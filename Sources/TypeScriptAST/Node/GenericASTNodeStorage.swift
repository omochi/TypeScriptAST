@propertyWrapper
public struct GenericASTNodeStorage<Box: ASTNodeBoxProtocol> {
    public typealias Value = Box.Value

    public init() {}

    @available(*, unavailable) 
    public var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }

    private var value: (Value)?

    public func setParent(_ parent: any ASTNode) {
        guard let value else { return }
        Box(value).setParent(parent)
    }

    public static subscript<EnclosingSelf: ASTNode>(
        _enclosingInstance object: EnclosingSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Self>
    ) -> Value {
        get {
            object[keyPath: storageKeyPath].value!
        }
        set {
            if let oldValue = object[keyPath: storageKeyPath].value {
                Box(oldValue).setParent(nil)
            }
            object[keyPath: storageKeyPath].value = newValue
            Box(newValue).setParent(object)
        }
    }
}

public typealias ASTNodeStorage<Value: ASTNode> = GenericASTNodeStorage<ASTNodeIdentityBox<Value>>
public typealias AnyTSTypeStorage = GenericASTNodeStorage<AnyTSTypeASTNodeBox>
