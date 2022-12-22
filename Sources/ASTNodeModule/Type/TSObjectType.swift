public final class TSObjectType: _TSType {
    public enum Field {
        case field(TSFieldDecl)
        case method(TSMethodDecl)
        case index(TSIndexDecl)
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
                switch field {
                case .field(let decl):
                    decl.setParent(nil)
                case .method(let decl):
                    decl.setParent(nil)
                case .index(let decl):
                    decl.setParent(nil)
                }
            }
            _fields = newValue
            for field in newValue {
                switch field {
                case .field(let decl):
                    decl.setParent(self)
                case .method(let decl):
                    decl.setParent(self)
                case .index(let decl):
                    decl.setParent(self)
                }
            }
        }
    }

    private var _fields: [Field] = []
}
