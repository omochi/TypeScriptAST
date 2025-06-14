import Foundation
import XCTest
import TypeScriptAST

final class AutoImportTests: TestCaseBase {
    func testAutoImportJsExt() throws {
        let s = TSSourceFile([
            TSTypeDecl(
                modifiers: [.export], name: "S",
                type: TSIdentType("Record", genericArgs: [TSIdentType("string"), TSIdentType("number")]))
        ])
        assertPrint(
            s, """
            export type S = Record<string, number>;

            """
        )

        let m = TSSourceFile([
            TSImportDecl(names: ["X"], from: "./x.js"),
            TSFunctionDecl(
                name: "f", params: [
                    .init(name: "a", type: TSIdentType("S")),
                    .init(name: "b", type: TSIdentType("X"))
                ], body: TSBlockStmt()
            )
        ])
        assertPrint(
            m, """
            import { X } from "./x.js";

            function f(a: S, b: X) {}

            """
        )

        var symbols = SymbolTable()
        symbols.add(source: s, file: URL(fileURLWithPath: "s.ts"))

        let imports = try m.buildAutoImportDecls(
            from: URL(fileURLWithPath: "m.ts"),
            symbolTable: symbols,
            fileExtension: .js
        )
        XCTAssertEqual(imports.count, 2)
        assertPrint(
            try XCTUnwrap(imports[safe: 0]),
            """
            import { S } from "./s.js";
            """
        )
        assertPrint(
            try XCTUnwrap(imports[safe: 1]),
            """
            import { X } from "./x.js";
            """
        )

        m.replaceImportDecls(imports)
        assertPrint(
            m, """
            import { S } from "./s.js";
            import { X } from "./x.js";

            function f(a: S, b: X) {}
            
            """
        )
    }

    func testAutoImportNoneExt() throws {
        let s = TSSourceFile([
            TSTypeDecl(modifiers: [.export], name: "S", type: TSObjectType([]))
        ])
        assertPrint(
            s, """
            export type S = {};

            """
        )

        let m = TSSourceFile([
            TSTypeDecl(modifiers: [.export], name: "M", type: TSIdentType("S"))
        ])
        assertPrint(
            m, """
            export type M = S;

            """
        )

        var symbols = SymbolTable()
        symbols.add(source: s, file: URL(fileURLWithPath: "s.ts"))

        let imports = try m.buildAutoImportDecls(
            from: URL(fileURLWithPath: "m.ts"),
            symbolTable: symbols,
            fileExtension: .none
        )
        m.replaceImportDecls(imports)

        assertPrint(
            m, """
            import { S } from "./s";

            export type M = S;

            """
        )
    }

    func testRelativeSibling() throws {
        let s = TSSourceFile([
            TSTypeDecl(modifiers: [.export], name: "S", type: TSObjectType([]))
        ])

        let m = TSSourceFile([
            TSTypeDecl(modifiers: [.export], name: "M", type: TSIdentType("S"))
        ])

        var symbols = SymbolTable()
        symbols.add(source: s, file: URL(fileURLWithPath: "s/s.ts"))

        let imports = try m.buildAutoImportDecls(
            from: URL(fileURLWithPath: "s/m.ts"),
            symbolTable: symbols,
            fileExtension: .none
        )
        m.replaceImportDecls(imports)

        assertPrint(
            m, """
            import { S } from "./s";

            export type M = S;

            """
        )
    }

    func testRelativeSubdir() throws {
        let s = TSSourceFile([
            TSTypeDecl(modifiers: [.export], name: "S", type: TSObjectType([]))
        ])

        let m = TSSourceFile([
            TSTypeDecl(modifiers: [.export], name: "M", type: TSIdentType("S"))
        ])

        var symbols = SymbolTable()
        symbols.add(source: s, file: URL(fileURLWithPath: "s/s/s.ts"))

        let imports = try m.buildAutoImportDecls(
            from: URL(fileURLWithPath: "s/m.ts"),
            symbolTable: symbols,
            fileExtension: .none
        )
        m.replaceImportDecls(imports)

        assertPrint(
            m, """
            import { S } from "./s/s";

            export type M = S;

            """
        )
    }

