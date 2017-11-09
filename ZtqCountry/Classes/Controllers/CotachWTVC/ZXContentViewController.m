//
//  ZXContentViewController.m
//  ZtqCountry
//
//  Created by Admin on 16/10/27.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "ZXContentViewController.h"
#import "EGOImageView.h"
#import "UILabel+utils.h"
#import "ShareSheet.h"
#import "weiboVC.h"
@interface ZXContentViewController ()
@property(strong,nonatomic)UIScrollView *bgscroview;
@property(strong,nonatomic)UILabel *wztitlelab,*timelab,*contentlab;
@property(strong,nonatomic)EGOImageView *egoimg;
@property(strong,nonatomic)UIImage *shareimg;
@property(strong,nonatomic)NSString *sharecontent;//分享内容
@end

@implementation ZXContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.barHiden=NO;
    self.titleLab.text=self.titlestr;
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView *scro = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, [UIScreen mainScreen].bounds.size.height-20-45)];
    scro.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    scro.contentSize=CGSizeMake(self.view.width, kScreenHeitht+100);
    [self.view addSubview:scro];
    self.bgscroview=scro;
    
    UIButton *sharebtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-50,27, 30, 30)];
    [sharebtn setBackgroundImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
    [sharebtn setBackgroundImage:[UIImage imageNamed:@"分享 二态.png"] forState:UIControlStateHighlighted];
    [sharebtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarBg addSubview:sharebtn];
    
    UILabel *titlelab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    titlelab.textColor=[UIColor blackColor];
    titlelab.numberOfLines=0;
    titlelab.textAlignment=NSTextAlignmentCenter;
    titlelab.backgroundColor=[UIColor clearColor];
    titlelab.font=[UIFont systemFontOfSize:18];
    [scro addSubview:titlelab];
    self.wztitlelab=titlelab;
    
    UILabel *put=[[UILabel alloc]initWithFrame:CGRectMake(0, 30, kScreenWidth, 50)];
    put.textColor=[UIColor grayColor];
    put.textAlignment=NSTextAlignmentCenter;
    put.backgroundColor=[UIColor clearColor];
    put.font=[UIFont systemFontOfSize:12];
    [scro addSubview:put];
    self.timelab=put;
    
    EGOImageView *img=[[EGOImageView alloc]initWithFrame:CGRectMake(10, 80, kScreenWidth-20, 225)];
    img.placeholderImage=[UIImage imageNamed:@"影视背景.jpg"];
    [scro addSubview:img];
    self.egoimg=img;
    
    UILabel *cont=[[UILabel alloc]initWithFrame:CGRectMake(10, 310, kScreenWidth-20, 300)];
    cont.textColor=[UIColor blackColor];
    //    cont.adjustsFontSizeToFitWidth = YES;
    cont.contentMode = UIViewContentModeScaleAspectFit;
    
    cont.numberOfLines=0;
    cont.textAlignment=NSTextAlignmentLeft;
    cont.backgroundColor=[UIColor clearColor];
    cont.font=[UIFont systemFontOfSize:16];
    [scro addSubview:cont];
    self.contentlab=cont;
    [self loadwzdetail];
}
#pragma mark分享
-(void)shareAction{
    [self getShareContent];
 
    
}
-(void)getCaptureScreen{
    UIImage *moreImage=[self makeImageMore];
    self.shareimg=moreImage;
    NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weiboShare.png"];
    if ([UIImagePNGRepresentation(moreImage) writeToFile:shareImagePath atomically:YES])
        NSLog(@">>write ok");
}
-(void)loadwzdetail{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    if (self.wzid.length>0) {
        [gz_todaywt_inde setObject:self.wzid forKey:@"id"];
    }
    [b setObject:gz_todaywt_inde forKey:@"gz_mltq_info"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary *gz_mltq_info=[b objectForKey:@"gz_mltq_info"];
            NSString *title=[gz_mltq_info objectForKey:@"title"];
            NSString *time=[gz_mltq_info objectForKey:@"release_time"];
            NSString *big_img=[gz_mltq_info objectForKey:@"big_img"];
            NSString *des=[gz_mltq_info objectForKey:@"desc"];
            self.wztitlelab.text=title;
            self.timelab.text=time;
            [self.egoimg setImageURL:[ShareFun makeImageUrl:big_img]];
            self.contentlab.text=des;
            if (des.length>0) {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:des];;
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                [paragraphStyle setLineSpacing:4];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, des.length)];
                
                self.contentlab.attributedText = attributedString;
                //调节高度
                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor blackColor], NSParagraphStyleAttributeName : paragraphStyle.copy};
                float H =   [self.contentlab.text boundingRectWithSize:CGSizeMake(300, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
                //    float H=[cont labelheight:self.contentstr withFont:[UIFont systemFontOfSize:18]];
                self.contentlab.frame=CGRectMake(10, 310, self.view.width-20, H);
                self.bgscroview.contentSize=CGSizeMake(self.view.width, 310+H);
            }
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } withCache:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getShareContent{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    [gz_todaywt_inde setObject:[setting sharedSetting].currentCityID forKey:@"county_id"];
    [gz_todaywt_inde setObject:@"ABOUT_GZ_DOWN" forKey:@"keyword"];
    [b setObject:gz_todaywt_inde forKey:@"gz_wt_share"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_wt_share"];
            NSString *sharecontent=[gz_air_qua_index objectForKey:@"share_content"];
            self.sharecontent=[NSString stringWithFormat:@"%@《%@》。%@",self.titlestr,self.wztitlelab.text,sharecontent];
            [self performSelector:@selector(getCaptureScreen) withObject:nil afterDelay:0];
            //分享
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
    UIGraphicsBeginImageContextWithOptions(self.bgscroview.contentSize, NO, 0.0);
    //    UIGraphicsBeginImageContext(_glassScrollView.foregroundScrollView.contentSize);
    {
        CGPoint savedContentOffset = self.bgscroview.contentOffset;
        CGRect savedFrame = self.bgscroview.frame;
        
        self.bgscroview.contentOffset = CGPointZero;
        self.bgscroview.frame = CGRectMake(0, 0, kScreenWidth, self.bgscroview.contentSize.height);
        self.bgscroview.backgroundColor=[UIColor whiteColor];
        [self.bgscroview.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        self.bgscroview.backgroundColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
        self.bgscroview.contentOffset = savedContentOffset;
        self.bgscroview.frame = savedFrame;
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
            //			[t_weibo release];
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


@end
