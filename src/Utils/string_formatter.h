#ifndef STRING_FORMATTER
#define STRING_FORMATTER


#include <memory>
#include <iostream>
#include <string>
#include <cstdio>

// TODO: ������Windows��Linux��snprintf���ܲ�ͬ������bug
// linux�� sprintf���Զ��ں����'/0'��ͬʱcopy�ĳ���Ҳ�����ˡ�/0����
// ��windows�µ�_snprintf��δ���ոù��򣬾��Ǽ򵥵�copyָ�����ȵ��ַ������Զ���0�����ҳ���Ҳ������0��

#ifdef __GNUC__
#define _snprintf snprintf
#endif


template<typename ... Args>
std::string string_format( const std::string& format, Args ... args )
{
	size_t size = _snprintf(nullptr, 0, format.c_str(), args ...) + 1; // Extra space for '\0'
    std::unique_ptr<char[]> buf( new char[ size ] );
	_snprintf(buf.get(), size, format.c_str(), args ...);
    return std::string( buf.get(), buf.get() + size - 1 ); // We don't want the '\0' inside
}


#endif /* end of include guard: STRING_FORMATTER */
