//
//  AIrViewController.m
//  ZtqCountry
//
//  Created by Admin on 15/6/10.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "AIrViewController.h"
#import "UILabel+utils.h"
#import "AirRank.h"
#import "ShareSheet.h"
#import "weiboVC.h"
#import "AQIViewController.h"
@implementation AIrViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorHelpWithRed:234 green:234 blue:234 alpha:1];
    self.navigationController.navigationBarHidden = YES;
    float place = 0;
    if(kSystemVersionMore7)
    {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
        place = 20;
    }
    self.barHeight=place+44;
    
    self.navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    self.navigationBarBg.userInteractionEnabled = YES;
    self.navigationBarBg.image=[UIImage imageNamed:@"导航栏.png"];
    [self.view addSubview:self.navigationBarBg];
    
    UIImageView *leftimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7+place, 29, 29)];
    leftimg.image=[UIImage imageNamed:@"返回.png"];
    leftimg.userInteractionEnabled=YES;
    [self.navigationBarBg addSubview:leftimg];
    
    UIButton * leftBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 7+place, 60, 44+place)];
    //    UIButton * leftBut = [[UIButton alloc] initWithFrame:CGRectMake(15, 7+place, 29, 29)];
    //    [leftBut setImage:[UIImage imageNamed:@"jc返回.png"] forState:UIControlStateNormal];
    //    [leftBut setImage:[UIImage imageNamed:@"jc返回点击.png"] forState:UIControlStateHighlighted];
    [leftBut setBackgroundColor:[UIColor clearColor]];
    
    [leftBut addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarBg addSubview:leftBut];
    
    UIButton * rightbut = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-40, 7+place, 30, 30)];
    self.rightbtn=rightbut;
    [rightbut setImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
    //    [rightbut setImage:[UIImage imageNamed:@"cssz返回点击.png"] forState:UIControlStateHighlighted];
    [rightbut setBackgroundColor:[UIColor clearColor]];
    
    [rightbut addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarBg addSubview:rightbut];
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 7+place, self.view.width-120, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text =@"空气质量";
    [self.navigationBarBg addSubview:titleLab];
//    if (self.titlename.length>0) {
//        titleLab.text=self.titlename;
//    }
    self.stationids=[[NSMutableArray alloc]init];
    self.stationnames=[[NSMutableArray alloc]init];
    self.airitems=[[NSMutableArray alloc]init];
    self.airitemkey=[[NSMutableArray alloc]init];
    
    self.isopen=NO;
    self.remarktype=@"AQI";
    UIScrollView *bgscrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, [UIScreen mainScreen].bounds.size.height)] ;
    bgscrollview.showsHorizontalScrollIndicator=YES;
    bgscrollview.showsVerticalScrollIndicator=YES;
    bgscrollview.backgroundColor=[UIColor clearColor];
    bgscrollview.contentSize=CGSizeMake(kScreenWidth, 850);
    self.bgscro=bgscrollview;
    [self.view addSubview:bgscrollview];
    

    //界面
    UIButton *rankbtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2-160, 10, 120, 85)];
//    rankbtn.backgroundColor=[UIColor redColor];
    [rankbtn setBackgroundImage:[UIImage imageNamed:@"air_城市排行榜"] forState:UIControlStateNormal];
    [rankbtn addTarget:self action:@selector(pmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscro addSubview:rankbtn];
    UIButton *mapbtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2+40, 10, 120, 85)];
//    mapbtn.backgroundColor=[UIColor redColor];
    [mapbtn setBackgroundImage:[UIImage imageNamed:@"air_地图模式"] forState:UIControlStateNormal];
    [mapbtn addTarget:self action:@selector(AirMapAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscro addSubview:mapbtn];
    UILabel *pmlab=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 120, 30)];
    self.pmlab=pmlab;
    pmlab.textAlignment=NSTextAlignmentCenter;
    pmlab.textColor=[UIColor blackColor];
    pmlab.font=[UIFont systemFontOfSize:15];
    [rankbtn addSubview:pmlab];
    
    
    self.airlist=[[AirinfoList alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(mapbtn.frame)+10, kScreenWidth-20, 35)];
    self.airlist.delegate=self;
    [self.airlist.button setTitleColor:[UIColor colorHelpWithRed:0 green:105 blue:179 alpha:1] forState:UIControlStateNormal];
    [self.airlist.button setTitle:@"空气质量指数AQI" forState:UIControlStateNormal];
    [self.bgscro addSubview:self.airlist];
    
    _pmView =[[PMView alloc] initWithFrame:CGRectMake(0, 260, kScreenWidth, 250)];
    [bgscrollview addSubview:_pmView];
