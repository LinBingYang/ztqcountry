//
//  AppDelegate.m
//  ZtqCountry
//
//  Created by linxg on 14-6-10.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "AppDelegate.h"
#import "LaunchViewController.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
//#import "UMSocialSinaSSOHandler.h"
//#import "NetWorkCenter.h"
#import "JierijieqiAlert.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "XMLParser.h"
#import "XGPush.h"
#import "XGSetting.h"

#define _IPHONE80_ 80000
@implementation AppDelegate

- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSInteger t_tag = [[NSUserDefaults standardUserDefaults] integerForKey:@"url_type"];
    switch (t_tag)
    {
        case 0:
            URL_SERVER = ONLINE_URL;
            
            break;
        case 1:
            URL_SERVER = kTestAddress;
            
            break;
        case 2:
            URL_SERVER = ONLINE_URL;
            break;
        default:
            URL_SERVER = ONLINE_URL;
            
            break;
    }
    //读取setting中存储的数据
    [[setting sharedSetting] loadSetting];
    [setting sharedSetting].app = @"20002-131451111";
    [setting sharedSetting].fs=@"启动";
    [setting sharedSetting].dwstreet=nil;
    [[setting sharedSetting] setDevToken:[NSString stringWithFormat:@"d30b244ab63ef3e926c9b97e4e1c08b1c03d107e7d823f20372e76d9b9368ef0"]];
    [self initAreainfoList];//加载城市列表数据
    
    
    
    [AMapLocationServices sharedServices].apiKey =@"7dd7294f1eb47ff26db3ec800af22024";
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
    BOOL isdw=![[NSUserDefaults standardUserDefaults] boolForKey:@"dwswitch"];
    if (isdw==YES) {
        [self startLocation];
    }
    

     [[UMSocialManager defaultManager] setUmSocialAppkey:@"56ce7257e0f55a34c9000ae2"];

    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxe8c03b44d818926e" appSecret:@"4e5762c4bc8dbae141637b9445d1b263" redirectURL:@"weather.ikan365.cn"];

    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105322783"  appSecret:nil redirectURL:@"weather.ikan365.cn"];

    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3779491882"  appSecret:@"2150b7d2f94e41566589b554a2bdf637" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
 
    //友盟统计
    [MobClick startWithAppkey:@"56ce7257e0f55a34c9000ae2" reportPolicy:BATCH   channelId:@"weather.ikan365.cn"];
    
  //信鸽推送，
    [XGPush startApp:2200054102 appKey:@"IQNA195R6W4D"];
    //客户端初始化
    [self initApp];
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [self registerPush];
            }
            else{
                [self registerPushForIOS8];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [self registerPush];
#endif
        }
    };
    [XGPush initForReregister:successCallback];
    
    //[XGPush registerPush];  //注册Push服务，注册后才能收到推送
    
    //[XGPush setAccount:@"testAccount1"];
    
    
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
//
        NSDictionary*userInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        if(userInfo)
        {
            [self performSelector:@selector(handuserInfo:) withObject:userInfo afterDelay:5];
//            [self application:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
        }
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //清除所有通知(包含本地通知)
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
    //推送反馈(app不在前台运行时，点击推送激活时)
//    [XGPush handleLaunching:launchOptions];
    //腾讯bug
    [Bugly startWithAppId:@"900017625"];
    
    
    //启动界面
    LaunchViewController * launchVC = [[LaunchViewController alloc] init];
    CustomNavigationController * launchNavVC = [[CustomNavigationController alloc] initWithRootViewController:launchVC];
    self.firstNavigationController = launchNavVC;
