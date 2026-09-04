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

import Testing
@testable import BullsEye

/// Unit tests written with the Swift Testing framework, so the fixture has tests a
/// step can exercise against the Swift Testing runner. `-skip-testing` only accepts
/// these with the `()` suffix on the function name, and one case here carries a
/// display name, whose reported test-case name is not the function name at all.
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

  /// The display name is what shows up as the test-case name in the results, so the
  /// function name can only be recovered from the test identifier.
  @Test("Score is computed when the guess matches the target")
  func scoreIsComputedWhenGuessMatchesTarget() {
    let game = BullsEyeGame()
    game.check(guess: game.targetValue)
    #expect(game.scoreRound == 100)
  }
}
