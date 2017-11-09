//
//  WRScrollView.h
//  ZtqCountry
//
//  Created by Admin on 16/1/14.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol wrClickDelegate <NSObject>
-(void)wrBanerbuttonClick:(int)vid;
@end
@interface WRScrollView : UIView
@property (nonatomic) CGPoint pageCenter; // pageControl 中心点
@property (nonatomic) CGRect titleFrame;
@property (nonatomic,strong) UIColor *titleBackColor;
@property (nonatomic,strong) NSTimer *timer; // Don't forget set valid when not in front
@property (nonatomic,strong)id<wrClickDelegate> Delegate;

- (instancetype)initWithNameArr:(NSMutableArray *)imageArr titleArr:(NSMutableArray *)titleArr height:(float)heightValue offsetY:(CGFloat )offsetY offsetx:(CGFloat)offsetx;
@property(assign)CGFloat x;
@end
