public final class TSTemplateLiteralExpr: _TSExpr {
    public enum Fragment {
        case literal(String)
        case expr(any TSExpr)
    }

    public struct StringInterpolation {
        var fragments: [Fragment]
    }

    public init(tag: String? = nil, _ stringInterpolation: StringInterpolation) {
        self.tag = tag
        self.fragments = stringInterpolation.fragments
        self.substitutions = fragments.substitutions
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var tag: String?
    public var fragments: [Fragment] {
        didSet {
            substitutions = fragments.substitutions
        }
    }
    @AnyTSExprArrayStorage public private(set) var substitutions: [any TSExpr]
}

extension TSTemplateLiteralExpr.StringInterpolation: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        fragments = [.literal(value)]
    }
}

extension TSTemplateLiteralExpr.StringInterpolation: ExpressibleByStringInterpolation {
    public init(stringInterpolation: Self) {
        fragments = stringInterpolation.fragments
    }
}

extension TSTemplateLiteralExpr.StringInterpolation: StringInterpolationProtocol {
    public init(literalCapacity: Int, interpolationCount: Int) {
        fragments = []
    }

    public mutating func appendLiteral(_ literal: String) {
        fragments.append(.literal(literal))
    }

    public mutating func appendInterpolation(_ expr: any TSExpr) {
        fragments.append(.expr(expr))
    }

    public mutating func appendInterpolation(ident: String) {
        fragments.append(.expr(TSIdentExpr(ident)))
    }
}

extension [TSTemplateLiteralExpr.Fragment] {
    public var substitutions: [any TSExpr] {
        compactMap { elem in
            if case .expr(let expr) = elem {
                return expr
            }
            return nil
        }
    }
}
