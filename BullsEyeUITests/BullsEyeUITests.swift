/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import XCTest

class BullsEyeUITests: XCTestCase {
  var app: XCUIApplication!
  
  override func setUp() {
    super.setUp()
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    app = XCUIApplication()
    app.launch()
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
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
    
    
    
    func testCase(){
        let app = XCUIApplication()
        app.otherElements.containing(.button, identifier:"hit me!").element.swipeLeft()
        
        let slideButton = app/*@START_MENU_TOKEN@*/.buttons["Slide"]/*[[".segmentedControls.buttons[\"Slide\"]",".buttons[\"Slide\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        slideButton.tap()
        
        let typeButton = app/*@START_MENU_TOKEN@*/.buttons["Type"]/*[[".segmentedControls.buttons[\"Type\"]",".buttons[\"Type\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        typeButton.tap()
        
        let hitMeButton = app.buttons["hit me!"]
        hitMeButton.tap()
        
        let okButton = app.alerts["Not A Number"].buttons["OK"]
        okButton.tap()
        hitMeButton.tap()
        okButton.tap()
        
        app.buttons["start over"].tap()
        slideButton.tap()
        typeButton.tap()
        slideButton.tap()
        typeButton.tap()
        slideButton.tap()
        hitMeButton.tap()
        app.alerts.firstMatch.buttons["OK"].tap()
        hitMeButton.tap()
        app.alerts.firstMatch.buttons["OK"].tap()
        hitMeButton.tap()
        app.alerts.firstMatch.buttons["OK"].tap()
    }
    
    func testScreenshot() {
        XCTContext.runActivity(named: "screenshot", block: { activity in
            let mainScreenScreenshot = XCUIScreen.main.screenshot()
            let attachement  = XCTAttachment.init(screenshot: mainScreenScreenshot)
            attachement.lifetime = XCTAttachment.Lifetime.keepAlways
            activity.add(attachement)
        })
    }
  
}


class BullsEyeUITests_2: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
    
    
    
    func testCase(){
        let app = XCUIApplication()
        app.otherElements.containing(.button, identifier:"hit me!").element.swipeLeft()
        
        let slideButton = app/*@START_MENU_TOKEN@*/.buttons["Slide"]/*[[".segmentedControls.buttons[\"Slide\"]",".buttons[\"Slide\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        slideButton.tap()
        
        let typeButton = app/*@START_MENU_TOKEN@*/.buttons["Type"]/*[[".segmentedControls.buttons[\"Type\"]",".buttons[\"Type\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        typeButton.tap()
        
        let hitMeButton = app.buttons["hit me!"]
        hitMeButton.tap()
        
        let okButton = app.alerts["Not A Number"].buttons["OK"]
        okButton.tap()
        hitMeButton.tap()
        okButton.tap()
        
        app.buttons["start over"].tap()
        slideButton.tap()
        typeButton.tap()
        slideButton.tap()
        typeButton.tap()
        slideButton.tap()
        hitMeButton.tap()
        app.alerts.firstMatch.buttons["OK"].tap()
        hitMeButton.tap()
        app.alerts.firstMatch.buttons["OK"].tap()
        hitMeButton.tap()
        app.alerts.firstMatch.buttons["OK"].tap()
    }
    
    func testScreenshot() {
        XCTContext.runActivity(named: "screenshot", block: { activity in
            let mainScreenScreenshot = XCUIScreen.main.screenshot()
            let attachement  = XCTAttachment.init(screenshot: mainScreenScreenshot)
            attachement.lifetime = XCTAttachment.Lifetime.keepAlways
            activity.add(attachement)
        })
    }
    
}
