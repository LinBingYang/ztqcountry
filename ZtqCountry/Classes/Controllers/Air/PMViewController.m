//
//  PMViewController.m
//  ZtqNew
//
//  Created by linxg on 13-8-8.
//
//

#import "PMViewController.h"
#import "ShareFun.h"
#import "ShareFunction.h"
//#import "NetWorkCenter.h"
#import "UIImage+Blur.h"
#import "AirRank.h"
@interface PMViewController ()

@end

@implementation PMViewController
@synthesize m_cityArray,m_cityValue,dateType,m_city,areaid;


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
    m_cityArray=[[NSMutableArray alloc] initWithCapacity:4];
    m_cityValue=[[NSMutableArray alloc] initWithCapacity:4];
    dateType=@"1";
    
    self.view.backgroundColor = [UIColor clearColor];
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
    self.navigationBarBg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navigationBarBg];
    
    UIButton * leftBut = [[UIButton alloc] initWithFrame:CGRectMake(15, 7+place, 30, 30)];
    [leftBut setImage:[UIImage imageNamed:@"cssz返回.png"] forState:UIControlStateNormal];
    [leftBut setImage:[UIImage imageNamed:@"cssz返回点击.png"] forState:UIControlStateHighlighted];
    [leftBut setBackgroundColor:[UIColor clearColor]];
    
    [leftBut addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarBg addSubview:leftBut];
    
    UIButton * rightbut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-40, 7+place, 30, 25)];
    [rightbut setImage:[UIImage imageNamed:@"刷新.png"] forState:UIControlStateNormal];
//    [rightbut setImage:[UIImage imageNamed:@"cssz返回点击.png"] forState:UIControlStateHighlighted];
    [rightbut setBackgroundColor:[UIColor clearColor]];
    
    [rightbut addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarBg addSubview:rightbut];
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 7+place, kScreenWidth-120, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text =@"空气质量";
    [self.navigationBarBg addSubview:titleLab];
    
    
    UIScrollView *bgscrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, [UIScreen mainScreen].bounds.size.height)] ;
    bgscrollview.showsHorizontalScrollIndicator=YES;
    bgscrollview.showsVerticalScrollIndicator=YES;
    bgscrollview.backgroundColor=[UIColor clearColor];
    bgscrollview.contentSize=CGSizeMake(kScreenWidth, 680);
    [self.view addSubview:bgscrollview];
    //    [bgscrollview release];
    
    _imageLabelWidth = 40;
    
    //城市
    city_button=[ShareFunction Button:nil Target:self Sel:@selector(buttonclick:) Img1:@"kqzl城市.png" Img2:nil];
    city_button.frame=CGRectMake(10, 10, 120, 30);
    [city_button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [city_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgscrollview addSubview:city_button];
    
    //    UILabel *t_label1=[ShareFunction LabelWithText:@"当前监测数据" withFrame:CGRectMake(135,17,120,20) withFontSize:14];
    //    [t_label1 setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    //    [bgscrollview addSubview:t_label1];
    
    
    //排行榜
    NSString *numstr=[NSString stringWithFormat:@"优于全国%d个城市>>",self.youyunum];
    UIButton *arnkbtn=[[UIButton alloc]initWithFrame:CGRectMake(140, 10, 170, 30)];
    [arnkbtn setTitle:numstr forState:UIControlStateNormal];
    arnkbtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [arnkbtn addTarget:self action:@selector(arnkBtn) forControlEvents:UIControlEventTouchUpInside];
    //    [arnkbtn setBackgroundImage:[UIImage imageNamed:@"kqzl城市.png"] forState:UIControlStateNormal];
    [bgscrollview addSubview:arnkbtn];
    
    //更新时间
    t_updateTime=[ShareFunction LabelWithText:nil withFrame:CGRectMake(160, 50, 160, 15) withFontSize:12];
    [t_updateTime setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    t_updateTime.textColor=[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:0.8];
    t_updateTime.textAlignment=NSTextAlignmentCenter;
    [bgscrollview addSubview:t_updateTime];
    
    UIImageView *ranimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 130, 50, 50)];
    ranimg.image=[UIImage imageNamed:@"圈_06.png"];
    [bgscrollview addSubview:ranimg];
    
    UILabel *t_label2=[ShareFunction LabelWithText:@"AQI" withFrame:CGRectMake(10,0,40,30) withFontSize:14];
    [t_label2 setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [ranimg addSubview:t_label2];
    //    [t_label2 release];
    
    //空气质量描述
    prompt = [[UIImageView alloc] initWithFrame:CGRectMake(20, 78, 87, 35)];
	[prompt setImage:[UIImage imageNamed:@"kqzl污染程度.png"]];
    prompt.alpha = 0.5;
	[bgscrollview addSubview:prompt];
    
    t_quality=[ShareFunction LabelWithText:nil withFrame:CGRectMake(0,-5,87,35) withFontSize:16];
    [t_quality setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [t_quality setTextAlignment:NSTextAlignmentCenter];
    [prompt addSubview:t_quality];
    
    //空气质量颜色块
    for (int i = 0; i < 6; i++) {
		UILabel *imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(35+i*_imageLabelWidth, 114,_imageLabelWidth-1,10)];
		switch (i) {
			case 0:
				imageLabel.backgroundColor = [UIColor colorWithRed:101.0/255.0f green:240.0/255.0f blue:2.0/255.0f alpha:1.0f];
				break;
			case 1:
				imageLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:28.0/255.0f alpha:1.0f];
				break;
			case 2:
				imageLabel.backgroundColor = [UIColor colorWithRed:253.0/255.0f green:164.0/255.0f blue:10.0/255.0f alpha:1.0f];
				break;
			case 3:
				imageLabel.backgroundColor = [UIColor colorWithRed:239.0/255.0f green:8.0/255.0f blue:2.0/255.0f alpha:1.0f];
				break;
			case 4:
				imageLabel.backgroundColor = [UIColor colorWithRed:162.0/255.0f green:0.0/255.0f blue:91.0/255.0f alpha:1.0f];
				break;
			case 5:
				imageLabel.backgroundColor = [UIColor colorWithRed:139.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:1.0f];
				break;
			default:
				break;
		}
		[bgscrollview addSubview:imageLabel];
        //		[imageLabel release];
    }
    
    //各项数值
    t_aqi=[ShareFunction LabelWithText:@"--" withFrame:CGRectMake(0, 20, 50, 30) withFontSize:14];
    
    [t_aqi setFont:[UIFont fontWithName:@"Helvetia" size:14]];
    t_aqi.textAlignment = NSTextAlignmentCenter;
    
    t_health=[[UILabel alloc]initWithFrame:CGRectMake(55, 120, 250, 60)];
