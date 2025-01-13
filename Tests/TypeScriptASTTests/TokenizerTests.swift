import Testing
import TypeScriptAST

@Suite struct TokenizerTests {
    static var data: [(String, [Token])] {
        let result: [(String, [Token])] = [
            ("", []),
            ("import from", [.keyword(.import), .keyword(.from)]),
            ("! % & ( ) * + , - . / : ; < = > ? [ \\ ] { | }", [
                .symbol(.exclamation),
                .symbol(.percent),
                .symbol(.ampersand),
                .symbol(.leftParen),
                .symbol(.rightParen),
                .symbol(.asterisk),
                .symbol(.plus),
                .symbol(.comma),
                .symbol(.minus),
                .symbol(.dot),
                .symbol(.slash),
                .symbol(.colon),
                .symbol(.semicolon),
                .symbol(.leftAngleBracket),
                .symbol(.equal),
                .symbol(.rightAngleBracket),
                .symbol(.question),
                .symbol(.leftSquareBracket),
                .symbol(.backslash),
                .symbol(.rightSquareBracket),
                .symbol(.leftBrace),
                .symbol(.pipe),
                .symbol(.rightBrace),
            ])
        ]
        return result
    }

    @Test(arguments: Self.data) func test(string: String, expected: [Token]) {
        var k  = Tokenizer(string: string)
        let ts = k.readAll()
        #expect(ts == expected)
    }
}
