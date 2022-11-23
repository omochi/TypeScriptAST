import XCTest
import TypeScriptAST

final class BasicTests: XCTestCase {
    func testAutoParent() throws {
        let b = TSNamedType.boolean
        let t = TSNamedType(
            name: "t",
            genericArgs: .init([b])
        )

        XCTAssertIdentical(b.parent, t)

        let n = TSNamedType.number
        t.genericArgs.append(n)
        XCTAssertIdentical(n.parent, t)

        let s = TSNamedType.string
        t.genericArgs[0] = s
        XCTAssertNil(b.parent)
        XCTAssertIdentical(s.parent, t)

        t.genericArgs = []
        XCTAssertNil(n.parent)
        XCTAssertNil(s.parent)
    }

    func testPrintType() throws {
        let atu = TSNamedType(
            name: "A",
            genericArgs: [TSNamedType(name: "T"), TSNamedType(name: "U")]
        )
        XCTAssertEqual(atu.print(), "A<T, U>")

        let na = TSArrayType(element: TSNamedType.number)
        XCTAssertEqual(na.print(), "number[]")

        
    }
}
