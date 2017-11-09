//
//  AutoShareViewController.m
//  ZtqCountry
//
//  Created by linxg on 14-7-21.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "AutoShareViewController.h"
//#import "NetWorkCenter.h"
#import "CustomPickView.h"


@interface AutoShareViewController ()<UITableViewDataSource,UITableViewDelegate,CustomPickDelegate>

@property (strong, nonatomic) UITableView * settingList;
@property (strong, nonatomic) UILabel * weatherInfoLab;
@property (strong, nonatomic) NSMutableArray * settingDatas;
@property (strong, nonatomic) UIButton * tengxunBut;
@property (strong, nonatomic) UIButton * xinlangBut;

@property (strong, nonatomic) NSMutableArray * firstTimes;
@property (strong, nonatomic) NSMutableArray * secondTimes;

@end

@implementation AutoShareViewController

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
    [self setNavigation];
    _settingList = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht-self.barHeight)];
    _settingList.delegate = self;
    _settingList.dataSource = self;
    _settingList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_settingList];
    [self loadingWeekTQ];
    [self setUpTiemGroup];
    
    // Do any additional setup after loading the view.
}

-(void)setNavigation
{
//    if(kSystemVersionMore7)
//    {
//        self.edgesForExtendedLayout =  UIRectEdgeNone;
//    }
//    self.navigationController.navigationBarHidden = YES;
//    //    self.title = @"推送设置";
//    float place = 0;
//    if(kSystemVersionMore7)
//    {
//        place = 20;
//    }
//    UIImageView * navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
//    navigationBarBg.userInteractionEnabled = YES;
//    navigationBarBg.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:navigationBarBg];
//    
//    UIButton * leftBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 7+place, 50, 30)];
//    [leftBut setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [leftBut setTitle:@"back" forState:UIControlStateNormal];
//    [leftBut addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [navigationBarBg addSubview:leftBut];
//    
//    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 7+place, 200, 30)];
//    titleLab.textAlignment = NSTextAlignmentCenter;
//    titleLab.font = [UIFont fontWithName:kBaseFont size:20];
//    titleLab.backgroundColor = [UIColor clearColor];
//    titleLab.textColor = [UIColor blackColor];
//    titleLab.text = @"分享设置";
//    [navigationBarBg addSubview:titleLab];

    self.titleLab.text = @"分享设置";
    self.barHiden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 95;
    }
    else
    {
        if(indexPath.row == 3)
        {
            return 110;
        }
        else
        {
            return 60;
        }
    }
        
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"one"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
            UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 20)];
            title.text = @"天气信息预览";
            title.backgroundColor = [UIColor clearColor];
            title.textAlignment = NSTextAlignmentLeft;
            title.font = [UIFont fontWithName:kBaseFont size:15];
            title.textColor = [UIColor blueColor];
            title.tag = 1;
            [cell.contentView addSubview:title];
            
            UILabel * contentLab =[[UILabel alloc] initWithFrame:CGRectMake(20, 35, kScreenWidth-40, 60)];
            self.weatherInfoLab = contentLab;
             contentLab.numberOfLines = 0;
            contentLab.backgroundColor = [UIColor clearColor];
           
            contentLab.textAlignment = NSTextAlignmentLeft;
            contentLab.font = [UIFont fontWithName:kBaseFont size:15];
            contentLab.textColor = [UIColor blackColor];
            contentLab.tag = 2;
            [cell.contentView addSubview:contentLab];
        }
        return cell;
    }
    if(indexPath.row == 1)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"two"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"two"];
            UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 20)];
            title.text = @"自动分享状态";
            title.backgroundColor = [UIColor clearColor];
            title.textAlignment = NSTextAlignmentLeft;
            title.font = [UIFont fontWithName:kBaseFont size:15];
            title.textColor = [UIColor blackColor];
            title.tag = 1;
            [cell.contentView addSubview:title];
            
            UILabel * contentLab =[[UILabel alloc] initWithFrame:CGRectMake(20, 35, kScreenWidth-40, 20)];
            contentLab.text = @"没有绑定微博则不发布";
            contentLab.backgroundColor = [UIColor clearColor];
            contentLab.numberOfLines = 0;
            contentLab.textAlignment = NSTextAlignmentLeft;
            contentLab.font = [UIFont fontWithName:kBaseFont size:13];
            contentLab.textColor = [UIColor grayColor];
            contentLab.tag = 2;
            [cell.contentView addSubview:contentLab];
            
            UISwitch * openSwithch = [[UISwitch alloc] initWithFrame:CGRectMake(230, 5, 65, 20)];
            openSwithch.tag = 3;
            [openSwithch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:openSwithch];
            
        }
        UISwitch * openSwitch = (UISwitch *)[cell.contentView viewWithTag:3];
        openSwitch.on = [[[NSUserDefaults standardUserDefaults] objectForKey:kAutoShareOpen] boolValue];
        return cell;
    }
    if(indexPath.row == 2)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"thr"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"thr"];
            UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 20)];
            title.text = @"自动分享时间";
            title.backgroundColor = [UIColor clearColor];
            title.textAlignment = NSTextAlignmentLeft;
            title.font = [UIFont fontWithName:kBaseFont size:15];
            title.textColor = [UIColor blackColor];
            title.tag = 1;
            [cell.contentView addSubview:title];
            
            UILabel * contentLab =[[UILabel alloc] initWithFrame:CGRectMake(20, 35, kScreenWidth-40, 20)];
            contentLab.backgroundColor = [UIColor clearColor];
            contentLab.text = @"设置分享时间后，分享天气前会自动更新天气";
            contentLab.numberOfLines = 0;
            contentLab.textAlignment = NSTextAlignmentLeft;
            contentLab.font = [UIFont fontWithName:kBaseFont size:13];
            contentLab.textColor = [UIColor grayColor];
            contentLab.tag = 2;
            [cell.contentView addSubview:contentLab];
            
            UIButton * settingBut = [[UIButton alloc] initWithFrame:CGRectMake(230, 5, 65, 20)];
            settingBut.tag = indexPath.row+10;
            [settingBut setTitle:@"设置" forState:UIControlStateNormal];
            [settingBut setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [settingBut setBackgroundColor:[UIColor whiteColor]];
            [settingBut addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:settingBut];
            
        }

        UISwitch * openSwitch = (UISwitch *)[cell.contentView viewWithTag:3];
        openSwitch.on = [[[NSUserDefaults standardUserDefaults] objectForKey:kAutoShareOpen] boolValue];
        return cell;
    }
    if(indexPath.row == 3)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"for"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"for"];
            UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 20)];
            
            title.backgroundColor = [UIColor clearColor];
            title.text = @"帐号管理";
            title.textAlignment = NSTextAlignmentLeft;
            title.font = [UIFont fontWithName:kBaseFont size:15];
            title.textColor = [UIColor blueColor];
            title.tag = 1;
            [cell.contentView addSubview:title];
            
            UILabel * xinlangLab =[[UILabel alloc] initWithFrame:CGRectMake(20, 35, 200, 20)];
            xinlangLab.text = @"新浪微博";
            xinlangLab.backgroundColor = [UIColor clearColor];
            xinlangLab.textAlignment = NSTextAlignmentLeft;
            xinlangLab.font = [UIFont fontWithName:kBaseFont size:15];
            xinlangLab.textColor = [UIColor blueColor];
            [cell.contentView addSubview:xinlangLab];
            
            UIButton * xinlangBut = [[UIButton alloc] initWithFrame:CGRectMake(230, 35, 65, 20)];
            self.xinlangBut = xinlangBut;
            SinaWeibo *sinaweibo = [self sinaweibo];
            BOOL authValid = sinaweibo.isAuthValid;
            if (authValid) {
                [xinlangBut setTitle:@"解绑" forState:UIControlStateNormal];
            }
            else {
                [xinlangBut setTitle:@"请绑定" forState:UIControlStateNormal];
            }

            xinlangBut.tag = indexPath.row+10;
            [xinlangBut setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [xinlangBut setBackgroundColor:[UIColor whiteColor]];
            [xinlangBut addTarget:self action:@selector(xinlangAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:xinlangBut];


            
            UILabel * tengxunLab =[[UILabel alloc] initWithFrame:CGRectMake(20, 80, 200, 20)];
            tengxunLab.text = @"腾讯微博";
            tengxunLab.backgroundColor = [UIColor clearColor];
            tengxunLab.textAlignment = NSTextAlignmentLeft;
            tengxunLab.font = [UIFont fontWithName:kBaseFont size:15];
            tengxunLab.textColor = [UIColor blueColor];
            [cell.contentView addSubview:tengxunLab];
            
            
            UIButton * tengxunBut = [[UIButton alloc] initWithFrame:CGRectMake(230, 80, 65, 20)];
            self.tengxunBut = tengxunBut;
            tengxunBut.tag = indexPath.row+11;
            [tengxunBut setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [tengxunBut setBackgroundColor:[UIColor whiteColor]];
            [tengxunBut addTarget:self action:@selector(tengxunAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:tengxunBut];
            TCWBEngine *weiboEngine = [self tcweibo];
            if ([[weiboEngine openId] length] > 0) {
                [tengxunBut setTitle:@"已绑定" forState:UIControlStateNormal];
            }
            else {
                [tengxunBut setTitle:@"请绑定" forState:UIControlStateNormal];
            }
            
        }
        return cell;
    }

    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(void)xinlangAction:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"请绑定"]) {
        SinaWeibo *sinaweibo = [self sinaweibo];
        [sinaweibo logIn];
    }
    else
    {
         SinaWeibo *sinaweibo = [self sinaweibo];
        [sinaweibo logOut];
    }
}
-(void)tengxunAction:(UIButton *)sender
{
    if([sender.titleLabel.text isEqualToString:@"请绑定"])
    {
        TCWBEngine *weiboEngine = [self tcweibo];
        [weiboEngine logInWithDelegate:self
                             onSuccess:@selector(onSuccessLogin)
                             onFailure:@selector(onFailureLogin)];
    }
    else
    {
        TCWBEngine *weiboEngine = [self tcweibo];
        if([weiboEngine logOut])
        {
            [sender setTitle:@"请绑定" forState:UIControlStateNormal];
        }
    }
    

}

