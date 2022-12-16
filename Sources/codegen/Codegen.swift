import Foundation
import CodeTemplate
import SwiftFormat
import SwiftFormatConfiguration

@main
struct Codegen {
    static func main() throws {
        try Codegen().run()
    }

    init() {
        self.definitions = Definitions()
        self.formatterConfiguration = Self.makeFormatterCondiguration()
        self.rendererTypes = [
            DeclRenderer.self,
            ExprRenderer.self
        ]
    }

    var definitions: Definitions
    var formatterConfiguration: SwiftFormatConfiguration.Configuration
    var rendererTypes: [any Renderer.Type]

    static func makeFormatterCondiguration() -> SwiftFormatConfiguration.Configuration {
        var c = SwiftFormatConfiguration.Configuration()
        c.lineLength = 10000
        c.indentation = .spaces(4)
        return c
    }

    func run() throws {
        var args = CommandLine.arguments
        args.removeFirst()
        guard let sourcesDirString = args.first else {
            throw MessageError("no sources dir")
        }
        args.removeFirst()
        let sourcesDir = URL(fileURLWithPath: sourcesDirString)

        let fm = FileManager.default
        try enumrateDirectory(sourcesDir, fileManager: fm) { (file) in
            var isDir = ObjCBool(false)
            guard fm.fileExists(atPath: file.path, isDirectory: &isDir),
                  !isDir.boolValue else { return }

            if file.lastPathComponent.hasSuffix(".swift") {
                try render(file: file)
            }
        }
    }

    func render(file: URL) throws {
        for rendererType in rendererTypes {
            if rendererType.isTarget(file: file) {
                let writer = Writer(
                    definitions: definitions,
                    formatter: SwiftFormatter(configuration: formatterConfiguration),
                    file: file
                )
                try rendererType.init(writer: writer).render()
            }
        }
    }
}
