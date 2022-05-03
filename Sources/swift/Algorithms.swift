//
//  Algorithms.swift
//  otio_macos
//
// SPDX-License-Identifier: Apache-2.0
// Copyright Contributors to the OpenTimelineIO project

import Foundation
import OpenTimelineIO_objc

public enum Algorithms {
    static public func trackTrimmedToRange(track: Track, trimRange: TimeRange) throws -> Track {
        let result = try OTIOError.returnOrThrow { algorithms_track_trimmed_to_range(track, trimRange.cxxTimeRange, &$0) }
        return SerializableObject.findOrCreate(cxxPtr: result) as! Track
    }

    static public func flatten(stack: Stack) throws -> Track {
        let result = try OTIOError.returnOrThrow { algorithms_flatten_stack(stack, &$0) }
        return SerializableObject.findOrCreate(cxxPtr: result) as! Track
    }

    static public func flatten<ST : Sequence>(tracks: ST) throws -> Track where ST.Element == Track  {
        let result = try OTIOError.returnOrThrow { algorithms_flatten_track_array(tracks.map { $0 }, &$0) }
        return SerializableObject.findOrCreate(cxxPtr: result) as! Track
    }
}
