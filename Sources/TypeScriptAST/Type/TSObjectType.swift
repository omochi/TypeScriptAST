public final class TSObjectType: _TSType {
    public struct Field {
        public init(
            name: String,
            type: any TSType,
            isOptional: Bool = false
        ) {
            self.name = name
            self.type = type
            self.isOptional = isOptional
        }

        public var name: String
        public var type: any TSType
        public var isOptional: Bool
    }

    public init(_ fields: [Field]) {
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
                field.type.setParent(nil)
            }
            _fields = newValue
            for field in newValue {
                field.type.setParent(self)
            }
        }
    }

    private var _fields: [Field] = []
}

