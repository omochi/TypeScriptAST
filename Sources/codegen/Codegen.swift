import Foundation
import CodeTemplate

@main
struct Codegen {
    static func main() throws {
        try Codegen().run()
    }

    var definitions: Definitions = .init()
    var rendererTypes: [any Renderer.Type] = [
        DeclRenderer.self
    ]

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
            if let renderer = rendererType.init(definitions: definitions, file: file) {
                print("process: \(file.relativePath)")
                try renderer.render()
            }
        }
    }
}
