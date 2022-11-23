public final class TSUnionType: _TSType {
    public init(
        _ elements: [any TSType]
    ) {
        self.elements = elements
    }

    public internal(set) unowned var parent: (any ASTNode)?
    func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @AnyTSTypeArrayStorage public var elements: [any TSType]

    public static var null: TSNamedType { TSNamedType(name: "null") }
    public static var undefined: TSNamedType { TSNamedType(name: "undefined") }
    public static var void: TSNamedType { TSNamedType(name: "void") }
    public static var never: TSNamedType { TSNamedType(name: "never") }
    public static var any: TSNamedType { TSNamedType(name: "any") }
    public static var boolean: TSNamedType { TSNamedType(name: "boolean") }
    public static var number: TSNamedType { TSNamedType(name: "number") }
    public static var string: TSNamedType { TSNamedType(name: "string") }
}
