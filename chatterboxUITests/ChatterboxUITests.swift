import XCTest

class ChatterboxUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testTextViewsAreAvailable() throws {
        app.launch()
        app.navigationBars.buttons.element(boundBy: 2).tap()

        let nameTextView = app.textViews["nameTextView"]
        let descriptionTextView = app.textViews["descriptionTextView"]

        XCTAssert(nameTextView.exists)
        XCTAssert(descriptionTextView.exists)
    }
}
