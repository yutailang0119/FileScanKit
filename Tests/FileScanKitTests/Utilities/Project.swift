//
//  Project.swift
//  FileScanKitTests
//
//  Created by Yutaro Muta on 2019/04/12.
//

import Foundation

struct Project {
    var rootPath: String {
        let filePath = #file // ParentPath/FileScanKit/Tests/FileScanKitTests/Utilities/ProjectPath.swift
        return filePath
            .components(separatedBy: "/")
            .dropLast(4)
            .joined(separator: "/") // ParentPath/FileScanKit
    }
}
