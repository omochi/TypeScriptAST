public final class TSGenericArgList: _ASTNodeCollection {
    public typealias Element = any TSType

    public init(_ elements: [Element] = []) {
        impl = .init(owner: self, elements: elements)
    }

    public internal(set) unowned var parent: (any ASTNode)?
    func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    // MARK: - template
    private var impl: AnyTSTypeCollectionImpl!
    public var elements: [Element] {
        get { impl.elements }
        set { impl.elements = newValue }
    }
    public subscript(position: Int) -> any TSType {
        get { impl[position] }
        set { impl[position] = newValue }
    }
    public var startIndex: Int { impl.startIndex }
    public var endIndex: Int { impl.endIndex }
    public func index(after i: Int) -> Int { impl.index(after: i) }
    public func index(before i: Int) -> Int { impl.index(before: i) }
}
