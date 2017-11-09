//
//  WebViewController.m
//  ZtqCountry
//
//  Created by Admin on 15/6/10.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "WebViewController.h"
#import "LGViewController.h"
#import "HDWebJSbean.h"
@implementation WebViewController
-(void)viewDidLoad{
    self.isshare=NO;
    self.isback=NO;
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    float place = 0;
    if(kSystemVersionMore7)
    {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
        place = 20;
    }
    self.barhight=place+44;
    
    _navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    _navigationBarBg.userInteractionEnabled = YES;
    _navigationBarBg.image=[UIImage imageNamed:@"导航栏.png"];
    [self.view addSubview:_navigationBarBg];
    
    UIButton * leftBut = [[UIButton alloc] initWithFrame:CGRectMake(20, 7+place, 30, 30)];
    [leftBut setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [leftBut setImage:[UIImage imageNamed:@"返回点击.png"] forState:UIControlStateHighlighted];
    [leftBut setBackgroundColor:[UIColor clearColor]];
    
    [leftBut addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarBg addSubview:leftBut];
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 12+place, kScreenWidth-120, 20)];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textColor = [UIColor whiteColor];
    [_navigationBarBg addSubview:_titleLab];
    _titleLab.text=self.titleString;
    UIWebView * webV = [[UIWebView alloc]initWithFrame:CGRectMake(0, self.barhight, kScreenWidth, kScreenHeitht-self.barhight)];
    webV.delegate = self;
    webV.scalesPageToFit=YES;//允许缩放
    self.web = webV;
    [self.view addSubview:webV];
//    [self loadWeb:self.url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(call:) name:@"sharesuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReciviceWebBeanData:) name:@"ReciviceWebBeanData" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lgsuccessAction) name:@"lgsuccsess" object:nil];
    UIActivityIndicatorView * activityV = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [activityV setCenter:self.view.center];
    [activityV setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    self.activity = activityV;
    [self.view addSubview:activityV];
//    [self loadShareContent];
}
-(void)leftAction{
 
//    if (self.web.canGoBack&&self.isback==YES) {
//        [self.web goBack];
//    }else{
        [self.navigationController popViewControllerAnimated:YES];
//    }
}
-(void)ReciviceWebBeanData:(NSNotification *)noti
{
    
    NSDictionary *userInfo=noti.object;
    NSString *activityID=userInfo[@"act_id"];
    NSString *share_type=userInfo[@"share_type"];
    self.urlact_id=activityID;
    self.url_type=share_type;
    [self action];
}
-(void)viewWillAppear:(BOOL)animated{

    NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"sjuserid"];
    NSString *url=self.url;
    self.userid=userid;

        if (userid.length>0) {
            url=[NSString stringWithFormat:@"%@?USER_ID=%@&PID=%@",self.url,userid,[setting sharedSetting].app];
        }else{
            url=[NSString stringWithFormat:@"%@?USER_ID=&PID=%@",self.url,[setting sharedSetting].app];
        }
        [self.activity startAnimating];
    self.nolgurl=url;
    if (self.isshare==NO) {
        [self loadWeb:url];
    }
}

-(void)loadWeb:(NSString *)urlS
{
    //    NSLog(@"##%@##",urlS);
    NSURL * url = [NSURL URLWithString:urlS];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.web loadRequest:request];
}

#pragma mark - UIWebViewDelegate

//-(void)webViewDidStartLoad:(UIWebView *)webView
//{
//    [self.activity startAnimating];
//}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activity stopAnimating];
    __weak WebViewController *weakSelf=self;
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
//    self.titleLab.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    HDWebJSbean *qxxz=[[HDWebJSbean alloc] init];
    self.jsContext[@"js"]=qxxz;
    // 打印异常
    self.jsContext.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };
//    self.jsContext[@"share"] =
//    ^(NSString *str)
//    {
//        [weakSelf action];
//
//    };

    self.jsContext[@"login"] =
    ^(NSString *str)
    {
//                NSLog(@"%@", str);
        LGViewController *lg=[[LGViewController alloc]init];
        lg.type=@"web";
        [weakSelf.navigationController pushViewController:lg animated:YES];
    };
//    if (self.nolgurl.length>0) {
//        NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
//        if ([currentURL rangeOfString:self.nolgurl].location!=NSNotFound ) {
//            self.isback=NO;
//        }else{
//            self.isback=YES;
//        }
//    }
    
    [self performSelector:@selector(getCaptureimg) withObject:nil afterDelay:2];

}
-(void)lgsuccessAction{
    self.isback=YES;
}
- (void)call:(NSNotification *)object{
//    NSLog(@"call");
    NSString *type=object.object;
    self.sharetype=type;

    [self loadShareState];//分享提交

    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    self.isshare=YES;
//    // 之后在回调js的方法Callback把内容传出去
//    JSValue *Callback = self.jsContext[@"shareCallback"];
//    //传值给web端
//    [Callback callWithArguments:@[@"1"]];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activity stopAnimating];
}
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
    if (self.urlact_id.length>0) {
       [gz_todaywt_inde setObject:self.urlact_id forKey:@"act_id"];
    }
    if (self.url_type.length>0) {
        [gz_todaywt_inde setObject:self.url_type forKey:@"type"];
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
                JSValue *Callback = self.jsContext[@"shareCallback"];
                //传值给web端
                [Callback callWithArguments:@[@"1"]];
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
#pragma  mark 加载分享内容
-(void)loadShareContent{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:@"GZ_ABOUT_QD_LLFW" forKey:@"keyword"];
    [b setObject:gz_todaywt_inde forKey:@"gz_wt_share"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
       
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            
            NSDictionary *addic=[b objectForKey:@"gz_wt_share"];
            NSString *share_content=[addic objectForKey:@"share_content"];
            self.shareContent=share_content;
        }
        
    } withFailure:^(NSError *error) {
       
    } withCache:YES];
}
#pragma mark分享
-(void)action{
    
    NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weiboShare.png"];
    [UIImagePNGRepresentation(self.shareimg) writeToFile:shareImagePath atomically:YES];
    ShareView *share=[[ShareView alloc]initDefaultWithTitle:@"分享到" WithShareContext:self.shareContent subtitile:nil WithShareimg:self.shareimg WithControllview:self];
    [share show];
}
-(void)getCaptureimg{
    NSMutableArray *images=[[NSMutableArray alloc]init];
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(self.web.scrollView.contentSize, NO, 0.0);
    //    UIGraphicsBeginImageContext(_glassScrollView.foregroundScrollView.contentSize);
    {
        CGPoint savedContentOffset = self.web.scrollView.contentOffset;
        CGRect savedFrame =  self.web.scrollView.frame;
        
        self.web.scrollView.contentOffset = CGPointZero;
        self.web.scrollView.frame = CGRectMake(0, 0, kScreenWidth,  self.web.scrollView.contentSize.height);
        [ self.web.scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        self.web.scrollView.contentOffset = savedContentOffset;
        self.web.scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    [images addObject:image];
    UIImage *newbgimg=[self verticalImageFromArray:images];
    self.shareimg=newbgimg;
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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
