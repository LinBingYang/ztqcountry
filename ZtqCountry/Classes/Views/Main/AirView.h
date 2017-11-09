//
//  AirView.h
//  ZtqCountry
//
//  Created by Admin on 15/7/14.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol airDelegate<NSObject>

-(void)airAction;
@end

@interface AirView : UIView
@property(nonatomic, weak) id<airDelegate>delegate;
@property(strong,nonatomic)UILabel *airlab,*aqilab,*wulanlab,*healthlab;
-(void)updateAirInfo:(NSDictionary *)airinfo;
@end
