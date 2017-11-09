//
//  ServevnDayView.m
//  ZtqCountry
//
//  Created by 派克斯科技 on 16/10/20.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "ServevnDayView.h"

@implementation ServevnDayView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.weeksName = [NSMutableArray array];
        self.daysName = [NSMutableArray array];
        self.wDayInfo = [NSMutableArray array];
        self.wDayIcon = [NSMutableArray array];
        self.upTem = [NSMutableArray array];
        self.lowTem = [NSMutableArray array];
        self.hDayInfo = [NSMutableArray array];
        self.hDayIcon = [NSMutableArray array];
        [self createTheBaseView];
        
    }
    return self;
}
- (void)createTheBaseView {
    CGFloat start_x = 0;
    CGFloat start_y = 10;
    CGFloat width = kScreenWidth / 7.0;
    CGFloat space = 3;
    for (int i = 0 ; i < 7; i ++) {
        UILabel *weekLab = [self cretaLabelFrame:CGRectMake(start_x + i * width, start_y, width, 20) color:[UIColor whiteColor] font:15];
        [self addSubview:weekLab];
        [self.weeksName addObject:weekLab];
        
        
        UILabel * daylan = [self cretaLabelFrame:CGRectMake(start_x + i * width, start_y + 20 + space , width, 15) color:[UIColor grayColor] font:13];
        daylan.textColor = [UIColor colorWithWhite:0.8 alpha:1];
        
        [self addSubview:daylan];
        [self.daysName addObject:daylan];
        
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((width/2)-15+start_x + i * width , start_y + 20 + space + 15 + space, 30, 30)];
        [self addSubview:imageView];
        [self.wDayIcon addObject:imageView];
        
        
        
        UILabel *wdlab = [self cretaLabelFrame:CGRectMake(start_x + i * width, start_y + 20 + space + 15 + space + 30 + space, width, 20) color:[UIColor whiteColor] font:13];
        [self addSubview:wdlab];
        [self.wDayInfo addObject:wdlab];
        
        
        UILabel *hdaylab = [self cretaLabelFrame:CGRectMake(start_x + i * width, start_y + 5 * space + 185, width, 20) color:[UIColor whiteColor] font:13];
        [self addSubview:hdaylab];
        [self.hDayInfo addObject:hdaylab];
        
        
        
        UIImageView *hdayImg = [[UIImageView alloc]initWithFrame:CGRectMake((width/2)-15+start_x + i * width , start_y  + 6 * space + 205, 30, 30)];
        [self addSubview:hdayImg];
        [self.hDayIcon addObject:hdayImg];
        
    }
//    self.weekView = [[WeekView alloc]initWithFrame:CGRectMake(start_x, start_y + 4 * space + 85, kScreenWidth, 100)];
//    [self addSubview:self.weekView];
    
}


- (UILabel *)cretaLabelFrame:(CGRect)frame color:(UIColor *)color font:(int)font{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = color;
    return label;
    
    
    
}


- (void)updateWithInfos:(NSArray *)infos {
    NSMutableArray *hightarray = [NSMutableArray array];
    NSMutableArray *lowarray = [NSMutableArray array];
    CGFloat high = -100;
    CGFloat low = +100;
    for (int i = 0; i <infos.count ; i ++) {
        NSDictionary *weekInfo = infos[i];
    
        NSString * gdt = [weekInfo objectForKey:@"gdt"];//时间
        NSString * week = [weekInfo objectForKey:@"week"];//周几

        NSString * higt = [weekInfo objectForKey:@"higt"];//高温
        NSString * lowt = [weekInfo objectForKey:@"lowt"];//低温
        NSString *wd_daytime = [weekInfo objectForKey:@"wd_daytime"];
        NSString *wd_nighttime = [weekInfo objectForKey:@"wd_nighttime"];
        NSString * wd_daytime_ico = [weekInfo objectForKey:@"wd_daytime_ico"];//白天天气图标

        NSString * wd_night_ico = [weekInfo objectForKey:@"wd_night_ico"];//夜晚天气图标
        if (gdt.length > 0) {
            NSString *date = [gdt substringFromIndex:gdt.length - 2];
            if ([date isEqualToString:@"01"]) {
                NSString *month = [gdt substringWithRange:NSMakeRange(gdt.length - 4, 2)];
                UILabel *day = (UILabel *)self.daysName[i];
                day.text = [NSString stringWithFormat:@"%@月", month];
            }else {
                UILabel *day = (UILabel *)self.daysName[i];
                day.text = [NSString stringWithFormat:@"%@日", date];
            }
        }
        if (week.length > 0) {
            if ( i == 0 ) {
                UILabel *day = (UILabel *)self.weeksName[i];
                day.text = @"昨天";
            }else if (i== 1) {
                UILabel *day = (UILabel *)self.weeksName[i];
                day.text = @"今天";
                day.textColor = [UIColor yellowColor];
            }else {
                UILabel *day = (UILabel *)self.weeksName[i];
                day.text = week;
            }
        }
        
        if (wd_daytime_ico.length > 0) {
            UIImageView *imageView = (UIImageView *)self.wDayIcon[i];
            imageView.image = [UIImage imageNamed:wd_daytime_ico];
        }
        
        if (wd_night_ico.length > 0) {
            UIImageView *imageView = (UIImageView *)self.hDayIcon[i];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"n%@", wd_night_ico]];
        }
        if (higt.length > 0) {
            [hightarray addObject:higt];
            high = high > higt.doubleValue ? high : higt.doubleValue;
        }
        if (lowt.length > 0) {
            [lowarray addObject:lowt];
            low = low < lowt.doubleValue ? low : lowt.doubleValue;
        }
        
        
        UILabel *day1 = (UILabel *)self.wDayInfo[i];
        day1.text = wd_daytime;
        day1.adjustsFontSizeToFitWidth = YES;
        UILabel *day2 = (UILabel *)self.hDayInfo[i];
        day2.text = wd_nighttime;
        if (i == 0) {
            day1.text = @"白天";
            day2.text = @"夜晨";
        }
        
        

    }
    if (self.weekView) {
        [self.weekView removeFromSuperview];
        self.weekView=nil;
    }
    self.weekView = [[WeekView alloc]initWithFrame:CGRectMake(0, 22 + 85, kScreenWidth, 100)];
    [self addSubview:self.weekView];
    [self.weekView gethights:hightarray Withlowts:lowarray Withmax:high Withmin:low];
    
    
}

@end
