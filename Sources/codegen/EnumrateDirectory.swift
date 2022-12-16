import Foundation

func enumrateDirectory(
    _ directory: URL,
    fileManager fm: FileManager = .default,
    body: (URL) throws -> Void
) throws {
    guard fm.changeCurrentDirectoryPath(directory.path) else {
        throw MessageError("failed to chdir: \(directory.path)")
    }

    guard let en = fm.enumerator(
        at: URL(fileURLWithPath: "."),
        includingPropertiesForKeys: nil,
        options: [.skipsHiddenFiles, .producesRelativePathURLs]
    ) else {
        throw MessageError("failed to enumerate")
    }

    for case let file as URL in en {
        try body(file)
    }
}
