//
//  FileScanKitTests.swift
//  FileScanKitTests
//
//  Created by Yutaro Muta on 2019/04/12.
//

import XCTest
@testable import FileScanKit

final class FileScanKitTests: XCTestCase {

    static let allTests = [
        ("testNotExistsPath", testNotExistsPath),
        ("testScan", testAllScan),
        ("testAllScan", testAllScan),
        ("testDepthScan", testDepthScan),
        ("testFileExtensionScan", testFileExtensionScan),
        ("testIgnoreTest", testIgnoreTest),
    ]

    private var rootPath: String = ""

    override func setUp() {
        super.setUp()
        let project = Project()
        rootPath = project.rootPath
    }

    func testNotExistsPath() {
        let path: String = ""
        let fileScanner = FileScanner(path: path)
        XCTAssertNil(fileScanner)
    }

    func testAllScan() {
        let path: String = "\(rootPath)/Sources/"
        guard let fileScanner = FileScanner(path: path) else {
            XCTFail("path is invalid")
            fatalError()
        }

        let recursion: Recursion = .all
        let option = Option(
            recursion: recursion,
            fileExtension: .swift,
            ignorePaths: [String]()
        )

        let result: Result<[URL], Error> = fileScanner.scan(with: option)
        switch result {
        case .success(let urls):
            let paths = urls.map { $0.absoluteString }
            XCTAssertEqual(
                paths,
                [
                    "file://\(rootPath)/Sources/FileScanKit/FileExtension.swift",
                    "file://\(rootPath)/Sources/FileScanKit/FileScanner.swift",
                    "file://\(rootPath)/Sources/FileScanKit/Option.swift",
                    "file://\(rootPath)/Sources/FileScanKit/Recursion.swift",
                ]
            )
        case .failure(let error):
            print(error)
            XCTFail()
        }
    }

