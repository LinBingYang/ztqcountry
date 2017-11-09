//
//  SettingViewController.m
//  ZtqCountry
//
//  Created by linxg on 14-6-11.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "SettingViewController.h"
#import "SendFeedBack.h"
#import "aboutZTQ.h"
#import "AskQViewController.h"
#import "PushSettingViewController.h"
#import "AutoShareViewController.h"
#import "CustomAlert.h"
#import "MianzeViewController.h"
#import "Alert.h"
#import "LGViewController.h"
#import "SomeSettingViewController.h"
#import "SomeAboutViewController.h"
#import "XiaozhiTuijianViewController.h"
#import "PersonalCenterVC.h"
#import "MFSideMenuContainerViewController.h"
#import "GRZXViewController.h"
#import "UseringViewController.h"
#import "ZtqFjVC.h"
#import "UILabel+utils.h"
#import "WebViewController.h"
#import "EGOImageView.h"
#import "RmtjViewController.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) NSArray * settingTitles;
@property (strong, nonatomic) NSArray * settingLogos;
@property (strong, nonatomic) NSMutableArray * settingSwitchs,*sectitles;
@property (strong, nonatomic) CustomAlert * alert;
//@property (strong, nonatomic) UIAlertView * alert;
@property (strong, nonatomic) UILabel * userNameLab;
@property(strong,nonatomic)UIButton *titlebtn;
@property(strong,nonatomic)UIButton *loginbtn;
@property(strong,nonatomic)UIView *cacheview;
@property(nonatomic,strong) UILabel *nicknameLabel;
@property(strong,nonatomic)UIButton *lgbtn;
@property(nonatomic,strong) EGOImageView *tximg;

@property (nonatomic, assign)BOOL  ishot;
@property (nonatomic, strong)NSMutableArray *datasource;


@end

@implementation SettingViewController

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
    //    if(!kSystemVersionMore7)
    self.navigationController.navigationBar.translucent = NO;
    if (kSystemVersionMore7) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserName) name:@"myname" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NetFromHttpithType:) name:@"updataHotAction" object:nil];
    
    
    
	// Do any additional setup after loading the view.
//    UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht+20)];
//    bgimg.image=[UIImage imageNamed:@"cssz蓝色背景"];
//    bgimg.userInteractionEnabled=YES;
//    [self.view addSubview:bgimg];
    self.view.backgroundColor=[UIColor colorHelpWithRed:234 green:234 blue:234 alpha:1];
    self.appurls=[[NSMutableArray alloc]init];
//    [self creatViews];
    [self creatTabView];
    [self getgz_hot_app];
    [self NetFromHttpithType:nil];
    UISwipeGestureRecognizer * rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(centerViewControllerRighttSwiped:)];
    [rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:rightSwipeRecognizer];
}
-(void)creatTabView{
    UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    bgimg.image=[UIImage imageNamed:@"右侧背景.jpg"];
    bgimg.userInteractionEnabled=YES;
    [self.view addSubview:bgimg];
    
    UIButton *leftbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftbtn.frame=CGRectMake(15, 55,33, 35);
    [leftbtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftbtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [bgimg addSubview:leftbtn];
    
    UIImageView * userImageBg = [[UIImageView alloc] initWithFrame:CGRectMake(60+20, 50, 80, 80)];
    userImageBg.userInteractionEnabled = YES;
    userImageBg.image = [UIImage imageNamed:@"设置_03.png"];
    [self.view addSubview:userImageBg];
    
    
    UIButton * userBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
    userBut.layer.cornerRadius = 35;
    userBut.layer.masksToBounds = YES;
    self.titlebtn=userBut;
//    UIImage * userImg = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"currendIco"]];
//    if(userImg == nil)
//    {
//        userImg = [UIImage imageNamed:@"gzicon"];
//    }
//    [userBut setBackgroundImage:userImg forState:UIControlStateNormal];
    [userBut addTarget:self action:@selector(userButAction:) forControlEvents:UIControlEventTouchUpInside];
    [userImageBg addSubview:userBut];
    leftbtn.centerY=userImageBg.centerY;

    UIImage * userImg = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"currendIco"]];
    EGOImageView *tximg=[[EGOImageView alloc]initWithFrame:userBut.bounds];
        self.tximg=tximg;
    if(userImg!=nil){
        tximg.image=userImg;
    }else{
        tximg.image=[UIImage imageNamed:@"知天气头像"];
    }
    tximg.contentMode=UIViewContentModeScaleAspectFill;
    tximg.layer.cornerRadius=tximg.width*0.5;
    tximg.layer.masksToBounds=YES;
    [userBut addSubview:tximg];
    
    UIButton *logbtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(userImageBg.frame)+20, 77, 65, 26)];
    self.lgbtn=logbtn;
    [self.lgbtn setTitle:@"登录" forState:UIControlStateNormal];
    logbtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [logbtn setBackgroundImage:[UIImage imageNamed:@"个人中心登录按钮常态"] forState:UIControlStateNormal];
    [logbtn setBackgroundImage:[UIImage imageNamed:@"个人中心登录按钮点击态"] forState:UIControlStateHighlighted];
    [logbtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logbtn];
    
    UILabel *nicknameLabel=[[UILabel alloc]init];
    nicknameLabel.x=logbtn.x;
