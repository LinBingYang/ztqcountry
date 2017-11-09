//
//  TravelCollectVC.m
//  ZtqCountry
//
//  Created by Admin on 15/7/6.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "TravelCollectVC.h"
#import "moreTravelController.h"
@implementation TravelCollectVC
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
    
    UIButton * rightbut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-40, place, 40, 40)];
    self.rightbtn=rightbut;
    [rightbut setImage:[UIImage imageNamed:@"旅游天气搜索.png"] forState:UIControlStateNormal];
        [rightbut setImage:[UIImage imageNamed:@"旅游天气搜索二态.png"] forState:UIControlStateHighlighted];
    [rightbut setBackgroundColor:[UIColor clearColor]];
    
    [rightbut addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarBg addSubview:rightbut];
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 7+place, kScreenWidth-120, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text =@"景点收藏";
    [self.navigationBarBg addSubview:titleLab];
    
    city_tq = [[NSMutableDictionary alloc] initWithCapacity:1];

    

}
-(void)viewWillAppear:(BOOL)animated{
    [self.bgscro removeFromSuperview];
    self.allarr=[[NSMutableArray alloc]init];
    NSMutableArray *citys=[[[NSUserDefaults standardUserDefaults]objectForKey:@"Travel"]mutableCopy];//如果没加mutablecopy的话 standaradUserdefault会返回一个arrary
    self.allarr=citys;
    if (!citys.count>0) {
        if (!self.lab) {
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, 30)];
            lab.text=@"中国这么大，想去哪走走，搜搜吧！";
            self.lab=lab;
            lab.textColor=[UIColor blackColor];
            lab.textAlignment=NSTextAlignmentCenter;
            lab.font=[UIFont systemFontOfSize:16];
            [self.view addSubview:lab];
        }
        
    }else{
        [self.lab removeFromSuperview];
        self.lab=nil;
    }
    [self getdata];
    
}
-(void)getdata{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    //    NSMutableDictionary *week = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    
    for(int i=0;i<self.allarr.count;i++)
    {
        NSMutableDictionary * sstq = [[NSMutableDictionary alloc] init];
        NSDictionary * currentCityInfo = [self.allarr objectAtIndex:i];
        NSString * currentID = [currentCityInfo objectForKey:@"ID"];
        [sstq setObject:currentID forKey:@"tour_id"];
        [t_b setObject:sstq forKey:[NSString stringWithFormat:@"gz_tour_weekwt#%@",currentID]];
    }
    
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    //    NSLog(@"%@",t_dic);
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        //        NSLog(@"%@",returnData);
        
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            for(int i=0;i<self.allarr.count;i++)
            {
                NSDictionary * cityInfo = [self.allarr objectAtIndex:i];
                NSString * cityID = [cityInfo objectForKey:@"ID"];
                NSString * newKey = [NSString stringWithFormat:@"gz_tour_weekwt#%@",cityID];
                NSDictionary * sstqForCityInfo = [b objectForKey:newKey];
                NSArray * weekinfos = [sstqForCityInfo objectForKey:@"tour_weekwt_list"];
                if (weekinfos.count>0) {
                    [city_tq setObject:weekinfos[0] forKey:cityID];
                }
                
                
            }
            [self CreatbtnInfo];
        }
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withCache:YES];
}
-(void)CreatbtnInfo{
    float width=self.view.width;
    self.bgscro=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht)];
    self.bgscro.contentSize=CGSizeMake(kScreenWidth, kScreenHeitht);
    self.bgscro.showsHorizontalScrollIndicator=NO;
    self.bgscro.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.bgscro];
    //九宫格
    for (int row=0; row<[self.allarr count]/2+1; row++) {
        for (int i = 0; i < [self.allarr count]; i ++) {
            int t_row = i / 2;
            if (t_row==row) {
                UIButton *t_btn = [UIButton buttonWithType:UIButtonTypeCustom];
                t_btn.tag=i;
                int x = (width-280)/3+(i%2)*(140+(width-280)/3);
                t_btn.frame = CGRectMake(0, 0, 140, 100);
//                t_btn.backgroundColor=[UIColor redColor];
//                [t_btn setBackgroundImage:[UIImage imageNamed:@"底座"] forState:UIControlStateNormal];
                [t_btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(x, 130*row+5, 140, 120)];
                bgimg.image=[UIImage imageNamed:@"底座"];
                bgimg.userInteractionEnabled=YES;
                [self.bgscro addSubview:bgimg];
                [bgimg addSubview:t_btn];
                UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 30, 140, 1)];
                line.backgroundColor=[UIColor colorHelpWithRed:234 green:234 blue:234 alpha:1];
                [bgimg addSubview:line];
                NSString * cityID =[[self.allarr objectAtIndex:i]objectForKey:@"ID"];
                NSString *provicename=[[self.allarr objectAtIndex:i]objectForKey:@"Provice"];
                NSDictionary * cityWeatherInfo = [city_tq objectForKey:cityID];
                if(cityWeatherInfo != nil)
                {
                    //        NSDictionary * sstq = [cityWeatherInfo objectForKey:@"sstq"];
                    
                    NSString * lowt = [cityWeatherInfo objectForKey:@"lowt"];
                    NSString * higt = [cityWeatherInfo objectForKey:@"higt"];
                    NSString *iconame=[cityWeatherInfo objectForKey:@"wt_day_ico"];
                    NSString *is_night=[cityWeatherInfo objectForKey:@"is_night"];
                    
                    NSDictionary *dic=self.allarr[i];
                    UILabel *citylab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
                    citylab.textColor=[UIColor blackColor];
                    citylab.textAlignment=NSTextAlignmentCenter;
                    citylab.text=[dic objectForKey:@"city"];
                    citylab.font=[UIFont systemFontOfSize:15];
                    [bgimg addSubview:citylab];
                    UIImageView *ld=[[UIImageView alloc]initWithFrame:CGRectMake(10, 40, 40, 40)];
                    ld.image=[UIImage imageNamed:@"小天气图标底座"];
                    [bgimg addSubview:ld];
                    UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
                    //        icon.image=[UIImage imageNamed:@"00"];
                    [ld addSubview:icon];
                   
                    UILabel *wdlab=[[UILabel alloc]initWithFrame:CGRectMake(70, 45, 70, 30)];
                    wdlab.textColor=[UIColor blackColor];
                    //        wdlab.text=@"晴转多云";
                    wdlab.font=[UIFont systemFontOfSize:14];
                    [bgimg addSubview:wdlab];
                    wdlab.text=[NSString stringWithFormat:@"%@°/%@°",higt,lowt];
                    if ([is_night isEqualToString:@"1"]) {
                        iconame=[cityWeatherInfo objectForKey:@"wt_night_ico"];
                    }
                    [icon setImage:[UIImage imageNamed:iconame]];
                    
                    UILabel *prolab=[[UILabel alloc]initWithFrame:CGRectMake(10, 85, 90, 30)];
                    prolab.text=provicename;
                    prolab.textColor=[UIColor blackColor];
                    prolab.font=[UIFont systemFontOfSize:15];
                    [bgimg addSubview:prolab];
                    
                    UIButton *delebtn=[[UIButton alloc]initWithFrame:CGRectMake(100, 80, 40, 40)];
                    delebtn.tag=i;
                    [delebtn setBackgroundImage:[UIImage imageNamed:@"旅游天气城市删除"] forState:UIControlStateNormal];
                    [delebtn setBackgroundImage:[UIImage imageNamed:@"旅游天气城市删除二态"] forState:UIControlStateHighlighted];
                    [delebtn addTarget:self action:@selector(deleAction:) forControlEvents:UIControlEventTouchUpInside];
                    [bgimg addSubview:delebtn];
                    
                }
                
            }
        }
    }
    self.bgscro.contentSize=CGSizeMake(kScreenWidth, 120*(self.allarr.count/2+2));

}

-(void)btnAction:(UIButton *)sender{
    [self.bgscro removeFromSuperview];
    NSInteger tag=sender.tag;
    NSString *cityid=[self.allarr[tag] objectForKey:@"ID"];
    NSString *cityname=[self.allarr[tag] objectForKey:@"city"];
    moreTravelController *collectVC = [[moreTravelController alloc] init];
    [collectVC setTravelCity:cityid];
    collectVC.mycity=cityname;
    [self.navigationController pushViewController:collectVC animated:YES];
}
-(void)deleAction:(UIButton *)sender{
    NSInteger tag=sender.tag;
    [self.allarr removeObjectAtIndex:tag];
    [self.bgscro removeFromSuperview];
    [[NSUserDefaults standardUserDefaults] setObject:self.allarr forKey:@"Travel"];
    [[NSUserDefaults standardUserDefaults]synchronize];
//    [self getdata];
    [self viewWillAppear:YES];

}
-(void)leftBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBtn:(UIButton *)sender{
    TravelViewController *travelVC = [[TravelViewController alloc] init];
    [travelVC setDataSource:m_treeNodeProvince withCitys:m_treeNodelLandscape];
    [self.navigationController pushViewController:travelVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