//    if (self.countryid.length>0) {
//        
//    }else{
//        self.countryid=[setting sharedSetting].currentCityID;
//    }
    
    if (self.countryid.length>0) {
        [self getair_qua_detailWithtype:self.remarktype withcityid:self.countryid];//获取详细
        [self getaqisixwithtype:@"1" withstationid:self.countryid];//获取城市6小时
    }else{
        [self creatjianceview];
    }
     [self getAirinfo];//获取说明
    [self getgz_air_item];//空气质量类型
//    [self getgz_air_station];//获取监测点
    UITapGestureRecognizer *longPress = [[UITapGestureRecognizer alloc]init];
    [longPress setNumberOfTapsRequired:1];
    longPress.delegate=self;
    [self.view addGestureRecognizer:longPress];
}
-(void)getair_qua_detailWithtype:(NSString *)type withcityid:(NSString *)cityid{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_air_qua_detail = [[NSMutableDictionary alloc] init];
    [gz_air_qua_detail setObject:cityid forKey:@"county_id"];
    [gz_air_qua_detail setObject:type forKey:@"rank_type"];
    [b setObject:gz_air_qua_detail forKey:@"gz_air_qua_detail"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (b!=nil) {
            NSDictionary *gz_air_qua_detail=[b objectForKey:@"gz_air_qua_detail"];
            NSString *aqi=[gz_air_qua_detail objectForKey:@"type"];
            NSString *quality=[gz_air_qua_detail objectForKey:@"quality"];
            NSString *city_name=[gz_air_qua_detail objectForKey:@"city_name"];
            NSString *city_num=[gz_air_qua_detail objectForKey:@"city_num"];
            NSString *update_time=[gz_air_qua_detail objectForKey:@"update_time"];
            NSString *key=[gz_air_qua_detail objectForKey:@"key"];
            NSString *pub_unit=[gz_air_qua_detail objectForKey:@"pub_unit"];
            self.cityid=key;
            self.cityname=city_name;
            self.uptime=update_time;
            self.pub_unitstr=pub_unit;
            NSArray *station_list=[gz_air_qua_detail objectForKey:@"station_list"];
            self.stations=station_list;
            [self creatjianceview];
            self.citylab.text=city_name;
            self.aqilab.text=aqi;
            self.pmlab.text=[NSString stringWithFormat:@"NO.%@",city_num];
            NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:self.pmlab.text];
            NSRange contentRange = {0,[content length]};
            [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
            self.pmlab.attributedText = content;
            self.wrlab.text=quality;
            self.jcdlab.text=[NSString stringWithFormat:@"%@市监测点排行",city_name];
            if ([self.remarktype isEqualToString:@"AQI"]) {
                self.colorimg.backgroundColor=[self getAQI:aqi];
            }
            
            [self.stfzlist.button setTitle:[NSString stringWithFormat:@"%@总体",city_name] forState:UIControlStateNormal];
        }
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
-(void)getgz_air_station{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_air_qua_detail = [[NSMutableDictionary alloc] init];
    [gz_air_qua_detail setObject:self.countryid forKey:@"county_id"];
    [b setObject:gz_air_qua_detail forKey:@"gz_air_station"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            [self.stationnames removeAllObjects];
            [self.stationids removeAllObjects];
            NSDictionary *gz_air_qua_detail=[b objectForKey:@"gz_air_station"];
            NSArray *station_list=[gz_air_qua_detail objectForKey:@"station_list"];
            if (self.cityname.length>0) {
                NSString *name=[NSString stringWithFormat:@"%@总体",self.cityname];
                [self.stationnames addObject:name];
                [self.stationids addObject:self.cityid];
            }
            for (int i=0; i<station_list.count; i++) {
                NSString *name=[station_list[i] objectForKey:@"station_name"];
                NSString *station_code=[station_list[i] objectForKey:@"station_code"];
                [self.stationnames addObject:name];
                [self.stationids addObject:station_code];
            }
           
        }
        [self.stfzlist setList:self.stationnames];

        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];

}
-(void)getaqisixwithtype:(NSString *)type withstationid:(NSString *)stationid{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_air_qua_detail = [[NSMutableDictionary alloc] init];
    [gz_air_qua_detail setObject:stationid forKey:@"station_id"];
    [gz_air_qua_detail setObject:type forKey:@"areatype"];
    [b setObject:gz_air_qua_detail forKey:@"gz_air_six_aqi"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary *gz_air_qua_detail=[b objectForKey:@"gz_air_six_aqi"];
            NSString *station_name=[gz_air_qua_detail objectForKey:@"station_name"];
            NSArray *aqi_list=[gz_air_qua_detail objectForKey:@"aqi_list"];
            [self.stationbtn setTitle:station_name forState:UIControlStateNormal];
            [_pmView PMviewgetaqidata:aqi_list with:self.uptime];
        }
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
//获取空气质量说明
-(void)getAirinfo{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_air_qua_detail = [[NSMutableDictionary alloc] init];
    [b setObject:gz_air_qua_detail forKey:@"gz_air_remark"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary *gz_air_qua_detail=[b objectForKey:@"gz_air_remark"];
            NSArray *dicList=[gz_air_qua_detail objectForKey:@"dicList"];
            self.remarks=dicList;
            self.airinfolab.text=[self.remarks[0] objectForKey:@"questions"];
        }
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
-(void)getgz_air_item{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_air_qua_detail = [[NSMutableDictionary alloc] init];
    [b setObject:gz_air_qua_detail forKey:@"gz_air_item"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            [self.airitemkey removeAllObjects];
            [self.airitems removeAllObjects];
            NSDictionary *gz_air_qua_detail=[b objectForKey:@"gz_air_item"];
            NSArray *air_item_list=[gz_air_qua_detail objectForKey:@"air_item_list"];
            for (int i=0; i<air_item_list.count; i++) {
                NSString *des=[air_item_list[i] objectForKey:@"des"];
                NSString *key=[air_item_list[i] objectForKey:@"key"];
                NSString *name=[NSString stringWithFormat:@"%@",des];
                [self.airitems addObject:name];
                [self.airitemkey addObject:key];
            }
        }
        
        [self.airlist setList:self.airitems];
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
-(void)creatjianceview{
    float height=self.stations.count*30;
    self.jianceimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.airlist.frame)+5, kScreenWidth-20, height+90)];
    self.jianceimg.userInteractionEnabled=YES;
    self.jianceimg.backgroundColor=[UIColor whiteColor];
    [self.bgscro addSubview:self.jianceimg];
    UILabel *citylab=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 30)];
