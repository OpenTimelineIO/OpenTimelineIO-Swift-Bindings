//
//  ImageSequenceReference.swift
//
// SPDX-License-Identifier: Apache-2.0
// Copyright Contributors to the OpenTimelineIO project

import Foundation
import OpenTimelineIO_objc

public class ImageSequenceReference : MediaReference {
    override public init() {
        super.init(otio_new_image_sequence_reference())
    }

    public enum MissingFramePolicy: Int {
        case error = 0
        case hold = 1
        case black = 2
    }

    public convenience init<ST : Sequence>(targetURLBase: String? = nil,
                                           namePrefix: String? = nil,
                                           nameSuffix: String? = nil,
                                           startFrame: Int = 1,
                                           frameStep: Int = 1,
                                           rate: Double = 1,
                                           frameZeroPadding: Int = 0,
                                           missingFramePolicy: MissingFramePolicy = .error,
                                           availableRange: TimeRange? = nil,
                                           metadata: ST? = nil) where ST.Element == Metadata.Dictionary.Element {
        self.init()
        metadataInit(name, metadata)
        if let targetURLBase = targetURLBase {
            self.targetURLBase = targetURLBase
        }
        if let namePrefix = namePrefix {
            self.namePrefix = namePrefix
        }
        if let nameSuffix = nameSuffix {
            self.nameSuffix = nameSuffix
        }
        self.startFrame = startFrame
        self.frameStep = frameStep
        self.rate = rate
        self.frameZeroPadding = frameZeroPadding
        self.missingFramePolicy = missingFramePolicy
        if let availableRange = availableRange {
            self.availableRange = availableRange
        }
    }

    public convenience init(targetURLBase: String? = nil,
                            namePrefix: String? = nil,
                            nameSuffix: String? = nil,
                            startFrame: Int = 1,
                            frameStep: Int = 1,
                            rate: Double = 1,
                            frameZeroPadding: Int = 0,
                            missingFramePolicy: MissingFramePolicy = .error,
                            availableRange: TimeRange? = nil) {
        self.init(targetURLBase: targetURLBase, namePrefix: namePrefix, nameSuffix: nameSuffix,
                  startFrame: startFrame, frameStep: frameStep, rate: rate,
                  frameZeroPadding: frameZeroPadding, missingFramePolicy: missingFramePolicy,
                  availableRange: availableRange, metadata: Metadata.Dictionary.none)
    }

    public var targetURLBase: String {
        get { return image_sequence_reference_get_target_url_base(self) }
        set { image_sequence_reference_set_target_url_base(self, newValue) }
    }

    public var namePrefix: String {
        get { return image_sequence_reference_get_name_prefix(self) }
        set { image_sequence_reference_set_name_prefix(self, newValue) }
    }

    public var nameSuffix: String {
        get { return image_sequence_reference_get_name_suffix(self) }
        set { image_sequence_reference_set_name_suffix(self, newValue) }
    }

    public var startFrame: Int {
        get { return Int(image_sequence_reference_get_start_frame(self)) }
        set { image_sequence_reference_set_start_frame(self, Int32(newValue)) }
    }

    public var frameStep: Int {
        get { return Int(image_sequence_reference_get_frame_step(self)) }
        set { image_sequence_reference_set_frame_step(self, Int32(newValue)) }
    }

    public var rate: Double {
        get { return image_sequence_reference_get_rate(self) }
        set { image_sequence_reference_set_rate(self, newValue) }
    }

    public var frameZeroPadding: Int {
        get { return Int(image_sequence_reference_get_frame_zero_padding(self)) }
        set { image_sequence_reference_set_frame_zero_padding(self, Int32(newValue)) }
    }

    public var missingFramePolicy: MissingFramePolicy {
        get { return MissingFramePolicy(rawValue: Int(image_sequence_reference_get_missing_frame_policy(self)))! }
        set { image_sequence_reference_set_missing_frame_policy(self, Int32(newValue.rawValue)) }
    }

    public var endFrame: Int {
        get { return Int(image_sequence_reference_end_frame(self)) }
    }

    public var numberOfImagesInSequence: Int {
        get { return Int(image_sequence_reference_number_of_images_in_sequence(self)) }
    }

    public func frame(for time: RationalTime) throws -> Int {
        return try Int(OTIOError.returnOrThrow { image_sequence_reference_frame_for_time(self, time.cxxRationalTime, &$0) })
    }

    public func targetURL(forImageNumber imageNumber: Int) throws -> String {
        return try OTIOError.returnOrThrow { image_sequence_reference_target_url_for_image_number(self, Int32(imageNumber), &$0) }
    }

    public func presentationTime(forImageNumber imageNumber: Int) throws -> RationalTime {
        return try RationalTime(OTIOError.returnOrThrow { image_sequence_reference_presentation_time_for_image_number(self, Int32(imageNumber), &$0) })
    }

    override internal init(_ cxxPtr: CxxSerializableObjectPtr) {
        super.init(cxxPtr)
    }
}
