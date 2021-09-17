//
//  testExternalReference.swift
//

import XCTest
@testable import OpenTimelineIO

import Foundation

class tesExternalReference: XCTestCase {

    func testAvailableRange() {
        let start_time1 = RationalTime(value: 18, rate: 24)
        let duration1 = RationalTime(value: 7, rate: 24)
        let tr1 = TimeRange(startTime: start_time1, duration: duration1)

        let e = ExternalReference(targetURL:"foo.png", availableRange: tr1)

        var test = e.availableRange
        XCTAssertEqual(tr1, test)
        
        let start_time2 = RationalTime(value: 18, rate: 24)
        let duration2 = RationalTime(value: 14, rate: 48)
        let tr2 = TimeRange(startTime: start_time2, duration: duration2)

        e.availableRange = tr2;
        test = e.availableRange
        XCTAssertEqual(tr2, test)
    }
    
    func testMetadata() {
        let dict = Metadata.Dictionary(arrayLiteral:
                    ("sheet_index", 3),
                    ("media", "/sample/path"),
                    ("kind", "sheet"))

        let e = ExternalReference(targetURL:"foo.png", availableRange: nil, metadata: dict)
        
        let test_dict = e.metadata
        let index : Int = test_dict["sheet_index"] as! Int
        XCTAssertEqual(index, 3)
    }
    
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
            let e = ExternalReference(targetURL:str)
            let dstURL = e.targetURL
            XCTAssert(str == dstURL)
        }
    }
}

