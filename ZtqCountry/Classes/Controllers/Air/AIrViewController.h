//
//  AIrViewController.h
//  ZtqCountry
//
//  Created by Admin on 15/6/10.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "stfzlist.h"
#import "AirinfoList.h"
#import "PMView.h"
@interface AIrViewController : UIViewController<stfzDelegate,airlistDelegate,MFMessageComposeViewControllerDelegate,UIGestureRecognizerDelegate>{
     PMView *_pmView;//图表
}
@property(strong,nonatomic)stfzlist *stfzlist;
@property(strong,nonatomic)AirinfoList *airlist;
@property(strong,nonatomic)UIScrollView *bgscro;
@property(nonatomic,strong)NSString *titlename;
@property(assign)float barHeight,heiht;
@property(retain,nonatomic)UIImageView *navigationBarBg;
@property(strong,nonatomic)UIButton *rightbtn;
@property(strong,nonatomic)UIButton *aqibtn,*stationbtn;
@property(strong,nonatomic)UIImageView *jianceimg;
@property(strong,nonatomic)NSArray *stations;//检测点数
@property(strong,nonatomic)NSMutableArray *stationnames,*stationids,*airitems,*airitemkey;
@property(strong,nonatomic)UILabel *citylab,*aqilab,*wrlab,*pmlab,*jcdlab;
@property(strong,nonatomic)NSString *pub_unitstr,*uptime,*cityname,*cityid;
@property(strong,nonatomic)UIImageView *colorimg;//污染程度颜色
@property(strong,nonatomic)UILabel *airinfolab,*deslab;
@property(strong,nonatomic)UIImageView *isopenimg;
@property(assign)BOOL isopen;
@property(strong,nonatomic)NSArray *remarks;//空气质量说明
@property(strong,nonatomic)NSString *remarktype;//指数类型
@property(strong,nonatomic)UILabel *sixlab,*hblab,*timelab;
@property(strong,nonatomic)UIButton *airremarkbtn;
@property(strong,nonatomic)UIImageView *line;
@property(strong,nonatomic)NSString *countryid;

@property(strong,nonatomic)NSString *sharecontent;//分享内容
@property(strong,nonatomic)UIImage *shareimg;
///对于空气质量详情界面的返回问题的判断值
@property(nonatomic, copy)NSString *popParameter;


-(void)getair_qua_detailWithtype:(NSString *)type withcityid:(NSString *)cityid;
@end

