//
//  toDoList__2023Tests.swift
//  toDoList--2023Tests
//
//  Created by Тимур Калимуллин on 10.06.2023.
//

import XCTest
@testable import toDoList__2023

final class toDoList__2023Tests: XCTestCase {
    
    var fileCache: FileCache!
    var item1: TodoItem!
    var item2: TodoItem!
    var fileNameJSON: String!
    var fileNameCVS: String!
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        fileCache = FileCache()
        item1 = TodoItem(id: "testId", text: "testText", importanceType: .reqular, flag: true)
        item2 = TodoItem(text: "testText", importanceType: .important, deadline: Date(timeIntervalSince1970: 1686836125), flag: true, creationDate: Date(timeIntervalSince1970: 77777), changeDate: Date(timeIntervalSince1970: 999999))
        fileNameJSON = "test.json"
        fileNameCVS = "test.cvs"
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        fileCache = nil
        item1 = nil
        item2 = nil
    }

    func testTodoItemField() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        XCTAssertEqual("testId", item1.getId())
        
        XCTAssertEqual("testText", item2.getText())
        XCTAssertEqual("important", item2.getImportanceTypeString())
        XCTAssertEqual(Date(timeIntervalSince1970: 1686836125), item2.getDeadline())
        XCTAssertEqual(true, item2.getFlag())
        XCTAssertEqual(Date(timeIntervalSince1970: 77777), item2.getCreationDate())
        XCTAssertEqual(Date(timeIntervalSince1970: 999999), item2.getChangeDate())
        
        
    }
    
    func testTodoItemParseJSON() throws {
        let trueExample: [String: Any] = [
            "id" : "testId",
            "text" : "testText",
            "flag": true,
            "creationDate": 11117556.8
        ]
        
        XCTAssertNotNil(TodoItem.parse(json: trueExample))

        let brokenExample: [String: Any] = [
            "id" : "testId",
            "flag": true,
            "creationDate": 11117556.8
        ]
        
        XCTAssertNil(TodoItem.parse(json: brokenExample))
        
    }
    
    func testTodoItemJSON() throws {
        let dict = item2.json as? [String: Any]
        if let dict = dict {
            XCTAssertEqual(dict.count, 7)
            XCTAssertEqual(dict["id"] as? String, item2.getId())
        }
    }
    
    func testTodoItemParseCSV() throws {
        let trueExample = "CF05CB51-29CA-4965-B96C-90395ACB896B,testText,important,1686836125.0,true,77777.0,999999.0"
        XCTAssertNotNil(TodoItem.parse(csv: trueExample))
        
        let brokenExample = "CF05CB51-29CA-4965-B96C-90395ACB896B,important,1686836125.0,true,77777.0,999999.0"
        XCTAssertNil(TodoItem.parse(csv: brokenExample))
        
    }
    
    func testTodoItemCSV() throws {
        let item1Data = item1.csv.components(separatedBy: ",")
        XCTAssertEqual(item1Data[0], "testId")
        XCTAssertEqual(item1Data[1], "testText")
    }
    
    func testFileCache() throws {
        fileCache.add(item: item1)
        fileCache.add(item: item2)
        XCTAssertEqual(fileCache.toDoItemDict.count, 2)
        
        let item3 = TodoItem(id: "testId", text: "sameID", importanceType: .reqular, flag: true)
        fileCache.add(item: item3)
        XCTAssertEqual(fileCache.toDoItemDict.count, 2)
        XCTAssertEqual(fileCache.toDoItemDict[item3.getId()]?.getText(), "sameID")
        
        fileCache.delete(item: item2)
        fileCache.delete(item: item3)
        XCTAssertEqual(fileCache.toDoItemDict.count, 0)
    }
    
    func testFileCacheJSON() throws {
        fileCache.add(item: item1)
        fileCache.add(item: item2)
        
        fileCache.saveJSON(fileName: fileNameJSON)
        
        var newFileCache = FileCache()
        newFileCache.loadJSON(fileName: fileNameJSON)
        
        XCTAssertEqual(newFileCache.toDoItemDict.count, 2)
        
        let checkText = newFileCache.toDoItemDict[item1.getId()]?.getText()
        XCTAssertEqual(item1.getText(), checkText)
    
    }
    
    func testFileCacheCSV() throws {
        fileCache.add(item: item1)
        fileCache.add(item: item2)
        
        fileCache.saveCVS(fileName: fileNameCVS)
        
        var newFileCache = FileCache()
        newFileCache.loadCVS(fileName: fileNameCVS)
        XCTAssertEqual(newFileCache.toDoItemDict.count, 2)
        
        let checkText = newFileCache.toDoItemDict[item1.getId()]?.getText()
        XCTAssertEqual(item1.getText(), checkText)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
