//
//  FileScanner.swift
//  FileScanKit
//
//  Created by Yutaro Muta on 2019/04/11.
//

import Foundation
import PathKit

public struct FileScanner {
    private let path: Path

    public init?(path: String?) {
        let path = path.flatMap(Path.init(_:)) ?? Path.current
        if !path.exists {
            return nil
        }
        self.path = path
    }

    public func scan(with option: Option) -> Result<[URL], Error> {
        if path.isFile {
            let url = scanFile()
            return .success([url])
        } else if path.isDirectory {
            return scanDirecotry(with: option)
        } else {
            fatalError()
        }
    }
}

extension FileScanner {
    private func scanFile() -> URL {
        return URL(fileURLWithPath: path.absolute().string)
    }

    private func scanDirecotry(with option: Option) -> Result<[URL], Error> {
        let paths: [Path]
        do {
            switch option.recursion {
            case .all:
                paths = try path.recursiveChildren()
            case .depth(let limit):
                paths = try descend(from: path, limit: limit)
            }
        } catch {
            return .failure(error)
        }
        let urls = paths.lazy
            .filter { $0.extension == option.fileExtension?.identifier }
            .filter { path in
                !option.ignorePaths
                    .contains(where: { path.absolute().string.hasPrefix($0.absolute().string ) })
            }
            .compactMap { URL(fileURLWithPath: $0.absolute().string) }

        return .success(Array(urls))
    }

    private func descend(from path: Path, limit: UInt) throws -> [Path] {
        func descend(from paths: [Path]) throws -> [Path] {
            return try paths
                .filter { $0.isDirectory }
                .flatMap { try $0.children() }
        }

        var paths: [Path] = [path]
        var cursors: [Path] = paths
        try (0..<limit).forEach { _ in
            let childrenPaths = try descend(from: cursors)
            paths.append(contentsOf: childrenPaths)
            cursors = childrenPaths
        }
        return paths
    }
}
