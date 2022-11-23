struct GenericASTNodeCollectionImpl<Box: ASTNodeBoxProtocol>: BidirectionalCollection {
    typealias Element = Box.Value

    init(owner: any ASTNode, elements: [Element]) {
        _owner = owner
        _elements = elements
    }

    private unowned let _owner: any ASTNode
    private var _elements: [Element] = []

    subscript(index: Int) -> Element {
        get { _elements[index] }
        set {
            Box(_elements[index]).setParent(nil)
            _elements[index] = newValue
            Box(_elements[index]).setParent(_owner)
        }
    }

    var elements: [Element] {
        get { _elements }
        set {
            for element in _elements {
                Box(element).setParent(nil)
            }
            _elements = newValue
            for element in _elements {
                Box(element).setParent(_owner)
            }
        }
    }

    var startIndex: Int { _elements.startIndex }
    var endIndex: Int { _elements.endIndex }
    func index(after index: Int) -> Int { _elements.index(after: index) }
    func index(before index: Int) -> Int { _elements.index(before: index) }
}

typealias AnyTSTypeCollectionImpl = GenericASTNodeCollectionImpl<AnyTSTypeASTNodeBox>
