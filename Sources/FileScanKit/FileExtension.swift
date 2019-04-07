//
//  FileExtension.swift
//  FileScanKit
//
//  Created by Yutaro Muta on 2019/04/11.
//

import Foundation

public enum FileExtension {
    case swift
    case header
    case plist
    case custom(extension: String)

    var identifier: String {
        switch self {
        case .swift:
            return "swift"
        case .header:
            return "h"
        case .plist:
            return "plist"
        case .custom(let `extension`):
            return `extension`
        }
    }
}