//    citylab.text=@"福州总体";
    self.citylab=citylab;
    citylab.textColor=[UIColor blackColor];
    citylab.font=[UIFont systemFontOfSize:15];
    [self.jianceimg addSubview:citylab];
    UILabel *aqilab=[[UILabel alloc]initWithFrame:CGRectMake(150, 10, 60, 30)];
//    aqilab.text=@"188";
    self.aqilab=aqilab;
    aqilab.textColor=[UIColor blackColor];
    aqilab.font=[UIFont systemFontOfSize:15];
    [self.jianceimg addSubview:aqilab];
    UILabel *wrlab=[[UILabel alloc]initWithFrame:CGRectMake(190, 10, 100, 30)];
//    wrlab.text=@"中度污染";
    self.wrlab=wrlab;
    self.wrlab.textAlignment=NSTextAlignmentCenter;
    wrlab.textColor=[UIColor blackColor];
    wrlab.font=[UIFont systemFontOfSize:15];
    [self.jianceimg addSubview:wrlab];
    UIImageView *colorimg=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-40, 15, 5, 20)];
   
    self.colorimg=colorimg;
    [self.jianceimg addSubview:colorimg];
//    UILabel *pmlab=[[UILabel alloc]initWithFrame:CGRectMake(10, 40, 200, 30)];
////    pmlab.text=@"全国城市排名:";
//    self.pmlab=pmlab;
//    pmlab.textColor=[UIColor blackColor];
//    pmlab.font=[UIFont systemFontOfSize:15];
//    [self.jianceimg addSubview:pmlab];
//    UIButton *pmbtn=[[UIButton alloc]initWithFrame:CGRectMake(200, 40, 100, 30)];
//    [pmbtn addTarget:self action:@selector(pmAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.jianceimg addSubview:pmbtn];
//    UIImageView *pmimg=[[UIImageView alloc]initWithFrame:CGRectMake(230, 45, 20, 18)];
//    pmimg.image=[UIImage imageNamed:@"文字又拉.png"];
//    [self.jianceimg addSubview:pmimg];
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth-20, 1)];
    line.backgroundColor=[UIColor colorHelpWithRed:234 green:234 blue:234 alpha:1];
    [self.jianceimg addSubview:line];
    UILabel *jcdphlab=[[UILabel alloc]initWithFrame:CGRectMake(10, 45, kScreenWidth-20, 30)];