//    logbtn.x=kScreenWidth-130;
    nicknameLabel.y=77;
    nicknameLabel.width=90;
    nicknameLabel.height=84;
    nicknameLabel.centerY=_lgbtn.centerY;
//        nicknameLabel.backgroundColor=[UIColor redColor];
    self.nicknameLabel=nicknameLabel;
    nicknameLabel.textColor=[UIColor whiteColor];
    nicknameLabel.font=[UIFont systemFontOfSize:15];
    nicknameLabel.numberOfLines=0;
    nicknameLabel.hidden=YES;
    nicknameLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:nicknameLabel];
    
    NSString * userNameStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"sjusername"];
    if (userNameStr.length>0) {
         [self.loginbtn setTitle:@"退出" forState:UIControlStateNormal];
//       float w=[self.loginbtn.titleLabel labelLength:userNameStr withFont:[UIFont systemFontOfSize:14]];
//        self.loginbtn.frame=CGRectMake((kScreenWidth-50-w-10)/2, 133, w+10, 26);
    }
    
    
    self.settingTitles=[[NSArray alloc]initWithObjects:@"关于知天气",@"推送设置",@"使用指南",@"意见反馈",@"清除缓存",@"热门推荐",  nil];
//    self.sectitles=[[NSArray alloc]initWithObjects:@"知天气-福建",@"气象服务网",@"全媒体传播", nil];
    self.sectitles=[[NSMutableArray alloc]initWithObjects:@"知天气-福建",@"农气宝", nil];
    self.settingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, kScreenWidth-50, kScreenHeitht-130) style:UITableViewStylePlain];
    self.settingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.settingTable.backgroundColor=[UIColor clearColor];
    self.settingTable.backgroundView=nil;
    self.settingTable.autoresizesSubviews = YES;
    self.settingTable.showsHorizontalScrollIndicator = YES;
    self.settingTable.showsVerticalScrollIndicator = YES;
    self.settingTable.delegate = self;
    self.settingTable.dataSource = self;
    [self.view addSubview:self.settingTable];
    [self updateUserName];
    
}

#pragma mark - NetWork

- (void)NetFromHttpithType:(NSString *)type {
    
    NSDictionary *p = @{@"p":[setting sharedSetting].app};
    NSDictionary *tdc  = @{@"type" : @"1"};
    NSDictionary *gz_hot_recommend = @{@"gz_hot_recommend": tdc};
    NSDictionary *pra = @{@"h" : p, @"b": gz_hot_recommend};
    
    
    [[NetWorkCenter share] postHttpWithUrl:URL_SERVER withParam: pra withFlag:0 withSuccess:^(NSDictionary *returnData) {
        NSDictionary *b = returnData[@"b"];
        NSDictionary *gz_hot_recommend = b[@"gz_hot_recommend"];
        NSArray *info_list = gz_hot_recommend[@"info_list"];
        self.datasource = [info_list mutableCopy];
//        [self.tableView reloadData];
        for (NSDictionary *obj in info_list) {
            NSString *hot = obj[@"hot"];
            if (hot.intValue == 1) {
                self.ishot = YES;
                break;
            }
        }
        [self.settingTable reloadData];
        
        
    } withFailure:^(NSError *error) {
        
    } withCache:NO];
    
}



-(void)getgz_hot_app{
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *qxfw_product = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [qxfw_product setObject:@"5" forKey:@"app_type"];
    [t_b setObject:qxfw_product forKey:@"gz_hot_app"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    
   
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:0 withSuccess:^(NSDictionary *returnData) {
        //        NSLog(@"%@",returnData);
        NSDictionary *b=[returnData objectForKey:@"b"];
        NSDictionary *qxfw_sel=[b objectForKey:@"gz_hot_app"];
        NSArray *list=[qxfw_sel objectForKey:@"app_list"];
        
        for (int i=0; i<list.count; i++) {
            NSString *name=[list[i] objectForKey:@"name"];
            NSString *url=[list[i] objectForKey:@"url"];
            [self.sectitles addObject:name];
            [self.appurls addObject:url];
        }
        
        [self.settingTable reloadData];
    } withFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        
    } withCache:YES];
}
-(void)centerViewControllerRighttSwiped:(id)sender{
    MFSideMenuContainerViewController * container =[self.navigationController.viewControllers objectAtIndex:1];
    [container togleCenterViewController];
}

