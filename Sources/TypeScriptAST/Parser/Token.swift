public enum Token: Equatable & CustomDebugStringConvertible {
    case keyword(Keyword)
    case identifier(String)
    case symbol(Symbol)

    public var debugDescription: String {
        switch self {
        case .keyword(let x): return "keyword(\(x))"
        case .identifier(let x): return "identifier(\(x))"
        case .symbol(let x): return "symbol(\(x))"
        }
    }
}

