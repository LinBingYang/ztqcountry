//
//  setting.m
//  Ztq_public
//
//  Created by yu lz on 12-1-4.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "setting.h"
#import "sys/utsname.h"
#import "ShareFun.h"
//#import "NetWorkCenter.h"


@implementation setting
@synthesize citys, app;
@synthesize currentCity,currentCityID,dingweicity,dwstreet;
@synthesize morencity,morencityID;
@synthesize systime;
// fs, idx, index, updateInterval, provinceIndex;
@synthesize lifedic;
@synthesize meterologicalDic;
@synthesize devToken;
@synthesize fs;
@synthesize info_shareWeather;
@synthesize info_recommend;
@synthesize ztq_about;
@synthesize memodic;
@synthesize memos;

static setting *settingSingleton = nil;

+ (setting*) sharedSetting
{
	@synchronized(self)
	{
//		if (!settingSingleton)
//		{
//			settingSingleton = [[setting alloc] init];
//		}
//		return settingSingleton;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            settingSingleton = [[setting alloc] init];
            
        });
        return settingSingleton;
	}
}

//- (id) retain
//{
//    return self;	
//}

//- (NSUInteger) retainCount
//{
//    return NSUIntegerMax;  //denotes an object that cannot be released	
//}



//- (id) autorelease
//{
//    return self;
//}

- (id)init
{
	if (self = [super init])
	{
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSError *error;
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *plistName=@"setting";
		NSString *full_name=@"setting.plist";
		NSString *t_str = [documentsDirectory stringByAppendingPathComponent:full_name];
		appFile = [[NSString alloc] initWithString:t_str];
		if ([fileManager fileExistsAtPath:appFile] == NO)
		{
			NSString *pathToDefaultPlist = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
            
			if ([fileManager copyItemAtPath:pathToDefaultPlist toPath:appFile error:&error] == NO)
            {
                NSLog(@"nnn");
			}
		}
        app=@"";
		devToken = @"";
        currentCityID = @"";
        currentCity = @"";
        dingweicity=@"";
        morencity=@"";
        morencityID=@"";
        systime=@"";
        fs=@"";
        dwstreet=@"";
//        lifedic=[NSDictionary new];
//        meterologicalDic = [NSMutableDictionary new];
		[self loadSetting];
	}
	return self;
}

- (void)dealloc
{
	[self saveSetting];
//	[citys release];
//	[app release];
//	[appFile release];
//	[devToken release];
//    [version_app release];
//    [uid release];
//	[super dealloc];
}

- (void) loadSetting
{
	NSMutableDictionary *t_dic = [[NSMutableDictionary alloc] initWithContentsOfFile:appFile];
	
	if (citys != nil)
    {
        citys = nil;
//		[citys release];
    }
    if (memos != nil)
    {
        memos = nil;
        
    }
	if (app != nil)
    {
        app = nil;
//        [app release];
    }
    if(currentCity !=nil)
    {
        currentCity = nil;
    }
    if(currentCityID != nil)
    {
        currentCityID = nil;
    }
    if(dingweicity != nil)
    {
        dingweicity = nil;
    }

    if(morencity !=nil)
    {
        morencity = nil;
    }
    if(morencityID != nil)
    {
        morencityID = nil;
    }
    if(systime != nil)
    {
        systime = nil;
    }
    if(lifedic != nil)
    {
        lifedic = nil;
    }
    if(meterologicalDic != nil)
    {
        meterologicalDic = nil;
    }
    if(fs != nil)
    {
        fs = nil;
    }
    if(memodic != nil)
    {
        memodic = nil;
    }
    if(dwstreet !=nil)
    {
        dwstreet = nil;
    }
    citys = [[NSMutableArray alloc] initWithArray:[t_dic objectForKey:@"citys"]];
    memos = [[NSMutableArray alloc] initWithArray:[t_dic objectForKey:@"memos"]];
    app = [[NSString alloc] initWithString:[t_dic objectForKey:@"app"]];
    currentCity = [t_dic objectForKey:@"currentCity"];
    currentCityID = [t_dic objectForKey:@"currentCityID"];
    dingweicity=[t_dic objectForKey:@"currentCityChina"];
    morencity = [t_dic objectForKey:@"morencity"];
    morencityID = [t_dic objectForKey:@"morencityID"];
    systime=[t_dic objectForKey:@"systime"];
    lifedic=[t_dic objectForKey:@"lifeDic"];
    meterologicalDic = [t_dic objectForKey:@"meterologicalDic"];
    dwstreet = [t_dic objectForKey:@"dwstreet"];
	fs = [t_dic objectForKey:@"fsopen"];
   	memodic = [t_dic objectForKey:@"memoDic"];
    
//	NSString *t_idxStr = [t_dic objectForKey:@"idx"];
//	if (t_idxStr != nil)
//		idx = (int)[t_idxStr intValue];
	
//	NSString *t_index = [t_dic objectForKey:@"index"];
//	if (t_index != nil)
//		index = (int)[t_index intValue];
	
//	NSString *t_udStr = [t_dic objectForKey:@"ud"];
//	if (t_udStr != nil)
//		updateInterval = [t_udStr intValue];
//	if (updateInterval <= 0)
//		updateInterval = 1800;
	
//	NSString *t_pIndex = [t_dic objectForKey:@"provinceIndex"];
//	if (t_pIndex != nil)
//		provinceIndex = [t_pIndex intValue];
	
//	[t_dic release];
}

