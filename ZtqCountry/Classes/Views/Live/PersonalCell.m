//
//  PersonalCell.m
//  ZtqCountry
//
//  Created by linxg on 14-8-8.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "PersonalCell.h"

@implementation PersonalCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)creatView
{
    _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 70, 15)];
    _timeLab.textAlignment = NSTextAlignmentLeft;
    _timeLab.font = [UIFont fontWithName:kBaseFont size:13];
    _timeLab.backgroundColor = [UIColor clearColor];
    _timeLab.textColor = [UIColor blackColor];
    [self addSubview:_timeLab];
    
    _weekLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 70, 15)];
    _weekLab.textAlignment = NSTextAlignmentLeft;
    _weekLab.font = [UIFont fontWithName:kBaseFont size:13];
    _weekLab.backgroundColor = [UIColor clearColor];
    _weekLab.textColor = [UIColor grayColor];
    [self addSubview:_weekLab];
}


-(id)initWithTime:(NSString *)time withWeek:(NSString *)week withCellInfos:(NSMutableArray *)infos withOriginY:(float)Y
{
    int num = infos.count;
    float width = 60;
    _height = 20+(num/3+(num%3==0?0:1))*65;
    self = [super initWithFrame:CGRectMake(0, Y, kScreenWidth, _height)];
    if(self)
    {
        self.backgroundColor = [UIColor yellowColor];
        [self creatView];
        _timeLab.text = time;
        _weekLab.text = week;
        for(int i=0;i<num;i++)
        {
            int line = i/3;
            int column = i%3;
            
            NSDictionary * info = [infos objectAtIndex:i];
            NSString * imageName = [info objectForKey:@"image"];
            UIImageView * cellImgV = [[UIImageView alloc] initWithFrame:CGRectMake(80+column*(width+5), 10+line*(width+5), width, width)];
            cellImgV.image = [UIImage imageNamed:imageName];
            cellImgV.layer.cornerRadius = 5;
            cellImgV.layer.masksToBounds = YES;
            //            cellImgV.backgroundColor = [UIColor blackColor];
            [self addSubview:cellImgV];
        }
    }
    return self;
}
//-(void)

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
