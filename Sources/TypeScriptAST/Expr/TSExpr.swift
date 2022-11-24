public protocol TSExpr: TSStmt {

}

internal protocol _TSExpr: _TSStmt & TSExpr {}

extension TSExpr {
    public var asIdent: TSIdentExpr? { self as? TSIdentExpr }
    public var asNumberLiteral: TSNumberLiteralExpr? { self as? TSNumberLiteralExpr }
}
