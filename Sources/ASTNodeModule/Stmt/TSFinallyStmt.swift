public final class TSFinallyStmt: _TSStmt {
    public init(
        body: TSBlockStmt
    ) {
        self.body = body
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @ASTNodeStorage public var body: TSBlockStmt
}
