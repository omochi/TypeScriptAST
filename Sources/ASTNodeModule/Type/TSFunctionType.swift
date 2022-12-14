public final class TSFunctionType: _TSType {
    public struct Param {
        public init(
            spread: Bool = false,
            name: String,
            isOptional: Bool = false,
            type: (any TSType)? = nil
        ) {
            self.spread = spread
            self.name = name
            self.isOptional = isOptional
            self.type = type
        }

        public var spread: Bool
        public var name: String
        public var isOptional: Bool
        public var type: (any TSType)?
    }

    public init(
        genericParams: [TSTypeParameterNode] = [],
        params: [Param],
        result: any TSType
    ) {
        self.genericParams = genericParams
        self.params = params
        self.result = result
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @ASTNodeArrayStorage public var genericParams: [TSTypeParameterNode]
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
    public var _params: [Param] = []
    @AnyTSTypeStorage public var result: any TSType
}