-(void)setUpTiemGroup
{
    self.firstTimes = [[NSMutableArray alloc] init];
    self.secondTimes = [[NSMutableArray alloc] initWithCapacity:10];
    for(int i=0;i<24;i++)
    {
        NSString * numStr;
        if(i<10)
        {
            numStr = [NSString stringWithFormat:@"0%d",i];
        }
        else
        {
            numStr = [NSString stringWithFormat:@"%d",i];
        }
        [self.firstTimes addObject:numStr];
    }
    for(int i=0;i<60;i++)
    {
        NSString * numStr;
        if(i<10)
        {
            numStr = [NSString stringWithFormat:@"0%d",i];
        }
        else
        {
            numStr = [NSString stringWithFormat:@"%d",i];
        }
        [self.secondTimes addObject:numStr];
    }
}

-(void)settingAction:(UIButton *)sender
{
//    int first = [[timeGroup objectAtIndex:0] intValue];
//    int second = [[timeGroup objectAtIndex:1] intValue];
    CustomPickView * pickView = [[CustomPickView alloc] initWithFrame:CGRectMake(10, 74, kScreenWidth-20, 150) withFirstGroupDataSourse:self.firstTimes withSecondGroupDataSourse:self.secondTimes withOnView:self.view withOneIdx:0 withTwoIdx:0];
    pickView.delegate = self;
    [pickView show];
}
-(void)switchChange:(UISwitch *)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:sender.on] forKey:kAutoShareOpen];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (SinaWeibo *)sinaweibo
{
    
	if (!_sinaweibo) {
		_sinaweibo = [[SinaWeibo alloc] initWithAppKey:SINAAPPKEY appSecret:SINAAPPSECRET appRedirectURI:CallBackURL andDelegate:self];
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
		if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
		{
			_sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
			_sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
			_sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
		}
	}
    return _sinaweibo;
}

