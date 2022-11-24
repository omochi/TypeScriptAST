public protocol TSExpr: TSStmt {

}

internal protocol _TSExpr: _TSStmt & TSExpr {}

extension TSExpr {
    public var asAs: TSAsExpr? { self as? TSAsExpr }
    public var asCall: TSCallExpr? { self as? TSCallExpr }
    public var asIdent: TSIdentExpr? { self as? TSIdentExpr }
    public var asInfixOperator: TSInfixOperatorExpr? { self as? TSInfixOperatorExpr }
    public var asNew: TSNewExpr? { self as? TSNewExpr }
    public var asNumberLiteral: TSNumberLiteralExpr? { self as? TSNumberLiteralExpr }
    public var asParen: TSParenExpr? { self as? TSParenExpr }
    public var asPrefixOperator: TSPrefixOperatorExpr? { self as? TSPrefixOperatorExpr }
    public var asStringLiteral: TSStringLiteralExpr? { self as? TSStringLiteralExpr }
}
