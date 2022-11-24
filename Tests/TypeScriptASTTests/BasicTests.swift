import XCTest
import TypeScriptAST

final class BasicTests: XCTestCase {
    func testAutoParent() throws {
        let b = TSIdentType.boolean
        let t = TSIdentType(
            "t",
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
            "A",
            genericArgs: [TSIdentType("T"), TSIdentType("U")]
        )
        XCTAssertEqual(atu.print(), "A<T, U>")

        let na = TSArrayType(TSIdentType.number)
        XCTAssertEqual(na.print(), "number[]")

        
    }
}
