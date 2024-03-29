//
//  CxxRetainer.m
//  otio_macos
//
// SPDX-License-Identifier: Apache-2.0
// Copyright Contributors to the OpenTimelineIO project

#import "CxxRetainer.h"

@implementation CxxRetainer
- (instancetype) init {
    self = [super init];
    return self;
}

- (void) setCxxSerializableObject:(void *)cxxPtr {
    otio::SerializableObject* so = reinterpret_cast<otio::SerializableObject*>(cxxPtr);
    if (so) {
        self.retainer = otio::SerializableObject::Retainer<>(so);
    }
}

- (void*) cxxSerializableObject {
    return self.retainer.value;
}
@end
