public final class TSConditionalType: _TSType {
    public init(
        _ check: any TSType,
        extends: any TSType,
        `true`: any TSType,
        `false`: any TSType
    ) {
        self.check = check
        self.extends = extends
        self.true = `true`
        self.false = `false`
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @AnyTSTypeStorage public var check: any TSType
    @AnyTSTypeStorage public var extends: any TSType
    @AnyTSTypeStorage public var `true`: any TSType
    @AnyTSTypeStorage public var `false`: any TSType
}
