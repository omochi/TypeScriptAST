public final class TSCatchStmt: _TSStmt {
    public init(
        name: String? = nil,
        body: TSBlockStmt
    ) {
        self.name = name
        self.body = body
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var name: String?
    @ASTNodeStorage public var body: TSBlockStmt
}
