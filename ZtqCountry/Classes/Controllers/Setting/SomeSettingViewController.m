//
//  SomeSettingViewController.m
//  ZtqCountry
//
//  Created by linxg on 14-8-28.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "SomeSettingViewController.h"
#import "MoreCell.h"
#import "AutoShareViewController.h"
#import "PushSettingViewController.h"
#import "SKGJViewController.h"
#import "PushSettingViewController.h"
#import "YujingPushViewController.h"
#import "TQYBViewController.h"
#import "UpdateSettingViewController.h"
#import "SelectCityViewController.h"
@interface SomeSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView * settingList;
@property (strong, nonatomic) NSMutableArray * datas;

@end

@implementation SomeSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)configDatas
{
    
    
    _datas = [[NSMutableArray alloc] init];

    NSMutableArray * secondGroup = [[NSMutableArray alloc] init];

    [_datas addObject:secondGroup];
    
   
    
    NSDictionary * settingDic2_1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"预警推送设置",@"Title",@"设置界面_15.png",@"Icon", nil];
    NSDictionary * settingDic2_2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"实况告警推送设置",@"Title",@"设置界面_19.png",@"Icon", nil];
    NSDictionary * settingDic2_3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"温馨提示推送设置",@"Title",@"设置界面_22.png",@"Icon", nil];
   
    [secondGroup addObject:settingDic2_1];
    [secondGroup addObject:settingDic2_2];
    [secondGroup addObject:settingDic2_3];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configDatas];
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
    [_leftBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarBg addSubview:_leftBut];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 12+place, kScreenWidth-120, 20)];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textColor = [UIColor whiteColor];
    [_navigationBarBg addSubview:_titleLab];
    self.barHiden = NO;
    self.titleLab.text = @"推送设置";
    self.titleLab.textColor = [UIColor whiteColor];
    self.view.backgroundColor=[UIColor whiteColor];
    UILabel *tscity=[[UILabel alloc]initWithFrame:CGRectMake(10, self.barHeight, 150, 50)];
    tscity.text=@"推送城市";
    tscity.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:tscity];
    
    NSDictionary *tsdic=[[NSUserDefaults standardUserDefaults]objectForKey:@"tsdic"];
    NSString *tsid=[tsdic objectForKey:@"ID"];
    self.tsid=tsid;
