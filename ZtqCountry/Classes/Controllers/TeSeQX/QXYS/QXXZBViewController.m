//
//  QXXZBViewController.m
//  ZtqCountry
//
//  Created by 胡彭飞 on 2017/1/12.
//  Copyright © 2017年 yyf. All rights reserved.
//

#import "QXXZBViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ZYQAssetPickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "QXxzbBean.h"
#import "AFNetworking.h"
#import "NSDictionary+UrlEncodedString.h"
#import "CustomSheet.h"
#import "WebShareView2.h"
//#import "ZZCircleProgress.h"
#import "UIView+Tools.h"
#import "LGViewController.h"
#import "GRZXViewController.h"
#import "WebShareView3.h"
typedef  void(^CompressionSuccessBlock)(NSString *resultPath,float memorySize);
#define CompressionVideoPaht [NSHomeDirectory() stringByAppendingFormat:@"/Documents/CompressionVideoField"]
#define KVideoUrlPath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VideoURL"]
#define BLUECOLOR [UIColor colorWithRed:0/255.0 green:155/255.0 blue:225/255.0 alpha:1]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface QXXZBViewController ()<ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIWebViewDelegate,AVCaptureFileOutputRecordingDelegate,ACSheetDelegate,UIActionSheetDelegate>
{
    
    AVCaptureSession * _captureSession;
    AVCaptureDevice *_videoDevice;
    AVCaptureDevice *_audioDevice;
    AVCaptureDeviceInput *_videoInput;
    AVCaptureDeviceInput *_audioInput;
    AVCaptureMovieFileOutput *_movieOutput;
    AVCaptureVideoPreviewLayer *_captureVideoPreviewLayer;
    
}
@property(nonatomic,strong) MPMoviePlayerController *mk;
@property (nonatomic, retain) ALAssetRepresentation *representation;
@property(nonatomic,strong) CustomSheet *acsheetview;
@property(nonatomic,strong) JSContext *jscontext;
@property(nonatomic,copy) NSString *userID;
@property(nonatomic,copy) NSString *activityID;
@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,strong) UIProgressView *proget;
@property(nonatomic,strong) UIView *backmenban;
//@property(nonatomic,strong) ZZCircleProgress *hud ;
@property (nonatomic,strong) UIView * videoView;
@property(nonatomic,strong) UIView *backvideoView;
@property(nonatomic,strong) UIButton *tapBtn;
@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) UIButton *changeCamare;
@property(nonatomic,assign) BOOL isRecording;
@property(nonatomic,assign) BOOL isCancel;

@property(nonatomic,strong) UIImagePickerController *luxiangPicker;
@property(nonatomic,strong) UIImagePickerController *imagePicker;

/*
 
 Shareurl : 网页给的分享地址
 Sharecontent:网页给的分享内容
 */
@property(nonatomic,copy) NSString *Shareurl;
@property(nonatomic,copy) NSString *Sharecontent;

@property(nonatomic,strong) QXxzbBean *qxxz;
@property(nonatomic,strong) UIImage *tempImage;
@end

@implementation QXXZBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.barhight = 44+ place;
    self.navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    self.navigationBarBg.userInteractionEnabled = YES;
    //    _navigationBarBg.backgroundColor = [UIColor colorHelpWithRed:27 green:92 blue:189 alpha:1];
    self.navigationBarBg.image=[UIImage imageNamed:@"导航栏.png"];
    [self.view addSubview:self.navigationBarBg];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReciviceQXxzbBeanData:) name:@"ReciviceQXxzbBeanData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReciviceQXxzbBeanPictureData:) name:@"ReciviceQXxzbBeanPictureData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(call:) name:@"sharesuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReciviceWebBeanData:) name:@"ReciviceWebBeanData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReciviceWebBeanDataURLandContent:) name:@"ReciviceWebBeanDataURLandContent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webLoginFinished:) name:@"webLoginFinished" object:nil];
    
    UIButton * leftBut = [[UIButton alloc] initWithFrame:CGRectMake(15, 7+place, 30, 30)];
    [leftBut setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [leftBut setImage:[UIImage imageNamed:@"返回点击.png"] forState:UIControlStateHighlighted];
    [leftBut setBackgroundColor:[UIColor clearColor]];
    
    [leftBut addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarBg addSubview:leftBut];
    
//    UIImageView *leftimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7+place, 29, 29)];
//    leftimg.image=[UIImage imageNamed:@"返回.png"];
//    leftimg.userInteractionEnabled=YES;
//    [navigationBarBg addSubview:leftimg];
//    
//    UIButton * leftBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 7+place, 60, 44+place)];
//    [leftBut setBackgroundColor:[UIColor clearColor]];
//    
//    [leftBut addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
//    [navigationBarBg addSubview:leftBut];
    
    
    _titlelab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5+place, self.view.width, 36)];
    _titlelab.userInteractionEnabled = NO;
    _titlelab.font = [UIFont fontWithName:kBaseFont size:20];
    _titlelab.textColor = [UIColor whiteColor];
    _titlelab.textAlignment = NSTextAlignmentCenter;
    _titlelab.backgroundColor = [UIColor clearColor];
    _titlelab.text=self.titleString;
    [self.view addSubview:_titlelab];
    
