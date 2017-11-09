//
//  PerosonShareCell.m
//  ZtqCountry
//
//  Created by linxg on 14-8-13.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "PerosonShareCell.h"

@implementation PerosonShareCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}
//高度90
-(void)createView
{
    UIImageView * lineUp = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 3, 40)];
    lineUp.image = [UIImage imageNamed:@"发表时间隔条.png"];
    [self.contentView addSubview:lineUp];
    
    _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 40,20 )];
    _timeLab.backgroundColor = [UIColor clearColor];
    _timeLab.textColor = [UIColor blueColor];
    _timeLab.textAlignment = NSTextAlignmentCenter;
    _timeLab.font = [UIFont fontWithName:kBaseFont size:10];
    [self.contentView addSubview:_timeLab];
    
    UIImageView * lineDown = [[UIImageView alloc] initWithFrame:CGRectMake(20, 60, 3, 30)];
    lineDown.image = [UIImage imageNamed:@"发表时间隔条.png"];
    [self.contentView addSubview:lineDown];
    
    _shareImgV = [[UIImageView alloc] initWithFrame:CGRectMake(40, 20, 90, 60)];
    CALayer * maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0, 0, 80, 60);
    maskLayer.contents = (__bridge id)([self createMaskImage]);
    [_shareImgV.layer setMask:maskLayer];
    [self.contentView addSubview:_shareImgV];
    
    _shareContentLab = [[UILabel alloc] initWithFrame:CGRectMake(140, 20, 120, 20)];
    _shareContentLab.backgroundColor = [UIColor clearColor];
    _shareContentLab.textColor = [UIColor blackColor];
    _shareContentLab.textAlignment = NSTextAlignmentLeft;
    _shareContentLab.font = [UIFont fontWithName:kBaseFont size:15];
    [self.contentView addSubview:_shareContentLab];
    
    _weatherLab = [[UILabel alloc] initWithFrame:CGRectMake(140, 45, 120, 15)];
    _weatherLab.adjustsFontSizeToFitWidth = YES;
    _weatherLab.backgroundColor = [UIColor clearColor];
    _weatherLab.textColor = [UIColor grayColor];
    _weatherLab.textAlignment = NSTextAlignmentLeft;
    _weatherLab.font = [UIFont fontWithName:kBaseFont size:13];
    [self.contentView addSubview:_weatherLab];
    
    UIImageView * addressIcon = [[UIImageView alloc] initWithFrame:CGRectMake(140, 65, 15, 15)];
    addressIcon.image = [UIImage imageNamed:@"csss2ngs_33.png"];
    [self.contentView addSubview:addressIcon];
    
    _addressLab = [[UILabel alloc] initWithFrame:CGRectMake(157, 65, 100, 15)];
    _addressLab.backgroundColor = [UIColor clearColor];
    _addressLab.textColor = [UIColor grayColor];
    _addressLab.textAlignment = NSTextAlignmentLeft;
    _addressLab.font = [UIFont fontWithName:kBaseFont size:13];
    [self.contentView addSubview:_addressLab];
    
    UIImageView * zanIcon = [[UIImageView alloc] initWithFrame:CGRectMake(265, 20, 13, 13)];
    zanIcon.image = [UIImage imageNamed:@"点赞.png"];
    [self.contentView addSubview:zanIcon];
    
    _zanNumLab = [[UILabel alloc] initWithFrame:CGRectMake(285, 20, 25, 13)];
    _zanNumLab.adjustsFontSizeToFitWidth = YES;
    _zanNumLab.backgroundColor = [UIColor clearColor];
    _zanNumLab.textColor = [UIColor grayColor];
    _zanNumLab.textAlignment = NSTextAlignmentLeft;
    _zanNumLab.font = [UIFont fontWithName:kBaseFont size:13];
    [self.contentView addSubview:_zanNumLab];
    
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(140, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame)-140, 1)];
    [self.contentView addSubview:line];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(CGImageRef)createMaskImage
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(90, 60), NO, 0);
    UIBezierPath * path = [UIBezierPath bezierPath];
    [[UIColor blueColor] setFill];
    CGPoint point1 = CGPointMake(10, 0);
    CGPoint point2 = CGPointMake(90, 0);
    CGPoint point3 = CGPointMake(90, 60);
    CGPoint point4 = CGPointMake(10, 60);
    CGPoint point5 = CGPointMake(10, 35);
    CGPoint point6 = CGPointMake(0, 30);
    CGPoint point7 = CGPointMake(10, 25);
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path addLineToPoint:point4];
    [path addLineToPoint:point5];
    [path addLineToPoint:point6];
    [path addLineToPoint:point7];
    [path addLineToPoint:point1];
    [path fill];
    UIImage * im = UIGraphicsGetImageFromCurrentImageContext();
    
    return im.CGImage;
}

@end
