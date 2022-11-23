public enum TSVarKind: String {
    case const
    case `let`
    case `var`
}

public final class TSVarDecl: _TSDecl {
    public init(
        modifiers: [TSDeclModifier] = [],
        kind: TSVarKind,
        name: String,
        type: TSType? = nil,
        initializer: (any TSExpr)? = nil
    ) {
        self.modifiers = modifiers
        self.kind = kind
        self.name = name
        self.type = type
        self.initializer = initializer
    }

    public private(set) unowned var parent: ASTNode?
    internal func _setParent(_ newValue: (ASTNode)?) {
        parent = newValue
    }

    public var modifiers: [TSDeclModifier]
    public var kind: TSVarKind
    public var name: String
    @AnyTSTypeOptionalStorage public var type: (any TSType)?
    @AnyTSExprOptionalStorage public var initializer: (any TSExpr)?
}

