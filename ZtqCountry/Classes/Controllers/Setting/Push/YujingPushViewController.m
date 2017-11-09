//
//  YujingPushViewController.m
//  ZtqCountry
//
//  Created by linxg on 14-8-29.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "YujingPushViewController.h"
#import "SelectCityViewController.h"
@interface YujingPushViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView * pushList;
@property (strong, nonatomic) UIButton * setBut;
@property (strong, nonatomic) UILabel * setStyleLab;
@property (strong, nonatomic) UIButton * cityBut;

@property (strong, nonatomic) UIView * cityBg;
@property (strong, nonatomic) UITableView * cityList;
@property (strong, nonatomic) UIImageView * bgImgV;

@end

@implementation YujingPushViewController

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
    
    self.view.backgroundColor=[UIColor whiteColor];
    if(kSystemVersionMore7)
    {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    self.navigationController.navigationBarHidden = YES;
    //    self.title = @"推送设置";
    float place = 0;
    if(kSystemVersionMore7)
    {
        place = 20;
    }
    self.barHeight = 44+ place;
    _navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    _navigationBarBg.userInteractionEnabled = YES;
    //    _navigationBarBg.backgroundColor = [UIColor colorHelpWithRed:27 green:92 blue:189 alpha:1];
    _navigationBarBg.image=[UIImage imageNamed:@"导航栏.png"];
    [self.view addSubview:_navigationBarBg];
    UIImageView *leftimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7+place, 29, 29)];
    leftimg.image=[UIImage imageNamed:@"返回.png"];
    leftimg.userInteractionEnabled=YES;
    [_navigationBarBg addSubview:leftimg];
    
    
    _leftBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 7+place, 60, 44+place)];
    [_leftBut addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarBg addSubview:_leftBut];
    
    _rightBut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-55, 7+place, 50, 30)];
    [_rightBut addTarget:self action:@selector(sendbtn) forControlEvents:UIControlEventTouchUpInside];
    [_rightBut setTitle:@"提交" forState:UIControlStateNormal];
    _rightBut.titleLabel.font=[UIFont systemFontOfSize:15];
    [_rightBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightBut setBackgroundImage:[UIImage imageNamed:@"提交框常态"] forState:UIControlStateNormal];
    [_rightBut setBackgroundImage:[UIImage imageNamed:@"提交框二态"] forState:UIControlStateHighlighted];
    [_navigationBarBg addSubview:_rightBut];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 12+place, self.view.width-120, 20)];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textColor = [UIColor whiteColor];
    [_navigationBarBg addSubview:_titleLab];
    self.barHiden = NO;
    self.titleLab.text = @"预警信息推送";
    self.titleLab.textColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendpushtoyj) name:@"YJTS" object:nil];
    
    UILabel *yjlab=[[UILabel alloc]initWithFrame:CGRectMake(10, self.barHeight, kScreenWidth, 30)];
    yjlab.text=@"预警等级设置";
    yjlab.font=[UIFont systemFontOfSize:15];
    yjlab.textColor=[UIColor grayColor];
    [self.view addSubview:yjlab];
    _pushList = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight+32, kScreenWidth, 300) style:UITableViewStylePlain];
    _pushList.separatorStyle = UITableViewCellSeparatorStyleNone;
    _pushList.delegate = self;
    _pushList.dataSource = self;
    _pushList.scrollEnabled=NO;
    [self.view addSubview:_pushList];
    
//    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
//    NSString *path = [docPath stringByAppendingPathComponent:@"YujingPush"];
//    NSFileManager *fm = [NSFileManager defaultManager];
//    if([fm fileExistsAtPath:path] == NO)
//    {
//        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
//       
//        
//        [self configData];
//        [self sendpush];
//    }else{
        [self queryPushTag];//查询标签