//    NSLog(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$launch=%@$$$$$$$$$$$$$",launchNavVC);
    self.window.rootViewController = launchNavVC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    self.Jumpwidget=widgetTypeother;
    
    [self performSelector:@selector(stoplocation) withObject:nil afterDelay:6];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    const static NSString *APIKey = @"7dd7294f1eb47ff26db3ec800af22024";
    [AMapServices sharedServices].apiKey = (NSString *)APIKey;
    [self getShareContent];
    return YES;
}
-(void)locationcitydatasWithfilename:(NSString *)filename WithDownload:(BOOL)isdownload WithDownurl:(NSString *)urlstr{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [cachesPath stringByAppendingPathComponent:filename];
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if ([filemanager fileExistsAtPath:path]) {
        if (isdownload==YES) {
            [filemanager removeItemAtPath:path error:nil];//
            [self downFileFromServerWithfilename:filename WithUrl:urlstr];
            //开始下载
            [_downloadTask resume];
        }else{
            
            [self readdownloadxml:path withfilename:filename];
        }
    }else{
        [self downFileFromServerWithfilename:filename WithUrl:urlstr];
        //开始下载
        [_downloadTask resume];
    }
}
-(void)readdownloadxml:(NSString *)fileOfThePath withfilename:(NSString *)filename{
    @autoreleasepool {
        NSData *t_data = [NSData dataWithContentsOfFile:fileOfThePath];
        __strong TreeNode * root = [[XMLParser sharedInstance] parseXMLFromData:t_data];
        if ([filename isEqualToString:@"2"]) {//全国城市
            m_treeNodeAllCity = root;
        }
        if ([filename isEqualToString:@"4"]) {//景点
            m_treeNodelLandscape=root;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"complatecity" object:nil];//读取完
        }
       
    }
}
#pragma mark 下载城市列表数据
- (void)downFileFromServerWithfilename:(NSString *)filename WithUrl:(NSString *)urlstr{
    
    NSURL *URL = [NSURL URLWithString:urlstr];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    //    NSMutableURLRequest *request1 =[_serializer requestWithMethod:@"POST" URLString:@"" parameters:@"" error:nil];
    //下载Task操作
    _downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // @property int64_t totalUnitCount;  需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        
        // 给Progress添加监听 KVO
        //        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        // 回到主队列刷新UI
        
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:filename];
        
        return [NSURL fileURLWithPath:path];
        //        NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        //        return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        
        NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
        NSLog(@"%@",imgFilePath);
        if (imgFilePath.length<=0) {
            [[GetXMLData alloc] startRead:@"provinceList" withObject:self withFlag:0];
            isdownloadsuccess=NO;
        }
        if (isdownloadsuccess==YES) {
            [self readdownloadxml:imgFilePath withfilename:filename];
        }
        
        
    }];
}
//微信支付回调
-(void)onResp:(BaseResp *)resp{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:{
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                NSNotification *notification = [NSNotification notificationWithName:@"pay" object:@"success"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                break;
            }
            default:{
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                NSNotification *notification = [NSNotification notificationWithName:@"pay" object:@"fail"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                break;
            }
        }
    }
}

-(void)handuserInfo:(NSDictionary *)userInfo{
    [self application:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
}
#pragma mark 推送
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //它是类里自带的方法,这个方法得说下，很多人都不知道有什么用，它一般在整个应用程序加载时执行，挂起进入后也会执行，所以很多时候都会使用到
    [self performSelector:@selector(confirmationWasHidden:) withObject:nil];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationWillEnterForegroundWidgetAction" object:nil];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	//deviceToken:所得到的令牌，令牌的作用是公司服务器在链接apns即苹果服务器时需要发送的令牌，所以得到后一般会发送给公司服务器。
    //得到令牌
	//9638dc00d34af697168fe27ee74b2d63a910fc946dcee151306f82a6aa638758
	//9638dc00 d34af697 168fe27e e74b2d63 a910fc94 6dcee151 306f82a6 aa638758
//    NSString *devStr = [NSString stringWithFormat:@"%@",deviceToken];
//    NSLog(@"动态令牌%@",devStr);
//	NSString *t_devtoken = [NSString stringWithString:devStr];
//	t_devtoken = [t_devtoken stringByReplacingOccurrencesOfString:@" " withString:@""];
//	t_devtoken = [t_devtoken stringByReplacingOccurrencesOfString:@"<" withString:@""];
//	t_devtoken = [t_devtoken stringByReplacingOccurrencesOfString:@">" withString:@""];
//	
//	[[setting sharedSetting] setDevToken:t_devtoken];
//	NSLog(@"istokenDone!");
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"title" message:t_devtoken delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
//	//发送通知，token获取完毕
//	[[NSNotificationCenter defaultCenter] postNotificationName:@"tokenDone" object:nil];
    
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    [[setting sharedSetting] setDevToken:deviceTokenStr];//token存到本地
    [[setting sharedSetting] saveSetting];
    if (kSystemVersionMore9) {
        if ([setting sharedSetting].app.length>0&&[setting sharedSetting].devToken.length>0) {
            NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
            NSString *path = [docPath stringByAppendingPathComponent:@"APPFIRST"];
            NSFileManager *fm = [NSFileManager defaultManager];
            if([fm fileExistsAtPath:path] == NO)
            {
                
                [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"tokensuccess" object:nil];
            }
        }
    }
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]register successBlock ,deviceToken: %@",deviceTokenStr);
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]register errorBlock");
    };
    
    //注册设备
    
    [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    
    
    
    //打印获取的deviceToken的字符串
    NSLog(@"deviceTokenStr is %@",deviceTokenStr);
    

}

