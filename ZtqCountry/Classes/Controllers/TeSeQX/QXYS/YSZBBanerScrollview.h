//
//  YSZBBanerScrollview.h
//  ZtqCountry
//
//  Created by Admin on 17/1/12.
//  Copyright © 2017年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol yszbClickDelegate <NSObject>
-(void)yszbbuttonClick:(int)vid;
@end
@interface YSZBBanerScrollview : UIView
@property (nonatomic) CGPoint pageCenter; // pageControl 中心点
@property (nonatomic) CGRect titleFrame;
@property (nonatomic,strong) UIColor *titleBackColor;
@property (nonatomic,strong) NSTimer *timer; // Don't forget set valid when not in front
@property (nonatomic,strong)id<yszbClickDelegate> vDelegate;
/**
 *  @method initWithNameArr: titleArr: height:
 *
 *  @param imageArr       图片数组
 *  @param titleArr          标题数组
 *  @param heightValue   视图高度
 *  @param offsetY           高度偏移量
 *
 *  @discussion     默认首页为零，当视图出现或消失时，注意对timer的处理
 */
- (instancetype)initWithNameArr:(NSMutableArray *)imageArr titleArr:(NSMutableArray *)titleArr height:(float)heightValue offsetY:(CGFloat )offsetY offsetx:(CGFloat)offsetx;
-(void)closeview;
@end
