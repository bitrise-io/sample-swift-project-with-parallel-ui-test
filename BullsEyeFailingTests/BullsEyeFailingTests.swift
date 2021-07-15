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

import XCTest
@testable import BullsEye

class BullsEyeFailingTests: XCTestCase {
  
  var sut: URLSession!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = URLSession(configuration: .default)
  }
  
  override func tearDownWithError() throws {
    sut = nil
    try super.tearDownWithError()
  }
  
  
  func testApiCallCompletes() throws {
    // given
    let urlString = "http://www.randomnumberapi.com/fail"
    let url = URL(string: urlString)!
    let promise = expectation(description: "Completion handler invoked")
    var statusCode: Int?
    var responseError: Error?
    
    // when
    let dataTask = sut.dataTask(with: url) { _, response, error in
      statusCode = (response as? HTTPURLResponse)?.statusCode
      responseError = error
      promise.fulfill()
    }
    dataTask.resume()
    wait(for: [promise], timeout: 5)
    
    // then
    XCTAssertNil(responseError)
    XCTAssertEqual(statusCode, 200)
  }
}

// A test case that initially fails a predefined number of times then always succeeds.
// The number of remaining failures is stored in UserDefaults, which is decremented each time the test is executed until it reaches 0.
// After that, the test will always succeed.
// Useful for testing Test Repetition in the Xcode Test step.
class BullsEyeEventuallySucceedingTests: XCTestCase {
  private static let numberOfFailuresKey = "eventually_succeeding_test_number_of_failures"
  
  func testPassIfNoFailuresRemain() {
    let numberOfRemainingFailures = UserDefaults.standard.integer(forKey: BullsEyeEventuallySucceedingTests.numberOfFailuresKey)
    
    if numberOfRemainingFailures > 0 {
      UserDefaults.standard.set(numberOfRemainingFailures - 1, forKey: BullsEyeEventuallySucceedingTests.numberOfFailuresKey)
      XCTFail()
    }
  }
}

// A test case that initially succeeds a predefined number of times then always fails.
// The number of remaining successes is stored in UserDefaults, which is decremented each time the test is executed until it reaches 0.
// After that, the test will always fail.
// Useful for testing Test Repetition in the Xcode Test step.
class BullsEyeEventuallyFailingTests: XCTestCase {
  private static let numberOfSuccessesKey = "eventually_failing_test_number_of_successes"
  
  func testFailIfNoSuccessesRemain() {
    let numberOfRemainingSuccesses = UserDefaults.standard.integer(forKey: BullsEyeEventuallyFailingTests.numberOfSuccessesKey)
    
    if numberOfRemainingSuccesses > 0 {
      UserDefaults.standard.set(numberOfRemainingSuccesses - 1, forKey: BullsEyeEventuallyFailingTests.numberOfSuccessesKey)
    } else {
      XCTFail()
    }
  }
}

// A test case that initially succeeds a predefined number of times then always succeeds.
// The number of remaining successes is initialized from UserDefaults then stored in memory.
// This number is decremented each time a test is executed until it reaches 0. After that, the test will always fail.
// Can be used to test "Relaunch Tests for Each Repetition" input of the Xcode Test step:
// - If each test is executed in a new process, then the number of successes is always reset to the value in UserDefaults - therefore tests will never fail (assuming this number is >0).
// - If tests are executed in the same process, the number of successes has a chance to reach 0 - hence tests will eventually fail.
class BullsEyeEventuallyFailingInMemoryTests: XCTestCase {
  private static let numberOfSuccessesKey = "eventually_failing_test_number_of_successes"
  private static var numberOfRemainingSuccesses = UserDefaults.standard.integer(forKey: BullsEyeEventuallyFailingInMemoryTests.numberOfSuccessesKey)
  
  func testFailIfNoSuccessesRemain() {
    if BullsEyeEventuallyFailingInMemoryTests.numberOfRemainingSuccesses > 0 {
      BullsEyeEventuallyFailingInMemoryTests.numberOfRemainingSuccesses -= 1
    } else {
      XCTFail()
    }
  }
}
