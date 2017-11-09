//
//  weiboVC.m
//  ztq_heilj
//
//  Created by lihj on 12-10-30.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "weiboVC.h"
#import "myImageSeeView.h"

#define kBorderWidth 20
#define kTextViewHeight 366

@implementation weiboVC

@synthesize shareText;
@synthesize shareImage;
@synthesize shareType;
@synthesize renren = _renren;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		shareType = 0;
        shareText = nil;
		shareImage = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor clearColor];
    int y=0;
    if (ios7) {
        y=20;
    }
	
	UIImageView *t_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, myheigth)];
	[t_imageView setImage:[UIImage imageNamed:@"城市管理背景.jpg"]];
	[self.view addSubview:t_imageView];
//	[t_imageView release];
	
	UIImageView *t_editBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0+y, 320, 44)];
	t_editBarBg.image = [UIImage imageNamed:@"top.jpg"];
	[self.view addSubview:t_editBarBg];
//	[t_editBarBg release];
	
	UILabel *t_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0+y, 320, 44)];
	[t_title setBackgroundColor:[UIColor clearColor]];
	[t_title setTextAlignment:UITextAlignmentCenter];
	[t_title setTextColor:[UIColor whiteColor]];
	[t_title setFont:[UIFont boldSystemFontOfSize:22]];
	switch (shareType) {
		case Sina:
			t_title.text = @"新浪微博";
			break;
		case Tencent:
			t_title.text = @"腾讯微博";
			break;
		case RenrenShare:
			t_title.text = @"人人网";
			break;
		default:
			break;
	}
	[self.view addSubview:t_title];
//	[t_title release];
	
	//返回按钮
	backBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 7+y, 50, 30)];
	[backBut setBackgroundColor:[UIColor clearColor]];
	[backBut setTitle:@"  返回" forState:UIControlStateNormal];
	[backBut.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
	[backBut setBackgroundImage:[UIImage imageNamed:@"back_normal.png"] forState:UIControlStateNormal];
	[backBut setBackgroundImage:[UIImage imageNamed:@"back_hightlighted.png"] forState:UIControlStateHighlighted];
	[backBut addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:backBut];
//	[backBut release];
    
    //分享按钮
	shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(245, 7+y, 60, 30)];
	[shareBtn setBackgroundColor:[UIColor clearColor]];
	[shareBtn setTitle:@"分享" forState:UIControlStateNormal];
	[shareBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
	[shareBtn setBackgroundImage:[UIImage imageNamed:@"add_normal.png"] forState:UIControlStateNormal];
	[shareBtn setBackgroundImage:[UIImage imageNamed:@"add_hightlighted.png"] forState:UIControlStateHighlighted];
	[shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:shareBtn];
//	[shareBtn release];
    
    CGRect rect = self.view.bounds;
    CGRect tvRect;
    tvRect.origin.x = kBorderWidth;
    tvRect.origin.y = kBorderWidth + 10 + 44+y;
    tvRect.size.width = rect.size.width - 2*kBorderWidth;
    tvRect.size.height = kTextViewHeight - 216;
	
	UIView *seeView = [[UIView alloc] initWithFrame:tvRect];
	[seeView setBackgroundColor:[UIColor whiteColor]];
	seeView.layer.cornerRadius = 5.f;
	seeView.layer.masksToBounds = YES;
    seeView.layer.borderWidth = 1.f;
    seeView.layer.borderColor = [[UIColor grayColor] CGColor];
	[self.view addSubview:seeView];
//	[seeView release];
	
	tvRect.size.width = rect.size.width - 2*kBorderWidth - 66;
	
    _textView = [[UITextView alloc] initWithFrame:tvRect];
	[_textView setBackgroundColor:[UIColor clearColor]];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:16.0f];
	_textView.alwaysBounceVertical = YES;
	_textView.autoresizesSubviews = YES;
	_textView.text = shareText;
    [_textView becomeFirstResponder];
    [self.view addSubview:_textView];
    
    CGRect lbRect;
    lbRect.origin.x = kBorderWidth;
    lbRect.origin.y = 5 + 44+y;
    lbRect.size.width = 60;
    lbRect.size.height = kBorderWidth;
    _stateLabel = [[UILabel alloc] initWithFrame:lbRect];
    _stateLabel.backgroundColor = [UIColor clearColor];
    _stateLabel.font = [UIFont systemFontOfSize:14.0f];
	_stateLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_stateLabel];
    
    lbRect.origin.x = 180;
    lbRect.size.width = 120;
    _countLabel = [[UILabel alloc] initWithFrame:lbRect];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textAlignment = UITextAlignmentRight;
    _countLabel.font = [UIFont systemFontOfSize:14.0f];
	_countLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_countLabel];
    
    if(shareImage != nil){
		NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:shareImage];
		UIImageView *t_image = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:shareImagePath]];
		[t_image setFrame:CGRectMake(300 - 66, 340-216-25, 66, 100)];
		t_image.tag = 10086;
		[self.view addSubview:t_image];
