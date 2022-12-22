public final class TSInferType: _TSType {
    public init(name: String) {
        self.name = name
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var name: String
}
