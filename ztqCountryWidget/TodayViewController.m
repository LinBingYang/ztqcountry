//
//  TodayViewController.m
//  ztqCountryWidget
//
//  Created by 胡彭飞 on 16/6/21.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "UIView+Extension.h"
#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#define ONLINE_URL @"http://218.104.235.90:8088/ztq30_gz/service.do"//决策线上
#define kScreenW   [UIScreen mainScreen].bounds.size.width
#define FONT_15 [UIFont systemFontOfSize:15]
#define sysVersion10         ([[UIDevice currentDevice].systemVersion doubleValue]>=10.0)
@interface TodayViewController () <NCWidgetProviding>
@property(nonatomic,weak) UILabel *sstqLabel;
@property(nonatomic,weak) UILabel *diquLabel;
@property(nonatomic,weak) UIButton  *kongqizhiliangBtn;
@property(nonatomic,weak) UILabel *todayLabel;
@property(nonatomic,weak) UILabel *secondLabel;
@property(nonatomic,weak) UILabel *thirdLabel;
@property(nonatomic,weak) UIImageView *todayHighImage;
@property(nonatomic,weak) UIImageView *secondHighImage;
@property(nonatomic,weak) UIImageView *thirdHighImage;
@property(nonatomic,weak) UILabel *todayHighLabel;
@property(nonatomic,weak) UILabel *secondHighLabel;
@property(nonatomic,weak) UILabel *thirdHighLabel;
@property(nonatomic,weak) UILabel *todayLowLabel;
@property(nonatomic,weak) UILabel *secondLowLabel;
@property(nonatomic,weak) UILabel *thirdLowLabel;
@property(nonatomic,weak) UIImageView *todayLowImage;
@property(nonatomic,weak) UIImageView *secondLowImage;
@property(nonatomic,weak) UIImageView *thirdLowImage;
@property(nonatomic,weak) UIButton  *zhidianTQ;
@property(nonatomic,weak) UIButton  *qixiangCP;
@property(nonatomic,weak) UIButton  *qixiangFW;
@property(nonatomic,weak) UILabel *riqiLabel;
@property(nonatomic,weak) UIButton *yujingLabel;
@property(nonatomic,weak) UIImageView *YJImage;
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) NSOperationQueue *operationQueue;
@property(nonatomic,assign) CGSize maxSize;
@property(nonatomic,strong) UIImageView *backmenban;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.view.subviews) {
        for (UIView *subview in self.view.subviews) {
            [subview removeFromSuperview];
        }
    }
    CGFloat scale=[UIScreen mainScreen].scale;
    CGSize nativesize=[UIScreen mainScreen].currentMode.size;
    CGSize sizepoint=[UIScreen mainScreen].bounds.size;
    if (sysVersion10) {
        if (scale *sizepoint.width==nativesize.width) {
            [self setupView3];
        }else{
            [self setupView3];
        }
    }else
    {
        if (scale *sizepoint.width==nativesize.width) {
            [self setupView];
        }else{
            [self setupView1];
        }
    }
    
    NSOperationQueue *operationQueue=[[NSOperationQueue alloc] init];
    self.operationQueue=operationQueue;
    NSBlockOperation *op1=[[NSBlockOperation alloc] init];
    [op1 addExecutionBlock:^{
        [self loadDatas];
    }];
    [operationQueue addOperation:op1];
    NSBlockOperation *op2=[[NSBlockOperation alloc] init];
    [op2 addExecutionBlock:^{
        [self loadOneWeekDatas];
    }];
    [operationQueue addOperation:op2];
    NSBlockOperation *op3=[[NSBlockOperation alloc] init];
    [op3 addExecutionBlock:^{
        [self loadbottomWeek];
    }];
    [operationQueue addOperation:op3];
    NSBlockOperation *op4=[[NSBlockOperation alloc] init];
    [op4 addExecutionBlock:^{
        [self loadingAirInfoSimple];
    }];
    [operationQueue addOperation:op4];
    NSBlockOperation *op5=[[NSBlockOperation alloc] init];
    [op5 addExecutionBlock:^{
        [self loadingyjxx];
    }];
    [operationQueue addOperation:op5];
    if (sysVersion10) {
        NSBlockOperation *op6=[[NSBlockOperation alloc] init];
        [op5 addExecutionBlock:^{
            [self loadbgview];
        }];
        [operationQueue addOperation:op6];
    }

        

    
}
-(void)loadingyjxx
{
    NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.com.app.ztqCountry"];
    NSString *appid=[userDf objectForKey:@"appid"];
    NSString *xianshiid=[userDf objectForKey:@"xianshiid"];
      NSString *currentID=[userDf objectForKey:@"currentCityID"];
    /**
     *  取缓存数据
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *desc=[userDf objectForKey:@"desc"];
        [self.yujingLabel setTitle:desc forState:UIControlStateNormal];
    });
    if (xianshiid==nil) {
        xianshiid=@"1069";
    }
//    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//    [h setObject:appid forKey:@"p"];
//    NSMutableDictionary * yjxx_index = [[NSMutableDictionary alloc] init];
//    [yjxx_index setObject:xianshiid forKey:@"area"];
//    [b setObject:yjxx_index forKey:@"yjxx_index"];
//    [param setObject:h forKey:@"h"];
//    [param setObject:b forKey:@"b"];
//    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
//    NSString *jsonStr=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSMutableDictionary *p=[NSMutableDictionary dictionary];
//    [p setObject:jsonStr forKey:@"p"];
//    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
//    [manager POST:ONLINE_URL parameters:p progress:^(NSProgress *  uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask *  task, id   responseObject) {
//        NSDictionary * b = [responseObject objectForKey:@"b"];
//        if (b!=nil) {
//            NSDictionary * yjxx_index = [b objectForKey:@"yjxx_index"];
//            NSDictionary *dws_city=[yjxx_index objectForKey:@"dataList"];
//            NSDictionary *put_str=[yjxx_index objectForKey:@"put_str"];
//            NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:dws_city];
//            //            [dic setValue:dws_city forKey:@"dws_city"];
//            [dic setValue:put_str forKey:@"put_str"];
//            [userDf setObject:dic forKey:@"dws_city"];
//            NSString *desc=[dws_city objectForKey:@"desc"];
//            if (desc==nil) {
//                [self.yujingLabel setTitle:@"暂无预警" forState:UIControlStateNormal];
//                [userDf setObject:@"暂无预警" forKey:@"desc"];
//            }else{
//                [self.yujingLabel setTitle:desc forState:UIControlStateNormal];
//                [userDf setObject:desc forKey:@"desc"];
//            }
//            [userDf synchronize];
//        }
//    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
//        NSLog(@"%@",error);
//    }];
    NSString * urlStr = ONLINE_URL;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:appid forKey:@"p"];
    NSMutableDictionary * yjxx_index = [[NSMutableDictionary alloc] init];
    if (currentID.length>0) {
        [yjxx_index setObject:currentID forKey:@"county_id"];
    }
    [b setObject:yjxx_index forKey:@"gz_warn_index"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
    NSString *jsonStr=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *p=[NSMutableDictionary dictionary];
    [p setObject:jsonStr forKey:@"p"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlStr parameters:p progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * b = [responseObject objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * yjxx_index = [b objectForKey:@"gz_warn_index"];
            NSArray *warn_list=[yjxx_index objectForKey:@"warn_list"];
            if (warn_list.count>0) {
                NSString *title=[warn_list[0] objectForKey:@"title"];
                NSString *ico=[warn_list[0] objectForKey:@"ico"];
                [userDf setObject:warn_list[0] forKey:@"dws_city"];
                [self.yujingLabel setTitle:title forState:UIControlStateNormal];
                CGFloat scale=[UIScreen mainScreen].scale;
                CGSize nativesize=[UIScreen mainScreen].currentMode.size;
                CGSize sizepoint=[UIScreen mainScreen].bounds.size;
                if (scale *sizepoint.width==nativesize.width) {
                    [self.yujingLabel sizeToFit];
                    CGFloat width=self.yujingLabel.frame.size.width;
                    //                    kScreenW-200, CGRectGetMaxY(zhidianTQ.frame)+marginY, 180, 30
                    self.yujingLabel.frame=CGRectMake(kScreenW-width-10, CGRectGetMaxY(self.zhidianTQ.frame)+15, width, 30);
//                    [self.yujingLabel setBackgroundColor:[UIColor redColor] ];
                    self.YJImage.frame=CGRectMake(kScreenW-width-35, CGRectGetMaxY(self.zhidianTQ.frame)+15+5, 20, 20);
                    [userDf synchronize];
                    
                    if (sysVersion10) {
                        self.yujingLabel.frame=CGRectMake(self.view.frame.size.width-width-10, CGRectGetMaxY(self.zhidianTQ.frame)+15, width, 30);
                        self.YJImage.frame=CGRectMake(self.view.frame.size.width-width-35, CGRectGetMaxY(self.zhidianTQ.frame)+15+5, 20, 20);
                    }
                }else{
                    [self.yujingLabel sizeToFit];
                    CGFloat width=self.yujingLabel.frame.size.width;
                    //                    kScreenW-200, CGRectGetMaxY(zhidianTQ.frame)+marginY, 180, 30
                    self.yujingLabel.frame=CGRectMake(kScreenW/2-width-10, CGRectGetMaxY(self.zhidianTQ.frame)+15, width, 30);
                    self.YJImage.frame=CGRectMake(kScreenW/2-width-35, CGRectGetMaxY(self.zhidianTQ.frame)+15+5, 20, 20);
                    [userDf synchronize];
                    if (sysVersion10) {
                        self.yujingLabel.frame=CGRectMake(self.view.frame.size.width-width-10, CGRectGetMaxY(self.zhidianTQ.frame)+15, width, 30);
                        self.YJImage.frame=CGRectMake(self.view.frame.size.width-width-35, CGRectGetMaxY(self.zhidianTQ.frame)+15+5, 20, 20);
                    }
                }
        
                
            }else{
                
                    [self.yujingLabel setTitle:@"暂无预警" forState:UIControlStateNormal];
                    [userDf setObject:@"暂无预警" forKey:@"desc"];
                CGFloat scale=[UIScreen mainScreen].scale;
                CGSize nativesize=[UIScreen mainScreen].currentMode.size;
                CGSize sizepoint=[UIScreen mainScreen].bounds.size;
                if (scale *sizepoint.width==nativesize.width) {
                    [self.yujingLabel sizeToFit];
                    CGFloat width=self.yujingLabel.frame.size.width;
                    //                    kScreenW-200, CGRectGetMaxY(zhidianTQ.frame)+marginY, 180, 30
                    self.yujingLabel.frame=CGRectMake(kScreenW-width-10, CGRectGetMaxY(self.zhidianTQ.frame)+15, width, 30);
                    //                    [self.yujingLabel setBackgroundColor:[UIColor redColor] ];
                    self.YJImage.frame=CGRectMake(kScreenW-width-35, CGRectGetMaxY(self.zhidianTQ.frame)+15+5, 20, 20);
                    if (sysVersion10) {
                        self.yujingLabel.frame=CGRectMake(self.view.frame.size.width-width-10, CGRectGetMaxY(self.zhidianTQ.frame)+15, width, 30);
                        self.YJImage.frame=CGRectMake(self.view.frame.size.width-width-35, CGRectGetMaxY(self.zhidianTQ.frame)+15+5, 20, 20);
                    }
                }else{
                    [self.yujingLabel sizeToFit];
                    CGFloat width=self.yujingLabel.frame.size.width;
                    //                    kScreenW-200, CGRectGetMaxY(zhidianTQ.frame)+marginY, 180, 30
                    self.yujingLabel.frame=CGRectMake(kScreenW/2-width-10, CGRectGetMaxY(self.zhidianTQ.frame)+15, width, 30);
                    self.YJImage.frame=CGRectMake(kScreenW/2-width-35, CGRectGetMaxY(self.zhidianTQ.frame)+15+5, 20, 20);
                    [userDf synchronize];
                    if (sysVersion10) {
                        self.yujingLabel.frame=CGRectMake(self.view.frame.size.width-width-10, CGRectGetMaxY(self.zhidianTQ.frame)+15, width, 30);
                        self.YJImage.frame=CGRectMake(self.view.frame.size.width-width-35, CGRectGetMaxY(self.zhidianTQ.frame)+15+5, 20, 20);
                    }
                }

            }
        }
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];


}
#pragma mark 获取空气质量数据------------------------------------------------------------------------
-(void)loadingAirInfoSimple
{
    NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.com.app.ztqCountry"];
    NSString *appid=[userDf objectForKey:@"appid"];
    NSString *xianshiid=[userDf objectForKey:@"xianshiid"];
    NSString *currentID=[userDf objectForKey:@"currentCityID"];
    /**
     *  取缓存数据
     */
    NSString *quality=[userDf objectForKey:@"quality"];
    NSString *aqi=[userDf objectForKey:@"aqi"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setkongqizhiliangView:quality andAqi:aqi];
    });
    if (xianshiid==nil) {
        xianshiid=@"1069";
    }