    func testDepthScan() {
        let path: String = "\(rootPath)"
        guard let fileScanner = FileScanner(path: path) else {
            XCTFail("path is invalid")
            fatalError()
        }

        // Depth limit = 0
        do {
            let recursion: Recursion = .depth(limit: 0)
            let option = Option(
                recursion: recursion,
                fileExtension: .swift,
                ignorePaths: [String]()
            )

            let result: Result<[URL], Error> = fileScanner.scan(with: option)
            switch result {
            case .success(let urls):
                let paths = urls.map { $0.absoluteString }
                XCTAssertEqual(
                    paths,
                    []
                )
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }

        // Depth limit = 1
        do {
            let recursion: Recursion = .depth(limit: 1)
            let option = Option(
                recursion: recursion,
                fileExtension: .swift,
                ignorePaths: [String]()
            )

            let result: Result<[URL], Error> = fileScanner.scan(with: option)
            switch result {
            case .success(let urls):
                let paths = urls.map { $0.absoluteString }
                XCTAssertEqual(
                    paths,
                    [
                        "file://\(rootPath)/Package.swift",
                    ]
                )
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }

        // Depth limit = 2
        do {
            let recursion: Recursion = .depth(limit: 2)
            let option = Option(
                recursion: recursion,
                fileExtension: .swift,
                ignorePaths: [String]()
            )

            let result: Result<[URL], Error> = fileScanner.scan(with: option)
            switch result {
            case .success(let urls):
                let paths = urls.map { $0.absoluteString }
                XCTAssertEqual(
                    paths,
                    [
                        "file://\(rootPath)/Package.swift",
                        "file://\(rootPath)/Tests/LinuxMain.swift",
                    ]
                )
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }

        // Depth limit = 4
        do {
            let recursion: Recursion = .depth(limit: 4)
            let ignorePaths: [String] = ["\(rootPath)/.build"]
            let option = Option(
                recursion: recursion,
                fileExtension: .swift,
                ignorePaths: ignorePaths
            )

            let result: Result<[URL], Error> = fileScanner.scan(with: option)
            switch result {
            case .success(let urls):
                let paths = urls.map { $0.absoluteString }
                XCTAssertEqual(
                    paths,
                    [
                        "file://\(rootPath)/Package.swift",
                        "file://\(rootPath)/Sources/FileScanKit/FileExtension.swift",
                        "file://\(rootPath)/Sources/FileScanKit/FileScanner.swift",
                        "file://\(rootPath)/Sources/FileScanKit/Option.swift",
                        "file://\(rootPath)/Sources/FileScanKit/Recursion.swift",
                        "file://\(rootPath)/Tests/FileScanKitTests/FileScanKitTests.swift",
                        "file://\(rootPath)/Tests/FileScanKitTests/Utilities/Project.swift",
                        "file://\(rootPath)/Tests/FileScanKitTests/XCTestManifests.swift",
                        "file://\(rootPath)/Tests/LinuxMain.swift"
                    ]
                )
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }

        // Depth limit = 10
        do {
            let recursion: Recursion = .depth(limit: 10)
            let ignorePaths: [String] = ["\(rootPath)/.build"]
            let option = Option(
                recursion: recursion,
                fileExtension: .swift,
                ignorePaths: ignorePaths
            )

            let result: Result<[URL], Error> = fileScanner.scan(with: option)
            switch result {
            case .success(let urls):
                let paths = urls.map { $0.absoluteString }
                XCTAssertEqual(
                    paths,
                    [
                        "file://\(rootPath)/Package.swift",
                        "file://\(rootPath)/Sources/FileScanKit/FileExtension.swift",
                        "file://\(rootPath)/Sources/FileScanKit/FileScanner.swift",
                        "file://\(rootPath)/Sources/FileScanKit/Option.swift",
                        "file://\(rootPath)/Sources/FileScanKit/Recursion.swift",
                        "file://\(rootPath)/Tests/FileScanKitTests/FileScanKitTests.swift",
                        "file://\(rootPath)/Tests/FileScanKitTests/Utilities/Project.swift",
                        "file://\(rootPath)/Tests/FileScanKitTests/XCTestManifests.swift",
                        "file://\(rootPath)/Tests/LinuxMain.swift"
                    ]
                )
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }

    }

    func testFileExtensionScan() {
        let path: String = "\(rootPath)/"
        guard let fileScanner = FileScanner(path: path) else {
            XCTFail("path is invalid")
            fatalError()
        }

        let fileExtension: FileExtension = .custom(extension: "resolved")
        let option = Option(
            recursion: .all,
            fileExtension: fileExtension,
            ignorePaths: [String]()
        )

        let result: Result<[URL], Error> = fileScanner.scan(with: option)
        switch result {
        case .success(let urls):
            let paths = urls.map { $0.absoluteString }
            XCTAssertEqual(
                paths,
                [
                    "file://\(rootPath)/Package.resolved",
                ]
            )
        case .failure(let error):
            print(error)
            XCTFail()
        }

    }

    func testIgnoreTest() {
        // Ignore directories
        do {
            let path: String = "\(rootPath)/"
            guard let fileScanner = FileScanner(path: path) else {
                XCTFail("path is invalid")
                fatalError()
            }

            let ignorePaths: [String] = [
                "\(rootPath)/.build",
                "\(rootPath)/Tests",
            ]
            let option = Option(
                recursion: .all,
                fileExtension: .swift,
                ignorePaths: ignorePaths
            )

            let result: Result<[URL], Error> = fileScanner.scan(with: option)
            switch result {
            case .success(let urls):
                let paths = urls.map { $0.absoluteString }
                XCTAssertEqual(
                    paths,
                    [
                        "file://\(rootPath)/Package.swift",
                        "file://\(rootPath)/Sources/FileScanKit/FileExtension.swift",
                        "file://\(rootPath)/Sources/FileScanKit/FileScanner.swift",
                        "file://\(rootPath)/Sources/FileScanKit/Option.swift",
                        "file://\(rootPath)/Sources/FileScanKit/Recursion.swift",
                    ]
                )
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }

        // Ignore files
        do {
            let path: String = "\(rootPath)/Sources"
            guard let fileScanner = FileScanner(path: path) else {
                XCTFail("path is invalid")
                fatalError()
            }

            let ignorePaths: [String] = [
                "\(rootPath)/Sources/FileScanKit/Option.swift",
                "\(rootPath)/Sources/FileScanKit/Recursion.swift",
            ]
            let option = Option(
                recursion: .all,
                fileExtension: .swift,
                ignorePaths: ignorePaths
            )

            let result: Result<[URL], Error> = fileScanner.scan(with: option)
            switch result {
            case .success(let urls):
                let paths = urls.map { $0.absoluteString }
                XCTAssertEqual(
                    paths,
                    [
                        "file://\(rootPath)/Sources/FileScanKit/FileExtension.swift",
                        "file://\(rootPath)/Sources/FileScanKit/FileScanner.swift",
                    ]
                )
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }

        // Invalid ignore paths
        do {
            let path: String = "\(rootPath)/Sources/"
            guard let fileScanner = FileScanner(path: path) else {
                XCTFail("path is invalid")
                fatalError()
            }

            do {
                let invalidIgnorePaths: [String] = [
                    "\(rootPath)/Sources/FileScanKi",
                ]
                let option = Option(
                    recursion: .all,
                    fileExtension: .swift,
                    ignorePaths: invalidIgnorePaths
                )

                let result: Result<[URL], Error> = fileScanner.scan(with: option)
                switch result {
                case .success(let urls):
                    let paths = urls.map { $0.absoluteString }
                    XCTAssertEqual(
                        paths,
                        [
                            "file://\(rootPath)/Sources/FileScanKit/FileExtension.swift",
                            "file://\(rootPath)/Sources/FileScanKit/FileScanner.swift",
                            "file://\(rootPath)/Sources/FileScanKit/Option.swift",
                            "file://\(rootPath)/Sources/FileScanKit/Recursion.swift",
                        ]
                    )
                case .failure(let error):
                    print(error)
                    XCTFail()
                }
            }
        }
    }

}
