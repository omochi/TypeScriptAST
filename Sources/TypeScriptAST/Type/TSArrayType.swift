public final class TSArrayType: _TSType {
    public init(element: any TSType) {
        self.element = element
    }

    public internal(set) unowned var parent: ASTNode?
    func _setParent(_ newValue: (ASTNode)?) {
        parent = newValue
    }

    @AnyTSTypeStorage var element: any TSType
}
