//
//  iOS_InternShip_ToDoListTests.swift
//  iOS-InternShip-ToDoListTests
//
//  Created by Дима on 4/14/25.
//

import XCTest
@testable import iOS_InternShip_ToDoList
final class iOS_InternShip_ToDoListTests: XCTestCase {
    var presenter: MainPagePresenter!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        let vc = MainPageViewController()
        presenter = MainPagePresenter(view: vc)
        vc.presenter = presenter
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        NotificationCenter.default.post(name: Notification.Name.loadData, object: nil)
        presenter.filterToDos(searchTerm: "Have")
        let filtered: [ToDo] = presenter.toDosToShow
        XCTAssertEqual(filtered.count, 3)
        XCTAssertEqual(filtered.first?.title, "Have a photo session with some friends")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
