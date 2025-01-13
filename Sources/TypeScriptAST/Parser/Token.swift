public enum Token: Equatable & CustomStringConvertible & CustomDebugStringConvertible {
    case keyword(Keyword)
    case identifier(String)
    case symbol(Symbol)

    public var description: String {
        switch self {
        case .keyword(let x): return x.description
        case .identifier(let x): return x
        case .symbol(let x): return x.description
        }
    }

    public var debugDescription: String {
        switch self {
        case .keyword(let x): return "keyword(\(x))"
        case .identifier(let x): return "identifier(\(x))"
        case .symbol(let x): return "symbol(\(x))"
        }
    }
}

