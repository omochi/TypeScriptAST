public final class TSTypeParameterNode: _ASTNode {
    public init(
        _ name: String,
        extends constraint: (any TSType)? = nil,
        default: (any TSType)? = nil
    ) {
        self.name = name
        self.constraint = constraint
        self.default = `default`
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var name: String
    @AnyTSTypeOptionalStorage public var constraint: (any TSType)?
    @AnyTSTypeOptionalStorage public var `default`: (any TSType)?
}
