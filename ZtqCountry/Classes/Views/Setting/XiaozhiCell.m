//
//  XiaozhiCell.m
//  ZtqCountry
//
//  Created by linxg on 14-8-29.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "XiaozhiCell.h"
#import "UILabel+utils.h"

@implementation XiaozhiCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createView];
    }
    return self;
}

-(void)createView
{
    UIView * blackBg = [[UIView alloc] initWithFrame:CGRectMake(4, 4, CGRectGetWidth(self.frame)-8, 120)];
    blackBg.backgroundColor = [UIColor grayColor];
    blackBg.alpha = 0.5;
    self.blackBg = blackBg;
    [self.contentView addSubview:blackBg];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(self.frame)-10, 120)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    _logoImgV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
    [_bgView addSubview:_logoImgV];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 100, 20)];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textColor = [UIColor blackColor];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.font = [UIFont fontWithName:kBaseFont size:15];
    [_bgView addSubview:_titleLab];
    
    
    UIButton * downloadBut = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_bgView.frame)-45, 30, 15, 15)];
    [downloadBut setBackgroundImage:[UIImage imageNamed:@"小知推荐_09.png"] forState:UIControlStateNormal];
    [downloadBut addTarget:self action:@selector(downLoadAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:downloadBut];
    
    _platformLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 150, 15)];
    _platformLab.numberOfLines = 0;
    _platformLab.backgroundColor = [UIColor clearColor];
    _platformLab.textColor = [UIColor blackColor];
    _platformLab.textAlignment = NSTextAlignmentLeft;
    _platformLab.font = [UIFont fontWithName:kBaseFont size:13];
    [_bgView addSubview:_platformLab];
    
    _line = [[UIView alloc] initWithFrame:CGRectMake(80, 47, 150, 1)];
    _line.backgroundColor = [UIColor grayColor];
    [_bgView addSubview:_line];
    
    _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, CGRectGetWidth(_bgView.frame)-85, 30)];
    _contentLab.numberOfLines = 0;
    _contentLab.backgroundColor = [UIColor clearColor];
    _contentLab.textColor = [UIColor grayColor];
    _contentLab.textAlignment = NSTextAlignmentLeft;
    _contentLab.font = [UIFont fontWithName:kBaseFont size:13];
    [_bgView addSubview:_contentLab];
}

- (void)awakeFromNib
{
    // Initialization code
}

-(void)downLoadAction:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(downloadWithIndexPath:)])
    {
        [self.delegate downloadWithIndexPath:self.indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setLogo:(UIImage *)logo withTitle:(NSString *)title withPlatform:(NSString *)platform withContent:(NSString *)content withIndexPath:(NSIndexPath *)indexPath withDelegate:(id)delegate
{
    _logoImgV.image = logo;
    _titleLab.text = title;
    _platformLab.text = platform;
    _contentLab.text = content;
    self.indexPath = indexPath;
    self.delegate = delegate;
    
    float platformHeight = [_platformLab labelheight:platform withFont:_platformLab.font];
    float contentHeight = [_contentLab labelheight:content withFont:_contentLab.font];
    _platformLab.frame = CGRectMake(80, 30, 150, platformHeight);
    
    _line.frame = CGRectMake(80, 30+platformHeight+2, 150, 1);
    
    _contentLab.frame = CGRectMake(80, 30+platformHeight+5, 310-85, contentHeight);
    _bgView.frame = CGRectMake(5, 5, 310,30+platformHeight+contentHeight+10);
    _blackBg.frame = CGRectMake(4, 4, 312,30+platformHeight+contentHeight+10+2);
}

@end
