//
//  MapBottomView.h
//  ZtqCountry
//
//  Created by 派克斯科技 on 17/1/13.
//  Copyright © 2017年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapBottomView : UIView<UITableViewDelegate, UITableViewDataSource>



@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)UIView *topContainerView;


@property (nonatomic, strong)UILabel *typeLab;


@property (nonatomic, strong)NSString *cityName;

@property (nonatomic, strong)NSArray *dataSource;
- (id)initWithFrame:(CGRect)frame Good:(int)good littleGood:(int)littleGood LightPollution:(int)lightPollutin midlePollution:(int)midlePollution highLevelPollution:(int)highLeverPullution seriousPollution :(int)seriousPullution datasource:(NSArray *)datasource time:(NSString *) time;


- (void)settypeWithZoomLevel:(CGFloat )zoomLevel text:(NSString *)text select:(BOOL)select;


@end
