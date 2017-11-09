//
//  ChineseHoliDay.h
//  ZtqCountry
//
//  Created by linxg on 14-7-23.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChineseHoliDay : NSObject

+(NSString *)getLunarSpecialDate:(int)iYear Month:(int)iMonth  Day:(int)iDay;
+(NSString *)getLunarHoliDayDate:(NSDate *)date;

@end
