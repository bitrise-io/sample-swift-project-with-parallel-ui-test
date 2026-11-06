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

class BullsEyeUITests: XCTestCase {
  var app: XCUIApplication!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
    app = XCUIApplication()
    app.launch()
  }
  
  func testGameStyleSwitch() {
    // given
    let slideButton = app.segmentedControls.buttons["Slide"]
    let typeButton = app.segmentedControls.buttons["Type"]
    let slideLabel = app.staticTexts["Get as close as you can to: "]
    let typeLabel = app.staticTexts["Guess where the slider is: "]
    
    // then
    if slideButton.isSelected {
      XCTAssertTrue(slideLabel.exists)
      XCTAssertFalse(typeLabel.exists)

      typeButton.tap()
      XCTAssertTrue(typeLabel.exists)
      XCTAssertFalse(slideLabel.exists)
    } else if typeButton.isSelected {
      XCTAssertTrue(typeLabel.exists)
      XCTAssertFalse(slideLabel.exists)

      slideButton.tap()
      XCTAssertTrue(slideLabel.exists)
      XCTAssertFalse(typeLabel.exists)
    }
  }
}

class BullsEyeUITests2: XCTestCase {
  var app: XCUIApplication!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
    app = XCUIApplication()
    app.launch()
  }
  
  func testGameStyleSwitch() {
    // given
    let slideButton = app.segmentedControls.buttons["Slide"]
    let typeButton = app.segmentedControls.buttons["Type"]
    let slideLabel = app.staticTexts["Get as close as you can to: "]
    let typeLabel = app.staticTexts["Guess where the slider is: "]
    
    // then
    if slideButton.isSelected {
      XCTAssertTrue(slideLabel.exists)
      XCTAssertFalse(typeLabel.exists)

      typeButton.tap()
      XCTAssertTrue(typeLabel.exists)
      XCTAssertFalse(slideLabel.exists)
    } else if typeButton.isSelected {
      XCTAssertTrue(typeLabel.exists)
      XCTAssertFalse(slideLabel.exists)

      slideButton.tap()
      XCTAssertTrue(slideLabel.exists)
      XCTAssertFalse(typeLabel.exists)
    }
  }
}

/// Fails on the first launch of a run and passes afterwards, for as long as `BULLSEYE_FLAKY_RUN_ID`
/// keeps the same value. Without that variable nothing fails.
enum FlakyLaunch {
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

class BullsEyeLaunchTests: XCTestCase {
  override class var runsForEachTargetApplicationUIConfiguration: Bool {
    true
  }

  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
  }

  // XCTest does not tell a test which UI configuration it runs in, so only the configuration that
  // runs first fails, and only on its first attempt.
  func testLaunch() {
    let app = XCUIApplication()
    app.launch()

    XCTAssertTrue(app.segmentedControls.buttons["Slide"].exists)
    XCTAssertTrue(FlakyLaunch.succeedsThisAttempt("testLaunch"))
  }
}
