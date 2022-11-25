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
    }

    func testNamespace() throws {
        assertPrint(
            TSNamespaceDecl(
                modifiers: [],
                name: "A",
                block: TSBlockStmt([])
            ),
            """
            namespace A {}
            """
        )

        assertPrint(
            TSNamespaceDecl(
                modifiers: [.export],
                name: "A",
                block: TSBlockStmt([
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
                block: TSBlockStmt([
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
                block: TSBlockStmt()
            ),
            """
            interface I {}
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
                block: TSBlockStmt([
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
            TSClassDecl(name: "A", block: TSBlockStmt()),
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
                block: TSBlockStmt([
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
}
