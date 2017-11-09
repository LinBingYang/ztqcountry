//
//  ZXTableViewCell.m
//  ZtqCountry
//
//  Created by 派克斯科技 on 16/10/26.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "ZXTableViewCell.h"
#import "EGOImageView.h"
#import "ZXModel.h"
@implementation ZXTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       EGOImageView  *thumbnailV = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 9, 80, 58)];
        self.thumbnailImage = thumbnailV;
        self.thumbnailImage.placeholderImage=[UIImage imageNamed:@"影视背景.jpg"];
        [self.contentView addSubview:self.thumbnailImage];
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, kScreenWidth - 100, 40)];
        titleLab.font = [UIFont systemFontOfSize:16];
        self.titleLabel = titleLab;
        titleLab.numberOfLines = 0;
        titleLab.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.titleLabel];
        
        UILabel *subtitle = [[UILabel alloc]initWithFrame:CGRectMake(100, 48, kScreenWidth -110, 20)];
        
        subtitle.numberOfLines = 0;
        subtitle.textColor = [UIColor blackColor];
        subtitle.font = [UIFont fontWithName:@"Helvetica" size:13];
        subtitle.textAlignment = NSTextAlignmentRight;
        self.subtitileLabel = subtitle;
        [self.contentView addSubview:self.subtitileLabel];
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(2, 69, kScreenWidth-2, 1)];
        img.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
        [self.contentView addSubview:img];
        
    }
    return self;
}


- (void)updataWithModel:(ZXModel *)model {
    NSURL *url = [ShareFun makeImageUrl:model.small_img];
    [self.thumbnailImage setImageURL:url];
    self.titleLabel.text = model.title;
    self.subtitileLabel.text = model.release_time;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
