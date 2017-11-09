//
//  HourWtView.h
//  ZtqCountry
//
//  Created by Admin on 15/6/15.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HourLineView.h"
#import "HourWtScrollview.h"

@interface HourWtView : UIView<UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property(strong,nonatomic)UIImageView *icoimg;
@property(strong,nonatomic)UILabel *timelab,*weathlab;
@property(strong,nonatomic)HourLineView *hourwt;
@property(strong,nonatomic)HourWtScrollview *hwsview;
@property(strong,nonatomic)UIScrollView *mscro;
-(void)updateviewwithico:(NSString*)ico withput:(NSString *)puttime withwt:(NSString *)wt withhig:(NSString *)hig withlowt:(NSString *)lowt withnowct:(NSString *)nowct withnowrain:(NSString *)nowrain withhourlist:(NSArray *)hourlist;
@end
