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
    var database: Database!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        self.database = try Database.connect(location: .memory)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExecute() throws {
        let exp = expectation(description: "\(#function):\(#line)")

        database.execute("CREATE TABLE IF NOT EXISTS users ( id INTEGER PRIMARY KEY NOT NULL,name TEXT NOT NULL,email TEXT NOT NULL ) ;") { result in
            switch result {
            case .success:
                break
            case .failure(.exec(let code)):
                XCTFail("\(code)")
            case .failure(.open(let path)):
                XCTFail("\(path)")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }

    func testStatement() throws {
        let exp = expectation(description: "\(#function):\(#line)")

        database.execute("CREATE TABLE IF NOT EXISTS users ( id INTEGER PRIMARY KEY NOT NULL,name TEXT NOT NULL,email TEXT NOT NULL ) ;") { _ in
        }

        database.execute("PRAGMA table_info(users)") { result in

            switch result {
            case .success(let statement):
                for r in statement {
                    for v in r {
//                        r.get(Column<String>("abc")).get()
                        print(v)
                    }
                }
            case .failure(.exec(let code)):
                XCTFail("\(code)")
            case .failure(.open(let path)):
                XCTFail("\(path)")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)
    }
}
