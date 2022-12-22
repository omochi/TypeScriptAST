import XCTest
import TypeScriptAST

final class PrintDeclTests: TestCaseBase {
    func testImport() throws {
        assertPrint(
            TSImportDecl(names: [], from: "./a.js"),
            """
            import {} from "./a.js";
            """
        )

        assertPrint(
            TSImportDecl(names: ["A"], from: "./a.js"),
            """
            import { A } from "./a.js";
            """
        )

        assertPrint(
            TSImportDecl(names: ["A", "B"], from: "./a.js"),
            """
            import { A, B } from "./a.js";
            """
        )

        assertPrint(
            TSImportDecl(names: ["A", "B", "C", "D"], from: "./a.js"),
            """
            import {
                A,
                B,
                C,
                D
            } from "./a.js";
            """
        )

        assertPrint(
            TSImportDecl(names: ["A", "B", "C"], from: ".."),
            """
            import { A, B, C } from "..";
            """
        )
    }

    func testType() throws {
        assertPrint(
            TSTypeDecl(
                modifiers: [.export],
                name: "A",
                type: TSUnionType([TSIdentType.number, TSIdentType.null])
            ),
            """
            export type A = number | null;
            """
        )

        assertPrint(
            TSTypeDecl(
                name: "A",
                genericParams: ["T"],
                type: TSIdentType("B", genericArgs: [TSIdentType("T")])
            ),
            """
            type A<T> = B<T>;
            """
        )

        assertPrint(
            TSTypeDecl(name: "S1", type: TSObjectType([
                .field(.init(name: "a", isOptional: true, type: TSObjectType([
                    .field(.init(name: "a", type: TSIdentType.number)),
                    .field(.init(name: "b", type: TSIdentType.string)),
                ]))),
            ])),
            """
            type S1 = {
                a?: {
                    a: number;
                    b: string;
                };
            };
            """
        )
    }

    func testNamespace() throws {
        assertPrint(
            TSNamespaceDecl(
                modifiers: [],
                name: "A",
                body: TSBlockStmt([])
            ),
            """
            namespace A {}
            """
        )

        assertPrint(
            TSNamespaceDecl(
                modifiers: [.export],
                name: "A",
                body: TSBlockStmt([
                    TSTypeDecl(modifiers: [.export], name: "B", type: TSIdentType.string)
                ])
            ),
            """
            export namespace A {
                export type B = string;
            }
            """
        )

        assertPrint(
            TSNamespaceDecl(
                modifiers: [.export],
                name: "A",
                body: TSBlockStmt([
                    TSTypeDecl(modifiers: [.export], name: "B", type: TSIdentType.string),
                    TSTypeDecl(modifiers: [.export], name: "C", type: TSIdentType.string)
                ])
            ),
            """
            export namespace A {
                export type B = string;

                export type C = string;
            }
            """
        )

        assertPrint(
            TSNamespaceDecl(
                name: "A",
                body: TSBlockStmt([
                    TSTypeDecl(name: "B", type: TSObjectType([
                        .field(.init(name: "x", type: TSIdentType.string)),
                    ]))
                ])
            ),
            """
            namespace A {
                type B = {
                    x: string;
                };
            }
            """
        )
    }

    func testVar() throws {
        assertPrint(
            TSVarDecl(
                kind: .var,
                name: "a"
            ),
            """
            var a;
            """
        )

        assertPrint(
            TSVarDecl(
                modifiers: [.export],
                kind: .const,
                name: "b",
                type: TSIdentType.number,
                initializer: TSNumberLiteralExpr("0")
            ),
            """
            export const b: number = 0;
            """
        )
    }

    func testFunction() throws {
        assertPrint(
            TSFunctionDecl(
                modifiers: [.export],
                name: "f",
                params: [
                    .init(name: "a", type: TSIdentType.number),
                    .init(name: "b", type: TSIdentType.string)
                ],
                body: TSBlockStmt([
                    TSReturnStmt(
                        TSNumberLiteralExpr("0")
                    )
                ])
            ),
            """
            export function f(a: number, b: string) {
                return 0;
            }
            """
        )

        assertPrint(
            TSFunctionDecl(
                modifiers: [.export],
                name: "f",
                genericParams: ["A", "B", "C", "D"],
                params: [
                    .init(name: "a", type: TSIdentType.number),
                    .init(name: "b", type: TSIdentType.string),
                    .init(name: "c", type: TSIdentType.number),
                    .init(name: "d", type: TSIdentType.string)
                ],
                result: TSIdentType.number,
                body: TSBlockStmt([
                    TSReturnStmt(
                        TSNumberLiteralExpr("0")
                    )
                ])
            ),
            """
            export function f<
                A,
                B,
                C,
                D
            >(
                a: number,
                b: string,
                c: number,
                d: string
            ): number {
                return 0;
            }
            """
        )
    }

