//
//  SKGJViewController.m
//  ZtqCountry
//
//  Created by linxg on 14-8-28.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "SKGJViewController.h"
#import "SelectCityViewController.h"
@interface SKGJViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) UITableView * PushList;
@property (strong, nonatomic) UIButton * cityBut;
@property (strong, nonatomic) UITextField * WDUpTF;
@property (strong, nonatomic) UITextField * WDDownTF;
@property (strong, nonatomic) UISwitch * WDUpSwitch;
@property (strong, nonatomic) UISwitch * WDDownSwitch;
@property (strong, nonatomic) UITextField * NJDTF;
@property (strong, nonatomic) UISwitch * NJDSwitch;
@property (strong, nonatomic) UITextField * SDUpTF;
@property (strong, nonatomic) UISwitch * SDUpSwitch;
@property (strong, nonatomic) UITextField *SDDownTF;
@property (strong, nonatomic) UISwitch *SDDownSwitch;
@property (strong, nonatomic) UITextField * XSYLTF;
@property (strong, nonatomic) UISwitch * XSYLSwitch;
@property (strong, nonatomic) UITextField * FSTF;
@property (strong, nonatomic) UISwitch * FSSwitch;
@property (strong, nonatomic) UITableViewCell * currentCell;
@property (assign, nonatomic) CGRect originFrame;
@property (strong, nonatomic) UITextField * currentTF;


@property (strong, nonatomic) UIView * cityBg;
@property (strong, nonatomic) UITableView * cityList;
@property (strong, nonatomic) UIImageView * bgImgV;
@property (strong, nonatomic) UITapGestureRecognizer * tapGestureRecognizer;
@property (strong, nonatomic) NSDictionary * weatherInfo;

@end

@implementation SKGJViewController

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
    self.titleLab.text = @"实况告警推送";
    self.titleLab.textColor = [UIColor whiteColor];
    self.view.backgroundColor=[UIColor whiteColor];
    //    [self loadingSSTQ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Nowcity) name:@"NowYjCity" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendpushtosk) name:@"SKTS" object:nil];
    //    [self.leftBut addTarget:self action:@selector(LBAction:) forControlEvents:UIControlEventTouchUpInside];
    
    float w=kScreenWidth/3;
    UILabel *gjlab=[[UILabel alloc]initWithFrame:CGRectMake(0, self.barHeight, w, 30)];
    gjlab.text=@"告警类型";
    gjlab.textAlignment=NSTextAlignmentCenter;
    gjlab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:gjlab];
    UILabel *fzlab=[[UILabel alloc]initWithFrame:CGRectMake(w+0, self.barHeight, w, 30)];
    fzlab.text=@"阈值";
    fzlab.textAlignment=NSTextAlignmentCenter;
    fzlab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:fzlab];
    UILabel *ztlab=[[UILabel alloc]initWithFrame:CGRectMake(w*2+0, self.barHeight, w, 30)];
    ztlab.text=@"状态";
    ztlab.textAlignment=NSTextAlignmentCenter;
    ztlab.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:ztlab];
    
    _PushList = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight+50, kScreenWidth, kScreenHeitht-self.barHeight) style:UITableViewStylePlain];
    _PushList.separatorStyle=UITableViewCellSeparatorStyleNone;
    _PushList.delegate = self;
    _PushList.dataSource = self;
    
    [self.view addSubview:_PushList];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardTap:)];
    self.tapGestureRecognizer = tap;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
    
    
//    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
//    NSString *path = [docPath stringByAppendingPathComponent:@"SKPush"];
//    NSFileManager *fm = [NSFileManager defaultManager];
//    if([fm fileExistsAtPath:path] == NO)
//    {
//        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
//        [self configData];
//        
//        [self sendpush];
//    }
//    else{
        [self queryPushTag];
