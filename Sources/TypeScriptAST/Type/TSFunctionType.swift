public final class TSFunctionType: _TSType {
    public struct Param {
        public init(
            name: String,
            type: (any TSType)?
        ) {
            self.name = name
            self.type = type
        }

        public var name: String
        public var type: (any TSType)?
    }

    public init(
        params: [Param],
        result: any TSType
    ) {
        self.params = params
        self.result = result
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

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
