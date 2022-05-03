//
//  CxxRetainer.h
//  otio_macos
//
// SPDX-License-Identifier: Apache-2.0
// Copyright Contributors to the OpenTimelineIO project

#import <Foundation/Foundation.h>

#if defined(__cplusplus)
#import <opentimelineio/serializableObject.h>
namespace otio = opentimelineio::OPENTIMELINEIO_VERSION;
#endif

NS_ASSUME_NONNULL_BEGIN

@interface CxxRetainer : NSObject
- (instancetype) init;
- (void) setCxxSerializableObject:(void*) cxxPtr;
- (void*) cxxSerializableObject;
@end

#if defined(__cplusplus)
@interface CxxRetainer ()
@property otio::SerializableObject::Retainer<> retainer;
@end
#endif

NS_ASSUME_NONNULL_END
