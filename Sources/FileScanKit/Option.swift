//
//  Option.swift
//  FileScanKit
//
//  Created by Yutaro Muta on 2019/04/11.
//

import Foundation
import PathKit

public struct Option {
    let recursion: Recursion
    let fileExtension: FileExtension?
    let ignorePaths: [Path]
}

extension Option {
    public init(recursion: Recursion, fileExtension: FileExtension?, ignorePaths: [String]) {
        self.init(
            recursion: recursion,
            fileExtension: fileExtension,
            ignorePaths: ignorePaths.map(Path.init(_:))
        )
    }
}
