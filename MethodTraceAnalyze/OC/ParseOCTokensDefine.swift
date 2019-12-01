//
//  ParseOCTokensDefine.swift
//  SA
//
//  Created by ming on 2019/11/14.
//  Copyright © 2019 ming. All rights reserved.
//

import Foundation

// 官方 token 定义：https://opensource.apple.com//source/lldb/lldb-69/llvm/tools/clang/include/clang/Basic/TokenKinds.def

// 切割符号 [](){}.&=*+-<>~!/%^|?:;,#@
public enum OCTK {
    case unknown // 不是 token
    case eof // 文件结束
    case eod // 行结束
    case codeCompletion // Code completion marker
    case cxxDefaultargEnd // C++ default argument end marker
    case comment // 注释
    case identifier // 比如 abcde123
    case numericConstant(OCTkNumericConstant) // 整型、浮点 0x123，解释计算时用，分析代码时可不用
    case charConstant // 'a'
    case stringLiteral // "foo"
    case wideStringLiteral // L"foo"
    case angleStringLiteral // <foo> 待处理需要考虑作为小于符号的问题
    
    // 标准定义部分
    // 标点符号
    case punctuators(OCTkPunctuators)
    
    //  关键字
    case keyword(OCTKKeyword)
    
    // @关键字
    case atKeyword(OCTKAtKeyword)
}

extension OCTK: Equatable {
    public static func == (lhs: OCTK, rhs: OCTK) -> Bool {
            switch (lhs, rhs) {
            case (.eof, .eof):
                return true
            case (.eod, .eod):
                return true
            case (.comment, .comment):
                return true
            case (.identifier, .identifier):
                return true
            case (.stringLiteral, .stringLiteral):
                return true
            case (.wideStringLiteral, .wideStringLiteral):
                return true
            default:
                return false
            }
        }
    }

// MARK: @关键字
public enum OCTKAtKeyword {
    case notKeyword
    case `class`
    case compatibilityAlias
    case defs
    case encode
    case end
    case implementation
    case interface
    case `private`
    case protected
    case `protocol`
    case `public`
    case selector
    case `throw`
    case `try`
    case `catch`
    case finally
    case synchronized
    case property
    case package
    case required
    case optional
    case synthesize
    case dynamic
    
}

// MARK:关键字
public enum OCTKKeyword {
    // C99 6.4.1:
    case auto
    case `break`
    case `case`
    case char
    case const
    case `continue`
    case `default`
    case `do`
    case double
    case `else`
    case `enum`
    case extern
    case float
    case `for`
    case goto
    case `if`
    case inline
    case int
    case long
    case register
    case restrict
    case `return`
    case short
    case signed
    case sizeof
    case `static`
    case `struct`
    case `switch`
    case typedef
    case union
    case unsigned
    case void
    case volatile
    case `while`
    case _Bool
    case _Generic
    case _Imaginary
    case _Static_assert
    case __func__
    
    // C++ 2.11p1: Keywords.
    case asm
    case bool
    case `catch`
    case `class`
    case const_cast
    case delete
    case dynamic_cast
    case explicit
    case export
    case `false`
    case friend
    case mutable
    case namespace
    case new
    case `operator`
    case `private`
    case protected
    case `public`
    case reinterpret_cast
    case static_cast
    case template
    case this
    case `throw`
    case `true`
    case `try`
    case typename
    case typeid
    case using
    case virtual
    case wchar_t
    
    // C++ 2.5p2: Alternative Representations.
    case and
    case and_eq
    case bitand
    case bitor
    case compl
    case not
    case not_eq
    case or
    case or_eq
    case xor
    case xor_eq
    
    // C++0x keywords
    case alignof
    case char16_t
    case char32_t
    case constexpr
    case decltype
    case noexcept
    case nullptr
    case static_assert
    case thread_local
    
    // GNU Extensions (in impl-reserved namespace)
    case _Decimal32
    case _Decimal64
    case _Decimal128
    case __null
    case __alignof
    case __attribute
    case __builtin_choose_expr
    case __builtin_types_compatible_p
    case __builtin_va_arg
    case __extension__
    case __imag
    case __label__
    case __real
    case __thread
    case `__FUNCTION__`
    case __PRETTY_FUNCTION__
    
    // GNU Extensions (outside impl-reserved namespace)
    case typeof
    
    // GNU and MS Type Traits
    case __has_nothrow_assign
    case __has_nothrow_copy
    case __has_nothrow_constructor
    case __has_trivial_assign
    case __has_trivial_copy
    case __has_trivial_constructor
    case __has_trivial_destructor
    case __has_virtual_destructor
    case __is_abstract
    case __is_base_of
    case __is_class
    case __is_convertible_to
    case __is_empty
    case __is_enum
    
