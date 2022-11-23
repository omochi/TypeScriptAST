public final class TSArrayType: _TSType {
    public init(element: any TSType) {
        self.element = element
    }

    public private(set) unowned var parent: ASTNode?
    internal func _setParent(_ newValue: (ASTNode)?) {
        parent = newValue
    }

    @AnyTSTypeStorage public var element: any TSType
}
