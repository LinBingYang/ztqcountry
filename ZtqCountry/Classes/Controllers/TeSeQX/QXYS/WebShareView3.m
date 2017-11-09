//
//  WebShareView3.m
//  ztqFj
//
//  Created by 胡彭飞 on 2017/3/9.
//  Copyright © 2017年 yyf. All rights reserved.
//

#import "WebShareView3.h"
#import "weiboVC.h"
@implementation WebShareView3
-(void)ShareSheetClickWithIndexPath:(NSInteger)indexPath
{
    NSString *shareContent = self.shareStr1;
    switch (indexPath)
    {
        case 2: {
            weiboVC *t_weibo = [[weiboVC alloc] initWithNibName:@"weiboVC" bundle:nil];
            [t_weibo setShareText:shareContent];
            [t_weibo setShareImage:@"weiboShare.png"];
            [t_weibo setShareType:1];
             t_weibo.isCallBack=self.isCallBack;
            [self.mydelegate presentViewController:t_weibo animated:YES completion:nil];
            //			[t_weibo release];
            break;
        }
            
        case 0:{
            BOOL isShareInstall=[[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession];
            if (isShareInstall) {
                //                        //创建分享消息对象
                //                        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                //
                //                        //创建图片内容对象
                //                        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
                //                        //如果有缩略图，则设置缩略图
                //                        [shareObject setShareImage:self.shareimg];
                //
                //                        //分享消息对象设置分享内容对象
                //                        messageObject.shareObject = shareObject;
                NSString *url;
                if ([self.shareStr1 rangeOfString:@"http"].location!=NSNotFound) {
                    NSArray *arr=[self.shareStr1 componentsSeparatedByString:@"http"];
                    if (arr.count>0) {
                        url=[NSString stringWithFormat:@"http%@",arr[1]];
                    }
                }
                if (url.length<=0) {
                    url=@"http://www.fjqxfw.com:8099/gz_wap/";
                }
                //创建分享消息对象
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                UMShareWebpageObject *shareweb=[[UMShareWebpageObject alloc]init];
                shareweb.webpageUrl=url;
                shareweb.title=@"知天气分享";
                shareweb.thumbImage=self.shareimg;
                shareweb.descr=self.shareStr1;
                //分享消息对象设置分享内容对象
                messageObject.shareObject = shareweb;
                //调用分享接口
                [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                    if (error) {
                        NSLog(@"************Share fail with error %@*********",error);
                    }else{
                        NSLog(@"response data is %@",data);
                        if(self.isCallBack){
                            NSString *type=@"3";
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"sharesuccess" object:type];
                        }else{
                            NSString *type=@"10";
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"sharesuccess" object:type];
                        }
                    }
                }];
            }else{
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"知天气" message:@"此设备未安装微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            break;
        }
        case 1: {
            BOOL isShareInstall=[[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatTimeLine];
            if (isShareInstall) {
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
                        if(self.isCallBack){
                            NSString *type=@"3";
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"sharesuccess" object:type];
                        }else{
                            NSString *type=@"10";
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"sharesuccess" object:type];
                        }
                    }
                }];
            }else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"知天气" message:@"此设备未安装微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            break;
        }
            
        case 3: {
            BOOL isShareInstall=[[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Qzone];
            if (isShareInstall) {
                NSString *url;
                if ([self.shareStr1 rangeOfString:@"http"].location!=NSNotFound) {
                    NSArray *arr=[self.shareStr1 componentsSeparatedByString:@"http"];
                    if (arr.count>0) {
                        url=[NSString stringWithFormat:@"http%@",arr[1]];
                    }
                }
                if (url.length<=0) {
                   url=@"http://www.fjqxfw.com:8099/gz_wap/";
                }
                //创建分享消息对象
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                
                //创建图片内容对象
                //            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
                //            //如果有缩略图，则设置缩略图
                //            [shareObject setShareImage:self.shareimg];
                UMShareWebpageObject *shareweb=[[UMShareWebpageObject alloc]init];
                shareweb.webpageUrl=url;
                shareweb.title=@"知天气分享";
                shareweb.thumbImage=self.shareimg;
                shareweb.descr=self.shareStr1;
                //分享消息对象设置分享内容对象
                messageObject.shareObject = shareweb;
                
                //调用分享接口
                [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Qzone messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                    if (error) {
                        NSLog(@"************Share fail with error %@*********",error);
                    }else{
                        NSLog(@"response data is %@",data);
                        if (self.isCallBack) {
                            NSString *type=@"2";
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"sharesuccess" object:type];
                        }else{
                            NSString *type=@"10";
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"sharesuccess" object:type];
                        }
                        
                    }
                }];
            }else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"知天气" message:@"此设备未安装QQ空间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            break;
        }
            
            
    }
}


@end
