public final class TSDictionaryType: _TSType {
    public init(value: any TSType) {
        self.value = value
    }

    public private(set) unowned var parent: ASTNode?
    internal func _setParent(_ newValue: (ASTNode)?) {
        parent = newValue
    }

    @AnyTSTypeStorage public var value: any TSType
}
