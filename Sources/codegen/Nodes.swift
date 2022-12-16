struct Decl {
    init(
        _ prefix: String,
        _ name: String? = nil
    ) {
        self.prefix = prefix
        self.name = name ?? Self.defaultName(prefix: prefix)
    }

    var prefix: String
    var name: String

    static func defaultName(prefix: String) -> String {
        return "TS" + prefix.capitalized + "Decl"
    }
}

let decls: [Decl] = [
    .init("class"),
    .init("field"),
    .init("function"),
    .init("import"),
    .init("interface"),
    .init("method"),
    .init("namespace"),
    .init("source", "TSSourceFile"),
    .init("type"),
    .init("var")
]


