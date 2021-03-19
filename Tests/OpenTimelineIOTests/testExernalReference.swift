//
//  testExternalReference.swift
//

import XCTest
@testable import OpenTimelineIO

import Foundation

class tesExternalReference: XCTestCase {

    func testURLs() {
        for str in [
            "",
            ".",
            "/.",
            "/",
            "file:///d:",
            "d:",
            "d:/hello/windows",
            "file:///d:/hello/windows",
            "file:///d:/hello/windows/",
            "/foo/bar.png",
            "foo/bar.png",
            "file:foo/bar.png",
            "file:/foo/bar.png",
            "file://foo/bar.png",
            "file:///foo/bar.png",
            "http:foo/bar.png",
            "http:/foo/bar.png",
            "http:www.foo.com/foo/bar.png",
            "https:www.foo.com:1245/foo/bar.png",
            "s3:foo/bar.png",
            "s3:/foo/bar.png",
            "s3://foo/bar.png",
            "s3:///foo/bar.png",
            "foo:/foo/bar.png?size=123&tag=&amp;&blah=bloog#1234"
        ] {
            let srcURL = URL(fileURLWithPath: str)
            let e = ExternalReference(targetURL:srcURL)
            let dstURL = e.targetURL
            XCTAssert(srcURL == dstURL)
            XCTAssert(str == dstURL?.absoluteString)
        }
    }
}