- (void) saveSetting
{
	NSMutableDictionary *t_dic = [[NSMutableDictionary alloc] initWithCapacity:4];
	if (citys != nil)
		[t_dic setObject:citys forKey:@"citys"];
    if (memos != nil)
        [t_dic setObject:memos forKey:@"memos"];
	if (app != nil)
		[t_dic setObject:app forKey:@"app"];
    if(currentCity !=nil)
        [t_dic setObject:currentCity forKey:@"currentCity"];
    if(currentCityID != nil)
        [t_dic setObject:currentCityID forKey:@"currentCityID"];
    if(dingweicity != nil)
        [t_dic setObject:dingweicity forKey:@"currentCityChina"];
    if(morencity !=nil)
        [t_dic setObject:morencity forKey:@"morencity"];
    if(morencityID != nil)
        [t_dic setObject:morencityID forKey:@"morencityID"];
    if(lifedic != nil)
        [t_dic setObject:lifedic forKey:@"lifeDic"];
    if(meterologicalDic != nil)
       [t_dic setObject:meterologicalDic forKey:@"meterologicalDic"];
    if(memodic != nil)
        [t_dic setObject:memodic forKey:@"memoDic"];
    if(systime != nil)
        [t_dic setObject:systime forKey:@"systime"];
	if (fs != nil)
		[t_dic setObject:fs forKey:@"fsopen"];
    if (dwstreet != nil)
        [t_dic setObject:dwstreet forKey:@"dwstreet"];
//   	[t_dic setObject:[NSString stringWithFormat:@"%d", idx] forKey:@"idx"];
//	[t_dic setObject:[NSString stringWithFormat:@"%d", index] forKey:@"index"];
//	[t_dic setObject:[NSString stringWithFormat:@"%d", updateInterval] forKey:@"ud"];
//	[t_dic setObject:[NSString stringWithFormat:@"%d", provinceIndex] forKey:@"provinceIndex"];
	
	[t_dic writeToFile:appFile atomically:NO];
//	[t_dic release];
}

+ (NSString *) getMainVersion
{
	return kMinVersoin;
}

+ (NSString *) getMainApp
{
	return kMinApp;
}

+ (NSString *) getChannel
{
	return kReleaseChannel;
}

+ (NSString *) getSysUid
{
	NSString *uuid ;
    //获取钥匙串里uuid的保存值
    NSError *error = nil;
    NSString *password = [SSKeychain passwordForService:pcsserviceName account:appAccount error:&error];
    if ([error code] == SSKeychainErrorNotFound) {
        NSLog(@"openUDID not in app");
        NSString* openUDID = [OpenUDID value];
        [SSKeychain setPassword:openUDID forService:pcsserviceName account:appAccount];
        NSLog(@"openUDID save successfully");
        uuid=openUDID;
    }else{
        uuid=password;
//        NSLog(@"UUID:%@",uuid);
    }
    
	return uuid;

}

+ (NSString *) getSysVersion
{
	NSString *sysVersion = [NSString stringWithFormat:@"IOS %@", [[UIDevice currentDevice] systemVersion]];
	return sysVersion;
}
//获取手机型号
+ (NSString *) getmodel{
    return [[UIDevice currentDevice] model];
}
+ (NSString *) getImsi
{
	return @"";
}

+ (NSInteger) getMainScreenHeght
{
	NSInteger h = [[UIScreen mainScreen] bounds].size.height;
	return h;
}

+ (NSInteger) getMainScreenWidth
{
	NSInteger w = [[UIScreen mainScreen] bounds].size.width;
	return w;
}

//获取8位随机验证码
+(NSString *)getcode{
    NSString *code=@"";
    for (int i=0; i<8; i++) {
        code=[NSString stringWithFormat:@"%@%d",code,arc4random()%10];
    }
    return code;
}

