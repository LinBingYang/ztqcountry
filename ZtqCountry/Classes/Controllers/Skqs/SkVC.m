//
//  SkVC.m
//  ZtqCountry
//
//  Created by Admin on 15/6/15.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "SkVC.h"
#import "WebViewController.h"
@implementation SkVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    float place = 0;
    if(kSystemVersionMore7)
    {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
        place = 20;
    }
    self.barHeight=place+44;
    UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    self.bgimg=bgimg;
    bgimg.image=[UIImage imageNamed:@"趋势背景图"];
    bgimg.userInteractionEnabled=YES;
    [self.view addSubview:bgimg];
    self.navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    self.navigationBarBg.userInteractionEnabled = YES;
//    self.navigationBarBg.image=[UIImage imageNamed:@"导航栏.png"];
        self.navigationBarBg.backgroundColor = [UIColor clearColor];
    [self.bgimg addSubview:self.navigationBarBg];
    
    UIImageView *leftimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7+place, 30, 30)];
    leftimg.image=[UIImage imageNamed:@"返回.png"];
    leftimg.userInteractionEnabled=YES;
    [_navigationBarBg addSubview:leftimg];
    UIButton * leftBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 7+place, 60, 44+place)];
//    [leftBut setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    //    [leftBut setImage:[UIImage imageNamed:@"cssz返回点击.png"] forState:UIControlStateHighlighted];
    [leftBut setBackgroundColor:[UIColor clearColor]];
    
    [leftBut addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarBg addSubview:leftBut];
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 7+place, kScreenWidth-120, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = @"天气趋势";
    [self.navigationBarBg addSubview:titleLab];
    
    self.adimgurls=[[NSMutableArray alloc]init];
    self.adtitles=[[NSMutableArray alloc]init];
    self.adurls=[[NSMutableArray alloc]init];
    
    self.bgscr=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht)];
    self.bgscr.contentSize=CGSizeMake(kScreenWidth, kScreenHeitht+100);
    self.bgscr.showsHorizontalScrollIndicator=NO;
    self.bgscr.showsVerticalScrollIndicator=NO;
    self.bgscr.backgroundColor=[UIColor clearColor];
    [self.bgimg addSubview:self.bgscr];
    if (iPhone4) {
       self.bgscr.contentSize=CGSizeMake(kScreenWidth, kScreenHeitht+140);
    }
    [self gethours];//判断有没有逐时数据
    
    
    
}
-(void)gethours{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_weekwt = [[NSMutableDictionary alloc] init];
    [gz_weekwt setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    [b setObject:gz_weekwt forKey:@"gz_hourswt"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
  
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_hourswt = [b objectForKey:@"gz_hourswt"];
            NSArray *hourswt_list=[gz_hourswt objectForKey:@"hourswt_list"];
            self.hourlist=hourswt_list;
            
            if (hourswt_list.count>0) {
                self.weekbtn=[[UIButton alloc]initWithFrame:CGRectMake(0,0, kScreenWidth/2, 30)];
                [self.weekbtn setTitle:@"7天天气" forState:UIControlStateNormal];
                [self.weekbtn addTarget:self action:@selector(weekAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.bgscr addSubview:self.weekbtn];
                self.hourbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2,0,kScreenWidth/2, 30)];
                [self.hourbtn setTitle:@"24小时逐时预报" forState:UIControlStateNormal];
                [self.hourbtn addTarget:self action:@selector(hourAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.bgscr addSubview:self.hourbtn];
                
                if ([self.typetag isEqualToString:@"1"]) {
                    self.selectimg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 30, 120, 2)];
                    self.selectimg.image=[UIImage imageNamed:@"一周 24小时切换条"];
                    [self.bgscr addSubview:self.selectimg];
                    [self getweekinfo];
                    [self loadMainAD:@"3"];
                    
                }else{
                    self.selectimg=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-155, 30, 145, 2)];
                    self.selectimg.image=[UIImage imageNamed:@"一周 24小时切换条"];
                    [self.bgscr addSubview:self.selectimg];
                    [self gethourinfo];
                    [self loadMainAD:@"4"];
                }
            }else{
                
                self.weekbtn=[[UIButton alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, 30)];
                [self.weekbtn setTitle:@"7天天气" forState:UIControlStateNormal];
                [self.weekbtn addTarget:self action:@selector(weekAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.bgscr addSubview:self.weekbtn];

                
                self.selectimg=[[UIImageView alloc]initWithFrame:CGRectMake(100, 30, 123, 2)];
                self.selectimg.image=[UIImage imageNamed:@"一周 24小时切换条"];
                [self.bgscr addSubview:self.selectimg];
                self.typetag=@"1";
                [self getweekinfo];
                [self loadMainAD:@"3"];
            }
            
            
        }
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
-(void)getweekinfo{
    WeekWeatherView *weekv=[[WeekWeatherView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, 380)];
    self.weekwtview=weekv;
    [self.bgscr addSubview:weekv];
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_weekwt = [[NSMutableDictionary alloc] init];
    [gz_weekwt setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    [b setObject:gz_weekwt forKey:@"gz_weekwt_s_y"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_weekwt_s_y"];
            NSArray *weekinfos=[gz_air_qua_index objectForKey:@"weekwt_list"];
            if(weekinfos.count>0){
                NSMutableArray * weekWeatherInfos = [[NSMutableArray alloc] init];
                for(int i=0;i<weekinfos.count;i++)
                {
                    NSDictionary * weekInfo = [weekinfos objectAtIndex:i];
                    NSString * gdt = [weekInfo objectForKey:@"gdt"];
                    NSString * week = [weekInfo objectForKey:@"week"];
                    NSString * wd = [weekInfo objectForKey:@"wd"];
                    NSString * wd_ico = [weekInfo objectForKey:@"wd_ico"];
                    NSString * higt = [weekInfo objectForKey:@"higt"];
                    NSString * lowt = [weekInfo objectForKey:@"lowt"];
                    NSString * wd_daytime_ico = [weekInfo objectForKey:@"wd_daytime_ico"];
                    NSString * wind = [weekInfo objectForKey:@"wind"];
                    NSString * wd_night = [weekInfo objectForKey:@"wd_night"];
                    NSString * wd_daytime = [weekInfo objectForKey:@"wd_day"];
                    NSString * wd_night_ico = [weekInfo objectForKey:@"wd_night_ico"];
                    NSString * sunrise_time = [weekInfo objectForKey:@"sunrise_time"];
                    NSString * sunset_time = [weekInfo objectForKey:@"sunset_time"];
                    NSString *wt=[weekInfo objectForKey:@"wt"];
                    if (i==6) {
                        
                            weekWeatherInfo * info = [[weekWeatherInfo alloc] initWithGdt:gdt withWeek:week withWd:wd withWd_ico:wd_ico withHigt:higt withLowt:lowt withWind:wind withWd_night:wd_night withWd_daytime:wd_daytime withWd_night_ico:wd_night_ico withWd_daytime_ico:wd_daytime_ico withWt:wt withsunrise:sunrise_time withsunset:sunset_time];
                            [weekWeatherInfos addObject:info];
                        
                    }else{
                    if (higt.length<=0||lowt.length<=0) {
                        NSString *a=[NSString stringWithFormat:@"%d",i];
                        [weekv.indexs addObject:a];
                    }else{
                    weekWeatherInfo * info = [[weekWeatherInfo alloc] initWithGdt:gdt withWeek:week withWd:wd withWd_ico:wd_ico withHigt:higt withLowt:lowt withWind:wind withWd_night:wd_night withWd_daytime:wd_daytime withWd_night_ico:wd_night_ico withWd_daytime_ico:wd_daytime_ico withWt:wt withsunrise:sunrise_time withsunset:sunset_time];
                        [weekWeatherInfos addObject:info];
                    }
                    }
                }
                [weekv setupViewWithInfos:weekWeatherInfos];
            
            }
            /**
             *  缓存三天数据给widget
             */
            NSUserDefaults *userDf=[[NSUserDefaults alloc] initWithSuiteName:@"group.com.app.ztqCountry"];
            if (weekinfos.count>3) {
                NSDictionary *todayDatas=weekinfos[1];
                NSDictionary *secondDatas=weekinfos[2];
                NSDictionary *thirdDatas=weekinfos[3];
                /**
                 *  把数据缓存
                 */
                [userDf setObject:todayDatas forKey:@"todayDatas"];
                [userDf setObject:secondDatas forKey:@"secondDatas"];
                [userDf setObject:thirdDatas forKey:@"thirdDatas"];
                [userDf synchronize];
            }
        }
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
//加载首页大广告
-(void)loadMainAD:(NSString *)type{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:type forKey:@"position_id"];
    [b setObject:gz_todaywt_inde forKey:@"gz_ad"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            [self.adimgurls removeAllObjects];
            [self.adtitles removeAllObjects];
            [self.adurls removeAllObjects];
            NSDictionary *addic=[b objectForKey:@"gz_ad"];
            NSArray *adlist=[addic objectForKey:@"ad_list"];
            for (int i=0; i<adlist.count; i++) {
                NSString *url=[adlist[i] objectForKey:@"url"];
                NSString *title=[adlist[i] objectForKey:@"title"];
                NSString *imgurl=[adlist[i] objectForKey:@"img_path"];
                [self.adurls addObject:url];
                [self.adtitles addObject:title];
                [self.adimgurls addObject:imgurl];
            }
            
            [self.bmadscro removeFromSuperview];
            self.bmadscro=nil;
            if (self.bmadscro==nil) {
                if (self.adimgurls.count>0) {
                    if ([type isEqualToString:@"3"]) {
                        self.bmadscro = [[BMAdScrollView alloc] initWithNameArr:self.adimgurls  titleArr:self.adtitles height:170 offsetY:380 offsetx:10];
                        self.bmadscro.vDelegate = self;
                        self.bmadscro.pageCenter = CGPointMake(280, 300);
                        [self.bgscr addSubview:self.bmadscro];
                    }else{
                        self.bmadscro = [[BMAdScrollView alloc] initWithNameArr:self.adimgurls  titleArr:self.adtitles height:170 offsetY:380 offsetx:10];
                        self.bmadscro.vDelegate = self;
                        self.bmadscro.pageCenter = CGPointMake(280, 300);
                        [self.bgscr addSubview:self.bmadscro];
                    }
                    
                }
                
            }
            
        }
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}

-(void)gethourinfo{
  
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_weekwt = [[NSMutableDictionary alloc] init];
    [gz_weekwt setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    [b setObject:gz_weekwt forKey:@"gz_hourswt"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_hourswt = [b objectForKey:@"gz_hourswt"];
            NSArray *hourswt_list=[gz_hourswt objectForKey:@"hourswt_list"];
//            hourswt_list=[[hourswt_list reverseObjectEnumerator]allObjects];//倒序
            NSString *ico=[gz_hourswt objectForKey:@"icon"];
            NSString *pub_str=[gz_hourswt objectForKey:@"pub_str"];
            NSString *wt=[gz_hourswt objectForKey:@"wt"];
            NSString *higt=[gz_hourswt objectForKey:@"higt"];
            NSString *lowt=[gz_hourswt objectForKey:@"lowt"];
            NSString *nowt=[gz_hourswt objectForKey:@"nowt"];
            NSString *nowrain=@"0.0";
            
            if (hourswt_list.count>0) {
                self.hourwt=[[HourWtView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth,255)];
                [self.bgscr addSubview:self.hourwt];
                [self.hourwt updateviewwithico:ico withput:pub_str withwt:wt withhig:higt withlowt:lowt withnowct:nowt withnowrain:nowrain withhourlist:hourswt_list];
            }else{

               
//                UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 200, kScreenWidth, 30)];
//                lab.text=@"暂无数据";
//                self.lab=lab;
//                lab.textAlignment=NSTextAlignmentCenter;
//                lab.font=[UIFont systemFontOfSize:15];
//                lab.textColor=[UIColor whiteColor];
//                [self.bgscr addSubview:lab];
            }
           
            
        }
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
-(void)weekAction:(UIButton*)sender{
//    [self.lab removeFromSuperview];
    if (!self.hourlist.count>0) {
        
    }else{
        self.selectimg.frame=CGRectMake(20, 30, 120, 2);
    }
    [self.weekwtview removeFromSuperview];
    [self getweekinfo];
    [self.bmadscro removeFromSuperview];
    [self loadMainAD:@"3"];
    [self.hourwt removeFromSuperview];
    
}
-(void)hourAction:(UIButton*)sender{
//    [self.lab removeFromSuperview];
    self.selectimg.frame=CGRectMake(kScreenWidth-155, 30, 145, 2);
    [self.hourwt removeFromSuperview];
    [self gethourinfo];
    [self.weekwtview removeFromSuperview];
    [self.bmadscro removeFromSuperview];
    [self loadMainAD:@"4"];
}
-(void)buttonClick:(int)vid{
    NSString *url=self.adurls[vid-1];
    if (url.length>0) {
        WebViewController *adVC = [[WebViewController alloc]init];
        adVC.url = self.adurls[vid-1];
        adVC.titleString =self.adtitles[vid-1];
        [self.navigationController pushViewController:adVC animated:YES];
    }
}
- (void)leftBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
