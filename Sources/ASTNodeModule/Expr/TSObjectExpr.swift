public final class TSObjectExpr: _TSExpr {
    public enum Field {
        case named(name: String, value: any TSExpr)
        case shorthandPropertyNames(name: String)
        case computedPropertyNames(name: any TSExpr, value: any TSExpr)
        case method(TSMethodDecl)
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
                switch field {
                case .named(_, let value):
                    value.setParent(nil)
                case .shorthandPropertyNames:
                    break
                case .computedPropertyNames(let name, let value):
                    name.setParent(nil)
                    value.setParent(nil)
                case .method(let decl):
                    decl.setParent(nil)
                }
            }
            _fields = newValue
            for field in newValue {
                switch field {
                case .named(_, let value):
                    value.setParent(self)
                case .shorthandPropertyNames:
                    break
                case .computedPropertyNames(let name, let value):
                    name.setParent(self)
                    value.setParent(self)
                case .method(let decl):
                    decl.setParent(self)
                }
            }
        }
    }
    private var _fields: [Field] = []
}
