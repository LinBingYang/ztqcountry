//
//  YSDetailViewController.m
//  ztqFj
//
//  Created by Admin on 15-2-3.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "YSDetailViewController.h"
#import "VideoViewController.h"
#import "weiboVC.h"
#import "WebViewController.h"
@interface YSDetailViewController ()

@end

@implementation YSDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    float place = 0;
    if(kSystemVersionMore7)
    {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
        place = 20;
    }
    self.barhight=place+44;
    
    UIImageView * navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    navigationBarBg.userInteractionEnabled = YES;
    navigationBarBg.image=[UIImage imageNamed:@"导航栏.png"];
    [self.view addSubview:navigationBarBg];
    
    UIImageView *leftimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7+place, 29, 29)];
    leftimg.image=[UIImage imageNamed:@"返回.png"];
    leftimg.userInteractionEnabled=YES;
    [navigationBarBg addSubview:leftimg];
    
    UIButton * leftBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 7+place, 60, 44+place)];
    [leftBut setBackgroundColor:[UIColor clearColor]];
    
    [leftBut addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarBg addSubview:leftBut];
    
    UIButton * rightbut = [[UIButton alloc] initWithFrame:CGRectMake(280, 7+place, 30, 30)];
    [rightbut setImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
//    [rightbut setImage:[UIImage imageNamed:@"分享点击.png"] forState:UIControlStateHighlighted];
    [rightbut setBackgroundColor:[UIColor clearColor]];
    
    [rightbut addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarBg addSubview:rightbut];
    
    
    _titlelab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5+place, self.view.width, 36)];
    _titlelab.userInteractionEnabled = NO;
    _titlelab.font = [UIFont fontWithName:kBaseFont size:20];
    _titlelab.textColor = [UIColor whiteColor];
    _titlelab.textAlignment = NSTextAlignmentCenter;
    _titlelab.backgroundColor = [UIColor clearColor];
    _titlelab.text=@"气象影视";
    [self.view addSubview:_titlelab];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.adimgurls=[[NSMutableArray alloc]init];
    self.adtitles=[[NSMutableArray alloc]init];
    self.adurls=[[NSMutableArray alloc]init];
    
    [self loadMainAD:@"9"];
    
//    UIImageView *titimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.barhight, kScreenWidth, 120)];
//    titimg.image=[UIImage imageNamed:@"气象影视banner"];
//    [self.view addSubview:titimg];
    EGOImageView *ego = [[EGOImageView alloc] initWithFrame:CGRectMake(0,(kScreenHeitht-160)/2+10,kScreenWidth,180)];
    ego.placeholderImage=[UIImage imageNamed:@"影视背景.jpg"];
    [self.view addSubview:ego];
    ego.userInteractionEnabled=YES;
    [ego setImageURL:[ShareFun makeImageUrl:self.imgurl]];
       UIImageView *bofa=[[UIImageView alloc]initWithFrame:CGRectMake(145, 85, 30, 30)];
    bofa.image=[UIImage imageNamed:@"气象影视_06"];
    [ego addSubview:bofa];
    UIButton * but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(ego.frame), CGRectGetHeight(ego.frame))];
    [but addTarget:self action:@selector(buttonclick) forControlEvents:UIControlEventTouchUpInside];
    [ego addSubview:but];
    UILabel *labtime=[[UILabel alloc]initWithFrame:CGRectMake(5, (kScreenHeitht-160)/2+30+180, kScreenHeitht, 30)];
    labtime.text=[NSString stringWithFormat:@"首播: %@",self.time];
    labtime.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:labtime];
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(5, (kScreenHeitht-160)/2+50+180, kScreenWidth-10, 100)];
    lab.text=[NSString stringWithFormat:@"%@",self.des];
    lab.numberOfLines=0;
    lab.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:lab];
}
//加载首页大广告
-(void)loadMainAD:(NSString *)type{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:type forKey:@"position_id"];
    [b setObject:gz_todaywt_inde forKey:@"gz_ad"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            [self.adimgurls removeAllObjects];
            [self.adtitles removeAllObjects];
            [self.adurls removeAllObjects];
            NSDictionary *addic=[b objectForKey:@"gz_ad"];
            NSArray *adlist=[addic objectForKey:@"ad_list"];
            for (int i=0; i<adlist.count; i++) {
                NSString *url=[adlist[i] objectForKey:@"url"];
                NSString *title=[adlist[i] objectForKey:@"title"];
                NSString *imgurl=[adlist[i] objectForKey:@"img_path"];
                [self.adurls addObject:url];
                [self.adtitles addObject:title];
                [self.adimgurls addObject:imgurl];
            }
            
            [self.bmadscro removeFromSuperview];
            self.bmadscro=nil;
            if (self.bmadscro==nil) {
                if (self.adimgurls.count>0) {
                    
                        self.bmadscro = [[BMAdScrollView alloc] initWithNameArr:self.adimgurls  titleArr:self.adtitles height:140 offsetY:self.barhight offsetx:10];
                        self.bmadscro.vDelegate = self;
                        self.bmadscro.pageCenter = CGPointMake(280, 300);
                        [self.view addSubview:self.bmadscro];
                   
                    
                }
                
            }
            
        }
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.view setTransform:CGAffineTransformMakeRotation(M_PI*2)];//强制旋转
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIDeviceOrientationIsLandscape(interfaceOrientation);
}
-(BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;//优先展示的设备方向
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightAction{
    [self getShareContent];
    UIImage *t_shareImage = [ShareFun captureScreen];
    self.shareimg=t_shareImage;
    NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weiboShare.png"];
    [UIImagePNGRepresentation(t_shareImage) writeToFile:shareImagePath atomically:YES];
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
    [gz_todaywt_inde setObject:self.titlstr forKey:@"v_name"];
    [gz_todaywt_inde setObject:self.viedourl forKey:@"v_url"];
    [gz_todaywt_inde setObject:@"WT_VIDEO" forKey:@"keyword"];
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
            NSString *shareContentWB = [NSString stringWithFormat:@"%@ %@",self.fxurl,shareContent];
            weiboVC *t_weibo = [[weiboVC alloc] initWithNibName:@"weiboVC" bundle:nil];
            [t_weibo setShareText:shareContentWB];
            [t_weibo setShareImage:@"weiboShare.png"];
            [t_weibo setShareType:1];
            [self presentViewController:t_weibo animated:YES completion:nil];

            break;
        }
//        case 1:{
//            [UMSocialData defaultData].extConfig.wxMessageType =UMSocialWXMessageTypeImage;
//            [[UMSocialControllerService defaultControllerService] setShareText:nil shareImage:self.shareimg socialUIDelegate:nil];     //设置分享内容和回调对象
//            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//            
//            break;
//        }
        case 1:{
            //创建分享消息对象
            NSString *url;
            url=self.fxurl;
            if (url.length<=0) {
                url=@"http://www.fjqxfw.com:8099/gz_wap/";
            }
            
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            //            if ([self.subtitle isEqualToString:@"知天气决策版"]) {
            UMShareWebpageObject *shareweb=[[UMShareWebpageObject alloc]init];
            shareweb.webpageUrl=url;
            shareweb.title=@"知天气分享";
            shareweb.thumbImage=self.shareimg;
            shareweb.descr=shareContent;
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareweb;
            
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
            //创建分享消息对象
            NSString *url;
            url=self.fxurl;
            if (url.length<=0) {
                url=@"http://www.fjqxfw.com:8099/gz_wap/";
            }
            
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            //            if ([self.subtitle isEqualToString:@"知天气决策版"]) {
            UMShareWebpageObject *shareweb=[[UMShareWebpageObject alloc]init];
            shareweb.webpageUrl=url;
            shareweb.title=[NSString stringWithFormat:@"【知天气公众版分享】%@",shareContent];
            shareweb.thumbImage=self.shareimg;
            shareweb.descr=shareContent;
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareweb;
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    NSLog(@"************Share fail with error %@*********",error);
                }else{
                    NSLog(@"response data is %@",data);
                }
            }];
            break;
        }