//        [self configData];
//    }
//    
}
-(void)sendpush{
    
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
    if (!self.hum_h.length>0) {
        self.hum_h=@"";
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
    [tip setObject:self.hum_h forKey:@"hum_l"];
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
-(void)sendpushtosk{
    
    [self configData];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"dwupPushNotification"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"wddownPushNotification"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"njdPushNotification"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"sdupPushNotification"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"sddownPushNotification"];
    [[NSUserDefaults standardUserDefaults] synchronize];
   
    
    [self.PushList reloadData];
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
                NSMutableDictionary * wdInfo = [[NSMutableDictionary alloc] init];
                if ([tagkey isEqualToString:@"hum_l"]) {
                    self.hum_h=tag_value;
                    if ([self.hum_h isEqualToString:@""]) {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"sdupPushNotification"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else{
                        [wdInfo setObject:self.hum_h forKey:@"UPVALUE"];
                        [self saveGaoJingInfoWithKey:@"SHIDUGAOJING" WithValue:wdInfo];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"sdupPushNotification"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                if ([tagkey isEqualToString:@"rain_h"]) {
                    self.rain_h=tag_value;
                    if ([self.rain_h isEqualToString:@""]) {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"xsylPushNotification"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else{
                        [wdInfo setObject:self.rain_h forKey:@"VALUE"];
                        [self saveGaoJingInfoWithKey:@"XIAOSHIYULIANGGAOJING" WithValue:wdInfo];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"xsylPushNotification"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                if ([tagkey isEqualToString:@"temp_h"]) {
                    self.temp_h=tag_value;
                    if ([self.temp_h isEqualToString:@""]) {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"dwupPushNotification"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else{
                        
                        
                        [wdInfo setObject:self.temp_h forKey:@"UPVALUE"];
                        [self saveGaoJingInfoWithKey:@"WENDUGAOJING" WithValue:wdInfo];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"dwupPushNotification"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                if ([tagkey isEqualToString:@"temp_l"]) {
                    self.temp_l=tag_value;
                    if ([self.temp_l isEqualToString:@""]) {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"wddownPushNotification"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else{
                        [wdInfo setObject:self.temp_l forKey:@"DOWNVALUE"];
                        [self saveGaoJingInfoWithKey:@"WENDUDIGAOJING" WithValue:wdInfo];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"wddownPushNotification"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                if ([tagkey isEqualToString:@"vis_l"]) {
                    self.vis_l=tag_value;
                    if ([self.vis_l isEqualToString:@""]) {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"njdPushNotification"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else{
                        [wdInfo setObject:self.vis_l forKey:@"VALUE"];
                        [self saveGaoJingInfoWithKey:@"NENGJIANDUGAOJING" WithValue:wdInfo];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"njdPushNotification"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
                if ([tagkey isEqualToString:@"hum_l"]) {
                    self.hum_l=tag_value;
                    if ([self.hum_l isEqualToString:@""]) {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"fsPushNotification"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }else{
                        [wdInfo setObject:self.hum_l forKey:@"VALUE"];
                        [self saveGaoJingInfoWithKey:@"FENGSU" WithValue:wdInfo];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"fsPushNotification"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
            }

            [self configData];

            [self sendpush];
            [self.PushList reloadData];
        }
        
    } withFailure:^(NSError *error) {
        
    } withCache:NO];
    
}
-(void)configData
{
   
    NSMutableDictionary * SKGJInfo = [[NSMutableDictionary alloc] init];
    //    if(!SKGJInfo)
    //    {
    
    //        SKGJInfo = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * gaojingchegnshi = [[NSMutableDictionary alloc] init];
    if (!self.tsid.length>0) {
        self.tsid=[setting sharedSetting].currentCityID;
    }
   
    [gaojingchegnshi setObject:self.tsid forKey:@"ID"];
    [SKGJInfo setObject:gaojingchegnshi forKey:@"GAOJINGCHENGSHI"];
    [[NSUserDefaults standardUserDefaults] setObject:SKGJInfo forKey:@"SKGJ"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.PushList reloadData];
    
    
    NSMutableDictionary * wdInfo = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * wdInfo1 = [[NSMutableDictionary alloc] init];
    NSString * wdUpValue = @"38";
    NSString * wdDownValue = @"5";
    if (self.temp_h.length>0) {
        wdUpValue=self.temp_h;
    }
    if (self.temp_l.length>0) {
        wdDownValue=self.temp_l;
    }
    BOOL wdUpState = NO;
    BOOL wdDownState = NO;
    [wdInfo setObject:wdUpValue forKey:@"UPVALUE"];
    [wdInfo setObject:[NSNumber numberWithBool:wdUpState] forKey:@"UPSTATE"];
    [wdInfo1 setObject:wdDownValue forKey:@"DOWNVALUE"];
    [wdInfo1 setObject:[NSNumber numberWithBool:wdDownState] forKey:@"DOWNSTATE"];
    [self saveGaoJingInfoWithKey:@"WENDUGAOJING" WithValue:wdInfo];
    [self saveGaoJingInfoWithKey:@"WENDUDIGAOJING" WithValue:wdInfo1];
    
    NSMutableDictionary * njdInfo = [[NSMutableDictionary alloc] init];
    NSString * njdValue = @"200";
    if (self.vis_l.length>0) {
        njdValue=self.vis_l;
    }
    BOOL njdState = NO;
    [njdInfo setObject:njdValue forKey:@"VALUE"];
    [njdInfo setObject:[NSNumber numberWithBool:njdState] forKey:@"STATE"];
    [self saveGaoJingInfoWithKey:@"NENGJIANDUGAOJING" WithValue:njdInfo];
    
    NSMutableDictionary * sdInfo = [[NSMutableDictionary alloc] init];
    NSString * sdUpValue = @"30";
    BOOL sdUpState = NO;
    NSString * sdDownValue = @"30";
    BOOL sdDownState = NO;
    if (self.hum_l.length>0) {
        sdUpValue=self.hum_l;
        sdDownValue=self.hum_l;
    }
    [sdInfo setObject:sdUpValue forKey:@"UPVALUE"];
    [sdInfo setObject:[NSNumber numberWithBool:sdUpState] forKey:@"UPSTATE"];
    [sdInfo setObject:sdDownValue forKey:@"DOWNVALUE"];
    [sdInfo setObject:[NSNumber numberWithBool:sdDownState] forKey:@"SDSTATE"];
    [self saveGaoJingInfoWithKey:@"SHIDUGAOJING" WithValue:sdInfo];
    
   }
-(void)Nowcity{
    [self configData];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"dwupPushNotification"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"wddownPushNotification"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"njdPushNotification"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"sdupPushNotification"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"sddownPushNotification"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString * name =nil;
    NSString * ID = nil;
    //    if (!name.length>0) {
    
    name=[setting sharedSetting].currentCity;
    
    ID=[setting sharedSetting].currentCityID;
    self.strid=ID;
    [self.cityBut setTitle:name forState:UIControlStateNormal];
    
    [self.PushList reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendbtn{
    self.isedit=NO;
    if (!self.tsid.length>0) {
        self.tsid=[setting sharedSetting].currentCityID;
    }
    NSString *wdup=[[NSUserDefaults standardUserDefaults]objectForKey:@"dwupPushNotification"];
    NSString *wddown=[[NSUserDefaults standardUserDefaults]objectForKey:@"wddownPushNotification"];
    NSString *visil=[[NSUserDefaults standardUserDefaults]objectForKey:@"njdPushNotification"];
    NSString *sd=[[NSUserDefaults standardUserDefaults]objectForKey:@"sdupPushNotification"];
    NSString *newwdup=[NSString stringWithFormat:@"%@",wdup];
    NSString *newwddown=[NSString stringWithFormat:@"%@",wddown];
    NSString *newvisil=[NSString stringWithFormat:@"%@",visil];
    NSString *newsd=[NSString stringWithFormat:@"%@",sd];
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * setProperty = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * tip = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    [tip setObject:self.tsid forKey:@"push_city"];
    if (wdup==nil||[newwdup isEqualToString:@"0"]) {
        self.temp_h=@"";
    }else{
        self.temp_h=self.WDUpTF.text;
    }
    if (wddown==nil||[newwddown isEqualToString:@"0"]) {
        self.temp_l=@"";
    }else{
        self.temp_l=self.WDDownTF.text;
    }
    if (visil==nil||[newvisil isEqualToString:@"0"]) {
        self.vis_l=@"";
    }else{
        self.vis_l=self.NJDTF.text;
    }
    if (sd==nil||[newsd isEqualToString:@"0"]) {
        self.hum_h=@"";
    }else{
        self.hum_h=self.SDUpTF.text;
    }
    
   
    
    [tip setObject:self.temp_h forKey:@"temp_h"];
    [tip setObject:self.temp_l forKey:@"temp_l"];
    [tip setObject:self.vis_l forKey:@"vis_l"];
    [tip setObject:self.hum_h forKey:@"hum_l"];
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
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    } withFailure:^(NSError *error) {
        
    } withCache:NO];
}

#pragma mark -TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    float w=kScreenWidth/3;
        switch (indexPath.row) {
            
            case 0:
            {
                //≥ ≤ ℃
                NSDictionary * WDInfo = [self getGaoJingInfoWithKey:@"WENDUGAOJING"];
                NSString * upValue = [WDInfo objectForKey:@"UPVALUE"];
                BOOL upState = [[WDInfo objectForKey:@"UPSTATE"] boolValue];
                NSDictionary * WDInfo1 = [self getGaoJingInfoWithKey:@"WENDUDIGAOJING"];
                NSString * downValue = [WDInfo1 objectForKey:@"DOWNVALUE"];
                BOOL downState = [[WDInfo1 objectForKey:@"DOWNSTATE"] boolValue];
                UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, w, 20)];
                titleLab.backgroundColor = [UIColor clearColor];
                titleLab.textColor = [UIColor blackColor];
                titleLab.textAlignment = NSTextAlignmentCenter;
                titleLab.font = [UIFont fontWithName:kBaseFont size:15];
                titleLab.text = @"气温";
                [cell.contentView addSubview:titleLab];
                
                UILabel * upSymbolLab = [[UILabel alloc] initWithFrame:CGRectMake(w+10, 10, 30, 20)];
                upSymbolLab.backgroundColor = [UIColor clearColor];
                upSymbolLab.textColor = [UIColor blackColor];
                upSymbolLab.textAlignment = NSTextAlignmentCenter;
                upSymbolLab.font = [UIFont fontWithName:kBaseFont size:15];
                upSymbolLab.text = @"高于";
                [cell.contentView addSubview:upSymbolLab];
                
                UITextField * upTF = [[UITextField alloc] initWithFrame:CGRectMake(w+40, 10, 50, 20)];
                self.WDUpTF = upTF;
                if(upValue)
                {
                    upTF.text = upValue;
                }
                upTF.textAlignment=NSTextAlignmentCenter;
                upTF.font=[UIFont fontWithName:kBaseFont size:13];
                upTF.borderStyle = UITextBorderStyleLine;
                upTF.tag = 10*indexPath.row+1;
                upTF.delegate = self;
                upTF.keyboardType = UIKeyboardTypeNumberPad;
                [cell.contentView addSubview:upTF];
                
                UILabel * upTemperatureSymbolLab = [[UILabel alloc] initWithFrame:CGRectMake(w+95, 10, 30, 20)];
                upTemperatureSymbolLab.backgroundColor = [UIColor clearColor];
                upTemperatureSymbolLab.textColor = [UIColor blackColor];
                upTemperatureSymbolLab.textAlignment = NSTextAlignmentLeft;
                upTemperatureSymbolLab.font = [UIFont fontWithName:kBaseFont size:15];
                upTemperatureSymbolLab.text = @"℃";
                [cell.contentView addSubview:upTemperatureSymbolLab];
                
                UISwitch * upSwith = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth-85, 5, 60, 30)];
                self.WDUpSwitch = upSwith;
                //                upSwith.on = upState;
                upSwith.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"dwupPushNotification"];
                upSwith.tag = 100*indexPath.row+1;
                [upSwith addTarget:self action:@selector(swithAction:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:upSwith];
                
                
                
                UILabel * downSymbolLab = [[UILabel alloc] initWithFrame:CGRectMake(w+10, 50, 30, 20)];
                downSymbolLab.backgroundColor = [UIColor clearColor];
                downSymbolLab.textColor = [UIColor blackColor];
                downSymbolLab.textAlignment = NSTextAlignmentCenter;
                downSymbolLab.font = [UIFont fontWithName:kBaseFont size:15];
                downSymbolLab.text = @"低于";
                [cell.contentView addSubview:downSymbolLab];
                
                UITextField * downTF = [[UITextField alloc] initWithFrame:CGRectMake(w+40, 50, 50, 20)];
                self.WDDownTF = downTF;
                if(downValue)
                {
                    downTF.text = downValue;
                }
                downTF.textAlignment=NSTextAlignmentCenter;
                downTF.font=[UIFont fontWithName:kBaseFont size:13];
                downTF.borderStyle = UITextBorderStyleLine;
                downTF.tag = 10*indexPath.row+2;
                downTF.delegate = self;
                downTF.keyboardType = UIKeyboardTypeNumberPad;
                [cell.contentView addSubview:downTF];
                
                UILabel * downTemperatureSymbolLab = [[UILabel alloc] initWithFrame:CGRectMake(w+95, 50, 30, 20)];
                downTemperatureSymbolLab.backgroundColor = [UIColor clearColor];
                downTemperatureSymbolLab.textColor = [UIColor blackColor];
                downTemperatureSymbolLab.textAlignment = NSTextAlignmentLeft;
                downTemperatureSymbolLab.font = [UIFont fontWithName:kBaseFont size:15];
                downTemperatureSymbolLab.text = @"℃";
                [cell.contentView addSubview:downTemperatureSymbolLab];
                
                UISwitch * downSwith = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth-85, 45, 60, 30)];
                self.WDDownSwitch = downSwith;
                //                downSwith.on = downState;
                downSwith.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"wddownPushNotification"];
                downSwith.tag = 100*indexPath.row+2;
                [downSwith addTarget:self action:@selector(swithAction:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:downSwith];
                UIImageView *m_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"灰色隔条.png"]];
                [m_image setFrame:CGRectMake(0, 99, kScreenWidth, 1)];
                [cell addSubview:m_image];
                return cell;
            }
            case 2:
            {
                //≥ ≤ ℃
                NSDictionary * WDInfo = [self getGaoJingInfoWithKey:@"NENGJIANDUGAOJING"];
                NSString * value = [WDInfo objectForKey:@"VALUE"];
                BOOL state = [[WDInfo objectForKey:@"STATE"] boolValue];
                
                UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, w, 20)];
                titleLab.backgroundColor = [UIColor clearColor];
                titleLab.textColor = [UIColor blackColor];
                titleLab.textAlignment = NSTextAlignmentCenter;
                titleLab.font = [UIFont fontWithName:kBaseFont size:15];
                titleLab.text = @"能见度";
                [cell.contentView addSubview:titleLab];
                
                UILabel * upSymbolLab = [[UILabel alloc] initWithFrame:CGRectMake(w+10, 10, 30, 20)];
                upSymbolLab.backgroundColor = [UIColor clearColor];
                upSymbolLab.textColor = [UIColor blackColor];
                upSymbolLab.textAlignment = NSTextAlignmentRight;
                upSymbolLab.font = [UIFont fontWithName:kBaseFont size:15];
                upSymbolLab.text = @"低于";
                [cell.contentView addSubview:upSymbolLab];
                
                UITextField * upTF = [[UITextField alloc] initWithFrame:CGRectMake(w+40, 10, 50, 20)];
                if(value)
                {
                    upTF.text = value;
                }
                upTF.textAlignment=NSTextAlignmentCenter;
                upTF.font=[UIFont fontWithName:kBaseFont size:13];
                upTF.borderStyle = UITextBorderStyleLine;
                self.NJDTF = upTF;
                upTF.tag = 10*indexPath.row+1;
                upTF.delegate = self;
                upTF.keyboardType = UIKeyboardTypeNumberPad;
                [cell.contentView addSubview:upTF];
                
                UILabel * upTemperatureSymbolLab = [[UILabel alloc] initWithFrame:CGRectMake(w+95, 10, 30, 20)];
                upTemperatureSymbolLab.backgroundColor = [UIColor clearColor];
                upTemperatureSymbolLab.textColor = [UIColor blackColor];
                upTemperatureSymbolLab.textAlignment = NSTextAlignmentLeft;
                upTemperatureSymbolLab.font = [UIFont fontWithName:kBaseFont size:15];
                upTemperatureSymbolLab.text = @"m";
                [cell.contentView addSubview:upTemperatureSymbolLab];
                
                UISwitch * upSwith = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth-85, 5, 60, 30)];
                self.NJDSwitch = upSwith;
                //                upSwith.on = state;
                upSwith.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"njdPushNotification"];
                upSwith.tag = 100*indexPath.row+1;
                [upSwith addTarget:self action:@selector(swithAction:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:upSwith];
                UIImageView *m_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"灰色隔条.png"]];
                [m_image setFrame:CGRectMake(0, 49, kScreenWidth, 1)];
                [cell addSubview:m_image];
                return cell;
                
            }
            case 1:
            {
                NSDictionary * SDInfo = [self getGaoJingInfoWithKey:@"SHIDUGAOJING"];
                NSString * upValue = [SDInfo objectForKey:@"UPVALUE"];
                
                UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, w, 20)];
                titleLab.backgroundColor = [UIColor clearColor];
                titleLab.textColor = [UIColor blackColor];
                titleLab.textAlignment = NSTextAlignmentCenter;
                titleLab.font = [UIFont fontWithName:kBaseFont size:15];
                titleLab.text = @"湿度";
                [cell.contentView addSubview:titleLab];
                
                UILabel * upSymbolLab = [[UILabel alloc] initWithFrame:CGRectMake(w+10, 10, 30, 20)];
                upSymbolLab.backgroundColor = [UIColor clearColor];
                upSymbolLab.textColor = [UIColor blackColor];
                upSymbolLab.textAlignment = NSTextAlignmentRight;
                upSymbolLab.font = [UIFont fontWithName:kBaseFont size:15];
                upSymbolLab.text = @"低于";
                [cell.contentView addSubview:upSymbolLab];
                
                UITextField * upTF = [[UITextField alloc] initWithFrame:CGRectMake(w+40, 10, 50, 20)];
                upTF.borderStyle = UITextBorderStyleLine;
                self.SDUpTF = upTF;
                if(upValue)
                {
                    upTF.text = upValue;
                }
                upTF.textAlignment=NSTextAlignmentCenter;
                upTF.font=[UIFont fontWithName:kBaseFont size:13];
                upTF.tag = 10*indexPath.row+1;
                upTF.delegate = self;
                upTF.keyboardType = UIKeyboardTypeNumberPad;
                [cell.contentView addSubview:upTF];
                
                UILabel * upTemperatureSymbolLab = [[UILabel alloc] initWithFrame:CGRectMake(w+95, 10, 30, 20)];
                upTemperatureSymbolLab.backgroundColor = [UIColor clearColor];
                upTemperatureSymbolLab.textColor = [UIColor blackColor];
                upTemperatureSymbolLab.textAlignment = NSTextAlignmentLeft;
                upTemperatureSymbolLab.font = [UIFont fontWithName:kBaseFont size:15];
                upTemperatureSymbolLab.text = @"%";
                [cell.contentView addSubview:upTemperatureSymbolLab];
                
                UISwitch * upSwith = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth-85, 5, 60, 30)];
                self.SDUpSwitch = upSwith;
                //                upSwith.on = upState;
                upSwith.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"sdupPushNotification"];
                upSwith.tag = 100*indexPath.row+1;
                [upSwith addTarget:self action:@selector(swithAction:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:upSwith];
             
                UIImageView *m_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"灰色隔条.png"]];
                [m_image setFrame:CGRectMake(0, 49, kScreenWidth, 1)];
                [cell addSubview:m_image];
                return cell;
                
            }
           
            default:
                return nil;
        }
        
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        if(indexPath.row ==0)
        {
            return 100;
        }
        else
        {
            return 50;
        }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}