-(void)creatViews
{
    
    UIImageView * userImageBg = [[UIImageView alloc] initWithFrame:CGRectMake(95, 40, 80, 80)];
    userImageBg.userInteractionEnabled = YES;
    userImageBg.image = [UIImage imageNamed:@"设置_03.png"];
    [self.view addSubview:userImageBg];
    
    UIButton * userBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
    userBut.layer.cornerRadius = 35;
    userBut.layer.masksToBounds = YES;
    self.titlebtn=userBut;
    UIImage * userImg = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"currendIco"]];
    if(userImg == nil)
    {
        userImg = [UIImage imageNamed:@"gzicon"];
    }
    [userBut setBackgroundImage:userImg forState:UIControlStateNormal];
    [userBut addTarget:self action:@selector(userButAction:) forControlEvents:UIControlEventTouchUpInside];
    [userImageBg addSubview:userBut];
    
    UILabel * userNameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, kScreenWidth-50, 20)];
    self.userNameLab = userNameLab;
    userNameLab.backgroundColor = [UIColor clearColor];
    userNameLab.textColor = [UIColor whiteColor];
    userNameLab.font = [UIFont fontWithName:kBaseFont size:15];
    userNameLab.textAlignment = NSTextAlignmentCenter;
    NSString * userNameStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"currendUserName"];
    userNameLab.text = userNameStr;
    [self.view addSubview:userNameLab];
    
    
    UIButton * settingBut = [[UIButton alloc] initWithFrame:CGRectMake(40, 190, 50, 50)];
    [settingBut setBackgroundImage:[UIImage imageNamed:@"设置_07.png"] forState:UIControlStateNormal];
    [settingBut addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBut];
    
    UILabel * settingLab =  [[UILabel alloc] initWithFrame:CGRectMake(20, 260, 90, 20)];
    settingLab.text = @"设置";
    settingLab.backgroundColor = [UIColor clearColor];
    settingLab.textColor = [UIColor whiteColor];
    settingLab.font = [UIFont fontWithName:kBaseFont size:15];
    settingLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:settingLab];
    
    
    UIButton * versionBut = [[UIButton alloc] initWithFrame:CGRectMake(180, 190, 50, 50)];
    [versionBut setBackgroundImage:[UIImage imageNamed:@"设置_10.png"] forState:UIControlStateNormal];
    [versionBut addTarget:self action:@selector(versionAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:versionBut];
    
    UILabel * versionLab =  [[UILabel alloc] initWithFrame:CGRectMake(160, 260, 90, 20)];
    versionLab.text = @"版本检测";
    versionLab.backgroundColor = [UIColor clearColor];
    versionLab.textColor = [UIColor whiteColor];
    versionLab.font = [UIFont fontWithName:kBaseFont size:15];
    versionLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLab];
    
    UIButton * friendBut = [[UIButton alloc] initWithFrame:CGRectMake(46, 310, 37, 50)];
    [friendBut setBackgroundImage:[UIImage imageNamed:@"设置_18.png"] forState:UIControlStateNormal];
    [friendBut addTarget:self action:@selector(friendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:friendBut];
    
    UILabel * friendLab =  [[UILabel alloc] initWithFrame:CGRectMake(20, 380, 90, 20)];
    friendLab.text = @"推荐好友";
    friendLab.backgroundColor = [UIColor clearColor];
    friendLab.textColor = [UIColor whiteColor];
    friendLab.font = [UIFont fontWithName:kBaseFont size:15];
    friendLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:friendLab];
    
    
    UIButton * aboutBut = [[UIButton alloc] initWithFrame:CGRectMake(180, 310, 50, 50)];
    [aboutBut setBackgroundImage:[UIImage imageNamed:@"设置_15.png"] forState:UIControlStateNormal];
    [aboutBut addTarget:self action:@selector(aboutAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aboutBut];
    
    UILabel * abooutLab =  [[UILabel alloc] initWithFrame:CGRectMake(160, 380, 90, 20)];
    abooutLab.text = @"关于";
    abooutLab.backgroundColor = [UIColor clearColor];
    abooutLab.textColor = [UIColor whiteColor];
    abooutLab.font = [UIFont fontWithName:kBaseFont size:15];
    abooutLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:abooutLab];
    
    
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeitht-50, kScreenWidth-50, 1)];
    line.backgroundColor = [UIColor whiteColor];
    line.alpha = 0.3;
    [self.view addSubview:line];
    
    UIImageView * recommendLogo = [[UIImageView alloc] initWithFrame:CGRectMake((135-16)/2.0, kScreenHeitht-50+10, 16, 16)];
    recommendLogo.image = [UIImage imageNamed:@"设置_26.png"];
    [self.view addSubview:recommendLogo];
    
    UILabel * recommendLab = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeitht-50+30, 135, 20)];
    recommendLab.text = @"软件推荐";
    recommendLab.backgroundColor = [UIColor clearColor];
    recommendLab.textColor = [UIColor whiteColor];
    recommendLab.font = [UIFont fontWithName:kBaseFont size:13];
    recommendLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:recommendLab];
    
    UIButton * recommendBut = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeitht-50, 135, 50)];
    [recommendBut addTarget:self action:@selector(recommendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recommendBut];
    
    UIImageView * verticalImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(135, kScreenHeitht-50+5, 1, 40)];
    verticalImg1.backgroundColor = [UIColor whiteColor];
    verticalImg1.alpha = 0.3;
    [self.view addSubview:verticalImg1];
    
    
    
    UIImageView * adviceLogo = [[UIImageView alloc] initWithFrame:CGRectMake((135-16)/2.0+135, kScreenHeitht-50+10, 16, 16)];
    adviceLogo.image = [UIImage imageNamed:@"设置_23.png"];
    [self.view addSubview:adviceLogo];
    
    UILabel * adviceLab = [[UILabel alloc] initWithFrame:CGRectMake(135, kScreenHeitht-50+30, 135, 20)];
    adviceLab.text = @"您的建议";
    adviceLab.backgroundColor = [UIColor clearColor];
    adviceLab.textColor = [UIColor whiteColor];
    adviceLab.font = [UIFont fontWithName:kBaseFont size:13];
    adviceLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:adviceLab];
    
    UIButton * adviceBut = [[UIButton alloc] initWithFrame:CGRectMake(135, kScreenHeitht-50, 135, 50)];
    [adviceBut addTarget:self action:@selector(adviceAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:adviceBut];
    
    UIImageView * verticalImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(270, kScreenHeitht-50+5, 1, 40)];
    verticalImg2.backgroundColor = [UIColor whiteColor];
    verticalImg2.alpha = 0.3;
    [self.view addSubview:verticalImg2];
    
    
    
    
    UIImageView * backLogo = [[UIImageView alloc] initWithFrame:CGRectMake(110, 150, 20, 20)];
    backLogo.image = [UIImage imageNamed:@"设置_29.png"];
    [self.view addSubview:backLogo];
    
    UILabel * backLab = [[UILabel alloc] initWithFrame:CGRectMake(140, 150, 90, 20)];
    backLab.text = @"注销";
    backLab.backgroundColor = [UIColor clearColor];
    backLab.textColor = [UIColor whiteColor];
    backLab.font = [UIFont fontWithName:kBaseFont size:14];
    backLab.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:backLab];
    
    UIButton * backBut = [[UIButton alloc] initWithFrame:CGRectMake(110, 150, 90, 50)];
    [backBut addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBut];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark -UITableDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return _settingTitles.count;
    }else{
        return _sectitles.count;
    }
    return _settingTitles.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    NSString *t_str = [NSString stringWithFormat:@"%ld_%ld", (long)section, (long)row];
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:t_str];
    if (cell != nil)
        [cell removeFromSuperview];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t_str];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    UIImageView *icoimg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 40, 40)];
    [cell addSubview:icoimg];
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(80, 10, 200, 30)];
    lab.textColor=[UIColor blackColor];
    [cell addSubview:lab];
    if (section==0) {
        
        icoimg.image=[UIImage imageNamed:self.settingTitles[row]];
        lab.text=self.settingTitles[row];
        if (indexPath.row == 5 && self.ishot == YES) {
//            UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 30, 30)];
//            lab1.text = @"hot";
//            lab1.font = [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:14];
//            lab1.textColor = [UIColor redColor];
//            [lab addSubview:lab1];
            UIImageView *hotimagev=[[UIImageView alloc] initWithFrame:CGRectMake(lab.frame.size.width-50, 0, 30, 30)];
            hotimagev.image=[UIImage imageNamed:@"hot图标.png"];
            [lab addSubview:hotimagev];
        }
        
    }
    if (section==1) {
        icoimg.image=[UIImage imageNamed:self.sectitles[row]];
        if (row==2) {
            icoimg.image=[UIImage imageNamed:@"应用1"];
        }
        if (row==3) {
            icoimg.image=[UIImage imageNamed:@"应用2"];
        }
        lab.text=self.sectitles[row];
        if (indexPath.row==0) {
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(180, 10, 200, 30)];
            lab.textColor=[UIColor blackColor];
            lab.font=[UIFont systemFontOfSize:12];
            lab.text=@"决策行业版";
            [cell addSubview:lab];
        }
    }
    if (row!=self.settingTitles.count-1) {
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(10, 49, kScreenWidth-75, 1)];
        line.backgroundColor=[UIColor colorHelpWithRed:234 green:234 blue:234 alpha:1];
        [cell addSubview:line];
    }
   
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0) {
        UIView *bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 20)];
        lab.text=@"友情链接";
        lab.textColor=[UIColor grayColor];
        lab.font=[UIFont systemFontOfSize:14];
        [bg addSubview:lab];
        return bg;
    }
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//   self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    NSLog(@"%d,%d",indexPath.section,indexPath.row);
    if(indexPath.section==0)
    {
        //标题
        if (indexPath.row==1) {
            SomeSettingViewController * someSettingVC = [[SomeSettingViewController alloc] init];
            [self.navigationController pushViewController:someSettingVC animated:YES];
        }
        if (indexPath.row==0) {
            aboutZTQ *abztq=[[aboutZTQ alloc]init];
            [self.navigationController pushViewController:abztq animated:YES];
        }
        if (indexPath.row==2) {
//            NSLog(@"使用指南");
            UseringViewController *uservc=[[UseringViewController alloc]init];
            [self.navigationController pushViewController:uservc animated:YES];
        }
        if (indexPath.row==3) {
            [self sendAD];
        }
//        if (indexPath.row==4) {
//            [self versionDetection];
//        }
        if (indexPath.row==4) {
//            NSLog(@"清除缓存");
            UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"是否清除缓存" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
            al.tag=3000;
            [al show];
           
        }
        if (indexPath.row==5) {
           
            RmtjViewController *rmtjVC = [[RmtjViewController alloc]init];
            rmtjVC.dataSource = self.datasource;
            [self.navigationController pushViewController:rmtjVC animated:YES];
            
        }
        
    }
    if(indexPath.section==1)
    {
        if (indexPath.row==0) {
            NSURL *appUrl = [NSURL URLWithString:@"com.app.ztq://ztq"];
            BOOL isExist = [[UIApplication sharedApplication]canOpenURL:appUrl];
            if (isExist==YES) {
                NSURL *Url = [NSURL URLWithString:@"com.app.ztq://ztq"];
                [[UIApplication sharedApplication]openURL:Url];
            }else{
                trackViewURL=@"https://itunes.apple.com/cn/app/zhi-tian-qi-zhang-shang-qi/id451961462?mt=8";
                NSURL *url = [NSURL URLWithString:trackViewURL];
                [[UIApplication sharedApplication]openURL:url];
            }
        }
        if (indexPath.row==1) {
            NSURL *appUrl = [NSURL URLWithString:@"com.pcs.zhny://zhny"];
            BOOL isExist = [[UIApplication sharedApplication]canOpenURL:appUrl];
            if (isExist==YES) {
                NSURL *Url = [NSURL URLWithString:@"com.pcs.zhny://zhny"];
                [[UIApplication sharedApplication]openURL:Url];
            }else{
                NSString *urlstr=@"https://itunes.apple.com/cn/app/zhi-hui-nong-ye/id1139982137?mt=8";
                NSURL *url = [NSURL URLWithString:urlstr];
                [[UIApplication sharedApplication]openURL:url];
            }
        }
        if (indexPath.row==2) {
            WebViewController *adVC = [[WebViewController alloc]init];
            adVC.url =self.appurls[indexPath.row-1];
            adVC.titleString =self.sectitles[indexPath.row];
            [self.navigationController pushViewController:adVC animated:YES];
        }
        if (indexPath.row==3) {
            WebViewController *adVC = [[WebViewController alloc]init];
            adVC.url = self.appurls[indexPath.row-1];
            adVC.titleString =self.sectitles[indexPath.row];
            [self.navigationController pushViewController:adVC animated:YES];
        }
    }
}
-(void)leftAction{
    MFSideMenuContainerViewController * container =[self.navigationController.viewControllers objectAtIndex:1];
    [container togleCenterViewController];
}
-(void)pushSetting
{
    PushSettingViewController * pushSetting = [[PushSettingViewController alloc] init];
    [self.navigationController pushViewController:pushSetting animated:YES];
}

