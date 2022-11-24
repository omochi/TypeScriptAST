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

@propertyWrapper
public struct GenericASTNodeOptionalStorage<Box: ASTNodeBoxProtocol> {
    public typealias Value = Box.Value?

    public init() {
        self.value = nil
    }

    @available(*, unavailable)
    public var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }

    private var value: Value

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
            object[keyPath: storageKeyPath].value
        }
        set {
            if let oldValue = object[keyPath: storageKeyPath].value {
                Box(oldValue).setParent(nil)
            }
            object[keyPath: storageKeyPath].value = newValue
            if let newValue {
                Box(newValue).setParent(object)
            }
        }
    }
}

@propertyWrapper
public struct GenericASTNodeArrayStorage<Box: ASTNodeBoxProtocol> {
    public typealias Value = [Box.Value]

    public init() {}

    @available(*, unavailable)
    public var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }

    private var value: (Value)?

    public func setParent(_ parent: any ASTNode) {
        guard let value else { return }
        for element in value {
            Box(element).setParent(parent)
        }
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
                for element in oldValue {
                    Box(element).setParent(nil)
                }
            }
            object[keyPath: storageKeyPath].value = newValue
            for element in newValue {
                Box(element).setParent(object)
            }
        }
    }
}

public typealias ASTNodeStorage<Value: ASTNode> = GenericASTNodeStorage<ASTNodeIdentityBox<Value>>
public typealias AnyASTNodeStorage = GenericASTNodeStorage<AnyASTNodeASTNodeBox>
public typealias AnyTSTypeStorage = GenericASTNodeStorage<AnyTSTypeASTNodeBox>
public typealias AnyTSExprStorage = GenericASTNodeStorage<AnyTSExprASTNodeBox>
public typealias AnyTSStmtStorage = GenericASTNodeStorage<AnyTSStmtASTNodeBox>
public typealias AnyTSDeclStorage = GenericASTNodeStorage<AnyTSDeclASTNodeBox>

public typealias ASTNodeOptionalStorage<Value: ASTNode> = GenericASTNodeOptionalStorage<ASTNodeIdentityBox<Value>>
public typealias AnyASTNodeOptionalStorage = GenericASTNodeOptionalStorage<AnyASTNodeASTNodeBox>
public typealias AnyTSTypeOptionalStorage = GenericASTNodeOptionalStorage<AnyTSTypeASTNodeBox>
public typealias AnyTSExprOptionalStorage = GenericASTNodeOptionalStorage<AnyTSExprASTNodeBox>
public typealias AnyTSStmtOptionalStorage = GenericASTNodeOptionalStorage<AnyTSStmtASTNodeBox>
public typealias AnyTSDeclOptionalStorage = GenericASTNodeOptionalStorage<AnyTSDeclASTNodeBox>

public typealias ASTNodeArrayStorage<Value: ASTNode> = GenericASTNodeArrayStorage<ASTNodeIdentityBox<Value>>
public typealias AnyASTNodeArrayStorage = GenericASTNodeArrayStorage<AnyASTNodeASTNodeBox>
public typealias AnyTSTypeArrayStorage = GenericASTNodeArrayStorage<AnyTSTypeASTNodeBox>
public typealias AnyTSExprArrayStorage = GenericASTNodeArrayStorage<AnyTSExprASTNodeBox>
public typealias AnyTSStmtArrayStorage = GenericASTNodeArrayStorage<AnyTSStmtASTNodeBox>
public typealias AnyTSDeclArrayStorage = GenericASTNodeArrayStorage<AnyTSDeclASTNodeBox>
