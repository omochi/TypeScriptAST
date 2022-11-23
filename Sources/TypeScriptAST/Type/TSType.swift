public protocol TSType: ASTNode {
    
}

internal protocol _TSType: _ASTNode & TSType {}

extension TSType {
    public var orNull: TSUnionType {
        TSUnionType([self, TSNamedType.null])
    }

    public var orUndefined: TSUnionType {
        TSUnionType([self, TSNamedType.undefined])
    }

    public var asArray: TSArrayType? { self as? TSArrayType }
    public var asDictionary: TSDictionaryType? { self as? TSDictionaryType }
    public var asFunction: TSFunctionType? { self as? TSFunctionType }
    public var asNamed: TSNamedType? { self as? TSNamedType }
    public var asNested: TSNestedType? { self as? TSNestedType }
    public var asRecord: TSRecordType? { self as? TSRecordType }
    public var asStringLiteral: TSStringLiteralType? { self as? TSStringLiteralType }
    public var asUnion: TSUnionType? { self as? TSUnionType }
}
