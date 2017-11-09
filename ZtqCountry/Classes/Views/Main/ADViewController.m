//
//  ADViewController.m
//  ZtqNew
//
//  Created by linxg on 13-11-27.
//
//

#import "ADViewController.h"
#import "ShareFun.h"
//#import "BShareViewController.h"
#import "LunarDB.h"
//#import "TuiJianViewController.h"
#import "ShareSheet.h"
#import "weiboVC.h"
@interface ADViewController ()
@property(nonatomic,strong) UIImageView *navigationBarBg;
@end

@implementation ADViewController

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
    self.navigationBarBg=navigationBarBg;
    navigationBarBg.image=[UIImage imageNamed:@"导航栏.png"];
    [self.view addSubview:navigationBarBg];
    
    UIButton * leftBut = [[UIButton alloc] initWithFrame:CGRectMake(20, 7+place, 30, 30)];
    [leftBut setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [leftBut setImage:[UIImage imageNamed:@"返回点击.png"] forState:UIControlStateHighlighted];
    [leftBut setBackgroundColor:[UIColor clearColor]];
    
    [leftBut addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarBg addSubview:leftBut];

    UIButton * rightbut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-40, 7+place, 30, 30)];
    [rightbut setImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
    [rightbut setImage:[UIImage imageNamed:@"分享点击.png"] forState:UIControlStateHighlighted];
    [rightbut setBackgroundColor:[UIColor clearColor]];
    
    [rightbut addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarBg addSubview:rightbut];
    
//    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 7+place, 200, 30)];
//    titleLab.textAlignment = NSTextAlignmentCenter;
//    titleLab.font = [UIFont fontWithName:kBaseFont size:20];
//    titleLab.backgroundColor = [UIColor clearColor];
//    titleLab.textColor = [UIColor whiteColor];
//    titleLab.text = @"旅游气象";
//    [navigationBarBg addSubview:titleLab];
    
    
    
//    UIButton *share_button = [[UIButton alloc] initWithFrame:CGRectMake(270, y, 44, 44)];
//	[share_button setBackgroundColor:[UIColor clearColor]];
//	[share_button setImage:[UIImage imageNamed:@"分享按钮.png"] forState:UIControlStateNormal];
//	[share_button addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:share_button];
//	[share_button release];
    
    _titlelab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5+place, self.view.width, 36)];
	_titlelab.userInteractionEnabled = NO;
	_titlelab.font = [UIFont fontWithName:@"Helvetica" size:18];
	_titlelab.textColor = [UIColor whiteColor];
	_titlelab.textAlignment = NSTextAlignmentCenter;
	_titlelab.backgroundColor = [UIColor clearColor];
    _titlelab.text=@"生活指数";
	[navigationBarBg addSubview:_titlelab];
//	[_titlelab release];
    
    
    UIWebView * webV = [[UIWebView alloc]initWithFrame:CGRectMake(0, 45+place, kScreenWidth, kScreenHeitht-45-place)];
    webV.delegate = self;
    self.web = webV;
    [self.view addSubview:webV];
//    [webV release];
    [self loadWeb:self.url];
    
    
    UIActivityIndicatorView * activityV = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [activityV setCenter:self.view.center];
    [activityV setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    self.activity = activityV;
    [self.view addSubview:activityV];
//    [activityV release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadWeb:(NSString *)urlS
{
//    NSLog(@"##%@##",urlS);
    NSURL * url = [NSURL URLWithString:urlS];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.web loadRequest:request];
}

