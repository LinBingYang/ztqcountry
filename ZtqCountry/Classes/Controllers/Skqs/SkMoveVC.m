//
//  SkMoveVC.m
//  ZtqCountry
//
//  Created by Admin on 15/6/19.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "SkMoveVC.h"
#import "WebViewController.h"
@implementation SkMoveVC
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
    titleLab.text = @"实况走势";
    [self.navigationBarBg addSubview:titleLab];
    
    self.adimgurls=[[NSMutableArray alloc]init];
    self.adtitles=[[NSMutableArray alloc]init];
    self.adurls=[[NSMutableArray alloc]init];
    
    self.bgscr=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht)];
    self.bgscr.contentSize=CGSizeMake(kScreenWidth, kScreenHeitht);
    self.bgscr.showsHorizontalScrollIndicator=NO;
    self.bgscr.showsVerticalScrollIndicator=NO;
    self.bgscr.backgroundColor=[UIColor clearColor];
    [self.bgimg addSubview:self.bgscr];
    
    self.wdbtn=[[UIButton alloc]initWithFrame:CGRectMake(0,5, kScreenWidth/4, 30)];
    [self.wdbtn setTitle:@"气温" forState:UIControlStateNormal];
    [self.wdbtn addTarget:self action:@selector(wdAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscr addSubview:self.wdbtn];
    self.sdbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/4,5,kScreenWidth/4, 30)];
    [self.sdbtn setTitle:@"湿度" forState:UIControlStateNormal];
    [self.sdbtn addTarget:self action:@selector(sdAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscr addSubview:self.sdbtn];
    self.njdbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/4*2,5,kScreenWidth/4, 30)];
    [self.njdbtn setTitle:@"能见度" forState:UIControlStateNormal];
    [self.njdbtn addTarget:self action:@selector(njdAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscr addSubview:self.njdbtn];
    self.rainbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/4*3,5,kScreenWidth/4, 30)];
    [self.rainbtn setTitle:@"雨量" forState:UIControlStateNormal];
    [self.rainbtn addTarget:self action:@selector(rainAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgscr addSubview:self.rainbtn];
        self.selectimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 35, kScreenWidth/4-20, 2)];
        self.selectimg.image=[UIImage imageNamed:@"一周 24小时切换条"];
        [self.bgscr addSubview:self.selectimg];
    self.wdarr=[[NSMutableArray alloc]init];
    self.humarr=[[NSMutableArray alloc]init];
    self.visarr=[[NSMutableArray alloc]init];
    self.timearr=[[NSMutableArray alloc]init];
    self.rainarr=[[NSMutableArray alloc]init];
   self.type=@"1";
    [self getskmovedata];
    [self loadMainAD:@"5"];
}
-(void)wdAction{
    self.type=@"1";
    [self.skmview removeFromSuperview];
    self.skmview=nil;
    [self getskmovedata];
     self.selectimg.frame=CGRectMake(10, 35, kScreenWidth/4-20, 2);
    self.iconame=@"气温图标";
    self.titlename=@"24小时气温实况走势图（单位：℃）";
//    [self.skmview upWithicon:self.iconame Withtitle:self.titlename Withdatas:self.wdarr WithTimes:self.timearr Withnowinfo:self.nowct Withflag:@"℃"];
    [self loadMainAD:@"5"];
}
-(void)sdAction{
    self.type=@"2";
    [self.skmview removeFromSuperview];
    self.skmview=nil;
    [self getskmovedata];
    self.selectimg.frame=CGRectMake(kScreenWidth/4+10, 35, kScreenWidth/4-20, 2);
    self.iconame=@"湿度图标";
    self.titlename=@"24小时湿度实况走势图（单位：%）";
//     [self.skmview upWithicon:self.iconame Withtitle:self.titlename Withdatas:self.wdarr WithTimes:self.timearr Withnowinfo:self.nowhum Withflag:@"%"];
    [self loadMainAD:@"6"];
}
-(void)njdAction{
    self.type=@"3";
    [self.skmview removeFromSuperview];
    self.skmview=nil;
    [self getskmovedata];
    self.selectimg.frame=CGRectMake(kScreenWidth/4*2+10, 35, kScreenWidth/4-20, 2);
    self.iconame=@"能见度图标";
    self.titlename=@"24小时能见度实况走势图（单位：m）";
//     [self.skmview upWithicon:self.iconame Withtitle:self.titlename Withdatas:self.wdarr WithTimes:self.timearr Withnowinfo:self.nowvisil Withflag:@"m"];
    [self loadMainAD:@"7"];
}
-(void)rainAction{
    self.type=@"4";
    [self.skmview removeFromSuperview];
    self.skmview=nil;
    [self getskmovedata];
    self.selectimg.frame=CGRectMake(kScreenWidth/4*3+10, 35, kScreenWidth/4-20, 2);
    self.iconame=@"雨量图标";
    self.titlename=@"24小时雨量实况走势图（单位：mm）";
    //     [self.skmview upWithicon:self.iconame Withtitle:self.titlename Withdatas:self.wdarr WithTimes:self.timearr Withnowinfo:self.nowvisil Withflag:@"m"];
    [self loadMainAD:@"7"];
}
-(void)getskmovedata{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_weekwt = [[NSMutableDictionary alloc] init];
    [gz_weekwt setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    [b setObject:gz_weekwt forKey:@"gz_real_trend"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            [self.wdarr removeAllObjects];
            [self.humarr removeAllObjects];
            [self.visarr removeAllObjects];
            [self.rainarr removeAllObjects];
            [self.timearr removeAllObjects];
            NSDictionary * gz_hourswt = [b objectForKey:@"gz_real_trend"];
            NSArray *real_trend_list=[gz_hourswt objectForKey:@"real_trend_list"];
            for (int i=0; i<real_trend_list.count; i++) {
                NSString *time=[real_trend_list[i] objectForKey:@"time"];
                NSString *humidity=[real_trend_list[i] objectForKey:@"humidity"];
                NSString *visibility=[real_trend_list[i] objectForKey:@"visibility"];
                NSString *temperature=[real_trend_list[i] objectForKey:@"temperature"];
                NSString *rainfall=[real_trend_list[i] objectForKey:@"rainfall"];
                [self.wdarr addObject:temperature];
                [self.humarr addObject:humidity];
                [self.visarr addObject:visibility];
                [self.rainarr addObject:rainfall];
                [self.timearr addObject:time];
                if (i==0) {
                    self.nowrain=rainfall;
                }
                
            }
//            NSArray *wdarr=[[self.wdarr reverseObjectEnumerator]allObjects];
//             NSArray *humarr=[[self.humarr reverseObjectEnumerator]allObjects];
//             NSArray *visarr=[[self.visarr reverseObjectEnumerator]allObjects];
//             NSArray *rainarr=[[self.rainarr reverseObjectEnumerator]allObjects];
//             NSArray *timearr=[[self.timearr reverseObjectEnumerator]allObjects];
            if (self.skmview==nil) {
                self.skmview=[[SKMoveView alloc]initWithFrame:CGRectMake(0, 50, kScreenWidth, 300)];
                [self.bgscr addSubview:self.skmview];
            }
            
            if ([self.type isEqualToString:@"1"]) {
                [self.skmview upWithicon:@"气温图标" Withtitle:@"24小时气温实况走势图（单位：℃）" Withdatas:self.wdarr WithTimes:self.timearr Withnowinfo:self.nowct Withflag:@"℃"];
            }
            if ([self.type isEqualToString:@"2"]) {
                [self.skmview upWithicon:self.iconame Withtitle:self.titlename Withdatas:self.humarr WithTimes:self.timearr Withnowinfo:self.nowhum Withflag:@"%"];
            }
            if ([self.type isEqualToString:@"3"]) {
                [self.skmview upWithicon:self.iconame Withtitle:self.titlename Withdatas:self.visarr WithTimes:self.timearr Withnowinfo:self.nowvisil Withflag:@"m"];
            }
            if ([self.type isEqualToString:@"4"]) {
                [self.skmview upWithicon:self.iconame Withtitle:self.titlename Withdatas:self.rainarr WithTimes:self.timearr Withnowinfo:self.nowrain Withflag:@"mm"];
            }
          
            
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
                        self.bmadscro = [[BMAdScrollView alloc] initWithNameArr:self.adimgurls  titleArr:self.adtitles height:170 offsetY:330 offsetx:10];
                        self.bmadscro.vDelegate = self;
                        self.bmadscro.pageCenter = CGPointMake(280, 300);
                        [self.bgscr addSubview:self.bmadscro];
                    
                    
                }
                
            }
            
        }
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
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
