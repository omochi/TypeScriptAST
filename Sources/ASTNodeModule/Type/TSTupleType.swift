public final class TSTupleType: _TSType {
    public init(_ elements: [any TSType]) {
        self.elements = elements
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @AnyTSTypeArrayStorage public var elements: [any TSType]
}
