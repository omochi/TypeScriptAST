public final class TSDictionaryType: _TSType {
    public init(value: any TSType) {
        self.value = value
    }

    public internal(set) unowned var parent: ASTNode?
    func _setParent(_ newValue: (ASTNode)?) {
        parent = newValue
    }

    @AnyTSTypeStorage var value: any TSType
}
