public enum TSForInOperator: String {
    case `in`
    case of
}

public final class TSForInStmt: _TSStmt {
    public init(
        kind: TSVarKind,
        name: String,
        `operator`: TSForInOperator,
        expr: any TSExpr,
        body: any TSStmt
    ) {
        self.kind = kind
        self.name = name
        self.operator = `operator`
        self.expr = expr
        self.body = body
    }

    public private(set) unowned var parent: ASTNode?
    internal func _setParent(_ newValue: (ASTNode)?) {
        parent = newValue
    }

    public var kind: TSVarKind
    public var name: String
    public var `operator`: TSForInOperator
    @AnyTSExprStorage public var expr: any TSExpr
    @AnyTSStmtStorage public var body: any TSStmt
}
