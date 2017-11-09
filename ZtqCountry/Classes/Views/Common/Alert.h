//
//  Alert.h
//  ZtqCountry
//
//  Created by linxg on 14-8-1.
//  Copyright (c) 2014年 yyf. All rights reserved.
//


/*
 此弹窗对应版本检测后的提示弹窗
 包括logo、标题——“检测新版本”、内容——“当前已经是最新版本”、按钮——“知道了”
 */

#import <UIKit/UIKit.h>
@class Alert;
@protocol alerdeleagte <NSObject>

-(void)moreAction;

@end

@interface Alert : UIView

@property (strong, nonatomic) UIImageView * logoImgV;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UILabel * contentLab;
@property(weak,nonatomic)id <alerdeleagte>delegate;
-(id)initWithLogoImage:(NSString *)imageName withTitle:(NSString *)title withContent:(NSString *)content WithTime:(NSString *)putime withType:(NSString *)type;
-(id)initWithcontetnt:(NSString *)content;
-(id)initWithTitle:(NSString *)title withContent:(NSString *)content withleftbtn:(NSString *)lefttitle withrightbtn:(NSString *)righttitle;
-(void)show;

@end
