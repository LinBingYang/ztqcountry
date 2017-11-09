//
//  LiveHeadNoTableViewCell.m
//  ZtqCountry
//
//  Created by linxg on 14-9-3.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "LiveHeadNoTableViewCell.h"
#import "EGOImageView.h"
@implementation LiveHeadNoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withImageInfo:(ImageInfo *)info withtype:(int)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        float width = info.width;
        float height = info.height;
        NSString *thumbURL = info.thumbURL;
        //        float newHeight = 240;
        float newHeight = height/width*CGRectGetWidth(self.frame);
        EGOImageView *ego=[[EGOImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), newHeight)];
        [ego setImageURL:[ShareFun makeImageUrl:thumbURL]];
        
        _photo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), newHeight)];
        _photo.image=ego.image;
        
        
        [self.contentView addSubview:_photo];
        
        
        
        
        //
        //
        //        UIImageView * addressLogo = [[UIImageView alloc] initWithFrame:CGRectMake(10, newHeight-25, 10, 15)];
        //        addressLogo.image = [UIImage imageNamed:@"grzx1地图.png"];
        //        [self.contentView addSubview:addressLogo];
        //
        //        _addressLab = [[UILabel alloc] initWithFrame:CGRectMake(22, newHeight-25, 200, 15)];
        //        _addressLab.backgroundColor = [UIColor clearColor];
        //        _addressLab.textColor = [UIColor whiteColor];
        //        _addressLab.textAlignment = NSTextAlignmentLeft;
        //        _addressLab.font = [UIFont fontWithName:kBaseFont size:10];
        //        _addressLab.text = info.address;
        //        [self.contentView addSubview:_addressLab];
        
        UIImageView * butBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, newHeight, kScreenWidth, 50)];
        butBg.image = [UIImage imageNamed:@"grzx1浏览回复线框.png"];
        butBg.userInteractionEnabled = YES;
        [self.contentView addSubview:butBg];
        
        //        @property (strong, nonatomic) UILabel * browseNumLab;
        //        @property (strong, nonatomic) UILabel * answerNumLab;
        //        @property (strong, nonatomic) UILabel * attentionLab;
        UIImageView *tximg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        tximg.image=[UIImage imageNamed:@"个人图标"];
        [butBg addSubview:tximg];
        
        UILabel *nicklab=[[UILabel alloc]initWithFrame:CGRectMake(40, 10, 150, 30)];
        nicklab.text=info.userName;
        nicklab.textColor=[UIColor grayColor];
        nicklab.font=[UIFont systemFontOfSize:14];
        [butBg addSubview:nicklab];
        UIButton *grbtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 180, 30)];
        grbtn.tag=11;
        [grbtn addTarget:self action:@selector(grzxAction) forControlEvents:UIControlEventTouchUpInside];
        [butBg addSubview:grbtn];
        
        UIImageView *browseimg=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-150, 10, 30, 30)];
        browseimg.image=[UIImage imageNamed:@"浏览图标"];
        [butBg addSubview:browseimg];
        UILabel *browselab=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-105, 10, 55, 30)];
        browselab.text=[NSString stringWithFormat:@"%d",info.commentNum];
        browselab.textColor=[UIColor grayColor];
        browselab.font=[UIFont systemFontOfSize:14];
        [butBg addSubview:browselab];
        if (type==1) {
            UIButton * zanBut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-80,10, 40, 30)];
            self.guanyuBut = zanBut;
            zanBut.tag=22;
            [zanBut setBackgroundImage:[UIImage imageNamed:@"点赞.png"] forState:UIControlStateNormal];
            [zanBut setBackgroundImage:[UIImage imageNamed:@"点赞 点击.png"] forState:UIControlStateHighlighted];
            [zanBut addTarget:self action:@selector(guanyuButAction:) forControlEvents:UIControlEventTouchUpInside];
            [butBg addSubview:zanBut];
        }else{
            UIImageView *xinimg=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-80,10, 40, 30)];
            xinimg.image=[UIImage imageNamed:@"喜欢.png"];
            [butBg addSubview:xinimg];
        }
        
        UILabel *zanlab=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-45, 10, 50, 30)];
        //        if ([info.click_type isEqualToString:@"0"]) {
        //            info.zanNum=info.zanNum+1;
        //        }
        zanlab.text=[NSString stringWithFormat:@"%d",info.zanNum];
        zanlab.textColor=[UIColor grayColor];
        zanlab.font=[UIFont systemFontOfSize:14];
        [butBg addSubview:zanlab];
        
        
        //        _browseNumLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5 , kScreenWidth/3.0, 20)];
        //        _browseNumLab.backgroundColor = [UIColor clearColor];
        //        _browseNumLab.textColor = [UIColor colorHelpWithRed:77 green:163 blue:230 alpha:1];
        //        _browseNumLab.textAlignment = NSTextAlignmentCenter;
        //        _browseNumLab.font = [UIFont fontWithName:kBaseFont size:13];
        //        _browseNumLab.text = [NSString stringWithFormat:@"%d",info.forwardNum];
        //        [butBg addSubview:_browseNumLab];
        //
        //        UILabel * browseTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 25 , kScreenWidth/3.0, 20)];
        //        browseTitleLab.text = @"浏览量";
        //        browseTitleLab.backgroundColor = [UIColor clearColor];
        //        browseTitleLab.textColor = [UIColor grayColor];
        //        browseTitleLab.textAlignment = NSTextAlignmentCenter;
        //        browseTitleLab.font = [UIFont fontWithName:kBaseFont size:15];
        //        [butBg addSubview:browseTitleLab];
        //
        //        UIImageView * line1 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/3.0-1, 0, 1, 50)];
        //        line1.image = [UIImage imageNamed:@"grzx1竖隔条.png"];
        //        [butBg addSubview:line1];
        //
        //        _answerNumLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/3.0, 5 , kScreenWidth/3.0, 20)];
        //        _answerNumLab.backgroundColor = [UIColor clearColor];
        //        _answerNumLab.textColor = [UIColor colorHelpWithRed:77 green:163 blue:230 alpha:1];
        //        _answerNumLab.textAlignment = NSTextAlignmentCenter;
        //        _answerNumLab.font = [UIFont fontWithName:kBaseFont size:13];
        //        _answerNumLab.text = [NSString stringWithFormat:@"%d",info.commentNum];
        //        [butBg addSubview:_answerNumLab];
        //
        //        UILabel * answerTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/3.0, 25 , kScreenWidth/3.0, 20)];
        //        answerTitleLab.text = @"回复";
        //        answerTitleLab.backgroundColor = [UIColor clearColor];
        //        answerTitleLab.textColor = [UIColor grayColor];
        //        answerTitleLab.textAlignment = NSTextAlignmentCenter;
        //        answerTitleLab.font = [UIFont fontWithName:kBaseFont size:15];
        //        [butBg addSubview:answerTitleLab];
        //
        //        UIImageView * line2 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/3.0*2-1, 0, 1, 50)];
        //        line2.image = [UIImage imageNamed:@"grzx1竖隔条.png"];
        //        [butBg addSubview:line2];
        //
        //        _attentionLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/3.0*2, 5 , kScreenWidth/3.0, 20)];
        //        _attentionLab.backgroundColor = [UIColor clearColor];
        //        _attentionLab.textColor = [UIColor colorHelpWithRed:77 green:163 blue:230 alpha:1];
        //        _attentionLab.textAlignment = NSTextAlignmentCenter;
        //        _attentionLab.font = [UIFont fontWithName:kBaseFont size:13];
        //        _attentionLab.text = [NSString stringWithFormat:@"%d",info.zanNum];
        //        [butBg addSubview:_attentionLab];
        //
        //        UILabel * attentionTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/3.0*2, 25 , kScreenWidth/3.0, 20)];
        //        attentionTitleLab.text = @"关注";
        //        attentionTitleLab.backgroundColor = [UIColor clearColor];
        //        attentionTitleLab.textColor = [UIColor grayColor];
        //        attentionTitleLab.textAlignment = NSTextAlignmentCenter;
        //        attentionTitleLab.font = [UIFont fontWithName:kBaseFont size:15];
        //        [butBg addSubview:attentionTitleLab];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void)guanyuButAction:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(zanActionWithTag)])
    {
        [self.delegate zanActionWithTag];
    }
}
-(void)grzxAction{
    if([self.delegate respondsToSelector:@selector(grzxAction)])
    {
        [self.delegate grzxAction];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
