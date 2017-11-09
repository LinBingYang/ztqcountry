//
//  AQIViewController.m
//  ZtqCountry
//
//  Created by 派克斯科技 on 17/1/6.
//  Copyright © 2017年 yyf. All rights reserved.
//

#import "AQIViewController.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "CommonUtility.h"
#import <MAMapKit/MAMapView.h>
#import "airpollutionybModel.h"
#import "EGOImageView.h"
#import "UILabel+utils.h"
#import "CustomMAanitionView.h"
#import "MapBottomView.h"
#import "ShareSheet.h"
#import "weiboVC.h"
@interface AQIViewController ()<MAMapViewDelegate, AMapSearchDelegate, UIScrollViewDelegate>{
    NSInteger ybt_indexpt;
    NSInteger picNumber;
    BOOL downloadFinish,isplay;
    NSTimer *ybt_timer;
    NSInteger ybt_index;
}

@property (nonatomic, strong)UIView *stripesView;
@property (nonatomic, strong)MAMapView *mapview;
@property (nonatomic, strong)UIScrollView *ContaintMapView;
@property (nonatomic, strong)AMapSearchAPI *search;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)NSMutableDictionary *dataAmor;
@property (nonatomic, strong)NSMutableDictionary *colorSource;
@property (nonatomic, strong)NSMutableArray *cityarray, *cityNameArray;
@property (nonatomic, strong)NSMutableArray *dataomer;
@property (nonatomic, strong)NSMutableDictionary *comerAmor;
@property (nonatomic, assign)int index;
@property (nonatomic, assign)int comer;
@property (nonatomic, assign)int ccount, stationCount;
@property (nonatomic, strong)UIColor *color;
@property (nonatomic, assign)BOOL isreload;
@property (nonatomic, assign)BOOL isannotion, isfirst;
@property (nonatomic, assign)int goodAQI, littleGoodAQI, lightPollution, moderatePollution,highLevelPollution,seriousPollution;
@property (nonatomic, strong)MapBottomView *bottomView;

@property(strong,nonatomic)UIImageView *navbg;
@property(strong,nonatomic)UIImage *shareimg;
@property(strong,nonatomic)NSString *sharecontent;
@property(strong,nonatomic)UIView *towbtnview;

//预报图
@property(strong,nonatomic)EGOImageView *bgego;
@property(strong,nonatomic)NSMutableArray *ptarr,*btnarrs;
@property(strong,nonatomic)UIButton *playbtn;
@property(strong,nonatomic)UIScrollView *bgscrol;
@property(strong,nonatomic)UILabel *t_titlelab,*t_deslab;
@property(assign)BOOL isybtclick;
@end

@implementation AQIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ptarr=[[NSMutableArray alloc]init];
    self.btnarrs=[[NSMutableArray alloc]init];
    [self creatNagBar];
    [self addTwoBtn];
    //添加预报图
    [self creatBaseView];
