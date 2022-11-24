import XCTest
import TypeScriptAST

final class PrintExprTests: PrintTestsBase {
    func testReturn() throws {
        assertPrint(
            TSReturnStmt(TSNumberLiteralExpr("0")),
            "return 0;"
        )
    }

    func testThrow() throws {
        assertPrint(
            TSThrowStmt(TSNumberLiteralExpr("0")),
            "throw 0;"
        )
    }

    func testBlock() throws {
        assertPrint(
            TSBlockStmt([
                TSReturnStmt(TSNumberLiteralExpr("0"))
            ]),
            """
            {
                return 0;
            }
            """
        )
    }

    func testIf() throws {
        assertPrint(
            TSIfStmt(
                condition: TSNumberLiteralExpr("1"),
                then: TSReturnStmt(TSNumberLiteralExpr("2"))
            ),
            """
            if (1) return 2;
            """
        )

        assertPrint(
            TSIfStmt(
                condition: TSNumberLiteralExpr("1"),
                then: TSReturnStmt(TSNumberLiteralExpr("2")),
                else: TSReturnStmt(TSNumberLiteralExpr("3"))
            ),
            """
            if (1) return 2;
            else return 3;
            """
        )

        assertPrint(
            TSIfStmt(
                condition: TSNumberLiteralExpr("1"),
                then: TSReturnStmt(TSNumberLiteralExpr("2")),
                else: TSIfStmt(
                    condition: TSNumberLiteralExpr("3"),
                    then: TSReturnStmt(TSNumberLiteralExpr("4")),
                    else: TSReturnStmt(TSNumberLiteralExpr("5"))
                )
            ),
            """
            if (1) return 2;
            else if (3) return 4;
            else return 5;
            """
        )

        assertPrint(
            TSIfStmt(
                condition: TSNumberLiteralExpr("1"),
                then: TSBlockStmt([
                    TSReturnStmt(TSNumberLiteralExpr("2"))
                ]),
                else: TSBlockStmt([
                    TSReturnStmt(TSNumberLiteralExpr("3"))
                ])
            ),
            """
            if (1) {
                return 2;
            } else {
                return 3;
            }
            """
        )

        assertPrint(
            TSIfStmt(
                condition: TSNumberLiteralExpr("1"),
                then: TSBlockStmt([
                    TSReturnStmt(TSNumberLiteralExpr("2"))
                ]),
                else: TSIfStmt(
                    condition: TSNumberLiteralExpr("3"),
                    then: TSBlockStmt([
                        TSReturnStmt(TSNumberLiteralExpr("4"))
                    ]),
                    else: TSBlockStmt([
                        TSReturnStmt(TSNumberLiteralExpr("5"))
                    ])
                )
            ),
            """
            if (1) {
                return 2;
            } else if (3) {
                return 4;
            } else {
                return 5;
            }
            """
        )
    }

    func testForIn() throws {
        assertPrint(
            TSForInStmt(
                kind: .const,
                name: "i",
                operator: .in,
                expr: TSIdentExpr("array"),
                body: TSBlockStmt([
                    TSReturnStmt(TSNumberLiteralExpr("0"))
                ])
            ),
            """
            for (const i in array) {
                return 0;
            }
            """
        )
    }
}
