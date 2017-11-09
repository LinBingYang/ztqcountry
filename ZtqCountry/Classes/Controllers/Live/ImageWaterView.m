//
//  ImageWaterView.m
//  hlrenTest
//
//  Created by blue on 13-4-23.
//  Copyright (c) 2013年 blue. All rights reserved.
//

#import "ImageWaterView.h"

@implementation ImageWaterView
@synthesize arrayImage;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithDataArray:(NSArray*)array withFrame:(CGRect)rect
{
    self = [super initWithFrame:rect];
    
    if (self) {
        self.arrayImage = array;
//        self.banerdatas=baners;
        //初始化参数
        [self initParameter];
        
    }
    return self;
}
-(void)initParameter
{
//    NSMutableArray *imgpaths=[[NSMutableArray alloc]init];
//    NSMutableArray *linkurls=[[NSMutableArray alloc]init];
//    NSMutableArray *orders=[[NSMutableArray alloc]init];
//    for (int i=0;i<self.banerdatas.count; i++) {
//        NSString *imgpath=[self.banerdatas[i] objectForKey:@"img_path"];
//        NSString *link_url=[self.banerdatas[i] objectForKey:@"link_url"];
//        NSString *target=[self.banerdatas[i] objectForKey:@"target"];
//        NSString *order_id=[self.banerdatas[i] objectForKey:@"order_id"];
//        [imgpaths addObject:imgpath];
//        [linkurls addObject:link_url];
//        [orders addObject:order_id];
//    }
//    self.banersurl=imgpaths;
//    self.banerstitls=orders;
//    [self.bmadscro removeFromSuperview];
//    self.bmadscro=nil;
//    if (self.bmadscro==nil) {
////        if (self.adimgurls.count>0) {
//            self.bmadscro = [[BannerSCRView alloc] initWithNameArr:self.banersurl  titleArr:self.banerstitls height:165
//                                                            offsetY:0 offsetx:0];
//        self.bmadscro.backgroundColor=[UIColor clearColor];
//            self.bmadscro.vDelegate = self;
//            self.bmadscro.pageCenter = CGPointMake(280, 170);
//            [self addSubview:self.bmadscro];
//            
//            
////        }
//    }
    //每一列的视图初始化
    firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
    secondView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH, 0)];
//    thridView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH*2, 0, WIDTH, 0)];
    
    higher = row = highValue = lower = 1;
    countImage = 0;
    
    for (int i = 0; i<self.arrayImage.count; i++) {
        //0%3=0,0-2除3也不可能大于0
        if (i/2>0 && i%2==0) {
            row++;
        }
        if (i==self.arrayImage.count-1) {
            self.islast=YES;
        }else
            self.islast=NO;
        ImageInfo *data = (ImageInfo*)[self.arrayImage objectAtIndex:i];
        
        countImage ++;
        //添加视图
        [self addViews:data with:countImage];
        //重新设置最高和最低view
        [self setHigherAndLower];
    }
    
    [self setContentSize:CGSizeMake(WIDTH, highValue+15)];
    [self addSubview:firstView];
    [self addSubview:secondView];
//    [self addSubview:thridView];
}
-(void)addViews:(ImageInfo *)image with:(int)a
{
    //要添加到列上的图片对象
    SelfImageVIew *imageView = nil;
    //图片的高度
    float imageHeight = 0;
    if (self.islast==YES) {
        lower=1;
    }
    //创建每列的视图填充的内容
    /*
     1、创建自定义的图片对象
     2、记住该图片的高度
     3、重新定义每列的大小，就是高度
     4、把该图片加到每列上。
     */
    //在最低的那一列添加图片
    switch (lower) {
        case 1:
            imageView = [[SelfImageVIew alloc]initWithImageInfo:image y:firstView.frame.size.height withA:a withRowTag:1];
            imageHeight = imageView.frame.size.height;
            firstView.frame = CGRectMake(firstView.frame.origin.x, firstView.frame.origin.y, WIDTH, firstView.frame.size.height + imageHeight);
            [firstView addSubview:imageView];
            break;
        case 2:
            imageView = [[SelfImageVIew alloc]initWithImageInfo:image y:secondView.frame.size.height  withA:a withRowTag:2];
            imageHeight = imageView.frame.size.height;
            secondView.frame = CGRectMake(secondView.frame.origin.x, secondView.frame.origin.y, WIDTH, secondView.frame.size.height + imageHeight);
            [secondView addSubview:imageView];
            break;
//        case 3:
//            imageView = [[SelfImageVIew alloc]initWithImageInfo:image y:thridView.frame.size.height  withA:a];
//            imageHeight = imageView.frame.size.height;
//            thridView.frame = CGRectMake(thridView.frame.origin.x, thridView.frame.origin.y, WIDTH, thridView.frame.size.height + imageHeight);
//            [thridView addSubview:imageView];
//            break;
        default:
            break;
    }
    imageView.delegate = self;
}
-(void)setHigherAndLower
{
    float firstHeight = firstView.frame.size.height;
    float secondHeight = secondView.frame.size.height;
//    float thridHeight = thridView.frame.size.height;
    //比较哪一列是最高的那列，并记录最高的值highValue和最高的列higher
    if (firstHeight > highValue) {
        highValue = firstHeight;
        higher = 1;
    }else if (secondHeight > highValue){
        highValue = secondHeight;
        higher = 2;
    }
    //找了最低列
    if (firstHeight < secondHeight) {
        lower=1;
    }else{
        lower=2;
    }
   
    self.hi=highValue;
}
-(void)clickImage:(ImageInfo *)data
{
    //自己做处理
    if([self.delegate respondsToSelector:@selector(imageWaterViewCellClickWithInfo:)])
    {
        [self.delegate imageWaterViewCellClickWithInfo:data];
    }
}
//刷新瀑布流
-(void)refreshView:(NSArray*)array
{
    [firstView removeFromSuperview];
    [secondView removeFromSuperview];
    firstView = nil;
    secondView = nil;
    self.arrayImage = array;
    [self initParameter];
    
}
//加载下一页瀑布流
-(void)loadNextPage:(NSArray*)array
{
    for (int i = 0; i<array.count; i++) {
        //0%3=0,0-2除3也不可能大于0
        if (i/2>0 && i%2==0) {
            row++;
        }
        if (i==array.count-1) {
            self.islast=YES;
        }else
            self.islast=NO;
        ImageInfo *data = (ImageInfo*)[array objectAtIndex:i];
        countImage++;
        //添加视图
        [self addViews:data with:countImage];
        //重新设置最高和最低view
        [self setHigherAndLower];
    }
    [self setContentSize:CGSizeMake(WIDTH, highValue+15)];
    self.hi=highValue;
}
////气象美图点击
//-(void)BanerbuttonClick:(int)vid{
//    if ([self.delegate respondsToSelector:@selector(bannerclick:)]) {
//        [self.delegate bannerclick:vid];
//    }
//}
@end
