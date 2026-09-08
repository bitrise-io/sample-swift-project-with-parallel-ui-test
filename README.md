# Bitrise sample iOS app (Swift, with parallel UI tests)

A small Swift iOS app used as a fixture for testing Bitrise steps. The app itself is BullsEye, a
slider game from the [iOS Unit Testing and UI Testing Tutorial](https://www.raywenderlich.com/21020457-ios-unit-testing-and-ui-testing-tutorial).
Everything around it exists to give steps something specific to chew on.

## Project layout

- Swift app in an **`.xcworkspace`** wrapping a single `.xcodeproj` (`BullsEye.xcworkspace`).
- One **shared scheme**: `BullsEye`.
- Five targets:
  - `BullsEye` — the app (one screen: a slider, a segmented control to pick the game style, and a score).
  - `BullsEyeTests` — unit tests, including fake and mock variants, plus a Swift Testing
    (`import Testing`) suite alongside the XCTest ones.
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
- **Both test frameworks in one target.** `BullsEyeTests` mixes XCTest cases with a Swift Testing
  suite, so one run produces results from both.
- **A Swift Testing case with a display name.** `@Test("Score is computed when the guess matches
  the target")` reports that string as the test-case name instead of the function name.
- **A nested Swift Testing suite.** `TotalScore` sits inside `BullsEyeSwiftTestingTests`, so its
  tests are identified by the full suite path,
  `BullsEyeSwiftTestingTests/TotalScore/totalAddsUpTheRoundScores()`, and a filter that names only
  the outer suite does not match them.
- **Shared scheme and test plans.** All checked in, so a step can resolve them by name.
- **Automatic code signing.** The app target and all four test targets use Xcode's automatic
  (managed) signing.
- **Wide Xcode compatibility.** The 15.6 deployment target is low enough to build on older CI Xcode
  versions and still valid on the newest, so the same fixture compiles across the whole CI Xcode
  matrix.

## Changing the code signing team

Two build settings carry the team-specific values. Both are defined once, at project
level, so they can be overridden without editing the project:

| setting | default | what it is |
| --- | --- | --- |
| `DEVELOPMENT_TEAM` | `72SA8V3WYL` | the team that signs the build |
| `SAMPLE_BUNDLE_ID_BASE` | `io.bitrise.sample-apps-swift` | the base every target's bundle identifier is built from |

Change both. App IDs are unique across Apple Developer teams, so a different team
cannot register `io.bitrise.sample-apps-swift` and App Store Connect rejects it with a
409. Overriding `PRODUCT_BUNDLE_IDENTIFIER` directly does not work, because it is a
target-level setting and one override would give all five targets the same identifier.
Overriding the base instead moves all five together and keeps them distinct
(`…`, `….tests`, `….slowtests`, `….failingtests`, `….uitests`).

**For one build, from the command line:**

```
xcodebuild ... DEVELOPMENT_TEAM=YOURTEAM SAMPLE_BUNDLE_ID_BASE=com.example.sample
```

**For one build, from a Bitrise step**, using any step that takes `xcconfig_content`:

```yaml
- xcode-build-for-test:
    inputs:
    - xcconfig_content: |-
        DEVELOPMENT_TEAM = YOURTEAM
        SAMPLE_BUNDLE_ID_BASE = com.example.sample
```

Nothing else is team-specific: the identity is the generic `Apple Development`, no
provisioning profile is pinned, every target uses automatic signing, and there are no
entitlements files. Steps that manage code signing themselves take the team from the
Apple service connection and rewrite `DEVELOPMENT_TEAM` at build time, so with those
only the bundle ID base has to be set.

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

`run_tests` prepares signing assets with `manage-ios-code-signing`, then runs
`xcode-build-for-test` for a physical device, which is what exercises code signing of the test
targets, then runs `FullTests` and `ParallelUITests` on a simulator.

Signing is prepared as its own step rather than left to `xcode-build-for-test` so that xcodebuild
never runs with `-allowProvisioningUpdates`. All five bundle IDs match the team's
`io.bitrise.*` wildcard profile, so when xcodebuild is allowed to regenerate profiles during the
build, the app target and the UI test runner can end up pointing at different generations of that
one profile, and the file the runner was handed no longer exists when it is packaged.
