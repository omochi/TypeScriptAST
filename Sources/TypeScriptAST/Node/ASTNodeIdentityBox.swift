public struct ASTNodeIdentityBox<Value: ASTNode>: ASTNodeBoxProtocol {
    public init(_ value: Value) {
        self.value = value
    }

    public var value: Value

    public var asASTNode: any ASTNode { value }
}