    // Tentative name - there's no implementation of std::is_literal_type yet.
    case __is_literal
    
    // Name for GCC 4.6 compatibility - people have already written libraries using this name unfortunately.
    case __is_literal_type
    case __is_pod
    case __is_polymorphic
    case __is_trivial
    case __is_union
    
    // Clang-only C++ Type Traits
    case __is_trivially_copyable
    case __underlying_type
    
    // Embarcadero Expression Traits
    case __is_lvalue_expr
    case __is_rvalue_expr
    
    // Embarcadero Unary Type Traits
    case __is_arithmetic
    case __is_floating_point
    case __is_integral
    case __is_complete_type
    case __is_void
    case __is_array
    case __is_function
    case __is_reference
    case __is_lvalue_reference
    case __is_rvalue_reference
    case __is_fundamental
    case __is_object
    case __is_scalar
    case __is_compound
    case __is_pointer
    case __is_member_object_pointer
    case __is_member_function_pointer
    case __is_member_pointer
    case __is_const
    case __is_volatile
    case __is_standard_layout
    case __is_signed
    case __is_unsigned
    
    // Embarcadero Binary Type Traits
    case __is_same
    case __is_convertible
    case __array_rank
    case __array_extent
    
    // Apple Extension.
    case __private_extern__
    
    // Microsoft Extension.
    case __declspec
    case __cdecl
    case __stdcall
    case __fastcall
    case __thiscall
    case __forceinline
    
    // OpenCL-specific keywords
    case __kernel
    case kernel
    case vec_step
    case __private
    case __global
    case __local
    case __constant
    case global
    case local
    case constant
    case __read_only
    case __write_only
    case __read_write
    case read_only
    case write_only
    case read_write
    
    // Borland Extensions.
    case __pascal
    
    // Altivec Extension.
    case __vector
    case __pixel
    
    // Alternate spelling for various tokens.  There are GCC extensions in all languages, but should not be disabled in strict conformance mode.
    case __alignof__
    case __asm
    case __asm__
    case __attribute__
    case __complex
    case __complex__
    case __const
    case __decltype
    case __imag__
    case __inline
    case __inline__
    case __nullptr
    case __real__
    case __restrict
    case __restrict__
    case __signed
    case __signed__
    case __typeof
    case __typeof__
    case __volatile
    case __volatile__
    
    // Microsoft extensions which should be disabled in strict conformance mode
    case __ptr64
    case __w64
    case __uuidof
    case __try
    case __except
    case __finally
    case __leave
    case __int64
    case __if_exists
    case __if_not_exists
    case __int8
    case __int32
    case _asm
    case _cdecl
    case _fastcall
    case _stdcall
    case _thiscall
    case _uuidof
    case _inline
    case _declspec
    case __interface
    
    // Borland Extensions which should be disabled in strict conformance mode.
    case _pascal
    
    // Clang Extensions.
    case __char16_t
    case __char32_t
    
    // Clang-specific keywords enabled only in testing.
    case __unknown_anytype
}

// MARK:标点符号
public enum OCTkPunctuators {
    // C99 6.4.6: Punctuators
    case lSquare             // [
    case rSquare             // ]
    case lParen              // (
    case rParen              // )
    case lBrace              // {
    case rBrace              // }
    case period              // .
    case ellipsis            // ...
    case amp                 // &
    case ampamp              // &&
    case ampequal            // &=
    case star                // *
    case starequal           // *=
    case plus                // +
    case plusplus            // ++
    case plusequal           // +=
    case minus               // -
    case arrow               // ->
    case minusminus          // --
    case minusequal          // -=
    case tilde               // ~
    case exclaim             // !
    case exclaimequal        // !=
    case slash               // /
    case slashequal          // /=
    case percent             // %
    case percentequal        // %=
    case less                // <
    case lessless            // <<
    case lessequal           // <=
    case lesslessequal       // <<=
    case greater             // >
    case greatergreater      // >>
    case greaterequal        // >=
    case greatergreaterequal // >>=
    case caret               // ^
    case caretequal          // ^=
    case pipe                // |
    case pipepipe            // ||
    case pipeequal           // |=
    case question            // ?
    case colon               // :
    case semi                // ;
    case equal               // =
    case equalequal          // ==
    case comma               // ,
    case hash                // #
    case hashhash            // ##
    case hashhat             // #@
    
    // C++ 支持
    case periodstar          // .*
    case arrowstar           // ->*
    case coloncolon          // ::
    
    // Objective C support
    case at                  // @
    
    // CUDA support
    case lesslessless          // <<<
    case greatergreatergreater // >>>
    
}

// MARK:数字
public enum OCTkNumericConstant {
    case integer(Int)
    case float(Float)
}