//        [self configData];
//    }
}
-(void)sendpushtoyj{
    //    [self queryPushTag];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"HwarnPushNotification"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"OwarnPushNotification"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"YwarnPushNotification"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"BwarnPushNotification"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"PwarnPushNotification"];//省级

    [[NSUserDefaults standardUserDefaults] synchronize];
  
    
    if (!self.tsid.length>0) {
        self.tsid=[setting sharedSetting].currentCityID;
    }
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * setProperty = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * tip = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    [tip setObject:self.tsid forKey:@"push_city"];
    if (!self.r_yjxx.length>0) {
        self.r_yjxx=@"1";
    }
    if (!self.o_yjxx.length>0) {
        self.o_yjxx=@"1";
    }
    if (!self.b_yjxx.length>0) {
        self.b_yjxx=@"0";
    }
    if (!self.y_yjxx.length>0) {
        self.y_yjxx=@"0";
    }
    if (!self.p_yjxx.length>0) {
        self.p_yjxx=@"1";
    }
    [tip setObject:self.r_yjxx forKey:@"yjxx_r"];
    [tip setObject:self.o_yjxx forKey:@"yjxx_o"];
    [tip setObject:self.y_yjxx forKey:@"yjxx_y"];
    [tip setObject:self.b_yjxx forKey:@"yjxx_b"];
    [tip setObject:self.p_yjxx forKey:@"push_fj_prowarn"];
    [setProperty setObject:tip forKey:@"tags"];
    [setProperty setObject:[setting sharedSetting].devToken forKey:@"token"];
    [b setObject:setProperty forKey:@"gz_set_pushtag"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
      
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error) {
        
    } withCache:NO];
    [self.pushList reloadData];
}

-(void)sendpush{
    
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * setProperty = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * tip = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    if (!self.tsid.length>0) {
        self.tsid=[setting sharedSetting].currentCityID;
    }
    if (self.tsid.length>0) {
        [tip setObject:self.tsid forKey:@"push_city"];
    }
    
    if (!self.r_yjxx.length>0) {
        self.r_yjxx=@"1";
    }
    if (!self.o_yjxx.length>0) {
        self.o_yjxx=@"1";
    }
    if (!self.b_yjxx.length>0) {
        self.b_yjxx=@"0";
    }
    if (!self.y_yjxx.length>0) {
        self.y_yjxx=@"0";
    }
    if (!self.p_yjxx.length>0) {
        self.p_yjxx=@"1";
    }
    [tip setObject:self.r_yjxx forKey:@"yjxx_r"];
    [tip setObject:self.o_yjxx forKey:@"yjxx_o"];
    [tip setObject:self.y_yjxx forKey:@"yjxx_y"];
    [tip setObject:self.b_yjxx forKey:@"yjxx_b"];
    [tip setObject:self.p_yjxx forKey:@"push_fj_prowarn"];
    [setProperty setObject:tip forKey:@"tags"];
    [setProperty setObject:[setting sharedSetting].devToken forKey:@"token"];
    [b setObject:setProperty forKey:@"gz_set_pushtag"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
      
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error) {
        
    } withCache:NO];
    
}

