//
//  wr_list.h
//  ZtqCountry
//
//  Created by hpf on 16/1/14.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wr_list : NSObject
@property(nonatomic,copy) NSString *num;
/**
 *  时间
 */
@property(nonatomic,copy) NSString *time;
/**
 *  高温数值
 */
@property(nonatomic,copy) NSString *h_num;
/**
 *  低温数值
 */
@property(nonatomic,copy) NSString *l_num;
/**
 *  type表示要查询的降雨量等类型的6天走势 1：降雨量 2：风况
 */
@property(nonatomic,copy) NSString *type;

@end
