public final class TSNestedType: _TSType {
    public init(
        namespace: String,
        type: any TSType
    ) {
        self.namespace = namespace
        self.type = type
    }

    public internal(set) unowned var parent: (any ASTNode)?
    func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var namespace: String
    @AnyTSTypeStorage public var type: any TSType
}
