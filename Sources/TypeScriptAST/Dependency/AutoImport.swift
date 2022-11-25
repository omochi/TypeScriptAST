extension TSSourceFile {
    public var imports: [TSImportDecl] {
        elements.compactMap { $0.asDecl?.asImport }
    }

    public func replaceImportDecls(list: [TSImportDecl]) {
        var elements = self.elements
        elements.removeAll { $0 is TSImportDecl }
        elements.insert(contentsOf: list, at: 0)
        self.elements = elements
    }

    public func buildAutoImportDecls(symbolTable: SymbolTable) throws -> [TSImportDecl] {
        var symbolTable = symbolTable

        var fileToSymbols = FileToSymbols()

        for `import` in self.imports {
            for symbol in `import`.names {
                fileToSymbols.add(file: `import`.from, symbol: symbol)
                symbolTable.add(symbol: symbol, file: .file(`import`.from))
            }
        }

        let symbols = self.scanDependency()
        for symbol in symbols {
            guard let file = symbolTable.find(symbol) else {
                throw MessageError("unknown symbol: \(symbol)")
            }

            switch file {
            case .standardLibrary: break
            case .file(let file):
                fileToSymbols.add(file: file, symbol: symbol)
            }
        }

        var imports: [TSImportDecl] = []

        for file in fileToSymbols.files.sorted() {
            let symbols = Set(fileToSymbols.symbols(for: file)).sorted()
            if symbols.isEmpty { continue }

            imports.append(
                TSImportDecl(names: symbols, from: file)
            )
        }

        return imports
    }
}

private struct FileToSymbols {
    var map: [String: [String]] = [:]

    var files: [String] {
        Array(map.keys)
    }

    func symbols(for file: String) -> [String] {
        map[file] ?? []
    }

    mutating func add(file: String, symbol: String) {
        var symbols = map[file] ?? []
        symbols.append(symbol)
        map[file] = symbols
    }
}
