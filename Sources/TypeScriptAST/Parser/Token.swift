public enum Token: Equatable & CustomStringConvertible & CustomDebugStringConvertible {
    case keyword(Keyword)
    case identifier(String)
    case symbol(Symbol)
    case stringLiteral(String)

    public var description: String {
        switch self {
        case .keyword(let x): return x.description
        case .identifier(let x): return x
        case .symbol(let x): return x.description
        case .stringLiteral(let x): return "\"" + Self.escapeStringLiteralContent(x) + "\""
        }
    }

    public var debugDescription: String {
        switch self {
        case .keyword(let x): return "keyword(\(x))"
        case .identifier(let x): return "identifier(\(x))"
        case .symbol(let x): return "symbol(\(x))"
        case .stringLiteral(let x): return "stringLiteral(\(x))"
        }
    }

    public static func escapeStringLiteralContent(_ string: String) -> String {
        var s = string
        s = s.replacingOccurrences(of: "\\", with: "\\\\")
        s = s.replacingOccurrences(of: "\"", with: "\\\"")
        s = s.replacingOccurrences(of: "\n", with: "\\n")
        return s
    }
}

