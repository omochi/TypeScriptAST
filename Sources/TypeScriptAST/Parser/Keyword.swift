public enum Keyword: String, Equatable & CustomStringConvertible {
    case `import`
    case from

    public var description: String {
        rawValue
    }
}
