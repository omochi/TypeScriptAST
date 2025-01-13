import Testing
import TypeScriptAST

func words(_ string: String) -> [Substring] {
    string.split(separator: /\s+/)
}

@Suite struct ParserTests {
    static var data: [String] {
        ["""
        import {  foo } from "./lib"
        """]
    }

    @Test(arguments: Self.data) func roundTripWord(string: String) {
        var p = Parser(string: string)
        let ast = p.parse()
        let parsed = words(ast.print())
        let expected = words(string)
        #expect(parsed == expected)
    }
}
