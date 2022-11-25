public final class TSSourceFile: _TSDecl {
    public init(_ elements: [any ASTNode]) {
        self.elements = elements
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @AnyASTNodeArrayStorage public var elements: [any ASTNode]
}