//标签查询
-(void)queryPushTag{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * setProperty = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    [setProperty setObject:[setting sharedSetting].devToken forKey:@"token"];
    [b setObject:setProperty forKey:@"gz_query_pushtag"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary *setpust=[b objectForKey:@"gz_query_pushtag"];
        NSArray *tags=[setpust objectForKey:@"tags"];
        if (tags.count>0) {
            for (int i=0; i<tags.count; i++) {
                NSString *tagkey=[tags[i] objectForKey:@"tag_key"];
                NSString *tag_value=[tags[i] objectForKey:@"tag_value"];
                if ([tagkey isEqualToString:@"yjxx_r"]) {
                    self.r_yjxx=tag_value;
                    if ([self.r_yjxx isEqualToString:@"0"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"HwarnPushNotification"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else{
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"HwarnPushNotification"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                if ([tagkey isEqualToString:@"yjxx_o"]) {
                    self.o_yjxx=tag_value;
                    if ([self.o_yjxx isEqualToString:@"0"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"OwarnPushNotification"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else{
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"OwarnPushNotification"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                if ([tagkey isEqualToString:@"yjxx_b"]) {
                    self.b_yjxx=tag_value;
                    if ([self.b_yjxx isEqualToString:@"0"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"BwarnPushNotification"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else{
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"BwarnPushNotification"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                if ([tagkey isEqualToString:@"yjxx_y"]) {
                    self.y_yjxx=tag_value;
                    if ([self.y_yjxx isEqualToString:@"0"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"YwarnPushNotification"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else{
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"YwarnPushNotification"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                if ([tagkey isEqualToString:@"push_fj_prowarn"]) {
                    self.p_yjxx=tag_value;
                    if ([self.p_yjxx isEqualToString:@"0"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"PwarnPushNotification"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else{
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"PwarnPushNotification"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                
            }
            
        }
        [self sendpush];
        [self.pushList reloadData];
        
    } withFailure:^(NSError *error) {
        
    } withCache:NO];
    
}
-(void)backAction:(UIButton *)sender
{
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//    NSString *o=[[NSUserDefaults standardUserDefaults]objectForKey:@"OwarnPushNotification"];
//    NSString *y=[[NSUserDefaults standardUserDefaults]objectForKey:@"YwarnPushNotification"];
//    NSString *b=[[NSUserDefaults standardUserDefaults]objectForKey:@"BwarnPushNotification"];
//    NSString *newo=[NSString stringWithFormat:@"%@",o];
//    NSString *newy=[NSString stringWithFormat:@"%@",y];
//    NSString *newb=[NSString stringWithFormat:@"%@",b];
    if (self.isedit==YES ) {
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"设置信息还未保存，要放弃吗？" delegate:self cancelButtonTitle:@"继续" otherButtonTitles:@"放弃", nil];
        al.delegate=self;
        [al show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        return;
    }else{
         [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)sendbtn{
    
    self.isedit=NO;
    BOOL o=![[NSUserDefaults standardUserDefaults] boolForKey:@"OwarnPushNotification"];
    NSString *yellow=[[NSUserDefaults standardUserDefaults]objectForKey:@"YwarnPushNotification"];
    NSString *blue=[[NSUserDefaults standardUserDefaults]objectForKey:@"BwarnPushNotification"];
    BOOL p=![[NSUserDefaults standardUserDefaults] boolForKey:@"PwarnPushNotification"];
    NSString *newo=[NSString stringWithFormat:@"%d",o];
    NSString *newy=[NSString stringWithFormat:@"%@",yellow];
    NSString *newb=[NSString stringWithFormat:@"%@",blue];
    NSString *newp=[NSString stringWithFormat:@"%d",p];

    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * setProperty = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * tip = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    if (!self.tsid.length>0) {
        self.tsid=[setting sharedSetting].currentCityID;
    }
    if (self.tsid.length>0) {
        [tip setObject:self.tsid forKey:@"push_city"];
    }
    if (!self.r_yjxx.length>0) {
        self.r_yjxx=@"1";
    }
    if (newo==nil) {
        newo=@"1";
    }
    if (yellow==nil) {
        newy=@"0";
    }
    if (blue==nil) {
        newb=@"0";
    }
    if (newp==nil) {
        newp=@"1";
    }
    [tip setObject:self.r_yjxx forKey:@"yjxx_r"];
    [tip setObject:newo forKey:@"yjxx_o"];
    [tip setObject:newy forKey:@"yjxx_y"];
    [tip setObject:newb forKey:@"yjxx_b"];
    [tip setObject:newp forKey:@"push_fj_prowarn"];
    [setProperty setObject:tip forKey:@"tags"];
    [setProperty setObject:[setting sharedSetting].devToken forKey:@"token"];
    [b setObject:setProperty forKey:@"gz_set_pushtag"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"提交中..." animated:YES];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary *setpust=[b objectForKey:@"gz_set_pushtag"];
        NSString *result=[setpust objectForKey:@"result"];
        if ([result isEqualToString:@"1"]) {
            
            UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"嘿嘿,提交成功了" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [al show];
        }else{
            UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"提交失败,再试试吧" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [al show];
        }
        
//        NSString * error = [h objectForKey:@"error"];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error) {
        
    } withCache:NO];
}
-(void)qxyjAction{
    
}
-(void)configData
{
//    self.yujingcitydic=[[NSUserDefaults standardUserDefaults]objectForKey:@"citydic"];
//    
//    NSString * ID = [self.yujingcitydic objectForKey:@"ID"];
//    
//   
//    
//    self.strid=ID;
//    self.tscity=name;
//    self.tsid=ID;
//    if(![originName isEqualToString:name])
//    {
//            NSDictionary * yjxxtsInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"通知栏",@"MODEL",name,@"CITYNAME",ID,@"ID",[NSNumber numberWithBool:NO],@"RSTATE",[NSNumber numberWithBool:NO],@"OSTATE",[NSNumber numberWithBool:NO],@"YSTATE",[NSNumber numberWithBool:NO],@"BSTATE", nil];
//        
//        [[NSUserDefaults standardUserDefaults] setObject:yjxxtsInfo forKey:@"YUJINGXINXITUISONG"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        //        [self sendpushtoqx];
//        [self.pushList reloadData];
//    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    int section = indexPath.section;
    
    NSString *t_str = [NSString stringWithFormat:@"cell %d_%d", section, row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:t_str];
    
    if(cell != nil)
        [cell removeFromSuperview];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t_str];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel * RTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 20)];
            RTitleLab.backgroundColor = [UIColor clearColor];
            RTitleLab.textColor = [UIColor blackColor];
            RTitleLab.textAlignment = NSTextAlignmentLeft;
            RTitleLab.text = @"红色预警";
            RTitleLab.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:RTitleLab];
            
            UILabel * OTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 100, 20)];
            OTitleLab.backgroundColor = [UIColor clearColor];
            OTitleLab.textColor = [UIColor blackColor];
            OTitleLab.textAlignment = NSTextAlignmentLeft;
            OTitleLab.text = @"橙色预警";
            OTitleLab.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:OTitleLab];
            
            UILabel * YTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 100, 20)];
            YTitleLab.backgroundColor = [UIColor clearColor];
            YTitleLab.textColor = [UIColor blackColor];
            YTitleLab.textAlignment = NSTextAlignmentLeft;
            YTitleLab.text = @"黄色预警";
            YTitleLab.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:YTitleLab];
            
            UILabel * BTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 100, 20)];
            BTitleLab.backgroundColor = [UIColor clearColor];
            BTitleLab.textColor = [UIColor blackColor];
            BTitleLab.textAlignment = NSTextAlignmentLeft;
            BTitleLab.text = @"蓝色预警";
            BTitleLab.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:BTitleLab];
    
    
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(10, 179, kScreenWidth-20, 1)];
    line.backgroundColor=[UIColor colorHelpWithRed:234 green:234 blue:234 alpha:1];
    [cell.contentView addSubview:line];
    
    
    UILabel *Lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 190, 200, 20)];
    Lab.backgroundColor = [UIColor clearColor];
    Lab.textColor = [UIColor grayColor];
    Lab.textAlignment = NSTextAlignmentLeft;
    Lab.text = @"福建省级预警设置";
    Lab.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:Lab];
    UILabel *tslab = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, 100, 20)];
    tslab.backgroundColor = [UIColor clearColor];
    tslab.textColor = [UIColor grayColor];
    tslab.textAlignment = NSTextAlignmentLeft;
    tslab.text = @"提示：";
    tslab.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:tslab];
    UILabel *tslab1= [[UILabel alloc] initWithFrame:CGRectMake(10, 275, 300, 20)];
    tslab1.backgroundColor = [UIColor clearColor];
    tslab1.textColor = [UIColor grayColor];
    tslab1.textAlignment = NSTextAlignmentLeft;
    tslab1.text = @"首界面当前城市为福建省内城市时，本设置有效。";
    tslab1.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:tslab1];
            UILabel * PTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 220, 150, 20)];
            PTitleLab.backgroundColor = [UIColor clearColor];
            PTitleLab.textColor = [UIColor blackColor];
            PTitleLab.textAlignment = NSTextAlignmentLeft;
            PTitleLab.text = @"福建省气象台预警";
            PTitleLab.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:PTitleLab];
    
    
            UISwitch * RSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth-85, 15, 60, 30)];
            RSwitch.tag = 21;
            RSwitch.enabled=NO;