//    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//    [h setObject:appid forKey:@"p"];
//    NSMutableDictionary * airInfoSimple = [[NSMutableDictionary alloc] init];
//    [airInfoSimple setObject:xianshiid forKey:@"area"];
//    [airInfoSimple setObject:@1 forKey:@"type"];
//    [b setObject:airInfoSimple forKey:@"airinfosimple"];
//    [param setObject:h forKey:@"h"];
//    [param setObject:b forKey:@"b"];
//    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
//    NSString *jsonStr=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSMutableDictionary *p=[NSMutableDictionary dictionary];
//    [p setObject:jsonStr forKey:@"p"];
//    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
//    [manager POST:ONLINE_URL parameters:p progress:^(NSProgress *  uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask *  task, id   responseObject) {
//        NSDictionary * b = [responseObject objectForKey:@"b"];
//        NSDictionary * airInfoSimple = [b objectForKey:@"airinfosimple"];
//        NSString * quality = [airInfoSimple objectForKey:@"quality"];
//        NSString * aqi = [airInfoSimple objectForKey:@"aqi"];
//        [self setkongqizhiliangView:quality andAqi:aqi];
//        /**
//         *  缓存数据
//         */
//        [userDf setObject:quality forKey:@"quality"];
//        [userDf setObject:aqi forKey:@"aqi"];
//        [userDf synchronize];
//    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
//        NSLog(@"%@",error);
//    }];
    NSString * urlStr = ONLINE_URL;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:appid forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    if (currentID.length>0) {
        [gz_todaywt_inde setObject:currentID forKey:@"county_id"];
    }
    [gz_todaywt_inde setObject:@"1" forKey:@"type"];
    [b setObject:gz_todaywt_inde forKey:@"gz_air_qua_index"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
     NSData *jsonData=[NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
     NSString *jsonStr=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     NSMutableDictionary *p=[NSMutableDictionary dictionary];
     [p setObject:jsonStr forKey:@"p"];
 AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        [manager POST:ONLINE_URL parameters:p progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary * b = [responseObject objectForKey:@"b"];
             
             if (b!=nil) {
                 NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_air_qua_index"];
                 if (gz_air_qua_index!=nil) {
                     NSDictionary *air_qua=[gz_air_qua_index objectForKey:@"air_qua"];
                     NSString *aqi=[air_qua objectForKey:@"aqi"];
                      NSString *quality=[air_qua objectForKey:@"quality"];
                      [self setkongqizhiliangView:quality andAqi:aqi];
                     /**
                      *  缓存数据
                      */
                     [userDf setObject:quality forKey:@"quality"];
                     [userDf setObject:aqi forKey:@"aqi"];
                     [userDf synchronize];
                 }
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
         }];
   
}
-(void)setkongqizhiliangView:(NSString *)quality andAqi:(NSString *)aqi
{
    if (quality.length>0) {
        [self.kongqizhiliangBtn setTitle:quality forState:UIControlStateNormal];
    }else{
        [self.kongqizhiliangBtn setTitle:@"暂无" forState:UIControlStateNormal];
    }
    int air=aqi.intValue;
    if (air>0 &&air<51) {
        [self.kongqizhiliangBtn setBackgroundColor:[UIColor colorWithRed:101.0/255.0f green:240.0/255.0f blue:2.0/255.0f alpha:1.0f]];
    }else
        if (air>50 && air <101) {
            [self.kongqizhiliangBtn setBackgroundColor:[UIColor colorWithRed:255.0/255.0f green:222.0/255.0f blue:0/255.0f alpha:1.0f]];
        }else
            if (air>100 && air<151) {
                [self.kongqizhiliangBtn setBackgroundColor:[UIColor colorWithRed:253.0/255.0f green:164.0/255.0f blue:10.0/255.0f alpha:1.0f]];
            }else
                if (air>150 && air<201) {
                    [self.kongqizhiliangBtn setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:8.0/255.0f blue:2.0/255.0f alpha:1.0f]];
                }else
                    if (air>200 && air<301) {
                        [self.kongqizhiliangBtn setBackgroundColor:[UIColor colorWithRed:153.0/255.0f green:0.0/255.0f blue:153.0/255.0f alpha:1.0f]];
                    }else
                        if (air>300) {
                            [self.kongqizhiliangBtn setBackgroundColor:[UIColor colorWithRed:139.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:1.0f]];
                        }
    
}
#pragma mark 获取底部日历数据------------------------------------------------------------------------
-(void)loadbottomWeek
{
    NSDate *nowdate=[NSDate date];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    dateFormat.timeZone=[NSTimeZone localTimeZone];
    [dateFormat setDateFormat:@"MM月dd日"];
    NSString *nowStr=[dateFormat stringFromDate:nowdate];
    NSString *nongliStr=[self getChineseCalendarWithDate:[NSDate date]];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.riqiLabel.text=[NSString stringWithFormat:@"%@  %@",nowStr,nongliStr];
    });
    
}
-(NSString*)getChineseCalendarWithDate:(NSDate *)date{
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
    unsigned unitFlags =NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@%@",m_str,d_str];
    
    return chineseCal_str;  
}
#pragma mark 获取一周天气数据-------------------------------------------------------------------------
-(void)setOneWEEKWithdatas:(NSDictionary *)todayDatas secondDay:(NSDictionary *)secondDatas thirdDay:(NSDictionary *)thirdDatas
{
    /**
     *  今天的天气
     */
    
    NSString *wd_day_ico=todayDatas[@"wd_daytime_ico"];
    NSString *wd_day_icoNew=[NSString stringWithFormat:@"b%@",wd_day_ico];
    self.todayHighImage.image=[UIImage imageNamed:wd_day_icoNew];
    NSString *high=[NSString stringWithFormat:@"%@°",todayDatas[@"higt"]];
    self.todayHighLabel.text=high;
    NSString *wd_night_ico=todayDatas[@"wd_night_ico"];
    NSString *wd_night_icoNew=[NSString stringWithFormat:@"1n%@",wd_night_ico];
    self.todayLowImage.image=[UIImage imageNamed:wd_night_icoNew];
    NSString *lowt=[NSString stringWithFormat:@"%@°",todayDatas[@"lowt"]];
    self.todayLowLabel.text=lowt;
    /**
     *  明天的天气
     */
    
    NSString *secondweek=secondDatas[@"week"];
    self.secondLabel.text=secondweek;
    NSString *secondwd_day_ico=secondDatas[@"wd_daytime_ico"];
    NSString *secondwd_day_icoNew=[NSString stringWithFormat:@"b%@",secondwd_day_ico];
    self.secondHighImage.image=[UIImage imageNamed:secondwd_day_icoNew];
    NSString *secondhigh=[NSString stringWithFormat:@"%@°",secondDatas[@"higt"]];
    self.secondHighLabel.text=secondhigh;
    NSString *secondwd_night_ico=secondDatas[@"wd_daytime_ico"];
    NSString *secondwd_night_icoNew=[NSString stringWithFormat:@"1n%@",secondwd_night_ico];
    self.secondLowImage.image=[UIImage imageNamed:secondwd_night_icoNew];
    NSString *secondlowt=[NSString stringWithFormat:@"%@°",secondDatas[@"lowt"]];
    self.secondLowLabel.text=secondlowt;
    /**
     *  后天的天气
     */
    
    NSString *thirdweek=thirdDatas[@"week"];
    self.thirdLabel.text=thirdweek;
    NSString *thirdwd_day_ico=thirdDatas[@"wd_daytime_ico"];
    NSString *thirdwd_day_icoNew=[NSString stringWithFormat:@"b%@",thirdwd_day_ico];
    self.thirdHighImage.image=[UIImage imageNamed:thirdwd_day_icoNew];
    NSString *thirdhigh=[NSString stringWithFormat:@"%@°",thirdDatas[@"higt"]];
    self.thirdHighLabel.text=thirdhigh;
    NSString *thirdwd_night_ico=thirdDatas[@"wd_night_ico"];
    NSString *thirdwd_night_icoNew=[NSString stringWithFormat:@"1n%@",thirdwd_night_ico];
    self.thirdLowImage.image=[UIImage imageNamed:thirdwd_night_icoNew];
    NSString *thirdlowt=[NSString stringWithFormat:@"%@°",thirdDatas[@"lowt"]];
    self.thirdLowLabel.text=thirdlowt;
    
}
-(void)loadOneWeekDatas
{
    NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.com.app.ztqCountry"];
    NSString *appid=[userDf objectForKey:@"appid"];
    NSString *currentID=[userDf objectForKey:@"currentCityID"];
    NSString *xianshiid=[userDf objectForKey:@"xianshiid"];
    /**
     *  这个是取缓存数据
     */
    NSDictionary *todayDatas=[userDf objectForKey:@"todayDatas"];
    NSDictionary *secondDatas=[userDf objectForKey:@"secondDatas"];
    NSDictionary *thirdDatas=[userDf objectForKey:@"thirdDatas"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setOneWEEKWithdatas:todayDatas secondDay:secondDatas thirdDay:thirdDatas];
    });
    if (currentID==nil) {
        currentID=@"30900";
    }
    if (xianshiid==nil) {
        xianshiid=@"1069";
    }