//-(void)loadthemeImg
//{
//    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//    NSMutableDictionary * ztq_img = [[NSMutableDictionary alloc] init];
//    [h setObject:[setting sharedSetting].app forKey:@"p"];
//    [ztq_img setObject:@"I" forKey:@"phone_type"];
//    NSString * size_type = nil;
//    if(kScreenHeitht >500)
//    {
//        size_type = @"1";
//    }
//    else
//    {
//        size_type = @"2";
//    }
//    [ztq_img setObject:size_type forKey:@"size_type"];
//    [b setObject:ztq_img forKey:@"ztq_img"];
//    [param setObject:h forKey:@"h"];
//    [param setObject:b forKey:@"b"];
//    
//    [[NetWorkCenter share] postHttpWithUrl:URL_SERVER withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
//        NSLog(@"$%@$",returnData);
//        NSDictionary * b = [returnData objectForKey:@"b"];
//        NSDictionary * ztq_img = [b objectForKey:@"ztq_img"];
//        NSDictionary * dataList = [ztq_img objectForKey:@"dataList"];
//        NSString * url = [dataList objectForKey:@"url"];
//        if(url.length)
//        {
//            
//            NSString * urlStr = [ShareFun makeImageUrlStr:url];
//            NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
//            NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//            [connection start];
//        }
//        else
//        {
//            if(kScreenHeitht >500)
//            {
//                self.themeImg = [UIImage imageNamed:@"全国版IOS-启动界面(640X960).jpg"];
//            }
//            else
//            {
//                 self.themeImg = [UIImage imageNamed:@"chengshibg.jpg"];
//            }
//        }
//    } withFailure:^(NSError *error) {
//       
//    } withCache:NO];
//
//}
//
//-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    self.themeImgData = [[NSMutableData alloc] init];
//}
//
//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    [self.themeImgData appendData:data];
//}
//
//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    if(kScreenHeitht >500)
//    {
//        self.themeImg = [UIImage imageNamed:@"全国版IOS-启动界面(640X960).jpg"];
//    }
//    else
//    {
//        self.themeImg = [UIImage imageNamed:@"chengshibg.jpg"];
//    }
//}
//-(void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    self.themeImg = [UIImage imageWithData:self.themeImgData];
//}

