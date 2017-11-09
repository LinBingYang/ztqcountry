//
//  SelfImageVIew.m
//  hlrenTest
//
//  Created by blue on 13-4-23.
//  Copyright (c) 2013年 blue. All rights reserved.
//

#import "SelfImageVIew.h"
#import "EGOImageView.h"
@implementation SelfImageVIew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithImageInfo:(ImageInfo*)imageInfo y:(float)y  withA:(int)a withRowTag:(int)row
{
    
    float imageW = imageInfo.width;
    float imageH = imageInfo.height;
    //缩略图宽度和宽度
    float width = WIDTH - SPACE;
//    float height = width * imageH / imageW;
    

    float height =imageH;
        
    
    self = [super initWithFrame:CGRectMake(0, y, WIDTH, height + SPACE-5)];
//    self = [super initWithFrame:CGRectMake(0, y, WIDTH, height + SPACE+25)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView * blackBg = [[UIView alloc] initWithFrame:CGRectMake(0, SPACE/2, width, height+25)];
        blackBg.backgroundColor = [UIColor whiteColor];
//        blackBg.layer.cornerRadius = 3;
//        blackBg.alpha = 0.3;
        [self addSubview:blackBg];
        
        UIView * whiteBg = [[UIView alloc] initWithFrame:CGRectMake(0, SPACE/2, width, height+24)];
        whiteBg.backgroundColor = [UIColor whiteColor];
//        whiteBg.layer.cornerRadius = 3;
//        whiteBg.layer.masksToBounds = YES;
//        whiteBg.clipsToBounds = YES;
//        whiteBg.clipsToBounds = YES;
        [self addSubview:whiteBg];
        self.data = imageInfo;
        EGOImageView *imageView = [[EGOImageView alloc]initWithFrame:CGRectMake(0 , 0 , width, height)];
        imageView.placeholderImage=[UIImage imageNamed:@"影视背景.jpg"];
        if(row==1)
        {
//            imageView.frame = CGRectMake(SPACE / 3*2 , SPACE / 2 , width, height);
            blackBg.frame = CGRectMake(SPACE / 3*2, SPACE/2, width, height+25);
            whiteBg.frame = CGRectMake(SPACE / 3*2, SPACE/2, width, height +24);
        }
        else
        {
//            imageView.frame = CGRectMake(SPACE / 3 , SPACE / 2 , width, height);
             blackBg.frame = CGRectMake(SPACE / 3, SPACE/2, width, height+25);
             whiteBg.frame = CGRectMake(SPACE / 3, SPACE/2, width, height +24);
        }
       imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds=YES;
//        imageView.layer.cornerRadius = 2;
//        imageView.layer.masksToBounds = YES;
        //        NSURL *url = [NSURL URLWithString:imageInfo.thumbURL];
        //        [imageView setImageWithURL:url placeholderImage:nil];
        //        imageView.backgroundColor = [UIColor greenColor];
//        if([imageInfo.imageType isEqualToString:@"1"])
//        {
//            imageView.image = [UIImage imageNamed:imageInfo.thumbURL];
//        }
//        else if ([imageInfo.imageType isEqualToString:@"2"])
//        {
//            imageView.image = [UIImage imageWithData:imageInfo.imageData];
//        }
        
//        EGOImageView *ego=[[EGOImageView alloc]init];
//        [ego setImageURL:[ShareFun makeImageUrl:imageInfo.thumbURL]];
//        NSURL *url=[NSURL URLWithString:@"http://images.ikan365.cn/txt/20121016/20121016_144718519_1847.jpg"];
        [imageView setImageURL:[ShareFun makeImageUrl:imageInfo.thumbURL]];
//        UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0 , width, height)];
//        photo.image=imageView.image;
//        imageView.image=ego.image;
        
        
        [whiteBg addSubview:imageView];
        //如果想加别的信息在此可加
        
        UIImageView * grayimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, height - 20, width, 20)];
        grayimg.image = [UIImage imageNamed:@"小图文字底部透明.png"];
        [whiteBg addSubview:grayimg];
