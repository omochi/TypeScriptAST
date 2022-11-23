import XCTest
import TypeScriptAST

final class PrintDeclTests: PrintTestsBase {
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
                type: TSNamedType.number.orNull
            ),
            """
            export type A = number | null;

            """
        )

        assertPrint(
            TSTypeDecl(
                name: "A",
                genericParams: ["T"],
                type: TSNamedType(name: "B", genericArgs: [TSNamedType(name: "T")])
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
                decls: []
            ),
            """
            namespace A {}
            """
        )

        assertPrint(
            TSNamespaceDecl(
                modifiers: [.export],
                name: "A",
                decls: [
                    TSTypeDecl(modifiers: [.export], name: "B", type: TSNamedType.string)
                ]
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
                decls: [
                    TSTypeDecl(modifiers: [.export], name: "B", type: TSNamedType.string),
                    TSTypeDecl(modifiers: [.export], name: "C", type: TSNamedType.string)
                ]
            ),
            """
            export namespace A {
                export type B = string;

                export type C = string;
            }
            """
        )
    }
}
