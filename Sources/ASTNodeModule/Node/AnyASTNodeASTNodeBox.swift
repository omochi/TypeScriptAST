public struct AnyASTNodeASTNodeBox: ASTNodeBoxProtocol {
    public typealias Value = any ASTNode

    public init(_ value: any ASTNode) {
        self.value = value
    }

    public var value: any ASTNode

    public var asASTNode: any ASTNode {
        value
    }
}
