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
            TSTypeDecl(name: "S", genericParams: [.init("T")], type: TSObjectType([
                .field(.init(name: "a", type: TSIdentType.string)),
                .field(.init(name: "b", type: TSIdentType("T"))),
                .field(.init(name: "c", type: TSIdentType("X"))),
            ])),
            TSFunctionDecl(
                name: "f", genericParams: [.init("T"), .init("U")],
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
                name: "K", genericParams: [.init("T")], extends: TSIdentType("M"),
                implements: [TSIdentType("I"), TSIdentType("J")],
                body: TSBlockStmt([
                    TSFieldDecl(name: "t", isOptional: true, type: TSIdentType("T")),
                    TSFieldDecl(name: "x", isOptional: true, type: TSIdentType("X")),
                    TSMethodDecl(name: "f", params: [], body: TSBlockStmt([
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
                name: "X", genericParams: [.init("T")],
                type: TSObjectType([])
            ),
            TSTypeDecl(
                name: "S", genericParams: [.init("T"), .init("U")],
                type: TSObjectType([
                    .field(.init(name: "a", isOptional: true, type: TSIdentType("A"))),
                    .field(.init(name: "b", type: TSIdentType("number"))),
                    .field(.init(name: "c", type: TSArrayType(TSIdentType("C")))),
                    .field(.init(name: "d", type: TSIdentType("T"))),
                    .field(.init(name: "e", type: TSIdentType("X", genericArgs: [TSIdentType("E")]))),
                    .field(.init(name: "f", type: TSIdentType("X", genericArgs: [TSIdentType("U")]))),
                    .method(.init(name: "g", params: [.init(name: "y", type: TSIdentType("Y", genericArgs: [TSIdentType("G")]))], result: TSIdentType.number)),
                    .method(.init(name: "h", params: [], result: TSIdentType("Y", genericArgs: [TSIdentType("U")]))),
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
                g(y: Y<G>): number;
                h(): Y<U>;
            };

            """
        )

        XCTAssertEqual(Set(s.memberDeclaredNames), ["X", "S"])
        XCTAssertEqual(Set(s.scanDependency()), ["A", "C", "E", "G", "Y", "number"])
    }

    func testInterface() throws {
        let s = TSSourceFile([
            TSInterfaceDecl(
                name: "I", genericParams: [.init("T")], extends: [TSIdentType("J")],
                body: TSBlockStmt([
                    TSMethodDecl(
                        name: "foo", genericParams: [.init("U")],
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
                name: "C", genericParams: [.init("T")],
                extends: TSIdentType("D"), implements: [TSIdentType("I")],
                body: TSBlockStmt([
                    TSMethodDecl(
                        name: "foo", genericParams: [.init("U")],
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
                catch: TSCatchStmt(name: "e", body: TSBlockStmt([
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

    func testObjectExpr() {
        let s = TSSourceFile([
            TSVarDecl(kind: .const, name: "v", initializer: TSObjectExpr([
                .named(name: "a", value: TSBooleanLiteralExpr.true),
                .shorthandPropertyNames(value: TSIdentExpr("b")),
                .computedPropertyNames(name: TSInfixOperatorExpr(
                    TSIdentExpr("c"), "+", TSNumberLiteralExpr(42)
                ), value: TSIdentExpr.undefined),
                .method(.init(name: "d", params: [], body: TSBlockStmt([]))),
                .destructuring(value: TSIdentExpr("e")),
            ])),
        ])

        assertPrint(
            s, """
            const v = {
                a: true,
                b,
                [c + 42]: undefined,
                d() {},
                ...e
            };

            """
        )

        XCTAssertEqual(Set(s.scanDependency()), ["b", "c", "e", "undefined"])
    }

    func testFunctionType() {
        let s = TSSourceFile([
            TSTypeDecl(name: "t", type: TSObjectType([
                .field(.init(name: "f", type: TSFunctionType(
                    genericParams: [.init("T")],
                    params: [.init(name: "a", type: TSIdentType("A"))],
                    result: TSIdentType("T")
                ))),
            ])),
        ])

        assertPrint(
            s, """
            type t = {
                f: <T>(a: A) => T;
            };

            """
        )

        XCTAssertEqual(Set(s.scanDependency()), ["A"])
    }

    func testClosureExpr() {
        let s = TSSourceFile([
            TSVarDecl(
                kind: .const,
                name: "f",
                initializer: TSClosureExpr(
                    genericParams: [.init("T")],
                    params: [.init(name: "tu", type: TSIntersectionType([
                        TSIdentType("T"),
                        TSIdentType("U"),
                    ]))],
                    body: TSIdentExpr("tu")
                )
            )
        ])

        assertPrint(
            s, """
            const f = <T,>(tu: T & U) => tu;

            """
        )

        XCTAssertEqual(Set(s.scanDependency()), ["U"])
    }

    func testInferType1() {
        let s = TSSourceFile([
            TSTypeDecl(
                name: "F",
                genericParams: [.init("T")],
                type: TSConditionalType(
                    TSIdentType("T"),
                    extends: TSArrayType(TSInferType(name: "I")),
                    true: TSIdentType("I"),
                    false: TSIdentType("T")
                )
            )
        ])

        assertPrint(
            s, """
            type F<T> = T extends (infer I)[]
                ? I
                : T
            ;

            """
        )

        XCTAssertEqual(Set(s.scanDependency()), [])
    }

    func testInferType2() {
        let s = TSSourceFile([
            TSTypeDecl(
                name: "F",
                genericParams: [.init("T")],
                type: TSConditionalType(
                    TSIdentType("T"),
                    extends: TSArrayType(TSInferType(name: "I")),
                    true: TSIdentType("T"),
                    false: TSIdentType("I")
                )
            )
        ])

        assertPrint(
            s, """
            type F<T> = T extends (infer I)[]
                ? T
                : I
            ;

            """
        )

        XCTAssertEqual(Set(s.scanDependency()), ["I"])
    }

    func testMappedType() {
        let s = TSSourceFile([
            TSTypeDecl(
                name: "E",
                genericParams: [.init("T")],
                type: TSMappedType(
                    "P",
                    in: TSKeyofType(TSIdentType("T")),
                    as: TSIdentType("Exclude", genericArgs: [TSIdentType("P"), TSStringLiteralType("kind")]),
                    value: TSIndexedAccessType(TSIdentType("T"), index: TSIdentType("P"))
                )
            ),
        ])

        assertPrint(
            s, """
            type E<T> = {
                [P in keyof T as Exclude<P, "kind">]: T[P];
            };
            
            """
        )

        XCTAssertEqual(Set(s.scanDependency()), ["Exclude"])
    }

    func testGenericTypeParameter() {
        let s = TSSourceFile([
            TSTypeDecl(
                name: "A", genericParams: [
                    .init("T"),
                    .init("U", extends: TSUnionType([TSIdentType("T"),  TSIdentType("V"), TSIdentType("B")])),
                    .init("V", default: TSIdentType("C")),
                ],
                type: TSIdentType("T")
            ),
        ])

        assertPrint(
            s, """
            type A<T, U extends T | V | B, V = C> = T;

            """
        )

        XCTAssertEqual(Set(s.scanDependency()), ["B", "C"])
    }
}