//    [self getAirFbt];
    ///初始化地图
    _ContaintMapView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeitht - 100)];
    _ContaintMapView.contentSize = CGSizeMake(kScreenWidth, kScreenHeitht-100);
    _ContaintMapView.delegate = self;
    
    _mapview = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht - 220)];
    _mapview.delegate = self;
    _mapview.showsScale = NO;
    _mapview.showsCompass = NO;
    ///把地图添加至view
    [self.ContaintMapView addSubview:_mapview];
    [self.view addSubview:self.ContaintMapView];
    self.ContaintMapView.bounces = NO;
    self.search = [[AMapSearchAPI alloc]initWithSearchKey:[AMapServices sharedServices].apiKey Delegate:self];
    [self.mapview setZoomLevel:4];
    _mapview.rotateEnabled = NO;
    _mapview.rotateCameraEnabled = NO;
    [self getDate:nil];
    self.index = 0;
    self.comer = 0;
    self.ccount = 0;
    self.isfirst = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTheAnimationMsg:) name:@"animationPostMsg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contiuteSearchCity:) name:@"contiuteSearchCity" object:nil];
}
- (void)contiuteSearchCity:(NSNotification *)noti {
    if (_index == 0) {
        [MBProgressHUD showViewCenterHUDAddedTo:_ContaintMapView animated:YES];
        
    }
    
    if (_index < self.cityarray.count) {
        NSArray *array = self.cityarray[_index];
        for (NSString *city in array) {
            
            [self searchDistrictWithName:city];
        }
        _index++;
        
    }
    
    
    
}
#pragma mark - 创建导航条
- (void) creatNagBar
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    float place = 0;
    if(kSystemVersionMore7)
    {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
        place = 20;
    }
    UIImageView * navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    navigationBarBg.userInteractionEnabled = YES;
    navigationBarBg.image=[UIImage imageNamed:@"导航栏"];
    [self.view addSubview:navigationBarBg];
    self.navbg=navigationBarBg;
    UIButton * leftBut = [[UIButton alloc] initWithFrame:CGRectMake(20, 7+place, 30, 30)];
    [leftBut setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [leftBut setImage:[UIImage imageNamed:@"返回点击.png"] forState:UIControlStateHighlighted];
    [leftBut setBackgroundColor:[UIColor clearColor]];
    [leftBut addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarBg addSubview:leftBut];
    
    UIButton * rightbut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-40, 7+place, 30, 30)];
    [rightbut setImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
    [rightbut setBackgroundColor:[UIColor clearColor]];
    
    [rightbut addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarBg addSubview:rightbut];
    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 7+place, kScreenWidth-120, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = @"空气质量";
    [navigationBarBg addSubview:titleLab];
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtn:(id)sender{
    [self shareAction];
}


- (void)addTwoBtn {
    self.sharecontent=[NSString stringWithFormat:@"空气质量分布图%@",sharecontenturl];
    UIView *twoBtnView= [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 30)];
    twoBtnView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:twoBtnView];
    self.towbtnview=twoBtnView;
    UIButton *btn = [ UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 2, kScreenWidth / 2.0, 23);
    [twoBtnView addSubview:btn];
    [btn setTitle:@"空气质量分布图" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handlePollutionDistribution) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font  = [UIFont systemFontOfSize:16];
    UIButton *btn2 = [ UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(kScreenWidth / 2.0, 2, kScreenWidth / 2.0, 23);
    [btn2 setTitle:@"污染扩散预报图" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    
    [twoBtnView addSubview:btn2];
    [btn2 addTarget:self action:@selector(handlePollutionForecast) forControlEvents:UIControlEventTouchUpInside];
    btn2.titleLabel.font  = [UIFont systemFontOfSize:16];
    self.stripesView = [[UIView alloc]initWithFrame:CGRectMake(3, 28, kScreenWidth / 2 - 6, 2)];
    self.stripesView.backgroundColor = [UIColor redColor];
    
    [twoBtnView addSubview:self.stripesView];
}

#pragma mark - 切换按钮
#pragma mark - 空气污染分布图

- (void)handlePollutionDistribution {
    self.sharecontent=[NSString stringWithFormat:@"空气质量分布图%@",sharecontenturl];
    self.ContaintMapView.hidden = NO;
//    if (self.bgscrol) {
//        [self.bgscrol removeFromSuperview];
//        self.bgscrol=nil;
//    }
    self.bgscrol.hidden=YES;
    [self pause];
    [UIView animateWithDuration:0.2 animations:^{
        self.stripesView.frame = CGRectMake(3, 28, kScreenWidth / 2 - 6, 2);
    }];
}


#pragma mark - 空气污染预报图   


- (void)handlePollutionForecast {
    self.sharecontent=[NSString stringWithFormat:@"污染扩散预报图%@",sharecontenturl];
    self.ContaintMapView.hidden = YES;
    self.bgscrol.hidden=NO;
    if (self.isybtclick==NO) {
        [self getAirFbt];
        self.isybtclick=YES;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.stripesView.frame = CGRectMake(kScreenWidth / 2 + 3, 28, kScreenWidth / 2 - 6, 2);
        
    }];
   
    
}
-(void)creatBaseView{
    self.bgscrol=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeitht-100)];
    [self.view addSubview:self.bgscrol];
    
    self.bgego=[[EGOImageView alloc]initWithFrame:CGRectMake(0, 50, kScreenWidth, 250)];
    self.bgego.placeholderImage=[UIImage imageNamed:@"影视背景.jpg"];
    [self.bgscrol addSubview:self.bgego];
    self.t_titlelab=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.bgego.frame), kScreenWidth-20, 25)];
