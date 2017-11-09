//
//  MedaiModel.h
//  ZtqCountry
//
//  Created by Admin on 14-10-14.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MedaiModel : NSObject{
    NSString *title;//文章标题
    NSString *imgurl;//缩略图
    NSString *medaiurl;//连接
    NSString *desc;//详细描述
    NSString *time;
}


@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *imgurl;
@property (nonatomic, strong)NSString *medaiurl;
@property(nonatomic,strong)NSString *desc;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong) NSString *fxurl;
@end
