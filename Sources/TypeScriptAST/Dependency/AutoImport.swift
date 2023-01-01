import Foundation

extension TSSourceFile {
    public var imports: [TSImportDecl] {
        elements.compactMap { $0.asDecl?.asImport }
    }

    public func replaceImportDecls(_ imports: [TSImportDecl]) {
        var elements = self.elements
        elements.removeAll { $0 is TSImportDecl }
        elements.insert(contentsOf: imports, at: 0)
        self.elements = elements
    }

    public func buildAutoImportDecls(
        from: URL,
        symbolTable: SymbolTable,
        fileExtension: ImportFileExtension,
        defaultFile: String? = nil
    ) throws -> [TSImportDecl] {
        var fileToSymbols = FileToSymbols()

        var originalSymbols: Set<String> = []
        for `import` in self.imports {
            for symbol in `import`.names {
                fileToSymbols.add(file: `import`.from, symbol: symbol)
                originalSymbols.insert(symbol)
            }
        }

        let symbols = self.scanDependency()
        for symbol in symbols {
            if originalSymbols.contains(symbol) {
                continue
            }

            if let file = symbolTable.find(symbol) {
                switch file {
                case .standardLibrary: break
                case .file(let file):
                    let path = resolveImportPath(from: from, file: file, extension: fileExtension)
                    fileToSymbols.add(
                        file: path.toImportFile(),
                        symbol: symbol
                    )
                }
                continue
            }

            if let defaultFile {
                fileToSymbols.add(file: defaultFile, symbol: symbol)
                continue
            } else {
                throw MessageError("unknown symbol: \(symbol)")
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

extension URL {
    fileprivate func toImportFile() -> String {
        if self.baseURL == nil { return self.path }

        var path = self.relativePath
        if !path.hasPrefix(".") {
            path = "./" + path
        }
        return path
    }
}

private func resolveImportPath(
    from: URL, file: URL, extension: ImportFileExtension
) -> URL {
    let file = modifyTSExtension(file: file, extension: `extension`)
    return file.relativePath(from: from.deletingLastPathComponent())
}

private func modifyTSExtension(file: URL, extension: ImportFileExtension) -> URL {
    let dir = file.deletingLastPathComponent()

    var base = file.lastPathComponent
    let stem = (base as NSString).deletingPathExtension

    guard (base as NSString).pathExtension == "ts" else {
        return file
    }

    switch `extension` {
    case .none: base = stem
    case .js: base = stem + ".js"
    }

    return dir.appendingPathComponent(base)
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