//    self.t_titlelab.text=@"测试";
    self.t_titlelab.font=[UIFont systemFontOfSize:14];
    self.t_titlelab.textColor=[UIColor colorHelpWithRed:50 green:141 blue:199 alpha:1];
    [self.bgscrol addSubview:self.t_titlelab];
    
    self.t_deslab=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.t_titlelab.frame), kScreenWidth-20, 30)];
//    self.t_deslab.text=@"测试";
    self.t_deslab.numberOfLines=0;
    self.t_deslab.font=[UIFont systemFontOfSize:14];
    self.t_deslab.textColor=[UIColor colorHelpWithRed:50 green:141 blue:199 alpha:1];
    [self.bgscrol addSubview:self.t_deslab];
    self.bgscrol.hidden=YES;
}
-(void)getAirFbt{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *sjkpindex = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [t_b setObject:sjkpindex forKey:@"gz_air_pollution"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
//    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        [self.ptarr removeAllObjects];
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        NSDictionary *sjkpindex=[t_b objectForKey:@"gz_air_pollution"];
        NSMutableArray *idx=[sjkpindex objectForKey:@"info_list"];
        NSString *title=[sjkpindex objectForKey:@"title"];
        NSString *des=[sjkpindex objectForKey:@"desc"];
        
        if (title.length>0) {
            UIImageView *bgline=[[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.t_titlelab.frame), (kScreenWidth-20) *(title.length / 21.0), 1)];
            bgline.backgroundColor=[UIColor colorHelpWithRed:50 green:141 blue:199 alpha:1];
            [self.bgscrol addSubview:bgline];
            self.t_titlelab.text=title;
            self.t_deslab.text=des;
//            float H=[self.t_deslab labelheight:des withFont:[UIFont systemFontOfSize:14]];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:des];;
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            [paragraphStyle setLineSpacing:4];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, des.length)];
            
            self.t_deslab.attributedText = attributedString;
            //调节高度
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName : paragraphStyle.copy};
            float H =   [self.t_deslab.text boundingRectWithSize:CGSizeMake(kScreenWidth-20, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
            self.t_deslab.frame=CGRectMake(10, CGRectGetMaxY(self.t_titlelab.frame)+6, kScreenWidth-20, H);
            self.bgscrol.contentSize=CGSizeMake(kScreenWidth, CGRectGetMaxY(self.t_deslab.frame)+20);
        }
        
        for (int j=0; j<[idx count]; j++) {
            NSDictionary *dataD = [idx objectAtIndex:j];
            
            if (dataD) {
                NSString *url=[dataD objectForKey:@"img_url"];
                airpollutionybModel *airmodel=[[airpollutionybModel alloc]init];
                airmodel.title=[dataD objectForKey:@"title"];
                airmodel.lm=[dataD objectForKey:@"lm"];
                airmodel.img_url=[dataD objectForKey:@"img_url"];
                
                [self.ptarr addObject:airmodel];
                if (j==0) {
                    [self.bgego setImageURL:[ShareFun makeImageUrl:url]];
                }
            }
            
        }
        if (self.ptarr.count>0) {
            UIButton *playbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-40, 10, 30, 30)];
            self.playbtn=playbtn;
            [playbtn setBackgroundImage:[UIImage imageNamed:@"air_播放"] forState:UIControlStateNormal];
            [playbtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
            [self.bgscrol addSubview:playbtn];
            [self creatDateBtnWithList:self.ptarr];//创建日期时间
            [self selectpt:0];
        }
        
        picNumber = [idx count] - 1;
        downloadFinish = NO;
