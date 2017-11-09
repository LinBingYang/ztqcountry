//
//  AirRankProvinceVC.m
//  ZtqCountry
//
//  Created by 派克斯科技 on 16/7/29.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "AirRankProvinceVC.h"
#import "ShareFun.h"
#import "rankListModle.h"
#import "PMViewController.h"
#import "UIColor+ColorWithHexColor.h"
#import "AIrViewController.h"
@interface AirRankProvinceVC ()

@end


@implementation AirRankProvinceVC

@synthesize airDes,m_airValue,m_airArray,m_cityValue,m_cityArray,aqiCity,menuflag,m_areaid;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    showcolor=YES;
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    float place = 0;
    if(kSystemVersionMore7)
    {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
        place = 20;
    }
    self.barhight=place+44;
    
    self.navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    self.navigationBarBg.userInteractionEnabled = YES;
    self.navigationBarBg.image=[UIImage imageNamed:@"导航栏.png"];
    [self.view addSubview:self.navigationBarBg];
    
    UIImageView *leftimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7+place, 29, 29)];
    leftimg.image=[UIImage imageNamed:@"返回.png"];
    leftimg.userInteractionEnabled=YES;
    [self.navigationBarBg addSubview:leftimg];
    
    UIButton * leftBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 7+place, 60, 44+place)];
    [leftBut setBackgroundColor:[UIColor clearColor]];
    
    [leftBut addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarBg addSubview:leftBut];
    
    UIButton * rightbut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-40, 7+place, 30, 30)];
    [rightbut setImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
    //    [rightbut setImage:[UIImage imageNamed:@"cssz返回点击.png"] forState:UIControlStateHighlighted];
    [rightbut setBackgroundColor:[UIColor clearColor]];
    
    [rightbut addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarBg addSubview:rightbut];
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 7+place, kScreenWidth-120, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text =@"排行榜";
    [self.navigationBarBg addSubview:titleLab];
    
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50+self.barhight, kScreenWidth, [UIScreen mainScreen].bounds.size.height-100) style:UITableViewStylePlain];
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_tableView.backgroundColor = [UIColor clearColor];
    m_tableView.backgroundView=nil;
    m_tableView.autoresizesSubviews = YES;
    m_tableView.showsHorizontalScrollIndicator = NO;
    m_tableView.showsVerticalScrollIndicator = NO;
    
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    [self.view addSubview:m_tableView];
    
    
    
    
    m_tableData = [[NSMutableArray alloc] initWithCapacity:4];
    m_airArray=[[NSMutableArray alloc] initWithCapacity:4];
    m_airValue=[[NSMutableArray alloc] initWithCapacity:4];
    m_cityArray=[[NSMutableArray alloc] initWithCapacity:4];
    m_cityValue=[[NSMutableArray alloc] initWithCapacity:4];
    m_areaid=[[NSMutableArray alloc]initWithCapacity:4];
    
    //    rankType=@"AQI";
    airNamge=nil;
    orderflag=true;
    airDes=@"";
    aqiCity=[setting sharedSetting].currentCity;
    airNamge=self.rankType;
    [self myviewnint];
    
    [self getDate:self.rankType];
    
    UITapGestureRecognizer *longPress = [[UITapGestureRecognizer alloc]init];
    [longPress setNumberOfTapsRequired:1];
    longPress.delegate=self;
    [self.view addGestureRecognizer:longPress];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}


