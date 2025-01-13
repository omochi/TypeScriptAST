public struct Parser {
    public init(string: String) {
        self.tokenizer = Tokenizer(string: string)
    }

    private var tokenizer: Tokenizer

    public mutating func parse() -> TSSourceFile {
        var es: [any ASTNode] = []
        while let e = parseElement() {
            es.append(e)
        }
        return TSSourceFile(es)
    }

    public mutating func parseElement() -> (any ASTNode)? {
        while true {
            switch nextToken {
            case nil: return nil
            case .keyword(let k):
                switch k {
                case .import:
                    if let x = parseImport() {
                        return x
                    }
                default:
                    print("skip keyword: \(k)")
                    readToken()
                }
            default:
                if let x = parseExpression() {
                    return x
                }
            }
        }
    }

    private mutating func parseImport() -> TSImportDecl? {
        let imp = readToken()
        guard imp == .keyword(.import) else { return nil }
        let lb = readToken()
        guard lb == .symbol(.leftBrace) else { return nil }
        var names: [String] = []
        loop: while true {
            guard let tk = readToken() else { return nil }
            switch tk {
            case .symbol(.rightBrace):
                break loop
            default:
                names.append(tk.description)
            }
        }
        let from = readToken()
        guard from == .keyword(.from) else { return nil }
        let pathToken = readToken()
        guard case .stringLiteral(let path) = pathToken else { return nil }
        return TSImportDecl(names: names, from: path)
    }

    private mutating func parseExpression() -> (any ASTNode)? {
        readToken()
        return nil
    }

    @discardableResult
    private mutating func readToken() -> Token? {
        tokenizer.read()
    }

    private var nextToken: Token? {
        tokenizer.nextToken
    }
}