//            NSLog(@"%d",[[NSUserDefaults standardUserDefaults] boolForKey:@"HwarnPushNotification"]);
            RSwitch.on = ![[NSUserDefaults standardUserDefaults] boolForKey:@"HwarnPushNotification"];
            [RSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:RSwitch];
            
            UISwitch * OSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth-85, 55, 60, 30)];
            OSwitch.tag = 22;
            OSwitch.on = ![[NSUserDefaults standardUserDefaults] boolForKey:@"OwarnPushNotification"];
            [OSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:OSwitch];
            
            UISwitch * YSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth-85, 95, 60, 30)];
            YSwitch.tag = 23;
            YSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"YwarnPushNotification"];
            [YSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:YSwitch];
            
            UISwitch * BSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth-85, 135, 60, 30)];
            BSwitch.tag = 24;
            //            BSwitch.on = Bstate;
            BSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"BwarnPushNotification"];
            [BSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:BSwitch];
    
            UISwitch * PSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth-85, 219, 60, 30)];
            PSwitch.tag = 25;
            PSwitch.on = ![[NSUserDefaults standardUserDefaults] boolForKey:@"PwarnPushNotification"];
            [PSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:PSwitch];
    UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(10, 299, kScreenWidth-20, 1)];
    line1.backgroundColor=[UIColor colorHelpWithRed:234 green:234 blue:234 alpha:1];
    [cell.contentView addSubview:line1];
            return cell;
    
    
    
}




