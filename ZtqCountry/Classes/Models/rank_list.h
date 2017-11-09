//
//  rank_list.h
//  ZtqCountry
//
//  Created by hpf on 16/1/15.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface rank_list : NSObject
@property(nonatomic,copy) NSString *val;
@property(nonatomic,copy) NSString *city_name;
@property(nonatomic,copy) NSString *num;
/**
 *  1为雨量排行  2为温度排行  3为风况排行 
 */
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *TempType;
@property(nonatomic,copy) NSString *proid,*pro_type,*sk_type;
@end
