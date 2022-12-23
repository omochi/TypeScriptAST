public final class TSKeyofType: _TSType {
    public init(_ type: any TSType) {
        self.type = type
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @AnyTSTypeStorage public var type: any TSType
}
