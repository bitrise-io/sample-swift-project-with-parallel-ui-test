import XCTest

/// Fails with the probability given by `BULLSEYE_RANDOM_FLAKY_PERCENT`, and passes when the variable
/// is unset. Every attempt draws again, with nothing carried over, which is the only flakiness a
/// cloud device can show: it reinstalls the app for each attempt, so no file, default or counter survives.
class BullsEyeRandomlyFailingTests: XCTestCase {
  func testPassesAtRandom() {
    let environment = ProcessInfo.processInfo.environment
    let failurePercent = environment["BULLSEYE_RANDOM_FLAKY_PERCENT"].flatMap(Int.init) ?? 0

    XCTAssertGreaterThan(
      Int.random(in: 1...100),
      failurePercent,
      "Failing on purpose, the draw came out under \(failurePercent)"
    )
  }
}
