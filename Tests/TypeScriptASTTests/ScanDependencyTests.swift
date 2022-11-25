import XCTest
import TypeScriptAST

final class ScanDependencyTests: PrintTestsBase {
    func testUseValue() throws {
        let s = TSSourceFile([
            TSVarDecl(kind: .const, name: "a", initializer: TSNumberLiteralExpr(1)),
            TSFunctionDecl(name: "f", params: [.init(name: "b")], body: TSBlockStmt([
                TSReturnStmt(
                    TSInfixOperatorExpr(
                        TSInfixOperatorExpr(
                            TSInfixOperatorExpr(
                                TSInfixOperatorExpr(
                                    TSIdentExpr("a"), "+", TSIdentExpr("b")
                                ), "+", TSIdentExpr("c")
                            ), "+", TSCallExpr(
                                callee: TSIdentExpr("f"),
                                args: [TSNumberLiteralExpr(2)]
                            )
                        ), "+", TSCallExpr(
                            callee: TSIdentExpr("g"),
                            args: [TSNumberLiteralExpr(3)]
                        )
                    )
                )
            ]))
        ])

        assertPrint(
            s, """
            const a = 1;

            function f(b) {
                return a + b + c + f(2) + g(3);
            }

            """
        )

        XCTAssertEqual(Set(s.memberDeclaredNames), ["a", "f"])
        XCTAssertEqual(Set(s.scanDependency()), ["c", "g"])
    }

    func testUseType() throws {
        let s = TSSourceFile([
            TSTypeDecl(name: "S", genericParams: ["T"], type: TSObjectType([
                .init(name: "a", type: TSIdentType.string),
                .init(name: "b", type: TSIdentType("T")),
                .init(name: "c", type: TSIdentType("X"))
            ])),
            TSFunctionDecl(
                name: "f", genericParams: ["T", "U"],
                params: [
                    .init(name: "t", type: TSIdentType("T")),
                    .init(name: "u", type: TSIdentType("U")),
                    .init(name: "v", type: TSIdentType("V"))
                ],
                result: TSIdentType("S", genericArgs: [TSIdentType("T")]),
                body: TSBlockStmt([
                    TSReturnStmt(
                        TSObjectExpr([
                            .init(name: "a", value: TSStringLiteralExpr("a")),
                            .init(name: "b", value: TSIdentExpr("t")),
                            .init(name: "c", value: TSCallExpr(
                                callee: TSIdentExpr("g"), args: [])
                            )
                        ])
                    )
                ])
            )
        ])

        assertPrint(
            s, """
            type S<T> = {
                a: string;
                b: T;
                c: X;
            };

            function f<T, U>(t: T, u: U, v: V): S<T> {
                return {
                    a: "a",
                    b: t,
                    c: g()
                };
            }

            """
        )

        XCTAssertEqual(Set(s.memberDeclaredNames), ["S", "f"])
        XCTAssertEqual(Set(s.scanDependency()), ["string", "X", "V", "g"])
    }

    func testClassName() throws {
        let s = TSSourceFile([
            TSInterfaceDecl(name: "I", block: TSBlockStmt([
                TSMethodDecl(name: "f", params: [], result: TSIdentType.void)
            ])),
            TSClassDecl(
                name: "K", genericParams: ["T"], extends: TSIdentType("M"),
                implements: [TSIdentType("I"), TSIdentType("J")],
                block: TSBlockStmt([
                    TSFieldDecl(name: "t", isOptional: true, type: TSIdentType("T")),
                    TSFieldDecl(name: "x", isOptional: true, type: TSIdentType("X")),
                    TSMethodDecl(name: "f", params: [], block: TSBlockStmt([
                        TSReturnStmt(
                            TSPostfixOperatorExpr(
                                TSMemberExpr(
                                    base: TSIdentExpr.this,
                                    name: "t"
                                ), "!"
                            )
                        )
                    ]))
                ])
            )
        ])

        assertPrint(
            s, """
            interface I {
                f(): void;
            }

            class K<T> extends M implements I, J {
                t?: T;
                x?: X;

                f() {
                    return this.t !;
                }
            }
            
            """
        )

        XCTAssertEqual(Set(s.memberDeclaredNames), ["I", "K"])
        XCTAssertEqual(Set(s.scanDependency()), ["void", "M", "J", "X", "this"])
    }
}
