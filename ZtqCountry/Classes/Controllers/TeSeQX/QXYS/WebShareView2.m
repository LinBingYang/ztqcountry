//
//  WebShareView2.m
//  ztqFj
//
//  Created by 胡彭飞 on 2017/1/19.
//  Copyright © 2017年 yyf. All rights reserved.
//

#import "WebShareView2.h"
#import "weiboVC.h"
@implementation WebShareView2

-(void)ShareSheetClickWithIndexPath:(NSInteger)indexPath
{
    NSString *shareContent = self.shareStr1;
    switch (indexPath)
    {
        case 2: {
            weiboVC *t_weibo = [[weiboVC alloc] initWithNibName:@"weiboVC" bundle:nil];
            [t_weibo setShareText:[NSString stringWithFormat:@"%@%@",shareContent,self.shareUrl]];
            [t_weibo setShareImage:@"weiboShare.png"];
            [t_weibo setShareType:1];
            t_weibo.isCallBack=self.isCallBack;
            [self.mydelegate presentViewController:t_weibo animated:YES completion:nil];
            //			[t_weibo release];
            break;
        }
            
        case 0:{
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
            url=self.shareUrl;
            if (url.length<=0) {
                url=@"http://www.fjqxfw.com:8099/gz_wap/";
            }
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            UMShareWebpageObject *shareweb=[[UMShareWebpageObject alloc]init];
            shareweb.webpageUrl=url;
            shareweb.title=[NSString stringWithFormat:@"【知天气分享】%@",[super subtitle]];
            shareweb.thumbImage=self.shareImg1;
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
            
            break;
        }
        case 1: {
            NSString *url;
            url=self.shareUrl;
            if (url.length<=0) {
                url=@"http://www.fjqxfw.com:8099/gz_wap/";
            }
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            UMShareWebpageObject *shareweb=[[UMShareWebpageObject alloc]init];
            shareweb.webpageUrl=url;
            shareweb.title=[NSString stringWithFormat:@"【知天气分享】%@",[super subtitle]];
            shareweb.thumbImage=self.shareImg1;
            shareweb.descr=self.shareStr1;
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareweb;
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
            break;
        }
            
        case 3: {
            NSString *url;
            url=self.shareUrl;
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
            shareweb.title=[NSString stringWithFormat:@"【知天气分享】%@",[super subtitle]];
            shareweb.thumbImage=self.shareImg1;
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
            
            break;
        }
            
            
    }
}


@end
