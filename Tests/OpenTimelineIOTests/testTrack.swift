//
//  File.swift
//
// SPDX-License-Identifier: Apache-2.0
// Copyright Contributors to the OpenTimelineIO project

import XCTest
@testable import OpenTimelineIO

import Foundation

class testTrack: XCTestCase {

    func testSourceRange() {
        let start_time1 = RationalTime(value: 18, rate: 24)
        let duration1 = RationalTime(value: 7, rate: 24)
        let tr1 = TimeRange(startTime: start_time1, duration: duration1)
        
        let track = Track()
        track.name = "Elements"
        track.kind = "Video"
        track.sourceRange = tr1
        
        let tr2 = track.sourceRange
        XCTAssertEqual(tr1, tr2)
        XCTAssertEqual(track.name, "Elements")
        XCTAssertEqual(track.kind, "Video")
    }

    func testEquality() {
        let start_time1 = RationalTime(value: 18, rate: 24)
        let duration1 = RationalTime(value: 7, rate: 24)
        let tr1 = TimeRange(startTime: start_time1, duration: duration1)
        
        let track = Track()
        track.name = "Elements"
        track.kind = "Video"
        track.sourceRange = tr1
        
        let track2 = Track()
        track2.name = "Elements"
        track2.kind = "Video"
        track2.sourceRange = tr1;
        
        XCTAssert(track.isEquivalent(to: track2))
        
        track2.kind = "Audio"
        XCTAssert(!track.isEquivalent(to: track2))
    }
    
}