//调用push，请求获取动态令牌
- (void) confirmationWasHidden: (NSNotification *) notification
{
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationType)7];
	//[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationType)(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    //push错误
	NSLog(@"Error in registration. Error: %@", err);
	
	//模拟器无devicetoken错误，debug使用
	if (err.code == 3010)
		[[setting sharedSetting] setDevToken:[NSString stringWithFormat:@"999"]];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //收到的push消息，userInfo：push里服务器传递的相关信息，这个信息是由公司服务器自己设定的。可以在这里处理一些逻辑
     [XGPush handleReceiveNotification:userInfo];
    NSLog(@"remote notification: %@",[userInfo description]);
	NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
	
	NSString *alert = [apsInfo objectForKey:@"alert"];
	NSLog(@"Received Push Alert: %@", alert);
	
	NSString *sound = [apsInfo objectForKey:@"sound"];
	NSLog(@"Received Push Sound: %@", sound);
	//	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	
	NSString *badge = [apsInfo objectForKey:@"badge"];
	NSLog(@"Received Push Badge: %@", badge);
//	NSInteger t_badge=[[NSUserDefaults standardUserDefaults] integerForKey:@"badge"];
//    
//    t_badge=t_badge+1;
//    [[NSUserDefaults standardUserDefaults] setInteger:t_badge forKey:@"badge"];
//    
//	application.applicationIconBadgeNumber = t_badge;
    
		
    NSString *type=[userInfo objectForKey:@"TYPE"];
    //    int t_type=type.intValue;
    //int t_type=[userInfo objectForKey:@"types"];
    if ([type isEqualToString:@"预警"]) {
        NSString *t_content = [userInfo objectForKey:@"CONTENT"];
        
        NSString *t_title = [userInfo objectForKey:@"TITLE"];
        NSString *ico=[userInfo objectForKey:@"ICO"];
        NSString *time=[userInfo objectForKey:@"PTIME"];
        NSString *put=[userInfo objectForKey:@"AUTHOR"];
        NSString *ID=[userInfo objectForKey:@"ID"];

        self.TSID=ID;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
        NSDate *fromdate=[dateFormatter dateFromString:time];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setLocale:[NSLocale currentLocale]];
        [outputFormatter setDateFormat:@"MM月dd日HH:mm"];
        NSString *timestr = [outputFormatter stringFromDate:fromdate];
        NSString *putime=[NSString stringWithFormat:@"%@ %@",put,timestr];
        self.al=[[Alert alloc]initWithLogoImage:ico withTitle:t_title withContent:t_content WithTime:putime withType:@"预警"];
        self.al.tag=111;
        self.al.delegate=self;
        [self.al show];
        
    }
    else if([type isEqualToString:@"节日"]){
        NSString *t_content = [userInfo objectForKey:@"CONTENT"];
        NSString *ID=[userInfo objectForKey:@"ID"];
        NSString *t_title = [userInfo objectForKey:@"TITLE"];
        NSString *ico=[userInfo objectForKey:@"ICO"];
        self.TSID=ID;
        self.al=[[Alert alloc]initWithLogoImage:ico withTitle:t_title withContent:t_content WithTime:nil withType:@"节日"];
        self.al.tag=222;
        self.al.delegate=self;
        [self.al show];
        
        
    }
    else if([type isEqualToString:@"节气"]){
        NSString *t_content = [userInfo objectForKey:@"CONTENT"];
         NSString *ID=[userInfo objectForKey:@"ID"];
        NSString *t_title = [userInfo objectForKey:@"TITLE"];
        NSString *ico=[userInfo objectForKey:@"ICO"];
         self.TSID=ID;
        self.al=[[Alert alloc]initWithLogoImage:ico withTitle:t_title withContent:t_content WithTime:nil withType:@"节气"];
        self.al.tag=333;
        self.al.delegate=self;
        [self.al show];
        
    }else if ([type isEqualToString:@"专题"]){
        NSString *t_content = [userInfo objectForKey:@"CONTENT"];
        
        NSString *t_title = [userInfo objectForKey:@"TITLE"];
        self.al=[[Alert alloc]initWithLogoImage:@"弹窗头像" withTitle:t_title withContent:t_content WithTime:nil withType:@"专题"];
        self.al.tag=444;
        self.al.delegate=self;
        [self.al show];
        
        
    }else if ([type isEqualToString:@"公告"]){
        NSString *t_content = [userInfo objectForKey:@"CONTENT"];
        NSString *t_title = [userInfo objectForKey:@"TITLE"];
        self.al=[[Alert alloc]initWithLogoImage:@"弹窗头像" withTitle:t_title withContent:t_content WithTime:nil withType:@"公告"];
        self.al.tag=555;
        self.al.delegate=self;
        [self.al show];
        
    }
    //实况推送
    else if ([type isEqualToString:@"temp_h"]){
        NSString *MSG = [userInfo objectForKey:@"MSG"];
        NSString *city=[userInfo objectForKey:@"CITY"];
        NSString *temp=[userInfo objectForKey:@"TEMP"];
        NSString *t_time=[userInfo objectForKey:@"TIME"];
        NSString *t_content=[NSString stringWithFormat:@"%@当前气温%@℃。\n%@\n%@发布",city,temp,MSG,t_time];
        [ShareFun alertNotice:@"知天气提示" withMSG:t_content cancleButtonTitle:@"确认" otherButtonTitle:@""];
        //            NSLog(@"contetn = #%@#",t_content);
        
    }else if ([type isEqualToString:@"temp_l"]){
        NSString *MSG = [userInfo objectForKey:@"MSG"];
        NSString *city=[userInfo objectForKey:@"CITY"];
        NSString *temp=[userInfo objectForKey:@"TEMP"];
        NSString *t_time=[userInfo objectForKey:@"TIME"];
        NSString *t_content=[NSString stringWithFormat:@"%@当前气温%@℃。\n%@\n%@发布",city,temp,MSG,t_time];
        [ShareFun alertNotice:@"知天气提示" withMSG:t_content cancleButtonTitle:@"确认" otherButtonTitle:@""];
        
    }else if ([type isEqualToString:@"vis_l"]){
        NSString *MSG = [userInfo objectForKey:@"MSG"];
        NSString *city=[userInfo objectForKey:@"CITY"];
        NSString *temp=[userInfo objectForKey:@"VIS"];
        NSString *t_time=[userInfo objectForKey:@"TIME"];
        NSString *t_content=[NSString stringWithFormat:@"%@当前能见度%@m。\n%@\n%@发布",city,temp,MSG,t_time];
        [ShareFun alertNotice:@"知天气提示" withMSG:t_content cancleButtonTitle:@"确认" otherButtonTitle:@""];
        
    }else if ([type isEqualToString:@"hum_h"]){
        NSString *MSG = [userInfo objectForKey:@"MSG"];
        NSString *city=[userInfo objectForKey:@"CITY"];
        NSString *temp=[userInfo objectForKey:@"HUM"];
        NSString *t_time=[userInfo objectForKey:@"TIME"];
        NSString *t_content=[NSString stringWithFormat:@"%@当前湿度%@%%。\n%@\n%@发布",city,temp,MSG,t_time];
        [ShareFun alertNotice:@"知天气提示" withMSG:t_content cancleButtonTitle:@"确认" otherButtonTitle:@""];
        
    }else if ([type isEqualToString:@"hum_l"]){
        NSString *MSG = [userInfo objectForKey:@"MSG"];
        NSString *city=[userInfo objectForKey:@"CITY"];
        NSString *temp=[userInfo objectForKey:@"HUM"];
        NSString *t_time=[userInfo objectForKey:@"TIME"];
        NSString *t_content=[NSString stringWithFormat:@"%@当前湿度%@%%。\n%@\n%@发布。",city,temp,MSG,t_time];
        [ShareFun alertNotice:@"知天气提示" withMSG:t_content cancleButtonTitle:@"确认" otherButtonTitle:@""];
        
    }
    else if ([type isEqualToString:@"rain_h"]){
        NSString *MSG = [userInfo objectForKey:@"MSG"];
        NSString *city=[userInfo objectForKey:@"CITY"];
        NSString *temp=[userInfo objectForKey:@"RAIN"];
        NSString *t_time=[userInfo objectForKey:@"TIME"];
        NSString *t_content=[NSString stringWithFormat:@"%@当前雨量%@mm。\n%@\n%@发布。",city,temp,MSG,t_time];
        [ShareFun alertNotice:@"知天气提示" withMSG:t_content cancleButtonTitle:@"确认" otherButtonTitle:@""];
        
    }
    else if ([type isEqualToString:@"wspeed_h"]){
        NSString *MSG = [userInfo objectForKey:@"MSG"];
        NSString *city=[userInfo objectForKey:@"CITY"];
        NSString *temp=[userInfo objectForKey:@"WSPEED"];
        NSString *t_time=[userInfo objectForKey:@"TIME"];
        
        NSString *t_content=[NSString stringWithFormat:@"%@当前风速%@m/s。\n%@\n%@发布。",city,temp,MSG,t_time];
        [ShareFun alertNotice:@"知天气提示" withMSG:t_content cancleButtonTitle:@"确认" otherButtonTitle:@""];
        
    }

}
-(void)push_yjxx{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * airInfoSimple = [[NSMutableDictionary alloc] init];
    [airInfoSimple setObject:self.TSID forKey:@"id"];
    [b setObject:airInfoSimple forKey:@"gz_query_warn_by_id"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData){
//        NSLog(@"%@",returnData);
        NSDictionary *t_b=[returnData objectForKey:@"b"];
        NSDictionary *push_yjxx=[t_b objectForKey:@"gz_query_warn_by_id"];
        NSDictionary *dws=[push_yjxx objectForKey:@"warn"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushyjxx" object:dws];
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
-(void)getHolidayinfo{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * airInfoSimple = [[NSMutableDictionary alloc] init];
    [airInfoSimple setObject:self.TSID forKey:@"id"];
    [b setObject:airInfoSimple forKey:@"gz_query_holiday_info"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData){
        //        NSLog(@"%@",returnData);
        NSDictionary *t_b=[returnData objectForKey:@"b"];
        NSDictionary *push_yjxx=[t_b objectForKey:@"gz_query_holiday_info"];
        NSDictionary *dws=[push_yjxx objectForKey:@"holiday"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushholiday" object:dws];
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
-(void)moreAction{
    if (self.al.tag==111) {
        [self push_yjxx];
        
    }
    if (self.al.tag==222) {
        [self getHolidayinfo];
    }
    if (self.al.tag==333) {
        [self getHolidayinfo];
    }
    if (self.al.tag==444) {
        
    }
    if (self.al.tag==555) {
        
    }
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *queryString = [url query];
    
    NSLog(@"url :%@query:%@",url,queryString);
    if([@"Identifier=ztqNew" isEqualToString:queryString])
        
    {
        
        return YES;
        
    }
    
    else
        
    {
        
        return NO;
        
    }
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        
    }

    return  result;
}
//进行程序间的回调的时候调用的方法
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSString *widgetStr=url.absoluteString;
    
    if ([widgetStr rangeOfString:@"ztqNEW.lvyouqixiang"].length) {
        /**
         *  跳转指点天气
         */
        
        self.Jumpwidget=widgetTypeLVQX;
        
        
        
    }else if([widgetStr rangeOfString:@"ztqNEW.fengyuchaxun"].length)
    {  /**
        *  跳转气象产品
        */
        
        self.Jumpwidget=widgetTypeFYCX;
        
        
        
    }else if([widgetStr rangeOfString:@"ztqNEW.yujingxxWidget"].length)
    {
        /**
         *  跳转预警信息界面
         */
        self.Jumpwidget=widgetTypeYJXX;
    }
    

    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
            NSString *resultStatus=[resultDic objectForKey:@"resultStatus"];
            if ([resultStatus isEqualToString:@"9000"]) {
                NSLog(@"支付成功");
                NSNotification *notification = [NSNotification notificationWithName:@"pay" object:@"success"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }else{
                NSNotification *notification = [NSNotification notificationWithName:@"pay" object:@"fail"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
            NSString *resultStatus=[resultDic objectForKey:@"resultStatus"];
            if ([resultStatus isEqualToString:@"9000"]) {
                NSLog(@"支付成功");
                NSNotification *notification = [NSNotification notificationWithName:@"pay" object:@"success"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }else{
                NSNotification *notification = [NSNotification notificationWithName:@"pay" object:@"fail"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
        }];
    }
    
    NSLog(@"跳转到URL schema中配置的地址-->%@",url);//跳转到URL schema中配置的地址
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    BOOL r=[WXApi handleOpenURL:url delegate:self];
    if (r==YES) {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    if (result == FALSE) {
        //调用其他SDK，例如新浪微博SDK等
        return [WXApi handleOpenURL:url delegate:self];
    }
    return result;

}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidEnterBackground" object:nil];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"badge"];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationWillEnterForeground" object:nil];
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"updataHotAction" object:nil];
}

//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"#%@#",notification.userInfo);
    NSDictionary * info = [notification.userInfo objectForKey:@"dictionary"];
    NSString * message = [info objectForKey:@"message"];
    NSString * title = [info objectForKey:@"title"];
    NSString * clockID = [info objectForKey:@"clockID"];
    if ([clockID isEqualToString:@"tianqinaozhong2"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"autoSpeak" object:nil];
    }
    if([clockID isEqualToString:@"jieqitixingtuisong"])
    {
        JierijieqiAlert * alert = [[JierijieqiAlert alloc] initWithTitle:title withLogoImageName:@"秋分.png" withContentStr:message];
        [alert show];
    }
    else if([clockID isEqualToString:@"jieritixingtuisong"])
    {
        
        JierijieqiAlert * alert = [[JierijieqiAlert alloc] initWithTitle:title withLogoImageName:@"秋分.png" withContentStr:message];
        [alert show];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    //    if([clockID isEqualToString:@"jieqitixingtuisong"])
    //    {
    //        NSString * imageName = [NSString stringWithFormat:@"%@.png",info];
    //        Alrert * alrate = [[Alrert alloc] initWithTitle:title imageView:[UIImage imageNamed:imageName] contentText:message leftButtonTitle:@"确定"];
    //        [alrate show];
    //    }
    //    else
    //    {
    
    //    }
    
    //    [[UIApplication sharedApplication] cancelLocalNotification:notification];
}
//开始定位城市
- (void) startLocation
{
    
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        [self.locationManager stopUpdatingLocation];

    }
    else
    {
        
//        [self.locationManager startUpdatingLocation];
        m_locationManager = [[CLLocationManager alloc] init];
        m_locationManager.delegate = self;
        if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0))
        {
            //设置定位权限，仅ios8有意义
            [m_locationManager requestAlwaysAuthorization];
        }
        m_locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
        //发生事件的最小距离间隔
        m_locationManager.distanceFilter = 1000.0f;

        [m_locationManager startUpdatingLocation];
//        [self performSelector:@selector(recogedCity) withObject:nil afterDelay:3];
    }
}
-(void)stoplocation{
    [self.locationManager stopUpdatingLocation];
    [m_locationManager stopUpdatingLocation];
}

//系统的定位
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    for (CLLocation *location in locations) {
         NSLog(@"appdelegate:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    }
}
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//     NSLog(@"appdelegate:{lat:%f; lon:%f; accuracy:%f}", newLocation.coordinate.latitude, newLocation.coordinate.longitude, newLocation.horizontalAccuracy);
//}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [manager stopUpdatingLocation];
}

#pragma mark - 高德的代理
-(void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    [self.locationManager stopUpdatingLocation];
}
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    
    
     NSLog(@"appdelegate:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    
    
}
-(void)recogedCity{
    
    
    self.locationManager.delegate=nil;
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        if (regeocode)
        {
//            [m_locationManager stopUpdatingLocation];
            NSLog(@"location1:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
            NSLog(@"reGeocode:%@", regeocode);
            NSString *street=regeocode.street;
            if (street.length>0) {
                [setting sharedSetting].dwstreet=street;
            }else{
                [setting sharedSetting].dwstreet=regeocode.township;
            }
            NSString *t_city = [NSString stringWithFormat:@"%@", regeocode.district];
            if (regeocode.province.length>0) {
                self.provice=[regeocode.province substringToIndex:[regeocode.province length]-1];
            }
            
            if ([regeocode.city hasSuffix:@"市"])
            {
                NSArray *t_array = [regeocode.city componentsSeparatedByString:@"市"];
                
                if ([t_array count] > 0)
                {
                    t_city = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
                }
            }
            if ([regeocode.district hasSuffix:@"市"])
            {
                NSArray *t_array = [regeocode.district componentsSeparatedByString:@"市"];
                
                if ([t_array count] > 0)
                {
                    t_city = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
                    if ([self readXMLcity:t_city]==NO) {
                        if ([regeocode.city hasSuffix:@"市"])
                        {
                            NSArray *t_array = [regeocode.city componentsSeparatedByString:@"市"];
                            
                            if ([t_array count] > 0)
                            {
                                t_city = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
                            }
                        }
                    }
                }
            }
            if ([regeocode.district hasSuffix:@"县"])
            {
                NSArray *t_array = [regeocode.district componentsSeparatedByString:@"县"];
                
                if ([t_array count] > 0)
                {
                    t_city = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
                    if ([self readXMLcity:t_city]==NO) {
                        if ([regeocode.city hasSuffix:@"市"])
                        {
                            NSArray *t_array = [regeocode.city componentsSeparatedByString:@"市"];
                            
                            if ([t_array count] > 0)
                            {
                                t_city = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
                            }
                        }
                    }
                }
            }
            if ([regeocode.district hasSuffix:@"区"])
            {
                NSArray *t_array = [regeocode.district componentsSeparatedByString:@"区"];
                
                if ([t_array count] > 0)
                {
                    t_city = [NSString stringWithFormat:@"%@区", [t_array objectAtIndex:0]];
                    if ([self readXMLcity:t_city]==NO) {
                        if ([regeocode.city hasSuffix:@"市"])
                        {
                            NSArray *t_array = [regeocode.city componentsSeparatedByString:@"市"];
                            
                            if ([t_array count] > 0)
                            {
                                t_city = [NSString stringWithFormat:@"%@", [t_array objectAtIndex:0]];
                            }
                        }
                    }
                    
                }
                
            }
            NSLog(@"哈哈%@", t_city);
            self.DWcity=t_city;
            [self readXML];
            if (self.DWid.length>0) {
                
                [setting sharedSetting].dingweicity=self.DWid;
                [setting sharedSetting].currentCityID = self.DWid;
                [setting sharedSetting].currentCity = self.DWcity;
                [setting sharedSetting].morencity=self.DWcity;
                [setting sharedSetting].morencityID=self.DWid;
                
                
                [[setting sharedSetting] saveSetting];
            }
            
        }
    }];
}
-(void)readXML{
    m_allCity=m_treeNodeAllCity;
    for (int i = 0; i < [m_allCity.children count]; i ++)
    {
        TreeNode *t_node = [m_allCity.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:1];
        TreeNode * t_cityname = [t_node.children objectAtIndex:2];
        NSString *t_name = t_cityname.leafvalue;
        if ([t_node_child.leafvalue isEqualToString:[self readXMLproviceId:self.provice]]) {
            if ([self.DWcity isEqualToString:t_name])
            {
                //----------------------------------------------------
                t_node_child = [t_node.children objectAtIndex:5];
                TreeNode *t_node_child1 = [t_node.children objectAtIndex:0];
                NSString *Id = t_node_child1.leafvalue;
                [[NSUserDefaults standardUserDefaults]setObject:Id forKey:@"DWid"];
                self.DWid=Id;
                break;
            }
        }
        
    }
    
    
}
-(BOOL)readXMLcity:(NSString *)city{
    BOOL iscity=NO;
    m_allCity=m_treeNodeAllCity;
    for (int i = 0; i < [m_allCity.children count]; i ++)
    {
        TreeNode *t_node = [m_allCity.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:1];
        t_node_child = [t_node.children objectAtIndex:2];
        NSString *t_name = t_node_child.leafvalue;
        if ([city isEqualToString:t_name])
        {
            iscity=YES;
        }
    }
    
    return iscity;
}
-(NSString *)readXMLproviceId:(NSString *)city{
    NSString *proid=nil;
    m_allprovice=m_treeNodeProvince;
    for (int i = 0; i < [m_allprovice.children count]; i ++)
    {
        TreeNode *t_node = [m_allprovice.children objectAtIndex:i];
        TreeNode *t_node_child = [t_node.children objectAtIndex:1];
        t_node_child = [t_node.children objectAtIndex:2];
        NSString *t_name = t_node_child.leafvalue;
        if ([city rangeOfString:t_name].location!=NSNotFound)
        {
            TreeNode *t_proid=[t_node.children objectAtIndex:0];
            proid=t_proid.leafvalue;
            break;
        }
    }
    
    return proid;
}
-(void)initApp
{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * init = [[NSMutableDictionary alloc] init];
    if ([setting getMainApp].length>0) {
        [init setObject:[setting getMainApp] forKey:@"app"];
    }
    if ([setting getmodel].length>0) {
        [init setObject:[setting getmodel] forKey:@"xh"];
    }
    if ([setting getSysVersion].length>0) {
        [init setObject:[setting getSysVersion] forKey:@"sys"];
    }
    
    if ([setting getSysUid].length>0) {
        [init setObject:[setting getSysUid] forKey:@"imei"];
    }
    if ([setting getImsi].length>0) {
        [init setObject:[setting getImsi] forKey:@"sim"];
    }
    if ([setting getMainVersion].length>0) {
        [init setObject:[setting getMainVersion] forKey:@"sv"];
    }
    
    [b setObject:init forKey:@"gz_init"];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    NSString *str=[param urlEncodedStringCustom];//将参数转为Json
    NSDictionary *parameters = @{@"p":str};
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * b = [responseObject objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * init = [b objectForKey:@"gz_init"];
            [setting sharedSetting].app = [init objectForKey:@"pid"];
            [[setting sharedSetting]saveSetting];
        }else{
            [setting sharedSetting].app = @"20002-156asd23as114";
            [[setting sharedSetting]saveSetting];
        }
        
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"%@",error);
    }];

    
}
-(void)getShareContent{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:@"ABOUT_GZ_DOWN" forKey:@"keyword"];
    [b setObject:gz_todaywt_inde forKey:@"gz_wt_share"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_wt_share"];
            NSString *sharecontent=[gz_air_qua_index objectForKey:@"share_content"];
            sharecontenturl=sharecontent;
        }
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
-(void)sendIOSpush{
    
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * setProperty = [[NSMutableDictionary alloc] init];
    if ([setting sharedSetting].app.length>0) {
        [h setObject:[setting sharedSetting].app forKey:@"p"];
    }
    if ([setting sharedSetting].devToken.length>0) {
        [setProperty setObject:[setting sharedSetting].devToken forKey:@"token"];
    }
    [b setObject:setProperty forKey:@"gz_settagfor"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        
    } withFailure:^(NSError *error) {
        
    } withCache:NO];
    
}
-(void)initAreainfoList
{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * sstq = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    [b setObject:sstq forKey:@"gz_area_info_list"];
    [sstq setObject:@"2" forKey:@"app_type"];
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary *area_info_list=[b objectForKey:@"gz_area_info_list"];
            NSArray *list=[area_info_list objectForKey:@"info_list"];
            if (list.count>0) {
                self.arealist=list;
                isdownloadsuccess=YES;
                [[GetXMLData alloc] startRead:@"provinceList" withObject:self withFlag:6];
                
            }else{
                [[GetXMLData alloc] startRead:@"provinceList" withObject:self withFlag:0];
            }
            
            
            
            
            
        }else{
            
            NSArray *locationlist=[[NSUserDefaults standardUserDefaults]objectForKey:@"areainfolist"];
            if (locationlist.count>0) {
                self.arealist=locationlist;
                [[GetXMLData alloc] startRead:@"provinceList" withObject:self withFlag:6];
            }else{
                [[GetXMLData alloc] startRead:@"provinceList" withObject:self withFlag:0];
            }
        }
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
       
        [[GetXMLData alloc] startRead:@"provinceList" withObject:self withFlag:0];
     
        
    } withCache:NO];
    
}
#pragma mark xml delegate

