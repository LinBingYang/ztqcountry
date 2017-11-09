//
//  YSDetailViewController.h
//  ztqFj
//
//  Created by Admin on 15-2-3.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "ShareSheet.h"
#import "BMAdScrollView.h"
@interface YSDetailViewController : UIViewController<ShareSheetDelegate,ValueClickDelegate>
@property(strong,nonatomic)NSString *imgurl,*des,*viedourl,*titlstr,*fxurl;
@property(strong,nonatomic)NSArray *viedoarr;
@property(strong,nonatomic)NSString *time;
@property(assign)float barhight;
@property (strong, nonatomic) UILabel * titlelab;
@property(strong,nonatomic)UIImage *shareimg;
@property(strong,nonatomic)NSString *sharecontent;//分享内容

@property(strong,nonatomic)BMAdScrollView *bmadscro;//广告
@property(strong,nonatomic)NSString *adurl,*adtitle,*adimgurl;
@property(strong,nonatomic)NSMutableArray *adtitles,*adimgurls,*adurls;

@end
