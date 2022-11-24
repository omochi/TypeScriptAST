public final class TSIdentType: _TSType {
    public init(
        name: String,
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

    public static var null: TSIdentType { TSIdentType(name: "null") }
    public static var undefined: TSIdentType { TSIdentType(name: "undefined") }
    public static var void: TSIdentType { TSIdentType(name: "void") }
    public static var never: TSIdentType { TSIdentType(name: "never") }
    public static var any: TSIdentType { TSIdentType(name: "any") }
    public static var boolean: TSIdentType { TSIdentType(name: "boolean") }
    public static var number: TSIdentType { TSIdentType(name: "number") }
    public static var string: TSIdentType { TSIdentType(name: "string") }
    public static func promise(_ element: any TSType) -> TSIdentType {
        TSIdentType(name: "Promise", genericArgs: [element])
    }
}