-(void)autoShare
{
    AutoShareViewController * autoShareVC = [[AutoShareViewController alloc] init];
    [self.navigationController pushViewController:autoShareVC animated:YES];
}
//推荐好友使用
-(void)tuiJianHaoYou
{
    
    //[ShareFun sendSMS:nil withContent:TEXT_SHARE_SMS];
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    
    if([messageClass canSendText])
        
    {
        
        
        NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
        NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
        NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
        NSMutableDictionary *getrecommendfriendsmsg = [NSMutableDictionary dictionaryWithCapacity:4];
        [t_h setObject:[setting sharedSetting].app forKey:@"p"];
        [getrecommendfriendsmsg setObject:@"1" forKey:@"type"];
        [t_b setObject:getrecommendfriendsmsg forKey:@"getrecommendfriendsmsg"];
        [t_dic setObject:t_h forKey:@"h"];
        [t_dic setObject:t_b forKey:@"b"];
        [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
            // NSLog(@"%@",returnData);
            
            
            NSDictionary *t_b = [returnData objectForKey:@"b"];
            
            if (t_b != nil)
            {
                NSDictionary *getFocusList=[t_b objectForKey:@"getrecommendfriendsmsg"];
                NSString *result=[getFocusList objectForKey:@"result"];
                self.duanxinstr=result;
                NSLog(@"%@",result);
            }
            //        [self.table reloadData];
            
        } withFailure:^(NSError *error) {
            NSLog(@"failure");
            
        } withCache:YES];

        
        
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
        controller.body = self.duanxinstr;
//        controller.recipients = @[@"13627988632",@"13627988567",@"13627988980"];
        controller.messageComposeDelegate = self;
        
        [self presentViewController:controller animated:YES completion:nil];
        
    }else
	{
		UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"不能发送，该设备不支持短信功能" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
		[t_alertView show];
        
	}
    
}
//短信取消
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    //       [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//常见问题
-(void)quest{
    AskQViewController *ask=[[AskQViewController alloc]init];
    [self.navigationController pushViewController:ask animated:YES];
}
//清理缓存
-(void)cleanCache{
    UIView *mb=[[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [(UIActivityIndicatorView *)mb startAnimating];
    self.cleanview1=[[CleanCanche alloc]initWithview:mb withTitle:@"缓存清理中" withtype:nil];
    [self.cleanview1 show];
//    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"缓存清理中" animated:YES];
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%lu",(unsigned long)[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                      
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
                   });
}
-(void)clearCacheSuccess{
    
     [self performSelector:@selector(cleansuccess) withObject:nil afterDelay:1];
    
}
-(void)cleansuccess{
//    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [self.cleanview1 hideenview];
//    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"缓存清理完成" animated:NO];
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    img.image=[UIImage imageNamed:@"缓存清理完成"];
    self.cleanview=[[CleanCanche alloc]initWithview:img withTitle:@"缓存清理完成" withtype:nil];
    [self.cleanview show];
    
    [self performSelector:@selector(cleandone) withObject:nil afterDelay:1];
    
}
-(void)cleandone{
    [self.cleanview hideenview];
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"缓存清理成功");
}
//意见反馈
-(void)sendAD{
    SendFeedBack *send=[[SendFeedBack alloc]init];
    [self.navigationController pushViewController:send animated:YES];
}
//关于
-(void)abt{
    aboutZTQ *aboutztq=[[aboutZTQ alloc]init];
    aboutztq.content = [NSString stringWithFormat:@"%@", @"       “知天气”是国内首款汇聚了各省特色气象信息资源的气象客户端，由各省气象局联合打造，为全国用户提供最及时、最丰富、最实用、最专业的气象服务。"];
    [self.navigationController pushViewController:aboutztq animated:YES];
}
//免责
-(void)mianze{
    //    CGRect t_frame = CGRectMake(0, 0, 320,kScreenHeitht);
    //
    //    NSString *k_title = @"免责声明";
    //    NSString *c_title = [NSString stringWithFormat:@"       1、 “知天气”提供的天气预报信息产品服务仅供用户作为生活、生产等活动的参考信息，用户据此作出的行为及所产生的后果与“知天气”及其关联的单位无关。\n       2、 由于不可抗力或互联网传输原因等造成信息传播的延迟、中断和缺失，“知天气”不承担任何责任。因不可预测或无法控制的系统故障、设备故障、通讯故障等原因给用户造成损失的，“知天气”不承担任何的赔偿责任。\n       3、 “知天气”努力给用户提供及时、准确的天气信息产品服务，但不承担因预报准确率原因引起的任何损失、损害。您在使用“知天气”时可能产生的GPRS流量资费各地不同，由当地运营商收取。\n       4、 “知天气”掌上气象提供的所有数据仅供参考，不具备法律效力，不得挪为他用。\n       5、 本声明的最终解释权归“知天气”所有。\n       以上风险提示，您已阅读并理解，如果继续使用，即表明您同意承担使用“知天气”所有服务可能存在的风险。"];
    //    about = [[AboutView alloc] initWithView:k_title setMessage:c_title setRect:t_frame];
    //    [about show];
    MianzeViewController * mianzeVC = [[MianzeViewController alloc] init];
    [self.navigationController pushViewController:mianzeVC animated:YES];
}



