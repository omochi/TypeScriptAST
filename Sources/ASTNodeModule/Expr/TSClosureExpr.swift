public final class TSClosureExpr: _TSExpr {
    public init(
        genericParams: [String] = [],
        hasParen: Bool = true,
        params: [TSFunctionType.Param],
        result: (any TSType)? = nil,
        body: any TSStmt
    ) {
        self.genericParams = genericParams
        self.hasParen = hasParen
        self.params = params
        self.result = result
        self.body = body
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var genericParams: [String]
    public var hasParen: Bool
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
    @AnyTSStmtStorage public var body: any TSStmt
}
