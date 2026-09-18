/// Copyright (c) 2021. Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import Testing
@testable import BullsEye

/// Makes a test case fail on its first attempt and pass afterwards, for as long as
/// `BULLSEYE_FLAKY_RUN_ID` keeps the same value. Without that variable nothing fails.
enum FlakyRun {
  static func succeedsThisAttempt(_ caseID: String) -> Bool {
    guard let runID = ProcessInfo.processInfo.environment["BULLSEYE_FLAKY_RUN_ID"], !runID.isEmpty else {
      return true
    }

    // The marker has to outlive the test process, which is relaunched between repetitions.
    let marker = (NSTemporaryDirectory() as NSString)
      .appendingPathComponent("bullseye-flaky-\(runID)-\(caseID)")
    if FileManager.default.fileExists(atPath: marker) {
      return true
    }

    FileManager.default.createFile(atPath: marker, contents: nil)
    return false
  }
}

struct BullsEyeSwiftTestingTests {
  @Test
  func scoreIsComputedWhenGuessIsHigherThanTarget() {
    let game = BullsEyeGame()
    game.check(guess: game.targetValue + 5)
    #expect(game.scoreRound == 95)
  }

  @Test
  func scoreIsComputedWhenGuessIsLowerThanTarget() {
    let game = BullsEyeGame()
    game.check(guess: game.targetValue - 5)
    #expect(game.scoreRound == 105)
  }

  @Test("Score is computed when the guess matches the target")
  func scoreIsComputedWhenGuessMatchesTarget() {
    let game = BullsEyeGame()
    game.check(guess: game.targetValue)
    #expect(game.scoreRound == 100)
  }

  @Test
  func scoreIsComputedEventually() {
    #expect(FlakyRun.succeedsThisAttempt("scoreIsComputedEventually"))
  }

  @Test("Score is eventually computed when the guess matches the target")
  func scoreIsEventuallyComputedWhenGuessMatchesTarget() {
    #expect(FlakyRun.succeedsThisAttempt("scoreIsEventuallyComputedWhenGuessMatchesTarget"))
  }

  @Suite
  struct TotalScore {
    @Test
    func totalAddsUpTheRoundScores() {
      let game = BullsEyeGame()
      game.check(guess: game.targetValue)
      game.check(guess: game.targetValue - 5)
      #expect(game.scoreTotal == 205)
    }

    @Test
    func newGameResetsTheTotal() {
      let game = BullsEyeGame()
      game.check(guess: game.targetValue)
      game.startNewGame()
      #expect(game.scoreTotal == 0)
    }

    @Test
    func totalIsAddedUpEventually() {
      #expect(FlakyRun.succeedsThisAttempt("totalIsAddedUpEventually"))
    }
  }
}
