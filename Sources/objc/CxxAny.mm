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

otio::any cxx_any_to_otio_any(CxxAny const& cxxAny) {
    switch(cxxAny.type_code) {
        case CxxAny::NONE:
            return otio::any();
        case CxxAny::BOOL_:
            return otio::any(cxxAny.value.b);
        case CxxAny::INT:
            if (cxxAny.value.i < -INT_MIN || cxxAny.value.i > INT_MAX) {
                return otio::any(cxxAny.value.i);
            }
            else {
                return otio::any(int(cxxAny.value.i));
            }
        case CxxAny::DOUBLE:
            return otio::any(cxxAny.value.d);
        case CxxAny::STRING:
            return otio::any(std::string(cxxAny.value.s));
        case CxxAny::SERIALIZABLE_OBJECT:
            { auto so = reinterpret_cast<otio::SerializableObject*>(cxxAny.value.ptr);
              return otio::any(otio::SerializableObject::Retainer<>(so));
            }
        case CxxAny::RATIONAL_TIME:
            return otio::any(*((otio::RationalTime const*)(&cxxAny.value.rt)));
        case CxxAny::TIME_RANGE:
            return otio::any(*((otio::TimeRange const*)(&cxxAny.value.tr)));
        case CxxAny::TIME_TRANSFORM:
             return otio::any(*((otio::TimeTransform const*)(&cxxAny.value.tt)));
        case CxxAny::VECTOR:
             return otio::any(*reinterpret_cast<otio::AnyVector*>(cxxAny.value.ptr));
        case CxxAny::DICTIONARY:
            return otio::any(*reinterpret_cast<otio::AnyDictionary*>(cxxAny.value.ptr));
        default:
            return otio::SerializableObject::UnknownType { opentime::string_printf("%s <Swift Type>", cxxAny.value.s) };
    }
}

namespace {
struct _ToCxxAny {
    std::map<std::type_index, std::function<void (otio::any const&, CxxAny*)>> function_map;
    
    _ToCxxAny() {
        auto& m = function_map;
        m[std::type_index(typeid(void))] = [](otio::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::NONE;
            
        };
        m[std::type_index(typeid(bool))] = [](otio::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::BOOL_;
            cxxAny->value.b = otio::any_cast<bool>(a);
        };
        m[std::type_index(typeid(int))] = [](otio::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::INT;
            cxxAny->value.i = otio::any_cast<int>(a);
        };
        m[std::type_index(typeid(int64_t))] = [](otio::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::INT;
            cxxAny->value.i = otio::any_cast<int64_t>(a);
        };
        m[std::type_index(typeid(double))] = [](otio::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::DOUBLE;
            cxxAny->value.d = otio::any_cast<double>(a);
        };
        m[std::type_index(typeid(std::string))] = [](otio::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::STRING;
            cxxAny->value.s = otio::any_cast<std::string const&>(a).c_str();
        };
        m[std::type_index(typeid(otio::RationalTime))] = [](otio::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::RATIONAL_TIME;
            cxxAny->value.rt = *((CxxRationalTime*)&otio::any_cast<otio::RationalTime const&>(a));
        };
        m[std::type_index(typeid(otio::TimeRange))] = [](otio::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::TIME_RANGE;
            cxxAny->value.tr = *((CxxTimeRange*)&otio::any_cast<otio::TimeRange const&>(a));
        };
        m[std::type_index(typeid(otio::TimeTransform))] = [](otio::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::TIME_TRANSFORM;
            cxxAny->value.tt = *((CxxTimeTransform*)&otio::any_cast<otio::TimeTransform const&>(a));
        };
        m[std::type_index(typeid(otio::SerializableObject::Retainer<>))] = [](otio::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::SERIALIZABLE_OBJECT;
            cxxAny->value.ptr = otio::any_cast<otio::SerializableObject::Retainer<> const&>(a).value;
        };
        m[std::type_index(typeid(otio::AnyVector))] = [](otio::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::VECTOR;
            cxxAny->value.ptr = (void*) &otio::any_cast<otio::AnyVector const&>(a);
        };
        m[std::type_index(typeid(otio::AnyDictionary))] = [](otio::any const& a, CxxAny* cxxAny) {
            cxxAny->type_code = CxxAny::DICTIONARY;
            cxxAny->value.ptr = (void*) &otio::any_cast<otio::AnyDictionary const&>(a);
        };
    }
};
}

void otio_any_to_cxx_any(otio::any const& a, CxxAny* cxxAny) {
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