//    if ([self.rightBtnType isEqualToString:@"sjqxr"]) {
//        UIButton * rightBut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-15-35, leftBut.frame.origin.y-3, 35, 35)];
//        [rightBut setBackgroundColor:[UIColor clearColor]];
//        [rightBut setBackgroundImage:[UIImage imageNamed:@"个人中心常态.png"] forState:UIControlStateNormal];
//        [rightBut setBackgroundImage:[UIImage imageNamed:@"个人中心二态.png"] forState:UIControlStateHighlighted];
//        [rightBut addTarget:self action:@selector(sjqxrRightAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_navigationBarBg addSubview:rightBut];
//    }

    self.view.backgroundColor=[UIColor whiteColor];
    UIWebView *webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeitht-64)];
    webView.delegate=self;
    self.webView=webView;
    //    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"testUpLoad" ofType:@"html"]]]];
    NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjuserid"];
    //    self.url=@"http://plasticheart.zicp.io/ztq_llhk/llhk.html";
    NSString *url=self.url;
    self.userid=userid;
    NSString *laststr=[url substringFromIndex:url.length-1];
    if ([laststr isEqualToString:@"/"]) {
        url=[url stringByReplacingCharactersInRange:NSMakeRange(_url.length-1, 1) withString:@""];
    }
    if (userid.length>0) {
        url=[NSString stringWithFormat:@"%@?USER_ID=%@&PID=%@",url,self.userid,[setting sharedSetting].app];
    }else{
        url=[NSString stringWithFormat:@"%@?USER_ID=&PID=%@",url,[setting sharedSetting].app];
    }
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *weburl = [NSURL URLWithString:[ShareFun returnFormatString:url]];
    _originRequest= [NSURLRequest requestWithURL:weburl];
    [webView loadRequest:_originRequest];
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [self.view addSubview:webView];
    
}
- (void)sjqxrRightAction:(UIButton *)sender {
    if (self.userid.length > 0) {
        GRZXViewController *greV = [[GRZXViewController alloc]init];
        [self.navigationController pushViewController:greV animated:YES];
    }else {
        LGViewController *lgVC = [[LGViewController alloc]init];
        lgVC.type = @"web";
        [self.navigationController pushViewController:lgVC animated:YES];
        
    }
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
//    NSString *newUrl=[_url stringByReplacingCharactersInRange:NSMakeRange(_url.length-1, 1) withString:@""];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?PID=%@",newUrl,[setting sharedSetting].app]]]];
//    self.nolgurl=newUrl;
//
//}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)call:(NSNotification *)object{
    //    NSLog(@"call");
    NSString *type=object.object;
    self.sharetype=type;
    if(![type isEqualToString:@"1"]&&![type isEqualToString:@"2"]&&![type isEqualToString:@"3"]){
        JSValue *CallbackshareUrlAndContentCallback = self.jscontext[@"shareUrlAndContentCallback"];
        //传值给web端
        [CallbackshareUrlAndContentCallback callWithArguments:@[@"1"]];
        return;
    }
    JSValue *CallbackshareUrlAndContentCallback = self.jscontext[@"shareUrlAndContentCallback"];
    //传值给web端
    [CallbackshareUrlAndContentCallback callWithArguments:@[@"1"]];
    [self loadShareState];//分享提交
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //    self.isshare=YES;
    //    // 之后在回调js的方法Callback把内容传出去
    //    JSValue *Callback = self.jsContext[@"shareCallback"];
    //    //传值给web端
    //    [Callback callWithArguments:@[@"1"]];
}
#pragma  mark  -------------------------------------------------------------------
-(void)loadShareState{
    NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjuserid"];
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    if (userid.length>0) {
        [gz_todaywt_inde setObject:userid forKey:@"user_id"];
    }
    self.sharetype=@"1";
    if (self.sharetype.length>0) {
        [gz_todaywt_inde setObject:self.sharetype forKey:@"fx_qd"];
    }
    if (self.activityID.length>0) {
        [gz_todaywt_inde setObject:self.activityID forKey:@"act_id"];
    }
    if (self.websharetype.length>0) {
        [gz_todaywt_inde setObject:self.websharetype forKey:@"type"];
    }
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddhhmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    int x = (arc4random() % 1001) + 9000;
    //    NSLog(@"dateString:%@",dateString);
    NSString *req_mid=[NSString stringWithFormat:@"%@%d",dateString,x];
    [gz_todaywt_inde setObject:req_mid forKey:@"req_mid"];
    NSString *md5str=[ShareFun getMd5_32Bit_String:[NSString stringWithFormat:@"%@%@pcs_ztq",userid,req_mid]];
    [gz_todaywt_inde setObject:md5str forKey:@"md5"];
    [b setObject:gz_todaywt_inde forKey:@"gz_qdcj_fx"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            
            NSDictionary *addic=[b objectForKey:@"gz_qdcj_fx"];
            NSString *result=[addic objectForKey:@"result"];
            NSString *result_msg=[addic objectForKey:@"result_msg"];
            if ([result isEqualToString:@"1"]) {
                self.isshare=YES;
                // 之后在回调js的方法Callback把内容传出去
                JSValue *shareCallback = self.jscontext[@"shareCallback"];
                //传值给web端
                [shareCallback callWithArguments:@[@"1"]];
            }else{
                UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"网络出错，请稍后再试" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [al show];
            }
            //            NSLog(@"分享%@",result_msg);
        }
        
    } withFailure:^(NSError *error) {
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"网络出错，请稍后再试" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [al show];
    } withCache:YES];
}
-(void)webLoginFinished:(NSNotification *)noti{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjuserid"];
        self.userid=userid;
        //修改成功
        NSString *jsStr1=[NSString stringWithFormat:@"loginCallback('%@')",userid];
        [self.jscontext evaluateScript:jsStr1];
    });
}
-(void)ReciviceWebBeanDataURLandContent:(NSNotification *)noti
{
    
    NSDictionary *userInfo=noti.object;
    NSString *Shareurl=userInfo[@"Shareurl"];
    NSString *Sharecontent=userInfo[@"Sharecontent"];
    self.Shareurl=Shareurl;
    self.Sharecontent=Sharecontent;
    
    NSString *defaultShareContent=self.shareContent;
    if(self.Sharecontent.length > 0)
    {
        defaultShareContent=self.Sharecontent;
    }
    NSString *url;
    url=self.Shareurl;
    if (url.length<=0) {
        url=self.url;
    }
    
    UIImage *t_shareImage = [ShareFun captureScreen];
    NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weiboShare.png"];
    [UIImagePNGRepresentation(t_shareImage) writeToFile:shareImagePath atomically:YES];
    WebShareView2 *share=[[WebShareView2 alloc] initDefaultWithTitle:@"分享到" WithShareContext:self.Sharecontent subtitile:_titleString WithShareimg:t_shareImage WithControllview:self];
    share.shareUrl=url;
    share.isCallBack=NO;
    share.shareImg1=t_shareImage;
    share.shareStr1=defaultShareContent;
    [share show];
    
}

-(void)ReciviceWebBeanData:(NSNotification *)noti
{
    
    NSDictionary *userInfo=noti.object;
    NSString *activityID=userInfo[@"act_id"];
    NSString *share_type=userInfo[@"share_type"];
    self.activityID=activityID;
    self.websharetype=share_type;
    [self action];
}
-(void)ReciviceQXxzbBeanData:(NSNotification *)noti
{   __weak QXXZBViewController *weakSelf=self;
    //    NSLog(@"%@",noti.object);
    NSDictionary *userInfo=noti.object;
    NSString *userID=userInfo[@"userID"];
    NSString *activityID=userInfo[@"activityID"];
    self.userID=userID;
    self.activityID=activityID;
    dispatch_async(dispatch_get_main_queue(), ^{
//        weakSelf.acsheetview=nil;
//        weakSelf.acsheetview=[[CustomSheet alloc] initWithupbtn:@"录制" Withdownbtn:@"本地选取" WithCancelbtn:@"取消" withDelegate:weakSelf];
//        weakSelf.acsheetview.tag=10;
//        [weakSelf.acsheetview show];
        
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"录制" otherButtonTitles:@"本地选取", nil];
        actionSheet.tag = 10;
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.view];
        
        
    });
}
-(void)ReciviceQXxzbBeanPictureData:(NSNotification *)noti
{
    __weak QXXZBViewController *weakSelf=self;
    NSDictionary *userInfo=noti.object;
    NSString *activityID=userInfo[@"activityID"];
    self.activityID=activityID;
    dispatch_async(dispatch_get_main_queue(), ^{
//        weakSelf.acsheetview=nil;
//        weakSelf.acsheetview=[[CustomSheet alloc]initWithupbtn:@"拍照" Withdownbtn:@"相册" WithCancelbtn:@"取消" withDelegate:weakSelf];
//        weakSelf.acsheetview.tag=1;
//        [weakSelf.acsheetview show];
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
        actionSheet.tag = 1;
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.view];
    });
    
}
-(QXxzbBean *)qxxz
{
    
    if (_qxxz==nil) {
        _qxxz=[[QXxzbBean alloc] init];
    }
    return _qxxz;

}
#pragma  mark UIWebViewDelegate   网页加载完成  js交互
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //    NSLog(@"%@",request.URL.absoluteString);
    self.jscontext=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    self.jscontext[@"js"]=self.qxxz;
    //    NSLog(@"%@",request.URL.absoluteString);
    if(!_authenticated) {
        
        _authenticated=NO;
        
        _urlConnection= [[NSURLConnection alloc]initWithRequest:_originRequest delegate:self];
        
        [_urlConnection start];
        
        return NO;
        
    }
    return YES;
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    self.jscontext=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    QXxzbBean *qxxz=[[QXxzbBean alloc] init];
    self.jscontext[@"js"]=self.qxxz;
    //    NSLog(@"开始请求数据。");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //    NSLog(@"失败 ---%@- %ld",error.userInfo,(long)error.code);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    __weak QXXZBViewController *weakSelf=self;
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    self.jscontext=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jscontext[@"js"]=self.qxxz;
    self.jscontext.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        //        NSLog(@"%@", exceptionValue);
    };
    //    self.jscontext[@"uploadImg"] = ^() {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            weakSelf.acsheetview=[[CustomSheet alloc]initWithupbtn:@"拍照" Withdownbtn:@"相册" WithCancelbtn:@"取消" withDelegate:weakSelf];
    //            [weakSelf.acsheetview show];
    //        });
    //    };
    
    self.jscontext[@"share"] = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *t_shareImage = [ShareFun captureScreen];
            //            UIImage *newShareImage=[weakSelf makeImageMore];
            NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weiboShare.png"];
            [UIImagePNGRepresentation(t_shareImage) writeToFile:shareImagePath atomically:YES];
            NSString *shareContent = [NSString stringWithFormat:@"%@", weakSelf.shareContent];
            WebShareView2 *share=[[WebShareView2 alloc] initDefaultWithTitle:@"分享到" WithShareContext:shareContent subtitile:weakSelf.titleString WithShareimg:t_shareImage WithControllview:weakSelf];
            share.shareUrl=weakSelf.url;
            share.isCallBack=NO;
            share.shareImg1=t_shareImage;
            share.shareStr1=weakSelf.shareContent;
            [share show];
        });
    };
    self.jscontext[@"login"] =
    ^()
    {   dispatch_async(dispatch_get_main_queue(), ^{
        LGViewController *lg=[[LGViewController alloc]init];
        lg.type=@"web";
        [weakSelf.navigationController pushViewController:lg animated:YES];
    });
    };
    NSString *jsFunctStr1=[NSString stringWithFormat:@"receiveAppData('%@')",[self.qxxz JsGetDatasFromApp]];
    [self.jscontext evaluateScript:jsFunctStr1];
    [self performSelector:@selector(getCaptureimg) withObject:nil afterDelay:2];
    //    self.jscontext[@"uploadVideo"] = ^() {
    ////        dispatch_async(dispatch_get_main_queue(), ^{
    ////            self.acsheetview=[[CustomSheet alloc]initWithupbtn:@"拍照" Withdownbtn:@"相册" WithCancelbtn:@"取消" withDelegate:self];
    ////            [self.acsheetview show];
    ////        });
    //            NSArray *args = [JSContext currentArguments];
    //            for (NSString *canshu in args) {
    //                                NSLog(@"%@",canshu);
    //
    //            }
    //
    //    };
}
#pragma mark NSURLConnection代理https
-(void)connection:(NSURLConnection*)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge

{
    
    NSLog(@"WebController Got auth challange via NSURLConnection");
    
    if([challenge previousFailureCount]==0)
        
    {
        
        _authenticated=YES;
        
        NSURLCredential*credential=[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        
    }else
        
    {
        
        [[challenge sender]cancelAuthenticationChallenge:challenge];
        
    }
    
}

-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response

{
    
    NSLog(@"WebController received response via NSURLConnection");
    
    // remake a webview call now that authentication has passed ok.
    
    _authenticated=YES;
    
    [self.webView loadRequest:_originRequest];
    
    // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
    
    [_urlConnection cancel];
    
}
- (BOOL)connection:(NSURLConnection*)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace*)protectionSpace

{
    return[protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    
}
-(void)getCaptureimg{
    NSMutableArray *images=[[NSMutableArray alloc]init];
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(self.webView.scrollView.contentSize, NO, 0.0);
    //    UIGraphicsBeginImageContext(_glassScrollView.foregroundScrollView.contentSize);
    {
        CGPoint savedContentOffset = self.webView.scrollView.contentOffset;
        CGRect savedFrame =  self.webView.scrollView.frame;
        
        self.webView.scrollView.contentOffset = CGPointZero;
        self.webView.scrollView.frame = CGRectMake(0, 0, kScreenWidth,  self.webView.scrollView.contentSize.height);
        [ self.webView.scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        self.webView.scrollView.contentOffset = savedContentOffset;
        self.webView.scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    [images addObject:image];
    UIImage *newbgimg=[self verticalImageFromArray:images];
    self.shareimg=newbgimg;
}
-(UIImage *)makeImageMore
{
    
    NSMutableArray *images=[[NSMutableArray alloc]init];
    
    
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions( self.webView.scrollView.contentSize, NO, 0.0);
    {
        CGPoint savedContentOffset = self.webView.scrollView.contentOffset;
        CGRect savedFrame =  self.webView.frame;
        
        self.webView.scrollView.contentOffset = CGPointZero;
        self.webView.scrollView.frame = CGRectMake(0, 0, kScreenWidth,  self.webView.scrollView.contentSize.height);
        [  self.webView.scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        self.webView.scrollView.contentOffset = savedContentOffset;
        self.webView.scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    [images addObject:image];
    UIImage *newimg=[self verticalImageFromArray:images];
    return newimg;
    
}
-(UIImage *)verticalImageFromArray:(NSArray *)imagesArray
{
    UIImage *unifiedImage = nil;
    CGSize totalImageSize = [self verticalAppendedTotalImageSizeFromImagesArray:imagesArray];
    UIGraphicsBeginImageContextWithOptions(totalImageSize, NO, 0.f);
    
    int imageOffsetFactor = 0;
    for (UIImage *img in imagesArray) {
        [img drawAtPoint:CGPointMake(0, imageOffsetFactor)];
        imageOffsetFactor += img.size.height;
    }
    
    unifiedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return unifiedImage;
}
-(CGSize)verticalAppendedTotalImageSizeFromImagesArray:(NSArray *)imagesArray
{
    CGSize totalSize = CGSizeZero;
    for (UIImage *im in imagesArray) {
        CGSize imSize = [im size];
        totalSize.height += imSize.height;
        // The total width is gonna be always the wider found on the array
        totalSize.width = kScreenWidth;
    }
    return totalSize;
}
-(void)action{
    
    NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weiboShare.png"];
    [UIImagePNGRepresentation(self.shareimg) writeToFile:shareImagePath atomically:YES];
    WebShareView3 *share1=[[WebShareView3 alloc] initDefaultWithTitle:@"分享到" WithShareContext:self.shareContent subtitile:_titleString WithShareimg:self.shareimg WithControllview:self];
    share1.isCallBack=YES;
    share1.shareImg1=self.shareimg;
    share1.shareStr1=self.shareContent;
    [share1 show];
}
//// 将原始视频的URL转化为NSData数据,写入沙盒
//- (void)videoWithUrl:(NSURL *)url withFileName:(NSString *)fileName
//{
//    // 解析一下,为什么视频不像图片一样一次性开辟本身大小的内存写入?
//    // 想想,如果1个视频有1G多,难道直接开辟1G多的空间大小来写?
//    // 创建存放原始图的文件夹--->VideoURL
//    NSFileManager * fileManager = [NSFileManager defaultManager];
//    if (![fileManager fileExistsAtPath:KVideoUrlPath]) {
//        [fileManager createDirectoryAtPath:KVideoUrlPath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//
//
//    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        if (url) {
//
//            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
//                ALAssetRepresentation *rep = [asset defaultRepresentation];
//                NSString * videoPath = [KVideoUrlPath stringByAppendingPathComponent:fileName];
//
//                const char *cvideoPath = [videoPath UTF8String];
//                FILE *file = fopen(cvideoPath, "a+");
//                if (file) {
//                    const int bufferSize = 11024 * 1024;
//                    // 初始化一个1M的buffer
//                    Byte *buffer = (Byte*)malloc(bufferSize);
//                    NSUInteger read = 0, offset = 0, written = 0;
//                    NSError* err = nil;
//                    if (rep.size != 0)
//                    {
//                        do {
//                            read = [rep getBytes:buffer fromOffset:offset length:bufferSize error:&err];
//                            written = fwrite(buffer, sizeof(char), read, file);
//                            offset += read;
//                        } while (read != 0 && !err);//没到结尾，没出错，ok继续
//                    }
//                    // 释放缓冲区，关闭文件
//                    free(buffer);
//                    buffer = NULL;
//                    fclose(file);
//                    file = NULL;
//
//                    // UI的更新记得放在主线程,要不然等子线程排队过来都不知道什么年代了,会很慢的
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        //                        [_tableView reloadData];
//                    });
//                }
//            } failureBlock:nil];
//        }
//    });
//}

#pragma mark -UIImagePickerControllerDelegate   头像上传
//点击相册中的图片 货照相机照完后点击use  后触发的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker==self.imagePicker) {
        
        self.tempImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //    UIImageWriteToSavedPhotosAlbum( self.tempImage, nil,nil, nil);
        [picker dismissViewControllerAnimated:YES completion:nil];
        if(self.tempImage)
        {
            //
            //        NSData *imageData =UIImageJPEGRepresentation(image,0.1);
            //        if (imageData.length/1024<500) {
            
            
            NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
            NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
            NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
            NSMutableDictionary *sp_test = [NSMutableDictionary dictionaryWithCapacity:4];
            [t_h setObject:[setting sharedSetting].app forKey:@"p"];
            
            [t_b setObject:sp_test forKey:@"gz_qxhd_head_tj"];
            if (self.activityID) {
                [sp_test setObject:self.activityID forKey:@"act_id"];
            }
            
            [t_dic setObject:t_h forKey:@"h"];
            [t_dic setObject:t_b forKey:@"b"];
            
            NSString *t_str=[t_dic urlEncodedStringCustom];
            NSDictionary *parameters = @{@"p":t_str};
            
            [MBProgressHUD showHUDAddedTo:self.view withLabel:@"正在上传..." animated:YES];
            
            if (kSystemVersionMore8) {
                AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc] init];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
                manager.responseSerializer.acceptableContentTypes  =[NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript" ,@"text/plain" , nil];
                [manager POST:URL_SERVER parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    UIImage *img = [self imageCompressForWidth:self.tempImage targetWidth:kScreenWidth];//压缩图片
                    NSData *imageData =UIImageJPEGRepresentation(img,0.5);
                    [formData appendPartWithFileData:imageData name:@"file" fileName:@"temp.jpg" mimeType:@"application/octet-stream"];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    NSDictionary *t_b = [responseObject objectForKey:@"b"];
                    
                    if (t_b != nil)
                    {
                        NSDictionary *syn_user_info_upd=[t_b objectForKey:@"gz_qxhd_head_tj"];
                        NSString *result=syn_user_info_upd[@"result"];
                        if ([result isEqualToString:@"1"]) {
                            //修改成功
                            NSString *imgurl=syn_user_info_upd[@"url"];
                            NSString *jsStr2;
                            if (imgurl) {
                                jsStr2=[NSString stringWithFormat:@"uploadImgCallback('%@')",imgurl];
                            }else
                            {
                                jsStr2=@"uploadImgCallback('')";
                            }
                            
                            if (self.jscontext) {
                                [self.jscontext evaluateScript:jsStr2];
                            }
                            
                            
                        }else{
                            //失败
                            
                            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"上传失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                            
                            
                        }
                    }
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                }];
 
                
            }else{
                NSString *tmpfilename=[NSString stringWithFormat:@"%f",[NSDate timeIntervalSinceReferenceDate]];
                NSURL *tmpfileurl=[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:tmpfilename]];
                NSMutableURLRequest *mrq=[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:ONLINE_URL parameters:parameters  constructingBodyWithBlock:^(id<AFMultipartFormData>   formData) {
                    UIImage *img = [self imageCompressForWidth:self.tempImage targetWidth:self.tempImage.size.width];//压缩图片
                    NSData *imageData =UIImageJPEGRepresentation(img ,0.6);
                    [formData appendPartWithFileData:imageData name:@"file" fileName:@"temp.jpg" mimeType:@"application/octet-stream"];
                } error:(nil)];
                [[AFHTTPRequestSerializer serializer]requestWithMultipartFormRequest:mrq writingStreamContentsToFile:tmpfileurl completionHandler:^(NSError *  error) {
                    AFURLSessionManager *maneger=[[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
                    maneger.responseSerializer=[AFHTTPResponseSerializer serializer];
                    NSURLSessionUploadTask *uploadtask=[maneger uploadTaskWithRequest:mrq fromFile:tmpfileurl progress:nil completionHandler:^(NSURLResponse *  response, id   responseObject, NSError *  error) {
                        [[NSFileManager defaultManager]removeItemAtURL:tmpfileurl error:nil];
                        if (error) {
                            
                            UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"知天气提示" message:@"提交失败，请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [al show];
                        }else{
                            
                            NSDictionary *t_b = [responseObject objectForKey:@"b"];
                            
                            if (t_b != nil)
                            {
                                NSDictionary *syn_user_info_upd=[t_b objectForKey:@"gz_qxhd_head_tj"];
                                NSString *result=syn_user_info_upd[@"result"];
                                if ([result isEqualToString:@"1"]) {
                                    //修改成功
                                    NSString *imgurl=syn_user_info_upd[@"url"];
                                    NSString *jsStr2;
                                    if (imgurl) {
                                        jsStr2=[NSString stringWithFormat:@"uploadImgCallback('%@')",imgurl];
                                    }else
                                    {
                                        jsStr2=@"uploadImgCallback('')";
                                    }
                                    
                                    if (self.jscontext) {
                                        [self.jscontext evaluateScript:jsStr2];
                                    }
                                    
                                    
                                }else{
                                    //失败
                                    
                                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"上传失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                    [alert show];
                                    
                                    
                                }
                            }

                            
                            
                        }
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }];
                    [uploadtask resume];
                }];
            }

            
            
            
            //        }else{
            //
            //            //失败
            //            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"上传头像失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //            [alert show];
            //
            //        }
        }
    }else if(picker==self.luxiangPicker){
        
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path])) {
            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, nil, nil);
            [picker dismissViewControllerAnimated:YES completion:nil];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [self compressedVideoOtherMethodWithURL:url compressionType:AVAssetExportPresetMediumQuality compressionResultPath:^(NSString *resultPath, float memorySize) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        __weak QXXZBViewController *weakSelf=self;
                        NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
                        NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
                        NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
                        NSMutableDictionary *sp_test = [NSMutableDictionary dictionaryWithCapacity:4];
                        [t_h setObject:[setting sharedSetting].app forKey:@"p"];
                        
                        [t_b setObject:sp_test forKey:@"gz_qxhd_video_tj"];
                        [t_dic setObject:t_h forKey:@"h"];
                        [t_dic setObject:t_b forKey:@"b"];
                        [sp_test setObject:self.userID forKey:@"user_id"];
                        [sp_test setObject:self.activityID forKey:@"act_id"];
                        NSString *t_str=[t_dic urlEncodedStringCustom];
                        
                        
                        AVURLAsset *urlSet = [AVURLAsset assetWithURL:url];
                        AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
                        imageGenerator.appliesPreferredTrackTransform = YES;
                        NSError *error = nil;
                        CMTime time = CMTimeMake(1,2);//缩略图创建时间 CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
                        CMTime actucalTime; //缩略图实际生成的时间
                        CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
                        if (error) {
                            NSLog(@"截取视频图片失败:%@",error.localizedDescription);
                        }
                        CMTimeShow(actucalTime);
                        UIImage *tempImg = [UIImage imageWithCGImage:cgImage];
                        
                        NSLog(@"视频截取成功");
                        //                     NSData *SuolueTuData = UIImageJPEGRepresentation(tempImg, 0.5);
                        NSDictionary *parameters = @{@"p":t_str};
                        __block NSData *upData;
                        [MBProgressHUD showHUDAddedTo:self.view withLabel:@"上传中..." animated:YES];
                        
                        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
                        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
                        manager.responseSerializer.acceptableContentTypes  =[NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript" ,@"text/plain" , nil];
                        [manager POST:URL_SERVER parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                            //视频
                            upData = [NSData dataWithContentsOfFile:resultPath];
                            [formData appendPartWithFileData:upData name:@"file1" fileName:@"temp.mp4" mimeType:@"application/octet-stream"];
                            
                            //缩略图
                            UIImage *imgnew = [weakSelf imageCompressForWidth:tempImg targetWidth:kScreenWidth];//压缩图片
                            NSData *SuolueTuData = UIImageJPEGRepresentation(imgnew, 0.5);
                            [formData appendPartWithFileData:SuolueTuData name:@"file" fileName:@"thumbImg.jpg" mimeType:@"application/octet-stream"];
                            
                        } progress:^(NSProgress *  uploadProgress) {
                            
                        } success:^(NSURLSessionDataTask *  task, id   responseObject) {
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            //                        NSLog(@"----------------视频上传成功------%@----------",[NSThread currentThread]);
                            //                        [weakSelf.backmenban removeFromSuperview];
                            if (responseObject != nil)
                            {
                                NSDictionary *bb=[responseObject objectForKey:@"b"];
                                NSDictionary *qxhd_video_tj=bb[@"gz_qxhd_video_tj"];
                                NSString *vid_id=qxhd_video_tj[@"vid_id"];
                                NSString *result=qxhd_video_tj[@"result"];
                                if ([result isEqualToString:@"1"]) {
                                    //修改成功
                                    NSString *jsStr1=[NSString stringWithFormat:@"uploadVideoCallback('%@')",vid_id];
                                    [weakSelf.jscontext evaluateScript:jsStr1];
                                    
                                    
                                }else{
                                    
                                    //失败
                                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"上传视频失败" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                    [alert show];
                                    
                                    
                                }
                            }
                            
                            
                            
                        } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
                            //                        NSLog(@"----------------视频上传失败----------------%@",[NSThread currentThread]);
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            //                        [weakSelf.backmenban removeFromSuperview];
                            [picker dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                        
                        
                        
                    });
                    
                    
                }];
            });
        }
    }
    
}
#pragma mark -UIAcitonSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1) {
        
        //    [self openShexiangtou];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        self.imagePicker=picker;
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        if (buttonIndex==0) {
            
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
            }
            else
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"知天气" message:@"此设备不支持拍照功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
        }
        if (buttonIndex==1) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
        }
        if (buttonIndex!=2) {
            if([UIImagePickerController isSourceTypeAvailable:picker.sourceType])
            {
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
    }else if(actionSheet.tag==10){
        if (buttonIndex==0) {
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                self.luxiangPicker=imagePicker;
                imagePicker.videoQuality = UIImagePickerControllerQualityTypeIFrame960x540;//视频质量设置
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.videoMaximumDuration = 60.0f;//设置最长录制5分钟
                imagePicker.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
                [self presentViewController:imagePicker animated:YES completion:nil];
                
            }else
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"知天气" message:@"此设备不支持视频拍摄功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
        }
        if (buttonIndex==1) {
            // 打开图库所有视频
            ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
            picker.maximumNumberOfSelection = 0;
            picker.assetsFilter = [ALAssetsFilter allVideos];
            picker.showEmptyGroups=NO;
            picker.delegate=self;
            picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                    NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                    return duration >= 5;
                } else {
                    return YES;
                }
            }];
            
            [self presentViewController:picker animated:YES completion:NULL];
            
        }
        
        
    }
}
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
//    NSString *mediatype = [info objectForKey:UIImagePickerControllerMediaType];
//    NSLog(@"%ld",[NSData dataWithContentsOfURL:videoUrl].length);
//    //判断是否为视频文件 否则显示错误
//    if ([mediatype isEqualToString:@"public.movie"]) {
//        [self compressedVideoOtherMethodWithURL:videoUrl compressionType:AVAssetExportPresetMediumQuality compressionResultPath:^(NSString *resultPath, float memorySize) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (memorySize <=1.5) {
//                    [picker dismissViewControllerAnimated:YES completion:nil];
//                    NSData *data11 =[NSData dataWithContentsOfFile:resultPath];
//                    self.mk=[[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:resultPath]];
//                    self.mk.repeatMode = MPMovieRepeatModeOne;
//                    self.mk.scalingMode = MPMovieScalingModeAspectFit;
//                    self.mk.controlStyle = MPMovieControlStyleFullscreen;
//                    self.mk.view.frame = CGRectMake(0.0,0,self.view.bounds.size.width,self.view.bounds.size.height);
//                    [[NSNotificationCenter defaultCenter] addObserver:self
//                                                             selector:@selector(myMovieFinishedCallback:)
//                                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                                               object:self.mk];
//                    [self.view addSubview:self.mk.view];
//
//                    [self.mk play];
//
//                }else{
//
//                    [picker dismissViewControllerAnimated:YES completion:nil];
//
//                }
//
//            });
//
//
//        }];
//
//    }else{
//
//
//         [picker dismissViewControllerAnimated:YES completion:nil];
//
//    }
//
//
//
//}
-(void)movieStateChangeCallback:(NSNotification*)notify  {
    
    //点击播放器中的播放/ 暂停按钮响应的通知
    
}
-(void)SheetClickWithIndexPath:(NSInteger)indexPath WithACSheet:(CustomSheet *)actionSheet{
    if (actionSheet.tag==1) {
        
        //    [self openShexiangtou];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        self.imagePicker=picker;
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        if (indexPath==1) {
            
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
            }
            else
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"知天气" message:@"此设备不支持拍照功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
        }
        if (indexPath==2) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
        }
        if (indexPath!=3) {
            if([UIImagePickerController isSourceTypeAvailable:picker.sourceType])
            {
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
    }else if(actionSheet.tag==10){
        if (indexPath==1) {
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                self.luxiangPicker=imagePicker;
                imagePicker.videoQuality = UIImagePickerControllerQualityTypeIFrame960x540;//视频质量设置
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.videoMaximumDuration = 60.0f;//设置最长录制5分钟
                imagePicker.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
                [self presentViewController:imagePicker animated:YES completion:nil];
                
            }else
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"知天气" message:@"此设备不支持视频拍摄功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
        }
        if (indexPath==2) {
            // 打开图库所有视频
            ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
            picker.maximumNumberOfSelection = 0;
            picker.assetsFilter = [ALAssetsFilter allVideos];
            picker.showEmptyGroups=NO;
            picker.delegate=self;
            picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                    NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                    return duration >= 5;
                } else {
                    return YES;
                }
            }];
            
            [self presentViewController:picker animated:YES completion:NULL];
            
        }
        
        
    }
}
-(void)myMovieFinishedCallback:(NSNotification*)notify
{
    //视频播放对象
    MPMoviePlayerController* theMovie = [notify object];
    //销毁播放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    [theMovie.view removeFromSuperview];
    // 释放视频对象
    [self dismissViewControllerAnimated:YES completion:nil];
    //    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - ZYQAssetPickerController Delegate  视频和缩略图上传
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    ALAsset *asset=assets[0];
    _representation = asset.defaultRepresentation;
    
    
    //    UIImage *tempImg = [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
    //    NSLog(@"%ld",(unsigned long)_representation.size);
    if ((unsigned long)_representation.size/1024/1024<300) {
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self compressedVideoOtherMethodWithURL:_representation.url compressionType:AVAssetExportPresetMediumQuality compressionResultPath:^(NSString *resultPath, float memorySize) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (memorySize <=10) {
                        //                    NSLog(@"%@-----%@-------%@",resultPath,_representation.url,CompressionVideoPaht);
                        [picker dismissViewControllerAnimated:YES completion:nil];
                        //                    NSData *data11 =[NSData dataWithContentsOfFile:resultPath];
                        
                        //                    NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjuserid"];
                        
                        __weak QXXZBViewController *weakSelf=self;
                        NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
                        NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
                        NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
                        NSMutableDictionary *sp_test = [NSMutableDictionary dictionaryWithCapacity:4];
                        [t_h setObject:[setting sharedSetting].app forKey:@"p"];
                        
                        [t_b setObject:sp_test forKey:@"gz_qxhd_video_tj"];
                        [t_dic setObject:t_h forKey:@"h"];
                        [t_dic setObject:t_b forKey:@"b"];
                        [sp_test setObject:self.userID forKey:@"user_id"];
                        [sp_test setObject:self.activityID forKey:@"act_id"];
                        NSString *t_str=[t_dic urlEncodedStringCustom];
                        UIImage *tempImg = [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
                        //                     NSData *SuolueTuData = UIImageJPEGRepresentation(tempImg, 0.5);
                        NSDictionary *parameters = @{@"p":t_str};
                        __block NSData *upData;
                        [MBProgressHUD showHUDAddedTo:self.view withLabel:@"上传中..." animated:YES];
                        //                    ZZCircleProgress *progressView = [[ZZCircleProgress alloc] initWithFrame:CGRectZero pathBackColor:[UIColor cyanColor] pathFillColor:[UIColor redColor] startAngle:0 strokeWidth:8];
                        //                    UIView *backmenban=[[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeitht)];
                        //                    [self.view addSubview:backmenban];
                        //                    self.backmenban=backmenban;
                        //                    //    progressView.pathBackColor = [UIColor cyanColor];//线条背景色
                        //                    //    progressView.pathFillColor = [UIColor redColor];//线条填充色
                        //                    //    progressView.startAngle = 0;//圆弧开始角度，默认为-90°，即正上方
                        //                    //    progressView.reduceValue = 0;//整个圆弧减少的角度，默认为0
                        //                    //    progressView.strokeWidth = 8;//线宽，默认为10
                        //                    progressView.frame = CGRectMake(100, 150, 150, 150);
                        //                    progressView.increaseFromLast = YES;//为YES动画则从上次的progress开始，否则从头开始，默认为NO
                        //                    progressView.animationModel = CircleIncreaseSameTime;//不同的进度条动画时间相同
                        //                    progressView.showPoint = YES;//是否显示光标，默认为YES
                        ////                    progressView.showProgressText = YES;//是否显示进度文本，默认为YES
                        //                    progressView.notAnimated = NO;//不开启动画，默认为NO
                        //                    progressView.forceRefresh = YES;//是否在set的值等于上次值时同样刷新动画，默认为NO
                        //                    self.hud=progressView;
                        //                    progressView.centerX=self.backmenban.centerX;
                        //                    progressView.progress = 0.01;//设置完之后给progress的值
                        //                    [backmenban addSubview:progressView];
                        
                        //                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        //                    hud.mode = MBProgressHUDModeDeterminate;
                        //                    hud.progress=0.1;
                        //                    hud.labelText = @"上传中...";
                        //                    self.hud=hud;
                        //                    [hud show:YES];
                        //                    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"正在上传..." animated:YES];
                        //                  MBProgressHUD *mbHUD=  [[MBProgressHUD alloc] initWithView:self.view];
                        //                    [self.view addSubview:mbHUD];
                        //                    mbHUD.mode=MBProgressHUDModeDeterminate;
                        //                    [mbHUD show:YES];
                        //                        NSLog(@"%@-------------------qxhd_video_tj-------",URL_SERVER);
                        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
                        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
                        manager.responseSerializer.acceptableContentTypes  =[NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript" ,@"text/plain" , nil];
                        [manager POST:URL_SERVER parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                            //视频
                            upData = [NSData dataWithContentsOfFile:resultPath];
                            [formData appendPartWithFileData:upData name:@"file1" fileName:@"temp.mp4" mimeType:@"application/octet-stream"];
                            
                            //缩略图
                            UIImage *imgnew = [weakSelf imageCompressForWidth:tempImg targetWidth:kScreenWidth];//压缩图片
                            NSData *SuolueTuData = UIImageJPEGRepresentation(imgnew, 0.5);
                            [formData appendPartWithFileData:SuolueTuData name:@"file" fileName:@"thumbImg.jpg" mimeType:@"application/octet-stream"];
                            //                         UIProgressView *proget=[[UIProgressView alloc] initWithFrame:CGRectMake(20,100,200,50)];
                            //                        proget.progress=0.1;
                            //                        proget.trackTintColor = [UIColor whiteColor];
                            //                        proget.progressTintColor=[UIColor redColor];
                            //                        proget.backgroundColor=[UIColor blackColor];
                            //                        proget.centerX=weakSelf.webView.centerX;
                            //                        proget.centerY=weakSelf.webView.centerY;
                            //                        weakSelf.proget=proget;
                            //                        [weakSelf.webView addSubview:proget];
                        } progress:^(NSProgress *  uploadProgress) {
                            
                            //                        NSLog(@"----------------视频正在上传----------------");
                            //                            UIProgressView *proget=[[UIProgressView alloc] init];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //                        [weakSelf.proget setProgress:(float)(uploadProgress.fractionCompleted) animated:YES];
                                //                             [self.hud setProgress:(float)(uploadProgress.fractionCompleted)];
                            });
                            //                        proget.progress=uploadProgress;
                            //                        mbHUD.progress=uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
                        } success:^(NSURLSessionDataTask *  task, id   responseObject) {
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            //                        NSLog(@"----------------视频上传成功------%@----------",[NSThread currentThread]);
                            //                        [weakSelf.backmenban removeFromSuperview];
                            if (responseObject != nil)
                            {
                                NSDictionary *bb=[responseObject objectForKey:@"b"];
                                NSDictionary *qxhd_video_tj=bb[@"gz_qxhd_video_tj"];
                                NSString *vid_id=qxhd_video_tj[@"vid_id"];
                                NSString *result=qxhd_video_tj[@"result"];
                                if ([result isEqualToString:@"1"]) {
                                    //修改成功
                                    NSString *jsStr1=[NSString stringWithFormat:@"uploadVideoCallback('%@')",vid_id];
                                    [weakSelf.jscontext evaluateScript:jsStr1];
                                    
                                    
                                }else{
                                    //失败
                                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"上传视频失败" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                    [alert show];
                                    
                                    
                                }
                            }
                            
                            //                        dispatch_async(dispatch_get_main_queue(), ^{
                            //                            self.mk=[[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:resultPath]];
                            //                            self.mk.repeatMode = MPMovieRepeatModeOne;
                            //                            self.mk.scalingMode = MPMovieScalingModeAspectFit;
                            //                            self.mk.controlStyle = MPMovieControlStyleFullscreen;
                            //                            self.mk.view.frame = CGRectMake(0.0,0,self.view.bounds.size.width,self.view.bounds.size.height);
                            //                            [[NSNotificationCenter defaultCenter] addObserver:self
                            //                                                                     selector:@selector(myMovieFinishedCallback:)
                            //                                                                         name:MPMoviePlayerPlaybackDidFinishNotification
                            //                                                                       object:self.mk];
                            //                            [self.view addSubview:self.mk.view];
                            //
                            //                            [self.mk play];
                            //                        });
                            
                        } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
                            //                        NSLog(@"----------------视频上传失败----------------%@",[NSThread currentThread]);
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            //                        [weakSelf.backmenban removeFromSuperview];
                            
                        }];
                        
                        
                        
                    }else{
                        
                        [picker dismissViewControllerAnimated:YES completion:nil];
                        
                    }
                    
                });
                
                
            }];
        });
        
    }else{
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        //失败
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"视频太大" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}
#pragma mark - 照片压缩
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)compressedVideoOtherMethodWithURL:(NSURL *)url compressionType:(NSString *)compressionType compressionResultPath:(CompressionSuccessBlock)resultPathBlock {
    
    NSString *resultPath;
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    CGFloat totalSize = (float)data.length / 1024 / 1024;
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    // 所支持的压缩格式中是否有 所选的压缩格式
    if ([compatiblePresets containsObject:compressionType]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:compressionType];
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];// 用时间, 给文件重新命名, 防止视频存储覆盖,
        
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        
        BOOL isExists = [manager fileExistsAtPath:CompressionVideoPaht];
        
        if (!isExists) {
            
            [manager createDirectoryAtPath:CompressionVideoPaht withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        resultPath = [CompressionVideoPaht stringByAppendingPathComponent:[NSString stringWithFormat:@"outputJFVideo-%@.mp4", [formater stringFromDate:[NSDate date]]]];
        
        
        
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        exportSession.shouldOptimizeForNetworkUse = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.view withLabel:@"正在压缩..." animated:YES];
        });
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         {
             if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                 
                 NSData *data = [NSData dataWithContentsOfFile:resultPath];
                 
                 float memorySize = (float)data.length / 1024 / 1024;
                 NSLog(@"视频压缩后大小 %f", memorySize);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                 });
                 resultPathBlock (resultPath, memorySize);
             } else {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                 });
                 NSLog(@"压缩失败");
             }
             
             
         }];
        
    } else {
        NSLog(@"不支持 %@ 格式的压缩", compressionType);
    }
}