-(void)myviewnint{
    
    UILabel *pmlab=[[UILabel alloc]initWithFrame:CGRectMake(15, 10+self.barhight, 35, 25)];
    pmlab.text=@"排名";
    pmlab.font=[UIFont systemFontOfSize:15];
    pmlab.textColor=[UIColor blackColor];
    [self.view addSubview:pmlab];
    UIImageView *pmimg=[[UIImageView alloc]initWithFrame:CGRectMake(50, 10+self.barhight, 25, 25)];
    pmimg.image=[UIImage imageNamed:@"切换按钮"];
    [self.view addSubview:pmimg];
    order_button=[UIButton buttonWithType:UIButtonTypeCustom];
    order_button.frame=CGRectMake(15, 10+self.barhight, 60, 25);
    [order_button addTarget:self  action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    order_button.tag=3;
    [self.view addSubview:order_button];
    
    
    city_button=[UIButton buttonWithType:UIButtonTypeCustom];
    city_button.frame=CGRectMake(110,10+self.barhight, 90, 25);
    [city_button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [city_button setBackgroundImage:[UIImage imageNamed:@"指数 城市底框.png"] forState:UIControlStateNormal];
    [city_button setBackgroundImage:[UIImage imageNamed:@"城市底座.png"] forState:UIControlStateHighlighted];
    [city_button setBackgroundImage:[UIImage imageNamed:@"城市底座.png"] forState:UIControlStateSelected];
    [city_button setTitle:@"省份/城市" forState:UIControlStateNormal];
    [city_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [city_button addTarget:self  action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    city_button.tag=1;
    [self.view addSubview:city_button];
    
    kqzl_button=[UIButton buttonWithType:UIButtonTypeCustom];
    kqzl_button.frame=CGRectMake(kScreenWidth-75, 10+self.barhight, 60, 25);
    [kqzl_button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [kqzl_button setBackgroundImage:[UIImage imageNamed:@"指数 城市底框.png"] forState:UIControlStateNormal];
    [kqzl_button setBackgroundImage:[UIImage imageNamed:@"城市底座.png"] forState:UIControlStateHighlighted];
     [kqzl_button setBackgroundImage:[UIImage imageNamed:@"城市底座.png"] forState:UIControlStateSelected];
    [kqzl_button setTitle:airNamge forState:UIControlStateNormal];
    [kqzl_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [kqzl_button addTarget:self  action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    kqzl_button.tag=2;
    [self.view addSubview:kqzl_button];
    
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark action

- (void)leftBtn:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
-(void)rightBtn:(id)sender{
    [self shareAction];
}
-(void)shareAction{
    [self getShareContent];
    //分享
    UIImage *t_shareImage = [ShareFun captureScreen];
    self.shareimg=t_shareImage;
    NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weiboShare.png"];
    if ([UIImagePNGRepresentation(t_shareImage) writeToFile:shareImagePath atomically:YES])
        NSLog(@">>write ok");
    
    ShareSheet * sheet = [[ShareSheet alloc] initDefaultWithTitle:@"分享天气" withDelegate:self];
    [sheet show];
}
-(void)getShareContent{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    //    [gz_todaywt_inde setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    [gz_todaywt_inde setObject:@"AIR_QUALITY_RANK" forKey:@"keyword"];
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
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            //创建图片内容对象
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            //如果有缩略图，则设置缩略图
            [shareObject setShareImage:self.shareimg];
            
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
            
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
            Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
            
            
            if([messageClass canSendText])
                
            {
                
                MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
                controller.body = shareContent;
                controller.messageComposeDelegate = self;
                
                [self presentViewController:controller animated:YES completion:nil];
                
            }else
            {
                UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"不能发送，该设备不支持短信功能" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                [t_alertView show];
                
            }
            break;
        }
        case 3: {
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            //创建图片内容对象
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            //如果有缩略图，则设置缩略图
            [shareObject setShareImage:self.shareimg];
            
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Qzone messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    NSLog(@"************Share fail with error %@*********",error);
                }else{
                    NSLog(@"response data is %@",data);
                }
            }];
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
-(void)buttonclick:(id)sender{
    UIButton *bt=(UIButton*)sender;
    int tag=(int)bt.tag;
    switch (tag) {
        case 1:
            //城市列表
            [self cityList];
            break;
        case 2:
            //空气指数列表
            [self airList];
            break;
        case 3:
            //排序
            [self cityRank];
            break;
        case 4:
            //空气指数解释
            [self showAirDes];
            break;
        default:
            break;
    }
}
#pragma mark 城市列表
-(void)cityList{
    if (self.citydailog) {
        [self.citydailog removeFromSuperview];
        self.citydailog=nil;
        city_button.selected = NO;
    }else{
        city_button.selected = YES;
        kqzl_button.selected = NO;
        [self.airdialog removeFromSuperview];
        self.airdialog=nil;
        CityRankDialog *crd=[[CityRankDialog alloc]initWithFrame:CGRectMake(0,40+self.barhight, kScreenWidth, kScreenHeitht)];
        self.citydailog=crd;
        [crd setData:m_cityArray Value:m_cityValue];
        [self.view addSubview:crd];
        crd.delegate=self;
    }
    //    [crd release];
    
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[CityRankDialog class]]||[touch.view isKindOfClass:[AirDialog class]]) {
        if (self.airdialog) {
            [self.airdialog removeFromSuperview];
            self.airdialog=nil;
            kqzl_button.selected = NO;
        }
        if (self.citydailog) {
            [self.citydailog removeFromSuperview];
            self.citydailog=nil;
            city_button.selected = NO;
        }
    }
    
    return NO;
}
#pragma mark 空气指数列表
-(void)airList{
    if (self.airdialog) {
        [self.airdialog removeFromSuperview];
        self.airdialog=nil;
        kqzl_button.selected = NO;
    }else{
        city_button.selected = NO;
        kqzl_button.selected = YES;
        [self.citydailog removeFromSuperview];
        self.citydailog=nil;
        AirDialog *airDialog=[[AirDialog alloc]initWithFrame:CGRectMake(0, 40+self.barhight, kScreenWidth, kScreenHeitht - 40 - self.barhight)];
        self.airdialog=airDialog;
        [airDialog initWithArray:m_airArray Value:m_airValue labelString:airDes flag:dialog_air];
        [self.view addSubview:airDialog];
        airDialog.delegate=self;
    }
    
}
#pragma mark 排序
-(void)cityRank{
    
    orderflag = !orderflag;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:4];
    for (int i = (int)m_tableData.count; i>0; i--) {
        [array addObject:[m_tableData objectAtIndex:i-1]];
    }
    [m_tableData removeAllObjects];
    m_tableData=nil;
    m_tableData=[[NSMutableArray alloc]initWithArray:array];
    //    [array release];
    [m_tableView reloadData];
    
}
#pragma mark 空气指数解释
-(void)showAirDes{
    
    AirDialog *airDesDialog=[[AirDialog alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    [airDesDialog initWithArray:nil Value:nil labelString:airDes flag:dialog_label];
    [self.view addSubview:airDesDialog];
    //[airDesDialog release];
}

#pragma 城市空气指数
-(void)cityAqi{
    AIrViewController *air=[[AIrViewController alloc]init];
    air.countryid=self.areaid;
    air.popParameter = @"省份界面";
    //    [air getair_qua_detailWithtype:@"1" withcityid:self.areaid];
    air.titlename=[NSString stringWithFormat:@"空气质量-%@",self.aqiCity];
    [self.navigationController pushViewController:air animated:YES];
    //    PMViewController *pmc=[[PMViewController alloc]init];
    //    pmc.youyunum=m_tableData.count-self.cityrow;
    //    [pmc getDataWithcity:self.aqiCity type:@"1"];
    //    pmc.titlename=[NSString stringWithFormat:@"空气质量-%@",self.aqiCity];
    //    [self.navigationController pushViewController:pmc animated:!kSystemVersionMore7];
    
}

#pragma mark AirDialogDelegat
-(void)selectTable:(NSInteger)row type:(dialogType)t_type{
    kqzl_button.selected = NO;
    self.airdialog=nil;
    if (t_type==dialog_air) {
        [self getDate:[m_airValue objectAtIndex:row]];
        self.rankType=[m_airValue objectAtIndex:row];
    }else{
        self.aqiCity=[m_cityValue objectAtIndex:row];
        
        [self cityAqi];
    }
}
#pragma mark cityDialogeDelegat
-(void)selectTable:(NSString *)t_city isProvince:(BOOL)isProvince{
    city_button.selected = NO;
    if (isProvince) {
        self.selectProvinceName = t_city;
        [self getDate:self.rankType];
    }else {
        self.citydailog=nil;
        self.aqiCity=t_city;
        self.areaid=[self readxml:t_city];
        sign=1;
        [self cityAqi];
    }
}
#pragma mark tableView delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    NSString *t_str = [NSString stringWithFormat:@"%ld_%ld", (long)section, (long)row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:t_str];
    if (cell) {
        [cell removeFromSuperview];
    }
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t_str];
    //cell的内容
    {
        rankListModle *rlm=[m_tableData objectAtIndex:row];
        
        //排名
        UILabel *rank_lable=[[UILabel alloc]initWithFrame:CGRectMake(0,0,60,45)];
        [rank_lable setTextAlignment:NSTextAlignmentCenter];
        [rank_lable setBackgroundColor:[UIColor clearColor]];
        [rank_lable setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [rank_lable setTextColor:[UIColor grayColor]];
        //        rank_lable.shadowColor = [UIColor grayColor];
        if (orderflag != false) {
            
            rank_lable.text=[NSString stringWithFormat:@"%d",(int)(indexPath.row + 1)];
        }else {
            rank_lable.text=[NSString stringWithFormat:@"%d",(int)(m_tableData.count - indexPath.row)];
        }
        [cell.contentView addSubview:rank_lable];
        //        [rank_lable release];
        
        //省份
        UILabel *province_lable=[[UILabel alloc]initWithFrame:CGRectMake(90,0,50,45)];
        [province_lable setTextAlignment:NSTextAlignmentCenter];
        [province_lable setBackgroundColor:[UIColor clearColor]];
        [province_lable setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [province_lable setTextColor:[UIColor grayColor]];
        //        province_lable.shadowColor = [UIColor grayColor];
        province_lable.text=rlm.province;
        [cell.contentView addSubview:province_lable];
        //        [province_lable release];
        
        //城市
        UILabel *city_lable=[[UILabel alloc]initWithFrame:CGRectMake(150, 0, 80, 45)];
        [city_lable setTextAlignment:NSTextAlignmentCenter];
        [city_lable setBackgroundColor:[UIColor clearColor]];
        [city_lable setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [city_lable setTextColor:[UIColor blackColor]];
        city_lable.text=rlm.city;
        [cell.contentView addSubview:city_lable];
        
        
        //数值
        UILabel *imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-70, 0,40,45)];
        
        [imageLabel setTextAlignment:NSTextAlignmentCenter];
        [imageLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [imageLabel setTextColor:[UIColor grayColor]];
        imageLabel.text=rlm.number;
        [cell.contentView addSubview:imageLabel];
        
        if (showcolor==YES) {
            UIImageView *colorimg=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-20, 10, 5, 23)];
            colorimg.backgroundColor=[self getAQI:rlm.number];
            [cell addSubview:colorimg];
        }
        
        
        if (row%2==0) {
            cell.backgroundColor=[UIColor colorHelpWithRed:246 green:246 blue:246 alpha:1];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
        
        //        [imageLabel release];
    }
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, 1)];
    line.backgroundColor=[UIColor grayColor];
    //    [cell addSubview:line];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //*
    NSInteger row=indexPath.row;
    rankListModle *rlm=[m_tableData objectAtIndex:row];
    self.aqiCity=rlm.city;
    self.cityrow=row+1;
    self.areaid=rlm.areaid;
//    NSLog(@"select:%@",aqiCity);
    [self cityAqi];
    //*/
}
#pragma mark network

-(void)getDate:(NSString*)t_rankType{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_type = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    
    if ([t_rankType isEqualToString:@"PM2.5"]) {
        t_rankType=@"PM2_5";
    }
    if ([t_rankType isEqualToString:@"AQI"]) {
        showcolor=YES;
    }else
        showcolor=NO;
    
    [t_type setObject:t_rankType forKey:@"rank_type"];
    [t_b setObject:t_type forKey:@"gz_air_city_rank"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    
    //NSLog(@"%@",t_dic);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        //        NSLog(@"%@",returnData);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        NSDictionary *t_airRank=[t_b objectForKey:@"gz_air_city_rank"];
        
        
        if (t_airRank!=nil) {
            
            
            [m_tableData removeAllObjects];
            NSArray *rankList_array=[t_airRank objectForKey:@"rank_list"];
            //排名数据源
            for (int i=0; i<rankList_array.count; i++) {
                rankListModle *rlm=[[rankListModle alloc]init];
                rlm.rank=i+1;
                rlm.province=[[rankList_array objectAtIndex:i] objectForKey:@"province"];
                rlm.city=[[rankList_array objectAtIndex:i] objectForKey:@"city"];
                rlm.number=[[rankList_array objectAtIndex:i] objectForKey:@"num"];
                rlm.areaid=[[rankList_array objectAtIndex:i] objectForKey:@"areaId"];
                if ([rlm.province isEqualToString:self.selectProvinceName]) {
                    [m_tableData addObject:rlm];
                }
            }
            
            //空气质量描述数据源
            NSArray *dicList_array=[t_airRank objectForKey:@"dic_list"];
            [m_airArray removeAllObjects];
            [m_airValue removeAllObjects];
            for (int i=0; i<dicList_array.count; i++) {
                
                NSString *t_rankType=[[dicList_array objectAtIndex:i] objectForKey:@"rankType"];
                if ([t_rankType isEqualToString:@"PM2.5"]) {
                    t_rankType=@"PM2_5";
                }
                NSString *t_name=[[dicList_array objectAtIndex:i] objectForKey:@"name"];
                
                [m_airArray addObject:[NSString stringWithFormat:@"%@%@",t_name,t_rankType]];
                [m_airValue addObject:t_rankType];
                if ([t_rankType isEqualToString:self.rankType]) {
                    airNamge=[[dicList_array objectAtIndex:i] objectForKey:@"name"];
                    self.airDes=[[dicList_array objectAtIndex:i] objectForKey:@"des"];
                    //     NSLog(@"%@",airDes);
                    //设置标题
                    [self setTitle:[NSString stringWithFormat:@"%@-排行榜",airNamge]];
                    [kqzl_button setTitle:t_rankType forState:UIControlStateNormal];
                    [air_button setTitle:[[dicList_array objectAtIndex:i] objectForKey:@"questions"] forState:UIControlStateNormal];
                    
                }
            }
            
            
            
            
            //城市数据源
            NSArray *areaList_array=[t_airRank objectForKey:@"area_list"];
            [m_cityArray removeAllObjects];
            [m_cityValue removeAllObjects];
            //            [m_areaid removeAllObjects];
            for (int i=0; i<areaList_array.count; i++) {
                
                NSString *t_province=[[areaList_array objectAtIndex:i] objectForKey:@"province"];
                NSString *t_city=[[areaList_array objectAtIndex:i] objectForKey:@"city"];
                //                NSString *t_areaid=[[areaList_array objectAtIndex:i]objectForKey:@"areaId"];
                [m_cityArray addObject:[NSString stringWithFormat:@"%@,%@",t_province,t_city]];
                [m_cityValue addObject:t_city];
                //                [m_areaid addObject:t_areaid];
            }
            //*/
            orderflag=true;
            [m_tableView reloadData];
            //            [order_button setBackgroundImage:[UIImage imageNamed:@"指数按钮1.png"] forState:UIControlStateNormal];
            
        }
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        [ShareFun alertNotice:@"知天气" withMSG:@"请检查网络连接！" cancleButtonTitle:@"确定" otherButtonTitle:nil];
        
    } withCache:YES];
    
}
-(NSString *)readxml:(NSString *)city{
    NSString *cityid=nil;
    m_allCity=m_treeNodeAllCity;
    for (int i = 0; i < [m_allCity.children count]; i ++)
    {
        TreeNode *t_node = [m_allCity.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:2];
        t_node_child = [t_node.children objectAtIndex:3];
        NSString *t_name = t_node_child.leafvalue;
        if ([t_name rangeOfString:city].length>0)
        {
            //----------------------------------------------------
            t_node_child = [t_node.children objectAtIndex:5];
            TreeNode *t_node_child1 = [t_node.children objectAtIndex:0];
            NSString *Id = t_node_child1.leafvalue;
            cityid=Id;
            break;
        }
    }
    return cityid;
}
-(UIColor *)getAQI:(NSString *)aqivalue{
    int air=aqivalue.intValue;
    UIColor *color=nil;
    if (air>=0 &&air<51) {
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
@end
