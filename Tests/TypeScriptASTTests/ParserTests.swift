import Testing
import TypeScriptAST

@Suite struct ParserTests {
    static var data: [String] {
        ["""
        import { foo } from "./lib";
        
        """]
    }

    @Test(arguments: Self.data) func roundTrip(string: String) {
        var p = Parser(string: string)
        let ast = p.parse()
        let parsed = ast.print()
        let expected = string
        #expect(parsed == expected)
    }
}
