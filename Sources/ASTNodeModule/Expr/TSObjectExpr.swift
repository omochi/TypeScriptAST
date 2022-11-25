public final class TSObjectExpr: _TSExpr {
    public struct Field {
        public init(name: String, value: any TSExpr) {
            self.name = name
            self.value = value
        }
        public var name: String
        public var value: any TSExpr
    }

    public init(
        _ fields: [Field]
    ) {
        self.fields = fields
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var fields: [Field] {
        get { _fields }
        set {
            for field in _fields {
                field.value.setParent(nil)
            }
            _fields = newValue
            for field in newValue {
                field.value.setParent(self)
            }
        }
    }
    private var _fields: [Field] = []
}
