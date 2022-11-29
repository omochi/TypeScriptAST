public final class TSTryStmt: _TSStmt {
    public init(
        body: TSBlockStmt,
        catch: TSCatchStmt? = nil,
        finally: TSFinallyStmt? = nil
    ) {
        self.body = body
        self.catch = `catch`
        self.finally = finally
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @ASTNodeStorage public var body: TSBlockStmt
    @ASTNodeOptionalStorage public var `catch`: TSCatchStmt?
    @ASTNodeOptionalStorage public var finally: TSFinallyStmt?

}
