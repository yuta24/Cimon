//
//  QueryTests.swift
//  LiteyTests
//
//  Created by Yu Tawata on 2020/08/11.
//

import XCTest
@testable import Litey

class QueryTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreate() throws {
        XCTContext.runActivity(named: "default") { _ in
            let query = Query.create(tableName: "users", columns: { b in
                b.column(name: "id", type: Int64.self, primaryKey: .default)
                b.column(name: "name", type: String.self, notNull: true)
                b.column(name: "email", type: String.self, notNull: true)
            })

            let rawString = "CREATE TABLE users ( id INTEGER PRIMARY KEY NOT NULL, name TEXT NOT NULL, email TEXT NOT NULL ) ;"

            XCTAssertEqual(query.rawString, rawString)
        }

        XCTContext.runActivity(named: "if not exists") { _ in
            let query = Query.create(ifNotExists: true, tableName: "users", columns: { b in
                b.column(name: "id", type: Int64.self, primaryKey: .default)
                b.column(name: "name", type: String.self, notNull: true)
                b.column(name: "email", type: String.self, notNull: true)
            })

            let rawString = "CREATE TABLE IF NOT EXISTS users ( id INTEGER PRIMARY KEY NOT NULL, name TEXT NOT NULL, email TEXT NOT NULL ) ;"

            XCTAssertEqual(query.rawString, rawString)
        }

        XCTContext.runActivity(named: "without rowid") { _ in
            let query = Query.create(tableName: "users", columns: { b in
                b.column(name: "id", type: Int64.self, primaryKey: .default)
                b.column(name: "name", type: String.self, notNull: true)
                b.column(name: "email", type: String.self, notNull: true)
            }, withoutRowid: true)

            let rawString = "CREATE TABLE users ( id INTEGER PRIMARY KEY NOT NULL, name TEXT NOT NULL, email TEXT NOT NULL ) WITHOUT ROWID ;"

            XCTAssertEqual(query.rawString, rawString)
        }
    }

    func testDrop() throws {
        XCTContext.runActivity(named: "default") { _ in
            let query = Query.drop(tableName: "users")

            let rawString = "DROP TABLE IF EXISTS users ;"

            XCTAssertEqual(query.rawString, rawString)
        }

        XCTContext.runActivity(named: "if not exists") { _ in
            let query = Query.drop(ifExists: false, tableName: "users")

            let rawString = "DROP TABLE users ;"

            XCTAssertEqual(query.rawString, rawString)
        }
    }

    func testPragma() throws {
        XCTContext.runActivity(named: "table_info") { activity in
            let query = Query.pragma(.tableInfo(tableName: "users"))

            let rawString = "PRAGMA table_info(users) ;"

            XCTAssertEqual(query.rawString, rawString)
        }
    }

    func testSelect() throws {
        XCTContext.runActivity(named: "fetch all") { _ in
            let query = Query.select(columns: .all, from: "users")

            let rawString = "SELECT * FROM users ;"

            XCTAssertEqual(query.rawString, rawString)
        }

        XCTContext.runActivity(named: "fetch distinct") { _ in
            let query = Query.select(distinct: true, columns: .all, from: "users")

            let rawString = "SELECT DISTINCT * FROM users ;"

            XCTAssertEqual(query.rawString, rawString)
        }
    }

}
