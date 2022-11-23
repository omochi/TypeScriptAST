//public protocol ASTNode: AnyObject {
//    var parent: ASTNode? { get }
//}
//
public protocol ASTNode: AnyObject {
    var parent: ASTNode? { get }
}

extension ASTNode {
    func setParent(_ parent: (any ASTNode)?) {
        (self as! _ASTNode)._setParent(parent)
    }
}

internal protocol _ASTNode: ASTNode {
    func _setParent(_ newValue: (any ASTNode)?)
}
