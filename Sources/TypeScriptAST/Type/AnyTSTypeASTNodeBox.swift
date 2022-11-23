public struct AnyTSTypeASTNodeBox: ASTNodeBoxProtocol {
    public typealias Value = any TSType

    public init(_ value: any TSType) {
        self.value = value
    }

    public var value: any TSType

    public var asASTNode: any ASTNode {
        value as any ASTNode
    }
}
