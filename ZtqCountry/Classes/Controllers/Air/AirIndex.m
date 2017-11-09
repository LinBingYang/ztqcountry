//
//  AirIndex.m
//  ZtqNew
//
//  Created by linxg on 13-8-1.
//
//

#import "AirIndex.h"
#import "ShareFun.h"
#import "UIColor+ColorWithHexColor.h"
//#import "NetWorkCenter.h"
@interface AirIndex ()

@end

@implementation AirIndex
@synthesize shareStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   

	// Do any additional setup after loading the view.
   
    
    if (kSystemVersionMore7) {
        self.edgesForExtendedLayout=UIEventSubtypeNone;
    }
	
	
    UIView *t_rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
		
	UIButton *t_shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[t_shareBtn setFrame:CGRectMake(0, 0, 44, 44)];
	[t_shareBtn addTarget:self action:@selector(shareAir:) forControlEvents:UIControlEventTouchUpInside];
	[t_shareBtn setImage:[UIImage imageNamed:@"分享按钮.png"] forState:UIControlStateNormal];
	[t_rightView addSubview:t_shareBtn];
	
	UIBarButtonItem *t_rightItem = [[UIBarButtonItem alloc] initWithCustomView:t_rightView];
//	[t_rightView release];
	self.navigationItem.rightBarButtonItem = t_rightItem;
//	[t_rightItem release];
    
    [self setTitle:[setting sharedSetting].currentCity];
	
    [self getDate];
}
-(void)getDate{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
	NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
	NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
	
	[t_h setObject:@"airIndex" forKey:@"pt"];
	[t_h setObject:[setting sharedSetting].app forKey:@"p"];
	[t_h setObject:@"1" forKey:@"dt"];
	[t_h setObject:@"0" forKey:@"n"];
    NSString *city=[setting sharedSetting].currentCity;
    [t_b setObject:city forKey:@"city"];
	
	[t_dic setObject:t_h forKey:@"h"];
	[t_dic setObject:t_b forKey:@"b"];
    
//    NSLog(@"%@",t_dic);
	
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        NSLog(@"%@",returnData);
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        NSDictionary *t_airIndex=[t_b objectForKey:@"airIndex"];
        if (t_b!=nil) {
            
            airIndexModle *air_modle=[[airIndexModle alloc]init];
            air_modle.so2=[t_airIndex objectForKey:@"so2"];
            air_modle.updateTime=[t_airIndex objectForKey:@"updateTime"];
            air_modle.o3=[t_airIndex objectForKey:@"o3"];
            air_modle.health_advice=[t_airIndex objectForKey:@"health_advice"];
            air_modle.pm2_5=[t_airIndex objectForKey:@"pm2_5"];
            air_modle.impact=[t_airIndex objectForKey:@"impact"];
            air_modle.co=[t_airIndex objectForKey:@"co"];
            air_modle.area=[t_airIndex objectForKey:@"area"];
            air_modle.no2=[t_airIndex objectForKey:@"no2"];
            air_modle.aqi=[t_airIndex objectForKey:@"aqi"];
            air_modle.quality=[t_airIndex objectForKey:@"quality"];
            air_modle.pm10=[t_airIndex objectForKey:@"pm10"];
            air_modle.o3_8h=[t_airIndex objectForKey:@"o3_8h"];
            air_modle.ranking=[t_airIndex objectForKey:@"ranking"];
            
            NSString *t_city = [[[NSUserDefaults standardUserDefaults] objectForKey:@"crtCity"] objectForKey:@"city"];
            self.shareStr=[NSString stringWithFormat:@"%@空气质量指数%@,%@,%@来自@知天气",t_city,air_modle.aqi,[t_airIndex objectForKey:@"quality"],air_modle.health_advice];

            [self initview:air_modle];
            
        }
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        [ShareFun alertNotice:@"知天气" withMSG:@"请检查网络连接！" cancleButtonTitle:@"确定" otherButtonTitle:nil];
        
    } withCache:YES];
	//[[ZYNetworkHelper shareZYNetworkHelper] requestDataFromURL:URL_SERVER withParams:t_dic withHelperDelegate:self withFlag:1 withCache:NO];

}
-(void)initview:(airIndexModle*)air_modle{
    UIScrollView *bgscrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgscrollview.backgroundColor=[UIColor clearColor];
 //   bgscrollview.contentSize=CGSizeMake(mywidth, myheigth);
    [self.view addSubview:bgscrollview];
//    [bgscrollview release];
    
    //空气质量指数
    UILabel *t_airlable=[[UILabel alloc]initWithFrame:CGRectMake(5,0,200,22)];
    [t_airlable setTextAlignment:NSTextAlignmentCenter];
    [t_airlable setBackgroundColor:[UIColor clearColor]];
    [t_airlable setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [t_airlable setTextColor:[UIColor whiteColor]];
    t_airlable.shadowColor = [UIColor blackColor];
    t_airlable.text=@"空气质量指数（AQI）:";
    [bgscrollview addSubview:t_airlable];
    
    UILabel *air_lable=[[UILabel alloc]initWithFrame:CGRectMake(0,25,100,55)];
    [air_lable setTextAlignment:NSTextAlignmentCenter];
    [air_lable setBackgroundColor:[UIColor clearColor]];
    [air_lable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:40]];
    [air_lable setTextColor:[UIColor whiteColor]];
    air_lable.shadowColor = [UIColor blackColor];
    air_lable.text=air_modle.aqi;
    [bgscrollview addSubview:air_lable];
    
    //更新时间
    UILabel *time_lable=[[UILabel alloc]initWithFrame:CGRectMake(80,80,kScreenWidth-80,20)];
    [time_lable setTextAlignment:NSTextAlignmentCenter];
    [time_lable setBackgroundColor:[UIColor clearColor]];
    [time_lable setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [time_lable setTextColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0]];
//    time_lable.shadowColor = [UIColor blackColor];
    time_lable.text=[NSString stringWithFormat:@"数据更新时间：%@",air_modle.updateTime];
    [bgscrollview addSubview:time_lable];

    //背景白条
    UIImageView *bgimage1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"指数白色底.png"]];
    bgimage1.frame=CGRectMake(0, 100, kScreenWidth, 40);
    bgimage1.alpha=0.5;
    [bgscrollview addSubview:bgimage1];
