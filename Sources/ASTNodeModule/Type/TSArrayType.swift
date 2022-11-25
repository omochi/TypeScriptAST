public final class TSArrayType: _TSType {
    public init(_ element: any TSType) {
        self.element = element
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @AnyTSTypeStorage public var element: any TSType
}
