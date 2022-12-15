public final class TSBooleanLiteralExpr: _TSExpr {
    public init(_ value: Bool) {
        self.value = value
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var value: Bool

    public static var `true`: TSBooleanLiteralExpr { Self(true) }
    public static var `false`: TSBooleanLiteralExpr { Self(false) }
}