//		[t_image release];
		
		UIButton *t_btn = [[UIButton alloc] initWithFrame:t_image.frame];
		[t_btn addTarget:self action:@selector(viewImage) forControlEvents:UIControlEventTouchUpInside];
		t_btn.tag = 10087;
		[self.view addSubview:t_btn];
//		[t_btn release];
		
		UIImage* closeImage = [UIImage imageNamed:@"SinaWeibo.bundle/images/close.png"];
        UIColor* color = [UIColor colorWithRed:167.0/255 green:184.0/255 blue:216.0/255 alpha:1];
        UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:closeImage forState:UIControlStateNormal];
        [closeButton setTitleColor:color forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		closeButton.tag = 10088;
        [closeButton addTarget:self action:@selector(closeImg) forControlEvents:UIControlEventTouchUpInside];
        closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        closeButton.showsTouchWhenHighlighted = YES;
        closeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		[closeButton sizeToFit];
		closeButton.frame = CGRectMake(300 - 14, 340-15-216-25, 29, 29);
		
        [self.view addSubview:closeButton];
	}
    m_statusBar = [[CHStatusBar alloc] initWithFrame:CGRectMake(200, 0+y, 120, 20)];
	
    [self performSelector:@selector(refreshView)];
}

//- (void)dealloc {
//	[_textView release];
//    [_stateLabel release];
//    [_countLabel release];
//	[shareText release], shareText = nil;
//	[shareImage release], shareImage = nil;
//	if (_sinaweibo) {
//		[_sinaweibo release], _sinaweibo = nil;
//	}
//	if (_TCWeibo) {
//		[_TCWeibo release], _TCWeibo = nil;
//	}
//	if (_renren) {
//		[_renren release], _renren = nil;
//	}
//	[m_statusBar release];
//    [super dealloc];
//}

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

