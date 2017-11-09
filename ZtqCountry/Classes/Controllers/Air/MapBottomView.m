
//
//  MapBottomView.m
//  ZtqCountry
//
//  Created by 派克斯科技 on 17/1/13.
//  Copyright © 2017年 yyf. All rights reserved.
//

#import "MapBottomView.h"
#import "MapBottomViewCell.h"

@implementation MapBottomView
- (id)initWithFrame:(CGRect)frame Good:(int)good littleGood:(int)littleGood LightPollution:(int)lightPollutin midlePollution:(int)midlePollution highLevelPollution:(int)highLeverPullution seriousPollution:(int)seriousPullution datasource:(NSArray *)datasource time:(NSString *) time{
    self = [super initWithFrame:frame];
    if (self) {
        self.cityName = @"福州";
        self.dataSource = datasource;
        self.typeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/ 2, 20)];
        self.typeLab.font =[ UIFont systemFontOfSize:13];
        self.typeLab.textColor = [UIColor colorWithRed:0 green:174 / 255.0 blue:209 / 255.0 alpha:1.0];
        self.typeLab.textAlignment = NSTextAlignmentCenter;
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2 , 0, kScreenWidth / 2 - 10, 20)];
        timeLabel.font =[ UIFont systemFontOfSize:13];
        timeLabel.textColor =[UIColor grayColor];
        timeLabel.text = time;
        timeLabel.textAlignment = NSTextAlignmentRight;
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5, 20, kScreenWidth/ 2 - 15, 1)];
        line.backgroundColor = [UIColor colorWithRed:0 green:174 / 255.0 blue:209 / 255.0 alpha:1.0];
        [self addSubview:self.typeLab];
        [self addSubview:line];
        [self addSubview:timeLabel];
        
        
        self.tableView= [[UITableView alloc]initWithFrame:CGRectMake(0, 21, kScreenWidth, self.height - 21)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerNib:[UINib nibWithNibName:@"MapBottomViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"mapCell"];
        self.topContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, 21, kScreenWidth, 100)];
        [self createTheViewWithFrame:CGRectMake(0, 3, kScreenWidth / 2, 30) image:[UIImage imageNamed:@"aqi_small_优"] text:[NSString stringWithFormat:@"优:%d个",good]];
        [self createTheViewWithFrame:CGRectMake(0, 36, kScreenWidth / 2, 30) image:[UIImage imageNamed:@"aqi_small_良"] text:[NSString stringWithFormat:@"良:%d个",littleGood]];
        [self createTheViewWithFrame:CGRectMake(0, 69, kScreenWidth / 2, 30) image:[UIImage imageNamed:@"aqi_small_轻度污染"] text:[NSString stringWithFormat:@"轻度污染:%d个",lightPollutin]];
        [self createTheViewWithFrame:CGRectMake(kScreenWidth / 2, 3, kScreenWidth / 2, 30) image:[UIImage imageNamed:@"aqi_small_中度污染"] text:[NSString stringWithFormat:@"中度污染:%d个",midlePollution]];
        [self createTheViewWithFrame:CGRectMake(kScreenWidth / 2, 36, kScreenWidth / 2, 30) image:[UIImage imageNamed:@"aqi_small_重度污染"] text:[NSString stringWithFormat:@"重度污染:%d个",highLeverPullution]];
        [self createTheViewWithFrame:CGRectMake(kScreenWidth / 2, 69, kScreenWidth / 2, 30) image:[UIImage imageNamed:@"aqi_small_严重污染"] text:[NSString stringWithFormat:@"严重污染:%d个",seriousPullution]];
        [self addSubview:self.tableView];
        self.topContainerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.topContainerView];
        [self.topContainerView setHidden:YES];
//        self.topContainerView.userInteractionEnabled = NO;
    }
    return self;
    
}

- (void)createTheViewWithFrame:(CGRect)frame image:(UIImage *)image text:(NSString *)text{
    UIView *ve = [[UIView alloc]initWithFrame:frame];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 7, 40, 16)];
    imageV.image = image;
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, kScreenWidth / 2 - 60, 20)];
    lab.font = [UIFont systemFontOfSize:13];
    lab.text = text;
    [ve addSubview:imageV];
    [ve addSubview:lab];
    [self.topContainerView addSubview:ve];
}
- (void)settypeWithZoomLevel:(CGFloat )zoomLevel text:(NSString *)text  select:(BOOL)select{
    if (text.length > 0) {
        self.cityName = text;
    }
    if (zoomLevel > 6 ||select) {
        self.topContainerView.hidden = YES;
        
        self.typeLab.text = [NSString stringWithFormat:@"%@空气质量统计", self.cityName];
        
    }else {
        self.topContainerView.hidden = NO;
        self.typeLab.text = @"城市空气质量分级统计";
    }
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MapBottomViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"mapCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.cityName.text = dic[@"station_name"];
    cell.aqinum.text = dic[@"aqi"];
//    cell.levelPoll.text = dic[@"quality"];
    cell.levelPoll.text = [self getMapCustomQuality:dic[@"aqi"]];
    cell.aqiImg.image = [self getMapCustomimage:dic[@"aqi"]];
    
    return cell;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (UIImage *)getMapCustomimage:(NSString *)aqivalue {
    int air=aqivalue.intValue;
    UIImage *image;
    if (air>=0 &&air<51) {
        image = [UIImage imageNamed:@"aqi_small_优"];
    }else
        if (air>50 && air <101) {
            image = [UIImage imageNamed:@"aqi_small_良"];
        }else
            if (air>100 && air<151) {
                image = [UIImage imageNamed:@"aqi_small_轻度污染"];
            }else
                if (air>150 && air<201) {
                    image = [UIImage imageNamed:@"aqi_small_中度污染"];
                }else
                    if (air>200 && air<301) {
                        image = [UIImage imageNamed:@"aqi_small_重度污染"];
                        
                    }else
                        if (air>300) {
                            image = [UIImage imageNamed:@"aqi_small_严重污染"];
                        }
    return image;
    
}
- (NSString *)getMapCustomQuality:(NSString *)aqivalue {
    int air=aqivalue.intValue;
    NSString *aqiStr;
    if (air>=0 &&air<51) {
        aqiStr = @"优";
    }else
        if (air>50 && air <101) {
            aqiStr = @"良";
        }else
            if (air>100 && air<151) {
                aqiStr = @"轻度污染";
            }else
                if (air>150 && air<201) {
                    aqiStr = @"中度污染";
                }else
                    if (air>200 && air<301) {
                        aqiStr = @"重度污染";
                    }else
                        if (air>300) {
                            aqiStr = @"严重污染";                         }
    return aqiStr;
    
}


@end
