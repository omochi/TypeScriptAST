public final class TSIdentExpr: _TSExpr {
    public init(_ name: String) {
        self.name = name
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var name: String

    public static var null: TSIdentExpr { TSIdentExpr("null") }
    public static var undefined: TSIdentExpr { TSIdentExpr("undefined") }
    public static var void: TSIdentExpr { TSIdentExpr("void") }
    public static var never: TSIdentExpr { TSIdentExpr("never") }
    public static var `true`: TSIdentExpr { TSIdentExpr("true") }
    public static var `false`: TSIdentExpr { TSIdentExpr("false") }
}