//    jcdphlab.text=@"福州市检测点排行";
    self.jcdlab=jcdphlab;
    jcdphlab.textColor=[UIColor colorHelpWithRed:0 green:105 blue:179 alpha:1];
    jcdphlab.font=[UIFont systemFontOfSize:15];
    [self.jianceimg addSubview:jcdphlab];
    for (int i=0; i<self.stations.count; i++) {
        NSString *station_name=[self.stations[i] objectForKey:@"station_name"];
        NSString *aqi=[self.stations[i] objectForKey:self.remarktype];
        NSString *quality=[self.stations[i] objectForKey:@"quality"];
        UILabel *namelab=[[UILabel alloc]initWithFrame:CGRectMake(10, 75+30*i, 150, 30)];
        namelab.text=station_name;
        namelab.textColor=[UIColor blackColor];
        namelab.font=[UIFont systemFontOfSize:15];
        [self.jianceimg addSubview:namelab];
        UILabel *aqilab=[[UILabel alloc]initWithFrame:CGRectMake(150, 75+30*i, 60, 30)];
        aqilab.text=aqi;
        aqilab.textColor=[UIColor blackColor];
        aqilab.font=[UIFont systemFontOfSize:15];
        [self.jianceimg addSubview:aqilab];
        UILabel *wrlab=[[UILabel alloc]initWithFrame:CGRectMake(190, 75+30*i, 100, 30)];
        wrlab.text=quality;
        wrlab.textAlignment=NSTextAlignmentCenter;
        wrlab.textColor=[UIColor blackColor];
        wrlab.font=[UIFont systemFontOfSize:15];
        [self.jianceimg addSubview:wrlab];
        if ([self.remarktype isEqualToString:@"AQI"]) {
            UIImageView *colorimg=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-40, 80+30*i, 5, 20)];
            colorimg.backgroundColor=[self getAQI:aqi];
            [self.jianceimg addSubview:colorimg];
        }
        
    }
    self.heiht=self.jianceimg.frame.size.height;
    [self creatSixview];
}
-(void)creatSixview{
    UILabel *sixlab=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.jianceimg.frame)+10, 150, 30)];
    sixlab.text=@"AQI  6小时走势图";
    self.sixlab=sixlab;
    sixlab.textColor=[UIColor colorHelpWithRed:0 green:105 blue:179 alpha:1];
    sixlab.font=[UIFont systemFontOfSize:15];
    [self.bgscro addSubview:sixlab];
