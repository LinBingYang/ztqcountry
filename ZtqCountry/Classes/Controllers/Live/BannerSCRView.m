//
//  BannerSCRView.m
//  ZtqCountry
//
//  Created by Admin on 15/7/6.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import "BannerSCRView.h"
#import "EGOImageView.h"

#define WIDTH ([UIScreen mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define PAGE_HEIGHT 37
#define rightDirection 1
#define zeroDirection 0
#define INTERVALE 3
@interface BannerSCRView()<UIScrollViewDelegate>
{
    int switchDirection;//方向
    //    CGFloat offsetY;
    NSMutableArray *imageNameArr;//图片数组
    NSMutableArray *titleStrArr;//标题数组
    
    UIScrollView *imageSV;//滚动视图
    UIPageControl *pageControl;
}
@end
static  int pageNumber;//页码
@implementation BannerSCRView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
//自定义实例化方法

- (instancetype)initWithNameArr:(NSMutableArray *)imageArr titleArr:(NSMutableArray *)titleArr height:(float)heightValue offsetY:(CGFloat)offsetY  offsetx:(CGFloat)offsetx{
    
    self = [super initWithFrame:CGRectMake(offsetx, 0, WIDTH, heightValue)];
    //    self.x=offsetx;
    if (self) {
        //        self.backgroundColor = [UIColor blueColor];
        pageNumber=0;//设置当前页为1
//        imageNameArr = imageArr;
//        titleStrArr=titleArr;
//        
//        [self addADScrollView:imageArr.count height:heightValue];
//        [self addImages:imageArr titles:titleArr];
//        [self addPageControl:imageArr.count];
        
        //设置NSTimer
//        _timer = [NSTimer scheduledTimerWithTimeInterval:INTERVALE target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        
    }
    return self;
}
-(void)getNameArr:(NSMutableArray *)imageArr titleArr:(NSMutableArray *)titleArr height:(float)heightValue offsetY:(CGFloat)offsetY  offsetx:(CGFloat)offsetx{
    pageNumber=0;//设置当前页为1
    imageNameArr = imageArr;
    titleStrArr=titleArr;
    
    [self addADScrollView:imageArr.count height:heightValue];
    [self addImages:imageArr titles:titleArr];
    [self addPageControl:imageArr.count];

}
- (void)addADScrollView:(NSInteger)count height:(CGFloat)heightValue
{
    //初始化scrollView
    imageSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, heightValue)];
    //设置sview属性
    
    imageSV.directionalLockEnabled = YES;//锁定滑动的方向
    if(count <= 1)
    {
        imageSV.pagingEnabled = NO;
        imageSV.scrollEnabled = NO;
    }
    else
    {
        imageSV.pagingEnabled = YES;//滑到subview的边界
        imageSV.scrollEnabled = YES;
    }
    
    imageSV.bounces = NO;
    imageSV.delegate = self;
    imageSV.showsVerticalScrollIndicator = NO;//不显示垂直滚动条
    imageSV.showsHorizontalScrollIndicator = NO;//不显示水平滚动条
    
    CGSize newSize = CGSizeMake(WIDTH * (count + 2),  imageSV.bounds.size.height);//设置scrollview的大小
    [imageSV setContentSize:newSize];
    [self addSubview:imageSV];
    
}
- (void)addImages:(NSArray *)imageArr titles:(NSArray *)titleArr
{
    //添加图片视图
    //    for (int i = 0; i < imageArr.count && !isRepeat; i++) {
    //
    //        NSString *title = @"";
    //        NSString *imageURL = @"";
    //        if (i < titleStrArr.count) {
    //            title = titleArr[i];
    //            imageURL = imageArr[i];
    //        }
    //
    //        //创建内容对象
    //        CGRect titleRect = CGRectMake(0, 150, 320, 30);
    //        BMImageView *imageView =  [[BMImageView alloc]initWithImageName:imageURL title:title x:WIDTH*i tFrame:titleRect iHeight:imageSV.frame.size.height titleHidden:NO];
    //
    //        //制定AOView委托
    //        imageView.uBdelegate = self;
    //        //设置视图标示
    //        imageView.tag = i;
    //        //添加视图
    //        [imageSV addSubview:imageView];
    //    }
    //
    for (int i = 0; i <= imageArr.count +1; i++) {
        
        NSString *title = @"";
        NSString *imageURL = @"";
        if (imageArr.count>0) {
            if (i != imageArr.count +1 && i != 0) {
                title = titleArr[i - 1];
                imageURL = imageArr[i - 1];
            }
            if (i == 0) {
                title = titleArr[titleArr.count - 1];
                imageURL = imageArr[imageArr.count - 1];
            }else if(i == titleArr.count +1)
            {
                title = titleArr[0];
                imageURL = imageArr[0];
            }
            NSLog(@"%@",title);
          
            NSURL *url=[NSURL URLWithString:imageURL];
            EGOImageView * egoimg = [[EGOImageView alloc] initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH, CGRectGetHeight(self.frame))];
            [egoimg setImageURL:url];
            egoimg.userInteractionEnabled=YES;
            egoimg.tag = i;
            //添加视图
            [imageSV addSubview:egoimg];
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH, self.frame.size.height)];
            btn.tag=i;
            [btn addTarget:self action:@selector(clickbtn:) forControlEvents:UIControlEventTouchUpInside];
            [egoimg addSubview:btn];
        }
        
    }
    [imageSV setContentOffset:CGPointMake(0, 0)];
    [imageSV scrollRectToVisible:CGRectMake(WIDTH,0,WIDTH,self.frame.size.height) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
    
    
}
- (void)addPageControl:(NSInteger)count
{
    CGRect rect =  CGRectMake(250, 125, 70, 30);
    pageControl = [[UIPageControl alloc]initWithFrame:rect];
    pageControl.numberOfPages = count;
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor colorHelpWithRed:0 green:140 blue:218 alpha:1];
    [self addSubview:pageControl];
    
}

// scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = imageSV.frame.size.width;
    int page = floor((imageSV.contentOffset.x - pagewidth/([imageNameArr count]+2))/pagewidth)+1;
    page --;  // 默认从第二页开始
    pageControl.currentPage = page;
}
// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = imageSV.frame.size.width;
    int currentPage = floor((imageSV.contentOffset.x - pagewidth/ ([imageNameArr count]+2)) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    if (currentPage==0)
    {
        [imageSV scrollRectToVisible:CGRectMake(WIDTH * [imageNameArr count],0,WIDTH,HEIGHT) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==([imageNameArr count]+1))
    {
        [imageSV scrollRectToVisible:CGRectMake(WIDTH,0,WIDTH,HEIGHT) animated:NO]; // 最后+1,循环第1页
    }
}
// pagecontrol 选择器的方法
- (void)turnPage
{
    int page = pageControl.currentPage; // 获取当前的page
    [imageSV scrollRectToVisible:CGRectMake(WIDTH*(page+1),0,WIDTH,HEIGHT) animated:YES]; // 触摸pagecontroller那个点点 往后翻一页 +1
}
// 定时器 绑定的方法
- (void)runTimePage
{
    int page = pageControl.currentPage; // 获取当前的page
    page++;
    page = page > imageNameArr.count-1 ? 0 : page ;
    pageControl.currentPage = page;
    [self turnPage];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
#pragma UBdelegate
-(void)click:(int)vid{
    //调用委托实现方法
    [self.vDelegate BanerbuttonClick:vid];
}
-(void)clickbtn:(UIButton *)sender{
    NSInteger tag=sender.tag;
    [self.vDelegate BanerbuttonClick:tag];
}
-(void)closeview{
    [self removeFromSuperview];
}

@end
