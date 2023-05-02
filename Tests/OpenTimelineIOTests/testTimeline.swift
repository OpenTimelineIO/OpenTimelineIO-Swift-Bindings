//
//  testTimeline.swift
//  
// SPDX-License-Identifier: Apache-2.0
// Copyright Contributors to the OpenTimelineIO project

import XCTest
@testable import OpenTimelineIO

import Foundation

final class testTimeline: XCTestCase {
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testMetadataRead() {
        let inputName = "data/timeline.otio"
        let knownDictKey = "foo"
        let knownKey = "some_key"
        let knownValue = "some_value"
        
        guard let timelineInputPath = Bundle.module.path(forResource: inputName, ofType: "") else {
            XCTFail("Missing test data `\(inputName)`")
            return
        }

        do {
            let otio = try SerializableObject.fromJSON(filename: timelineInputPath)
            
            guard let timeline = otio as? Timeline else {
                XCTFail("Could not create Timeline object from \(timelineInputPath)")
                return
            }

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
        } catch let error {
            XCTFail("Cannot read OTIO file `\(timelineInputPath)`: \(error)")
        }
    }
}
