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
            guard let c = char(at: pos) else { return nil }

            if isWhitespace(c) {
                readWhitespace()
                continue
            }

            if isKeyword(c) {
                return readKeyword()
            }

            pos = string.index(after: pos)
        }
    }

    private mutating func readWhitespace() {
        _ = readString(where: isWhitespace)
    }

    private mutating func readKeyword() -> Token {
        let s = readKeywordString()
        if let k = Keyword(rawValue: s) {
            return .keyword(k)
        }
        return .identifier(s)
    }

    private mutating func readKeywordString() -> String {
        readString(where: isKeyword)
    }

    private mutating func readString(where predicate: (Character) -> Bool) -> String {
        let start = pos
        while true {
            if let c = char(at: pos), predicate(c) {
                pos = string.index(after: pos)
                continue
            }
            return String(string[start..<pos])
        }
    }

    private func isWhitespace(_ c: Character) -> Bool {
        switch c {
        case .space, .tab, .lf, .cr, .crlf: return true
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

    private func char(at index: String.Index) -> Character? {
        if index == string.endIndex { return nil }
        return string[index]
    }
}
