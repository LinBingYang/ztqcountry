//
//  WebShareView2.h
//  ztqFj
//
//  Created by 胡彭飞 on 2017/1/19.
//  Copyright © 2017年 yyf. All rights reserved.
//

#import "WebShareView.h"
/**
 WebShareView2  可以自定义分享的内容,分享url链接方式
 shareStr1 : 分享的文字部分
 shareImg1 : 分享的图片
 shareUrl  : 分享的url
 */
@interface WebShareView2 : WebShareView
//判断是否回调  YES为是  NO为不是 默认为NO
@property(nonatomic,assign) BOOL isCallBack;
@property(nonatomic,copy) NSString *shareStr1;
@property(nonatomic,copy) UIImage  *shareImg1;
@property(nonatomic,copy) NSString *shareUrl;
-(void)ShareSheetClickWithIndexPath:(NSInteger)indexPath;
@end
