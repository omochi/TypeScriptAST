import Testing
import TypeScriptAST

@Suite struct TokenizerTests {
    static func symbols(_ s: [Symbol]) -> [Token] {
        s.map { .symbol($0) }
    }

    static var data: [(String, [Token])] {
        let result: [(String, [Token])] = [
            ("", []),
            ("import from", [.keyword(.import), .keyword(.from)]),
            ("! % & ( ) * + , - . / : ; < = > ? [ \\ ] { | }", symbols([
                .exclamation,
                .percent,
                .ampersand,
                .leftParen,
                .rightParen,
                .asterisk,
                .plus,
                .comma,
                .minus,
                .dot,
                .slash,
                .colon,
                .semicolon,
                .leftAngleBracket,
                .equal,
                .rightAngleBracket,
                .question,
                .leftSquareBracket,
                .backslash,
                .rightSquareBracket,
                .leftBrace,
                .pipe,
                .rightBrace,
            ])),
            ("! != !== % %= & && &&= &= * *= + ++ += - -- -= / /=", symbols([
                .exclamation,
                .exclamationEqual,
                .exclamationEqualEqual,
                .percent,
                .percentEqual,
                .ampersand,
                .ampersandAmpersand,
                .ampersandAmpersandEqual,
                .ampersandEqual,
                .asterisk,
                .asteriskEqual,
                .plus,
                .plusPlus,
                .plusEqual,
                .minus,
                .minusMinus,
                .minusEqual,
                .slash,
                .slashEqual,

            ])),
            ("< << <<= = == === => > >> >>= ? ?. ?? ??= | |= || ||=", symbols([
                .leftAngleBracket,
                .leftAngleBracketLeftAngleBracket,
                .leftAngleBracketLeftAngleBracketEqual,
                .equal,
                .equalEqual,
                .equalEqualEqual,
                .equalRightAngleBracket,
                .rightAngleBracket,
                .rightAngleBracketRightAngleBracket,
                .rightAngleBracketRightAngleBracketEqual,
                .question,
                .questionDot,
                .questionQuestion,
                .questionQuestionEqual,
                .pipe,
                .pipeEqual,
                .pipePipe,
                .pipePipeEqual,
            ])),
            ("""
            foo // comment
            bar
            """, [.identifier("foo"), .identifier("bar")]),
            ("""
            foo /*
            comment */ bar /**/ baz /* * */ qux
            """, [
                .identifier("foo"), .identifier("bar"), .identifier("baz"), .identifier("qux")
            ]),
            ("foo /* bar", [.identifier("foo")]),
            ("foo /* bar *", [.identifier("foo")]),
            ("""
            foo // /*
            bar
            """, [.identifier("foo"), .identifier("bar")]),
            ("""
            foo /*
            // */ bar
            """, [.identifier("foo"), .identifier("bar")])
        ]
        return result
    }

    @Test(arguments: Self.data) func test(string: String, expected: [Token]) {
        var k = Tokenizer(string: string)
        let tokens = k.readAll()
        #expect(tokens == expected)
    }
}
