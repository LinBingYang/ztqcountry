//
//  NSDictionary+UrlEncodedString.h
//
//---------------------------------
//    文件作用：转换参数字典为php页面能接受得编码
//           
//  Copyright (c) 2012年 __ZYProSoft__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(UrlString)
- (NSString*)urlEncodedString;
- (NSString*)urlEncodedStringCustom;
@end
