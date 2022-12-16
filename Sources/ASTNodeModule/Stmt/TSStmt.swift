public protocol TSStmt: ASTNode {

}

internal protocol _TSStmt: _ASTNode & TSStmt {}

extension TSStmt {
    // @codegen(as)
    public var asBlock: TSBlockStmt? { self as? TSBlockStmt }
    public var asCase: TSCaseStmt? { self as? TSCaseStmt }
    public var asCatch: TSCatchStmt? { self as? TSCatchStmt }
    public var asDefault: TSDefaultStmt? { self as? TSDefaultStmt }
    public var asFinally: TSFinallyStmt? { self as? TSFinallyStmt }
    public var asForIn: TSForInStmt? { self as? TSForInStmt }
    public var asIf: TSIfStmt? { self as? TSIfStmt }
    public var asReturn: TSReturnStmt? { self as? TSReturnStmt }
    public var asSwitch: TSSwitchStmt? { self as? TSSwitchStmt }
    public var asThrow: TSThrowStmt? { self as? TSThrowStmt }
    public var asTry: TSTryStmt? { self as? TSTryStmt }
    // @end
}
