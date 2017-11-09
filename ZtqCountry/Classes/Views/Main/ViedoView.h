//
//  ViedoView.h
//  ZtqCountry
//
//  Created by Admin on 15/7/14.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "BMAdScrollView.h"
@protocol viedoDelegate<NSObject>

-(void)YingShiAction;

@end
@interface ViedoView : UIView<ValueClickDelegate>
@property(strong,nonatomic)EGOImageView *Viedoimg;
@property(strong,nonatomic)BMAdScrollView *bmadscro;
@property(nonatomic, weak) id<viedoDelegate>delegate;
@property(strong,nonatomic)NSMutableArray *adtitles,*adimgurls,*adurls;
-(void)updateYSInfo:(NSString *)ysurl;
-(void)upYSdatas:(NSArray *)datas;
@end