//    health.text=@"健康提示:各类人群可自由活动。";
    t_health.textColor=[UIColor whiteColor];
    t_health.numberOfLines=0;
    t_health.backgroundColor=[UIColor clearColor];
    t_health.font=[UIFont systemFontOfSize:14];
    [bgscrollview addSubview:t_health];
    t_pm25=[ShareFunction LabelWithText:@"--" withFrame:CGRectMake(40, 180, 280, 20) withFontSize:12];
    //    UILabel *mpm25=[ShareFunction LabelWithText:@"--" withFrame:CGRectMake(70, 130, 200, 20) withFontSize:12];
    //    mpm25.text=@"μg/m³    PM2.5细颗粒物";
    //    [bgscrollview addSubview:mpm25];
    //    [mpm25 release];
    
    t_pm10=[ShareFunction LabelWithText:@"--" withFrame:CGRectMake(40, 180+25*1, 280, 20) withFontSize:12];
    //    UILabel *mpm10=[ShareFunction LabelWithText:@"--" withFrame:CGRectMake(70, 130+25*1, 200, 20) withFontSize:12];
    //    mpm10.text=@"μg/m³    PM10可吸入颗粒物";
    //    [bgscrollview addSubview:mpm10];
    //    [mpm10 release];
    
    t_co=[ShareFunction LabelWithText:@"--" withFrame:CGRectMake(40, 180+25*2, 280, 20) withFontSize:12];
    //    UILabel *mco=[ShareFunction LabelWithText:@"--" withFrame:CGRectMake(70, 130+25*2, 200, 20) withFontSize:12];
    //    mco.text=@"μg/m³    CO一氧化碳";
    //    [bgscrollview addSubview:mco];
    //    [mco release];
    
    t_no2=[ShareFunction LabelWithText:@"--" withFrame:CGRectMake(40, 180+25*3, 280, 20) withFontSize:12];
    //    UILabel *mo2=[ShareFunction LabelWithText:@"--" withFrame:CGRectMake(70, 130+25*3, 200, 20) withFontSize:12];
    //    mo2.text=@"μg/m³    NO2二氧化氮";
    //    [bgscrollview addSubview:mo2];
    //    [mo2 release];
    
    t_o3=[ShareFunction LabelWithText:@"--" withFrame:CGRectMake(40, 180+25*4, 280, 20) withFontSize:12];
    //    UILabel *mo3=[ShareFunction LabelWithText:@"--" withFrame:CGRectMake(70, 130+25*4, 200, 20) withFontSize:12];
    //    mo3.text=@"μg/m³    O3_1h臭氧1小时平均";
    //    [bgscrollview addSubview:mo3];
    //    [mo3 release];
    
    t_o38h=[ShareFunction LabelWithText:@"--" withFrame:CGRectMake(40, 180+25*5, 280, 20) withFontSize:12];
    //    UILabel *mo38h=[ShareFunction LabelWithText:@"--" withFrame:CGRectMake(70, 130+25*5, 200, 20) withFontSize:12];
    //    mo38h.text=@"μg/m³    O3_8h臭氧8小时平均";
    //    [bgscrollview addSubview:mo38h];
    //    [mo38h release];
    
    t_so2=[ShareFunction LabelWithText:@"--" withFrame:CGRectMake(40, 180+25*6, 280, 20) withFontSize:12];
    //    UILabel *mso2=[ShareFunction LabelWithText:@"--" withFrame:CGRectMake(70, 130+25*6, 200, 20) withFontSize:12];
    //    mso2.text=@"μg/m³    SO2二氧化硫";
    //    [bgscrollview addSubview:mso2];
    //    [mso2 release];
    
    
    [ranimg addSubview:t_aqi];
    [bgscrollview addSubview:t_pm25];
    [bgscrollview addSubview:t_pm10];
    [bgscrollview addSubview:t_co];
    [bgscrollview addSubview:t_no2];
    [bgscrollview addSubview:t_o3];
    [bgscrollview addSubview:t_o38h];
    [bgscrollview addSubview:t_so2];
    
    UIImageView *sevenimage=[[UIImageView alloc]initWithFrame:CGRectMake(25, 180, 1, 165)];
    [sevenimage setImage:[UIImage imageNamed:@"AQI竖条.png"]];
    [bgscrollview addSubview:sevenimage];
    //    [sevenimage release];
    
    UILabel *t_label3=[ShareFunction LabelWithText:@"空气质量指数（AQI）24小时趋势图" withFrame:CGRectMake(10,360,300,30) withFontSize:16];
    [t_label3 setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [bgscrollview addSubview:t_label3];
    //    [t_label3 release];
    
    //图表
    _pmView =[[PMView alloc] initWithFrame:CGRectMake(0, 375, self.view.width, 250)];
	[bgscrollview addSubview:_pmView];
    
    [self getDataWithcity:self.m_city type:self.dateType];
}
- (void) viewWillAppear:(BOOL)animated
{
    
	[super viewWillAppear:animated];
	m_gdBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, [UIScreen mainScreen].bounds.size.height)];
    //	[m_gdBg setImage:[UIImage imageNamed:@"BG"]];
    [self getBlureImage];
    UIWindow *windows = [[ShareFun shareAppDelegate] window];
	[windows.rootViewController.view insertSubview:m_gdBg atIndex:0];
}
- (void) viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[m_gdBg removeFromSuperview];
}
-(void)arnkBtn{
    AirRank *air=[[AirRank alloc]init];
    [self.navigationController pushViewController:air animated:NO];
}
-(void)getBlureImage
{
    
    NSString *bgimgname=[[NSUserDefaults standardUserDefaults]objectForKey:@"weatherBG"];
    UIImage * image =[UIImage imageNamed:bgimgname];
    
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, CGRectMake(0, 0, kScreenWidth, kScreenHeitht));
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    UIImage * blurImage = [newImage blurredImage:0.5];
    m_gdBg.image = blurImage;
}
- (void)leftBtn:(id)sender{
    if (self.sign==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:NO];
    }

}
-(void)rightBtn:(id)sender{
    [self getDataWithcity:self.m_city type:self.dateType];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark action
- (void) backAction
{
	//[super backAction];
}
-(void)buttonclick:(id)sender{
    [self cityList];
}

-(void)viewinint:(airIndexModle*)t_aim withpmArray:(NSArray*)t_array{
    t_updateTime.text=t_aim.updateTime;
    t_aqi.text=t_aim.aqi;
    t_quality.text=t_aim.quality;
    t_health.text=t_aim.health_advice;
    t_pm25.text=[NSString stringWithFormat:@"PM2.5        细微颗粒物               %@            μg/m³",t_aim.pm2_5];
    t_pm10.text=[NSString stringWithFormat:@"PM10        可吸入细微颗粒物     %@            μg/m³",t_aim.pm10];
    t_co.text=[NSString stringWithFormat:@"CO            一氧化碳                 %@         μg/m³",t_aim.co];
    t_no2.text=[NSString stringWithFormat:@"NO2          二氧化氮                    %@           μg/m³",t_aim.no2];
    t_o3.text=[NSString stringWithFormat:@"O3_1h       臭氧1小时平均          %@           μg/m³",t_aim.o3];
    t_o38h.text=[NSString stringWithFormat:@"O3_8h       臭氧8小时平均          %@           μg/m³",t_aim.o3_8h];
    t_so2.text=[NSString stringWithFormat:@"SO2           二氧化硫                    %@            μg/m³",t_aim.so2];
    
    float per;
	CGPoint point;
	point.y =prompt.frame.origin.y+prompt.frame.size.height/2;
	int pm25 =[t_aim.aqi intValue];
    if (pm25>500) {
        pm25=500;
    }
	if (0<= pm25 && pm25<= 50) {
		per = _imageLabelWidth/50;
		point.x = 33+per*pm25;
	}else if (50 < pm25 && pm25<= 100 ) {
		per = _imageLabelWidth/50;
		point.x = 33+_imageLabelWidth+per*(pm25-50);
	}else if (100 < pm25 && pm25<= 150) {
		per = _imageLabelWidth/50;
		point.x = 33+_imageLabelWidth*2+per*(pm25-100);
	}else if (150 < pm25 && pm25<= 200) {
		per = _imageLabelWidth/50;
		point.x = 33+_imageLabelWidth*3+per*(pm25-150);
	}else if (200 < pm25 && pm25<= 300) {
		per = _imageLabelWidth/100;
		point.x = 33+_imageLabelWidth*4+per*(pm25-200);
	}else if (300 < pm25 && pm25<= 500) {
   		per = _imageLabelWidth/200;
		point.x = 33+_imageLabelWidth*5+per*(pm25-300);
	}
    NSLog(@"%f#####%f",point.x,point.y);
	[prompt setCenter:point];
    
    [_pmView setArray:t_array];
}
#pragma mark 监测点列表
-(void)cityList{
    AirDialog *cityDialog=[[AirDialog alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    [cityDialog initWithArray:m_cityArray Value:m_cityValue labelString:nil flag:dialog_air];
    [self.view addSubview:cityDialog];
    cityDialog.delegate=self;
//    [cityDialog release];
    
}
-(void)readXML{
    m_allCity=m_treeNodeAllCity;
    for (int i = 0; i < [m_allCity.children count]; i ++)
    {
        TreeNode *t_node = [m_allCity.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:1];
        t_node_child = [t_node.children objectAtIndex:2];
        NSString *t_name = t_node_child.leafvalue;
        if ([self.m_city isEqualToString:t_name])
        {
            //----------------------------------------------------
            t_node_child = [t_node.children objectAtIndex:5];
            TreeNode *t_node_child1 = [t_node.children objectAtIndex:0];
            NSString *Id = t_node_child1.leafvalue;
            [[NSUserDefaults standardUserDefaults]setObject:Id forKey:@"id"];
        }
    }
    
    
}
#pragma mark network
-(void)getDataWithcity:(NSString*)t_city type:(NSString*)t_type{
    
    self.dateType=t_type;
    self.m_city=t_city;
 //   [city_button setTitle:[NSString stringWithFormat:@"%@总体",t_city] forState:UIControlStateNormal];
    [self readXML];
    NSString *ID=[[NSUserDefaults standardUserDefaults]objectForKey:@"id"];
    if ([t_type isEqualToString:@"2"]) {
        ID=t_city;
    }
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
	NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
	NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
	NSMutableDictionary *air = [NSMutableDictionary dictionaryWithCapacity:4];
     NSMutableDictionary *airInfoSimple = [NSMutableDictionary dictionaryWithCapacity:4];
	[t_h setObject:[setting sharedSetting].app forKey:@"p"];

    
    [air setObject:dateType forKey:@"type"];
    [air setObject:ID forKey:@"area"];
    [airInfoSimple setObject:dateType forKey:@"type"];
    [airInfoSimple setObject:ID forKey:@"area"];
	[t_b setObject:air forKey:@"airInfo"];
    [t_b setObject:airInfoSimple forKey:@"airInfoSimple"];
	[t_dic setObject:t_h forKey:@"h"];
	[t_dic setObject:t_b forKey:@"b"];
    
//    NSLog(@"%@",t_dic);
	
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        NSLog(@"%@",returnData);
        NSDictionary *t_b=[returnData objectForKey:@"b"];
        NSDictionary *t_airsimple=[t_b objectForKey:@"airInfoSimple"];
        NSDictionary *t_airInfo = [t_b objectForKey:@"airInfo"];
        
        if (t_airInfo!=nil) {
            //  NSLog(@"%@",t_airInfo);
            //各项数据
            
            NSString *t_area;
            if ([self.dateType isEqualToString:@"1"]) {
                t_area=[NSString stringWithFormat:@"%@总体",[t_airInfo objectForKey:@"area"]];
            }else{
                t_area=[t_airInfo objectForKey:@"area"];
            }
            
            [city_button setTitle:t_area forState:UIControlStateNormal];
           
            //  [self setTitle:[NSString stringWithFormat:@"空气质量-%@",t_area]];
//            self.titleLab.textColor=[UIColor whiteColor];
//            self.titleLab.text=[NSString stringWithFormat:@"空气质量-%@",t_area];
            
            airIndexModle *aim=[[airIndexModle alloc]init];
            
            aim.updateTime=[NSString stringWithFormat:@"%@更新",[t_airInfo objectForKey:@"updateTime"]];
            aim.aqi=[t_airInfo objectForKey:@"aqi"];
            aim.quality=[t_airInfo objectForKey:@"quality"];
            aim.pm2_5=[t_airInfo objectForKey:@"pm2_5"];
            aim.pm10=[t_airInfo objectForKey:@"pm10"];
            aim.no2=[t_airInfo objectForKey:@"no2"];
            aim.co=[t_airInfo objectForKey:@"co"];
            aim.o3=[t_airInfo objectForKey:@"o3"];
            aim.o3_8h=[t_airInfo objectForKey:@"o3_8h"];
            aim.so2=[t_airInfo objectForKey:@"so2"];
            aim.health_advice=[t_airsimple objectForKey:@"health_advice"];
            
            //图表数据
            NSArray *t_aqiList=[t_airInfo objectForKey:@"AQIList"];
            [self viewinint:aim withpmArray:t_aqiList];
            
            //监测点数据
            NSArray *t_positionList=[t_airInfo objectForKey:@"positionList"];
            if (t_positionList!=nil) {
                
                if ([self.dateType isEqualToString:@"1"]) {
                    [m_cityArray removeAllObjects];
                    [m_cityValue removeAllObjects];
                    [m_cityArray addObject:[NSString stringWithFormat:@"%@总体",m_city]];
                    [m_cityValue addObject:m_city];
                    
                    for (int i=0; i<t_positionList.count; i++) {
                        [m_cityArray addObject:[[t_positionList objectAtIndex:i]objectForKey:@"posName"] ];
                        [m_cityValue addObject:[[t_positionList objectAtIndex:i]objectForKey:@"station_code"] ];
                        
                    }
                    
                }
            }
            //      NSLog(@"%@,%@",m_cityArray,m_cityValue);
            
        }

        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];

    

    
}
#pragma mark AirDialogDelegat
-(void)selectTable:(NSInteger)row type:(dialogType)t_type{
    if (t_type==dialog_city) {
        ;
    }else{
        if (row==0) {
            [self getDataWithcity:[m_cityValue objectAtIndex:row] type:@"1"];
        }else{
            [self getDataWithcity:[m_cityValue objectAtIndex:row] type:@"2"];
        }
    
    }
}
@end
