//
//  ServevnDayView.h
//  ZtqCountry
//
//  Created by 派克斯科技 on 16/10/20.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekView.h"

@interface ServevnDayView : UIView
@property(nonatomic, strong)NSMutableArray *weeksName, *daysName, *wDayIcon, *wDayInfo, *upTem, *lowTem, *hDayInfo, *hDayIcon;

@property(nonatomic, strong)WeekView *weekView;

- (void)updateWithInfos:(NSArray *)infos;

@end
