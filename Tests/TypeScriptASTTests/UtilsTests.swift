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

    func testPathPrefixReplace() throws {
        let args: [(from: String, to: String, input: String, expect: String?, line: UInt)] = [
            // full to full
            ("/usr", "/foo", "/usr/lib", "/foo/lib", #line),
            // full to rel
            ("/usr", "foo", "/usr/lib", "foo/lib", #line),
            ("/usr", "../foo", "/usr/lib", "../foo/lib", #line),
            // rel to full
            ("usr", "/foo", "usr/lib", "/foo/lib", #line),
            ("../usr", "/foo", "../usr/lib", "/foo/lib", #line),
            // rel to rel
            ("usr", "foo", "usr/lib", "foo/lib", #line),
            ("../usr", "foo", "../usr/lib", "foo/lib", #line),
            // slash
            ("/usr", "/foo", "/usr2/lib", nil, #line),
        ]

        for arg in args {
            let replacement = PathPrefixReplacement(
                path: URL(fileURLWithPath: arg.from), replacement: arg.to
            )
            let input = URL(fileURLWithPath: arg.input)
            let expect = arg.expect.map { URL(fileURLWithPath: $0) }

            let actual = replacement.replace(path: input)

            XCTAssertEqual(actual, expect, file: #file, line: arg.line)
        }
    }
}