    func testInterface() throws {
        assertPrint(
            TSInterfaceDecl(
                name: "I",
                body: TSBlockStmt()
            ),
            """
            interface I {}
            """
        )

        assertPrint(
            TSInterfaceDecl(
                name: "I",
                genericParams: ["T"],
                extends: [TSIdentType("J")],
                body: TSBlockStmt([
                    TSMethodDecl(
                        name: "a",
                        genericParams: ["U"],
                        params: [.init(name: "x", type: TSIdentType("T"))],
                        result: TSIdentType("U")
                    )
                ])
            ),
            """
            interface I<T> extends J {
                a<U>(x: T): U;
            }
            """
        )

        assertPrint(
            TSInterfaceDecl(
                modifiers: [.export],
                name: "I",
                genericParams: ["T"],
                extends: [
                    TSIdentType("J", genericArgs: [TSIdentType("T")]),
                    TSIdentType("K")
                ],
                body: TSBlockStmt([
                    TSFieldDecl(name: "x", type: TSIdentType.number),
                    TSFieldDecl(name: "y", type: TSIdentType.number),
                    TSMethodDecl(name: "f", params: []),
                    TSMethodDecl(name: "g", genericParams: ["U"], params: [
                        .init(name: "a", type: TSIdentType.string)
                    ], result: TSIdentType.string)
                ])
            ),
            """
            export interface I<T> extends J<T>, K {
                x: number;
                y: number;

                f();
                g<U>(a: string): string;
            }
            """
        )
    }

    func testClass() throws {
        assertPrint(
            TSClassDecl(name: "A", body: TSBlockStmt()),
            """
            class A {}
            """
        )

        assertPrint(
            TSClassDecl(
                modifiers: [.export],
                name: "A",
                genericParams: ["T"],
                extends: TSIdentType("B"),
                implements: [TSIdentType("I")],
                body: TSBlockStmt([
                    TSFieldDecl(
                        modifiers: [.public],
                        name: "a",
                        type: TSIdentType.number
                    ),
                    TSFieldDecl(
                        modifiers: [.private],
                        name: "b",
                        type: TSIdentType.number
                    ),
                    TSMethodDecl(
                        modifiers: [.public, .async],
                        name: "f",
                        params: [],
                        result: TSIdentType.promise(TSIdentType.number)
                    )
                ])
            ),
            """
            export class A<T> extends B implements I {
                public a: number;
                private b: number;

                public async f(): Promise<number>;
            }
            """
        )

        assertPrint(
            TSClassDecl(
                name: "A",
                genericParams: ["T"],
                extends: TSIdentType("B", genericArgs: [TSIdentType("T")]),
                implements: [TSIdentType("I", genericArgs: [TSIdentType("T")])],
                body: TSBlockStmt([
                    TSMethodDecl(
                        name: "a", params: [], result: TSIdentType.number,
                        body: TSBlockStmt([
                            TSReturnStmt(TSNumberLiteralExpr("1.0"))
                        ])
                    )
                ])
            ),
            """
            class A<T> extends B<T> implements I<T> {
                a(): number {
                    return 1.0;
                }
            }
            """
        )

        assertPrint(
            TSClassDecl(
                name: "A",
                extends: TSIdentType("B"),
                implements: [TSIdentType("I"), TSIdentType("J"), TSIdentType("K"), TSIdentType("L")],
                body: TSBlockStmt([
                    TSMethodDecl(
                        modifiers: [.async], name: "a", params: [],
                        result: TSIdentType.promise(TSIdentType.number),
                        body: TSBlockStmt([
                            TSReturnStmt(TSNumberLiteralExpr(1))
                        ])
                    ),
                    TSMethodDecl(
                        modifiers: [.async], name: "b", params: [],
                        result: TSIdentType.promise(TSIdentType.number),
                        body: TSBlockStmt([
                            TSReturnStmt(
                                TSAwaitExpr(
                                    TSCallExpr(
                                        callee: TSMemberExpr(base: TSIdentExpr.this, name: "a"),
                                        args: []
                                    )
                                )
                            )
                        ])
                    )
                ])
            ),
            """
            class A extends B implements
                I,
                J,
                K,
                L
            {
                async a(): Promise<number> {
                    return 1;
                }

                async b(): Promise<number> {
                    return await this.a();
                }
            }
            """
        )
    }

