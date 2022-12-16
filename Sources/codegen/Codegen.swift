import Foundation
import CodeTemplate

@main
struct Codegen {
    static func main() throws {
        try Codegen().run()
    }

    func run() throws {
        var args = CommandLine.arguments
        args.removeFirst()
        guard let sourcesDirString = args.first else {
            throw MessageError("no sources dir")
        }
        args.removeFirst()
        let sourcesDir = URL(fileURLWithPath: sourcesDirString)

        try enumrateDirectory(sourcesDir) { (file) in
            print(file.relativePath)
        }
    }
}
