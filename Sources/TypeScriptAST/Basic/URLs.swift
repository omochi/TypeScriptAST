import Foundation

public enum URLs {
    /*
     Modified implementation of
     https://github.com/neoneye/SwiftyRelativePath
     */
    public static func relativePath(to destURL: URL, from fromURL: URL) -> URL {
        let dest = destURL.absoluteURL.standardized.pathComponents
        let from = fromURL.absoluteURL.standardized.pathComponents

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
            relativeTo: fromURL
        )
    }

    public static func replacingPathExtension(of url: URL, to ext: String) -> URL {
        var dir = url.deletingLastPathComponent()
        if dir.relativePath == "" {
            // swift-foundation のバグを回避する
            dir = URL(fileURLWithPath: ".", isDirectory: true, relativeTo: dir.baseURL)
        }

        var base = url.lastPathComponent
        let stem = (base as NSString).deletingPathExtension
        base = stem
        if !ext.isEmpty {
            base += "." + ext
        }
        if dir.relativePath == "." {
            /*
             元の relativePath が foo.ts のような単体ファイル名だった場合、
             appendすると ./foo.ts に変化してしまう。
             これを防ぐために init を使う。
             */
            return URL(fileURLWithPath: base, relativeTo: url.baseURL)
        }

        /*
         元の relativePath が絶対パスでも相対パスでもそれを維持するために、init ではなく append を使う.
         */
        return dir.appendingPathComponent(base)
    }
}