#pragma mark - 返回按钮
- (void)backBtnClicked{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark 查看图片
- (void)viewImage
{
	[_textView resignFirstResponder];
	myImageSeeView *t_myImageSeeView = [[myImageSeeView alloc] initWithImageName:shareImage];
	[self.view addSubview:t_myImageSeeView];
	[t_myImageSeeView show];
//	[t_myImageSeeView release];
}

- (void)closeImg
{
	UIImageView *t_img = (UIImageView *)[self.view viewWithTag:10086];
	[t_img removeFromSuperview];
	UIButton *t_btn = (UIButton *)[self.view viewWithTag:10087];
	[t_btn removeFromSuperview];
	t_btn = (UIButton *)[self.view viewWithTag:10088];
	[t_btn removeFromSuperview];
	shareImage = nil;
	
	CGRect rect = self.view.bounds;
    CGRect tvRect;
    tvRect.origin.x = kBorderWidth;
    tvRect.origin.y = kBorderWidth + 10 + 44;
    tvRect.size.width = rect.size.width - 2*kBorderWidth;
    tvRect.size.height = kTextViewHeight - 216;
	
	_textView.frame = tvRect;
}

#pragma mark - 分享按钮
- (void)shareBtnClicked {
	[_textView resignFirstResponder];
	if (shareType == Sina) {
		if ([_stateLabel.text isEqualToString:@"未绑定"]) {
			SinaWeibo *sinaweibo = [self sinaweibo];
			[sinaweibo logIn];
		}
		else {
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
			backBut.enabled = NO;
			shareBtn.enabled = NO;
			[m_statusBar showWithStatusMessage:@"发布中..." withImage:@"sending.png"];
			
			SinaWeibo *sinaweibo = [self sinaweibo];
			
			if (shareImage) {
				NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:shareImage];
				[sinaweibo requestWithURL:@"statuses/upload.json"
								   params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
										   _textView.text, @"status",
										   [UIImage imageWithContentsOfFile:shareImagePath], @"pic", nil]
							   httpMethod:@"POST"
								 delegate:self];
			}
			else {
				[sinaweibo requestWithURL:@"statuses/update.json"
								   params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
										   _textView.text, @"status", nil]
							   httpMethod:@"POST"
								 delegate:self];
			}
		}
	}
	else if (shareType == Tencent) {
		TCWBEngine *weiboEngine = [self tcweibo];
		if ([[weiboEngine openId] length] > 0) {
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
			backBut.enabled = NO;
			shareBtn.enabled = NO;
			[m_statusBar showWithStatusMessage:@"发布中..." withImage:@"sending.png"];
			
			if (shareImage) {
				NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:shareImage];
				UIImage *img = [UIImage imageWithContentsOfFile:shareImagePath];
				NSData *dataImage = UIImageJPEGRepresentation(img, 1.0);
				[weiboEngine postPictureTweetWithFormat:@"json" 
											 content:_textView.text 
											clientIP:@"10.10.1.38"  
												 pic:dataImage
									  compatibleFlag:@"0"
										   longitude:nil
										 andLatitude:nil
										 parReserved:nil
											delegate:self 
										   onSuccess:@selector(successCallBack:) 
										   onFailure:@selector(failureCallBack:)];
			}
			else {
				[weiboEngine postTextTweetWithFormat:@"json" content:_textView.text clientIP:@"10.10.1.38" 
										   longitude:nil andLatitude:nil parReserved:nil delegate:self 
										   onSuccess:@selector(successCallBack:) 
										   onFailure:@selector(failureCallBack:)];
			}

		}
		else {
			[weiboEngine logInWithDelegate:self 
								 onSuccess:@selector(onSuccessLogin) 
								 onFailure:@selector(onFailureLogin:)];
		}
	}
	else if (shareType == RenrenShare) {
		
		if ([_renren isSessionValid]) {
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
			backBut.enabled = NO;
			shareBtn.enabled = NO;
			[m_statusBar showWithStatusMessage:@"发布中..." withImage:@"sending.png"];
			if (shareImage) {
				NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:shareImage];
				UIImage *img = [UIImage imageWithContentsOfFile:shareImagePath];
				
				ROPublishPhotoRequestParam *param = [[ROPublishPhotoRequestParam alloc] init];
				param.caption = _textView.text;
				param.imageFile = img;
				[_renren publishPhoto:param andDelegate:self];
//				[param release];
			}
			else {
				NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:10];
				[params setObject:@"status.set" forKey:@"method"];
				[params setObject:_textView.text forKey:@"status"];
				[_renren requestWithParams:params andDelegate:self];
			}
        }
        else {
            NSArray *permissions = [NSArray arrayWithObjects:@"status_update", @"photo_upload", @"publish_feed", nil];
            [_renren authorizationInNavigationWithPermisson:permissions andDelegate:self];
        }
	}
}