#pragma mark  -------------------------------------------------摄像头拍摄视频测试-------------------------------------------------------------------------------------------

-(void)openShexiangtou
{
    self.backvideoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    self.backvideoView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:self.backvideoView];
    self.videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht-180)];
    [self.backvideoView addSubview:self.videoView];
    self.videoView.layer.masksToBounds = YES;
    [self getAuthorization];
    
    UIView* btView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 86, 86)];
    btView.center = CGPointMake(kScreenWidth/2, kScreenHeitht-100);
    [btView makeCornerRadius:43 borderColor:nil borderWidth:0];
    btView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.backvideoView addSubview:btView];
    
    self.tapBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2 - 60/2, kScreenHeitht - 60, 76, 76)];
    //    [self.tapBtn setTitle:@"单击" forState:UIControlStateNormal];
    self.tapBtn.center = CGPointMake(43, 43);
    self.tapBtn.backgroundColor = [UIColor redColor];
    [self.tapBtn addTarget:self action:@selector(startRecordclick) forControlEvents:UIControlEventTouchUpInside];
    //    [self.tapBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btView addSubview:_tapBtn];
    [self.tapBtn makeCornerRadius:38 borderColor:[UIColor blackColor] borderWidth:3];
    
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 76, 40)];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelBtn.center = CGPointMake(kScreenWidth/4-15,  kScreenHeitht-100);
    [self.backvideoView addSubview:self.cancelBtn];
    [self.cancelBtn addTarget:self action:@selector(Cancelclick) forControlEvents:UIControlEventTouchUpInside];
    
    self.changeCamare = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-40, 5, 34, 34)];
    [self.changeCamare setBackgroundImage:[UIImage imageNamed:@"changeCamer"] forState:UIControlStateNormal];
    [self.backvideoView addSubview:self.changeCamare];
    [self.changeCamare addTarget:self action:@selector(changeCamareclick) forControlEvents:UIControlEventTouchUpInside];
    [self.changeCamare makeCornerRadius:17 borderColor:nil borderWidth:0];
}
- (void)getAuthorization
{
    /*
     AVAuthorizationStatusNotDetermined = 0,// 未进行授权选择
     
     AVAuthorizationStatusRestricted,　　　　// 未授权，且用户无法更新，如家长控制情况下
     
     AVAuthorizationStatusDenied,　　　　　　 // 用户拒绝App使用
     
     AVAuthorizationStatusAuthorized,　　　　// 已授权，可使用
     */
    
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo])
    {
        case AVAuthorizationStatusAuthorized:       //已授权，可使用    The client is authorized to access the hardware supporting a media type.
        {
            NSLog(@"授权摄像头使用成功");
            [self setupAVCaptureInfo];
            break;
        }
        case AVAuthorizationStatusNotDetermined:    //未进行授权选择     Indicates that the user has not yet made a choice regarding whether the client can access the hardware.
        {
            //则再次请求授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){    //用户授权成功
                    [self setupAVCaptureInfo];
                    return;
                } else {        //用户拒绝授权
                    //                    [self backBtnClick];
                    //                    [self showMsgWithTitle:@"出错了" andContent:@"用户拒绝授权摄像头的使用权,返回上一页.请打开\n设置-->隐私/通用等权限设置"];
                    return;
                }
            }];
            break;
        }
        default:                                    //用户拒绝授权/未授权
        {
            //            [self backBtnClick];
            //            [self showMsgWithTitle:@"出错了" andContent:@"拒绝授权,返回上一页.请检查下\n设置-->隐私/通用等权限设置"];
            break;
        }
    }
    
}
- (void)setupAVCaptureInfo
{
    [self addSession];
    
    [_captureSession beginConfiguration];
    
    [self addVideo];
    [self addAudio];
    [self addPreviewLayer];
    
    [_captureSession commitConfiguration];
    
    //开启会话-->注意,不等于开始录制
    [_captureSession startRunning];
    
}
- (void)addSession
{
    _captureSession = [[AVCaptureSession alloc] init];
    //设置视频分辨率
    /*  通常支持如下格式
     (
     AVAssetExportPresetLowQuality,
     AVAssetExportPreset960x540,
     AVAssetExportPreset640x480,
     AVAssetExportPresetMediumQuality,
     AVAssetExportPreset1920x1080,
     AVAssetExportPreset1280x720,
     AVAssetExportPresetHighestQuality,
     AVAssetExportPresetAppleM4A
     )
     */
    //注意,这个地方设置的模式/分辨率大小将影响你后面拍摄照片/视频的大小,
    if ([_captureSession canSetSessionPreset:AVAssetExportPresetHighestQuality]) {
        [_captureSession setSessionPreset:AVAssetExportPresetHighestQuality];
    }
}
- (void)addVideo
{
    // 获取摄像头输入设备， 创建 AVCaptureDeviceInput 对象
    /* MediaType
     AVF_EXPORT NSString *const AVMediaTypeVideo                 NS_AVAILABLE(10_7, 4_0);       //视频
     AVF_EXPORT NSString *const AVMediaTypeAudio                 NS_AVAILABLE(10_7, 4_0);       //音频
     */
    
    /* AVCaptureDevicePosition
     typedef NS_ENUM(NSInteger, AVCaptureDevicePosition) {
     AVCaptureDevicePositionUnspecified         = 0,
     AVCaptureDevicePositionBack                = 1,            //后置摄像头
     AVCaptureDevicePositionFront               = 2             //前置摄像头
     } NS_AVAILABLE(10_7, 4_0) __TVOS_PROHIBITED;
     */
    _videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
    
    [self addVideoInput];
    [self addMovieOutput];
}
#pragma mark 获取摄像头-->前/后
- (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = devices.firstObject;
    
    for ( AVCaptureDevice *device in devices ) {
        if ( device.position == position ) {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

- (void)addVideoInput
{
    NSError *videoError;
    
    // 视频输入对象
    // 根据输入设备初始化输入对象，用户获取输入数据
    _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_videoDevice error:&videoError];
    if (videoError) {
        NSLog(@"---- 取得摄像头设备时出错 ------ %@",videoError);
        return;
    }
    
    // 将视频输入对象添加到会话 (AVCaptureSession) 中
    if ([_captureSession canAddInput:_videoInput]) {
        [_captureSession addInput:_videoInput];
    }
    
}
- (void)addMovieOutput
{
    // 拍摄视频输出对象
    // 初始化输出设备对象，用户获取输出数据
    _movieOutput = [[AVCaptureMovieFileOutput alloc] init];
    Float64 TotalSeconds = 60;            //Total seconds
    int32_t preferredTimeScale = 30;    //Frames per second
    CMTime maxDuration = CMTimeMakeWithSeconds(TotalSeconds, preferredTimeScale);    //<<SET MAX DURATION
    _movieOutput.maxRecordedDuration = maxDuration;
    if ([_captureSession canAddOutput:_movieOutput]) {
        [_captureSession addOutput:_movieOutput];
        AVCaptureConnection *captureConnection = [_movieOutput connectionWithMediaType:AVMediaTypeVideo];
        
        //设置视频旋转方向
        /*
         typedef NS_ENUM(NSInteger, AVCaptureVideoOrientation) {
         AVCaptureVideoOrientationPortrait           = 1,
         AVCaptureVideoOrientationPortraitUpsideDown = 2,
         AVCaptureVideoOrientationLandscapeRight     = 3,
         AVCaptureVideoOrientationLandscapeLeft      = 4,
         } NS_AVAILABLE(10_7, 4_0) __TVOS_PROHIBITED;
         */
        //        if ([captureConnection isVideoOrientationSupported]) {
        //            [captureConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
        //        }
        
        // 视频稳定设置
        if ([captureConnection isVideoStabilizationSupported]) {
            captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
        
        captureConnection.videoScaleAndCropFactor = captureConnection.videoMaxScaleAndCropFactor;
    }
    
}
- (void)addAudio
{
    NSError *audioError;
    // 添加一个音频输入设备
    _audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    //  音频输入对象
    _audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:_audioDevice error:&audioError];
    if (audioError) {
        NSLog(@"取得录音设备时出错 ------ %@",audioError);
        return;
    }
    // 将音频输入对象添加到会话 (AVCaptureSession) 中
    if ([_captureSession canAddInput:_audioInput]) {
        [_captureSession addInput:_audioInput];
    }
}

- (void)addPreviewLayer
{
    
    [self.view layoutIfNeeded];
    
    // 通过会话 (AVCaptureSession) 创建预览层
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    _captureVideoPreviewLayer.frame = self.view.layer.bounds;
    /* 填充模式
     Options are AVLayerVideoGravityResize, AVLayerVideoGravityResizeAspect and AVLayerVideoGravityResizeAspectFill. AVLayerVideoGravityResizeAspect is default.
     */
    //有时候需要拍摄完整屏幕大小的时候可以修改这个
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    // 如果预览图层和视频方向不一致,可以修改这个
    _captureVideoPreviewLayer.connection.videoOrientation = [_movieOutput connectionWithMediaType:AVMediaTypeVideo].videoOrientation;
    _captureVideoPreviewLayer.position = CGPointMake(self.view.width*0.5,self.videoView.height*0.5);
    
    // 显示在视图表面的图层
    CALayer *layer = self.videoView.layer;
    layer.masksToBounds = true;
    [self.view layoutIfNeeded];
    [layer addSublayer:_captureVideoPreviewLayer];
    
}

-(void)startRecordclick
{
    self.isRecording=!self.isRecording;
    if (self.isRecording) {
        [self startRecord];
        [self.tapBtn makeCornerRadius:38 borderColor:UIColorFromRGB(0x28292b) borderWidth:10];
    }else{
        [self.tapBtn makeCornerRadius:38 borderColor:UIColorFromRGB(0x28292b) borderWidth:3];
        [self stopRecord];
        
    }
    
}
#pragma mark 录制相关
- (NSURL *)outPutFileURL
{
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"outPut.mov"]];
}