    func testRelativeDoubleDot() throws {
        let s = TSSourceFile([
            TSTypeDecl(modifiers: [.export], name: "S", type: TSObjectType([]))
        ])

        let m = TSSourceFile([
            TSTypeDecl(modifiers: [.export], name: "M", type: TSIdentType("S"))
        ])

        var symbols = SymbolTable()
        symbols.add(source: s, file: URL(fileURLWithPath: "s/s.ts"))

        let imports = try m.buildAutoImportDecls(
            from: URL(fileURLWithPath: "m/m.ts"),
            symbolTable: symbols,
            fileExtension: .none
        )
        m.replaceImportDecls(imports)

        assertPrint(
            m, """
            import { S } from "../s/s";

            export type M = S;

            """
        )
    }

    func testAlias() throws {
        let s = TSSourceFile([
            TSTypeDecl(modifiers: [.export], name: "S", type: TSObjectType([]))
        ])

        let m = TSSourceFile([
            TSTypeDecl(modifiers: [.export], name: "M", type: TSIdentType("S"))
        ])

        var symbols = SymbolTable()
        symbols.add(source: s, file: URL(fileURLWithPath: "lib/foo/s.ts"))

        let imports = try m.buildAutoImportDecls(
            from: URL(fileURLWithPath: "m/m.ts"),
            symbolTable: symbols,
            fileExtension: .none,
            pathPrefixReplacements: [
                .init(path: URL(fileURLWithPath: "lib/foo"), replacement: "@foo")
            ]
        )
        m.replaceImportDecls(imports)

        assertPrint(
            m, """
            import { S } from "@foo/s";

            export type M = S;

            """
        )
    }

    func testUnrelatedAlias() throws {
        let s = TSSourceFile([
            TSTypeDecl(modifiers: [.export], name: "S", type: TSObjectType([]))
        ])

        let m = TSSourceFile([
            TSTypeDecl(modifiers: [.export], name: "M", type: TSIdentType("S"))
        ])

        var symbols = SymbolTable()
        symbols.add(source: s, file: URL(fileURLWithPath: "s/s.ts"))

        let imports = try m.buildAutoImportDecls(
            from: URL(fileURLWithPath: "m/m.ts"),
            symbolTable: symbols,
            fileExtension: .none,
            pathPrefixReplacements: [
                .init(path: URL(fileURLWithPath: "lib/foo"), replacement: "@foo")
            ]
        )
        m.replaceImportDecls(imports)

        assertPrint(
            m, """
            import { S } from "../s/s";

            export type M = S;

            """
        )
    }


    func testDefaultImport() throws {
        let s = TSSourceFile([
            TSVarDecl(
                kind: .const, name: "a", type: TSIdentType("A"),
                initializer: TSIdentExpr("b")
            )
        ])

        assertPrint(
            s, """
            const a: A = b;

            """
        )

        let imports = try s.buildAutoImportDecls(
            from: URL(fileURLWithPath: "s.ts"),
            symbolTable: SymbolTable(),
            fileExtension: .js,
            defaultFile: ".."
        )
        s.replaceImportDecls(imports)

        assertPrint(
            s, """
            import { A, b } from "..";

            const a: A = b;
            
            """
        )
    }

    func testUnknownSymbols() throws {
        let s = TSSourceFile([
            TSVarDecl(
                kind: .const, name: "a", type: TSIdentType("A"),
                initializer: TSIdentExpr("b")
            )
        ])

        assertPrint(
            s, """
            const a: A = b;

            """
        )

        XCTAssertThrowsError(try s.buildAutoImportDecls(
            from: URL(fileURLWithPath: "s.ts"),
            symbolTable: SymbolTable(),
            fileExtension: .js
        )) { error in
            XCTAssertEqual("\(error)", "unknown symbols: A, b")
        }
    }
}
