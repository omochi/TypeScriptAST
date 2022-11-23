public final class TSTypeDecl: _TSDecl {
    public init(
        modifiers: [TSDeclModifier] = [],
        name: String,
        genericParams: [String] = [],
        type: any TSType
    ) {
        self.modifiers = modifiers
        self.name = name
        self.genericParams = genericParams
        self.type = type
    }

    public private(set) unowned var parent: ASTNode?
    internal func _setParent(_ newValue: (ASTNode)?) {
        parent = newValue
    }

    public var modifiers: [TSDeclModifier]
    public var name: String
    public var genericParams: [String]
    @AnyTSTypeStorage public var type: any TSType
}
