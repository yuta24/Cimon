//
//  TableTests.swift
//  LiteyTests
//
//  Created by Yu Tawata on 2020/08/15.
//

import XCTest
@testable import Litey

class TableTests: XCTestCase {
    private var database: Database!
    private let table = Table<User>("users")

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        var path = NSTemporaryDirectory()
        path.append("db.sqlite")

        self.database = try Database.connect(location: .path(path))
        try database.execute("DROP TABLE IF EXISTS \(table.name) ;")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try database.execute("DROP TABLE IF EXISTS \(table.name) ;")
    }

    func testCreateThenExecute() throws {
        try table.create()
            .execute(on: database)

        let expects: [(Int64, String, String, Int64, String?, Int64)] = [
            (0, "id", "INTEGER", 1, nil, 1),
            (1, "name", "TEXT", 1, nil, 0),
            (2, "email", "TEXT", 1, nil, 0),
            (3, "country", "TEXT", 1, nil, 0),
            (4, "bio", "TEXT", 0, nil, 0),
        ]

        do {
            let statement = try database.prepare("PRAGMA table_info(\(table.name)) ;")

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

    func testDropThenQuery() throws {
        let queryString = table.drop()
            .build()

        let expect = "DROP TABLE \(table.name) ;"

        XCTAssertEqual(queryString, expect)
    }

    func testDropThenExecute() throws {
        try table.create()
            .execute(on: database)

        do {
            try table.drop()
                .execute(on: database)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testInsertThenQuery() throws {
        let queryString = table.insert()
            .value(1, for: \.id)
            .value("Yu Tawata", for: \.name)
            .value("yuta24@example.com", for: \.email)
            .value("Japan", for: \.country)
            .value(nil, for: \.bio)
            .build()

        let expect = "INSERT INTO \(table.name) ( id, name, email, country, bio ) VALUES ( 1, \"Yu Tawata\", \"yuta24@example.com\", \"Japan\", NULL ) ;"

        XCTAssertEqual(queryString, expect)
    }

    func testInsertThenExecute() throws {
        try table.create()
            .execute(on: database)

        do {
            try table.insert()
                .value(1, for: \.id)
                .value("Yu Tawata", for: \.name)
                .value("yuta24@example.com", for: \.email)
                .value("Japan", for: \.country)
                .value(nil, for: \.bio)
                .execute(on: database)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testFetchThenQuery() throws {
        try table.create()
            .execute(on: database)

        let queryString = table.fetch()
            .filter("name = yuta24")
            .orderby("id")
            .limit(50, offset: 10)
            .build()

        let expect = "SELECT * FROM users WHERE name = yuta24 ORDER BY id LIMIT 50 OFFSET 10 ;"

        XCTAssertEqual(queryString, expect)
    }

    func testUpdateThenQuery() throws {
        let queryString = table.update()
            .setValue(1, for: \.id)
            .setValue("Yu Tawata", for: \.name)
            .setValue("yuta24@example.com", for: \.email)
            .setValue("Japan", for: \.country)
            .setValue(nil, for: \.bio)
            .build()

        let expect = "UPDATE \(table.name) SET id = 1, name = \"Yu Tawata\", email = \"yuta24@example.com\", country = \"Japan\", bio = NULL ;"

        XCTAssertEqual(queryString, expect)
    }

    func testDeleteThenQuery() throws {
        try table.create()
            .execute(on: database)

        let queryString = table.delete()
            .where("name = \"Yu Tawata\"")
            .build()

        let expect = "DELETE FROM \(table.name) WHERE name = \"Yu Tawata\" ;"

        XCTAssertEqual(queryString, expect)
    }

}