- (TCWBEngine *)tcweibo
{
	if (!_TCWeibo) {
		_TCWeibo = [[TCWBEngine alloc] initWithAppKey:WiressSDKDemoAppKey andSecret:WiressSDKDemoAppSecret andRedirectUrl:REDIRECTURI];
		[_TCWeibo setRootViewController:self];
	}
    return _TCWeibo;
}

-(void)onSuccessLogin
{
    [self.tengxunBut setTitle:@"解绑" forState:UIControlStateNormal];
}

-(void)onFailureLogin
{
    [self.tengxunBut setTitle:@"请绑定" forState:UIControlStateNormal];
}


-(void)refreshXinlangWeibo
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    BOOL authValid = sinaweibo.isAuthValid;
    if (authValid) {
        [self.xinlangBut setTitle:@"解绑" forState:UIControlStateNormal];
    }
    else {
        [self.xinlangBut setTitle:@"请绑定" forState:UIControlStateNormal];
    }

}

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    //    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    //    [m_statusBar showWithStatusMessage:@"绑定新浪成功" withImage:@"success.png"];
	[self performSelector:@selector(refreshXinlangWeibo)];
}
-(void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    [self performSelector:@selector(refreshXinlangWeibo)];
}


-(void)loadingWeekTQ
{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * weekTq = [[NSMutableDictionary alloc] init];
    NSString * currentID = [setting sharedSetting].currentCityID;
    
    [weekTq setObject:currentID forKey:@"area"];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [b setObject:weekTq forKey:@"weekTq"];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSLog(@"success");
        //拼接分享的信息
        NSMutableString * shareStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@:",[setting sharedSetting].currentCity]];
        NSDictionary * b = [returnData objectForKey:@"b"];
        NSDictionary * weekTq = [b objectForKey:@"weekTq"];
        NSArray * week = [weekTq objectForKey:@"week"];
        int k = 0;
        if(week.count>3)
        {
            k=3;
        }
        else
        {
            k=week.count;
        }
        for(int i=0;i<k;i++)
        {
            NSDictionary * weekInfo = [week objectAtIndex:i];
            NSString * gdt = [weekInfo objectForKey:@"gdt"];
//            NSString * week = [weekInfo objectForKey:@"week"];
//            NSString * wd = [weekInfo objectForKey:@"wd"];
//            NSString * wd_ico = [weekInfo objectForKey:@"wd_ico"];
            NSString * higt = [weekInfo objectForKey:@"higt"];
            NSString * lowt = [weekInfo objectForKey:@"lowt"];
//            NSString * wd_daytime_ico = [weekInfo objectForKey:@"wd_daytime_ico"];
//            NSString * wind = [weekInfo objectForKey:@"wind"];
            NSString * wd_night = [weekInfo objectForKey:@"wd_night"];
            NSString * wd_daytime = [weekInfo objectForKey:@"wd_daytime"];
//            NSString * wd_night_ico = [weekInfo objectForKey:@"wd_night_ico"];
            
            NSString * weather = nil;
            NSString * up = nil;
            NSString * down = nil;
            if([ShareFun timeRules]==Evening)
            {
                weather = wd_night;
            }
            else
            {
                weather = wd_daytime;
            }
            if([ShareFun timeRules]==Morning)
            {
                up = lowt;
                down = higt;
                [shareStr appendString:[NSString stringWithFormat:@"%@,%@,%@~%@;",gdt,weather,up,down]];

            }
            else if([ShareFun timeRules] == Noon)
            {
                up = higt;
                down = lowt;
                [shareStr appendString:[NSString stringWithFormat:@"%@,%@,%@~%@;",gdt,weather,up,down]];
            }
            else if([ShareFun timeRules] == Evening)
            {
                 [shareStr appendString:[NSString stringWithFormat:@"%@,%@,最低温度%@;",gdt,weather,lowt]];
            }
            
        }
        self.weatherInfoLab.text = shareStr;
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}

#pragma mark -CustomPickDelegate

-(void)determineWithTime:(NSString *)time
{
   
}

-(void)cancle
{
    
}


-(void)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
