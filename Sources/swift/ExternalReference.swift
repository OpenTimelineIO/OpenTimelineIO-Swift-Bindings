//
//  ExternalReference.swift
//

import Foundation
import OpenTimelineIO_objc

public class ExternalReference : MediaReference {
    override public init() {
        super.init(otio_new_external_reference())
    }
    
    public convenience init<ST : Sequence>(targetURL: String? = nil,
                                           availableRange: TimeRange? = nil,
                                           metadata: ST? = nil) where ST.Element == Metadata.Dictionary.Element {
        self.init()
        metadataInit(name, metadata)
        if let url = targetURL {
            self.targetURL = url
        }
        if let t = availableRange {
            self.availableRange = t
        }
    }
    
    public convenience init(targetURL: String? = nil,
                            availableRange: TimeRange? = nil) {
        self.init(targetURL: targetURL, availableRange: availableRange,
                  metadata: Metadata.Dictionary.none)
    }
    
    public var targetURL: String? {
        get { external_reference_get_target_url(self) }
        set { external_reference_set_target_url(self, newValue ?? "") }
    }

    override internal init(_ cxxPtr: CxxSerializableObjectPtr) {
        super.init(cxxPtr)
    }
}
