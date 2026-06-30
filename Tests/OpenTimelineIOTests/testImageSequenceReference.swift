//
//  testImageSequenceReference.swift
//
// SPDX-License-Identifier: Apache-2.0
// Copyright Contributors to the OpenTimelineIO project

import XCTest
@testable import OpenTimelineIO

import Foundation

class testImageSequenceReference: XCTestCase {

    func testCreate() {
        let tr = TimeRange(startTime: RationalTime(value: 0, rate: 30),
                           duration: RationalTime(value: 60, rate: 30))
        let dict = Metadata.Dictionary(arrayLiteral: ("custom", "bar"))

        let ref = ImageSequenceReference(targetURLBase: "file:///show/seq/shot/rndr/",
                                         namePrefix: "show_shot.",
                                         nameSuffix: ".exr",
                                         frameStep: 3,
                                         rate: 30,
                                         frameZeroPadding: 5,
                                         missingFramePolicy: .hold,
                                         availableRange: tr,
                                         metadata: dict)

        XCTAssertEqual(ref.targetURLBase, "file:///show/seq/shot/rndr/")
        XCTAssertEqual(ref.namePrefix, "show_shot.")
        XCTAssertEqual(ref.nameSuffix, ".exr")
        XCTAssertEqual(ref.frameZeroPadding, 5)
        XCTAssertEqual(ref.availableRange, tr)
        XCTAssertEqual(ref.frameStep, 3)
        XCTAssertEqual(ref.rate, 30)
        XCTAssertEqual(ref.missingFramePolicy, .hold)
        XCTAssertEqual(ref.metadata["custom"] as! String, "bar")
    }

    func testProperties() {
        let ref = ImageSequenceReference()
        ref.targetURLBase = "file:///show/seq/shot/rndr/"
        ref.namePrefix = "show_shot."
        ref.nameSuffix = ".exr"
        ref.startFrame = 101
        ref.frameStep = 2
        ref.rate = 24
        ref.frameZeroPadding = 4
        ref.missingFramePolicy = .black

        XCTAssertEqual(ref.targetURLBase, "file:///show/seq/shot/rndr/")
        XCTAssertEqual(ref.namePrefix, "show_shot.")
        XCTAssertEqual(ref.nameSuffix, ".exr")
        XCTAssertEqual(ref.startFrame, 101)
        XCTAssertEqual(ref.frameStep, 2)
        XCTAssertEqual(ref.rate, 24)
        XCTAssertEqual(ref.frameZeroPadding, 4)
        XCTAssertEqual(ref.missingFramePolicy, .black)
    }

    func testNumberOfImagesInSequence() {
        let tr = TimeRange(startTime: RationalTime(value: 0, rate: 24),
                           duration: RationalTime(value: 48, rate: 24))
        let ref = ImageSequenceReference(targetURLBase: "file:///show/seq/shot/rndr/",
                                         namePrefix: "show_shot.",
                                         nameSuffix: ".exr",
                                         rate: 24,
                                         availableRange: tr)

        XCTAssertEqual(ref.numberOfImagesInSequence, 48)

        ref.frameStep = 2
        XCTAssertEqual(ref.numberOfImagesInSequence, 24)

        ref.frameStep = 3
        XCTAssertEqual(ref.numberOfImagesInSequence, 16)
    }

    func testEndFrame() {
        let tr = TimeRange(startTime: RationalTime(value: 12, rate: 24),
                           duration: RationalTime(value: 48, rate: 24))
        let ref = ImageSequenceReference(targetURLBase: "file:///show/seq/shot/rndr/",
                                         namePrefix: "show_shot.",
                                         nameSuffix: ".exr",
                                         startFrame: 101,
                                         rate: 24,
                                         frameZeroPadding: 4,
                                         availableRange: tr)

        XCTAssertEqual(ref.endFrame, 148)

        ref.frameStep = 2
        XCTAssertEqual(ref.endFrame, 148)
    }

    func testTargetURLForImageNumber() throws {
        let tr = TimeRange(startTime: RationalTime(value: 0, rate: 24),
                           duration: RationalTime(value: 48, rate: 24))
        let ref = ImageSequenceReference(targetURLBase: "file:///show/seq/shot/rndr/",
                                         namePrefix: "show_shot.",
                                         nameSuffix: ".exr",
                                         startFrame: 1,
                                         frameStep: 1,
                                         rate: 24,
                                         frameZeroPadding: 4,
                                         availableRange: tr)

        XCTAssertEqual(ref.numberOfImagesInSequence, 48)
        for i in 0..<ref.numberOfImagesInSequence {
            let expected = String(format: "file:///show/seq/shot/rndr/show_shot.%04d.exr", i + 1)
            XCTAssertEqual(try ref.targetURL(forImageNumber: i), expected)
        }
    }

