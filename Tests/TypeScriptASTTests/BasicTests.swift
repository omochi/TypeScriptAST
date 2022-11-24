import XCTest
import TypeScriptAST

final class BasicTests: XCTestCase {
    func testAutoParent() throws {
        let b = TSIdentType.boolean
        let t = TSIdentType(
            name: "t",
            genericArgs: .init([b])
        )

        XCTAssertIdentical(b.parent, t)

        let n = TSIdentType.number
        t.genericArgs.append(n)
        XCTAssertIdentical(n.parent, t)

        let s = TSIdentType.string
        t.genericArgs[0] = s
        XCTAssertNil(b.parent)
        XCTAssertIdentical(s.parent, t)

        t.genericArgs = []
        XCTAssertNil(n.parent)
        XCTAssertNil(s.parent)
    }

    func testPrintType() throws {
        let atu = TSIdentType(
            name: "A",
            genericArgs: [TSIdentType(name: "T"), TSIdentType(name: "U")]
        )
        XCTAssertEqual(atu.print(), "A<T, U>")

        let na = TSArrayType(element: TSIdentType.number)
        XCTAssertEqual(na.print(), "number[]")

        
    }
}
