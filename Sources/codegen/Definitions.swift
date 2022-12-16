struct Decl {
    init(
        _ stem: String,
        _ name: String? = nil
    ) {
        self.stem = stem
        self.typeName = name ?? Self.defaultTypeName(stem: stem)
    }

    var stem: String
    var typeName: String

    static func defaultTypeName(stem: String) -> String {
        return "TS" + stem.capitalized + "Decl"
    }
}

struct Definitions {
    var decls: [Decl] = [
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
}




