import XCTest
import TypeScriptAST

final class UtilsTests: XCTestCase {
    func testReplaceExtension() throws {
        let work = URL(fileURLWithPath: "/work", isDirectory: true)

        do {
            let u = URLs.replacingPathExtension(of: URL(fileURLWithPath: "a.swift", relativeTo: work), to: "ts")
            XCTAssertEqual(u.relativePath, "a.ts")
            XCTAssertEqual(u.path, "/work/a.ts")
            XCTAssertEqual(u.baseURL?.path, "/work")
        }

        do {
            let u = URLs.replacingPathExtension(of: URL(fileURLWithPath: "dir/a.swift", relativeTo: work), to: "ts")
            XCTAssertEqual(u.relativePath, "dir/a.ts")
            XCTAssertEqual(u.path, "/work/dir/a.ts")
            XCTAssertEqual(u.baseURL?.path, "/work")
        }

        do {
            let u = URLs.replacingPathExtension(of: URL(fileURLWithPath: "../a.swift", relativeTo: work), to: "ts")
            XCTAssertEqual(u.relativePath, "../a.ts")
            XCTAssertEqual(u.path, "/a.ts")
            XCTAssertEqual(u.baseURL?.path, "/work")
        }

        do {
            let u = URLs.replacingPathExtension(of: URL(fileURLWithPath: "/work/a.swift"), to: "ts")
            XCTAssertEqual(u.relativePath, "/work/a.ts")
            XCTAssertEqual(u.path, "/work/a.ts")
            XCTAssertNil(u.baseURL)
        }

        do {
            let u = URLs.replacingPathExtension(of: URL(fileURLWithPath: "/work/dir/a.swift"), to: "ts")
            XCTAssertEqual(u.relativePath, "/work/dir/a.ts")
            XCTAssertEqual(u.path, "/work/dir/a.ts")
            XCTAssertNil(u.baseURL)
        }
    }
}
