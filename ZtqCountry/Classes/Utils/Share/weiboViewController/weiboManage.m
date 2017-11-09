//
//  weiboManage.m
//  ZtqNew
//
//  Created by wang zw on 12-8-3.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "weiboManage.h"
#import "ShareFun.h"

@implementation weiboManage

@synthesize renren = _renren;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    int y=0;
	if (ios7) {
        self.edgesForExtendedLayout=UIEventSubtypeNone;
        y=20;
    }
	[self.view setBackgroundColor:[UIColor clearColor]];
	
	UIImageView *t_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"对话框背景.png"]];
	[t_image setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	[self.view addSubview:t_image];
//	[t_image release];
	
	UILabel *t_lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0+y, 320, 44)];
	t_lable.userInteractionEnabled = NO;
	t_lable.text = @"管理分享帐号";
	t_lable.font = [UIFont boldSystemFontOfSize:20];
	t_lable.textColor = [UIColor whiteColor];
	t_lable.textAlignment = UITextAlignmentCenter;
	t_lable.backgroundColor = [UIColor clearColor];
	[self.view addSubview:t_lable];
//	[t_lable release];
	
	UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 7+y, 50, 30)];
	[backBtn setUserInteractionEnabled:YES];
	[backBtn setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
	[backBtn addTarget:self action:@selector(backButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:backBtn];
//	[backBtn release];
	//------------------------------------------------------------------------------------
	
	m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 50+y, 300, self.view.frame.size.height - 50-y)  style:UITableViewStyleGrouped];
    if (ios7) {
        m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50+y, 320, self.view.frame.size.height - 50-y)  style:UITableViewStyleGrouped];
    }
	m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	m_tableView.backgroundColor=[UIColor clearColor];
    m_tableView.backgroundView=nil;
	m_tableView.autoresizesSubviews = YES;
	m_tableView.scrollEnabled = NO;
	m_tableView.delegate = self;
	m_tableView.dataSource = self;
	[self.view addSubview:m_tableView];
//	[m_tableView release];
}

//- (void)dealloc {
//	if (_sinaweibo) {
//		[_sinaweibo release], _sinaweibo = nil;
//	}
//	if (_TCWeibo) {
//		[_TCWeibo release], _TCWeibo = nil;
//	}
//	if (_renren) {
//		[_renren release], _renren = nil;
//	}
//    [super dealloc];
//}

- (void)backButtonEvent:(id) sender{										
	[self dismissModalViewControllerAnimated:YES];
	return ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int section = indexPath.section;
	int row = indexPath.row;
	NSString *t_str = [NSString stringWithFormat:@"weiboManage cell %d_%d",section,row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:t_str];
	if(cell != nil)
		[cell removeFromSuperview];
	
//	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t_str] autorelease];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:t_str];
    if (ios7) {
        [cell setBackgroundColor:[UIColor clearColor]];
        UIImageView *bgimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
        bgimage.image=[UIImage imageNamed:@"huisebeijingwubian.png"];
        [cell addSubview:bgimage];
//        [bgimage release];
        
    }
	
	UILabel *t_label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 40)];
	t_label.backgroundColor = [UIColor clearColor];
	t_label.font = [UIFont fontWithName:@"Helvetica" size:15];
	[cell addSubview:t_label];
