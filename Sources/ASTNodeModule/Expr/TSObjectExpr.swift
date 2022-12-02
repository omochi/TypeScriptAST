public final class TSObjectExpr: _TSExpr {
    public enum Field {
        case named(name: String, value: any TSExpr)
        case namedWithVariable(varName: String)
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
                case .namedWithVariable:
                    break
                case .method(let decl):
                    decl.setParent(nil)
                }
            }
            _fields = newValue
            for field in newValue {
                switch field {
                case .named(_, let value):
                    value.setParent(self)
                case .namedWithVariable:
                    break
                case .method(let decl):
                    decl.setParent(self)
                }
            }
        }
    }
    private var _fields: [Field] = []
}