//        UIImageView * addressLogoImg = [[UIImageView alloc] initWithFrame:CGRectMake(55, height - 15, 7, 10)];
//        addressLogoImg.image = [UIImage imageNamed:@"位置.png"];
//        [whiteBg addSubview:addressLogoImg];
//        
//        UILabel *labe = [[UILabel alloc]initWithFrame:CGRectMake(65,height - 20, width-67, 20)];
//        labe.font = [UIFont fontWithName:kBaseFont size:10];
//        labe.backgroundColor = [UIColor clearColor];
//        labe.textColor = [UIColor whiteColor];
//        labe.text = imageInfo.address;
//        self.backgroundColor = [UIColor whiteColor];
//        [whiteBg addSubview:labe];
        
        UIImageView * zanImg = [[UIImageView alloc] initWithFrame:CGRectMake(width-45,10, 40, 15)];
        zanImg.image = [UIImage imageNamed:@"首页浏览量.png"];
        [whiteBg addSubview:zanImg];
        
        UILabel * zanLab = [[UILabel alloc] initWithFrame:CGRectMake(20,0, 15, 15)];
        zanLab.backgroundColor = [UIColor clearColor];
        zanLab.textColor = [UIColor whiteColor];
        zanLab.textAlignment=NSTextAlignmentCenter;
        zanLab.adjustsFontSizeToFitWidth = YES;
        zanLab.font = [UIFont fontWithName:kBaseFont size:10];
        zanLab.text = [NSString stringWithFormat:@"%d",imageInfo.commentNum];
        [zanImg addSubview:zanLab];
        
        UIView * commentsBg = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, 20)];
        commentsBg.backgroundColor = [UIColor clearColor];
        [whiteBg addSubview:commentsBg];
        
        UIImageView * userImgBg = [[UIImageView alloc] initWithFrame:CGRectMake(5, height-20, 40, 40)];
        userImgBg.backgroundColor = [UIColor whiteColor];
        userImgBg.layer.cornerRadius = 20;
        userImgBg.layer.masksToBounds = YES;
        userImgBg.layer.shadowColor = [UIColor blackColor].CGColor;
        userImgBg.layer.shadowOffset = CGSizeMake(2, 2);
        userImgBg.layer.shadowRadius = 5;
        userImgBg.layer.shadowOpacity = 0.11;
//        [whiteBg addSubview:userImgBg];
        
        UIImageView * userImg = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 36, 36)];
//        if([imageInfo.imageType isEqualToString:@"1"])
//        {
//            userImg.image = [UIImage imageNamed:imageInfo.userImg];
//        }
//        else
//        {
//            if([imageInfo.imageType isEqualToString:@"2"])
//            {
//                userImg.image = [UIImage imageWithData:imageInfo.userImageData];
//            }
//        }
        EGOImageView *egouser=[[EGOImageView alloc]init];
        
        [egouser setImageURL:[ShareFun makeImageUrl:imageInfo.userImg]];
        userImg.image=egouser.image;
        
        userImg.layer.cornerRadius = 18;
        userImg.layer.masksToBounds = YES;
        [userImgBg addSubview:userImg];
        
        UIImageView * addressLogoImg = [[UIImageView alloc] initWithFrame:CGRectMake(5,height-15, 7, 10)];
        addressLogoImg.image = [UIImage imageNamed:@"位置.png"];
//        [whiteBg addSubview:addressLogoImg];
        
        UILabel *labe = [[UILabel alloc]initWithFrame:CGRectMake(5,height-18, width-10, 20)];
        labe.font = [UIFont fontWithName:kBaseFont size:10];
        labe.numberOfLines=0;
        labe.textAlignment=NSTextAlignmentCenter;
        labe.backgroundColor = [UIColor clearColor];
        labe.textColor = [UIColor whiteColor];
        labe.text = imageInfo.address;
        self.backgroundColor = [UIColor whiteColor];
        [whiteBg addSubview:labe];
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        [btn addTarget:self action:@selector(clickimg) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
//        UIImageView * zanImg = [[UIImageView alloc] initWithFrame:CGRectMake(width-40, 5, 10, 10)];
//        zanImg.image = [UIImage imageNamed:@"爱心.png"];
//        [commentsBg addSubview:zanImg];
//        
//        UILabel * zanLab = [[UILabel alloc] initWithFrame:CGRectMake(width-30, 10, 15, 7)];
//        zanLab.backgroundColor = [UIColor clearColor];
//        zanLab.textColor = [UIColor blackColor];
//        zanLab.adjustsFontSizeToFitWidth = YES;
//        zanLab.font = [UIFont fontWithName:kBaseFont size:8];
//        zanLab.text = [NSString stringWithFormat:@"%d",imageInfo.commentNum];
//        [commentsBg addSubview:zanLab];
        
    }
    return self;
}
-(void)clickimg
{
    [self.delegate clickImage:self.data];
}
@end