-(void)rightAction:(UIButton *)sender{
    [self getShareContent];
 
}
-(void)getShareContent{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    [gz_todaywt_inde setObject:self.titleString forKey:@"liv_name"];
    [gz_todaywt_inde setObject:@"LIVING" forKey:@"keyword"];
    [b setObject:gz_todaywt_inde forKey:@"gz_wt_share"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_wt_share"];
            NSString *sharecontent=[gz_air_qua_index objectForKey:@"share_content"];
            self.sharecontent=sharecontent;
            UIImage *t_shareImage = [self makeImageMore];
            self.shareimg=t_shareImage;
            NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weiboShare.png"];
            [UIImagePNGRepresentation(t_shareImage) writeToFile:shareImagePath atomically:YES];
            ShareSheet * sheet = [[ShareSheet alloc] initDefaultWithTitle:@"分享天气" withDelegate:self];
            [sheet show];
        }
        
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
    } withCache:YES];
}
-(UIImage *)makeImageMore
{
    NSMutableArray *images=[[NSMutableArray alloc]init];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, 64), NO, 0.0);
    [self.navigationBarBg.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [images addObject:tempImage];
    
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(self.web.scrollView.contentSize, NO, 0.0);
    //    UIGraphicsBeginImageContext(_glassScrollView.foregroundScrollView.contentSize);
    {
        CGPoint savedContentOffset = self.web.scrollView.contentOffset;
        CGRect savedFrame = self.web.scrollView.frame;
        
        self.web.scrollView.contentOffset = CGPointZero;
        self.web.scrollView.frame = CGRectMake(0, 0, kScreenWidth, self.web.scrollView.contentSize.height);
     
        [self.web.scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
  
        self.web.scrollView.contentOffset = savedContentOffset;
        self.web.scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    [images addObject:image];
    //添加二维码
    UIImage *ewmimg=[UIImage imageNamed:@"指纹二维码.jpg"];
    UIImageView *ewm=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 177)];
    ewm.image=ewmimg;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, 177), NO, 0.0);
    [ewm.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *tempImage1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [images addObject:tempImage1];
    
    //    [self verticalImageFromArray:images];
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
-(void)ShareSheetClickWithIndexPath:(NSInteger)indexPath
{
    NSString *shareContent = self.sharecontent;
    switch (indexPath)
    {
            
        case 0: {
            weiboVC *t_weibo = [[weiboVC alloc] initWithNibName:@"weiboVC" bundle:nil];
            [t_weibo setShareText:shareContent];
            [t_weibo setShareImage:@"weiboShare.png"];
            [t_weibo setShareType:1];
            [self presentViewController:t_weibo animated:YES completion:nil];
            
            break;
        }
        case 1:{
            NSString *url;
            if ([self.sharecontent rangeOfString:@"http"].location!=NSNotFound) {
                NSArray *arr=[self.sharecontent componentsSeparatedByString:@"http"];
                if (arr.count>0) {
                    url=[NSString stringWithFormat:@"http%@",arr[1]];
                }
            }
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            UMShareWebpageObject *shareweb=[[UMShareWebpageObject alloc]init];
            shareweb.webpageUrl=url;
            shareweb.title=@"知天气分享";
            shareweb.thumbImage=self.shareimg;
            shareweb.descr=self.sharecontent;
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
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            //创建图片内容对象
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            //如果有缩略图，则设置缩略图
            [shareObject setShareImage:self.shareimg];
            
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
            shareObject.title=shareContent;
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
        case 3: {
            NSString *url;
            if ([self.sharecontent rangeOfString:@"http"].location!=NSNotFound) {
                url=[self.sharecontent substringToIndex:[self.sharecontent rangeOfString:@"http"].location];
            }else{
                url=self.sharecontent;
            }
            //要分享的内容，加在一个数组里边，初始化UIActivityViewController
            NSMutableArray *activityItems=[[NSMutableArray alloc] init];
            NSString *textToShare = url;
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
-(void)leftAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)rightAction:(UIButton *)sender
//{
//    UIImage *t_shareImage = [ShareFun captureScreen];
//
//	NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weiboShare.png"];
//	if ([UIImagePNGRepresentation(t_shareImage) writeToFile:shareImagePath atomically:YES])
//		NSLog(@">>write ok");
////    NSString * city = [(NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:@"crtCity"] objectForKey:@"city"];
//////
////    
////    LunarDB *m_lunarDB = [[LunarDB alloc]init];
////    [m_lunarDB setSolarDate:[NSDate date]];
////    NSString * date = [NSString stringWithFormat:@"%@%@%@%@", [m_lunarDB SolorDateString], [m_lunarDB SolorDayString],@"日",[m_lunarDB SolorWeekDayString]];
////
////    NSString *share = [NSString stringWithFormat:@"%@ %@ %@%@",city,date,self.shareContent ,@"(来自@知天气)."];
//	
//	
//	[ShareFun actionNoticeWithView:self.web withContent:self.shareContent];
//
//}



-(void)setBG:(NSString *)bg withLeftBarBG:(NSString *)left withRightBarBG:(NSString *)right
{
//    if(bg&&bg.length)
//    {
//        UIImageView * imageV = [[UIImageView alloc]initWithFrame:self.view.frame];
//        imageV.image = [UIImage imageNamed:bg];
//        [self.view insertSubview:imageV atIndex:0];
//        [imageV release];
//    }
//    if(left&&left.length)
//    {
//        UIButton * leftBT = [UIButton buttonWithType:UIButtonTypeCustom];
//        leftBT.frame = CGRectMake(0, 0, 35, 25);
//        [leftBT setBackgroundImage:[UIImage imageNamed:left] forState:UIControlStateNormal];
//        [leftBT addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem * leftBarBt = [[[UIBarButtonItem alloc]initWithCustomView:leftBT]autorelease];
//        self.navigationItem.leftBarButtonItem = leftBarBt;
//    }
//    if(right&&right.length)
//    {
//        UIButton * rightBT = [UIButton buttonWithType:UIButtonTypeCustom];
//        rightBT.frame = CGRectMake(0, 0, 50, 25);
//        [rightBT setBackgroundImage:[UIImage imageNamed:right] forState:UIControlStateNormal];
//        [rightBT addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem * rightBarBt = [[[UIBarButtonItem alloc]initWithCustomView:rightBT]autorelease];
//        self.navigationItem.rightBarButtonItem = rightBarBt;
//
//    }
}


-(void)dealloc
{
    self.web.delegate = nil;
//    [_web release];
//    _web = nil;
//    [_activity release];
//    _activity = nil;
//    [_url release];
//    _url = nil;
//    [_shareContent release];
//    _shareContent = nil;
//    [_titlelab release];
//    _titlelab = nil;
//    [_titleString release];
//    _titleString = nil;
//    [super dealloc];
}



#pragma mark -
#pragma mark - UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activity startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activity stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activity stopAnimating];
}




@end