//	[t_label release];
	
	UISwitch *t_switch = [[UISwitch alloc] initWithFrame:CGRectMake(180, 7, 0, 0)];
    if (ios7) {
        t_switch.frame=CGRectMake(240, 5, 0, 0);
        t_switch.tintColor=[UIColor whiteColor];
    }
	[t_switch setTag:row + 100];
	[t_switch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
	[cell addSubview:t_switch];
//	[t_switch release];
	
	switch (row) {
		case 0:
		{
			SinaWeibo *sinaweibo = [self sinaweibo];
			BOOL authValid = sinaweibo.isAuthValid;
			t_label.text = @"绑定新浪微博";
			t_switch.on = authValid;
			break;
		}
		case 1:
		{
			TCWBEngine *weiboEngine = [self tcweibo];
			BOOL tcAuthValid = [[weiboEngine openId] length];
			t_label.text = @"绑定腾讯微博";
			t_switch.on = tcAuthValid;
			break;
		}
//		case 2:
//		{
//			self.renren = [Renren sharedRenren];
//			BOOL renreAauthValid = [_renren isSessionValid];
//			t_label.text = @"绑定人人网";
//			t_switch.on = renreAauthValid;
//			break;
//		}
		default:
			break;
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
//	cell.backgroundColor=[UIColor clearColor];
	return cell;
}

- (void) switchChange:(id)sender
{
	UISwitch *t_switch = (UISwitch *)sender;
	
	if (t_switch.tag == 100)
	{
		if (t_switch.on)
		{
			t_switch.on = NO;
			
			BOOL netWork = [ShareFun isNetworkAvailable];
			if (!netWork){
				[ShareFun alertNotice:@"沃·知天气" withMSG:@"绑定失败,请检查网络连接" cancleButtonTitle:@"确定" otherButtonTitle:nil];
				return;
			}
			SinaWeibo *sinaweibo = [self sinaweibo];
			[sinaweibo logIn];
		}
		else if (!t_switch.on)
		{
			[MBProgressHUD showHUDAddedTo:self.view withLabel:@"解除绑定中..." animated:YES];
			SinaWeibo *sinaweibo = [self sinaweibo];
			[sinaweibo logOut];
		}
	}
	else if (t_switch.tag == 101)
	{
		TCWBEngine *weiboEngine = [self tcweibo];
		if (t_switch.on)
		{
			t_switch.on = NO;
			
			BOOL netWork = [ShareFun isNetworkAvailable];
			if (!netWork){
				[ShareFun alertNotice:@"沃·知天气" withMSG:@"绑定失败,请检查网络连接" cancleButtonTitle:@"确定" otherButtonTitle:nil];
				return;
			}
			
			[weiboEngine logInWithDelegate:self 
								 onSuccess:@selector(onSuccessLogin) 
								 onFailure:@selector(onFailureLogin:)];
		}
		else if (!t_switch.on)
		{
			[weiboEngine logOut];
		}
	}
	else if (t_switch.tag == 102)
	{
		if (t_switch.on)
		{
			t_switch.on = NO;
			
			BOOL netWork = [ShareFun isNetworkAvailable];
			if (!netWork){
				[ShareFun alertNotice:@"沃·知天气" withMSG:@"绑定失败,请检查网络连接" cancleButtonTitle:@"确定" otherButtonTitle:nil];
				return;
			}
			
			NSArray *permissions = [NSArray arrayWithObjects:@"status_update", @"photo_upload", @"publish_feed", nil];
            [_renren authorizationInNavigationWithPermisson:permissions andDelegate:self];
		}
		else if (!t_switch.on)
		{
			[MBProgressHUD showHUDAddedTo:self.view withLabel:@"解除绑定中..." animated:YES];
			[_renren logout:self];
		}
	}
}

#pragma mark - SinaWeibo Delegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    UISwitch *t_switch = (UISwitch *)[self.view viewWithTag:100];
	t_switch.on = YES;
	
    [self storeAuthData];
}

- (void)storeAuthData
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
	UISwitch *t_switch = (UISwitch *)[self.view viewWithTag:100];
	t_switch.on = NO;
	[self storeAuthData];
	[MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - tcWeibo Delegate
- (void)onSuccessLogin
{
    UISwitch *t_switch = (UISwitch *)[self.view viewWithTag:101];
	t_switch.on = YES;
}

- (void)onFailureLogin:(NSError *)error
{
    UISwitch *t_switch = (UISwitch *)[self.view viewWithTag:101];
	t_switch.on = NO;
}

#pragma mark - RenrenDelegate methods
-(void)renrenDidLogin:(Renren *)renren{
    UISwitch *t_switch = (UISwitch *)[self.view viewWithTag:102];
	t_switch.on = YES;
}

- (void)renrenDidLogout:(Renren *)renren
{
	UISwitch *t_switch = (UISwitch *)[self.view viewWithTag:102];
	t_switch.on = NO;
	
	[MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
