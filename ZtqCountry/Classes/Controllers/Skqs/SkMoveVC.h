//
//  SkMoveVC.h
//  ZtqCountry
//
//  Created by Admin on 15/6/19.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMAdScrollView.h"
#import "SKMoveView.h"
@interface SkMoveVC : UIViewController<ValueClickDelegate>
@property(assign)float barHeight;
@property(retain,nonatomic)UIImageView *navigationBarBg;
@property(strong,nonatomic)UIScrollView *bgscr;
@property(strong,nonatomic)UIImageView *bgimg,*selectimg;
@property(strong,nonatomic)UIButton *wdbtn,*sdbtn,*njdbtn,*rainbtn;
@property(strong,nonatomic)NSString *typetag;//一周还是24
@property(strong,nonatomic)BMAdScrollView *bmadscro;//广告
@property(strong,nonatomic)NSString *adurl,*adtitle,*adimgurl,*iconame,*titlename;
@property(strong,nonatomic)NSMutableArray *adtitles,*adimgurls,*adurls;
@property(strong,nonatomic)NSMutableArray *wdarr,*humarr,*visarr,*timearr,*rainarr;
@property(strong,nonatomic)SKMoveView *skmview;
@property(strong,nonatomic)NSString *nowct,*nowhum,*nowvisil,*nowrain;//现在的温度湿度能见度
@property(strong,nonatomic)NSString *type;

@end
