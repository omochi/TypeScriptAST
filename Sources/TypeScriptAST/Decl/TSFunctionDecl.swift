public final class TSFunctionDecl: _TSDecl {
    public struct Param {
        public var name: String
        public var type: (any TSType)?

        public init(
            name: String,
            type: (any TSType)?
        ) {
            self.name = name
            self.type = type
        }
    }

    public init(
        modifiers: [TSDeclModifier] = [],
        name: String,
        genericParams: [String] = [],
        parameters: [Param],
        result: (any TSType)?,
        body: (any TSStmt)?
    ) {
        self.modifiers = modifiers
        self.name = name
        self.genericParams = genericParams
        self._params = params
        self.result = result
        self.body = body
    }

    public private(set) unowned var parent: ASTNode?
    internal func _setParent(_ newValue: (ASTNode)?) {
        parent = newValue
    }

    public var modifiers: [TSDeclModifier]
    public var name: String
    public var genericParams: [String]
    public var params: [Param] {
        get { _params }
        set {
            for param in _params {
                param.type?.setParent(nil)
            }
            _params = newValue
            for param in newValue {
                param.type?.setParent(self)
            }
        }
    }
    private var _params: [Param] = []
    @AnyTSTypeOptionalStorage public var result: (any TSType)?
    @AnyTSStmtOptionalStorage public var body: (any TSStmt)?
}
