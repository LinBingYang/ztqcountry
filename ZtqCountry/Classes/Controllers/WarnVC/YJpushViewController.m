//
//  YJpushViewController.m
//  ZtqCountry
//
//  Created by 胡彭飞 on 16/7/28.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "YJpushViewController.h"
#import "UILabel+utils.h"
#import "weiboVC.h"
//#import "UMSocial.h"
#import "ShareSheet.h"
#import "UILabel+utils.h"
@interface YJpushViewController ()

@end

@implementation YJpushViewController

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
    self.barHeight=place+44;
    
    self.navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    self.navigationBarBg.userInteractionEnabled = YES;
    self.navigationBarBg.image=[UIImage imageNamed:@"导航栏.png"];
    [self.view addSubview:self.navigationBarBg];
    
    UIImageView *leftimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7+place, 29, 29)];
    leftimg.image=[UIImage imageNamed:@"返回.png"];
    leftimg.userInteractionEnabled=YES;
    [self.navigationBarBg addSubview:leftimg];
    
    UIButton * leftBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 7+place, 60, 44+place)];
    [leftBut setBackgroundColor:[UIColor clearColor]];
    
    [leftBut addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarBg addSubview:leftBut];
    
    UIButton * rightbut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-40, 7+place, 30, 30)];
    [rightbut setImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
    [rightbut setBackgroundColor:[UIColor clearColor]];
    
    [rightbut addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarBg addSubview:rightbut];
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 7+place, kScreenWidth-120, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text =@"气象预警";
    [self.navigationBarBg addSubview:titleLab];
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    m_scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, kScreenHeitht)];
    m_scroll.contentSize=CGSizeMake(kScreenWidth,kScreenHeitht+80);
    m_scroll.showsVerticalScrollIndicator=NO;
    m_scroll.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:m_scroll];
    
    [self loadDatas];
    
}
-(void)loadDatas
{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * yjxx_index = [[NSMutableDictionary alloc] init];
    [yjxx_index setObject:self.warnid forKey:@"id"];
    [b setObject:yjxx_index forKey:@"gz_query_warn_by_id"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    NSString *str=[param urlEncodedStringCustom];
    NSDictionary *parameters = @{@"p":str};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * b = [responseObject objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_query_warn_by_id = [b objectForKey:@"gz_query_warn_by_id"];
            NSDictionary *yjxx_index=[gz_query_warn_by_id objectForKey:@"warn"];
                NSString *desc,*color,*ico,*warninfo,*put,*putstr,*fyznstr,*warn_id;
                desc = [yjxx_index objectForKey:@"title"];
                color = [yjxx_index objectForKey:@"color"];
                ico = [yjxx_index objectForKey:@"ico"];
                warninfo   = [yjxx_index objectForKey:@"content"];
                put=[yjxx_index objectForKey:@"pt"];
                putstr=[yjxx_index objectForKey:@"station_name"];
                fyznstr=[yjxx_index objectForKey:@"defend"];
            
            UIImageView *ico1=[[UIImageView alloc]initWithFrame:CGRectMake(16, 8, 60, 55)];
            ico1.image=[UIImage imageNamed:ico];
            [m_scroll addSubview:ico1];
            
            UILabel *titleLa=[[UILabel alloc]initWithFrame:CGRectMake(85, 8, 180, 40)];
            titleLa.text=desc;
            titleLa.textColor=[UIColor blackColor];
            titleLa.numberOfLines=0;
            titleLa.font=[UIFont systemFontOfSize:18];
            titleLa.backgroundColor=[UIColor clearColor];
            [m_scroll addSubview:titleLa];
            UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(80, 43, kScreenWidth-85, 1)];
            line.backgroundColor=[UIColor orangeColor];
            [m_scroll addSubview:line];
            NSString *putstring=[NSString stringWithFormat:@"%@  %@",putstr,put];
            
            UILabel *desLa=[[UILabel alloc]initWithFrame:CGRectMake(85, 45, 200, 20)];
            desLa.text=putstring;
            desLa.numberOfLines=0;
            desLa.textColor=[UIColor colorHelpWithRed:84 green:83 blue:83 alpha:1];
            desLa.font=[UIFont systemFontOfSize:12.0];
            [m_scroll addSubview:desLa];

            UILabel *contentLa=[[UILabel alloc]initWithFrame:CGRectMake(16, 60, kScreenWidth-32, 150)];
            contentLa.text=[NSString stringWithFormat:@"    %@",warninfo];
            contentLa.numberOfLines=0;
            contentLa.textAlignment=NSTextAlignmentLeft;
            contentLa.textColor=[UIColor blackColor];
            contentLa.font=[UIFont systemFontOfSize:15.0];
            contentLa.backgroundColor=[UIColor clearColor];
            [m_scroll addSubview:contentLa];
            float h=[contentLa labelheight:warninfo withFont:[UIFont systemFontOfSize:15.0]];
            contentLa.frame=CGRectMake(16, 60, kScreenWidth-32, h+30);
            
            //分享内容
            self.guidestr=[NSString stringWithFormat:@"%@ %@ %@ @知天气。下载“知天气”客户端：http://218.85.78.125:8099/ztq_wap/",desc,warninfo,putstring];
            
            if (fyznstr.length>0) {
                UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(5, 60+h+40, kScreenWidth-10, 1)];
                //        line.image=[UIImage imageNamed:@"预警隔条"];
                line.backgroundColor=[UIColor orangeColor];
                [m_scroll addSubview:line];
                
                
                
                UILabel * gtitleLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 60+h+50, 300, 20)];
                gtitleLab.backgroundColor = [UIColor clearColor];
                gtitleLab.text = @"防御指南:";
                gtitleLab.textAlignment = NSTextAlignmentLeft;
                gtitleLab.font = [UIFont systemFontOfSize:16];
                gtitleLab.textColor = [UIColor blackColor];
                //    [m_scroll addSubview:gtitleLab];
                UILabel * contentView = [[UILabel alloc] initWithFrame:CGRectMake(16, 110+h, 300, 20)];
                contentView.numberOfLines = 0;
                contentView.backgroundColor = [UIColor clearColor];
                contentView.text = fyznstr;
                contentView.textAlignment = NSTextAlignmentLeft;
                contentView.font = [UIFont systemFontOfSize:15];
                contentView.textColor =[UIColor blackColor];
                CGFloat labHeight = [contentView labelheight:fyznstr withFont:[UIFont systemFontOfSize:15]];
                contentView.frame = CGRectMake(16, 110+h, 300, labHeight+50);
                [m_scroll addSubview:contentView];
                
                [m_scroll setContentSize:CGSizeMake(kScreenWidth, labHeight+h+220)];
            }
            

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];


}
-(void)leftBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBtn:(UIButton *)sender{
    [self getShareContent];

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
    UIGraphicsBeginImageContextWithOptions(m_scroll.contentSize, NO, 0.0);
    //    UIGraphicsBeginImageContext(_glassScrollView.foregroundScrollView.contentSize);
    {
        CGPoint savedContentOffset = m_scroll.contentOffset;
        CGRect savedFrame = m_scroll.frame;
        
        m_scroll.contentOffset = CGPointZero;
        m_scroll.frame = CGRectMake(0, 0, kScreenWidth, m_scroll.contentSize.height);
        [m_scroll.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        m_scroll.contentOffset = savedContentOffset;
        m_scroll.frame = savedFrame;
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

-(void)getShareContent{
    NSString * urlStr = URL_SERVER;
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * h = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * b = [[NSMutableDictionary alloc] init];
    [h setObject:[setting sharedSetting].app forKey:@"p"];
    NSMutableDictionary * gz_todaywt_inde = [[NSMutableDictionary alloc] init];
    if (self.warnid.length>0) {
        [gz_todaywt_inde setObject:self.warnid forKey:@"warn_id"];
    }
    [gz_todaywt_inde setObject:@"WARN" forKey:@"keyword"];
    [b setObject:gz_todaywt_inde forKey:@"gz_wt_share"];
    [param setObject:h forKey:@"h"];
    [param setObject:b forKey:@"b"];
    [[NetWorkCenter share] postHttpWithUrl:urlStr withParam:param withFlag:1 withSuccess:^(NSDictionary *returnData) {
        NSDictionary * b = [returnData objectForKey:@"b"];
        if (b!=nil) {
            NSDictionary * gz_air_qua_index = [b objectForKey:@"gz_wt_share"];
            NSString *sharecontent=[gz_air_qua_index objectForKey:@"share_content"];
            self.sharecontent=sharecontent;
            UIImage *moreImage=[self makeImageMore];
            self.shareimg=moreImage;
            NSString *shareImagePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"weiboShare.png"];
            [UIImagePNGRepresentation(moreImage) writeToFile:shareImagePath atomically:YES];
            ShareSheet * sheet = [[ShareSheet alloc] initDefaultWithTitle:@"分享天气" withDelegate:self];
            [sheet show];
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
//            Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
//            
//            
//            if([messageClass canSendText])
//                
//            {
//                
//                MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
//                controller.body = shareContent;
//                controller.messageComposeDelegate = self;
//                
//                [self presentViewController:controller animated:YES completion:nil];
//                
//            }else
//            {
//                UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"不能发送，该设备不支持短信功能" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
//                [t_alertView show];
//                
//            }
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
@end
