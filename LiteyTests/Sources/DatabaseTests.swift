//
//  DatabaseTests.swift
//  LiteyTests
//
//  Created by Yu Tawata on 2020/08/11.
//

import SQLite3
import XCTest
@testable import Litey

class DatabaseTests: XCTestCase {
    private var database: Database!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        var path = NSTemporaryDirectory()
        path.append("db.sqlite")

        self.database = try Database.connect(location: .path(path))
        try database.execute("DROP TABLE IF EXISTS users ;")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExecute() throws {
        do {
            try database.execute("""
                CREATE TABLE
                users ( id INTEGER PRIMARY KEY NOT NULL, name TEXT NOT NULL, email TEXT NOT NULL ) ;
                """
            )
        } catch {
            XCTFail("\(error)")
        }
    }

    func testPrepare() throws {
        try database.execute("""
            CREATE TABLE
            users ( id INTEGER PRIMARY KEY NOT NULL, name TEXT NOT NULL, email TEXT NOT NULL ) ;
            """
        )

        let expects: [(Int64, String, String, Int64, String?, Int64)] = [
            (0, "id", "INTEGER", 1, nil, 1),
            (1, "name", "TEXT", 1, nil, 0),
            (2, "email", "TEXT", 1, nil, 0),
        ]

        do {
            let statement = try database.prepare("PRAGMA table_info(users) ;")

            var flag = false
            for (row, expect) in zip(statement, expects) {
                flag = true
                XCTAssertEqual(row[0], expect.0)
                XCTAssertEqual(row[1], expect.1)
                XCTAssertEqual(row[2], expect.2)
                XCTAssertEqual(row[3], expect.3)
                XCTAssertEqual(row[4], expect.4)
                XCTAssertEqual(row[5], expect.5)
            }

            XCTAssertTrue(flag)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testSupportDataType() throws {
        try database.execute("""
            CREATE TABLE
            users ( id INTEGER PRIMARY KEY NOT NULL, name TEXT NOT NULL, email BLOB NOT NULL, bio TEXT ) ;
            """
        )
        try database.execute("""
            INSERT INTO
            users values ( 1, 'Yu Tawata', x'\(Data("yuta24@example.com".utf8).toHex())', NULL ) ;
            """
        )

        let expects: [(Int64, String, Data, String?)] = [
            (1, "Yu Tawata", Data("yuta24@example.com".utf8), nil),
        ]

        do {
            let statement = try database.prepare("SELECT * FROM users ;")

            var flag = false
            for (row, expect) in zip(statement, expects) {
                flag = true
                XCTAssertEqual(row[0], expect.0)
                XCTAssertEqual(row[1], expect.1)
                XCTAssertEqual(row[2], expect.2)
                XCTAssertEqual(row[3], expect.3)
            }

            XCTAssertTrue(flag)
        } catch {
            XCTFail("\(error)")
        }
    }
}
