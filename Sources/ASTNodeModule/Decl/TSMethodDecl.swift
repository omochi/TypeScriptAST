public final class TSMethodDecl: _TSDecl {
    public init(
        modifiers: [TSDeclModifier] = [],
        name: String,
        isOptional: Bool = false,
        genericParams: [TSTypeParameterNode] = [],
        params: [TSFunctionType.Param],
        result: (any TSType)? = nil,
        body: TSBlockStmt? = nil
    ) {
        self.modifiers = modifiers
        self.name = name
        self.isOptional = isOptional
        self.genericParams = genericParams
        self.params = params
        self.result = result
        self.body = body
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var modifiers: [TSDeclModifier]
    public var name: String
    public var isOptional: Bool
    @ASTNodeArrayStorage public var genericParams: [TSTypeParameterNode]
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
    @ASTNodeOptionalStorage public var body: TSBlockStmt?
}
