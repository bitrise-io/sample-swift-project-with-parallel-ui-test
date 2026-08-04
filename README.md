# Bitrise sample iOS app (Swift, with parallel UI tests)

A small Swift iOS app used as a fixture for testing Bitrise steps. The app itself is BullsEye, a
slider game from the [iOS Unit Testing and UI Testing Tutorial](https://www.raywenderlich.com/21020457-ios-unit-testing-and-ui-testing-tutorial).
Everything around it exists to give steps something specific to chew on.

## Project layout

- Swift app in an **`.xcworkspace`** wrapping a single `.xcodeproj` (`BullsEye.xcworkspace`).
- One **shared scheme**: `BullsEye`.
- Five targets:
  - `BullsEye` — the app (one screen: a slider, a segmented control to pick the game style, and a score).
  - `BullsEyeTests` — unit tests, including fake and mock variants.
  - `BullsEyeSlowTests` — a test that sleeps for a random 5-10 seconds.
  - `BullsEyeUITests` — UI tests. Two classes with the same test method name, so a result parser has
    to keep them apart.
  - `BullsEyeFailingTests` — tests that fail on purpose, plus the flaky-by-design cases below.
- iOS deployment target 15.6.

## Test plans

The scheme shares eight test plans. Which one you run decides what the fixture demonstrates.

| test plan | contents | what it is for |
| --- | --- | --- |
| `FullTests` | unit + slow + UI tests, `retryOnFailure` on | The default plan. Test retry across several bundles. |
| `UnitTests` | unit + slow tests | Unit tests only, no simulator UI. |
| `UITests` | UI tests, serial | Baseline to compare parallel runs against. |
| `ParallelUITests` | UI tests, `parallelizable` on | Parallel UI test execution across simulator clones. |
| `FailingTests` | one always-failing network test | A step's handling of a genuine test failure. |
| `EventuallySucceedingTests` | fails N times, then always passes | Test repetition that eventually goes green. |
| `EventuallyFailingTests` | passes N times, then always fails | Test repetition that eventually goes red. |
| `EventuallyFailingInMemoryTests` | same, but the counter lives in memory | The Xcode Test step's "relaunch tests for each repetition" input. Per-process state survives or resets depending on that setting. |

The eventually-passing and eventually-failing cases read their counters from `UserDefaults`, so you
set up a scenario by seeding those keys before the run.

## Features relevant for step testing

- **Workspace, not a bare project.** A step has to resolve the scheme through the `.xcworkspace`.
- **Multiple test bundles in one scheme.** Results come back from several targets at once.
- **Parallel UI test execution.** `ParallelUITests` fans the UI tests out over simulator clones, so
  a step sees results arriving from more than one destination.
- **Deliberately failing and flaky tests.** Separate plans produce a clean failure, a test that
  turns green on retry, and a test that turns red on retry.
- **Slow tests.** `BullsEyeSlowTests` makes a run long enough to exercise timeouts and progress
  reporting.
- **Duplicate test method names.** `BullsEyeUITests` and `BullsEyeUITests2` both define
  `testGameStyleSwitch()`, so a report has to key on the class, not just the method.
- **Shared scheme and test plans.** All checked in, so a step can resolve them by name.
- **Automatic code signing.** The app target and all four test targets use Xcode's automatic
  (managed) signing.
- **Wide Xcode compatibility.** The 15.6 deployment target is low enough to build on older CI Xcode
  versions and still valid on the newest, so the same fixture compiles across the whole CI Xcode
  matrix.

## CI

`bitrise.yml` defines a `pr_check` pipeline that runs on every pull request. It fans out into six
parallel workflows: tests and archive, each on three stacks.

| stack | why |
| --- | --- |
| `osx-xcode-16.0.x` | The lowest Xcode this fixture supports. Pinned, because it is the floor. |
| `osx-xcode-latest-stable` | Floating alias, so new stable Xcode releases are picked up without an edit here. |
| `osx-xcode-edge` | Floating alias onto Xcode betas. Breaks first, which is the point. |

Running all three ends of the range is what keeps the wide Xcode compatibility claim above honest.

The steps live in two step bundles, `run_tests` and `build_archive`, so each workflow is a stack
plus one bundle reference and a step change only has to be made once.

`run_tests` runs `xcode-build-for-test` for a physical device before testing, which is what
exercises automatic code signing of the test targets, then runs `FullTests` and `ParallelUITests`
on a simulator.