//    UIButton *aqibtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-130, 55+self.heiht, 120, 30)];
//    [aqibtn setBackgroundColor:[UIColor whiteColor]];
//    [aqibtn addTarget:self action:@selector(stationAction) forControlEvents:UIControlEventTouchUpInside];
//    self.stationbtn=aqibtn;
//    self.stationbtn.titleLabel.font=[UIFont systemFontOfSize:15];
//    [self.stationbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.bgscro addSubview:aqibtn];
//    UIImageView *xiaimg=[[UIImageView alloc]initWithFrame:CGRectMake(aqibtn.frame.size.width-20, 12, 10, 10)];
//    xiaimg.image=[UIImage imageNamed:@"框下拉.png"];
//    [self.stationbtn addSubview:xiaimg];
   
    _pmView.frame=CGRectMake(0, CGRectGetMaxY(self.jianceimg.frame)+20, kScreenWidth, 250);
    self.stfzlist=[[stfzlist alloc]initWithFrame:CGRectMake(kScreenWidth-130, CGRectGetMaxY(self.jianceimg.frame)+10, 120, 30)];
    self.stfzlist.delegate=self;
    [self.bgscro addSubview:self.stfzlist];
    [self getgz_air_station];//获取监测点
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.jianceimg.frame)+260, 150, 20)];
    lab.text=self.pub_unitstr;
    lab.textAlignment=NSTextAlignmentLeft;
    self.hblab=lab;
    lab.textColor=[UIColor blackColor];
    lab.font=[UIFont systemFontOfSize:13];
    [self.bgscro addSubview:lab];
    UILabel *timelab=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.jianceimg.frame)+260, kScreenWidth-20, 20)];
    if (self.uptime.length>0) {
        timelab.text=[NSString stringWithFormat:@"%@更新",self.uptime];
    }
    timelab.textAlignment=NSTextAlignmentRight;
    timelab.textColor=[UIColor blackColor];
    self.timelab=timelab;
    timelab.font=[UIFont systemFontOfSize:13];
    [self.bgscro addSubview:timelab];
    
    //空气质量说明
    UILabel *airinfolab=[[UILabel alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(self.jianceimg.frame)+280, 250, 30)];
    airinfolab.textColor=[UIColor colorHelpWithRed:0 green:105 blue:179 alpha:1];
