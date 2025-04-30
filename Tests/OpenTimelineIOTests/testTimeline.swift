//
//  testTimeline.swift
//  
// SPDX-License-Identifier: Apache-2.0
// Copyright Contributors to the OpenTimelineIO project

import XCTest
@testable import OpenTimelineIO

import Foundation

final class testTimeline: XCTestCase {
    enum Error: Swift.Error {
        case SetupFailed(String)
    }

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testMetadataRead() throws {
        let knownDictKey = "foo"
        let knownKey = "some_key"
        let knownValue = "some_value"
        
        let timeline = try timeline(from: "data/timeline.otio")
        let timelineMetadata = timeline.metadata

        if let knownMetadata = timelineMetadata[knownDictKey] as? Metadata.Dictionary {
            if let value = knownMetadata[knownKey] as? String {
                XCTAssertTrue(value == knownValue)
            } else {
                XCTFail("Expects (\(knownKey), \(knownValue)), but found none in \(knownMetadata)")
            }
        } else {
            XCTFail("Cannot read timeline metadata \(String(describing: timelineMetadata[knownDictKey])) as `Metadata.Dictionary`")
        }
    }
    
    func testTimelineClipAvailableBounds() throws {
        let timeline = try timeline(from: "data/clip_example.otio")
        
        if let firstClip = timeline.videoTracks.first!.children[1] as? Clip,
           let mediaReference = firstClip.mediaReference,
           let availableBounds = mediaReference.availableImageBounds
        {
            XCTAssertEqual(availableBounds, CGRect(origin: .zero, size: CGSize(width: 16, height: 9)))
        }
    }

    func testTimelineFindClips() throws {
        // SETUP
        let timeline = try timeline(from: "data/nested_example.otio")

        // EXERCISE
        let clips = try timeline.findClips()

        // VERIFY
        XCTAssertEqual(
            clips.map(\.name), 
            [
                "Normal Clip 1",
                "Clip Inside A Stack 1",
                "Normal Clip 2", 
                "Clip Inside A Stack 2", 
                "Normal Clip 3", 
                "Clip Inside A Track", 
                "Normal Clip 4"
            ]
        )
    }

    func timeline(from inputFilePath: String) throws -> Timeline {
        guard let timelineInputPath = Bundle.module.path(forResource: inputFilePath, ofType: "") else {
            throw Error.SetupFailed("Missing test data `\(inputFilePath)`")
        }

        do {
            let otio = try SerializableObject.fromJSON(filename: timelineInputPath)

            guard let timeline = otio as? Timeline else {
                throw Error.SetupFailed("Could not create Timeline object from \(timelineInputPath)")
            }

            return timeline

        } catch let error {
            throw Error.SetupFailed("Cannot read OTIO file `\(timelineInputPath)`: \(error)")
        }
    }
    
}