#pragma mark -textFileDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    int tag = textField.tag/10;
    NSIndexPath * IP = [NSIndexPath indexPathForRow:tag inSection:0];
    UITableViewCell * cell = [self.PushList cellForRowAtIndexPath:IP];
    self.currentCell = cell;
    self.currentTF = textField;
    [self.PushList addGestureRecognizer:self.tapGestureRecognizer];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.isedit=YES;
    int tag = textField.tag/10;
    //    NSIndexPath * IP = [NSIndexPath indexPathForRow:tag inSection:0];
    //    UITableViewCell * cell = [self.PushList cellForRowAtIndexPath:IP];
    if (tag==2) {
        if (textField.text.integerValue>10000) {
            textField.text=@"10000";
        }
    }
    NSString * state = nil;
    NSInteger i=textField.tag;
    if(self.sender.on)
    {
        //        state = @"1";
        switch (i) {
            case 1:
                state=self.WDUpTF.text;
                break;
            case 2:
                state=self.WDDownTF.text;
                break;
            case 21:
                state=self.NJDTF.text;
                break;
            case 11:
                state=self.SDUpTF.text;
                break;
           
            default:
                break;
        }
        
    }
    else
    {
        state = @"";
    }
    if([textField isEqual:self.WDUpTF])
    {
        //温度大于
        
        [self setPropertywithValue:state withKey:@"temp_h" withView:nil];
        [[NSUserDefaults standardUserDefaults]setObject:self.WDUpTF.text forKey:@"wdup"];
        
    }
    if([textField isEqual:self.WDDownTF])
    {
        //        //温度小于
        
        [self setPropertywithValue:state withKey:@"temp_l" withView:nil];
        [[NSUserDefaults standardUserDefaults]setObject:self.WDDownTF.text forKey:@"wddown"];
        
    }
    if([textField isEqual:self.NJDTF])
    {
        //能见度
        
        [self setPropertywithValue:state withKey:@"vis_l" withView:nil];
        [[NSUserDefaults standardUserDefaults]setObject:self.NJDTF.text forKey:@"njd"];
        
    }
    if([textField isEqual:self.SDUpTF])
    {
        //湿度大于
        
        [self setPropertywithValue:state withKey:@"hum_h" withView:nil];
        [[NSUserDefaults standardUserDefaults]setObject:self.SDUpTF.text forKey:@"sdup"];
        
    }
    if([textField isEqual:self.SDDownTF])
    {
        //湿度小于
        
        [self setPropertywithValue:state withKey:@"hum_l" withView:nil];
        [[NSUserDefaults standardUserDefaults]setObject:self.SDDownTF.text forKey:@"sddown"];
        
    }
}






