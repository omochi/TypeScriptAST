import XCTest
import TypeScriptAST

class PrintTestsBase: XCTestCase {
    func assertPrint(
        _ node: any ASTNode,
        _ expected: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(node.print(), expected, file: file, line: line)
    }
}