    func testSourceFile() throws {
        assertPrint(
            TSSourceFile([
                TSVarDecl(
                    modifiers: [.export], kind: .const, name: "a", type: TSIdentType.number,
                    initializer: TSNumberLiteralExpr("1")
                ),
                TSVarDecl(
                    modifiers: [.export], kind: .const, name: "b", type: TSIdentType.number,
                    initializer: TSNumberLiteralExpr("2")
                )
            ]),
            """
            export const a: number = 1;

            export const b: number = 2;
            
            """
        )
    }

    func testImports() throws {
        assertPrint(
            TSSourceFile([
                TSImportDecl(names: ["A", "B"], from: "./ab.js"),
                TSImportDecl(names: ["C"], from: "./c.js"),
                TSImportDecl(names: ["D", "E", "F", "G", "H", "I"], from: "./defghi.js"),
                TSFunctionDecl(name: "foo", params: [], body: TSBlockStmt([]))
            ]),
            """
            import { A, B } from "./ab.js";
            import { C } from "./c.js";
            import {
                D,
                E,
                F,
                G,
                H,
                I
            } from "./defghi.js";

            function foo() {}

            """
        )
    }

    func testNewlineBetweenDecls() throws {
        let s = TSSourceFile([
            TSImportDecl(names: ["A", "B"], from: "./ab.js"),
            TSImportDecl(names: ["C"], from: "./c.js"),
            TSInterfaceDecl(name: "I", body: TSBlockStmt([
                TSFieldDecl(name: "value1", type: TSIdentType("A")),
                TSFieldDecl(name: "value2", type: TSIdentType("B")),
                TSMethodDecl(name: "f1", params: []),
                TSMethodDecl(name: "f2", params: []),
            ])),
            TSFunctionDecl(name: "foo", params: [], body: TSBlockStmt([
                TSVarDecl(
                    kind: .const, name: "c1", type: TSUnionType([TSIdentType("C"), TSIdentType.undefined]),
                    initializer: TSIdentExpr.undefined
                ),
                TSVarDecl(
                    kind: .const, name: "c2", type: TSUnionType([TSIdentType("C"), TSIdentType.undefined]),
                    initializer: TSIdentExpr.undefined
                ),
            ])),
            TSVarDecl(
                kind: .const, name: "c1", type: TSUnionType([TSIdentType("C"), TSIdentType.undefined]),
                initializer: TSIdentExpr.undefined
            ),
            TSVarDecl(
                kind: .const, name: "c1", type: TSUnionType([TSIdentType("C"), TSIdentType.undefined]),
                initializer: TSIdentExpr.undefined
            ),
            TSClassDecl(name: "Bar", body: TSBlockStmt([
                TSFieldDecl(name: "value1", type: TSIdentType("A")),
                TSFieldDecl(name: "value2", type: TSIdentType("B")),
                TSFunctionDecl(name: "f1", params: [], result: TSIdentType.string, body: TSBlockStmt([
                    TSVarDecl(
                        kind: .const, name: "c1", type: TSUnionType([TSIdentType("C"), TSIdentType.undefined]),
                        initializer: TSIdentExpr.undefined
                    ),
                    TSVarDecl(
                        kind: .const, name: "c1", type: TSUnionType([TSIdentType("C"), TSIdentType.undefined]),
                        initializer: TSIdentExpr.undefined
                    ),
                ])),
                TSFunctionDecl(name: "f2", params: [], result: TSIdentType.string, body: TSBlockStmt([]))
            ])),
        ])

        assertPrint(
            s, """
            import { A, B } from "./ab.js";
            import { C } from "./c.js";

            interface I {
                value1: A;
                value2: B;

                f1();
                f2();
            }

            function foo() {
                const c1: C | undefined = undefined;
                const c2: C | undefined = undefined;
            }

            const c1: C | undefined = undefined;

            const c1: C | undefined = undefined;

            class Bar {
                value1: A;
                value2: B;

                function f1(): string {
                    const c1: C | undefined = undefined;
                    const c1: C | undefined = undefined;
                }

                function f2(): string {}
            }
            
            """
        )
    }
}