//    airinfolab.text=@"什么是空气质量指数(AQI)?";
    airinfolab.text=[self.remarks[0] objectForKey:@"questions"];
    airinfolab.userInteractionEnabled=YES;
    airinfolab.textAlignment=NSTextAlignmentLeft;
    airinfolab.font=[UIFont systemFontOfSize:15];
    self.airinfolab=airinfolab;
    [self.bgscro addSubview:airinfolab];
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(self.jianceimg.frame)+280+29, kScreenWidth-30, 1)];
    self.line=line;
    line.backgroundColor=[UIColor grayColor];
    [self.bgscro addSubview:line];
    self.isopenimg=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-50, CGRectGetMaxY(self.jianceimg.frame)+285, 15, 15)];
    self.isopenimg.image=[UIImage imageNamed:@"文字上拉"];
    self.isopenimg.userInteractionEnabled=YES;
    [self.bgscro addSubview:self.isopenimg];
    UIButton *airinfo=[[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.jianceimg.frame)+280, kScreenWidth-20, 30)];
    self.airremarkbtn=airinfo;
    [airinfo addTarget:self action:@selector(infoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscro addSubview:airinfo];
    [self.bgscro setContentSize:CGSizeMake(kScreenWidth, CGRectGetMaxY(self.jianceimg.frame)+280+100)];
    
    for (int i=0; i<self.remarks.count; i++) {
        NSString *rankType=[self.remarks[i] objectForKey:@"rankType"];
        NSString *questions=[self.remarks[i] objectForKey:@"questions"];
//        if ([self.remarktype isEqualToString:@"PM2.5"]) {
//            self.remarktype=@"PM2_5";
//        }
        if ([self.remarktype isEqualToString:rankType]) {
            if (self.airinfolab) {
                self.airinfolab.text=questions;
            }
        }
    }
}
-(void)aqiAction{
    
    
}
-(void)infoAction{
    if (self.deslab) {
       [self.deslab removeFromSuperview];
        self.deslab=nil;
    }
    
    if (self.isopen==NO) {
        self.isopenimg.image=[UIImage imageNamed:@"文字下拉"];
        self.isopen=YES;
    }else{
        self.isopenimg.image=[UIImage imageNamed:@"文字上拉"];
        self.isopen=NO;
    }
    if (self.isopen==YES) {
        for (int i=0; i<self.remarks.count; i++) {
            NSString *rankType=[self.remarks[i] objectForKey:@"rankType"];
            NSString *des=[self.remarks[i] objectForKey:@"des"];
            NSString *questions=[self.remarks[i] objectForKey:@"questions"];
            if ([self.remarktype isEqualToString:rankType]) {
//            if (i==0) {
                if (self.airinfolab) {
                    self.airinfolab.text=questions;
                }
                
                UILabel *airinfolab=[[UILabel alloc]initWithFrame:CGRectMake(5,CGRectGetMaxY(self.jianceimg.frame)+280+30, kScreenWidth-10, 150)];
                airinfolab.textColor=[UIColor grayColor];
                airinfolab.numberOfLines=0;
                airinfolab.text=[NSString stringWithFormat:@"    %@",des];
                airinfolab.textAlignment=NSTextAlignmentLeft;
                airinfolab.font=[UIFont systemFontOfSize:16];
                self.deslab=airinfolab;
                [self.bgscro addSubview:airinfolab];
                float H=[airinfolab labelheight:des withFont:[UIFont systemFontOfSize:16]];
                airinfolab.frame=CGRectMake(5, CGRectGetMaxY(self.jianceimg.frame)+280+25, kScreenWidth-10, H+50);
                [self.bgscro setContentSize:CGSizeMake(kScreenWidth, CGRectGetMaxY(self.jianceimg.frame)+280+30+H+100)];
                [self.bgscro setContentOffset:CGPointMake(0, CGRectGetMaxY(self.jianceimg.frame)+280)];
//            }
            
            }
        }
        
        
        
    }else{
        [self.bgscro setContentSize:CGSizeMake(kScreenWidth, CGRectGetMaxY(self.jianceimg.frame)+280+100)];
    }
}
-(void)stfzdidSelect:(stfzlist *)list withIndex:(NSInteger)index{
    if (list==self.stfzlist) {
        NSString *title=self.stationnames[index];
        [self.stfzlist.button setTitle:title forState:UIControlStateNormal];
        if (index==0) {
            [self getaqisixwithtype:@"1" withstationid:self.cityid];
        }else
        [self getaqisixwithtype:@"2" withstationid:self.stationids[index]];
    }    
}
-(void)airlistdidSelect:(AirinfoList *)list withIndex:(NSInteger)index{
    [self.jianceimg removeFromSuperview];
    [self.sixlab removeFromSuperview];
    [self.hblab removeFromSuperview];
    [self.stfzlist removeFromSuperview];
    [self.line removeFromSuperview];
    [self.isopenimg removeFromSuperview];
    if (self.airinfolab) {
        [self.airinfolab removeFromSuperview];
//        self.airinfolab=nil;
    }
    if (self.airremarkbtn) {
        [self.airremarkbtn removeFromSuperview];
    }
    if (self.timelab) {
        [self.timelab removeFromSuperview];
    }
    if (self.deslab) {
        [self.deslab removeFromSuperview];
    }
    
  
        self.isopenimg.image=[UIImage imageNamed:@"文字下拉"];
        self.isopen=NO;
    
    NSString *title=self.airitems[index];
    [self.airlist.button setTitle:title forState:UIControlStateNormal];
    self.remarktype=self.airitemkey[index];
    if (self.countryid.length>0) {
         [self getair_qua_detailWithtype:self.remarktype withcityid:self.countryid];
    }else{
        [self creatjianceview];
    }
   
    
    
    
   

}
-(void)airinfodlist:(AirinfoList *)dropDownList{
    [self.stfzlist setShowList:NO];
}
-(void)dlist:(stfzlist *)dropDownList{
    [self.airlist setShowList:NO];
}
#pragma mark 地图空气质量
-(void)AirMapAction{
    
    AQIViewController *airtp=[[AQIViewController alloc]init];
    airtp.Air_stationid=self.countryid;
    [self.navigationController pushViewController:airtp animated:YES];
}
#pragma mark 排名
-(void)pmAction{
    if ([self.popParameter isEqualToString:@"省份界面"] ||[self.popParameter isEqualToString:@"全国界面"]) {
    
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        //传递排序的值的类型 ag:AQI
        AirRank *airrank=[[AirRank alloc]init];
        airrank.rankType=self.remarktype;
        [self.navigationController pushViewController:airrank animated:YES];
    }
}
- (void)leftBtn:(id)sender{
//    if ([self.popParameter isEqualToString:@"省份界面"]) {
//        
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
//    }
    [self.navigationController popViewControllerAnimated:YES];
   
    
}
-(void)rightBtn:(id)sender{
    [self shareAction];
}
-(UIColor *)getAQI:(NSString *)aqivalue{
    int air=aqivalue.intValue;
    UIColor *color=nil;
    if (air>0 &&air<51) {
        color=[UIColor colorWithRed:101.0/255.0f green:240.0/255.0f blue:2.0/255.0f alpha:1.0f];
    }else
        if (air>50 && air <101) {
            color=[UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:28.0/255.0f alpha:1.0f];
        }else
            if (air>100 && air<151) {
                color=[UIColor colorWithRed:253.0/255.0f green:164.0/255.0f blue:10.0/255.0f alpha:1.0f];
            }else
                if (air>150 && air<201) {
                    color=[UIColor colorWithRed:239.0/255.0f green:8.0/255.0f blue:2.0/255.0f alpha:1.0f];
                }else
                    if (air>200 && air<301) {
                        color=[UIColor colorWithRed:153.0/255.0f green:0.0/255.0f blue:153.0/255.0f alpha:1.0f];
                    }else
                        if (air>300) {
                            color=[UIColor colorWithRed:139.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:1.0f];
                        }
    return color;
}
-(void)shareAction{
    [self getShareContent];
    //分享
    UIImage *moreImage=[self makeImageMore];
    self.shareimg=moreImage;
    NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weiboShare.png"];
    if ([UIImagePNGRepresentation(moreImage) writeToFile:shareImagePath atomically:YES])
        NSLog(@">>write ok");
    
    ShareSheet * sheet = [[ShareSheet alloc] initDefaultWithTitle:@"分享天气" withDelegate:self];
    [sheet show];
}
-(UIImage *)makeImageMore
{
    NSMutableArray *images=[[NSMutableArray alloc]init];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, 64), NO, 0.0);
    [self.navigationBarBg.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [images addObject:tempImage];
    
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(self.bgscro.contentSize, NO, 0.0);
    //    UIGraphicsBeginImageContext(_glassScrollView.foregroundScrollView.contentSize);
    {
        CGPoint savedContentOffset = self.bgscro.contentOffset;
        CGRect savedFrame = self.bgscro.frame;
        
        self.bgscro.contentOffset = CGPointZero;
        self.bgscro.frame = CGRectMake(0, 0, kScreenWidth, self.bgscro.contentSize.height);
        self.bgscro.backgroundColor=[UIColor whiteColor];
        [self.bgscro.layer renderInContext: UIGraphicsGetCurrentContext()];
        self.bgscro.backgroundColor=[UIColor clearColor];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        self.bgscro.contentOffset = savedContentOffset;
        self.bgscro.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    [images addObject:image];
    //添加二维码
    UIImage *ewmimg=[UIImage imageNamed:@"指纹二维码.jpg"];
    UIImageView *ewm=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 177)];
    ewm.image=ewmimg;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, 177), NO, 0.0);
    [ewm.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *tempImage1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [images addObject:tempImage1];
    
    //    [self verticalImageFromArray:images];
    UIImage *newimg=[self verticalImageFromArray:images];
    return newimg;
    
}

