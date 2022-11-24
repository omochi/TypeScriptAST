public protocol TSStmt: ASTNode {

}

internal protocol _TSStmt: _ASTNode & TSStmt {}

extension TSStmt {
    public var asBlock: TSBlockStmt? { self as? TSBlockStmt }
    public var asReturn: TSReturnStmt? { self as? TSReturnStmt }
}
