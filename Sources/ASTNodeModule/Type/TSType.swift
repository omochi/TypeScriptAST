public protocol TSType: ASTNode {

}

internal protocol _TSType: _ASTNode & TSType {}

extension TSType {
    // @codegen(as)
    public var asArray: TSArrayType? { self as? TSArrayType }
    public var asConditional: TSConditionalType? { self as? TSConditionalType }
    public var asCustom: TSCustomType? { self as? TSCustomType }
    public var asDictionary: TSDictionaryType? { self as? TSDictionaryType }
    public var asFunction: TSFunctionType? { self as? TSFunctionType }
    public var asIdent: TSIdentType? { self as? TSIdentType }
    public var asIntersection: TSIntersectionType? { self as? TSIntersectionType }
    public var asMember: TSMemberType? { self as? TSMemberType }
    public var asObject: TSObjectType? { self as? TSObjectType }
    public var asStringLiteral: TSStringLiteralType? { self as? TSStringLiteralType }
    public var asUnion: TSUnionType? { self as? TSUnionType }
    // @end
}
