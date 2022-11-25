public struct AnyTSExprASTNodeBox: ASTNodeBoxProtocol {
    public typealias Value = any TSExpr

    public init(_ value: any TSExpr) {
        self.value = value
    }

    public var value: any TSExpr

    public var asASTNode: any ASTNode {
        value as any ASTNode
    }
}