-(void)swithAction:(UISwitch *)sender
{
    self.isedit=YES;
    NSString * state = nil;
    NSInteger i=sender.tag;
    self.sender=sender;
    if(sender.on)
    {
        //        state = @"1";
        switch (i) {
            case 1:
                state=self.WDUpTF.text;
                break;
            case 2:
                state=self.WDDownTF.text;
                break;
            case 201:
                state=self.NJDTF.text;
                break;
            case 101:
                state=self.SDUpTF.text;
                break;
            default:
                break;
        }
        
    }
    else
    {
        state = @"";
    }
    if([sender isEqual:self.WDUpSwitch])
    {
        //温度大于
        
        [self setPropertywithValue:state withKey:@"temp_h" withView:nil];
        [[NSUserDefaults standardUserDefaults]setObject:self.WDUpTF.text forKey:@"wdup"];
        
    }
    if([sender isEqual:self.WDDownSwitch])
    {
        //        //温度小于
        
        [self setPropertywithValue:state withKey:@"temp_l" withView:nil];
        [[NSUserDefaults standardUserDefaults]setObject:self.WDDownTF.text forKey:@"wddown"];
        
    }
    if([sender isEqual:self.NJDSwitch])
    {
        //能见度
        
        [self setPropertywithValue:state withKey:@"vis_l" withView:nil];
        [[NSUserDefaults standardUserDefaults]setObject:self.NJDTF.text forKey:@"njd"];
        
    }
    if([sender isEqual:self.SDUpSwitch])
    {
        //湿度大于
        
        [self setPropertywithValue:state withKey:@"hum_h" withView:nil];
        [[NSUserDefaults standardUserDefaults]setObject:self.SDUpTF.text forKey:@"sdup"];
        
    }
    if([sender isEqual:self.SDDownSwitch])
    {
        //湿度小于
        
        [self setPropertywithValue:state withKey:@"hum_l" withView:nil];
        [[NSUserDefaults standardUserDefaults]setObject:self.SDDownTF.text forKey:@"sddown"];
        
    }
    if([sender isEqual:self.XSYLSwitch])
    {
        //小时雨量
        
        [self setPropertywithValue:state withKey:@"rain_h" withView:nil];
        [[NSUserDefaults standardUserDefaults]setObject:self.XSYLTF.text forKey:@"xsyl"];
    }
    if([sender isEqual:self.FSSwitch])
    {
        //风速
        
        [self setPropertywithValue:state withKey:@"wspeed_h" withView:nil];
        [[NSUserDefaults standardUserDefaults]setObject:self.FSTF.text forKey:@"fs"];
        
    }
}
-(void)setPropertywithValue:(NSString *)value withKey:(NSString *)key withView:(id)sender{
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
//    [tip setObject:cityid forKey:@"warning_city"];
//    [setProperty setObject:tip forKey:@"tags"];
//    [setProperty setObject:[setting sharedSetting].devToken forKey:@"token"];
//    [b setObject:setProperty forKey:@"setPushTag"];
//    [param setObject:h forKey:@"h"];
//    [param setObject:b forKey:@"b"];
//    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
//    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
//        [MBProgressHUD hideHUDForView:self.view animated:NO];
//        NSDictionary * b = [returnData objectForKey:@"b"];
//        NSDictionary *setpust=[b objectForKey:@"setPushTag"];
//        NSString *result=[setpust objectForKey:@"result"];
//        int is = [result intValue];
//        NSString * error = [h objectForKey:@"error"];
//        if(is ==1)
//        {
//            //成功
            if([key isEqualToString:@"temp_h"])
            {
                //hongse
                if([value isEqualToString:@""])
                {
                    //关
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"dwupPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else
                {
                    //开
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"dwupPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
            }
            if([key isEqualToString:@"temp_l"])
            {
                //
                if([value isEqualToString:@""])
                {
                    //关
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"wddownPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else
                {
                    //开
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"wddownPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
            }
            if([key isEqualToString:@"vis_l"])
            {
                //
                if([value isEqualToString:@""])
                {
                    //关
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"njdPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else
                {
                    //开
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"njdPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
            }
            if([key isEqualToString:@"hum_h"])
            {
                //
                if([value isEqualToString:@""])
                {
                    //关
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"sdupPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else
                {
                    //开
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"sdupPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
            }
            if([key isEqualToString:@"hum_l"])
            {
                //
                if([value isEqualToString:@""])
                {
                    //关
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"sddownPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else
                {
                    //开
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"sddownPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
            }
            if([key isEqualToString:@"rain_h"])
            {
                //
                if([value isEqualToString:@""])
                {
                    //关
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"xsylPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else
                {
                    //开
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"xsylPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
            }
            if([key isEqualToString:@"wspeed_h"])
            {
                //
                if([value isEqualToString:@""])
                {
                    //关
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"fsPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else
                {
                    //开
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"fsPushNotification"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
            }
            
            
//        }
//        else
//        {
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"知天气" message:@"设置失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//            //失败
//            
//            if([key isEqualToString:@"wdupstate"])
//            {
//                //节日
//                UISwitch * s = sender;
//                BOOL isOpen = s.on;
//                s.on = !isOpen;
//            }
//            if([key isEqualToString:@"wddownstate"])
//            {
//                //节气
//                UISwitch * s = sender;
//                BOOL isOpen = s.on;
//                s.on = !isOpen;
//            }
//            if([key isEqualToString:@"njdstate"])
//            {
//                //节气
//                UISwitch * s = sender;
//                BOOL isOpen = s.on;
//                s.on = !isOpen;
//            }
//            if([key isEqualToString:@"sdupstate"])
//            {
//                //节气
//                UISwitch * s = sender;
//                BOOL isOpen = s.on;
//                s.on = !isOpen;
//            }
//            if([key isEqualToString:@"sddownstate"])
//            {
//                //节气
//                UISwitch * s = sender;
//                BOOL isOpen = s.on;
//                s.on = !isOpen;
//            }
//            if([key isEqualToString:@"xsylstate"])
//            {
//                //节气
//                UISwitch * s = sender;
//                BOOL isOpen = s.on;
//                s.on = !isOpen;
//            }
//            if([key isEqualToString:@"fsstate"])
//            {
//                //节气
//                UISwitch * s = sender;
//                BOOL isOpen = s.on;
//                s.on = !isOpen;
//            }
//        }
//    } withFailure:^(NSError *error) {
//    } withCache:NO];
}
-(NSDictionary *)getGaoJingInfoWithKey:(NSString *)key
{
    NSMutableDictionary * SKGJInfo =[[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"SKGJ"]];
    NSDictionary * infoDic = [SKGJInfo objectForKey:key];
    return infoDic;
}

-(void)saveGaoJingInfoWithKey:(NSString *)key WithValue:(NSDictionary *)value
{
    NSMutableDictionary * SKGJInfo =[[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"SKGJ"]];
    [SKGJInfo setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:SKGJInfo forKey:@"SKGJ"];
}

-(void)backAction:(UIButton *)sender
{
    
    NSMutableDictionary * wdInfo = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * wdInfo1 = [[NSMutableDictionary alloc] init];
    NSString * wdUpValue = @"";
    NSString * wdDownValue = @"";
    if(self.WDUpTF.text)
    {
        wdUpValue = self.WDUpTF.text;
    }
    if(self.WDDownTF.text)
    {
        wdDownValue = self.WDDownTF.text;
    }
    BOOL wdUpState = self.WDUpSwitch.on;
    BOOL wdDownState = self.WDDownSwitch.on;
    [wdInfo setObject:wdUpValue forKey:@"UPVALUE"];
    [wdInfo setObject:[NSNumber numberWithBool:wdUpState] forKey:@"UPSTATE"];
    [wdInfo1 setObject:wdDownValue forKey:@"DOWNVALUE"];
    [wdInfo1 setObject:[NSNumber numberWithBool:wdDownState] forKey:@"DOWNSTATE"];
    [self saveGaoJingInfoWithKey:@"WENDUGAOJING" WithValue:wdInfo];
    [self saveGaoJingInfoWithKey:@"WENDUDIGAOJING" WithValue:wdInfo1];
    
    NSMutableDictionary * njdInfo = [[NSMutableDictionary alloc] init];
    NSString * njdValue = @"";
    if(self.NJDTF.text)
    {
        njdValue = self.NJDTF.text;
    }
    BOOL njdState = self.NJDSwitch.on;
    [njdInfo setObject:njdValue forKey:@"VALUE"];
    [njdInfo setObject:[NSNumber numberWithBool:njdState] forKey:@"STATE"];
    [self saveGaoJingInfoWithKey:@"NENGJIANDUGAOJING" WithValue:njdInfo];
    
    NSMutableDictionary * sdInfo = [[NSMutableDictionary alloc] init];
    NSString * sdUpValue = @"";
    if(self.SDUpTF.text)
    {
        sdUpValue = self.SDUpTF.text;
    }
    BOOL sdUpState = self.SDUpSwitch.on;
    
    [sdInfo setObject:sdUpValue forKey:@"UPVALUE"];
    [sdInfo setObject:[NSNumber numberWithBool:sdUpState] forKey:@"UPSTATE"];
    [self saveGaoJingInfoWithKey:@"SHIDUGAOJING" WithValue:sdInfo];
    
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
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


- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self changeShareContentHeight:keyboardRect.size.height withDuration:animationDuration];
    
    
    //	[self changeShareContentHeight:keyboardRect.size.height withDuration:animationDuration];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGRect keyboardRect = [animationDurationValue CGRectValue];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    //	[self changeShareContentHeight:keyboardRect.size.height withDuration:animationDuration];
    [self changeNewview];
    
}
#pragma mark keyboardWillhe
- (void)changeShareContentHeight:(float)t_height withDuration:(float)t_dration
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:t_dration];
    [UIView setAnimationDelegate:self];
    //    [self.table setFrame:CGRectMake(0, self.barHeight, kScreenWidth, CGRectGetHeight(self.view.frame)-300)];
    [_PushList setContentOffset:CGPointMake(0, 115)];
    _PushList.frame=CGRectMake(0, self.barHeight, kScreenWidth, 250);
    [UIView commitAnimations];
}
-(void)changeNewview
{
    _PushList.frame=CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-self.barHeight);
    [_PushList setContentOffset:CGPointMake(0, 0)];
    
}
//-(void)changeCellWithHeight:(float)height withDuration:(NSTimeInterval)animationDuration withCell:(UITableViewCell *)cell withState:(BOOL)isOpen;
//{
//    if(isOpen)
//    {
//         self.originFrame = cell.frame;
//        CGRect originFrame = [self.view convertRect:cell.frame fromView:self.PushList];
//        float distance = originFrame.origin.y+originFrame.size.height - (kScreenHeitht - height);
//        if(distance >0)
//        {
//            cell.layer.shadowColor = [UIColor blackColor].CGColor;
//            cell.layer.shadowOffset = CGSizeMake(1, 1);
//            cell.layer.shadowOpacity = 0.6;
//            cell.layer.shadowRadius = 1;
//            cell.transform = CGAffineTransformMakeScale(0.99, 0.99);
//            [cell.superview bringSubviewToFront:cell];
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//            [UIView setAnimationDuration:animationDuration];
//            cell.frame = CGRectOffset(self.originFrame, 0, -distance);
//            [UIView commitAnimations];
//        }
//    }
//    else
//    {
//        [UIView animateWithDuration:animationDuration animations:^{
//            cell.frame = self.originFrame;
//        } completion:^(BOOL finished) {
//            cell.transform = CGAffineTransformMakeScale(1, 1);
//            cell.layer.shadowColor = [UIColor clearColor].CGColor;
//        }];
//    }
//
//
//}


#pragma mark -本地通知
#pragma mark -本地通知

-(void)addTuisongWithInfo:(NSString *)info withTitle:(NSString *)title withClockID:(NSString *)clockID withFireDate:(NSDate *)fireDate
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        //        NSDate *now = [NSDate date];
        //从现在开始，10秒以后通知
        //             notification.fireDate = [NSDate dat]
        notification.repeatInterval = kCFCalendarUnitDay;
        //使用本地时区
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.alertBody=info;
        notification.fireDate = fireDate;
        
        
        //通知提示音 使用默认的
        notification.soundName= UILocalNotificationDefaultSoundName;
        notification.alertAction=@"关闭";
        //存入的字典，用于传入数据，区分多个通知
        NSMutableDictionary * dicUserInfo = [[NSMutableDictionary alloc] init];
        //        NSString * clockID = [NSString stringWithFormat:@"%@%@%@",self.cityBut.titleLabel.text,color,[ShareFun NSDateToNSString:now]];
        
        [dicUserInfo setValue:clockID forKey:@"clockID"];
        [dicUserInfo setValue:info forKey:@"message"];
        [dicUserInfo setValue:title forKey:@"title"];
        notification.userInfo = [NSDictionary dictionaryWithObject:dicUserInfo forKey:@"dictionary"];
        
        
        [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
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


-(void)tapAction:(UITapGestureRecognizer *)sender
{
    self.cityBg.hidden = YES;
}
-(void)loadingSSTQ
{
    NSMutableDictionary * SKGJInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"SKGJ"];
    NSDictionary * cityInfo = [SKGJInfo objectForKey:@"GAOJINGCHENGSHI"];
    
    NSString * currentID = [cityInfo objectForKey:@"ID"];
    //    NSDictionary * returnData = [[setting sharedSetting].DEMO_AllCitySstq objectForKey:currentID];
    //    NSDictionary * returnData = nil;
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * sstq = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    
    
    [sstq setObject:currentID forKey:@"area"];
    [b setObject:sstq forKey:@"sstq"];
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    NSLog(@"%@",param);
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSLog(@"success");
        //更新首界面1接界面
        self.weatherInfo = returnData;
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
    
    
    
    //    if(returnData)
    //    {
    //        NSDictionary * b = [returnData objectForKey:@"b"];
    //        NSDictionary * sstqAll = [b objectForKey:@"sstq"];
    //        NSDictionary * sstq = [sstqAll objectForKey:@"sstq"];
    //        NSString * week = [sstq objectForKey:@"week"];
    //        NSString * ct = [sstq objectForKey:@"ct"];
    //        NSString * wt_ico = [sstq objectForKey:@"wt_ico"];
    //        NSString * wind = [sstq objectForKey:@"wind"];
    //        NSString * wt_night = [sstq objectForKey:@"wt_night"];
    //        NSString * wt_daytime = [sstq objectForKey:@"wt_daytime"];
    //        NSString * humidity = [sstq objectForKey:@"humidity"];
    //        NSString * wt_night_ico = [sstq objectForKey:@"wt_night_ico"];
    //        NSString * wt_daytime_ico = [sstq objectForKey:@"wt_daytime_ico"];
    //        NSString * higt = [sstq objectForKey:@"higt"];
    //        NSString * lowt = [sstq objectForKey:@"lowt"];
    //        NSString * cityName = [sstq objectForKey:@"cityName"];
    //        NSString * visibilityNum = [sstq objectForKey:@"visibilityNum"];//可见度
    //        NSString * windSpeedNum = [sstq objectForKey:@"windSpeedNum"];
    //        NSString * humidityNum = [sstq objectForKey:@"humidityNum"];
    //        NSString * rainfallNum = [sstq objectForKey:@"rainfallNum"];
    //    }
}

-(void)keyboardTap:(UITapGestureRecognizer *)sender
{
    [self.currentTF resignFirstResponder];
    [self.PushList removeGestureRecognizer:self.tapGestureRecognizer];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
