//
//  PersonalShareImagesCell.m
//  ZtqCountry
//
//  Created by linxg on 14-9-4.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "PersonalShareImagesCell.h"
#import "UILabel+utils.h"
#import "EGOImageView.h"
@implementation PersonalShareImagesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withMonth:(NSString *)month withDay:(NSString *)day withComment:(NSString *)comment withAddress:(NSString *)address withZanNum:(NSString *)zanNum withImages:(NSArray *)images
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.images = images;
        UIImageView * upLine = [[UIImageView alloc] initWithFrame:CGRectMake(23, 0, 2, 10)];
        upLine.image = [UIImage imageNamed:@"日期竖条gaibian.png"];
        [self.contentView addSubview:upLine];
        
        UIImageView * timeBg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 37, 39)];
        timeBg.image = [UIImage imageNamed:@"grzxsc日期圆圈.png"];
        [self.contentView addSubview:timeBg];
        
        UILabel * monthLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 20, 15)];
        monthLab.text = month;
        monthLab.backgroundColor = [UIColor clearColor];
        monthLab.textColor = [UIColor colorHelpWithRed:77 green:163 blue:230 alpha:1];
        monthLab.textAlignment = NSTextAlignmentRight;
        monthLab.font = [UIFont fontWithName:kBaseFont size:13];
        [timeBg addSubview:monthLab];
        
//        UILabel * signLab = [[UILabel alloc] initWithFrame:CGRectMake(18, 11, 5, 20)];
//        signLab.text = @"/";
//        signLab.backgroundColor = [UIColor clearColor];
//        signLab.textColor = [UIColor colorHelpWithRed:77 green:163 blue:230 alpha:1];
//        signLab.textAlignment = NSTextAlignmentCenter;
//        signLab.font = [UIFont fontWithName:kBaseFont size:13];
//        [timeBg addSubview:signLab];
//        
//        UILabel * dayLab = [[UILabel alloc] initWithFrame:CGRectMake(23, 15, 20, 15)];
//        dayLab.text = day;
//        dayLab.backgroundColor = [UIColor clearColor];
//        dayLab.textColor = [UIColor colorHelpWithRed:77 green:163 blue:230 alpha:1];
//        dayLab.textAlignment = NSTextAlignmentLeft;
//        dayLab.font = [UIFont fontWithName:kBaseFont size:13];
//        [timeBg addSubview:dayLab];
        
        UILabel * commentLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, kScreenWidth-130, 20)];
        commentLab.text = comment;
        commentLab.numberOfLines = 0;
        commentLab.backgroundColor = [UIColor clearColor];
        commentLab.textColor = [UIColor blackColor];
        commentLab.textAlignment = NSTextAlignmentLeft;
        commentLab.font = [UIFont fontWithName:kBaseFont size:15];
        [self.contentView addSubview:commentLab];
        float commentHeight = [commentLab labelheight:comment withFont:commentLab.font];
        commentLab.frame = CGRectMake(50, 10, kScreenWidth-100, commentHeight);
        
//        UIImageView * zanLogo = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-60, 10, 19, 17)];
//        zanLogo.image = [UIImage imageNamed:@"grzxsc点赞.png"];
//        [self.contentView addSubview:zanLogo];
        
        UIButton *zanbtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-60, 10, 19, 17)];
        [zanbtn setBackgroundImage:[UIImage imageNamed:@"grzxsc点赞.png"] forState:UIControlStateNormal];
        [zanbtn addTarget:self action:@selector(zanbtnAction) forControlEvents:UIControlEventTouchUpInside];
        zanbtn.tag=1001;
        [self.contentView addSubview:zanbtn];
        
        UILabel * zanNumLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-60+22, 10,30, 20)];
        zanNumLab.text = zanNum;
        zanNumLab.backgroundColor = [UIColor clearColor];
        zanNumLab.textColor = [UIColor grayColor];
        zanNumLab.textAlignment = NSTextAlignmentLeft;
        zanNumLab.font = [UIFont fontWithName:kBaseFont size:13];
        [self.contentView addSubview:zanNumLab];

        UIImageView * addressLogo = [[UIImageView alloc] initWithFrame:CGRectMake(50, 35, 10, 15)];
        addressLogo.image = [UIImage imageNamed:@"grzxsc地址.png"];
        [self.contentView addSubview:addressLogo];
        
        UILabel * addressLab = [[UILabel alloc] initWithFrame:CGRectMake(62, 35, kScreenWidth-62-30, 15)];
        addressLab.text = address;
        addressLab.backgroundColor = [UIColor clearColor];
        addressLab.textColor = [UIColor grayColor];
        addressLab.textAlignment = NSTextAlignmentLeft;
        addressLab.font = [UIFont fontWithName:kBaseFont size:13];
        [self.contentView addSubview:addressLab];

        for(int i=0;i<images.count;i++)
        {
            int line = i/3;//行
            int column = i%3;//列
            float space = 20;//图片间隔
            float imageWidth = ((kScreenWidth-50-30)-2*space)/3.0;
            //图片下载
            EGOImageView * shareImage = [[EGOImageView alloc] initWithFrame:CGRectMake(50+(imageWidth+space)*column, 55+line*(imageWidth+space), imageWidth, imageWidth)];
            NSString *imgurl=[ShareFun makeImageUrlStr:[images objectAtIndex:i]];
            NSURL *url=[NSURL URLWithString:imgurl];
            [shareImage setImageURL:url];
//            shareImage.image = [images objectAtIndex:i];
            [self.contentView addSubview:shareImage];
            
            UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(50+(imageWidth+space)*column, 55+line*(imageWidth+space), imageWidth, imageWidth)];
            button.tag = i;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
        }
        float hangshu = images.count/3;
        float zuihoulie = images.count%3;
        float zonghangshu = hangshu;
        if(zuihoulie !=0)
        {
            zonghangshu+=1;
        }
        float lineHeight = zonghangshu*(((kScreenWidth-50-30)-2*20)/3.0+20)+20;
        UIImageView *downLine = [[UIImageView alloc] initWithFrame:CGRectMake(23, 49, 2, lineHeight)];
        downLine.image = [UIImage imageNamed:@"日期竖条gaibian.png"];
        [self.contentView addSubview:downLine];
    }
    return self;
}

-(void)buttonAction:(UIButton *)sender
{
    int tag = sender.tag;
    UIImage * image = [self.images objectAtIndex:tag];
    if([self.delegate respondsToSelector:@selector(PersonalSahreImagesCellImageClickWithImage:)])
    {
        [self.delegate PersonalSahreImagesCellImageClickWithImage:image];
    }
    
}
-(void)zanbtnAction{
    if ([self.delegate respondsToSelector:@selector(zanActionWithIndexPath:)]) {
        [self.delegate zanActionWithIndexPath:self.row];
    }
}
@end