//    NSMutableDictionary * weekTq = [[NSMutableDictionary alloc] init];
//    [weekTq setObject:xianshiid forKey:@"area"];
//    [weekTq setObject:currentID forKey:@"country"];
//    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//    //    [b setObject:weekTq forKey:@"weektq"];//原来一周
//    [b setObject:weekTq forKey:@"new_week"];//曲线一周
//    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//    [h setObject:appid forKey:@"p"];
//    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//    [param setObject:h forKey:@"h"];
//    [param setObject:b forKey:@"b"];
//    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
//    NSString *jsonStr=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSMutableDictionary *p=[NSMutableDictionary dictionary];
//    [p setObject:jsonStr forKey:@"p"];
//    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
//    [manager POST:ONLINE_URL parameters:p progress:^(NSProgress *  uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask *  task, id   responseObject) {
//        NSDictionary *b=responseObject[@"b"];
//        NSDictionary *new_week=b[@"new_week"];
//        NSArray *weekArrays=new_week[@"week"];
//        if (weekArrays.count) {
//            NSDictionary *todayDatas=weekArrays[1];
//            NSDictionary *secondDatas=weekArrays[2];
//            NSDictionary *thirdDatas=weekArrays[3];
//            [self setOneWEEKWithdatas:todayDatas secondDay:secondDatas thirdDay:thirdDatas];
//            /**
//             *  把数据缓存
//             */
//            [userDf setObject:todayDatas forKey:@"todayDatas"];
//            [userDf setObject:secondDatas forKey:@"secondDatas"];
//            [userDf setObject:thirdDatas forKey:@"thirdDatas"];
//            [userDf synchronize];
//        }
//    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
//        NSLog(@"%@",error);
//    }];
    NSString * urlStr = ONLINE_URL;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:appid forKey:@"p"];
    NSMutableDictionary * gz_weekwt = [[NSMutableDictionary alloc] init];
    [gz_weekwt setObject:currentID forKey:@"county_id"];
    [b setObject:gz_weekwt forKey:@"gz_weekwt"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
        NSData *jsonData=[NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
        NSString *jsonStr=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *p=[NSMutableDictionary dictionary];
        [p setObject:jsonStr forKey:@"p"];

    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager POST:urlStr parameters:p progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * b = [responseObject objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_weekwt"];
            NSArray *weekinfos=[gz_air_qua_index objectForKey:@"weekwt_list"];
            if (weekinfos.count) {
                 NSDictionary *todayDatas=weekinfos[1];
                NSDictionary *secondDatas=weekinfos[2];
                NSDictionary *thirdDatas=weekinfos[3];
                [self setOneWEEKWithdatas:todayDatas secondDay:secondDatas thirdDay:thirdDatas];
                            /**
                             *  把数据缓存
                             */
                [userDf setObject:todayDatas forKey:@"todayDatas"];
                [userDf setObject:secondDatas forKey:@"secondDatas"];
                [userDf setObject:thirdDatas forKey:@"thirdDatas"];
                [userDf synchronize];
            }

        }
    }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
#pragma mark 获取实时天气数据-------------------------------------------------------------------------
-(void)loadDatas
{
    
    NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.com.app.ztqCountry"];
    NSString *appid=[userDf objectForKey:@"appid"];
    NSString *currentID=[userDf objectForKey:@"currentCityID"];
    NSString *currentCity=[userDf objectForKey:@"currentCity"];
    /**
     *  这个是取缓存数据
     */
    NSString *sstqLabelText=[userDf objectForKey:@"sstqLabel"];
    if(sstqLabelText)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.sstqLabel.text=[NSString stringWithFormat:@"%@°",sstqLabelText];
        });
    }
    if (currentID==nil) {
        currentID=@"30900";
    }
    if (currentCity==nil) {
        currentCity=@"福州";
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.diquLabel.text=currentCity;
    });
