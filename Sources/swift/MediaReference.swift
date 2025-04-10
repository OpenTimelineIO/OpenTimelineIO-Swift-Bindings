//
//  MediaReference.swift
//
// SPDX-License-Identifier: Apache-2.0
// Copyright Contributors to the OpenTimelineIO project

import Foundation
import OpenTimelineIO_objc

public class MediaReference : SerializableObjectWithMetadata {
    override public init() {
        super.init(otio_new_media_reference())
    }
    
    override internal init(_ cxxPtr: CxxSerializableObjectPtr) {
        super.init(cxxPtr)
    }
    
    public convenience init<ST : Sequence>(name: String? = nil,
                                           availableRange: TimeRange? = nil,
                                           metadata: ST? = nil) where ST.Element == Metadata.Dictionary.Element {
        self.init()
        metadataInit(name, metadata)
        if let availableRange = availableRange {
            self.availableRange = availableRange
        }
    }
    
    public convenience init(name: String? = nil,
                            availableRange: TimeRange? = nil) {
        self.init(name: name, availableRange: availableRange,
                  metadata: Metadata.Dictionary.none)
    }
    
    public var availableRange: TimeRange? {
        get { var timeRange = CxxTimeRange()
            return media_reference_available_range(self, &timeRange) ? TimeRange(timeRange) : nil
        }
        set {
            if let newValue = newValue {
                media_reference_set_available_range(self, newValue.cxxTimeRange)
            }
            else {
                media_reference_clear_available_range(self)
            }
        }
    }
    
    public var isMissingReference: Bool {
        get { return media_reference_is_missing_reference(self) }
    }
    
    public var availableImageBounds: CGRect?
    {
        get {
            var rect = CGRect(origin: CGPoint.init(x: 0, y: 0), size: CGSize(width: 0, height: 0))
            return media_reference_available_image_bounds(self, &rect) ? rect : nil
        }
        set {
            if let newValue {
                media_reference_set_available_image_bounds(self, newValue)
            }
            else {
                media_reference_clear_available_image_bounds(self)
            }
        }
        
    }
}
