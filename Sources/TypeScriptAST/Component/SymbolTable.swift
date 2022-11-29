public struct SymbolTable {
    public enum File {
        case standardLibrary
        case file(String)
    }

    public init(
        standardLibrarySymbols: Set<String> = Self.standardLibrarySymbols
    ) {
        for symbol in standardLibrarySymbols {
            add(symbol: symbol, file: .standardLibrary)
        }
    }

    public static let standardLibrarySymbols: Set<String> = [
        "null",
        "undefined",
        "void",
        "never",
        "any",
        "unknown",
        "boolean",
        "true",
        "false",
        "number",
        "string",
        "this",
        "Promise",
        "Error",
        "Date"
    ]

    public var table: [String: File] = [:]

    public mutating func add(symbol: String, file: File) {
        table[symbol] = file
    }

    public mutating func add(source: TSSourceFile, file: String) {
        for symbol in source.memberDeclaredNames {
            add(symbol: symbol, file: .file(file))
        }
    }

    public func find(_ symbol: String) -> File? {
        table[symbol]
    }
}
