//
//  Timeline.swift
//
// SPDX-License-Identifier: Apache-2.0
// Copyright Contributors to the OpenTimelineIO project

import Foundation
import OpenTimelineIO_objc

public class Timeline : SerializableObjectWithMetadata {
    override public init() {
        super.init(otio_new_timeline())
    }
    
    public convenience init<ST : Sequence>(name: String? = nil,
                                           globalStartTime: RationalTime = RationalTime(value: 0, rate: 24),
                                           metadata: ST? = nil) where ST.Element == Metadata.Dictionary.Element {
        self.init()
        metadataInit(name, metadata)
        self.globalStartTime = globalStartTime
    }
    
    public convenience init(name: String? = nil,
                            globalStartTime: RationalTime = RationalTime(value: 0, rate: 24)) {
        self.init(name: name, globalStartTime: globalStartTime,  metadata: Metadata.Dictionary.none)
    }

    public var globalStartTime: RationalTime? {
        get { var rt = CxxRationalTime()
            return timeline_get_global_start_time(self, &rt) ? RationalTime(rt) : nil
        }
        set {
            if let newValue = newValue {
                timeline_set_global_start_time(self, newValue.cxxRationalTime)
            }
            else {
                timeline_clear_global_start_time(self)
            }
        }
    }
    
    public var tracks: Stack? {
        get { return SerializableObject.possiblyFindOrCreate(cxxPtr: timeline_get_tracks(self)) as? Stack }
        set {
            // nb: Setting a newValue of nil will cause a crash.
            // That is consistent with the current Python behavior.
            /// @TODO revisit nil handling in the C++ code
            timeline_set_tracks(self, newValue!)
        }
    }
    
    public var audioTracks: [Track] {
        get {
            let stack = tracks
            if stack != nil {
                return stack!.children.filter({ ($0 as! Track).kind == "Audio" }) as! [Track]
            }
            return []
        }
    }

    public var videoTracks: [Track] {
        get {
            let stack = tracks
            if stack != nil {
                return stack!.children.filter({ ($0 as! Track).kind == "Video" }) as! [Track]
            }
            return []
        }
    }

    public func duration() throws -> RationalTime {
        return try OTIOError.returnOrThrow { RationalTime(timeline_duration(self, &$0)) }
    }

    public func range(of child: Composable) throws -> TimeRange {
        return try OTIOError.returnOrThrow { TimeRange(timeline_range_of_child(self, child, &$0)) }
    }

    override internal init(_ cxxPtr: CxxSerializableObjectPtr) {
        super.init(cxxPtr)
    }
}
