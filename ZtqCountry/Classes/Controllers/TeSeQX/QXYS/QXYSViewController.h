//
//  QXYSViewController.h
//  ZtqCountry
//
//  Created by Admin on 14-8-13.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "BMAdScrollView.h"
#import "YSZBBanerScrollview.h"
@interface QXYSViewController : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,yszbClickDelegate>{
    BOOL _reloading;
}
@property (strong, nonatomic) UIScrollView * bgScrollView;
@property(assign)float nowhight;
@property(strong,nonatomic)NSArray *viedoarrname,*viedoico;
@property(strong,nonatomic)NSMutableArray *viedoarr;
@property(strong,nonatomic)UIImage *viedoimg;
@property(strong,nonatomic)EGOImageView * bgImgV;

@property(strong,nonatomic)UITableView *m_tableview;
@property(strong,nonatomic)NSMutableArray *adtitles,*adimgurls,*adurls,*adfx_contents;
@property(strong,nonatomic)YSZBBanerScrollview *bmadscro;//广告
@property(assign)BOOL isad;
@end
