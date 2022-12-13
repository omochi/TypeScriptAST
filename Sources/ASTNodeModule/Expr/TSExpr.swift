public protocol TSExpr: TSStmt {

}

internal protocol _TSExpr: _TSStmt & TSExpr {}

extension TSExpr {
    public var asArray: TSArrayExpr? { self as? TSArrayExpr }
    public var asAs: TSAsExpr? { self as? TSAsExpr }
    public var asAssign: TSAssignExpr? { self as? TSAssignExpr }
    public var asAwait: TSAwaitExpr? { self as? TSAwaitExpr }
    public var asCall: TSCallExpr? { self as? TSCallExpr }
    public var asClosure: TSClosureExpr? { self as? TSClosureExpr }
    public var asCustom: TSCustomExpr? { self as? TSCustomExpr }
    public var asIdent: TSIdentExpr? { self as? TSIdentExpr }
    public var asInfixOperator: TSInfixOperatorExpr? { self as? TSInfixOperatorExpr }
    public var asMember: TSMemberExpr? { self as? TSMemberExpr }
    public var asNew: TSNewExpr? { self as? TSNewExpr }
    public var asNumberLiteral: TSNumberLiteralExpr? { self as? TSNumberLiteralExpr }
    public var asObject: TSObjectExpr? { self as? TSObjectExpr }
    public var asParen: TSParenExpr? { self as? TSParenExpr }
    public var asPostfixOperator: TSPostfixOperatorExpr? { self as? TSPostfixOperatorExpr }
    public var asPrefixOperator: TSPrefixOperatorExpr? { self as? TSPrefixOperatorExpr }
    public var asStringLiteral: TSStringLiteralExpr? { self as? TSStringLiteralExpr }
    public var asTemplateLiteral: TSTemplateLiteralExpr? { self as? TSTemplateLiteralExpr }
    public var asSubscript: TSSubscriptExpr? { self as? TSSubscriptExpr }
}
