//
//  CustomPickView.h
//  ZtqCountry
//
//  Created by linxg on 14-7-18.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomPickDelegate <NSObject>

-(void)determineWithTime:(NSString *)time;
-(void)cancle;

@end

@interface CustomPickView : UIView

@property (strong, nonatomic) NSArray * firstDataSourse;
@property (strong, nonatomic) NSArray * secondDataSourse;
@property (weak, nonatomic) id<CustomPickDelegate>delegate;
@property (strong, nonatomic) UIView * onView;
@property (assign, nonatomic) int oneIdx;
@property (assign, nonatomic) int twoIdx;

//这个数组是二维数组
-(id)initWithFrame:(CGRect)frame withFirstGroupDataSourse:(NSArray *)firstDataSourse withSecondGroupDataSourse:(NSArray *)secondDataSourse withOnView:(UIView *)onView withOneIdx:(int)one withTwoIdx:(int)two;

-(void)show;
@end
