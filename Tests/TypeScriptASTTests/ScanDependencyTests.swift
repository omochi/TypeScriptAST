import XCTest
import TypeScriptAST

final class ScanDependencyTests: TestCaseBase {
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
                            .named(name: "a", value: TSStringLiteralExpr("a")),
                            .named(name: "b", value: TSIdentExpr("t")),
                            .named(name: "c", value: TSCallExpr(
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
            TSInterfaceDecl(name: "I", body: TSBlockStmt([
                TSMethodDecl(name: "f", params: [], result: TSIdentType.void)
            ])),
            TSClassDecl(
                name: "K", genericParams: ["T"], extends: TSIdentType("M"),
                implements: [TSIdentType("I"), TSIdentType("J")],
                body: TSBlockStmt([
                    TSFieldDecl(name: "t", isOptional: true, type: TSIdentType("T")),
                    TSFieldDecl(name: "x", isOptional: true, type: TSIdentType("X")),
                    TSMethodDecl(name: "f", params: [], body: TSBlockStmt([
                        TSReturnStmt(
                            TSPostfixOperatorExpr(
                                TSMemberExpr(
                                    base: TSIdentExpr.this,
                                    name: TSIdentExpr("t")
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

    func testCustomNode() throws {
        let s = TSSourceFile([
            TSFunctionDecl(
                name: "f",
                params: [.init(name: "x", type: TSCustomType(text: "A[]", dependencies: ["A"]))],
                body: TSBlockStmt([
                    TSReturnStmt(
                        TSCustomExpr(text: "g(x)", dependencies: ["g"])
                    )
                ])
            )
        ])

        assertPrint(
            s, """
            function f(x: A[]) {
                return g(x);
            }

            """
        )

        XCTAssertEqual(Set(s.memberDeclaredNames), ["f"])
        XCTAssertEqual(Set(s.scanDependency()), ["A", "g"])
    }

    func testStruct() throws {
        let s = TSSourceFile([
            TSTypeDecl(
                name: "X", genericParams: ["T"],
                type: TSObjectType([])
            ),
            TSTypeDecl(
                name: "S", genericParams: ["T", "U"],
                type: TSObjectType([
                    .init(name: "a", isOptional: true, type: TSIdentType("A")),
                    .init(name: "b", type: TSIdentType("number")),
                    .init(name: "c", type: TSArrayType(TSIdentType("C"))),
                    .init(name: "d", type: TSIdentType("T")),
                    .init(name: "e", type: TSIdentType("X", genericArgs: [TSIdentType("E")])),
                    .init(name: "f", type: TSIdentType("X", genericArgs: [TSIdentType("U")])),
                    .init(name: "g", type: TSIdentType("Y", genericArgs: [TSIdentType("G")])),
                    .init(name: "h", type: TSIdentType("Y", genericArgs: [TSIdentType("U")])),
                ])
            )
        ])

        assertPrint(
            s, """
            type X<T> = {};

            type S<T, U> = {
                a?: A;
                b: number;
                c: C[];
                d: T;
                e: X<E>;
                f: X<U>;
                g: Y<G>;
                h: Y<U>;
            };

            """
        )

        XCTAssertEqual(Set(s.memberDeclaredNames), ["X", "S"])
        XCTAssertEqual(Set(s.scanDependency()), ["A", "C", "E", "G", "Y", "number"])
    }

    func testInterface() throws {
        let s = TSSourceFile([
            TSInterfaceDecl(
                name: "I", genericParams: ["T"], extends: [TSIdentType("J")],
                body: TSBlockStmt([
                    TSMethodDecl(
                        name: "foo", genericParams: ["U"],
                        params: [
                            .init(name: "a", type: TSIdentType("A")),
                            .init(name: "t", type: TSIdentType("T")),
                            .init(name: "u", type: TSIdentType("U"))
                        ],
                        result: TSIdentType("B")
                    )
                ])
            )
        ])

        assertPrint(
            s, """
            interface I<T> extends J {
                foo<U>(a: A, t: T, u: U): B;
            }

            """
        )

        XCTAssertEqual(Set(s.memberDeclaredNames), ["I"])
        XCTAssertEqual(Set(s.scanDependency()), ["A", "B", "J"])
    }

    func testClass() throws {
        let s = TSSourceFile([
            TSClassDecl(
                name: "C", genericParams: ["T"],
                extends: TSIdentType("D"), implements: [TSIdentType("I")],
                body: TSBlockStmt([
                    TSMethodDecl(
                        name: "foo", genericParams: ["U"],
                        params: [
                            .init(name: "a", type: TSIdentType("A")),
                            .init(name: "t", type: TSIdentType("T")),
                            .init(name: "u", type: TSIdentType("U"))
                        ],
                        result: TSIdentType("B"),
                        body: TSBlockStmt([
                            TSReturnStmt(
                                TSInfixOperatorExpr(
                                    TSInfixOperatorExpr(
                                        TSIdentExpr("a"), "+",
                                        TSIdentExpr("b")
                                    ), "+",
                                    TSIdentExpr("t")
                                )
                            )
                        ])
                    )
                ])
            )
        ])

        assertPrint(
            s, """
            class C<T> extends D implements I {
                foo<U>(a: A, t: T, u: U): B {
                    return a + b + t;
                }
            }

            """
        )

        XCTAssertEqual(Set(s.memberDeclaredNames), ["C"])
        XCTAssertEqual(Set(s.scanDependency()), ["A", "B", "D", "I", "b"])
    }

    func testCatch() {
        let s = TSSourceFile([
            TSTryStmt(
                body: TSBlockStmt([
                    TSReturnStmt()
                ]),
                catch: TSCatchStmt(name: TSIdentExpr("e"), body: TSBlockStmt([
                    TSReturnStmt(TSIdentExpr("e"))
                ]))
            )
        ])

        assertPrint(
            s, """
            try {
                return;
            } catch (e) {
                return e;
            }

            """
        )

        XCTAssertEqual(Set(s.scanDependency()), [])
    }

    func testSwitch() {
        let s = TSSourceFile([
            TSSwitchStmt(expr: TSIdentExpr("x"), cases: [
                TSCaseStmt(expr: TSIdentExpr("y"), elements: [
                    TSVarDecl(kind: .const, name: "a", initializer: TSNumberLiteralExpr(1)),
                    TSReturnStmt(TSIdentExpr("a"))
                ]),
                TSDefaultStmt(elements: [
                    TSReturnStmt(TSIdentExpr("b"))
                ])
            ])
        ])

        assertPrint(
            s, """
            switch (x) {
            case y:
                const a = 1;
                return a;
            default:
                return b;
            }

            """
        )

        XCTAssertEqual(Set(s.scanDependency()), ["x", "y", "b"])
    }

    func testTemplateLiteral() {
        let s = TSSourceFile([
            TSVarDecl(kind: .const, name: "a", initializer: TSNumberLiteralExpr(1)),
            TSVarDecl(kind: .const, name: "c", initializer: TSTemplateLiteralExpr("\(ident: "a"), \(ident: "b")")),
        ])

        assertPrint(
            s, """
            const a = 1;

            const c = `${a}, ${b}`;

            """
        )

        XCTAssertEqual(Set(s.scanDependency()), ["b"])
    }
}