-(void)switchAction:(UISwitch *)sender
{
    

    self.isedit=YES;
    int tag = sender.tag;
    NSString * state = nil;
    if(sender.on)
    {
        state = @"1";
    }
    else
    {
        state = @"0";
    }
    
    switch (tag) {
            
        case 21:
        {
            
            [self setPropertywithValue:state withKey:@"yjxx_r" withView:sender];
            break;
        }
        case 22:
        {
            
            [self setPropertywithValue:state withKey:@"yjxx_o" withView:sender];
            break;
        }
        case 23:
        {
            [self setPropertywithValue:state withKey:@"yjxx_y" withView:sender];
            break;
        }
        case 24:
        {
            
            [self setPropertywithValue:state withKey:@"yjxx_b" withView:sender];
            break;
        }
        case 25:
        {
            
            [self setPropertywithValue:state withKey:@"push_fj_prowarn" withView:sender];
            break;
        }
    }
}
-(void)setPropertywithValue:(NSString *)value withKey:(NSString *)key withView:(id)sender
{
//    NSString * urlStr = URL_SERVER;
//    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * setProperty = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * tip = [[NSMutableDictionary alloc] init];
//    [h setObject:[setting sharedSetting].app forKey:@"p"];
//    [tip setObject:value forKey:key];
//    NSString *cityid=nil;
//    if (self.strid.length>0) {
//        cityid=self.strid;
//    }else{
//        cityid=[setting sharedSetting].currentCityID;
//    }
//    [tip setObject:cityid forKey:@"push_city"];
//    [setProperty setObject:tip forKey:@"tags"];
//    [setProperty setObject:[setting sharedSetting].devToken forKey:@"token"];
//    [b setObject:setProperty forKey:@"gz_set_pushtag"];
//    [param setObject:h forKey:@"h"];
//    [param setObject:b forKey:@"b"];
//    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
//    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
//        [MBProgressHUD hideHUDForView:self.view animated:NO];
//        NSDictionary * b = [returnData objectForKey:@"b"];
//        NSDictionary *setpust=[b objectForKey:@"gz_set_pushtag"];
//        NSString *result=[setpust objectForKey:@"result"];
//        int is = [result intValue];
//        
//        if(is ==1)
//        {
            //成功
            if([key isEqualToString:@"yjxx_r"])
            {
                //hongse
                if([value isEqualToString:@"0"])
                {
                    //关
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"HwarnPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    //                     NSLog(@"%d",[[NSUserDefaults standardUserDefaults] boolForKey:@"HwarnPushNotification"]);
                }
                else
                {
                    //开
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"HwarnPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
            }
            if([key isEqualToString:@"yjxx_o"])
            {
                //
                if([value isEqualToString:@"0"])
                {
                    //关
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"OwarnPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else
                {
                    //开
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"OwarnPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
            }
            if([key isEqualToString:@"yjxx_y"])
            {
                //产品
                if([value isEqualToString:@"0"])
                {
                    //关
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"YwarnPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else
                {
                    //开
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"YwarnPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
            }
            if([key isEqualToString:@"yjxx_b"])
            {
                //专题
                if([value isEqualToString:@"0"])
                {
                    //关
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"BwarnPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else
                {
                    //开
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"BwarnPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
            }
    if([key isEqualToString:@"push_fj_prowarn"])
    {
        //hongse
        if([value isEqualToString:@"0"])
        {
            //关
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"PwarnPushNotification"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        else
        {
            //开
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"PwarnPushNotification"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }
//    [_pushList reloadData];
//        }
//        else
//        {
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"知天气" message:@"设置失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//            //失败
//            
//            if([key isEqualToString:@"yjxx_r"])
//            {
//                //节日
//                UISwitch * s = sender;
//                BOOL isOpen = s.on;
//                s.on = !isOpen;
//            }
//            if([key isEqualToString:@"yjxx_o"])
//            {
//                //节气
//                UISwitch * s = sender;
//                BOOL isOpen = s.on;
//                s.on = !isOpen;
//            }
//            if([key isEqualToString:@"yjxx_y"])
//            {
//                //产品
//                UISwitch * s = sender;
//                BOOL isOpen = s.on;
//                s.on = !isOpen;
//            }
//            if([key isEqualToString:@"yjxx_b"])
//            {
//                //专题
//                UISwitch * s = sender;
//                BOOL isOpen = s.on;
//                s.on = !isOpen;
//            }
//            
//        }
//    } withFailure:^(NSError *error) {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"知天气" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        if([key isEqualToString:@"yjxx_r"])
//        {
//            //节日
//            UISwitch * s = sender;
//            BOOL isOpen = s.on;
//            s.on = !isOpen;
//        }
//        if([key isEqualToString:@"yjxx_o"])
//        {
//            //节气
//            UISwitch * s = sender;
//            BOOL isOpen = s.on;
//            s.on = !isOpen;
//        }
//        if([key isEqualToString:@"yjxx_y"])
//        {
//            //产品
//            UISwitch * s = sender;
//            BOOL isOpen = s.on;
//            s.on = !isOpen;
//        }
//        if([key isEqualToString:@"yjxx_b"])
//        {
//            //专题
//            UISwitch * s = sender;
//            BOOL isOpen = s.on;
//            s.on = !isOpen;
//        }
//        
//    } withCache:NO];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    if([tableView isEqual:self.cityList])
    //    {
    //        NSString * originName = self.cityBut.titleLabel.text;
    //        NSDictionary * cityInfo = [[setting sharedSetting].citys objectAtIndex:indexPath.row];
    //        NSString * name = [self.yujingcitydic objectForKey:@"city"];
    //        NSString * ID = [self.yujingcitydic objectForKey:@"ID"];
    //        self.strid=ID;
    //        if(![originName isEqualToString:name])
    //        {
    //            [self.cityBut setTitle:name forState:UIControlStateNormal];
    //
    //           NSDictionary * yjxxtsInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"通知栏",@"MODEL",name,@"CITYNAME",ID,@"ID",[NSNumber numberWithBool:NO],@"RSTATE",[NSNumber numberWithBool:NO],@"OSTATE",[NSNumber numberWithBool:NO],@"YSTATE",[NSNumber numberWithBool:NO],@"BSTATE", nil];
    //
    //            [[NSUserDefaults standardUserDefaults] setObject:yjxxtsInfo forKey:@"YUJINGXINXITUISONG"];
    //            [[NSUserDefaults standardUserDefaults] synchronize];
    //            [self.pushList reloadData];
    //            [self removeNotificationWithClockID:@"yujingxinxituisongO"];
    //            [self removeNotificationWithClockID:@"yujingxinxituisongR"];
    //            [self removeNotificationWithClockID:@"yujingxinxituisongY"];
    //            [self removeNotificationWithClockID:@"yujingxinxituisongB"];
    //        }
    //        self.cityBg.hidden = YES;
    //    }
}

-(void)tapAction:(UITapGestureRecognizer *)sender
{
    self.cityBg.hidden = YES;
}


-(BOOL)haveYujingWithColor:(NSString *)color
{
    BOOL result = YES;
    return result;
}

-(void)addYujingTuisongWithColor:(NSString *)color
{
    NSDictionary * yjxxsInfo = [self getYujingInfo];
    NSArray * yjxxs = [yjxxsInfo objectForKey:@"yjxxs"];
    for(int i=0;i<yjxxs.count;i++)
    {
        NSDictionary * yjxxInfo = [yjxxs objectAtIndex:i];
        NSString * title = [yjxxInfo objectForKey:@"Title"];
        NSString * info = [yjxxInfo objectForKey:@"Info"];
        NSString * Currentcolor = [yjxxInfo objectForKey:@"Color"];
        if([Currentcolor isEqualToString:color])
        {
            UILocalNotification *notification=[[UILocalNotification alloc] init];
            if (notification!=nil) {
                NSDate *now = [NSDate date];
                //从现在开始，10秒以后通知
                //             notification.fireDate = [NSDate dat]
                notification.repeatInterval = kCFCalendarUnitDay;
                //使用本地时区
                notification.timeZone=[NSTimeZone defaultTimeZone];
                notification.alertBody=info;
                notification.fireDate = [[NSDate date] dateByAddingTimeInterval:10];
                //通知提示音 使用默认的
                notification.soundName= UILocalNotificationDefaultSoundName;
                notification.alertAction=@"关闭";
                //存入的字典，用于传入数据，区分多个通知
                NSMutableDictionary * dicUserInfo = [[NSMutableDictionary alloc] init];
                NSString * clockID = [NSString stringWithFormat:@"yujingxinxituisong%@",color];
                
                [dicUserInfo setValue:clockID forKey:@"clockID"];
                [dicUserInfo setValue:info forKey:@"message"];
                [dicUserInfo setValue:@"预警信息" forKey:@"title"];
                notification.userInfo = [NSDictionary dictionaryWithObject:dicUserInfo forKey:@"dictionary"];
                
                
                [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
                
            }
            
        }
    }
}

-(void)removeNotificationWithClockID:(NSString *)clockID
{
    NSArray * array = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSUInteger acount = [array count];
    if(acount>0)
    {
        for(int i=0;i<acount;i++)
        {
            UILocalNotification * myUILocalNotification = [array objectAtIndex:i];
            NSDictionary * userInfo = myUILocalNotification.userInfo;
            NSDictionary * dictionary = [userInfo objectForKey:@"dictionary"];
            NSString * currentID = [dictionary objectForKey:@"clockID"];
            if([currentID isEqual:clockID])
            {
                [[UIApplication sharedApplication] cancelLocalNotification:myUILocalNotification];
                break;
            }
        }
    }
}


-(NSDictionary *)getYujingInfo
{
    NSDictionary * yjxxtsInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"YUJINGXINXITUISONG"];
    NSString * currentID = [yjxxtsInfo objectForKey:@"ID"];
    //    NSDictionary * returnData = [[setting sharedSetting].DEMO_AllCityYjxxxq objectForKey:currentID];
    NSDictionary * returnData = nil;
    
    return returnData;
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