//    NSString *name=[tsdic objectForKey:@"city"];
    UIButton *citybtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-155, self.barHeight, 150, 50)];
    [citybtn setTitle:[self readXMLwith:[setting sharedSetting].currentCityID] forState:UIControlStateNormal];
    [citybtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    citybtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [citybtn addTarget:self action:@selector(cityAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:citybtn];
    if (tsid.length>0) {
        [citybtn setTitle:[self readXMLwith:tsid] forState:UIControlStateNormal];
    }
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(10, self.barHeight+51, kScreenWidth-20, 1)];
    line.backgroundColor=[UIColor colorHelpWithRed:234 green:234 blue:234 alpha:1];
    [self.view addSubview:line];
    
    UILabel *wrlab=[[UILabel alloc]initWithFrame:CGRectMake(10, self.barHeight+51, 150, 50)];
    wrlab.text=@"勿扰模式";
    wrlab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:wrlab];
    
    UILabel *timelab=[[UILabel alloc]initWithFrame:CGRectMake(10, self.barHeight+101, 150, 50)];
    timelab.text=@"时间设定";
    timelab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:timelab];
    UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(10,self.barHeight+170, kScreenWidth-20, 1)];
    line1.backgroundColor=[UIColor colorHelpWithRed:234 green:234 blue:234 alpha:1];
    [self.view addSubview:line1];
    
    UISwitch * RSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth-75, self.barHeight+65, 60, 30)];
    self.mswitch=RSwitch;
    RSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"TimePushNotification"];
    [RSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:RSwitch];
    
    
    pickerTitle = [[NSArray alloc] initWithObjects:
                   [NSArray arrayWithObjects:@"00", @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", nil],
                   [NSArray arrayWithObjects:@"00", @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19",
                    @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"38", @"39",
                    @"40", @"41", @"42", @"43", @"44", @"45", @"46", @"47", @"48", @"49", @"50", @"51", @"52", @"53", @"54", @"55", @"56", @"57", @"58", @"59", nil], nil];
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-100, self.barHeight+100, 60, 30)];
    lab.text=@"从";
    lab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:lab];
    UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-100, self.barHeight+135, 60, 30)];
    lab1.text=@"至";
    lab1.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:lab1];
    UIButton *formbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-80, self.barHeight+100, 60, 30)];
    self.formbtn=formbtn;
    [formbtn setTitle:@"00:00" forState:UIControlStateNormal];
    [formbtn setBackgroundImage:[UIImage imageNamed:@"推送设置时间框"] forState:UIControlStateNormal];
    [formbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    formbtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [formbtn addTarget:self action:@selector(formAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:formbtn];
    UIButton *tobtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-80, self.barHeight+135, 60, 30)];
    [tobtn setTitle:@"23:59" forState:UIControlStateNormal];
    self.tobtn=tobtn;
    [tobtn setBackgroundImage:[UIImage imageNamed:@"推送设置时间框"] forState:UIControlStateNormal];
    [tobtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    tobtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [tobtn addTarget:self action:@selector(toAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tobtn];
    
    NSString *form=[[NSUserDefaults standardUserDefaults]objectForKey:@"starttime"];
    NSString *to=[[NSUserDefaults standardUserDefaults]objectForKey:@"endtime"];
    if (form.length>0) {
        [self.formbtn setTitle:form forState:UIControlStateNormal];
    }
    if (to.length>0) {
        [self.tobtn setTitle:to forState:UIControlStateNormal];
    }
    
    pickbgview=[[UIView alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht - self.barHeight)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgClicked)];
    [self.view addGestureRecognizer:tap];
    [pickbgview addGestureRecognizer:tap];
    
    _settingList = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight+173, kScreenWidth, kScreenHeitht-self.barHeight) style:UITableViewStylePlain];
    _settingList.separatorStyle = UITableViewCellSeparatorStyleNone;
    _settingList.dataSource = self;
    _settingList.delegate = self;
    [self.view addSubview:_settingList];
    [self queryPushTag];
}
-(NSString *)readXMLwith:(NSString *)cityid{
    m_allCity=m_treeNodeAllCity;
    NSString *city=[setting sharedSetting].currentCity;
    for (int i = 0; i < [m_allCity.children count]; i ++)
    {
        TreeNode *t_node = [m_allCity.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:0];
        t_node_child = [t_node.children objectAtIndex:0];
        NSString *cityID = t_node_child.leafvalue;
        if ([cityID isEqualToString:cityid])
        {
            
            TreeNode *t_node_child1 = [t_node.children objectAtIndex:6];
            NSString *cityname = t_node_child1.leafvalue;
            city=cityname;
        }
    }
    
    return city;
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
                }
                if ([tagkey isEqualToString:@"yjxx_o"]) {
                    self.o_yjxx=tag_value;
                }
                if ([tagkey isEqualToString:@"yjxx_b"]) {
                    self.b_yjxx=tag_value;
                }
                if ([tagkey isEqualToString:@"yjxx_y"]) {
                    self.y_yjxx=tag_value;
                }
                if ([tagkey isEqualToString:@"push_fj_prowarn"]) {
                    self.p_yjxx=tag_value;
                }
                if ([tagkey isEqualToString:@"hum_l"]) {
                    self.hum_l=tag_value;
                }
                
                
                if ([tagkey isEqualToString:@"temp_h"]) {
                    self.temp_h=tag_value;
                }
                if ([tagkey isEqualToString:@"temp_l"]) {
                    self.temp_l=tag_value;
                }
                if ([tagkey isEqualToString:@"tips_holiday"]) {
                    self.jieri=tag_value;
                    
                }
                if ([tagkey isEqualToString:@"tips_jieqi"]) {
                    self.jieqi=tag_value;
                    
                }
                if ([tagkey isEqualToString:@"tips_notice"]) {
                    self.chanpin=tag_value;
                }
                if ([tagkey isEqualToString:@"tips_special"]) {
                    self.zt=tag_value;
                }
                
            }
            
        }
        [self sendpush];
        
    } withFailure:^(NSError *error) {
        
    } withCache:NO];
    
}
-(void)sendpush{
     NSString *ID=nil;
    if (self.tsid.length>0) {
        ID=self.tsid;
    }else{
        ID=[setting sharedSetting].currentCityID;
    }
   
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * setProperty = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * tip = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    
    if (ID.length>0) {
        [tip setObject:ID forKey:@"push_city"];
    }
    
    
    
    if (!self.hum_l.length>0) {
        self.hum_l=@"";
    }
    if (!self.temp_h.length>0) {
        self.temp_h=@"";
    }
    if (!self.temp_l.length>0) {
        self.temp_l=@"";
    }
    if (!self.vis_l.length>0) {
        self.vis_l=@"";
    }
    
    [tip setObject:self.temp_h forKey:@"temp_h"];
    [tip setObject:self.temp_l forKey:@"temp_l"];
    [tip setObject:self.vis_l forKey:@"vis_l"];
    [tip setObject:self.hum_l forKey:@"hum_l"];
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
    
    if (!self.jieqi.length>0) {
        self.jieqi=@"1";
    }
    if (!self.jieri.length>0) {
        self.jieri=@"1";
    }
    if (!self.chanpin.length>0) {
        self.chanpin=@"1";
    }
    if (!self.zt.length>0) {
        self.zt=@"1";
    }
    [tip setObject:self.jieri forKey:@"tips_holiday"];
    [tip setObject:self.jieqi forKey:@"tips_jieqi"];
    [tip setObject:self.chanpin forKey:@"tips_notice"];
    [tip setObject:self.zt forKey:@"tips_special"];
    [setProperty setObject:tip forKey:@"tags"];
    [setProperty setObject:[setting sharedSetting].devToken forKey:@"token"];
    [b setObject:setProperty forKey:@"gz_set_pushtag"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        
        
    } withFailure:^(NSError *error) {
        
    } withCache:NO];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backAction{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
-(void)cityAction{
    SelectCityViewController *select=[[SelectCityViewController alloc]init];
    [select setDataSource: m_treeNodeProvince withCitys:m_treeNodeAllCity];
    [select setDelegate:self];
    select.type=@"tuisong";
    [self.navigationController pushViewController:select animated:YES];
}
-(void)switchAction:(UISwitch *)sender{
    
    NSString *isonswitch=nil;
    if (sender.on) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"TimePushNotification"];
        
        [[NSUserDefaults standardUserDefaults]setObject:self.formtime forKey:@"starttime"];
        [[NSUserDefaults standardUserDefaults]setObject:self.totime forKey:@"endtime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        isonswitch=@"1";
        
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"TimePushNotification"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        isonswitch=@"0";
    }
    NSString *form=[[NSUserDefaults standardUserDefaults]objectForKey:@"starttime"];
    NSString *to=[[NSUserDefaults standardUserDefaults]objectForKey:@"endtime"];
    if (!form.length>0) {
        form=@"00:00";
    }
    if (!to.length>0) {
        to=@"23:59";
    }
    if (form.length>0) {
        NSArray *timeArray1=[form componentsSeparatedByString:@":"];
        NSString *h=[timeArray1 objectAtIndex:0];
        NSString *m=[timeArray1 objectAtIndex:1];
        form=[NSString stringWithFormat:@"%@%@",h,m];
    }
    if (to.length>0) {
        NSArray *timeArray1=[to componentsSeparatedByString:@":"];
        NSString *h=[timeArray1 objectAtIndex:0];
        NSString *m=[timeArray1 objectAtIndex:1];
        to=[NSString stringWithFormat:@"%@%@",h,m];
    }
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * setProperty = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * tip = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    [tip setObject:isonswitch forKey:@"is_disturb"];
    [tip setObject:form forKey:@"disturb_start_time"];
    [tip setObject:to forKey:@"disturb_end_time"];
    [setProperty setObject:tip forKey:@"tags"];
    [setProperty setObject:[setting sharedSetting].devToken forKey:@"token"];
    [b setObject:setProperty forKey:@"gz_set_pushtag"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary *setpust=[b objectForKey:@"gz_set_pushtag"];
        NSString *result=[setpust objectForKey:@"result"];
        int is = [result intValue];
        NSString * error = [h objectForKey:@"error"];
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error) {
        
    } withCache:NO];
}
-(void)formAction{
    if (self.mswitch.on==YES) {
        if (!m_pickerView)
        {
            m_pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, pickbgview.bounds.size.height - 200, kScreenWidth, 200)];
            m_pickerView.tag=111;
            m_pickerView.dataSource = self;
            m_pickerView.delegate = self;
            m_pickerView.showsSelectionIndicator = YES;
            m_pickerView.backgroundColor=[UIColor whiteColor];
            [pickbgview addSubview:m_pickerView];
            [self.view addSubview:pickbgview];
            
        }
    }
    
}
-(void)toAction{
    if (self.mswitch.on==YES) {
    if (!m_pickerView)
    {
        m_pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, pickbgview.bounds.size.height - 200, kScreenWidth, 200)];
        m_pickerView.tag=222;
        m_pickerView.dataSource = self;
        m_pickerView.delegate = self;
        m_pickerView.showsSelectionIndicator = YES;
        m_pickerView.backgroundColor=[UIColor whiteColor];
        [pickbgview addSubview:m_pickerView];
        [self.view addSubview:pickbgview];
        
    }
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //	return [[pickerTitle objectAtIndex:component] count];
    NSArray *array=[pickerTitle objectAtIndex:component];
    return array.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    NSInteger row1 = [pickerView selectedRowInComponent:0];
    NSInteger row2 = [pickerView selectedRowInComponent:1];
    NSString *titlestr=[NSString stringWithFormat:@"%@:%@",[pickerTitle[0] objectAtIndex:row1],[pickerTitle[1] objectAtIndex:row2]];
    if (pickerView.tag==111) {
        [self.formbtn setTitle:titlestr forState:UIControlStateNormal];
        self.formtime=titlestr;
        
    }else if(pickerView.tag==222){
        [self.tobtn setTitle:titlestr forState:UIControlStateNormal];
        self.totime=titlestr;
    }
    [[NSUserDefaults standardUserDefaults]setObject:self.formtime forKey:@"starttime"];
    [[NSUserDefaults standardUserDefaults]setObject:self.totime forKey:@"endtime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self uploadtime:self.formtime with:self.totime];

}
-(void)uploadtime:(NSString *)form with:(NSString *)to{
   
    if (!form.length>0) {
        form=@"00:00";
    }
    if (!to.length>0) {
        to=@"23:59";
    }
    if (form.length>0) {
        NSArray *timeArray1=[form componentsSeparatedByString:@":"];
        NSString *h=[timeArray1 objectAtIndex:0];
        NSString *m=[timeArray1 objectAtIndex:1];
        form=[NSString stringWithFormat:@"%@%@",h,m];
    }
    if (to.length>0) {
        NSArray *timeArray1=[to componentsSeparatedByString:@":"];
        NSString *h=[timeArray1 objectAtIndex:0];
        NSString *m=[timeArray1 objectAtIndex:1];
        to=[NSString stringWithFormat:@"%@%@",h,m];
    }
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * setProperty = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * tip = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    [tip setObject:@"1" forKey:@"is_disturb"];
    [tip setObject:form forKey:@"disturb_start_time"];
    [tip setObject:to forKey:@"disturb_end_time"];
    [setProperty setObject:tip forKey:@"tags"];
    [setProperty setObject:[setting sharedSetting].devToken forKey:@"token"];
    [b setObject:setProperty forKey:@"gz_set_pushtag"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
//    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary *setpust=[b objectForKey:@"gz_set_pushtag"];
        NSString *result=[setpust objectForKey:@"result"];
        int is = [result intValue];
//        NSString * error = [h objectForKey:@"error"];
//        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error) {
        
    } withCache:NO];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[pickerTitle objectAtIndex:component] objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 100;
}

