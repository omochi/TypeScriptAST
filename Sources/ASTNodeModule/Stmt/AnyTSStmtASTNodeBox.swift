public struct AnyTSStmtASTNodeBox: ASTNodeBoxProtocol {
    public typealias Value = any TSStmt

    public init(_ value: any TSStmt) {
        self.value = value
    }

    public var value: any TSStmt

    public var asASTNode: any ASTNode {
        value as any ASTNode
    }
}