    func testNegativeFrameNumbers() throws {
        let tr = TimeRange(startTime: RationalTime(value: 0, rate: 24),
                           duration: RationalTime(value: 4, rate: 24))
        let ref = ImageSequenceReference(targetURLBase: "",
                                         namePrefix: "frame.",
                                         nameSuffix: ".exr",
                                         startFrame: -2,
                                         frameStep: 1,
                                         rate: 24,
                                         frameZeroPadding: 4,
                                         availableRange: tr)

        XCTAssertEqual(ref.numberOfImagesInSequence, 4)
        XCTAssertEqual(try ref.targetURL(forImageNumber: 0), "frame.-0002.exr")
        XCTAssertEqual(try ref.targetURL(forImageNumber: 1), "frame.-0001.exr")
        XCTAssertEqual(try ref.targetURL(forImageNumber: 2), "frame.0000.exr")
        XCTAssertEqual(try ref.targetURL(forImageNumber: 3), "frame.0001.exr")
    }

    func testTargetURLWithMissingSlash() throws {
        let tr = TimeRange(startTime: RationalTime(value: 0, rate: 24),
                           duration: RationalTime(value: 48, rate: 24))
        let ref = ImageSequenceReference(targetURLBase: "file:///show/seq/shot/rndr",
                                         namePrefix: "show_shot.",
                                         nameSuffix: ".exr",
                                         startFrame: 1,
                                         frameStep: 1,
                                         rate: 24,
                                         frameZeroPadding: 4,
                                         availableRange: tr)

        XCTAssertEqual(try ref.targetURL(forImageNumber: 0),
                       "file:///show/seq/shot/rndr/show_shot.0001.exr")
    }

    func testFrameForTime() throws {
        let tr = TimeRange(startTime: RationalTime(value: 12, rate: 24),
                           duration: RationalTime(value: 48, rate: 24))
        let ref = ImageSequenceReference(targetURLBase: "file:///show/seq/shot/rndr/",
                                         namePrefix: "show_shot.",
                                         nameSuffix: ".exr",
                                         startFrame: 1,
                                         frameStep: 1,
                                         rate: 24,
                                         frameZeroPadding: 4,
                                         availableRange: tr)

        XCTAssertEqual(try ref.frame(for: tr.startTime), 1)
        XCTAssertEqual(try ref.frame(for: RationalTime(value: 15, rate: 24)), 4)
        XCTAssertEqual(try ref.frame(for: tr.endTimeInclusive()), 48)
    }

    func testFrameForTimeOutOfRange() {
        let tr = TimeRange(startTime: RationalTime(value: 0, rate: 30),
                           duration: RationalTime(value: 60, rate: 30))
        let ref = ImageSequenceReference(targetURLBase: "file:///show/seq/shot/rndr/",
                                         namePrefix: "show_shot.",
                                         nameSuffix: ".exr",
                                         rate: 30,
                                         availableRange: tr)

        XCTAssertThrowsError(try ref.frame(for: RationalTime(value: 73, rate: 30)))
    }

    func testPresentationTimeForImageNumber() throws {
        let tr = TimeRange(startTime: RationalTime(value: 0, rate: 24),
                           duration: RationalTime(value: 48, rate: 24))
        let ref = ImageSequenceReference(targetURLBase: "file:///show/seq/shot/rndr/",
                                         namePrefix: "show_shot.",
                                         nameSuffix: ".exr",
                                         startFrame: 1,
                                         frameStep: 2,
                                         rate: 24,
                                         frameZeroPadding: 4,
                                         availableRange: tr)

        XCTAssertEqual(ref.numberOfImagesInSequence, 24)
        for i in 0..<ref.numberOfImagesInSequence {
            XCTAssertEqual(try ref.presentationTime(forImageNumber: i),
                           RationalTime(value: Double(i * 2), rate: 24))
        }
    }

    func testSerializeRoundtrip() throws {
        let tr = TimeRange(startTime: RationalTime(value: 0, rate: 30),
                           duration: RationalTime(value: 60, rate: 30))
        let dict = Metadata.Dictionary(arrayLiteral: ("custom", "bar"))

        let ref = ImageSequenceReference(targetURLBase: "file:///show/seq/shot/rndr/",
                                         namePrefix: "show_shot.",
                                         nameSuffix: ".exr",
                                         frameStep: 3,
                                         rate: 30,
                                         frameZeroPadding: 5,
                                         missingFramePolicy: .hold,
                                         availableRange: tr,
                                         metadata: dict)

        let encoded = try ref.toJSON()
        let decoded = try SerializableObject.fromJSON(string: encoded) as! ImageSequenceReference

        XCTAssert(ref.isEquivalent(to: decoded))
        XCTAssertEqual(decoded.targetURLBase, "file:///show/seq/shot/rndr/")
        XCTAssertEqual(decoded.namePrefix, "show_shot.")
        XCTAssertEqual(decoded.nameSuffix, ".exr")
        XCTAssertEqual(decoded.frameZeroPadding, 5)
        XCTAssertEqual(decoded.availableRange, tr)
        XCTAssertEqual(decoded.frameStep, 3)
        XCTAssertEqual(decoded.rate, 30)
        XCTAssertEqual(decoded.missingFramePolicy, .hold)
    }
}