- (void)bgClicked
{
    if (m_pickerView) {
        [pickbgview removeFromSuperview];
        [m_pickerView removeFromSuperview];
        m_pickerView = nil;
    }
}
#pragma mark -tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * sectionDatas = [_datas objectAtIndex:section];
    return sectionDatas.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * sectionsDatas = [_datas objectAtIndex:indexPath.section];
    NSDictionary * rowDic = [sectionsDatas objectAtIndex:indexPath.row];
    MoreCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell = [[MoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.verticalLine.hidden = YES;
    cell.horizontalLine.hidden = YES;
    cell.logoImagV.image = [UIImage imageNamed:[rowDic objectForKey:@"Icon"]];
    cell.titleLab.text = [rowDic objectForKey:@"Title"];
    UIImageView *m_image = [[UIImageView alloc] init];
    [m_image setFrame:CGRectMake(10, 49, kScreenWidth-20, 1)];
    m_image.backgroundColor=[UIColor colorHelpWithRed:234 green:234 blue:234 alpha:1];
    [cell addSubview:m_image];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.section == 0)
//    {
//        switch (indexPath.row) {
//            case 0:
//                //天气闹钟
//                [self AlarmClock];
//                return;
//            case 1:
//                //自动分享
//                [self autoShare];
//                return;
//            case 2:
//                //更新频次设置
//                [self updateSetting];
//                return;
//        }
//    }
    if(indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
            {
                //预警信息推送
//                [self pushSetting];
                [self yujingPush];
                return;
            }
            case 2:
            {
                //温馨提示推送
              
                 [self pushSetting];
                return;
            }
            case 1:
            {
                //实况告警通知
                [self skyjPush];
                return;
            }

//            case 3:
//            {
//                //天气预报通知
//                 [self pushSetting];
//            }

        }
    }
}