//    [bgimage1 release];
    
        
    UIImageView *bgimage2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"指数白色底.png"]];
    bgimage2.frame=CGRectMake(0, 190, kScreenWidth, 100);
    if (iPhone5) {
        bgimage2.frame=CGRectMake(0, 210, kScreenWidth, 100);
    }
    
    bgimage2.alpha=0.5;
    [bgscrollview addSubview:bgimage2];
//    [bgimage2 release];
    UIView *bgview11=[[UIView alloc]initWithFrame:bgimage2.frame];
    [bgscrollview addSubview:bgview11];
//    [bgview11 release];
    
    int juli=0;
    UIImageView *bgimage3=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"指数白色底.png"]];
    bgimage3.frame=CGRectMake(0, 300-juli, kScreenWidth, 100);
    if (iPhone5) {
        bgimage3.frame=CGRectMake(0, 300-juli+40, kScreenWidth, 100);
    }
    bgimage3.alpha=0.5;
    [bgscrollview addSubview:bgimage3];
//    [bgimage3 release];
    
    UIView *bgview22=[[UIView alloc]initWithFrame:bgimage3.frame];
    [bgscrollview addSubview:bgview22];
//    [bgview22 release];
    
    //空气质量
    UILabel *imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100,46*2,40)];
    int air_flag=0;
    int air=[air_modle.aqi intValue];
    if (air>0 &&air<51) {
        air_flag=0;
    }else
    if (air>50 && air <101) {
        air_flag=1;
    }else
    if (air>100 && air<151) {
        air_flag=2;
    }else
    if (air>150 && air<201) {
        air_flag=3;
    }else
    if (air>200 && air<301) {
        air_flag=4;
    }else
    if (air>300) {
        air_flag=5;
    }
    switch (air_flag) {
        case 0:
            imageLabel.backgroundColor = COLORGRADE0;
            break;
        case 1:
            imageLabel.backgroundColor = COLORGRADE1;
            break;
        case 2:
            imageLabel.backgroundColor = COLORGRADE2;
            break;
        case 3:
            imageLabel.backgroundColor = COLORGRADE3;
            break;
        case 4:
            imageLabel.backgroundColor = COLORGRADE4;
            break;
        case 5:
            imageLabel.backgroundColor = COLORGRADE5;
            break;
        default:
            break;
    }
    [imageLabel setTextAlignment:NSTextAlignmentCenter];
    [imageLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [imageLabel setTextColor:[UIColor grayColor]];
    imageLabel.text=air_modle.quality;
    [bgscrollview addSubview:imageLabel];
//    [imageLabel release];
    
    //排行
    UILabel *rank_lable=[[UILabel alloc]initWithFrame:CGRectMake(46*2,110,kScreenWidth-46*2,20)];
    [rank_lable setTextAlignment:NSTextAlignmentCenter];
    [rank_lable setBackgroundColor:[UIColor clearColor]];
    [rank_lable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [rank_lable setTextColor:[UIColor whiteColor]];
    rank_lable.shadowColor = [UIColor blackColor];
    int rank=[air_modle.ranking intValue];
    rank_lable.text=[NSString stringWithFormat:@"空气质量优于%d个城市",rank];
    [bgscrollview addSubview:rank_lable];
//    [rank_lable release];
    
    UIButton *rank_button=[UIButton buttonWithType:UIButtonTypeCustom];
    rank_button.frame=CGRectMake(80, 115, kScreenWidth-80, 10);
   // [rank_button setBackgroundImage:[UIImage imageNamed:@"符号2.png"] forState:UIControlStateNormal];
    [rank_button addTarget:self  action:@selector(cityRank:) forControlEvents:UIControlEventTouchUpInside];
    [bgscrollview addSubview:rank_button];
    UIImageView *rankimage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"符号2.png"]];
    rankimage.frame=CGRectMake(kScreenWidth-30, 110, 25, 20);
    [bgscrollview addSubview:rankimage];
