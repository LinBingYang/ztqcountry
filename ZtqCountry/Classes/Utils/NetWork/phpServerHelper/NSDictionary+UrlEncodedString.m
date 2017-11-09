//
//  NSDictionary+UrlEncodedString.m
//
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.

#import "NSDictionary+UrlEncodedString.h"
#import "NSObject+SBJSON.h"

static NSString * EncodeGB2312Str(id encodeStr)
{
	CFStringRef nonAlphaNumValidChars = CFSTR("![            ]’()*+,-./:;=?@_~");
//	NSString *preprocessedString = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodeStr, CFSTR(""), kCFStringEncodingGB_18030_2000);
//	NSString *newStr = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingGB_18030_2000) autorelease];
    NSString *preprocessedString = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodeStr, CFSTR(""), kCFStringEncodingGB_18030_2000));
	NSString *newStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingGB_18030_2000));
//	[preprocessedString release];
	
	//NSLog(@"EncodeGB2312Str = %@", newStr);
	return newStr;
}

static NSString *toString(id object) {
    return [NSString stringWithFormat: @"%@", object];
}

// 转化为UTF8编码
static NSString *urlEncode(id object) {
    NSString *string = toString(object);
    return [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}

// 转化为GB2312编码
static NSString *urlEncode2 (id object)
{
    NSString *string = toString(object);
    return EncodeGB2312Str(string);
}

@implementation NSDictionary(UrlString)

-(NSString*) urlEncodedString {
	NSMutableArray *parts = [NSMutableArray array];
	for (id key in self) {
		id value = [self objectForKey: key];
		NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
		[parts addObject: part];
	}
	return [parts componentsJoinedByString: @"&"];//拼装字符串
}

- (NSString*)urlEncodedStringCustom
{
	return [self JSONRepresentation];
}
@end
