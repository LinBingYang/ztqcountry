//
//  ZanTableViewCell.m
//  ZtqCountry
//
//  Created by linxg on 14-8-31.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "ZanTableViewCell.h"

@implementation ZanTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self creatView];
    }
    return self;
}

-(void)creatView
{
    UIImageView * cornerBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    cornerBg.image = [UIImage imageNamed:@"dz背景外圆.png"];
    [self.contentView addSubview:cornerBg];
    
    _personImgV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
    _personImgV.layer.masksToBounds = YES;
    _personImgV.layer.cornerRadius = 25;
    [cornerBg addSubview:_personImgV];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 100, 20)];
    _nameLab.textAlignment = NSTextAlignmentLeft;
    _nameLab.backgroundColor = [UIColor clearColor];
    _nameLab.textColor = [UIColor colorHelpWithRed:132 green:132 blue:132 alpha:1];
    _nameLab.font = [UIFont fontWithName:kBaseFont size:15];
    [self.contentView addSubview:_nameLab];
    
    _attentionBut = [[UIButton alloc] initWithFrame:CGRectMake(255, 25, 60, 30)];
    [_attentionBut setTitle:@"关注" forState:UIControlStateNormal];
    [_attentionBut setTitle:@"取消" forState:UIControlStateSelected];
    [_attentionBut setBackgroundImage:[UIImage imageNamed:@"dz关注图标.png"] forState:UIControlStateNormal];
    [_attentionBut setBackgroundImage:[UIImage imageNamed:@"dz取消图标.png"] forState:UIControlStateSelected];
    [_attentionBut setBackgroundImage:[UIImage imageNamed:@"dz关注图标.png"] forState:UIControlStateHighlighted];
    _attentionBut.titleLabel.font = [UIFont fontWithName:kBaseFont size:15];
    [_attentionBut addTarget:self action:@selector(attentionButAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_attentionBut];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)attentionButAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if([self.delegate respondsToSelector:@selector(zanTableViewCellAttentionClickWithIndexPath:withState:)])
    {
        [self.delegate zanTableViewCellAttentionClickWithIndexPath:self.indexPath withState:sender.selected];
    }
}



@end
