import XCTest
import TypeScriptAST

final class AutoImportTests: TestCaseBase {
    func testAutoImport() throws {
        let s = TSSourceFile([
            TSTypeDecl(modifiers: [.export], name: "S", type: TSObjectType([]))
        ])
        assertPrint(
            s, """
            export type S = {};

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
        symbols.add(source: s, file: "./s.js")
        let imports = try m.buildAutoImportDecls(symbolTable: symbols)
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

        m.replaceImportDecls(list: imports)
        assertPrint(
            m, """
            import { S } from "./s.js";
            import { X } from "./x.js";

            function f(a: S, b: X) {}
            
            """
        )
    }
}
