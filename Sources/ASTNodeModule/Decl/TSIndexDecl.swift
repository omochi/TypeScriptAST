public final class TSIndexDecl: _TSDecl {
    public enum IndexKind: String {
        case number
        case string
        case symbol
    }

    public init(
        name: String,
        kind: IndexKind,
        type: any TSType
    ) {
        self.name = name
        self.kind = kind
        self.type = type
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var name: String
    public var kind: IndexKind
    @AnyTSTypeStorage public var type: any TSType
}
