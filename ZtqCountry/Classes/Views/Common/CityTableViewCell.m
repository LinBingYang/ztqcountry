//
//  CityTableViewCell.m
//  ZtqCountry
//
//  Created by 林炳阳	 on 14-6-25.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "CityTableViewCell.h"

@implementation CityTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *m_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"城市天气底座.png"]];
        m_image.userInteractionEnabled=YES;
        if (self.isclick==NO) {
            [m_image setFrame:CGRectMake(5, 3, 255, 45)];
        }else
            [m_image setFrame:CGRectMake(5, 3, kScreenWidth-5, 45)];
        
        [self.contentView addSubview:m_image];
        self.titleImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 17, 20, 19)];
        [self.contentView addSubview:self.titleImg];
        self.city_labe=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 80, 50)];
        self.city_labe.textColor=[UIColor whiteColor];
        self.city_labe.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.city_labe];
        self.ico=[[UIImageView alloc]initWithFrame:CGRectMake(110, 5, 30, 30)];
        [self.contentView addSubview:self.ico];
        self.sstq=[[UILabel alloc]initWithFrame:CGRectMake(180, 0, 100, 50)];
        self.sstq.textColor=[UIColor whiteColor];
        self.sstq.backgroundColor=[UIColor clearColor];
        self.sstq.font= [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.sstq];
        
        
        self.city=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 50)];
        self.city.textColor=[UIColor blackColor];
        self.city.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.city];
        self.icoImg=[[UIImageView alloc]initWithFrame:CGRectMake(180, 0, 20, 20)];
        [self.contentView addSubview:self.icoImg];
        self.hlwd=[[UILabel alloc]initWithFrame:CGRectMake(210, 0, 100, 50)];
        self.hlwd.textColor=[UIColor blackColor];
        self.hlwd.backgroundColor=[UIColor clearColor];
        self.hlwd.font= [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.hlwd];
    }
    return self;
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

@end
