public final class TSIndexedAccessType: _TSType {
    internal init(parent: (ASTNode)?, base: TSType, index: TSType) {
        self.parent = parent
        self.base = base
        self.index = index
    }
    
    public init(
        _ base: any TSType,
        index: any TSType
    ) {
        self.base = base
        self.index = index
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @AnyTSTypeStorage public var base: any TSType
    @AnyTSTypeStorage public var index: any TSType
}
