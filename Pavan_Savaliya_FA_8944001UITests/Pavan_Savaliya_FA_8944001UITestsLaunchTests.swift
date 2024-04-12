//
//  Pavan_Savaliya_FA_8944001UITestsLaunchTests.swift
//  Pavan_Savaliya_FA_8944001UITests
//
//  Created by Pavan savaliya on 2024-04-12.
//

import XCTest

final class Pavan_Savaliya_FA_8944001UITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