//        case 2: {
//            //            [UMSocialData defaultData].extConfig.wxMessageType =UMSocialWXMessageTypeWeb;
//            [UMSocialData defaultData].extConfig.wxMessageType =UMSocialWXMessageTypeImage;
//            //            [[UMSocialControllerService defaultControllerService] setShareText:@"知天气客户端是整合各省气象资源，面向大众用户开发的智能终端气象应用，提供全国3000多个城市天气预报、重点城市空气质量和深度气象信息的查询需求服务。" shareImage:[UIImage imageNamed:@"Icon.png"] socialUIDelegate:nil];     //设置分享内容和回调对象
//            [[UMSocialControllerService defaultControllerService] setShareText:nil shareImage:self.shareimg socialUIDelegate:nil];     //设置分享内容和回调对象
//            [UMSocialData defaultData].extConfig.title = shareContent;
//            //            [UMSocialData defaultData].extConfig.wechatSessionData.shareImage=[UIImage imageNamed:@"Icon"];
//            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//            
//            break;
//        }
        case 3: {
            NSString *shareContentWB = [NSString stringWithFormat:@"%@ %@",self.fxurl,shareContent];
//            NSString *url;
//            url=self.fxurl;
//            if (url.length<=0) {
//                url=@"http://www.fjqxfw.com:8099/gz_wap/";
//            }
            //要分享的内容，加在一个数组里边，初始化UIActivityViewController
            NSMutableArray *activityItems=[[NSMutableArray alloc] init];
            NSString *textToShare = shareContentWB;
            UIImage *imageToShare = self.shareimg;
            // 本地沙盒目录
            NSURL *imageUrl=[NSURL URLWithString:@"http://www.fjqxfw.com:8099/gz_wap/"];
            [activityItems addObject:textToShare];
            if (imageToShare) {
                [activityItems addObject:imageToShare];
            }
            [activityItems addObject:imageUrl];
            
            
            UIActivityViewController *activity =[[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            
            [self.navigationController presentViewController:activity animated:YES completion:nil];
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
-(void)buttonclick{
    VideoViewController *video=[[VideoViewController alloc]init];
    video.viedoname=self.viedourl;
    NSLog(@"%@",self.viedourl);
    [self.navigationController pushViewController:video animated:YES];

}
-(void)buttonClick:(int)vid{
    NSString *url=self.adurls[vid-1];
    if (url.length>0) {
        WebViewController *adVC = [[WebViewController alloc]init];
        adVC.url = self.adurls[vid-1];
        adVC.titleString =self.adtitles[vid-1];
        [self.navigationController pushViewController:adVC animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
