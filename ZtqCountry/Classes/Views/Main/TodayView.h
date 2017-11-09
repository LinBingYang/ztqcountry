//
//  TodayView.h
//  ZtqCountry
//
//  Created by Admin on 15/6/2.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayView : UIView
@property(strong,nonatomic)UIImageView *icoimg,*airicon;
@property(strong,nonatomic)UILabel *wdlab,*wtlab, *sklab;

-(void)updateMainViewData:(NSDictionary *)dataDic;

- (void)updateMainSKTemData:(NSString *)str;

-(void)upAirLev:(NSString *)airlev;
@end
