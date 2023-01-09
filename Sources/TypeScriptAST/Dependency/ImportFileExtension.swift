public enum ImportFileExtension: CustomStringConvertible {
    case none
    case js
    case ts

    public var description: String {
        switch self {
        case .none: return ""
        case .js: return "js"
        case .ts: return "ts"
        }
    }
}
