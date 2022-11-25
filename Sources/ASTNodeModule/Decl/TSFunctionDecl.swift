public final class TSFunctionDecl: _TSDecl {
    public init(
        modifiers: [TSDeclModifier] = [],
        name: String,
        genericParams: [String] = [],
        params: [TSFunctionType.Param],
        result: (any TSType)? = nil,
        body: TSBlockStmt
    ) {
        self.modifiers = modifiers
        self.name = name
        self.genericParams = genericParams
        self._params = params
        self.result = result
        self.body = body
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var modifiers: [TSDeclModifier]
    public var name: String
    public var genericParams: [String]
    public var params: [TSFunctionType.Param] {
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
    private var _params: [TSFunctionType.Param] = []
    @AnyTSTypeOptionalStorage public var result: (any TSType)?
    @ASTNodeStorage public var body: TSBlockStmt
}
