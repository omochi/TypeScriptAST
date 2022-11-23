public protocol ASTNode: AnyObject {
    var parent: ASTNode? { get }
}

internal protocol _ASTNode: ASTNode {
    func _setParent(_ newValue: (any ASTNode)?)
}

extension ASTNode {
    internal func setParent(_ parent: (any ASTNode)?) {
        (self as! _ASTNode)._setParent(parent)
    }

    public func print() -> String {
        let printer = ASTPrinter()
        return printer.print(self)
    }
}


