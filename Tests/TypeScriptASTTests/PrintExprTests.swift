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

    func testNumberLiteral() throws {
        assertPrint(TSNumberLiteralExpr("0"), "0")
    }

    func testStringLiteral() throws {
        assertPrint(
            TSStringLiteralExpr("aaa"),
            """
            "aaa"
            """
        )
        assertPrint(
            TSStringLiteralExpr("a\nb"),
            #"""
            "a\nb"
            """#
        )
        assertPrint(
            TSStringLiteralExpr(#"a\b"#),
            #"""
            "a\\b"
            """#
        )
        assertPrint(
            TSStringLiteralExpr(#"a"b"#),
            #"""
            "a\"b"
            """#
        )
    }

    func testIdent() throws {
        assertPrint(TSIdentExpr.null, "null")
    }

    func testAs() throws {
        assertPrint(TSAsExpr(TSIdentExpr("a"), TSIdentType(name: "A")), "a as A")
    }

    func testInfixOperator() throws {
        assertPrint(
            TSInfixOperatorExpr(
                TSIdentExpr("a"), "+", TSIdentExpr("b")
            ),
            "a + b"
        )
    }

    func testParen() throws {
        assertPrint(TSParenExpr(TSIdentExpr("a")), "(a)")
    }

    func testPrefixOperator() throws {
        assertPrint(TSPrefixOperatorExpr("!", TSIdentExpr("a")), "! a")
    }

    func testCall() throws {
        assertPrint(TSCallExpr(callee: TSIdentExpr("f"), args: []), "f()")

        assertPrint(
            TSCallExpr(
                callee: TSIdentExpr("f"),
                args: [
                    TSIdentExpr("a"),
                    TSIdentExpr("b"),
                    TSIdentExpr("c"),
                    TSIdentExpr("d")
                ]
            ),
            """
            f(
                a,
                b,
                c,
                d
            )
            """)
    }

    func testNew() throws {
        assertPrint(TSNewExpr(callee: TSIdentType(name: "Error"), args: []), "new Error()")
    }
}