-(void)readFinish:(TreeNode *)p_treeNode withFlag:(int)p_flag
{
    if(p_flag == 0)
    {
        m_treeNodeProvince = p_treeNode;
        NSLog(@"privince list load finish!");
        
        [[GetXMLData alloc] startRead:@"cityList" withObject:self withFlag:1];
    }
    else if (p_flag == 1)
    {
        m_treeNodeAllCity = p_treeNode;


        [[GetXMLData alloc] startRead:@"landscapeList" withObject:self withFlag:2];
    }
    else if (p_flag == 2)
    {
        m_treeNodelLandscape = p_treeNode;
        [[GetXMLData alloc] startRead:@"t_area" withObject:self withFlag:3];
        //isGetXML = YES;
        
    }
    else if (p_flag==3){
        m_treeNodearea=p_treeNode;
        [[GetXMLData alloc] startRead:@"birth_city" withObject:self withFlag:4];
    }
    else if (p_flag==4){
        m_treeNodebirthcity=p_treeNode;
        [[GetXMLData alloc] startRead:@"birth_county" withObject:self withFlag:5];
    }
    else if (p_flag==5){
        m_treeNodebirthcountry=p_treeNode;
        NSLog(@"XML is finish!");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"complatecity" object:nil];
    }else if (p_flag==6){//后面4种不取接口，直接读本地
        m_treeNodeProvince = p_treeNode;
        [[GetXMLData alloc] startRead:@"birth_city" withObject:self withFlag:7];
    }else if (p_flag==7){
        m_treeNodebirthcity=p_treeNode;
        [[GetXMLData alloc] startRead:@"birth_county" withObject:self withFlag:8];
        
    }else if (p_flag==8){
        m_treeNodebirthcountry=p_treeNode;
         [[GetXMLData alloc] startRead:@"t_area" withObject:self withFlag:9];
    }else if (p_flag==9){
        m_treeNodearea=p_treeNode;//剩下读接口
        NSArray *locationlist=[[NSUserDefaults standardUserDefaults]objectForKey:@"areainfolist"];
        if (locationlist.count>0) {//对比本地缓存的时间有改变就下载
            if (self.arealist.count==locationlist.count) {
                for (int i=0; i<self.arealist.count; i++) {
                    NSString *datetime=[self.arealist[i] objectForKey:@"pub_time"];
                    NSString *datetime1=[locationlist[i] objectForKey:@"pub_time"];
                    NSString *url=[self.arealist[i] objectForKey:@"url"];
                    NSString *channel_id=[self.arealist[i] objectForKey:@"channel_id"];
                    if (![datetime isEqualToString:datetime1]) {
                        if ([channel_id isEqualToString:@"2"]||[channel_id isEqualToString:@"4"]) {
                            [self locationcitydatasWithfilename:channel_id WithDownload:YES WithDownurl:[ShareFun makeImageUrlStr:url]];//删除本地在下载
                        }
                        
                    }else{if ([channel_id isEqualToString:@"2"]||[channel_id isEqualToString:@"4"]) {
                        [self locationcitydatasWithfilename:channel_id WithDownload:NO WithDownurl:[ShareFun makeImageUrlStr:url]];//读取本地数据
                    }
                    }
                }
            }else{//全部重新下载
                if (self.arealist.count>0) {
                    for (int i=0; i<self.arealist.count; i++) {
                        NSString *url=[self.arealist[i] objectForKey:@"url"];
                        NSString *channel_id=[self.arealist[i] objectForKey:@"channel_id"];
                        if ([channel_id isEqualToString:@"2"]||[channel_id isEqualToString:@"4"]) {
                            [self locationcitydatasWithfilename:channel_id WithDownload:YES WithDownurl:[ShareFun makeImageUrlStr:url]];//删除本地在下载
                        }
                    }
                }else{
                    [[GetXMLData alloc] startRead:@"provinceList" withObject:self withFlag:0];
                }
            }
        }else{
            //第一次
            if (self.arealist.count>0) {
                for (int i=0; i<self.arealist.count; i++) {
                    NSString *url=[self.arealist[i] objectForKey:@"url"];
                    NSString *channel_id=[self.arealist[i] objectForKey:@"channel_id"];
                    if ([channel_id isEqualToString:@"2"]||[channel_id isEqualToString:@"4"]) {
                        [self locationcitydatasWithfilename:channel_id WithDownload:YES WithDownurl:[ShareFun makeImageUrlStr:url]];//删除本地在下载
                    }
                }
            }else{
                [[GetXMLData alloc] startRead:@"provinceList" withObject:self withFlag:0];
            }
            
        }
        [[NSUserDefaults standardUserDefaults]setObject:self.arealist forKey:@"areainfolist"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    
    
}
@end