//    [rankimage release];
    
    
    //空气指数
    for (int i=0; i<7; i++) {
        UIImageView *bgimage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"指数白色底.png"]];
        bgimage.frame=CGRectMake(i*46, 141, 45, 40);
        bgimage.alpha=0.5;
        [bgscrollview addSubview:bgimage];
//        [bgimage release];
        
        NSString *t_label=nil;
        NSString *text_lable=nil;
        switch (i) {
            case 0:
                t_label=@"PM2.5";
                text_lable=air_modle.pm2_5;
                break;
            case 1:
                t_label=@"PM10";
                text_lable=air_modle.pm10;
                break;
            case 2:
                t_label=@"CO";
                text_lable=air_modle.co;
                break;
            case 3:
                t_label=@"NO2";
                text_lable=air_modle.no2;
                break;
            case 4:
                t_label=@"O3_1h";
                text_lable=air_modle.o3;
                break;
            case 5:
                t_label=@"O3_8h";
                text_lable=air_modle.o3_8h;
                break;
            case 6:
                t_label=@"SO2";
                text_lable=air_modle.so2;
                break;
                
            default:
                break;
        }
        UILabel *kqzl_label=[[UILabel alloc]initWithFrame:CGRectMake(i*46,141,45,20)];
        [kqzl_label setTextAlignment:NSTextAlignmentCenter];
        [kqzl_label setBackgroundColor:[UIColor clearColor]];
        [kqzl_label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        [kqzl_label setTextColor:[UIColor whiteColor]];
        kqzl_label.shadowColor = [UIColor blackColor];
        kqzl_label.text=t_label;
        [bgscrollview addSubview:kqzl_label];
//        [kqzl_label release];
        
        UILabel *t_kqzllabel=[[UILabel alloc]initWithFrame:CGRectMake(i*46,161,45,20)];
        [t_kqzllabel setTextAlignment:NSTextAlignmentCenter];
        [t_kqzllabel setBackgroundColor:[UIColor clearColor]];
        [t_kqzllabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        [t_kqzllabel setTextColor:[UIColor whiteColor]];
        t_kqzllabel.shadowColor = [UIColor blackColor];
        t_kqzllabel.text=text_lable;
        [bgscrollview addSubview:t_kqzllabel];
//        [t_kqzllabel release];

    }
    //影响分析
    UIImageView *yxfx=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"影响分析.png"]];
    yxfx.frame=CGRectMake(2, 50-76*0.5, 46*2, 76);
    [bgview11 addSubview:yxfx];
//    [yxfx release];
    
    UILabel *yxfx_lable=[[UILabel alloc]initWithFrame:CGRectMake(100,0,kScreenWidth-100,100)];
    [yxfx_lable setTextAlignment:NSTextAlignmentCenter];
    [yxfx_lable setBackgroundColor:[UIColor clearColor]];
    [yxfx_lable setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [yxfx_lable setTextColor:[UIColor whiteColor]];
  //  yxfx_lable.shadowColor = [UIColor blackColor];
    yxfx_lable.lineBreakMode = NSLineBreakByWordWrapping;
    yxfx_lable.numberOfLines = 0;
    yxfx_lable.text= air_modle.impact;
    [bgview11 addSubview:yxfx_lable];
//    [yxfx_lable release];

    
       //健康建议
    UIImageView *jkjy=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"健康建议.png"]];
    jkjy.frame=CGRectMake(2, 50-76*0.5, 46*2, 76);
    [bgview22 addSubview:jkjy];