-(void)versionDetection
{
//    _alert = [[CustomAlert alloc] initWithMessage:@"正在检测新版本...."];
//    [_alert show];
    //    _alert = [[UIAlertView alloc] initWithTitle:nil message:@"正在检测新版本..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    //    [_alert show];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [self performSelector:@selector(showJianceJieguo) withObject:nil afterDelay:0];
    
    
}

-(void)showJianceJieguo
{
    
    [_alert hide];
    //    _alert = nil;
    //    [_alert removeFromSuperview];
    //    _alert.hidden = YES;
//    UIAlertView *alretview=[[UIAlertView alloc]initWithTitle:nil message:@"当前已经是最新版本" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//    [alretview show];
    
    
    [[NetWorkCenter share] postVersionWithSuccess:^(NSDictionary *returnData) {
//        NSLog(@"%@",returnData);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *infoArray = [returnData objectForKey:@"results"];
        if ([infoArray count]) {
            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
            NSString *message;
            NSString *lastVersion = [releaseInfo objectForKey:@"version"];
            NSString *currentVersion=[ShareFun localVersion];
            NSString *cv=[currentVersion substringToIndex:1];
            NSString *lv=[lastVersion substringToIndex:1];
            if (cv.integerValue <lv.integerValue) {
                trackViewURL = [releaseInfo objectForKey:@"trackViewUrl"];
                NSString *title=[NSString stringWithFormat:@"知天气%@发布日志",lastVersion];
                message=[releaseInfo objectForKey:@"releaseNotes"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
                alert.tag = 10000;
                [alert show];
                
            }
            else
            {
                                [ShareFun alertNotice:@"知天气" withMSG:@"您现在的“知天气”版本为最新版本，无需更新！" cancleButtonTitle:@"确定" otherButtonTitle:nil];
//                Alert * alert = [[Alert alloc] initWithLogoImage:@"logo.png" withTitle:@"检测新版本" withContent:@"当前已经是最新版本"];
//                [alert show];
            }
            
        }else{
                        [ShareFun alertNotice:@"知天气" withMSG:@"更新失败！" cancleButtonTitle:@"确定" otherButtonTitle:nil];
//            Alert * alert = [[Alert alloc] initWithLogoImage:@"logo.png" withTitle:@"知天气" withContent:@"更新失败!"];
//            [alert show];
            
        }
        
    } withFailure:^(NSError *error) {
        NSLog(@"failue");
    }];
    //    Alert * alert = [[Alert alloc] initWithLogoImage:@"logo.png" withTitle:@"检测新版本" withContent:@"当前已经是最新版本"];
    //    [alert show];
}

-(void)recommendAction:(UIButton *)sender
{
    XiaozhiTuijianViewController * xiaozhiTuijianVC = [[XiaozhiTuijianViewController alloc] init];
    [self.navigationController pushViewController:xiaozhiTuijianVC animated:YES];
}

-(void)adviceAction:(UIButton *)sender
{
    [self sendAD];
}

-(void)backAction:(UIButton *)sender
{
    
//    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sjuserid"];
//    if(userName.length)
//    {
//        GRZXViewController *grzx=[[GRZXViewController alloc]init];
//        [self.navigationController pushViewController:grzx animated:YES];
//        
//    }
//    else
//    {
//        LGViewController * LGVC = [[LGViewController alloc] init];
//        [self.navigationController pushViewController:LGVC animated:YES];
//    }
    NSString *name=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjuserid"];
    if (name.length>0) {
        UIAlertView *alre=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"确认退出当前账号吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alre.tag=20000;
        [alre show];
    }else{
        LGViewController *lg=[[LGViewController alloc]init];
        [self.navigationController pushViewController:lg animated:YES];
    }
   
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"RightBack" object:nil];
    
}

