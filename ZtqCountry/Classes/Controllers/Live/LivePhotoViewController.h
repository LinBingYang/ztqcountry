//
//  LivePhotoViewController.h
//  ZtqCountry
//
//  Created by linxg on 14-8-7.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "BaseViewController.h"
#import "ImageWaterView.h"
#import "SVPullToRefresh.h"
#import "WebViewController.h"
#import "NewsViewController.h"
#import "CustomSheet.h"
#import "BannerSCRView.h"
@interface LivePhotoViewController : BaseViewController<ImageWaterViewDelegate,NSURLConnectionDelegate,ACSheetDelegate,ValueClickDelegate>{
    BOOL _reloading;
    TreeNode *m_allArea;
    NSMutableArray *m_areaData;
}
@property (nonatomic,strong)ImageWaterView *waterView;
@property(strong,nonatomic)CustomSheet *acsheetview;
@property(nonatomic,strong)NSMutableArray *marr,*xialaarr;
@property(assign)int page;
@property(strong,nonatomic)NSString *userid;
@property(strong,nonatomic)NSString *signle;//判断返回
@property(strong,nonatomic)NSString *parentid;//市级id
@property(strong,nonatomic)NSMutableArray *alldatas;//所有首页数据
@property(strong,nonatomic)ImageInfo *img;
@property(strong,nonatomic)NSArray *baners;
@property(strong,nonatomic)BannerSCRView *bmadscro;//广告
@property(strong,nonatomic)NSMutableArray *banersurl,*banerstitls,*banseimgurls,*bannershares;//美图数据
@end
