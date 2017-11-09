//
//  Skview.h
//  ZtqCountry
//
//  Created by Admin on 15/7/14.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineProgressView.h"
@protocol skDelegate<NSObject>

-(void)skAction;
-(void)fyfindaction;
-(void)airaction;
@end
@interface Skview : UIView{
    CAShapeLayer *arcLayer;
}
@property (strong, nonatomic) UILabel * realTemperatureLab;//实时温度lab
@property(strong,nonatomic)UILabel *pointtempLab;//小数点后的数值
@property (strong, nonatomic) UILabel * sign;//温度的符号
@property (strong, nonatomic) UILabel * sklab;//温度的符号
@property (strong, nonatomic) UILabel * shidulab;//湿度
@property (strong, nonatomic) UILabel * visilab;//visi
@property (strong, nonatomic) UILabel * uptimeLabel;//更新时间显示
@property(strong,nonatomic)UILabel *sunriselab,*sunsetlab;//日出日落
@property (assign, nonatomic) double percent;
@property(strong,nonatomic)LineProgressView *linep;

@property(strong,nonatomic)UIImageView *njdimg,*sdimg;
@property(nonatomic, weak) id<skDelegate>delegate;
-(void)updateSK:(NSDictionary *)skinfo;
@end
