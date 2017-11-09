//
//  ViedoADSrcollView.h
//  ZtqCountry
//
//  Created by Admin on 15/9/16.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YSClickDelegate <NSObject>
-(void)YSBanerbuttonClick:(int)vid;
@end
@interface ViedoADSrcollView : UIView
@property (nonatomic) CGPoint pageCenter; // pageControl 中心点
@property (nonatomic) CGRect titleFrame;
@property (nonatomic,strong) UIColor *titleBackColor;
@property (nonatomic,strong) NSTimer *timer; // Don't forget set valid when not in front
@property (nonatomic,strong)id<YSClickDelegate> vDelegate;

- (instancetype)initWithNameArr:(NSMutableArray *)imageArr titleArr:(NSMutableArray *)titleArr height:(float)heightValue offsetY:(CGFloat )offsetY offsetx:(CGFloat)offsetx;
@property(assign)CGFloat x;
-(void)closeview;
@end
