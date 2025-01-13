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
            guard let c = char() else { return nil }

            if readWhitespace() {
                continue
            }

            if readComment() {
                continue
            }

            if let x = readSymbol() {
                return .symbol(x)
            }

            if let x = readKeyword() {
                return x
            }

            print("skip character: \(c)")
            advance()
        }
    }

    private mutating func readWhitespace() -> Bool {
        return readString(where: isWhitespace) != nil
    }

    private mutating func readComment() -> Bool {
        var p = self.pos
        switch char(at: p) {
        case .slash:
            advance(position: &p)
            switch char(at: p) {
            case .slash:
                advance(position: &p)
                loop: while true {
                    switch char(at: p) {
                    case .lf, .cr, .crLf:
                        advance(position: &p)
                        break loop
                    case nil:
                        break loop
                    default:
                        advance(position: &p)
                        continue
                    }
                }
                self.pos = p
                return true
            case .asterisk:
                advance(position: &p)
                loop: while true {
                    switch char(at: p) {
                    case .asterisk:
                        advance(position: &p)
                        switch char(at: p) {
                        case .slash:
                            advance(position: &p)
                            break loop
                        case nil:
                            break loop
                        default:
                            continue
                        }
                    case nil:
                        break loop
                    default:
                        advance(position: &p)
                        continue
                    }
                }
                self.pos = p
                return true
            default:
                return false
            }
        default:
            return false
        }
    }

    private mutating func readSymbol() -> Symbol? {
        switch char() {
        case .exclamation:
            advance()
            switch char() {
            case .equal:
                advance()
                switch char() {
                case .equal:
                    advance()
                    return .exclamationEqualEqual
                default:
                    return .exclamationEqual
                }
            default:
                return .exclamation
            }
        case .percent:
            advance()
            switch char() {
            case .equal:
                advance()
                return .percentEqual
            default:
                return .percent
            }
        case .ampersand:
            advance()
            switch char() {
            case .ampersand:
                advance()
                switch char() {
                case .equal:
                    advance()
                    return .ampersandAmpersandEqual
                default:
                    return .ampersandAmpersand
                }
            case .equal:
                advance()
                return .ampersandEqual
            default:
                return .ampersand
            }
        case .leftParen:
            advance()
            return .leftParen
        case .rightParen:
            advance()
            return .rightParen
        case .asterisk:
            advance()
            switch char() {
            case .equal:
                advance()
                return .asteriskEqual
            default:
                return .asterisk
            }
        case .plus:
            advance()
            switch char() {
            case .plus:
                advance()
                return .plusPlus
            case .equal:
                advance()
                return .plusEqual
            default:
                return .plus
            }
        case .comma:
            advance()
            return .comma
        case .minus:
            advance()
            switch char() {
            case .minus:
                advance()
                return .minusMinus
            case .equal:
                advance()
                return .minusEqual
            default:
                return .minus
            }
        case .dot:
            advance()
            return .dot
        case .slash:
            advance()
            switch char() {
            case .equal:
                advance()
                return .slashEqual
            default:
                return .slash
            }
        case .colon:
            advance()
            return .colon
        case .semicolon:
            advance()
            return .semicolon
        case .leftAngleBracket:
            advance()
            switch char() {
            case .leftAngleBracket:
                advance()
                switch char() {
                case .equal:
                    advance()
                    return .leftAngleBracketLeftAngleBracketEqual
                default:
                    return .leftAngleBracketLeftAngleBracket
                }
            default:
                return .leftAngleBracket
            }
        case .equal:
            advance()
            switch char() {
            case .equal:
                advance()
                switch char() {
                case .equal:
                    advance()
                    return .equalEqualEqual
                default:
                    return .equalEqual
                }
            case .rightAngleBracket:
                advance()
                return .equalRightAngleBracket
            default:
                return .equal
            }
        case .rightAngleBracket:
            advance()
            switch char() {
            case .rightAngleBracket:
                advance()
                switch char() {
                case .equal:
                    advance()
                    return .rightAngleBracketRightAngleBracketEqual
                default:
                    return .rightAngleBracketRightAngleBracket
                }
            default:
                return .rightAngleBracket
            }
        case .question:
            advance()
            switch char() {
            case .dot:
                advance()
                return .questionDot
            case .question:
                advance()
                switch char() {
                case .equal:
                    advance()
                    return .questionQuestionEqual
                default:
                    return .questionQuestion
                }
            default:
                return .question
            }
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
            switch char() {
            case .equal:
                advance()
                return .pipeEqual
            case .pipe:
                advance()
                switch char() {
                case .equal:
                    advance()
                    return .pipePipeEqual
                default:
                    return .pipePipe
                }
            default:
                return .pipe
            }
        case .rightBrace:
            advance()
            return .rightBrace
        default:
            return nil
        }
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
                .underscore, .dollar: return true
        default: return false
        }
    }

    private func advance(position: inout String.Index) {
        position = string.index(after: position)
    }

    private mutating func advance() {
        advance(position: &pos)
    }

    private func char(at index: String.Index) -> Character? {
        if index == string.endIndex { return nil }
        return string[index]
    }

    private func char() -> Character? {
        char(at: pos)
    }
}
