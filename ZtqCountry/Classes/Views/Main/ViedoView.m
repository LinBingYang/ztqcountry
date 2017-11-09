//
//  ViedoView.m
//  ZtqCountry
//
//  Created by Admin on 15/7/14.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "ViedoView.h"

@implementation ViedoView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[UIColor clearColor];
        self.adimgurls=[[NSMutableArray alloc]init];
        self.adtitles=[[NSMutableArray alloc]init];
        self.adurls=[[NSMutableArray alloc]init];
        
//        EGOImageView *egoview=[[EGOImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
//        egoview.userInteractionEnabled=YES;
//        self.Viedoimg=egoview;
//        [self.Viedoimg setPlaceholderImage:[UIImage imageNamed:@"15.jpg"]];
//        [self addSubview:egoview];
//        UIButton *mapbut1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
//        [mapbut1 addTarget:self action:@selector(YSAction) forControlEvents:UIControlEventTouchUpInside];
//        [egoview addSubview:mapbut1];
//        UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(0,190+9, kScreenWidth, 1)];
//        line1.image=[UIImage imageNamed:@"分割线.png"];
////        [self addSubview:line1];
       
    }
    return self;
}
-(void)upYSdatas:(NSArray *)datas{
    [self.adimgurls removeAllObjects];
    [self.adtitles removeAllObjects];
    [self.adurls removeAllObjects];
    for (int i=0; i<datas.count; i++) {
        NSString *url=[datas[i] objectForKey:@"url"];
        NSString *title=[datas[i] objectForKey:@"title"];
        NSString *imgurl=[datas[i] objectForKey:@"img_path"];
        [self.adurls addObject:url];
        [self.adtitles addObject:title];
        [self.adimgurls addObject:imgurl];
    }
    
    [self.bmadscro removeFromSuperview];
    self.bmadscro=nil;
    if (self.bmadscro==nil) {
      
            self.bmadscro = [[BMAdScrollView alloc] initWithNameArr:self.adimgurls  titleArr:self.adtitles height:180 offsetY:0 offsetx:10];

        self.bmadscro.vDelegate = self;
        self.bmadscro.pageCenter = CGPointMake(280, 300);
        [self addSubview:self.bmadscro];
    }
}
-(void)buttonClick:(int)vid{
    if ([self.delegate respondsToSelector:@selector(YingShiAction)]) {
        [self.delegate YingShiAction];
    }
}
-(void)YSAction{
    if ([self.delegate respondsToSelector:@selector(YingShiAction)]) {
        [self.delegate YingShiAction];
    }
}
-(void)updateYSInfo:(NSString *)ysurl{
    if (ysurl.length>0) {
        [self.Viedoimg setImageURL:[ShareFun makeImageUrl:ysurl]];
    }
}
@end
