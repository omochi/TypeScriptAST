import Foundation

public enum URLs {
    /*
     Modified implementation of
     https://github.com/neoneye/SwiftyRelativePath
     */
    public static func relativePath(to dest: URL, from originalFrom: URL) -> URL {
        let dest = dest.absoluteURL.standardized.pathComponents
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

    public static func replacingPathExtension(of url: URL, to ext: String) -> URL {
        let dir = url.deletingLastPathComponent()
        var base = url.lastPathComponent
        let stem = (base as NSString).deletingPathExtension
        base = stem
        if !ext.isEmpty {
            base += "." + ext
        }
        if dir.relativePath == "." {
            return URL(fileURLWithPath: base, relativeTo: url.baseURL)
        } else {
            return dir.appendingPathComponent(base)
        }
    }
}

