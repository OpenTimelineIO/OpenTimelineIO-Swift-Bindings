//
//  CxxAny.m
//  otio_macos
//
// SPDX-License-Identifier: Apache-2.0
// Copyright Contributors to the OpenTimelineIO project

#import "CxxAny.h"
#import "CxxAnyDictionaryMutationStamp.h"
#include <typeindex>
#include <opentimelineio/stringUtils.h>
#include <opentimelineio/serializableObject.h>

std::any cxx_any_to_otio_any(CxxAny const& cxxAny) {
    switch(cxxAny.type_code) {
        case CxxAny::NONE:
            return std::any();
        case CxxAny::BOOL_:
            return std::any(cxxAny.value.b);
        case CxxAny::INT:
            if (cxxAny.value.i < -INT_MIN || cxxAny.value.i > INT_MAX) {
                return std::any(cxxAny.value.i);
            }
            else {
                return std::any(int(cxxAny.value.i));
            }
        case CxxAny::DOUBLE:
            return std::any(cxxAny.value.d);
        case CxxAny::STRING:
            return std::any(std::string(cxxAny.value.s));
        case CxxAny::SERIALIZABLE_OBJECT:
            { auto so = reinterpret_cast<otio::SerializableObject*>(cxxAny.value.ptr);
              return std::any(otio::SerializableObject::Retainer<>(so));
            }
        case CxxAny::RATIONAL_TIME:
            return std::any(*((otio::RationalTime const*)(&cxxAny.value.rt)));
        case CxxAny::TIME_RANGE:
            return std::any(*((otio::TimeRange const*)(&cxxAny.value.tr)));
        case CxxAny::TIME_TRANSFORM:
             return std::any(*((otio::TimeTransform const*)(&cxxAny.value.tt)));
        case CxxAny::VECTOR:
             return std::any(*reinterpret_cast<otio::AnyVector*>(cxxAny.value.ptr));
        case CxxAny::DICTIONARY:
            return std::any(*reinterpret_cast<otio::AnyDictionary*>(cxxAny.value.ptr));
        default:
            return otio::SerializableObject::UnknownType { opentime::string_printf("%s <Swift Type>", cxxAny.value.s) };
    }
}

namespace {
struct _ToCxxAny {
    std::map<std::type_index, std::function<void (std::any const&, CxxAny*)>> function_map;
    
    _ToCxxAny() {
        auto& m = function_map;
        m[std::type_index(typeid(void))] = [](std::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::NONE;
            
        };
        m[std::type_index(typeid(bool))] = [](std::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::BOOL_;
            cxxAny->value.b = std::any_cast<bool>(a);
        };
        m[std::type_index(typeid(int))] = [](std::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::INT;
            cxxAny->value.i = std::any_cast<int>(a);
        };
        m[std::type_index(typeid(int64_t))] = [](std::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::INT;
            cxxAny->value.i = std::any_cast<int64_t>(a);
        };
        m[std::type_index(typeid(double))] = [](std::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::DOUBLE;
            cxxAny->value.d = std::any_cast<double>(a);
        };
        m[std::type_index(typeid(std::string))] = [](std::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::STRING;
            cxxAny->value.s = std::any_cast<std::string const&>(a).c_str();
        };
        m[std::type_index(typeid(otio::RationalTime))] = [](std::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::RATIONAL_TIME;
            cxxAny->value.rt = *((CxxRationalTime*)&std::any_cast<otio::RationalTime const&>(a));
        };
        m[std::type_index(typeid(otio::TimeRange))] = [](std::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::TIME_RANGE;
            cxxAny->value.tr = *((CxxTimeRange*)&std::any_cast<otio::TimeRange const&>(a));
        };
        m[std::type_index(typeid(otio::TimeTransform))] = [](std::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::TIME_TRANSFORM;
            cxxAny->value.tt = *((CxxTimeTransform*)&std::any_cast<otio::TimeTransform const&>(a));
        };
        m[std::type_index(typeid(otio::SerializableObject::Retainer<>))] = [](std::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::SERIALIZABLE_OBJECT;
            cxxAny->value.ptr = std::any_cast<otio::SerializableObject::Retainer<> const&>(a).value;
        };
        m[std::type_index(typeid(otio::AnyVector))] = [](std::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::VECTOR;
            cxxAny->value.ptr = (void*) &std::any_cast<otio::AnyVector const&>(a);
        };
        m[std::type_index(typeid(otio::AnyDictionary))] = [](std::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::DICTIONARY;
            cxxAny->value.ptr = (void*) &std::any_cast<otio::AnyDictionary const&>(a);
        };
    }
};
}

void otio_any_to_cxx_any(std::any const& a, CxxAny* cxxAny) {
    static auto toCxxAny = _ToCxxAny();
    auto e = toCxxAny.function_map.find(std::type_index(a.type()));
    
    if (e != toCxxAny.function_map.end()) {
        e->second(a, cxxAny);
    }
    else {
        cxxAny->type_code = CxxAny::UNKNOWN;
        cxxAny->value.s = a.type().name();
        return;
    }
}
