import XCTest
import TypeScriptAST

final class BasicTests: XCTestCase {
    func testAutoParent() throws {
        let b = TSNamedType.boolean
        let t = TSNamedType(
            name: "t",
            genericArgs: .init([b])
        )
        let args0 = t.genericArgs

        XCTAssertIdentical(args0.parent, t)
        XCTAssertIdentical(args0[safe: 0], b)
        XCTAssertIdentical(b.parent, args0)

        let n = TSNamedType.number
        t.genericArgs.elements.append(n)
        XCTAssertIdentical(n.parent, args0)

        let s = TSNamedType.string
        args0[1] = s
        XCTAssertNil(n.parent)
        XCTAssertIdentical(s.parent, args0)

        let args1 = TSGenericArgList()
        t.genericArgs = args1
        XCTAssertNil(args0.parent)
        XCTAssertIdentical(args1.parent, t)
    }
}