//    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * sstq = [[NSMutableDictionary alloc] init];
//    [h setObject:appid forKey:@"p"];
//    [sstq setObject:currentID forKey:@"area"];
//    [b setObject:sstq forKey:@"sstq"];
//    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//    [param setObject:h forKey:@"h"];
//    [param setObject:b forKey:@"b"];
//    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
//    NSString *jsonStr=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSMutableDictionary *p=[NSMutableDictionary dictionary];
//    [p setObject:jsonStr forKey:@"p"];
//    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
//    [manager POST:ONLINE_URL parameters:p progress:^(NSProgress *  uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask *  task, id   responseObject) {
//        NSDictionary *b=responseObject[@"b"];
//        NSDictionary *sstq1=b[@"sstq"];
//        NSDictionary *sstq2=sstq1[@"sstq"];
//        //        NSLog(@"%@",[NSThread currentThread]);
//        if (sstq2[@"ct"]) {
//            self.sstqLabel.text=[NSString stringWithFormat:@"%@°",sstq2[@"ct"]];
//            [userDf setObject:sstq2[@"ct"] forKey:@"sstqLabel"];
//            [userDf synchronize];
//        }
//    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
//        NSLog(@"%@",error);
//    }];
    NSString * urlStr = ONLINE_URL;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:appid forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    if (currentID.length>0) {
        [gz_todaywt_inde setObject:currentID forKey:@"county_id"];
    }
    [b setObject:gz_todaywt_inde forKey:@"gz_realwt_index"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
    NSString *jsonStr=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *p=[NSMutableDictionary dictionary];
    [p setObject:jsonStr forKey:@"p"];
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager POST:ONLINE_URL parameters:p progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * b = [responseObject objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_realwt_index = [b objectForKey:@"gz_realwt_index"];
            if (gz_realwt_index!=nil) {
                NSDictionary *realwt=[gz_realwt_index objectForKey:@"realwt"];
                NSString *ct=[realwt objectForKey:@"ct"];
                self.sstqLabel.text=[NSString stringWithFormat:@"%@°",ct];
                [userDf setObject:ct forKey:@"sstqLabel"];
                [userDf synchronize];
            }
   
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
   
    
}

#pragma mark 按钮点击事件-----------------------------------------------------------------------------
-(void)bottomBtnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 1:
        {
            [self.extensionContext openURL:[NSURL URLWithString:@"com.pcs.ztqNew://ztqNEW.lvyouqixiang"] completionHandler:nil];
            
        }
            break;
        case 2:
        {
            [self.extensionContext openURL:[NSURL URLWithString:@"com.pcs.ztqNew://ztqNEW.fengyuchaxun"] completionHandler:nil];
            
        }
            break;
        case 4:
        {
            
            [self.extensionContext openURL:[NSURL URLWithString:@"com.pcs.ztqNew://ztqNEW"] completionHandler:nil];
        }
            break;
        case 5:
        {
            if([self.yujingLabel.titleLabel.text isEqualToString:@"暂无预警"]) return;
            [self.extensionContext openURL:[NSURL URLWithString:@"com.pcs.ztqNew://ztqNEW.yujingxxWidget"] completionHandler:nil];
        }
            break;
    }
    
}
#pragma mark 界面初始化------------------------------------------------------------------------------
-(void)setupView
{
    CGFloat marginX=15;
    CGFloat marginY=15;
    
    /**
     实时天气
     */
    UILabel *sstqLabel=[[UILabel alloc] initWithFrame:CGRectMake(kScreenW-150, marginY, 250, 70)];
    sstqLabel.font=[UIFont fontWithName: @"STHeitiTC-Light" size:60];
    sstqLabel.textColor=[UIColor whiteColor];
    self.sstqLabel=sstqLabel;
    sstqLabel.text=@"9.6°";
    [self.view addSubview:sstqLabel];
    /**
     地区
     */
    UILabel *diquLabel=[[UILabel alloc] initWithFrame:CGRectMake(2*marginX, marginY, 80, 20)];
    diquLabel.font=FONT_15;
    self.diquLabel=diquLabel;
    diquLabel.textColor=[UIColor whiteColor];
    diquLabel.textAlignment=NSTextAlignmentCenter;
    diquLabel.text=@"福州鼓楼区";
    [self.view addSubview:diquLabel];
    
    /**
     空气质量
     */
    UIButton *kongqizhiliangBtn=[[UIButton alloc] initWithFrame:CGRectMake(2*marginX, CGRectGetMaxY(diquLabel.frame)+5, 80, 20)];
    [kongqizhiliangBtn setBackgroundColor:[UIColor colorWithRed:1/255.0 green:205/255.0 blue:59/255.0 alpha:1]];
    self.kongqizhiliangBtn=kongqizhiliangBtn;
    kongqizhiliangBtn.centerX=diquLabel.centerX;
    [kongqizhiliangBtn setTitle:@"良" forState:UIControlStateNormal];
    kongqizhiliangBtn.titleLabel.font=FONT_15;
    [kongqizhiliangBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    kongqizhiliangBtn.layer.cornerRadius=10;
    kongqizhiliangBtn.clipsToBounds=YES;
    [self.view addSubview:kongqizhiliangBtn];
    
    /**
     三天天气日期
     */
    CGFloat TodayLabelW=kScreenW/3;
    UILabel *todayLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sstqLabel.frame), TodayLabelW, 20)];
    self.todayLabel=todayLabel;
    todayLabel.font=FONT_15;
    todayLabel.textColor=[UIColor whiteColor];
    todayLabel.textAlignment=NSTextAlignmentCenter;
    todayLabel.text=@"今天";
    [self.view addSubview:todayLabel];
    
    UILabel *secondLabel=[[UILabel alloc] initWithFrame:CGRectMake(TodayLabelW, CGRectGetMaxY(sstqLabel.frame), TodayLabelW, 20)];
    self.secondLabel=secondLabel;
    secondLabel.font=FONT_15;
    secondLabel.textColor=[UIColor whiteColor];
    secondLabel.textAlignment=NSTextAlignmentCenter;
    secondLabel.text=@"周三";
    [self.view addSubview:secondLabel];
    
    UILabel *thirdLabel=[[UILabel alloc] initWithFrame:CGRectMake(2*TodayLabelW, CGRectGetMaxY(sstqLabel.frame), TodayLabelW, 20)];
    self.thirdLabel=thirdLabel;
    thirdLabel.font=FONT_15;
    thirdLabel.textColor=[UIColor whiteColor];
    thirdLabel.textAlignment=NSTextAlignmentCenter;
    thirdLabel.text=@"周三";
    [self.view addSubview:thirdLabel];
    /**
     三天高温天气图片
     */
    CGFloat imageW=40;
    UIImageView *todayHighImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(todayLabel.frame), imageW, imageW)];
    self.todayHighImage=todayHighImage;
    todayHighImage.centerX=todayLabel.centerX;
    todayHighImage.image=[UIImage imageNamed:@"b00"];
    todayHighImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:todayHighImage];
    
    UIImageView *secondHighImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(todayLabel.frame), imageW, imageW)];
    self.secondHighImage=secondHighImage;
    secondHighImage.centerX=secondLabel.centerX;
    secondHighImage.image=[UIImage imageNamed:@"b00"];
    secondHighImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:secondHighImage];
    
    UIImageView *thirdHighImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(todayLabel.frame), imageW, imageW)];
    self.thirdHighImage=thirdHighImage;
    thirdHighImage.centerX=thirdLabel.centerX;
    thirdHighImage.image=[UIImage imageNamed:@"b00"];
    thirdHighImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:thirdHighImage];
    /**
     三天高温天气label
     */
    UILabel *todayHighLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(todayHighImage.frame), TodayLabelW, 20)];
    self.todayHighLabel=todayHighLabel;
    todayHighLabel.font=FONT_15;
    todayHighLabel.textColor=[UIColor whiteColor];
    todayHighLabel.textAlignment=NSTextAlignmentCenter;
    todayHighLabel.text=@"16°";
    [self.view addSubview:todayHighLabel];
    
    UILabel *secondHighLabel=[[UILabel alloc] initWithFrame:CGRectMake(TodayLabelW, CGRectGetMaxY(todayHighImage.frame), TodayLabelW, 20)];
    self.secondHighLabel=secondHighLabel;
    secondHighLabel.font=FONT_15;
    secondHighLabel.textColor=[UIColor whiteColor];
    secondHighLabel.textAlignment=NSTextAlignmentCenter;
    secondHighLabel.text=@"16°";
    [self.view addSubview:secondHighLabel];
    
    UILabel *thirdHighLabel=[[UILabel alloc] initWithFrame:CGRectMake(2*TodayLabelW, CGRectGetMaxY(todayHighImage.frame), TodayLabelW, 20)];
    self.thirdHighLabel=thirdHighLabel;
    thirdHighLabel.font=FONT_15;
    thirdHighLabel.textColor=[UIColor whiteColor];
    thirdHighLabel.textAlignment=NSTextAlignmentCenter;
    thirdHighLabel.text=@"16°";
    [self.view addSubview:thirdHighLabel];
    /**
     三天低温天气label
     */
    UILabel *todayLowLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(todayHighLabel.frame)+5, TodayLabelW, 20)];
    self.todayLowLabel=todayLowLabel;
    todayLowLabel.font=FONT_15;
    todayLowLabel.textColor=[UIColor whiteColor];
    todayLowLabel.textAlignment=NSTextAlignmentCenter;
    todayLowLabel.text=@"16°";
    [self.view addSubview:todayLowLabel];
    
    UILabel *secondLowLabel=[[UILabel alloc] initWithFrame:CGRectMake(TodayLabelW, CGRectGetMaxY(todayHighLabel.frame)+5, TodayLabelW, 20)];
    self.secondLowLabel=secondLowLabel;
    secondLowLabel.font=FONT_15;
    secondLowLabel.textColor=[UIColor whiteColor];
    secondLowLabel.textAlignment=NSTextAlignmentCenter;
    secondLowLabel.text=@"16°";
    [self.view addSubview:secondLowLabel];
    
    UILabel *thirdLowLabel=[[UILabel alloc] initWithFrame:CGRectMake(2*TodayLabelW, CGRectGetMaxY(todayHighLabel.frame)+5, TodayLabelW, 20)];
    self.thirdLowLabel=thirdLowLabel;
    thirdLowLabel.font=FONT_15;
    thirdLowLabel.textColor=[UIColor whiteColor];
    thirdLowLabel.textAlignment=NSTextAlignmentCenter;
    thirdLowLabel.text=@"16°";
    [self.view addSubview:thirdLowLabel];
    /**
     三天低温天气图片
     */
    UIImageView *todayLowImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(todayLowLabel.frame), imageW, imageW)];
    self.todayLowImage=todayLowImage;
    todayLowImage.centerX=todayLabel.centerX;
    todayLowImage.image=[UIImage imageNamed:@"b00"];
    todayLowImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:todayLowImage];
    
    UIImageView *secondLowImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(todayLowLabel.frame), imageW, imageW)];
    self.secondLowImage=secondLowImage;
    secondLowImage.centerX=secondLabel.centerX;
    secondLowImage.image=[UIImage imageNamed:@"b00"];
    secondLowImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:secondLowImage];
    
    UIImageView *thirdLowImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(todayLowLabel.frame), imageW, imageW)];
    self.thirdLowImage=thirdLowImage;
    thirdLowImage.centerX=thirdLabel.centerX;
    thirdLowImage.image=[UIImage imageNamed:@"b00"];
    thirdLowImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:thirdLowImage];
    
    /**
     底部三个Btn
     */
    CGFloat bottomMargin=70;
    CGFloat BottomBtnW=(kScreenW-2*bottomMargin-30)/2;
    CGFloat BottomBtnH=30;
    UIButton *zhidianTQ=[[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(todayLowImage.frame)+marginY, 100, BottomBtnH)];
    //    [zhidianTQ setBackgroundImage:[UIImage imageNamed:@"notificationBtnBackground.png"] forState:UIControlStateNormal];
    self.zhidianTQ=zhidianTQ;
    zhidianTQ.tag=1;
    [zhidianTQ addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [zhidianTQ setTitle:@"旅游气象" forState:UIControlStateNormal];
    zhidianTQ.titleLabel.font=FONT_15;
    [zhidianTQ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    zhidianTQ.layer.cornerRadius=15;
//    zhidianTQ.layer.borderWidth=1.0;
//    zhidianTQ.layer.borderColor=[UIColor whiteColor].CGColor;
//    zhidianTQ.clipsToBounds=YES;
    zhidianTQ.titleEdgeInsets=UIEdgeInsetsMake(0, 15, 0, 0);
    [zhidianTQ setBackgroundImage:[UIImage imageNamed:@"旅游气象.png"] forState:UIControlStateNormal];
    [self.view addSubview:zhidianTQ];
    
    UIButton *qixiangCP=[[UIButton alloc] initWithFrame:CGRectMake(kScreenW-130, CGRectGetMaxY(todayLowImage.frame)+marginY, 100, BottomBtnH)];
    //    [qixiangCP setBackgroundImage:[UIImage imageNamed:@"notificationBtnBackground.png"] forState:UIControlStateNormal];
    qixiangCP.tag=2;
    [qixiangCP addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.qixiangCP=qixiangCP;
    [qixiangCP setTitle:@"风雨查询" forState:UIControlStateNormal];
    qixiangCP.titleLabel.font=FONT_15;
    [qixiangCP setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    qixiangCP.layer.cornerRadius=15;
//    qixiangCP.layer.borderWidth=1.0;
//    qixiangCP.layer.borderColor=[UIColor whiteColor].CGColor;
//    qixiangCP.clipsToBounds=YES;
        qixiangCP.titleEdgeInsets=UIEdgeInsetsMake(0, 15, 0, 0);
    [qixiangCP setBackgroundImage:[UIImage imageNamed:@"风雨查询.png"] forState:UIControlStateNormal];
    [self.view addSubview:qixiangCP];
    
//    UIButton *qixiangFW=[[UIButton alloc] initWithFrame:CGRectMake(bottomMargin*3+BottomBtnW*2, CGRectGetMaxY(todayLowImage.frame)+marginY, BottomBtnW, BottomBtnH)];
//    //    [qixiangFW setBackgroundImage:[UIImage imageNamed:@"notificationBtnBackground.png"] forState:UIControlStateNormal];
//    qixiangFW.tag=3;
//    [qixiangFW addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.qixiangFW=qixiangFW;
//    [qixiangFW setTitle:@"气象服务" forState:UIControlStateNormal];
//    qixiangFW.titleLabel.font=FONT_15;
//    [qixiangFW setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    qixiangFW.layer.cornerRadius=15;
//    qixiangFW.layer.borderWidth=1.0;
//    qixiangFW.layer.borderColor=[UIColor whiteColor].CGColor;
//    qixiangFW.clipsToBounds=YES;
//    [self.view addSubview:qixiangFW];
    
    
    /**
     底部日期
     */
    
    UILabel *riqiLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(zhidianTQ.frame)+marginY, 200, 30)];
    self.riqiLabel=riqiLabel;
    riqiLabel.font=FONT_15;
    riqiLabel.textColor=[UIColor whiteColor];
    riqiLabel.textAlignment=NSTextAlignmentLeft;
    riqiLabel.text=@"3月23日 二月十五";
    [self.view addSubview:riqiLabel];
    UIImageView *YJImage=[[UIImageView alloc] initWithFrame:CGRectMake(kScreenW-230, CGRectGetMaxY(zhidianTQ.frame)+marginY ,  30, 30)];
    self.YJImage=YJImage;
    YJImage.image=[UIImage imageNamed:@"预警中心.png"];
    [self.view addSubview:YJImage];
    UIButton *yujingLabel=[[UIButton alloc] initWithFrame:CGRectMake(kScreenW-200, CGRectGetMaxY(zhidianTQ.frame)+marginY, 180, 30)];
    self.yujingLabel=yujingLabel;
    //    yujingLabel.backgroundColor=[UIColor redColor];
    yujingLabel.titleLabel.font=FONT_15;
    [yujingLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [yujingLabel setContentMode:UIViewContentModeRight];
    [yujingLabel setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [yujingLabel setTitle:@"暂无预警" forState:UIControlStateNormal];
    [self.view addSubview:yujingLabel];
    yujingLabel.tag=5;
    [yujingLabel addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.preferredContentSize=CGSizeMake(0, CGRectGetMaxY(yujingLabel.frame)+marginY);
    [self.yujingLabel sizeToFit];
    CGFloat width=self.yujingLabel.frame.size.width;
    //                    kScreenW-200, CGRectGetMaxY(zhidianTQ.frame)+marginY, 180, 30
    self.yujingLabel.frame=CGRectMake(kScreenW-width-10, CGRectGetMaxY(self.zhidianTQ.frame)+15, width, 30);
    self.YJImage.frame=CGRectMake(kScreenW-width-35, CGRectGetMaxY(self.zhidianTQ.frame)+15+5, 20, 20);
    //大区域点击事件
    UIButton *bigBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, CGRectGetMinY(zhidianTQ.frame))];
    bigBtn.tag=4;
    [bigBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bigBtn];
    
}
-(void)setupView1
{
    CGFloat marginX=15;
    CGFloat marginY=15;
    //大区域点击事件
    UIButton *bigBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 100)];
    bigBtn.tag=4;
    [bigBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bigBtn];
    /**
     实时天气
     */
    UILabel *sstqLabel=[[UILabel alloc] initWithFrame:CGRectMake(kScreenW/2-150, marginY, 250, 70)];
    sstqLabel.font=[UIFont fontWithName: @"STHeitiTC-Light" size:60];
    sstqLabel.textColor=[UIColor whiteColor];
    self.sstqLabel=sstqLabel;
    sstqLabel.text=@"9.6°";
    [self.view addSubview:sstqLabel];
    /**
     地区
     */
    UILabel *diquLabel=[[UILabel alloc] initWithFrame:CGRectMake(2*marginX, marginY, 80, 20)];
    diquLabel.font=FONT_15;
    self.diquLabel=diquLabel;
    diquLabel.textColor=[UIColor whiteColor];
    diquLabel.textAlignment=NSTextAlignmentCenter;
    diquLabel.text=@"福州鼓楼区";
    [self.view addSubview:diquLabel];
    
    /**
     空气质量
     */
    UIButton *kongqizhiliangBtn=[[UIButton alloc] initWithFrame:CGRectMake(2*marginX, CGRectGetMaxY(diquLabel.frame)+5, 80, 20)];
    [kongqizhiliangBtn setBackgroundColor:[UIColor colorWithRed:1/255.0 green:205/255.0 blue:59/255.0 alpha:1]];
    self.kongqizhiliangBtn=kongqizhiliangBtn;
    kongqizhiliangBtn.centerX=diquLabel.centerX;
    [kongqizhiliangBtn setTitle:@"良" forState:UIControlStateNormal];
    kongqizhiliangBtn.titleLabel.font=FONT_15;
    [kongqizhiliangBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    kongqizhiliangBtn.layer.cornerRadius=10;
    kongqizhiliangBtn.clipsToBounds=YES;
    [self.view addSubview:kongqizhiliangBtn];
    
    /**
     三天天气日期
     */
    CGFloat TodayLabelW=kScreenW/3/2;
    UILabel *todayLabel=[[UILabel alloc] initWithFrame:CGRectMake(kScreenW/2, marginY, TodayLabelW, 20)];
    self.todayLabel=todayLabel;
    todayLabel.font=FONT_15;
    todayLabel.textColor=[UIColor whiteColor];
    todayLabel.textAlignment=NSTextAlignmentCenter;
    todayLabel.text=@"今天";
    [self.view addSubview:todayLabel];
    
    UILabel *secondLabel=[[UILabel alloc] initWithFrame:CGRectMake(kScreenW/2+TodayLabelW, marginY, TodayLabelW, 20)];
    self.secondLabel=secondLabel;
    secondLabel.font=FONT_15;
    secondLabel.textColor=[UIColor whiteColor];
    secondLabel.textAlignment=NSTextAlignmentCenter;
    secondLabel.text=@"周三";
    [self.view addSubview:secondLabel];
    
    UILabel *thirdLabel=[[UILabel alloc] initWithFrame:CGRectMake(kScreenW/2+2*TodayLabelW, marginY, TodayLabelW, 20)];
    self.thirdLabel=thirdLabel;
    thirdLabel.font=FONT_15;
    thirdLabel.textColor=[UIColor whiteColor];
    thirdLabel.textAlignment=NSTextAlignmentCenter;
    thirdLabel.text=@"周三";
    [self.view addSubview:thirdLabel];
    /**
     三天高温天气图片
     */
    CGFloat imageW=40;
    UIImageView *todayHighImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(todayLabel.frame), imageW, imageW)];
    self.todayHighImage=todayHighImage;
    todayHighImage.centerX=todayLabel.centerX;
    todayHighImage.image=[UIImage imageNamed:@"b00"];
    todayHighImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:todayHighImage];
    
    UIImageView *secondHighImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(todayLabel.frame), imageW, imageW)];
    self.secondHighImage=secondHighImage;
    secondHighImage.centerX=secondLabel.centerX;
    secondHighImage.image=[UIImage imageNamed:@"b00"];
    secondHighImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:secondHighImage];
    
    UIImageView *thirdHighImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(todayLabel.frame), imageW, imageW)];
    self.thirdHighImage=thirdHighImage;
    thirdHighImage.centerX=thirdLabel.centerX;
    thirdHighImage.image=[UIImage imageNamed:@"b00"];
    thirdHighImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:thirdHighImage];
    /**
     三天高温天气label
     */
    UILabel *todayHighLabel=[[UILabel alloc] initWithFrame:CGRectMake(kScreenW/2, CGRectGetMaxY(todayHighImage.frame), TodayLabelW, 20)];
    self.todayHighLabel=todayHighLabel;
    todayHighLabel.font=FONT_15;
    todayHighLabel.textColor=[UIColor whiteColor];
    todayHighLabel.textAlignment=NSTextAlignmentCenter;
    todayHighLabel.text=@"16°";
    [self.view addSubview:todayHighLabel];
    
    UILabel *secondHighLabel=[[UILabel alloc] initWithFrame:CGRectMake(kScreenW/2+TodayLabelW, CGRectGetMaxY(todayHighImage.frame), TodayLabelW, 20)];
    self.secondHighLabel=secondHighLabel;
    secondHighLabel.font=FONT_15;
    secondHighLabel.textColor=[UIColor whiteColor];
    secondHighLabel.textAlignment=NSTextAlignmentCenter;
    secondHighLabel.text=@"16°";
    [self.view addSubview:secondHighLabel];
    
    UILabel *thirdHighLabel=[[UILabel alloc] initWithFrame:CGRectMake(kScreenW/2+2*TodayLabelW, CGRectGetMaxY(todayHighImage.frame), TodayLabelW, 20)];
    self.thirdHighLabel=thirdHighLabel;
    thirdHighLabel.font=FONT_15;
    thirdHighLabel.textColor=[UIColor whiteColor];
    thirdHighLabel.textAlignment=NSTextAlignmentCenter;
    thirdHighLabel.text=@"16°";
    [self.view addSubview:thirdHighLabel];
    /**
     三天低温天气label
     */
    UILabel *todayLowLabel=[[UILabel alloc] initWithFrame:CGRectMake(kScreenW/2, CGRectGetMaxY(todayHighLabel.frame)+15, TodayLabelW, 20)];
    self.todayLowLabel=todayLowLabel;
    todayLowLabel.font=FONT_15;
    todayLowLabel.textColor=[UIColor whiteColor];
    todayLowLabel.textAlignment=NSTextAlignmentCenter;
    todayLowLabel.text=@"16°";
    [self.view addSubview:todayLowLabel];
    
    UILabel *secondLowLabel=[[UILabel alloc] initWithFrame:CGRectMake(kScreenW/2+TodayLabelW, CGRectGetMaxY(todayHighLabel.frame)+15, TodayLabelW, 20)];
    self.secondLowLabel=secondLowLabel;
    secondLowLabel.font=FONT_15;
    secondLowLabel.textColor=[UIColor whiteColor];
    secondLowLabel.textAlignment=NSTextAlignmentCenter;
    secondLowLabel.text=@"16°";
    [self.view addSubview:secondLowLabel];
    
    UILabel *thirdLowLabel=[[UILabel alloc] initWithFrame:CGRectMake(kScreenW/2+2*TodayLabelW, CGRectGetMaxY(todayHighLabel.frame)+15, TodayLabelW, 20)];
    self.thirdLowLabel=thirdLowLabel;
    thirdLowLabel.font=FONT_15;
    thirdLowLabel.textColor=[UIColor whiteColor];
    thirdLowLabel.textAlignment=NSTextAlignmentCenter;
    thirdLowLabel.text=@"16°";
    [self.view addSubview:thirdLowLabel];
    /**
     三天低温天气图片
     */
    UIImageView *todayLowImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(todayLowLabel.frame), imageW, imageW)];
    self.todayLowImage=todayLowImage;
    todayLowImage.centerX=todayLabel.centerX;
    todayLowImage.image=[UIImage imageNamed:@"b00"];
    todayLowImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:todayLowImage];
    
    UIImageView *secondLowImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(todayLowLabel.frame), imageW, imageW)];
    self.secondLowImage=secondLowImage;
    secondLowImage.centerX=secondLabel.centerX;
    secondLowImage.image=[UIImage imageNamed:@"b00"];
    secondLowImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:secondLowImage];
    
    UIImageView *thirdLowImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(todayLowLabel.frame), imageW, imageW)];
    self.thirdLowImage=thirdLowImage;
    thirdLowImage.centerX=thirdLabel.centerX;
    thirdLowImage.image=[UIImage imageNamed:@"b00"];
    thirdLowImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:thirdLowImage];
    
    /**
     底部三个Btn
     */
    CGFloat bottomMargin=60;
    CGFloat BottomBtnW=(kScreenW/2-3*bottomMargin)/2;
    CGFloat BottomBtnH=30;
    UIButton *zhidianTQ=[[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(sstqLabel.frame)+marginY, 100, BottomBtnH)];
    //    [zhidianTQ setBackgroundImage:[UIImage imageNamed:@"notificationBtnBackground.png"] forState:UIControlStateNormal];
    self.zhidianTQ=zhidianTQ;
    zhidianTQ.tag=1;
    [zhidianTQ addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [zhidianTQ setTitle:@"旅游气象" forState:UIControlStateNormal];
    zhidianTQ.titleLabel.font=FONT_15;
        [zhidianTQ setBackgroundImage:[UIImage imageNamed:@"旅游气象.png"] forState:UIControlStateNormal];
    [zhidianTQ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    zhidianTQ.layer.cornerRadius=15;
//    zhidianTQ.layer.borderWidth=1.0;
//    zhidianTQ.layer.borderColor=[UIColor whiteColor].CGColor;
//    zhidianTQ.clipsToBounds=YES;
    zhidianTQ.titleEdgeInsets=UIEdgeInsetsMake(0, 15, 0, 0);
    [self.view addSubview:zhidianTQ];
    
    UIButton *qixiangCP=[[UIButton alloc] initWithFrame:CGRectMake(kScreenW/2-130, CGRectGetMaxY(sstqLabel.frame)+marginY, 100, BottomBtnH)];
    //    [qixiangCP setBackgroundImage:[UIImage imageNamed:@"notificationBtnBackground.png"] forState:UIControlStateNormal];
    qixiangCP.tag=2;
    [qixiangCP addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.qixiangCP=qixiangCP;
    [qixiangCP setTitle:@"风雨查询" forState:UIControlStateNormal];
    qixiangCP.titleLabel.font=FONT_15;
    [qixiangCP setBackgroundImage:[UIImage imageNamed:@"风雨查询.png"] forState:UIControlStateNormal];
    [qixiangCP setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    qixiangCP.layer.cornerRadius=15;
//    qixiangCP.layer.borderWidth=1.0;
//    qixiangCP.layer.borderColor=[UIColor whiteColor].CGColor;
//    qixiangCP.clipsToBounds=YES;
  qixiangCP.titleEdgeInsets=UIEdgeInsetsMake(0, 15, 0, 0);
    [self.view addSubview:qixiangCP];
    
//    UIButton *qixiangFW=[[UIButton alloc] initWithFrame:CGRectMake(bottomMargin*3+BottomBtnW*2, CGRectGetMaxY(sstqLabel.frame)+marginY, BottomBtnW, BottomBtnH)];
//    //    [qixiangFW setBackgroundImage:[UIImage imageNamed:@"notificationBtnBackground.png"] forState:UIControlStateNormal];
//    qixiangFW.tag=3;
//    [qixiangFW addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.qixiangFW=qixiangFW;
//    [qixiangFW setTitle:@"气象服务" forState:UIControlStateNormal];
//    qixiangFW.titleLabel.font=FONT_15;
//    [qixiangFW setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    qixiangFW.layer.cornerRadius=15;
//    qixiangFW.layer.borderWidth=1.0;
//    qixiangFW.layer.borderColor=[UIColor whiteColor].CGColor;
//    qixiangFW.clipsToBounds=YES;
//    [self.view addSubview:qixiangFW];
    
    
    /**
     底部日期
     */
    
    UILabel *riqiLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(zhidianTQ.frame)+marginY, 200, 30)];
    self.riqiLabel=riqiLabel;
    riqiLabel.font=FONT_15;
    riqiLabel.textColor=[UIColor whiteColor];
    riqiLabel.textAlignment=NSTextAlignmentLeft;
    riqiLabel.text=@"3月23日 二月十五";
    [self.view addSubview:riqiLabel];
    UIImageView *YJImage=[[UIImageView alloc] initWithFrame:CGRectMake(kScreenW/2-120, CGRectGetMaxY(zhidianTQ.frame)+marginY ,  30, 30)];
    self.YJImage=YJImage;
    YJImage.image=[UIImage imageNamed:@"预警中心.png"];
    [self.view addSubview:YJImage];
    UIButton *yujingLabel=[[UIButton alloc] initWithFrame:CGRectMake(kScreenW/2-90, CGRectGetMaxY(zhidianTQ.frame)+marginY, 90, 30)];
    self.yujingLabel=yujingLabel;
    //    yujingLabel.backgroundColor=[UIColor redColor];
    yujingLabel.titleLabel.font=FONT_15;
    [yujingLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [yujingLabel setContentMode:UIViewContentModeRight];
    [yujingLabel setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [yujingLabel setTitle:@"暂无预警" forState:UIControlStateNormal];
    [self.view addSubview:yujingLabel];
    yujingLabel.tag=5;
    [yujingLabel addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.preferredContentSize=CGSizeMake(0, CGRectGetMaxY(yujingLabel.frame)+marginY);
    [self.yujingLabel sizeToFit];
//    CGFloat width=self.yujingLabel.frame.size.width;
//    //                    kScreenW-200, CGRectGetMaxY(zhidianTQ.frame)+marginY, 180, 30
//    self.yujingLabel.frame=CGRectMake(kScreenW/2-width-10, CGRectGetMaxY(self.zhidianTQ.frame)+15, width, 30);
//    self.YJImage.frame=CGRectMake(kScreenW/2-width-35, CGRectGetMaxY(self.zhidianTQ.frame)+15+5, 20, 20);
   
//    UIButton *bigBtn1=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(yujingLabel.frame), CGRectGetMaxY(bigBtn.frame), kScreenW-CGRectGetMaxX(qixiangFW.frame), self.preferredContentSize.height-bigBtn.frame.size.height)];
//    bigBtn1.tag=4;
//    [bigBtn1 addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:bigBtn1];
    bigBtn.frame=CGRectMake(0, 0, kScreenW, CGRectGetMaxY(yujingLabel.frame)+marginY);
//    bigBtn.backgroundColor=[UIColor redColor];
    
}
-(void)setupView3//IOS10界面
{
    CGFloat marginX=15;
    CGFloat marginY=15;
    
    UIImageView *backmenban=[[UIImageView alloc] initWithFrame:self.view.bounds];
//    backmenban.backgroundColor=[UIColor blackColor];
//    backmenban.alpha=0.3;
    self.backmenban=backmenban;
    backmenban.userInteractionEnabled=YES;
    [self.view insertSubview:backmenban aboveSubview:self.view];
    
    /**
     实时天气
     */
    UILabel *sstqLabel=[[UILabel alloc] initWithFrame:CGRectMake(kScreenW-150-15, marginY, 250, 70)];
    sstqLabel.font=[UIFont fontWithName: @"STHeitiTC-Light" size:60];
    sstqLabel.textColor=[UIColor whiteColor];
    self.sstqLabel=sstqLabel;
    sstqLabel.text=@"9.6°";
    [self.view addSubview:sstqLabel];
    /**
     地区
     */
    UILabel *diquLabel=[[UILabel alloc] initWithFrame:CGRectMake(2*marginX, marginY, 80, 20)];
    diquLabel.font=FONT_15;
    self.diquLabel=diquLabel;
    diquLabel.textColor=[UIColor whiteColor];
    diquLabel.textAlignment=NSTextAlignmentCenter;
    diquLabel.text=@"福州鼓楼区";
    [self.view addSubview:diquLabel];
    
    /**
     空气质量
     */
    UIButton *kongqizhiliangBtn=[[UIButton alloc] initWithFrame:CGRectMake(2*marginX, CGRectGetMaxY(diquLabel.frame)+5, 80, 20)];
    [kongqizhiliangBtn setBackgroundColor:[UIColor colorWithRed:1/255.0 green:205/255.0 blue:59/255.0 alpha:1]];
    self.kongqizhiliangBtn=kongqizhiliangBtn;
    kongqizhiliangBtn.centerX=diquLabel.centerX;
    [kongqizhiliangBtn setTitle:@"良" forState:UIControlStateNormal];
    kongqizhiliangBtn.titleLabel.font=FONT_15;
    [kongqizhiliangBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    kongqizhiliangBtn.layer.cornerRadius=10;
    kongqizhiliangBtn.clipsToBounds=YES;
    [self.view addSubview:kongqizhiliangBtn];
    
    /**
     三天天气日期
     */
    CGFloat TodayLabelW=self.view.frame.size.width/3;
    UILabel *todayLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sstqLabel.frame), TodayLabelW, 20)];
    self.todayLabel=todayLabel;
    todayLabel.font=FONT_15;
    todayLabel.textColor=[UIColor whiteColor];
    todayLabel.textAlignment=NSTextAlignmentCenter;
    todayLabel.text=@"今天";
    [self.view addSubview:todayLabel];
    
    UILabel *secondLabel=[[UILabel alloc] initWithFrame:CGRectMake(TodayLabelW, CGRectGetMaxY(sstqLabel.frame), TodayLabelW, 20)];
    self.secondLabel=secondLabel;
    secondLabel.font=FONT_15;
    secondLabel.textColor=[UIColor whiteColor];
    secondLabel.textAlignment=NSTextAlignmentCenter;
    secondLabel.text=@"周三";
    [self.view addSubview:secondLabel];
    
    UILabel *thirdLabel=[[UILabel alloc] initWithFrame:CGRectMake(2*TodayLabelW, CGRectGetMaxY(sstqLabel.frame), TodayLabelW, 20)];
    self.thirdLabel=thirdLabel;
    thirdLabel.font=FONT_15;
    thirdLabel.textColor=[UIColor whiteColor];
    thirdLabel.textAlignment=NSTextAlignmentCenter;
    thirdLabel.text=@"周三";
    [self.view addSubview:thirdLabel];
    /**
     三天高温天气图片
     */
    CGFloat imageW=40;
    UIImageView *todayHighImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(todayLabel.frame), imageW, imageW)];
    self.todayHighImage=todayHighImage;
    todayHighImage.centerX=todayLabel.centerX;
    todayHighImage.image=[UIImage imageNamed:@"b00"];
    todayHighImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:todayHighImage];
    
    UIImageView *secondHighImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(todayLabel.frame), imageW, imageW)];
    self.secondHighImage=secondHighImage;
    secondHighImage.centerX=secondLabel.centerX;
    secondHighImage.image=[UIImage imageNamed:@"b00"];
    secondHighImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:secondHighImage];
    
    UIImageView *thirdHighImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(todayLabel.frame), imageW, imageW)];
    self.thirdHighImage=thirdHighImage;
    thirdHighImage.centerX=thirdLabel.centerX;
    thirdHighImage.image=[UIImage imageNamed:@"b00"];
    thirdHighImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:thirdHighImage];
    /**
     三天高温天气label
     */
    UILabel *todayHighLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(todayHighImage.frame), TodayLabelW, 20)];
    self.todayHighLabel=todayHighLabel;
    todayHighLabel.font=FONT_15;
    todayHighLabel.textColor=[UIColor whiteColor];
    todayHighLabel.textAlignment=NSTextAlignmentCenter;
    todayHighLabel.text=@"16°";
    [self.view addSubview:todayHighLabel];
    
    UILabel *secondHighLabel=[[UILabel alloc] initWithFrame:CGRectMake(TodayLabelW, CGRectGetMaxY(todayHighImage.frame), TodayLabelW, 20)];
    self.secondHighLabel=secondHighLabel;
    secondHighLabel.font=FONT_15;
    secondHighLabel.textColor=[UIColor whiteColor];
    secondHighLabel.textAlignment=NSTextAlignmentCenter;
    secondHighLabel.text=@"16°";
    [self.view addSubview:secondHighLabel];
    
    UILabel *thirdHighLabel=[[UILabel alloc] initWithFrame:CGRectMake(2*TodayLabelW, CGRectGetMaxY(todayHighImage.frame), TodayLabelW, 20)];
    self.thirdHighLabel=thirdHighLabel;
    thirdHighLabel.font=FONT_15;
    thirdHighLabel.textColor=[UIColor whiteColor];
    thirdHighLabel.textAlignment=NSTextAlignmentCenter;
    thirdHighLabel.text=@"16°";
    [self.view addSubview:thirdHighLabel];
    /**
     三天低温天气label
     */
    UILabel *todayLowLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(todayHighLabel.frame)+5, TodayLabelW, 20)];
    self.todayLowLabel=todayLowLabel;
    todayLowLabel.font=FONT_15;
    todayLowLabel.textColor=[UIColor whiteColor];
    todayLowLabel.textAlignment=NSTextAlignmentCenter;
    todayLowLabel.text=@"16°";
    [self.view addSubview:todayLowLabel];
    
    UILabel *secondLowLabel=[[UILabel alloc] initWithFrame:CGRectMake(TodayLabelW, CGRectGetMaxY(todayHighLabel.frame)+5, TodayLabelW, 20)];
    self.secondLowLabel=secondLowLabel;
    secondLowLabel.font=FONT_15;
    secondLowLabel.textColor=[UIColor whiteColor];
    secondLowLabel.textAlignment=NSTextAlignmentCenter;
    secondLowLabel.text=@"16°";
    [self.view addSubview:secondLowLabel];
    
    UILabel *thirdLowLabel=[[UILabel alloc] initWithFrame:CGRectMake(2*TodayLabelW, CGRectGetMaxY(todayHighLabel.frame)+5, TodayLabelW, 20)];
    self.thirdLowLabel=thirdLowLabel;
    thirdLowLabel.font=FONT_15;
    thirdLowLabel.textColor=[UIColor whiteColor];
    thirdLowLabel.textAlignment=NSTextAlignmentCenter;
    thirdLowLabel.text=@"16°";
    [self.view addSubview:thirdLowLabel];
    /**
     三天低温天气图片
     */
    UIImageView *todayLowImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(todayLowLabel.frame), imageW, imageW)];
    self.todayLowImage=todayLowImage;
    todayLowImage.centerX=todayLabel.centerX;
    todayLowImage.image=[UIImage imageNamed:@"b00"];
    todayLowImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:todayLowImage];
    
    UIImageView *secondLowImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(todayLowLabel.frame), imageW, imageW)];
    self.secondLowImage=secondLowImage;
    secondLowImage.centerX=secondLabel.centerX;
    secondLowImage.image=[UIImage imageNamed:@"b00"];
    secondLowImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:secondLowImage];
    
    UIImageView *thirdLowImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(todayLowLabel.frame), imageW, imageW)];
    self.thirdLowImage=thirdLowImage;
    thirdLowImage.centerX=thirdLabel.centerX;
    thirdLowImage.image=[UIImage imageNamed:@"b00"];
    thirdLowImage.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:thirdLowImage];
    
    /**
     底部三个Btn
     */
    CGFloat bottomMargin=70;
    CGFloat BottomBtnW=(self.view.frame.size.width-2*bottomMargin-30)/2;
    CGFloat BottomBtnH=30;
    UIButton *zhidianTQ=[[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(todayLowImage.frame)+marginY, 100, BottomBtnH)];
    self.zhidianTQ=zhidianTQ;
    zhidianTQ.tag=1;
    [zhidianTQ addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [zhidianTQ setTitle:@"旅游气象" forState:UIControlStateNormal];
    zhidianTQ.titleLabel.font=FONT_15;
    [zhidianTQ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 
    zhidianTQ.titleEdgeInsets=UIEdgeInsetsMake(0, 15, 0, 0);
    [zhidianTQ setBackgroundImage:[UIImage imageNamed:@"旅游气象.png"] forState:UIControlStateNormal];
    [self.view addSubview:zhidianTQ];
    
    UIButton *qixiangCP=[[UIButton alloc] initWithFrame:CGRectMake(kScreenW-130-15, CGRectGetMaxY(todayLowImage.frame)+marginY, 100, BottomBtnH)];

    qixiangCP.tag=2;
    [qixiangCP addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.qixiangCP=qixiangCP;
    [qixiangCP setTitle:@"风雨查询" forState:UIControlStateNormal];
    qixiangCP.titleLabel.font=FONT_15;
    [qixiangCP setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    qixiangCP.titleEdgeInsets=UIEdgeInsetsMake(0, 15, 0, 0);
    [qixiangCP setBackgroundImage:[UIImage imageNamed:@"风雨查询.png"] forState:UIControlStateNormal];
    [self.view addSubview:qixiangCP];
    

    
    
    /**
     底部日期
     */
    
    UILabel *riqiLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(zhidianTQ.frame)+marginY, 200, 30)];
    self.riqiLabel=riqiLabel;
    riqiLabel.font=FONT_15;
    riqiLabel.textColor=[UIColor whiteColor];
    riqiLabel.textAlignment=NSTextAlignmentLeft;
    riqiLabel.text=@"3月23日 二月十五";
    [self.view addSubview:riqiLabel];
    UIImageView *YJImage=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-230, CGRectGetMaxY(zhidianTQ.frame)+marginY ,  30, 30)];
    self.YJImage=YJImage;
    YJImage.image=[UIImage imageNamed:@"预警中心.png"];
    [self.view addSubview:YJImage];
    UIButton *yujingLabel=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-200, CGRectGetMaxY(zhidianTQ.frame)+marginY, 180, 30)];
    self.yujingLabel=yujingLabel;
    //    yujingLabel.backgroundColor=[UIColor redColor];
    yujingLabel.titleLabel.font=FONT_15;
    [yujingLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [yujingLabel setContentMode:UIViewContentModeRight];
    [yujingLabel setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [yujingLabel setTitle:@"暂无预警" forState:UIControlStateNormal];
    [self.view addSubview:yujingLabel];
    yujingLabel.tag=5;
    [yujingLabel addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.preferredContentSize=CGSizeMake(0, CGRectGetMaxY(yujingLabel.frame)+marginY);
    [self.yujingLabel sizeToFit];
    CGFloat width=self.yujingLabel.frame.size.width;
    //                    kScreenW-200, CGRectGetMaxY(zhidianTQ.frame)+marginY, 180, 30
    self.yujingLabel.frame=CGRectMake(self.view.frame.size.width-width-10, CGRectGetMaxY(self.zhidianTQ.frame)+15, width, 30);
    self.YJImage.frame=CGRectMake(self.view.frame.size.width-width-35, CGRectGetMaxY(self.zhidianTQ.frame)+15+5, 20, 20);
    //大区域点击事件
    UIButton *bigBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, CGRectGetMinY(zhidianTQ.frame))];
    bigBtn.tag=4;
    [bigBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bigBtn];
       if (sysVersion10) {
        
        self.extensionContext.widgetLargestAvailableDisplayMode=NCWidgetDisplayModeExpanded;
        self.maxSize=CGSizeMake(0, CGRectGetMaxY(yujingLabel.frame)+marginY);
    }
    
    
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsZero;
    
}
-(void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
{
    
    if (activeDisplayMode == NCWidgetDisplayModeCompact ) {
        
        self.preferredContentSize=CGSizeMake(0, 110);
        //        self.backmenban.height=110;
        
    }else
    {
        self.preferredContentSize=self.maxSize;
        self.backmenban.height=self.maxSize.height;
        
    }
    
    
}
#pragma mark IOS背景图加载
-(void)loadbgview{
    NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.com.app.ztqCountry"];
    NSString *appid=[userDf objectForKey:@"appid"];
    NSString *currentID=[userDf objectForKey:@"currentCityID"];

    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:appid forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    if (currentID.length>0) {
        [gz_todaywt_inde setObject:currentID forKey:@"county_id"];
    }
    [gz_todaywt_inde setObject:@"IOS" forKey:@"os_type"];
    [b setObject:gz_todaywt_inde forKey:@"gz_todaywt_index"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    
    NSData *jsonData=[NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
    NSString *jsonStr=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *p=[NSMutableDictionary dictionary];
    [p setObject:jsonStr forKey:@"p"];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager POST:ONLINE_URL parameters:p progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * b = [responseObject objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_todaywt_inde = [b objectForKey:@"gz_todaywt_index"];
            NSDictionary *todaywt=[gz_todaywt_inde objectForKey:@"todaywt"];
            NSString *back_img_max=[todaywt objectForKey:@"back_img_max"];
            NSURL *url = [self makeImageUrl:back_img_max];
            self.backmenban.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            self.backmenban.alpha=1;
            self.backmenban.clipsToBounds=YES;
        }else{
            UIImage *backImage=[UIImage imageNamed:@"widget背景.png"];
                  self.backmenban.image=backImage;
//                self.backmenban.alpha=0.3;
            self.backmenban.contentMode=UIViewContentModeScaleToFill;
            self.backmenban.clipsToBounds=YES;
        
        }

        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIImage *backImage=[UIImage imageNamed:@"widget背景.png"];
        self.backmenban.image=backImage;
        //                self.backmenban.alpha=0.3;
        self.backmenban.contentMode=UIViewContentModeScaleToFill;
        self.backmenban.clipsToBounds=YES;
    }];

}
- (NSString *) makeImageUrlStr:(NSString *)t_imgName
{
    NSString *urlStr = [NSString stringWithFormat:@"http://www.fjqxfw.cn:8099/ftp/%@",t_imgName];
    return urlStr;
}
- (NSURL *) makeImageUrl:(NSString *)t_imgName
{
   
    NSURL *url = [NSURL URLWithString:[self makeImageUrlStr:t_imgName]];
    return url;
}
@end