-(UIImage *)verticalImageFromArray:(NSArray *)imagesArray
{
    UIImage *unifiedImage = nil;
    CGSize totalImageSize = [self verticalAppendedTotalImageSizeFromImagesArray:imagesArray];
    UIGraphicsBeginImageContextWithOptions(totalImageSize, NO, 0.f);
    
    int imageOffsetFactor = 0;
    for (UIImage *img in imagesArray) {
        [img drawAtPoint:CGPointMake(0, imageOffsetFactor)];
        imageOffsetFactor += img.size.height;
    }
    
    unifiedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return unifiedImage;
}

-(CGSize)verticalAppendedTotalImageSizeFromImagesArray:(NSArray *)imagesArray
{
    CGSize totalSize = CGSizeZero;
    for (UIImage *im in imagesArray) {
        CGSize imSize = [im size];
        totalSize.height += imSize.height;
        // The total width is gonna be always the wider found on the array
        totalSize.width = kScreenWidth;
    }
    return totalSize;
}
-(void)getShareContent{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    [gz_todaywt_inde setObject:@"AIR_QUALITY" forKey:@"keyword"];
    [b setObject:gz_todaywt_inde forKey:@"gz_wt_share"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_wt_share"];
            NSString *sharecontent=[gz_air_qua_index objectForKey:@"share_content"];
            self.sharecontent=sharecontent;
        }
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
-(void)ShareSheetClickWithIndexPath:(NSInteger)indexPath
{
    NSString *shareContent = self.sharecontent;
    switch (indexPath)
    {
            
        case 0: {
            weiboVC *t_weibo = [[weiboVC alloc] initWithNibName:@"weiboVC" bundle:nil];
            [t_weibo setShareText:shareContent];
            [t_weibo setShareImage:@"weiboShare.png"];
            [t_weibo setShareType:1];
            [self presentViewController:t_weibo animated:YES completion:nil];
            //			[t_weibo release];
            break;
        }
        case 1:{
            NSString *url;
            if ([self.sharecontent rangeOfString:@"http"].location!=NSNotFound) {
                NSArray *arr=[self.sharecontent componentsSeparatedByString:@"http"];
                if (arr.count>0) {
                    url=[NSString stringWithFormat:@"http%@",arr[1]];
                }
            }
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            UMShareWebpageObject *shareweb=[[UMShareWebpageObject alloc]init];
            shareweb.webpageUrl=url;
            shareweb.title=@"知天气分享";
            shareweb.thumbImage=self.shareimg;
            shareweb.descr=self.sharecontent;
            messageObject.shareObject = shareweb;
            
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    NSLog(@"************Share fail with error %@*********",error);
                }else{
                    NSLog(@"response data is %@",data);
                }
            }];
            
            break;
        }
        case 2: {
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            //创建图片内容对象
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            //如果有缩略图，则设置缩略图
            [shareObject setShareImage:self.shareimg];
            
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
            shareObject.title=shareContent;
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    NSLog(@"************Share fail with error %@*********",error);
                }else{
                    NSLog(@"response data is %@",data);
                }
            }];
            break;
        }
        case 3: {
//            //创建分享消息对象
//            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//            
//            //创建图片内容对象
//            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
//            //如果有缩略图，则设置缩略图
//            [shareObject setShareImage:self.shareimg];
//            
//            //分享消息对象设置分享内容对象
//            messageObject.shareObject = shareObject;
//            //调用分享接口
//            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Qzone messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//                if (error) {
//                    NSLog(@"************Share fail with error %@*********",error);
//                }else{
//                    NSLog(@"response data is %@",data);
//                }
//            }];
            NSString *url;
            if ([self.sharecontent rangeOfString:@"http"].location!=NSNotFound) {
                url=[self.sharecontent substringToIndex:[self.sharecontent rangeOfString:@"http"].location];
            }else{
                url=self.sharecontent;
            }
            
            //要分享的内容，加在一个数组里边，初始化UIActivityViewController
            NSMutableArray *activityItems=[[NSMutableArray alloc] init];
            NSString *textToShare = url;
            UIImage *imageToShare = self.shareimg;
            // 本地沙盒目录
            NSURL *imageUrl=[NSURL URLWithString:@"http://www.fjqxfw.com:8099/gz_wap/"];
            [activityItems addObject:textToShare];
            if (imageToShare) {
                [activityItems addObject:imageToShare];
            }
            [activityItems addObject:imageUrl];
            
            
            UIActivityViewController *activity =[[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            
            [self.navigationController presentViewController:activity animated:YES completion:nil];
            break;

        }
            
            
    }
}
//短信取消
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    //       [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[self.bgscro class]]||[touch.view isKindOfClass:[UIImageView class]]||[touch.view isKindOfClass:[_pmView class]]||[touch.view isKindOfClass:[UIScrollView class]]||[touch.view isKindOfClass:[AirinfoList class]]) {
        [self.stfzlist setShowList:NO];
        [self.airlist setShowList:NO];
        return NO;
    }
    
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