//    [jkjy release];
    
    UILabel *jkjy_lable=[[UILabel alloc]initWithFrame:CGRectMake(100,0,kScreenWidth-100,100)];
    [jkjy_lable setTextAlignment:NSTextAlignmentCenter];
    [jkjy_lable setBackgroundColor:[UIColor clearColor]];
    [jkjy_lable setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [jkjy_lable setTextColor:[UIColor whiteColor]];
  //  jkjy_lable.shadowColor = [UIColor blackColor];
    jkjy_lable.lineBreakMode = NSLineBreakByWordWrapping;
    jkjy_lable.numberOfLines = 0;
    jkjy_lable.text=air_modle.health_advice;
    [bgview22 addSubview:jkjy_lable];
//    [jkjy_lable release];
    
    
    
    //数据来源
    UILabel *source_lable=[[UILabel alloc]initWithFrame:CGRectMake(160,kScreenHeitht-80,kScreenWidth-160,20)];
    [source_lable setTextAlignment:NSTextAlignmentCenter];
    [source_lable setBackgroundColor:[UIColor clearColor]];
    [source_lable setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [source_lable setTextColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0]];
    source_lable.shadowColor = [UIColor blackColor];
    source_lable.text=@"数据来源国家环境保护部网站";
    [bgscrollview addSubview:source_lable];
//    [source_lable release];

    
}

#pragma mark action
- (void) backAction
{

}

- (void) shareAir:(id)sender
{
	UIImage *t_shareImage = [ShareFun captureScreen];
	
	NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weiboShare.png"];
	if ([UIImagePNGRepresentation(t_shareImage) writeToFile:shareImagePath atomically:YES])
		NSLog(@">>write ok");
	
 //   NSLog(@"%@", self.shareStr);
	
	//[ShareFun actionNoticeWithView:self.view withContent:self.shareStr];
}
- (void) cityRank:(id)sender{
    AirRank *ar=[[AirRank alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:ar animated:!kSystemVersionMore7];
    [ar setTitle:@"空气质量-排行榜"];
//    [ar setmenuflag:0];//返回时 无菜单
//    [ar release];
}


//-(void) didFailed:(NSInteger)flag
//{
//	//[MBProgressHUD hideHUDForView:self.view animated:NO];
//	if (flag == 1) {
//		[ShareFun alertNotice:@"知天气" withMSG:@"请检查网络连接！" cancleButtonTitle:@"确定" otherButtonTitle:nil];
//			}
//}
//
//
//- (void) didFinishDownloadData:(NSDictionary *)dic withFlag:(NSInteger)flag
//{
//	if (flag==1){
//        
//        NSDictionary *t_b = [dic objectForKey:@"b"];
//        NSDictionary *t_airIndex=[t_b objectForKey:@"airIndex"];
//        if (t_b!=nil) {
//            
//            airIndexModle *air_modle=[[airIndexModle alloc]init];
//            air_modle.so2=[t_airIndex objectForKey:@"so2"];
//            air_modle.updateTime=[t_airIndex objectForKey:@"updateTime"];
//            air_modle.o3=[t_airIndex objectForKey:@"o3"];
//            air_modle.health_advice=[t_airIndex objectForKey:@"health_advice"];
//            air_modle.pm2_5=[t_airIndex objectForKey:@"pm2_5"];
//            air_modle.impact=[t_airIndex objectForKey:@"impact"];
//            air_modle.co=[t_airIndex objectForKey:@"co"];
//            air_modle.area=[t_airIndex objectForKey:@"area"];
//            air_modle.no2=[t_airIndex objectForKey:@"no2"];
//            air_modle.aqi=[t_airIndex objectForKey:@"aqi"];
//            air_modle.quality=[t_airIndex objectForKey:@"quality"];
//            air_modle.pm10=[t_airIndex objectForKey:@"pm10"];
//            air_modle.o3_8h=[t_airIndex objectForKey:@"o3_8h"];
//            air_modle.ranking=[t_airIndex objectForKey:@"ranking"];
//            
//            NSString *t_city = [[[NSUserDefaults standardUserDefaults] objectForKey:@"crtCity"] objectForKey:@"city"];
//            self.shareStr=[NSString stringWithFormat:@"%@空气质量指数%@,%@,%@来自@知天气",t_city,air_modle.aqi,[t_airIndex objectForKey:@"quality"],air_modle.health_advice];
//          //  NSLog(@"%@",shareStr);
//            [self initview:air_modle];
////            [air_modle release];
//            
//        }
//    }
//    
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
