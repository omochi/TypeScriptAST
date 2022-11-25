public protocol ASTNode: AnyObject {
    var parent: (any ASTNode)? { get }
}

internal protocol _ASTNode: ASTNode {
    func _setParent(_ newValue: (any ASTNode)?)
}

extension ASTNode {
    internal func setParent(_ parent: (any ASTNode)?) {
        (self as! _ASTNode)._setParent(parent)
    }

    public var asType: (any TSType)? { self as? any TSType }
    public var asExpr: (any TSExpr)? { self as? any TSExpr }
    public var asStmt: (any TSStmt)? { self as? any TSStmt }
    public var asDecl: (any TSDecl)? { self as? any TSDecl }
}


