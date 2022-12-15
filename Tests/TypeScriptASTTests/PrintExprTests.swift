import XCTest
import TypeScriptAST

final class PrintExprTests: TestCaseBase {
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

    func testTemplateLiteral() throws {
        assertPrint(
            TSTemplateLiteralExpr("string text \(TSIdentExpr("foo")) string text"),
            #"""
            `string text ${foo} string text`
            """#
        )

        assertPrint(
            TSTemplateLiteralExpr(tag: "css", "\(ident: "foo")string\(ident: "bar")"),
            #"""
            css`${foo}string${bar}`
            """#
        )
    }

    func testIdent() throws {
        assertPrint(TSIdentExpr.undefined, "undefined")
    }

    func testNull() throws {
        assertPrint(TSNullLiteralExpr(), "null")
    }

    func testBoolean() throws {
        assertPrint(TSBooleanLiteralExpr.true, "true")
        assertPrint(TSBooleanLiteralExpr.false, "false")
    }

    func testAs() throws {
        assertPrint(TSAsExpr(TSIdentExpr("a"), TSIdentType("A")), "a as A")
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
        assertPrint(TSNewExpr(callee: TSIdentType("Error"), args: []), "new Error()")
    }

    func testArray() throws {
        assertPrint(TSArrayExpr([]), "[]")

        assertPrint(
            TSArrayExpr([
                TSIdentExpr("a"),
                TSIdentExpr("b"),
                TSIdentExpr("c"),
                TSIdentExpr("d"),
            ]),
            """
            [
                a,
                b,
                c,
                d
            ]
            """
        )
    }

    func testObject() throws {
        assertPrint(TSObjectExpr([]), "{}")

        assertPrint(
            TSObjectExpr([
                .named(name: "a", value: TSBooleanLiteralExpr.true),
                .shorthandPropertyNames(value: TSIdentExpr("b")),
                .computedPropertyNames(name: TSInfixOperatorExpr(
                    TSIdentExpr("a"), "+", TSNumberLiteralExpr(42)
                ), value: TSBooleanLiteralExpr.true),
                .method(.init(name: "c", params: [], body: TSBlockStmt([]))),
                .destructuring(value: TSIdentExpr("d")),
                .named(name: "Content-Type", value: TSStringLiteralExpr("application/json")),
                .method(.init(name: "0f", params: [], body: TSBlockStmt([]))),
                .named(name: "", value: TSBooleanLiteralExpr.true),
            ]),
            """
            {
                a: true,
                b,
                [a + 42]: true,
                c() {},
                ...d,
                "Content-Type": "application/json",
                "0f"() {},
                "": true
            }
            """
        )
    }

    func testClosure() throws {
        assertPrint(
            TSClosureExpr(params: [], body: TSBooleanLiteralExpr.true),
            "() => true"
        )

        assertPrint(
            TSClosureExpr(hasParen: false, params: [.init(name: "x")], body: TSIdentExpr("x")),
            "x => x"
        )

        assertPrint(
            TSClosureExpr(
                params: [
                    .init(name: "a", type: TSIdentType("A")),
                    .init(name: "b", type: TSIdentType("B")),
                    .init(name: "c", type: TSIdentType("C")),
                    .init(name: "d", type: TSIdentType("D"))
                ],
                result: TSIdentType.boolean,
                body: TSBlockStmt([
                    TSReturnStmt(TSBooleanLiteralExpr.true)
                ])
            ),
            """
            (
                a: A,
                b: B,
                c: C,
                d: D
            ): boolean => {
                return true;
            }
            """
        )
    }

    func testCustom() throws {
        assertPrint(TSCustomExpr(text: "aaa"), "aaa")
    }

    func testAwait() throws {
        assertPrint(
            TSAwaitExpr(TSCallExpr(callee: TSIdentExpr("f"), args: [])),
            "await f()"
        )
    }

    func testPostfix() throws {
        assertPrint(
            TSPostfixOperatorExpr(TSIdentExpr("v"), "!"),
            "v !"
        )
    }

    func testMember() throws {
        assertPrint(
            TSMemberExpr(
                base: TSIdentExpr("A"),
                name: "B"
            ),
            "A.B"
        )

        assertPrint(
            TSMemberExpr(
                base: TSMemberExpr(
                    base: TSIdentExpr("A"),
                    name: "B"
                ),
                name: "C"
            ),
            "A.B.C"
        )

        assertPrint(
            TSMemberExpr(
                base: TSIdentExpr("A"),
                isOptional: true,
                name: "B"
            ),
            "A?.B"
        )
    }

    func testAssign() throws {
        assertPrint(
            TSAssignExpr(TSIdentExpr("x"), TSNumberLiteralExpr(0)),
            "x = 0"
        )

        assertPrint(
            TSFunctionDecl(name: "f", params: [], body: TSBlockStmt([
                TSAssignExpr(TSIdentExpr("x"), TSNumberLiteralExpr(0))
            ])),
            """
            function f() {
                x = 0;
            }
            """
        )
    }

    func testSubscript() throws {
        assertPrint(
            TSSubscriptExpr(base: TSIdentExpr("a"), key: TSIdentExpr("k")),
            "a[k]"
        )
    }

    func testTry() throws {
        assertPrint(
            TSTryStmt(
                body: TSBlockStmt([
                    TSReturnStmt(TSNumberLiteralExpr(1))
                ]),
                catch: TSCatchStmt(body: TSBlockStmt([
                    TSReturnStmt(TSNumberLiteralExpr(2))
                ]))
            ),
            """
            try {
                return 1;
            } catch {
                return 2;
            }
            """
        )

        assertPrint(
            TSTryStmt(
                body: TSBlockStmt([
                    TSReturnStmt(TSNumberLiteralExpr(1))
                ]),
                catch: TSCatchStmt(name: "e", body: TSBlockStmt([
                    TSReturnStmt(TSNumberLiteralExpr(2))
                ])),
                finally: TSFinallyStmt(body: TSBlockStmt([
                    TSReturnStmt(TSNumberLiteralExpr(3))
                ]))
            ), """
            try {
                return 1;
            } catch (e) {
                return 2;
            } finally {
                return 3;
            }
            """
        )
    }

    func testSwitch() throws {
        assertPrint(
            TSSwitchStmt(expr: TSIdentExpr("x")),
            """
            switch (x) {}
            """
        )

        assertPrint(
            TSSwitchStmt(
                expr: TSIdentExpr("x"),
                cases: [
                    TSCaseStmt(expr: TSNumberLiteralExpr(1), elements: [
                        TSReturnStmt(TSBooleanLiteralExpr.true)
                    ]),
                    TSDefaultStmt(elements: [
                        TSReturnStmt(TSBooleanLiteralExpr.false)
                    ])
                ]
            ),
            """
            switch (x) {
            case 1:
                return true;
            default:
                return false;
            }
            """)
    }
}
