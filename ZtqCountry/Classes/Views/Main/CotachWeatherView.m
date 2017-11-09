//
//  CotachWeatherView.m
//  ZtqCountry
//
//  Created by Admin on 16/10/20.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "CotachWeatherView.h"

@implementation CotachWeatherView
- (id)initWithFrame:(CGRect)frame WithInfos:(NSArray *)lists
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.lists=lists;
        self.titlearrs=[[NSMutableArray alloc]init];
        self.timearrs=[[NSMutableArray alloc]init];
        self.icoarrs=[[NSMutableArray alloc]init];
        UIImageView * bgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 220)];
        bgImgV.backgroundColor = [UIColor clearColor];
        bgImgV.userInteractionEnabled = YES;
        [self addSubview:bgImgV];
        UIImageView *bgimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 2, kScreenWidth, 40)];
        bgimg.image=[UIImage imageNamed:@"首页背景条"];
        bgimg.userInteractionEnabled=YES;
        [bgImgV addSubview:bgimg];
        
        UILabel *loclab=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 30)];
        loclab.text=@"漫聊天气";
        loclab.textColor=[UIColor whiteColor];
        loclab.font=[UIFont systemFontOfSize:15];
        [bgimg addSubview:loclab];
        
        UIButton *tqzxbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-147, 7.5, 70, 25)];
        [tqzxbtn setTitle:@"天气资讯" forState:UIControlStateNormal];
        tqzxbtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [tqzxbtn setTitleColor:[UIColor colorHelpWithRed:172 green:172 blue:172 alpha:1] forState:UIControlStateHighlighted];
        [tqzxbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮.png"] forState:UIControlStateNormal];
        [tqzxbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮点击.png"] forState:UIControlStateHighlighted];
        [tqzxbtn addTarget:self action:@selector(tqzxAction) forControlEvents:UIControlEventTouchUpInside];
        [bgimg addSubview:tqzxbtn];
        
        UIButton *birthbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-75, 7.5, 70, 25)];
        [birthbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮.png"] forState:UIControlStateNormal];
        [birthbtn setBackgroundImage:[UIImage imageNamed:@"小标题按钮点击.png"] forState:UIControlStateHighlighted];
        [birthbtn setTitle:@"专家解读" forState:UIControlStateNormal];
        [birthbtn setTitleColor:[UIColor colorHelpWithRed:172 green:172 blue:172 alpha:1] forState:UIControlStateHighlighted];
        birthbtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [birthbtn addTarget:self action:@selector(zjjdAction) forControlEvents:UIControlEventTouchUpInside];
        [bgimg addSubview:birthbtn];
        
        
        
    }
    return self;
}
-(void)getinfoslist:(NSMutableArray *)lists Withtqname:(NSString *)tqname Withzjname:(NSString *)zjname withcount:(int)count{
    self.lists=(NSArray *)lists;
    if (self.bgimg) {
        [self.bgimg removeFromSuperview];
        self.bgimg=nil;
    }
    UIImageView * listview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, self.lists.count*70)];
    listview.backgroundColor = [UIColor clearColor];
    listview.userInteractionEnabled = YES;
    self.bgimg=listview;
    [self addSubview:listview];
    [self creatlistviewWithbgview:self.bgimg Withtqname:tqname Withzjname:zjname withlistcount:count];
}
-(void)creatlistviewWithbgview:(id)bgview Withtqname:(NSString *)tqname Withzjname:(NSString *)zjname withlistcount:(int)count{
    float theight=70;
//    self.lists=[[NSArray alloc]initWithObjects:@"",@"",@"", nil];
    for (int i=0; i<self.lists.count; i++) {
        EGOImageView *icon=[[EGOImageView alloc]initWithFrame:CGRectMake(10, theight*i+5, 80, theight-10)];
        icon.placeholderImage=[UIImage imageNamed:@"影视背景.jpg"];
        NSString *url=[self.lists[i] objectForKey:@"small_img"];
        [icon setImageURL:[ShareFun makeImageUrl:url]];
        [bgview addSubview:icon];
        [self.icoarrs addObject:icon];
        
        UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(95, 0+theight*i, kScreenWidth-95, 35)];
        titleLab.backgroundColor = [UIColor clearColor];
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.textColor = [UIColor whiteColor];
        titleLab.font = [UIFont systemFontOfSize:15];
        titleLab.numberOfLines=0;
        [bgview addSubview:titleLab];
    
        UILabel * introductionLab = [[UILabel alloc] initWithFrame:CGRectMake(95, 45+theight*i, 60, 15)];
        introductionLab.backgroundColor = [UIColor clearColor];
        introductionLab.textAlignment = NSTextAlignmentRight;
        introductionLab.textColor = [UIColor colorHelpWithRed:214 green:214 blue:214 alpha:1];
        introductionLab.font = [UIFont systemFontOfSize:13];
        [bgview addSubview:introductionLab];
   
        UILabel * introductionLab1 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-170, 45+theight*i, 160, 15)];
        introductionLab1.backgroundColor = [UIColor clearColor];
        introductionLab1.textAlignment = NSTextAlignmentRight;
        introductionLab1.textColor = [UIColor colorHelpWithRed:214 green:214 blue:214 alpha:1];
        introductionLab1.font = [UIFont systemFontOfSize:13];
        [bgview addSubview:introductionLab1];
        NSString *tstr=[self.lists[i] objectForKey:@"title"];
//        if (tstr.length>14) {
//            titleLab.text=[tstr substringToIndex:14];
//        }else{
            titleLab.text=[self.lists[i] objectForKey:@"title"];
//        }
        NSString *timestr=[self.lists[i] objectForKey:@"release_time"];
        if (i<count) {
            introductionLab.text=tqname;
        }else{
            introductionLab.text=zjname;
        }
        introductionLab1.text=timestr;
        
        UIImageView * lineimg = [[UIImageView alloc] initWithFrame:CGRectMake(5, theight*i+theight-1, kScreenWidth-10, 0.7)];
        lineimg.backgroundColor = [UIColor colorHelpWithRed:172 green:172 blue:172 alpha:1];
        lineimg.alpha=0.3;
        [bgview addSubview:lineimg];
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, theight*i, kScreenWidth, theight)];
        btn.tag=i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgview addSubview:btn];
    }
}
-(void)btnAction:(UIButton *)sender{
    NSInteger p=sender.tag;
    NSString *wzid=[self.lists[p] objectForKey:@"id"];
    if ([self.delegate respondsToSelector:@selector(clickbtntagActionWithtag:withindex:)]) {
        [self.delegate clickbtntagActionWithtag:wzid withindex:p];
    }
}
-(void)tqzxAction{
    if ([self.delegate respondsToSelector:@selector(tqzxaction)]) {
        [self.delegate tqzxaction];
    }
}
-(void)zjjdAction{
    if ([self.delegate respondsToSelector:@selector(zjjdaction)]) {
        [self.delegate zjjdaction];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
