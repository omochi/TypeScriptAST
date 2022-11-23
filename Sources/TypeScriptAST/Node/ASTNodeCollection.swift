public protocol ASTNodeCollection:
    ASTNode & BidirectionalCollection
{
    var elements: [Element] { get set }
    subscript(index: Index) -> Element { get set }
}

internal protocol _ASTNodeCollection: _ASTNode & ASTNodeCollection {}