//+(void)pretreatmentWeather
//{
//    [setting loadingAllCitySSTQ];
//    [setting loadingAllCityYjxx];
//    [setting loadingAllCityWeekTQ];
//    [setting loadingAllCitySixhyb];
//    [setting loadingAllCityAirInfoSimple];
//    [setting loadingAllCityShzs];
//}
//
////下载数据 实时天气
//+(void)loadingAllCitySSTQ
//{
//    if([setting sharedSetting].citys.count)
//    {
//        NSString * urlStr = URL_SERVER;
//        NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//        NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//        [h setObject:[setting sharedSetting].app forKey:@"p"];
//     
//        for(int i=0;i<[setting sharedSetting].citys.count;i++)
//        {
//            NSMutableDictionary * sstq = [[NSMutableDictionary alloc] init];
//            NSDictionary * currentCityInfo = [[setting sharedSetting].citys objectAtIndex:i];
//            NSString * currentID =[currentCityInfo objectForKey:@"ID"];
//            [sstq setObject:currentID forKey:@"area"];
//            NSString * newKey = [NSString stringWithFormat:@"sstq#%@",currentID];
//            [b setObject:sstq forKey:newKey];
//        }
//        NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//        [param setObject:h forKey:@"h"];
//        [param setObject:b forKey:@"b"];
//        NSLog(@"%@",param);
//        [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
//            NSLog(@"success");
//            NSLog(@"#%@#",returnData);
//            //更新首界面1接界面
//        } withFailure:^(NSError *error) {
//            NSLog(@"failure");
//        } withCache:YES];
//
//    }
//  }
////一周天气
//+(void)loadingAllCityWeekTQ
//{
//    if([setting sharedSetting].citys.count)
//    {
//        NSString * urlStr = URL_SERVER;
//        NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//        
//        for(int i=0;i<[setting sharedSetting].citys.count;i++)
//        {
//            NSMutableDictionary * weekTq = [[NSMutableDictionary alloc] init];
//            NSDictionary * currentCityInfo = [[setting sharedSetting].citys objectAtIndex:i];
//            NSString * currentID = [currentCityInfo objectForKey:@"ID"];
//            [weekTq setObject:currentID forKey:@"area"];
//            [b setObject:weekTq forKey:[NSString stringWithFormat:@"weekTq#%@",currentID]];
//        }
//        
//        NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//        [h setObject:[setting sharedSetting].app forKey:@"p"];
//        NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//        [param setObject:h forKey:@"h"];
//        [param setObject:b forKey:@"b"];
//        [[NetWorkCenter share]postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
//            NSLog(@"success");
//        } withFailure:^(NSError *error) {
//            NSLog(@"failure");
//        } withCache:YES];
//
//    }
//}
////六小时
//+(void)loadingAllCitySixhyb
//{
//    if([setting sharedSetting].citys.count)
//    {
//        NSString * urlStr = URL_SERVER;
//        NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//        NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//        NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//        [h setObject:[setting sharedSetting].app forKey:@"p"];
//        for(int i=0;i<[setting sharedSetting].citys.count;i++)
//        {
//            NSMutableDictionary * sixhyb = [[NSMutableDictionary alloc] init];
//            NSDictionary * currentCityInfo = [[setting sharedSetting].citys objectAtIndex:i];
//            NSString * currentID = [currentCityInfo objectForKey:@"ID"];
//            [sixhyb setObject:currentID forKey:@"area"];
//            [b setObject:sixhyb forKey:[NSString stringWithFormat:@"sixhyb#%@",currentID]];
//        }
//        [param setObject:h forKey:@"h"];
//        [param setObject:b forKey:@"b"];
//        [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
//            NSLog(@"success");
//            //更新首界面1接界面
//        } withFailure:^(NSError *error) {
//            NSLog(@"failure");
//        } withCache:YES];
// 
//    }
//}
//
////空气质量
//+(void)loadingAllCityAirInfoSimple
//{
//    if([setting sharedSetting].citys.count)
//    {
//        NSString * urlStr = URL_SERVER;
//        NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//        NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//        NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//        [h setObject:[setting sharedSetting].app forKey:@"p"];
//        for(int i=0;i<[setting sharedSetting].citys.count;i++)
//        {
//            NSMutableDictionary * airInfoSimple = [[NSMutableDictionary alloc] init];
//            NSDictionary * currentCityInfo = [[setting sharedSetting].citys objectAtIndex:i];
//            NSString * currentID = [currentCityInfo objectForKey:@"ID"];
//            [airInfoSimple setObject:currentID forKey:@"area"];
//            [airInfoSimple setObject:@1 forKey:@"type"];
//            [b setObject:airInfoSimple forKey:[NSString stringWithFormat:@"airInfoSimple#%@",currentID]];
//            
//        }
//        [param setObject:h forKey:@"h"];
//        [param setObject:b forKey:@"b"];
//        [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
//            NSLog(@"success");
//        } withFailure:^(NSError *error) {
//            NSLog(@"failure");
//        } withCache:YES];
//    }
//    
//}
//
////生活指数
//+(void)loadingAllCityShzs
//{
//    if([setting sharedSetting].citys.count)
//    {
//        NSString * urlStr = URL_SERVER;
//        NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//        NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//        NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//        [h setObject:[setting sharedSetting].app forKey:@"p"];
//        for(int i=0;i<[setting sharedSetting].citys.count;i++)
//        {
//            NSMutableDictionary * shzs = [[NSMutableDictionary alloc] init];
//            NSDictionary * currentCityInfo = [[setting sharedSetting].citys objectAtIndex:i];
//            NSString * currentID = [currentCityInfo objectForKey:@"ID"];
//            [shzs setObject:currentID forKey:@"area"];
//            [b setObject:shzs forKey:[NSString stringWithFormat:@"shzs#%@",currentID]];
//        }
//        [param setObject:h forKey:@"h"];
//        [param setObject:b forKey:@"b"];
//        [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
//            NSLog(@"success");
//            //更新首界面1接界面
//        } withFailure:^(NSError *error) {
//            NSLog(@"failure");
//        } withCache:YES];
//
//    }
//}
//
////首页预警
//
//+(void)loadingAllCityYjxx
//{
//    if([setting sharedSetting].citys.count)
//    {
//        NSString * urlStr = URL_SERVER;
//        NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
//        NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
//        NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
//        [h setObject:[setting sharedSetting].app forKey:@"p"];
//        for(int i=0;i<[setting sharedSetting].citys.count;i++)
//        {
//            NSMutableDictionary * yjxx_index = [[NSMutableDictionary alloc] init];
//            NSDictionary * currentCityInfo = [[setting sharedSetting].citys objectAtIndex:i];
//            NSString * currentID = [currentCityInfo objectForKey:@"ID"];
//            [yjxx_index setObject:currentID forKey:@"area"];
//            [b setObject:yjxx_index forKey:[NSString stringWithFormat:@"yjxx_index#%@",currentID]];
//        }
//        [param setObject:h forKey:@"h"];
//        [param setObject:b forKey:@"b"];
//        [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
//            NSLog(@"success");
//            //更新首界面预警信息
//        } withFailure:^(NSError *error) {
//            NSLog(@"failure");
//        } withCache:YES];
//
//    }
//}
//
//+(void)pretreatmentMainView
//{
//    [setting loadingAllCitySSTQ];
//    [setting loadingAllCityYjxx];
//}
//
//+(void)pretreatmentOtherView
//{
//    [setting loadingAllCityWeekTQ];
//    [setting loadingAllCitySixhyb];
//    [setting loadingAllCityAirInfoSimple];
//    [setting loadingAllCityShzs];
//}







@end
