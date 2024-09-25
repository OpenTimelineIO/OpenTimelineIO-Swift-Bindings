//
//  CxxAny.h
//  otio-swift
//
// SPDX-License-Identifier: Apache-2.0
// Copyright Contributors to the OpenTimelineIO project

#import "opentime.h"

#if defined(__cplusplus)
#import <any/any.hpp>
#import "opentimelineio.h"
namespace otio = opentimelineio::OPENTIMELINEIO_VERSION;
#endif


typedef union CxxAnyValue {
    bool b;
    int64_t i;
    double d;
    char const* s;
    void* ptr;
    CxxRationalTime rt;
    CxxTimeRange tr;
    CxxTimeTransform tt;
} CxxAnyValue;

typedef struct CxxAny {
    enum {
        NONE = 0,
        BOOL_,      // avoid BOOL, as it conflicts with a macro in objc/objc.h
        INT,
        DOUBLE,
        STRING,
        SERIALIZABLE_OBJECT,
        RATIONAL_TIME,
        TIME_RANGE,
        TIME_TRANSFORM,
        DICTIONARY,
        VECTOR,
        UNKNOWN
    };
    
    int type_code;
    CxxAnyValue value;
} CxxAny;

#if defined(__cplusplus)
void otio_any_to_cxx_any(std::any const&, CxxAny*);
std::any cxx_any_to_otio_any(CxxAny const&);
#endif
