public struct Tokenizer {
    public init(
        string: String,
        position: String.Index? = nil
    ) {
        self.string = string
        self.pos = position ?? string.startIndex
        self.nextToken = nil
        _ = self.read()
    }

    public let string: String

    public var position: String.Index {
        get { pos }
        set {
            pos = newValue
            nextToken = nil
            _ = read()
        }
    }
    private var pos: String.Index

    public private(set) var nextToken: Token?

    public mutating func read() -> Token? {
        let result = nextToken
        nextToken = readNextToken()
        return result
    }

    public mutating func readAll() -> [Token] {
        var result: [Token] = []
        while let token = read() {
            result.append(token)
        }
        return result
    }

    private mutating func readNextToken() -> Token? {
        while true {
            guard let _ = char() else { return nil }

            if readWhitespace() {
                continue
            }

            if let x = readSymbol() {
                return .symbol(x)
            }

            if let x = readKeyword() {
                return x
            }

            advance()
        }
    }

    private mutating func readWhitespace() -> Bool {
        return readString(where: isWhitespace) != nil
    }

    private mutating func readKeyword() -> Token? {
        guard let s = readKeywordString() else { return nil }

        if let k = Keyword(rawValue: s) {
            return .keyword(k)
        }
        return .identifier(s)
    }

    private mutating func readKeywordString() -> String? {
        readString(where: isKeyword)
    }

    private mutating func readSymbol() -> Symbol? {
        guard let c = char() else {
            return nil
        }

        switch c {
        case .exclamation:
            advance()
            return .exclamation
        case .percent:
            advance()
            return .percent
        case .ampersand:
            advance()
            return .ampersand
        case .leftParen:
            advance()
            return .leftParen
        case .rightParen:
            advance()
            return .rightParen
        case .asterisk:
            advance()
            return .asterisk
        case .plus:
            advance()
            return .plus
        case .comma:
            advance()
            return .comma
        case .minus:
            advance()
            return .minus
        case .dot:
            advance()
            return .dot
        case .slash:
            advance()
            return .slash
        case .colon:
            advance()
            return .colon
        case .semicolon:
            advance()
            return .semicolon
        case .leftAngleBracket:
            advance()
            return .leftAngleBracket
        case .equal:
            advance()
            return .equal
        case .rightAngleBracket:
            advance()
            return .rightAngleBracket
        case .question:
            advance()
            return .question
        case .leftSquareBracket:
            advance()
            return .leftSquareBracket
        case .backslash:
            advance()
            return .backslash
        case .rightSquareBracket:
            advance()
            return .rightSquareBracket
        case .leftBrace:
            advance()
            return .leftBrace
        case .pipe:
            advance()
            return .pipe
        case .rightBrace:
            advance()
            return .rightBrace
        default:
            return nil
        }
    }

    private mutating func readString(where predicate: (Character) -> Bool) -> String? {
        let start = pos
        guard let c = char(at: pos), predicate(c) else {
            return nil
        }
        advance()

        while let c = char(at: pos), predicate(c) {
            advance()
        }

        return String(string[start..<pos])
    }

    private func isWhitespace(_ c: Character) -> Bool {
        switch c {
        case .space, .tab, .lf, .cr, .crLf: return true
        default: return false
        }
    }

    private func isKeyword(_ c: Character) -> Bool {
        switch c {
        case .a ... .z,
                .A ... .Z,
                ._0 ... ._9,
                .underscore: return true
        default: return false
        }
    }

    private mutating func advance() {
        pos = string.index(after: pos)
    }

    private func char(at index: String.Index) -> Character? {
        if index == string.endIndex { return nil }
        return string[index]
    }

    private func char() -> Character? {
        char(at: pos)
    }
}
