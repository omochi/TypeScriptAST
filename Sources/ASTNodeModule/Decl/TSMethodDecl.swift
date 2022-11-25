public final class TSMethodDecl: _TSDecl {
    public init(
        modifiers: [TSDeclModifier] = [],
        name: String,
        genericParams: [String] = [],
        params: [TSFunctionType.Param],
        result: (any TSType)? = nil,
        block: TSBlockStmt? = nil
    ) {
        self.modifiers = modifiers
        self.name = name
        self.genericParams = genericParams
        self.params = params
        self.result = result
        self.block = block
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
    @ASTNodeOptionalStorage public var block: TSBlockStmt?
}