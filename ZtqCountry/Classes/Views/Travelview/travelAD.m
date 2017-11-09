//
//  travelAD.m
//  ZtqCountry
//
//  Created by Admin on 14-8-26.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "travelAD.h"

@implementation travelAD

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor=[UIColor whiteColor];
        UIScrollView *m_scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
        m_scroll.contentSize=CGSizeMake(kScreenWidth, kScreenHeitht);
        [self addSubview:m_scroll];
        UIImageView *adimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 190)];
        adimg.image=[UIImage imageNamed:@"广告.jpg"];
        [m_scroll addSubview:adimg];
        UIImageView *barimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 160, kScreenWidth, 30)];
        barimg.image=[UIImage imageNamed:@"透明.png"];
        [adimg addSubview:barimg];
        UILabel *t_label=[[UILabel alloc]initWithFrame:CGRectMake(130, 5, 100, 20)];
        t_label.text=@"线路推荐";
        t_label.textColor=[UIColor whiteColor];
        t_label.backgroundColor=[UIColor clearColor];
        t_label.font=[UIFont systemFontOfSize:14];
        [barimg addSubview:t_label];
        
        UILabel *textview=[[UILabel alloc]initWithFrame:CGRectMake(5, 90, 315, 500)];
        textview.text=@"武夷山途家斯维登度假别墅1晚+50元加油卡6人自由行：\n\r推荐理由： 游碧水丹霞武夷山，全家6-8人住：武夷山途家斯维登度假别墅武夷水庄店3居别墅1晚，赠50元中石化加油卡1张！\n\r时间安排：2天1晚 \n\r市  场  价：¥5,938\n\r去哪儿价：¥ 1,198 起 (人均¥200起）\n\r有效日期：2014年08月22日-2014年12月31日";
        textview.numberOfLines=0;
        textview.backgroundColor=[UIColor clearColor];
        textview.font=[UIFont systemFontOfSize:14];
        [m_scroll addSubview:textview];
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
