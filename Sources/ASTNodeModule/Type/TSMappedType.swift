public final class TSMappedType: _TSType {
    public enum ModifierOperation {
        case add
        case remove
    }

    public init(
        readonly: ModifierOperation? = nil,
        _ name: String,
        in constraint: any TSType,
        nameType: (any TSType)? = nil,
        optional: ModifierOperation? = nil,
        value: any TSType
    ) {
        self.readonly = readonly
        self.name = name
        self.constraint = constraint
        self.nameType = nameType
        self.optional = optional
        self.value = value
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var readonly: ModifierOperation?
    public var name: String
    @AnyTSTypeStorage public var constraint: any TSType
    @AnyTSTypeOptionalStorage public var nameType: (any TSType)?
    public var optional: ModifierOperation?
    @AnyTSTypeStorage public var value: any TSType
}
