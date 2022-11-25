public struct AnyTSDeclASTNodeBox: ASTNodeBoxProtocol {
    public typealias Value = any TSDecl

    public init(_ value: any TSDecl) {
        self.value = value
    }

    public var value: any TSDecl

    public var asASTNode: any ASTNode {
        value as any ASTNode
    }
}
