//
//  MainView.h
//  ZtqCountry
//
//  Created by Admin on 15/6/3.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServevnDayView.h"

#import "HourWtView.h"
@interface MainView : UIView
@property(nonatomic, strong)ServevnDayView *servenView;

@property(nonatomic, strong)HourWtView *hourView;

@property(nonatomic, strong)NSString *type;
- (void)loadServenData:(NSMutableArray *)infos;
-(void)gethourinfo;
-(void)cacheServen;
-(void)cachehourinfo;
- (void)loadSubTwoView:(BOOL)two;
@end