#pragma mark -
#pragma mark - alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            NSURL *url = [NSURL URLWithString:trackViewURL];
            
            [[UIApplication sharedApplication]openURL:url];
        }
    }
    if (alertView.tag==20000) {
        if (buttonIndex==1) {
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"sjusername"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"sjuserid"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"currendIco"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"sjusername"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"sjuserphone"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self updateUserName];
        }
        
//        LGViewController *lg=[[LGViewController alloc]init];
//        [self.navigationController pushViewController:lg animated:YES];
    }
    if (alertView.tag==3000) {
        if (buttonIndex==0) {
            [self cleanCache];
        }
        
    }
    
}

-(void)userButAction:(UIButton *)sender
{
//    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"sjuserid"];
    if(userName.length)
    {
        GRZXViewController *grzx=[[GRZXViewController alloc]init];
        [self.navigationController pushViewController:grzx animated:YES];
        
    }
    else
    {
        LGViewController * LGVC = [[LGViewController alloc] init];
        [self.navigationController pushViewController:LGVC animated:YES];
    }

}

-(void)settingAction:(UIButton *)sender
{
    //设置
    SomeSettingViewController * someSettingVC = [[SomeSettingViewController alloc] init];
    [self.navigationController pushViewController:someSettingVC animated:YES];
    
}

