import Testing
import TypeScriptAST

@Suite struct TokenizerTests {
    static var data: [(String, [Token])] {
        let result: [(String, [Token])] = [
            ("", []),
            ("import from", [Token.keyword(.import), .keyword(.from)]),
        ]
        return result
    }

    @Test(arguments: Self.data) func test(string: String, expected: [Token]) {
        var k  = Tokenizer(string: string)
        let ts = k.readAll()
        #expect(ts == expected)
    }
}