//        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
    } withCache:YES];
}
-(void)creatDateBtnWithList:(NSArray *)lists{
    [self.btnarrs removeAllObjects];
    for (int i=0; i<lists.count; i++) {
        airpollutionybModel*airmodel=[[airpollutionybModel alloc]init];
        airmodel=lists[i];
        NSInteger time=airmodel.lm.integerValue;
        UIButton *datebtn=[[UIButton alloc]initWithFrame:CGRectMake(10+70*i, 10, 60, 30)];
        //        datebtn.backgroundColor=[UIColor redColor];
        [datebtn setBackgroundImage:[UIImage imageNamed:@"air_日期"] forState:UIControlStateNormal];
        datebtn.tag=i;
        [datebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        datebtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [datebtn addTarget:self action:@selector(selectpt:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgscrol addSubview:datebtn];
        [self.btnarrs addObject:datebtn];
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [inputFormatter setDateFormat:@"yyyy年MM月dd日"];
        NSString * dateStr = [inputFormatter stringFromDate:[NSDate date]];
        NSDate *inputDate = [inputFormatter dateFromString:dateStr];
        NSDate *nextDate = [NSDate dateWithTimeInterval:time*60*60 sinceDate:inputDate];
        NSDateFormatter *putFormatter = [[NSDateFormatter alloc] init];
        [putFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [putFormatter setDateFormat:@"M月dd日"];
        NSString * str = [putFormatter stringFromDate:nextDate];
        [datebtn setTitle:str forState:UIControlStateNormal];
        
    }
}
-(void)selectpt:(UIButton *)sender{
    isplay=NO;
    [self pause];
    NSInteger tag=sender.tag;
    ybt_index=tag;
    airpollutionybModel *airmodel=self.ptarr[tag];
    [self.bgego setImageURL:[ShareFun makeImageUrl:airmodel.img_url]];
    for (int i=0; i<self.btnarrs.count; i++) {
        UIButton *btn=self.btnarrs[i];
        if (i==tag) {
            [btn setBackgroundImage:[UIImage imageNamed:@"air_日期选中"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [btn setBackgroundImage:[UIImage imageNamed:@"air_日期"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}
-(void)playAction
{
    if ([self.ptarr count] == 0)
        return;
    isplay=!isplay;
    if (isplay) {
        //        if (!downloadFinish)
        //        {
        //        picNumber = 0;
        //        for (NSInteger i=0; i<[self.ptarr count]; i++)
        //        {
        //            NSString *url=self.ptarr[i];
        //            NSURL *t_url = [ShareFun makeImageUrl:url];
        //            [downQueue addDownImageWithURL:t_url andTag:i];
        //        }
        //        }else{
        [self play];
        //        }
    }else{
        [self pause];
    }
    
}
#pragma mark EGOImageLoadConnection delegate
- (void)aLoadConnectionDidFinishLoading:(NSData *)imgDta andTag:(NSInteger)aTag
{
    NSInteger tag = aTag;
    
    NSLog(@"imageLoadConnectionDidFinishLoading tag = %ld", tag);
    
    if (tag == [self.ptarr count]-1 )
    {
        ybt_indexpt = [self.ptarr count] - 1;
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self play];
    }
    
}
-(void)play{
    //    self.playbtn.backgroundColor=[UIColor redColor];
    [self.playbtn setBackgroundImage:[UIImage imageNamed:@"air_暂停"] forState:UIControlStateNormal];
    downloadFinish = YES;
    if (ybt_timer != nil)
        [self performSelector:@selector(pause)];
    
    ybt_timer = [NSTimer scheduledTimerWithTimeInterval:1.2
                                              target:self
                                            selector:@selector(timerAction)
                                            userInfo:nil
                                             repeats:YES];
}
- (void) pause
{
    
    //    self.playbtn.backgroundColor=[UIColor yellowColor];
    [self.playbtn setBackgroundImage:[UIImage imageNamed:@"air_播放"] forState:UIControlStateNormal];
    if (ybt_timer != nil)
    {
        [ybt_timer invalidate];
        ybt_timer = nil;
    }
}

- (void) timerAction
{
    ybt_index++;
    if (ybt_index >= self.ptarr.count)
        ybt_index = 0;
    airpollutionybModel *airmodel=[[airpollutionybModel alloc]init];
    airmodel=self.ptarr[ybt_index];
    [self.bgego setImageURL:[ShareFun makeImageUrl:airmodel.img_url]];
    for (int i=0; i<self.btnarrs.count; i++) {
        UIButton *btn=self.btnarrs[i];
        if (i==ybt_index) {
            [btn setBackgroundImage:[UIImage imageNamed:@"air_日期选中"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [btn setBackgroundImage:[UIImage imageNamed:@"air_日期"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
}

-(void)getDate:(NSString*)t_rankType{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_type = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    
    
    
    [t_type setObject:@"aqi" forKey:@"rank_type"];
    [t_b setObject:t_type forKey:@"gz_air_city_rank_new"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    
    [[NetWorkCenter share] postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary *b = returnData[@"b"];
        NSDictionary *gz_air_city_rank = b[@"gz_air_city_rank_new"];
        NSArray *rank_list = gz_air_city_rank[@"rank_list"];
        self.dataSource = [rank_list mutableCopy];
        self.dataAmor = [NSMutableDictionary dictionary];
        
        self.colorSource = [NSMutableDictionary dictionary];
        self.cityNameArray = [NSMutableArray array];
        self.goodAQI = 0;
        self.littleGoodAQI = 0;
        self.lightPollution = 0;
        self.moderatePollution = 0;
        self.highLevelPollution = 0;
        self.seriousPollution = 0;
        for (NSDictionary *obj in rank_list) {
            NSString *city = obj[@"map_name"];
            NSString * num = obj[@"num"];
            NSString *cityName = obj[@"city"];
            [self judjeTheTotoalAqiNum:num];
            [self.colorSource setValue:num forKey:city];
            [self.cityNameArray addObject:cityName];
        }
        NSArray *array = self.colorSource.allKeys;
       [self copareTheDataSourceCityArrayWithCount:5 withArray:array];
        
        if (self.mapview.zoomLevel > 6) {
            self.isannotion = NO;
            self.isreload = YES;
            //添加标注
            for (NSDictionary *obj in self.dataSource) {
                MAPointAnnotation *poiAnnotation = [[MAPointAnnotation alloc] init];
                NSString *lat = obj[@"lat"];
                NSString *lon = obj[@"lon"];
                NSString *areaID = obj[@"areaId"];
                NSString *num = obj[@"num"];
                poiAnnotation.coordinate = CLLocationCoordinate2DMake(lat.floatValue, lon.floatValue);
                poiAnnotation.title      = num;
                poiAnnotation.subtitle = areaID;
                
                [self.mapview addAnnotation:poiAnnotation];
            }
        }else {
            self.isreload = NO;
            self.isannotion = YES;
            
            //添加预报图
            [self contiuteSearchCity:nil];

        }
                if (!self.isfirst) {
                    //[self getair_qua_detailWithtype:@"aqi" withcityid:@"AIR_56" selected:NO];
                    [self getair_qua_detailWithtype:@"aqi" withcityid:self.Air_stationid selected:NO];
                    self.isfirst = YES;
                }
        

    } withFailure:^(NSError *error) {
        
    } withCache:NO];
    

    
}

- (void)copareTheDataSourceCityArrayWithCount:(int)subCount withArray:(NSArray *)array {
    unsigned long count = array.count %subCount == 0 ? (array.count / subCount):(array.count / subCount + 1);
    self.cityarray = [NSMutableArray array];
    [self.cityarray removeAllObjects ];
    
    for (int i = 0; i < count; i ++)  {
        NSMutableArray *obj = [NSMutableArray array];
        int index = i * subCount;
        
        while (index < subCount*(i + 1) && index < array.count) {
            [obj addObject:[array objectAtIndex:index]];
            index += 1;
        }
        //将子数组添加到保存子数组的数组中
        [self.cityarray addObject:obj];
        
    }
    
    
    
}



-(void)getair_qua_detailWithtype:(NSString *)type withcityid:(NSString *)cityid selected:(BOOL)selected{
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
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary *gz_air_qua_detail=[b objectForKey:@"gz_air_qua_detail"];
//            NSString *aqi=[gz_air_qua_detail objectForKey:@"type"];
//            NSString *quality=[gz_air_qua_detail objectForKey:@"quality"];
            NSString *city_name=[gz_air_qua_detail objectForKey:@"city_name"];
            NSString *update_time=[gz_air_qua_detail objectForKey:@"update_time"];
            NSArray *station_list  = gz_air_qua_detail[@"station_list"];
            self.stationCount = (int)station_list.count;
            if (self.bottomView) {
                [self.bottomView removeFromSuperview];
                self.bottomView = nil;
            }
            CGFloat hieght = self.stationCount * 30 + 20;
            if (hieght < 120) {
                hieght = 120;
            }
            if (self.mapview.zoomLevel > 6) {
                _ContaintMapView.contentSize = CGSizeMake(kScreenWidth, kScreenHeitht -100 + hieght - 120);
            }
            
            
            
            self.bottomView = [[MapBottomView alloc]initWithFrame:CGRectMake(0, kScreenHeitht - 220, kScreenWidth, hieght) Good:self.goodAQI littleGood:self.littleGoodAQI LightPollution:self.lightPollution midlePollution:self.moderatePollution highLevelPollution:self.highLevelPollution seriousPollution:self.seriousPollution datasource:station_list time:update_time];
            [self.bottomView settypeWithZoomLevel:self.mapview.zoomLevel text:city_name select:selected];
            [self.ContaintMapView addSubview:self.bottomView];
            
                    }
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}


-(UIColor *)getAQI:(NSString *)aqivalue{
    int air=aqivalue.intValue;
    UIColor *color=nil;
    if (air>=0 &&air<51) {
        color=[UIColor colorWithRed:101.0/255.0f green:240.0/255.0f blue:2.0/255.0f alpha:0.8f];
    }else
        if (air>50 && air <101) {
            color=[UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:28.0/255.0f alpha:0.8f];
        }else
            if (air>100 && air<151) {
                color=[UIColor colorWithRed:253.0/255.0f green:164.0/255.0f blue:10.0/255.0f alpha:0.8f];
            }else
                if (air>150 && air<201) {
                    color=[UIColor colorWithRed:239.0/255.0f green:8.0/255.0f blue:2.0/255.0f alpha:0.8f];
                }else
                    if (air>200 && air<301) {
                        color=[UIColor colorWithRed:153.0/255.0f green:0.0/255.0f blue:153.0/255.0f alpha:0.8f];
                    }else
                        if (air>300) {
                            color=[UIColor colorWithRed:139.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:0.8f];
                        }
    return color;
}


- (UIImage *)getMapCustomimage:(NSString *)aqivalue {
    int air=aqivalue.intValue;
    UIImage *image;
    if (air>=0 &&air<51) {
        image = [UIImage imageNamed:@"u18"];
    }else
        if (air>50 && air <101) {
            image = [UIImage imageNamed:@"u16"];
        }else
            if (air>100 && air<151) {
               image = [UIImage imageNamed:@"u20"];
            }else
                if (air>150 && air<201) {
                    image = [UIImage imageNamed:@"u22"];
                }else
                    if (air>200 && air<301) {
                        image = [UIImage imageNamed:@"u24"];
                    
                    }else
                        if (air>300) {
                          image = [UIImage imageNamed:@"u26"];
                        }
    return image;
    
}


- (void)judjeTheTotoalAqiNum:(NSString *)aqiNum {
    int air=aqiNum.intValue;
    if (air>=0 &&air<51) {
        self.goodAQI++;
    }else
        if (air>50 && air <101) {
            self.littleGoodAQI++;
            
        }else
            if (air>100 && air<151) {
                self.lightPollution ++;
            }else
                if (air>150 && air<201) {
                    self.moderatePollution++;
                }else
                    if (air>200 && air<301) {
                        self.highLevelPollution ++;
                    }else
                        if (air>300) {
                            self.seriousPollution++;
                        }
}





#pragma mark - Helpers

- (void)handleDistrictResponse:(AMapDistrictSearchResponse *)response
{
    if (response == nil)
    {
        return;
    }
    
    for (AMapDistrict *dist in response.districts)
    {
        
        if (dist.polylines.count > 0)
        {
//            MAMapRect bounds = MAMapRectZero;
            
            for (NSString *polylineStr in dist.polylines)
            {
                MAPolygon *polyline = [CommonUtility polylineForCoordinateString:polylineStr];
                polyline.title = dist.name;
                [self.mapview addOverlay:polyline level:0];
                
//                bounds = MAMapRectUnion(bounds, polyline.boundingMapRect);
            }
            
            //            [self.mapview setVisibleMapRect:bounds animated:YES];
        }
        
        
        
        
    }
    
}

- (void)searchDistrictWithName:(NSString *)name
{
    NSString *cc = name;
    AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
    dist.keywords = cc;
    dist.requireExtension = YES;
    
    [self.search AMapDistrictSearch:dist];
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    //{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        
        CustomMAanitionView *annotationView = (CustomMAanitionView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomMAanitionView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.aqiNum = annotation.title;
        annotationView.aqiImage = [self getMapCustomimage:annotation.title];
        annotationView.areaId = annotation.subtitle;
        
        
     
        annotationView.canShowCallout = NO;
        annotationView.draggable = YES;;
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -25);
        return annotationView;
    }
    
    return nil;
}

- (void)receiveTheAnimationMsg:(NSNotification *)noti {
    [self getair_qua_detailWithtype:@"aqi" withcityid:noti.object selected:YES];
    
}


- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        
        
        MAPolygon *line= (MAPolygon *)overlay;
        
        NSString *city = line.title;
        if ([city  rangeOfString:@"章丘"].location != NSNotFound ){
            return nil;
        }
        NSString *cc =  [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
        
        NSString *dd = [cc stringByReplacingOccurrencesOfString:@"区" withString:@""];
        
        NSString *ff = [dd stringByReplacingOccurrencesOfString:@"县" withString:@""];
        
        
        
        
        NSString *num = [self.colorSource valueForKey:ff];
        NSArray *array = self.cityarray.lastObject;
        if ([array.lastObject isEqualToString:ff]) {
            [MBProgressHUD hideHUDForView:_ContaintMapView animated:YES];
        }
        MAPolygonRenderer*gon = [[MAPolygonRenderer alloc]initWithOverlay:overlay];
        gon.strokeColor = [self getAQI:num];
        gon.fillColor = [self getAQI:num];
        
        return gon;
    }
    
    
    if ([overlay isKindOfClass:[MATileOverlay class]])
    {
        MATileOverlayRenderer *render = [[MATileOverlayRenderer alloc] initWithTileOverlay:overlay];
        
        return render;
    }
    
    
    return nil;
}


- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction {
    if (wasUserAction) {
        [self.bottomView settypeWithZoomLevel:self.mapview.zoomLevel text:nil select:NO
         ];
        if (self.mapview.zoomLevel > 6) {
            CGFloat hieght = self.stationCount * 30 + 20;
            if (hieght < 120) {
                hieght = 120;
            }

            _ContaintMapView.contentSize = CGSizeMake(kScreenWidth, kScreenHeitht -100 + hieght - 120);
//            [self.mapview removeOverlays:self.mapview.overlays];
            if (self.dataSource != nil ) {
                if (self.isannotion == YES) {
                    for (NSDictionary *obj in self.dataSource) {
                        MAPointAnnotation *poiAnnotation = [[MAPointAnnotation alloc] init];
                        NSString *lat = obj[@"lat"];
                        NSString *lon = obj[@"lon"];
                        NSString *areaID = obj[@"areaId"];
                        NSString *num = obj[@"num"];
                       
                        poiAnnotation.coordinate = CLLocationCoordinate2DMake(lat.floatValue, lon.floatValue);
                        poiAnnotation.title      = num;
                        poiAnnotation.subtitle = areaID;
                        
                        [self.mapview addAnnotation:poiAnnotation];
                        
                    }
                }
            }else {
                _index = 0;
//                [self contiuteSearchCity:nil];
            }
            self.isreload = YES;
            self.isannotion = NO;
        }else {
            _ContaintMapView.contentSize = CGSizeMake(kScreenWidth, kScreenHeitht-100 );
            [self.mapview removeAnnotations:self.mapview.annotations];
            if (self.isreload) {
                _index = 0;
//                [self contiuteSearchCity:nil];
                self.isreload = NO;
                self.isannotion = YES;
            }
        }
    }
}


- (void)mapView:(MAMapView *)mapView mapWillZoomByUser:(BOOL)wasUserAction {
    
}



#pragma mark - AMapSearchDelegate
- (void)searchRequest:(id)request didFailWithError:(NSError *)error {
    [self.search AMapDistrictSearch:request];
}

- (void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"contiuteSearchCity" object:nil];
    [self handleDistrictResponse:response];
    
}

#pragma mark - UIScrollViewDelegate
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    if (self.mapview.zoomLevel<6.0) {
//        self.ContaintMapView.scrollEnabled = NO;
//    }else {
//        self.ContaintMapView.scrollEnabled = YES;
//    }
//}

- (void)dealloc {
    self.mapview.delegate = nil;
    
    self.search.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.mapview = nil;
    self.search = nil;

}
#pragma mark 分享
-(void)shareAction{
    
    //分享
    
    
    self.shareimg=[self makeImageMore];
    NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weiboShare.png"];
    if ([UIImagePNGRepresentation(self.shareimg) writeToFile:shareImagePath atomically:YES])
        NSLog(@">>write ok");
    
    ShareSheet * sheet = [[ShareSheet alloc] initDefaultWithTitle:@"分享天气" withDelegate:self];
    [sheet show];
}
-(UIImage *)makeImageMore
{
    UIScrollView *bgscro;
    NSMutableArray *images=[[NSMutableArray alloc]init];
    if (self.ContaintMapView.hidden==NO) {
        bgscro=self.ContaintMapView;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, 64), NO, 0.0);
        [self.navbg.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [images addObject:tempImage];
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, 30), NO, 0.0);
        [self.towbtnview.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *tempImage1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [images addObject:tempImage1];
        
        UIImageView *mapimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht-220)];
        __block UIImage *screenshotImage = nil;
        __block NSInteger resState = 1;
        [self.mapview takeSnapshotInRect:CGRectMake(0, 30, kScreenWidth, kScreenHeitht-220) withCompletionBlock:^(UIImage *resultImage, NSInteger state) {
            screenshotImage = resultImage;
            resState = state; // state表示地图此时是否完整，0-不完整，1-完整
            //            [images addObject:screenshotImage];
            
            mapimg.image=resultImage;
            [bgscro addSubview:mapimg];
        }];
        
        
        UIImage* image = nil;
        UIGraphicsBeginImageContextWithOptions(bgscro.contentSize, NO, 0.0);
        //    UIGraphicsBeginImageContext(_glassScrollView.foregroundScrollView.contentSize);
        {
            CGPoint savedContentOffset = bgscro.contentOffset;
            CGRect savedFrame = bgscro.frame;
            
            bgscro.contentOffset = CGPointZero;
            bgscro.frame = CGRectMake(0, 0, kScreenWidth, bgscro.contentSize.height);
            bgscro.backgroundColor=[UIColor whiteColor];
            [bgscro.layer renderInContext: UIGraphicsGetCurrentContext()];
            bgscro.backgroundColor=[UIColor clearColor];
            image = UIGraphicsGetImageFromCurrentImageContext();
            
            bgscro.contentOffset = savedContentOffset;
            bgscro.frame = savedFrame;
        }
        UIGraphicsEndImageContext();
        [images addObject:image];
        if (mapimg) {
            [mapimg removeFromSuperview];
            mapimg=nil;
        }
    }else{
        bgscro=self.bgscrol;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, 64), NO, 0.0);
        [self.navbg.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [images addObject:tempImage];
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, 30), NO, 0.0);
        [self.towbtnview.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *tempImage1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [images addObject:tempImage1];
        
        UIImage* image = nil;
        UIGraphicsBeginImageContextWithOptions(bgscro.contentSize, NO, 0.0);
        //    UIGraphicsBeginImageContext(_glassScrollView.foregroundScrollView.contentSize);
        {
            CGPoint savedContentOffset = bgscro.contentOffset;
            CGRect savedFrame = bgscro.frame;
            
            bgscro.contentOffset = CGPointZero;
            bgscro.frame = CGRectMake(0, 0, kScreenWidth, bgscro.contentSize.height);
            bgscro.backgroundColor=[UIColor whiteColor];
            [bgscro.layer renderInContext: UIGraphicsGetCurrentContext()];
            bgscro.backgroundColor=[UIColor clearColor];
            image = UIGraphicsGetImageFromCurrentImageContext();
            
            bgscro.contentOffset = savedContentOffset;
            bgscro.frame = savedFrame;
        }
        UIGraphicsEndImageContext();
        [images addObject:image];
    }
    
    
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
@end