//-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 20;
//}

-(void)updateSetting
{
    UpdateSettingViewController * updateSettingVC = [[UpdateSettingViewController alloc] init];
    [self.navigationController pushViewController:updateSettingVC animated:YES];
}
-(void)AlarmClock
{
   
}
-(void)autoShare
{
    AutoShareViewController * autoShareVC = [[AutoShareViewController alloc] init];
    [self.navigationController pushViewController:autoShareVC animated:YES];
}

-(void)pushSetting
{
    PushSettingViewController * pushSetting = [[PushSettingViewController alloc] init];
    [self.navigationController pushViewController:pushSetting animated:YES];
}

-(void)yujingPush
{
    YujingPushViewController * yujingPushVC = [[YujingPushViewController alloc] init];
    yujingPushVC.tsid=self.tsid;
    [self.navigationController pushViewController:yujingPushVC animated:YES];
}
-(void)tianqiyubaoPush
{
    TQYBViewController * tqybVC = [[TQYBViewController alloc] init];
    [self.navigationController pushViewController:tqybVC animated:YES];
}

-(void)skyjPush
{
    SKGJViewController * skgjVC = [[SKGJViewController alloc] init];
    skgjVC.tsid=self.tsid;
    [self.navigationController pushViewController:skgjVC animated:YES];
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
