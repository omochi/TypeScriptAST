public protocol ASTNodeBoxProtocol {
    associatedtype Value

    init(_ value: Value)
    var value: Value { get }

    var asASTNode: any ASTNode { get }
}

extension ASTNodeBoxProtocol {
    func setParent(_ parent: (any ASTNode)?) {
        asASTNode.setParent(parent)
    }
}
