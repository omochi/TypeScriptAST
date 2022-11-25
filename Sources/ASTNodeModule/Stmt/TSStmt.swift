public protocol TSStmt: ASTNode {

}

internal protocol _TSStmt: _ASTNode & TSStmt {}

extension TSStmt {
    public var asBlock: TSBlockStmt? { self as? TSBlockStmt }
    public var asForIn: TSForInStmt? { self as? TSForInStmt }
    public var asIf: TSIfStmt? { self as? TSIfStmt }
    public var asReturn: TSReturnStmt? { self as? TSReturnStmt }
    public var asThrow: TSThrowStmt? { self as? TSThrowStmt }
}
