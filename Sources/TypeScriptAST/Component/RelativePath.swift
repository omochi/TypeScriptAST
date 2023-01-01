import Foundation

extension URL {
    /*
     Modified implementation of
     https://github.com/neoneye/SwiftyRelativePath
     */
    public func relativePath(from originalFrom: URL) -> URL {
        let dest = self.absoluteURL.standardized.pathComponents
        let from = originalFrom.absoluteURL.standardized.pathComponents

        var i = 0
        while i < dest.count,
              i < from.count,
              dest[i] == from[i]
        {
            i += 1
        }

        var rel = Array(repeating: "..", count: from.count - i)
        rel.append(contentsOf: dest[i...])
        return URL(
            fileURLWithPath: rel.joined(separator: "/"),
            relativeTo: originalFrom
        )
    }
}

