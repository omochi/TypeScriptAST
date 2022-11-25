public final class TSIdentType: _TSType {
    public init(
        _ name: String,
        genericArgs: [any TSType] = []
    ) {
        self.name = name
        self.genericArgs = genericArgs
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var name: String
    @AnyTSTypeArrayStorage public var genericArgs: [any TSType]

    public static var null: TSIdentType { TSIdentType("null") }
    public static var undefined: TSIdentType { TSIdentType("undefined") }
    public static var void: TSIdentType { TSIdentType("void") }
    public static var never: TSIdentType { TSIdentType("never") }
    public static var any: TSIdentType { TSIdentType("any") }
    public static var unknown: TSIdentType { TSIdentType("unknown") }
    public static var boolean: TSIdentType { TSIdentType("boolean") }
    public static var number: TSIdentType { TSIdentType("number") }
    public static var string: TSIdentType { TSIdentType("string") }
    public static func promise(_ element: any TSType) -> TSIdentType {
        TSIdentType("Promise", genericArgs: [element])
    }
}