-(void)versionAction:(UIButton *)sender
{
    //版本检测
    [self versionDetection];
    
}

-(void)friendAction:(UIButton *)sender
{
    //推荐好友
    [self tuiJianHaoYou];
}

-(void)aboutAction:(UIButton *)sender
{
    //关于
//    SomeAboutViewController * someAboutVC = [[SomeAboutViewController alloc] init];
//    [self.navigationController pushViewController:someAboutVC animated:YES];
    aboutZTQ *abztq=[[aboutZTQ alloc]init];
    [self.navigationController pushViewController:abztq animated:YES];
}

-(void)updateUserName
{
//    NSString * userNameStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"sjusername"];
//    if (userNameStr.length>0) {
//        [self.loginbtn setTitle:userNameStr forState:UIControlStateNormal];
//    }else
//    [self.loginbtn setTitle:@"登录" forState:UIControlStateNormal];
//    UIImage * userImg = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"currendIco"]];
//    if(userImg == nil)
//    {
//        userImg = [UIImage imageNamed:@"gzicon"];
//    }
//    [self.titlebtn setBackgroundImage:userImg forState:UIControlStateNormal];
    NSString * userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sjuserid"];
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *userCenterImage = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    if (userid.length>0) {
        [userCenterImage setObject:userid forKey:@"user_id"];
    }
    [t_b setObject:userCenterImage forKey:@"gz_user_center"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
   
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            NSDictionary *userCenterImage=[t_b objectForKey:@"gz_user_center"];
            NSDictionary *userinfo=[userCenterImage objectForKey:@"userinfo"];
            NSString *head_url=[userinfo objectForKey:@"head_url"];
            if(head_url)
            {
                NSURL *url=[NSURL URLWithString:head_url];
                NSData *mydata = [NSData dataWithContentsOfURL:url];
                if (mydata) {
                    [[NSUserDefaults standardUserDefaults]setObject:mydata forKey:@"currendIco"];
                }
            }
            
            NSString *username=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjusername"];
            self.username=username;
            if (username.length>0) {
                self.lgbtn.hidden=YES;
                self.nicknameLabel.hidden=NO;
                
                NSData *head_data=[[NSUserDefaults standardUserDefaults] objectForKey:@"currendIco"];
                if (head_data) {
                    self.tximg.image=[UIImage imageWithData:head_data];
                }else{
                    self.tximg.image=[UIImage imageNamed:@"gzicon"];
                }
                self.nicknameLabel.text=self.username;
                
            }else{
                self.tximg.image=[UIImage imageNamed:@"gzicon"];
                self.lgbtn.hidden=NO;
                self.nicknameLabel.hidden=YES;
            }
   

       
        }else{
            
            NSString *username=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjusername"];
            self.username=username;
            if (username.length>0) {
                self.lgbtn.hidden=YES;
                self.nicknameLabel.hidden=NO;
                
                NSData *head_data=[[NSUserDefaults standardUserDefaults] objectForKey:@"currendIco"];
                if (head_data) {
                    self.tximg.image=[UIImage imageWithData:head_data];
                }else{
                    self.tximg.image=[UIImage imageNamed:@"gzicon"];
                }
                self.nicknameLabel.text=self.username;
                
            }else{
                self.tximg.image=[UIImage imageNamed:@"gzicon"];
                self.lgbtn.hidden=NO;
                self.nicknameLabel.hidden=YES;
            }
        
        }

    } withFailure:^(NSError *error) {
        
    } withCache:YES];


    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//#pragma mark -
//
//#pragma mark -UpgradeAlertDelegate
//
//-(void)clickButtonWithTag:(int)tag
//{
//    if(tag == 1)
//    {
//        NSURL *url = [NSURL URLWithString:trackViewURL];
//        [[UIApplication sharedApplication]openURL:url];
//    }
//}

@end