- (void)refreshView {
    
    int length = [self wordCount:_textView.text];
    _countLabel.text = [NSString stringWithFormat:@"还可以输入%d字", WeiboMaxWordCount - length];
    if (shareType == Sina) {
		SinaWeibo *sinaweibo = [self sinaweibo];
		BOOL authValid = sinaweibo.isAuthValid;
        if (authValid) {
            _stateLabel.text = @"已绑定";
        }
        else {
            _stateLabel.text = @"未绑定";
        }
    }
	else if (shareType == Tencent) {
		TCWBEngine *weiboEngine = [self tcweibo];
		if ([[weiboEngine openId] length] > 0) {
			_stateLabel.text = @"已绑定";
		}
		else {
			_stateLabel.text = @"未绑定";
		}
	}
	else if (shareType == RenrenShare) {
		self.renren = [Renren sharedRenren];
        if ([_renren isSessionValid] == NO) 
        {
            _stateLabel.text = @"未绑定";
        }
        else {
            _stateLabel.text = @"已绑定";
        }
	}
}

- (SinaWeibo *)sinaweibo
{
    OperaterModel * ope = [[OperaterModel alloc]init];
    ope.lmid = @"103";
    ope.eventid = @"07";
    ope.beg_time = [OperaterOfFile getLogdate];
    ope.end_time = [OperaterOfFile getLogdate];
    [OperaterOfFile addToOperateWithInfo:ope];
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
    OperaterModel * ope = [[OperaterModel alloc]init];
    ope.lmid = @"103";
    ope.eventid = @"07";
    ope.beg_time = [OperaterOfFile getLogdate];
    ope.end_time = [OperaterOfFile getLogdate];
    [OperaterOfFile addToOperateWithInfo:ope];
	if (!_TCWeibo) {
		_TCWeibo = [[TCWBEngine alloc] initWithAppKey:WiressSDKDemoAppKey andSecret:WiressSDKDemoAppSecret andRedirectUrl:REDIRECTURI];
		[_TCWeibo setRootViewController:self];  
	}
    return _TCWeibo;
}

#pragma mark - textview delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    int length = [self wordCount:textView.text];
    
    if (length <= WeiboMaxWordCount && length >= 0) {
		if (length == 0) {
			shareBtn.enabled = NO;
		}
		else {
			shareBtn.enabled = YES;
		}
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.text = [NSString stringWithFormat:@"还可以输入%d字", WeiboMaxWordCount - length];
    }
    else {
		shareBtn.enabled = NO;
        _countLabel.textColor = [UIColor redColor];
        _countLabel.text = [NSString stringWithFormat:@"已经超过%d字", length - WeiboMaxWordCount];
    }
}

#pragma mark statusBarHide
- (void)statusBarHide
{
	[m_statusBar hide];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	shareBtn.enabled = YES;
	backBut.enabled = YES;
}

#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
//    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    [m_statusBar showWithStatusMessage:@"绑定新浪成功" withImage:@"success.png"];
	[self performSelector:@selector(statusBarHide) withObject:nil afterDelay:2.0f];
	[self performSelector:@selector(refreshView)];
    [self storeAuthData];
}

#pragma mark - SinaWeiboRequest Delegate 

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
	//[self performSelector:@selector(statusBarHide) withObject:nil afterDelay:1.2f];
	
    NSLog(@"error:%@", error);
	
	NSNumber *t_str = [[[error userInfo] objectForKey:@"error"] objectForKey:@"error_code"];

	if ([t_str intValue] == 20019) {
		[ShareFun alertNotice:@"沃·知天气" withMSG:@"新浪微博发送失败，内容重复" cancleButtonTitle:@"确定" otherButtonTitle:nil];
	}
	else if ([t_str intValue] == 20016) {
		[ShareFun alertNotice:@"沃·知天气" withMSG:@"发送过于频繁，请稍后再试" cancleButtonTitle:@"确定" otherButtonTitle:nil];
	}
	else {
		[ShareFun alertNotice:@"沃·知天气" withMSG:@"新浪微博发送失败，请重新发送" cancleButtonTitle:@"确定" otherButtonTitle:nil];
	}
	[self performSelector:@selector(statusBarHide)];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
	[self performSelector:@selector(backBtnClicked)];
	
	[m_statusBar showWithStatusMessage:@"分享新浪成功" withImage:@"success.png"];
	[self performSelector:@selector(statusBarHide) withObject:nil afterDelay:2.0f];
}