- (void)startRecord
{
    [_movieOutput startRecordingToOutputFileURL:[self outPutFileURL] recordingDelegate:self];
}
- (void)stopRecord
{
    // 取消视频拍摄
    [_movieOutput stopRecording];
}

#pragma mark 录制相关  代理方法
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"---- 开始录制 ----");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"---- 录制结束 outputFileURL---%@-  captureOutput.outputFileURL - %@ ",outputFileURL,captureOutput.outputFileURL);
    
    if (outputFileURL.absoluteString.length == 0 && captureOutput.outputFileURL.absoluteString.length == 0 ) {
        //        [self showMsgWithTitle:@"出错了" andContent:@"录制视频保存地址出错"];
        return;
    }
    
    //    if (self.canSave) {
    //        [self pushToPlay:outputFileURL];
    //        self.canSave = NO;
    //    }
    __weak QXXZBViewController *weakSelf=self;
    
    //视频保存后 播放视频
    if (!self.isCancel) {
        NSString *urlPath = [outputFileURL path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlPath)) {
            UISaveVideoAtPathToSavedPhotosAlbum(urlPath, self, nil, nil);
            [self.backvideoView removeFromSuperview];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 打开图库所有视频
                    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
                    picker.maximumNumberOfSelection = 0;
                    picker.assetsFilter = [ALAssetsFilter allVideos];
                    picker.showEmptyGroups=NO;
                    picker.delegate=weakSelf;
                    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                            return duration >= 5;
                        } else {
                            return YES;
                        }
                    }];
                    
                    [weakSelf presentViewController:picker animated:YES completion:NULL];
                });
            });
            
            
        }
    }
}
-(void)changeCamareclick
{
    
    switch (_videoDevice.position) {
        case AVCaptureDevicePositionBack:
            _videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionFront];
            break;
        case AVCaptureDevicePositionFront:
            _videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
            break;
        default:
            return;
            break;
    }
    
    [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_videoDevice error:&error];
        
        if (newVideoInput != nil) {
            //必选先 remove 才能询问 canAdd
            [_captureSession removeInput:_videoInput];
            if ([_captureSession canAddInput:newVideoInput]) {
                [_captureSession addInput:newVideoInput];
                _videoInput = newVideoInput;
            }else{
                [_captureSession addInput:_videoInput];
            }
            
        } else if (error) {
            NSLog(@"切换前/后摄像头失败, error = %@", error);
        }
    }];
    
}
//更改设备属性前一定要锁上
-(void)changeDevicePropertySafety:(void (^)(AVCaptureDevice *captureDevice))propertyChange{
    //也可以直接用_videoDevice,但是下面这种更好
    AVCaptureDevice *captureDevice= [_videoInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁,意义是---进行修改期间,先锁定,防止多处同时修改
    BOOL lockAcquired = [captureDevice lockForConfiguration:&error];
    NSLog(@"lockForConfiguration");
    if (!lockAcquired) {
        NSLog(@"锁定设备过程error，错误信息：%@",error.localizedDescription);
    }else{
        [_captureSession beginConfiguration];
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
        [_captureSession commitConfiguration];
        NSLog(@"unlockForConfiguration");
        
    }
}
-(void)Cancelclick
{
    self.isCancel=YES;
    //    [_movieOutput stopRecording];
    [_captureSession stopRunning];
    [self.backvideoView removeFromSuperview];
}

#pragma mark  -------------------------------------------------摄像头拍摄视频测试-------------------------------------------------------------------------------------------
@end