#pragma mark - RenrenDelegate methods
-(void)renrenDidLogin:(Renren *)renren{
	[m_statusBar showWithStatusMessage:@"绑定人人网成功" withImage:@"success.png"];
	[self performSelector:@selector(statusBarHide) withObject:nil afterDelay:2.0f];
    [self performSelector:@selector(refreshView)];
}

- (void)renren:(Renren *)renren loginFailWithError:(ROError*)error
{
	NSLog(@"RenrenDelegate%@", error);
	[ShareFun alertNotice:@"沃·知天气" withMSG:@"人人网绑定失败，请重新尝试" cancleButtonTitle:@"确定" otherButtonTitle:nil];
}

- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{
	[self performSelector:@selector(backBtnClicked)];
	[m_statusBar showWithStatusMessage:@"分享人人网成功" withImage:@"success.png"];
	[self performSelector:@selector(statusBarHide) withObject:nil afterDelay:2.0f];
}

- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error
{
	[self dealWithError:error];
	[self performSelector:@selector(statusBarHide)];
}

- (void)dealWithError:(ROError *)error
{
    int errorCode = error.code;
    NSString *errorAlertString = error.localizedDescription;
    switch (errorCode) {
        case 20100:
            errorAlertString = @"您所选择的相册已删除，请重新选择相册";
            break;
        case 20101:
            errorAlertString = @"上传照片失败，请稍后重试";
            break;
        case 20102:
            errorAlertString = @"暂不支持此格式照片，请重新选择（20102）";
            break;
        case 20103:
            errorAlertString = @"暂不支持此格式照片，请重新选择（20103）";
            break;
        case 20105:
            errorAlertString = @"请输入相册密码";
            break;
        default:
            break;
    }
    [ShareFun alertNotice:@"沃·知天气" withMSG:errorAlertString cancleButtonTitle:@"确定" otherButtonTitle:nil];
}

#pragma mark - 腾讯login callback
//登录成功回调
- (void)onSuccessLogin
{
    [m_statusBar showWithStatusMessage:@"绑定腾讯成功" withImage:@"success.png"];
	[self performSelector:@selector(statusBarHide) withObject:nil afterDelay:2.0f];
	[self performSelector:@selector(refreshView)];
}

//登录失败回调
- (void)onFailureLogin:(NSError *)error
{
    NSLog(@"腾讯lonFailureLogin%@", error);
	[ShareFun alertNotice:@"沃·知天气" withMSG:@"腾讯微博绑定失败，请重新尝试" cancleButtonTitle:@"确定" otherButtonTitle:nil];
}

#pragma mark - 腾讯发微博callback
- (void)successCallBack:(id)result{
    [self performSelector:@selector(backBtnClicked)];
	[m_statusBar showWithStatusMessage:@"分享腾讯成功" withImage:@"success.png"];
	[self performSelector:@selector(statusBarHide) withObject:nil afterDelay:2.0f];
}

- (void)failureCallBack:(NSError *)error{
    NSLog(@"error: %@", error);
	[ShareFun alertNotice:@"沃·知天气" withMSG:@"腾讯微博发送失败，请重新尝试" cancleButtonTitle:@"确定" otherButtonTitle:nil];
	[self performSelector:@selector(statusBarHide)];
}

#pragma mark 字数统计
- (int)wordCount:(NSString*)s
{
    int i,n=[s length],l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[s characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return l+(int)ceilf((float)(a+b)/2.0);
}

@end
