//
//  YSZBBanerScrollview.m
//  ZtqCountry
//
//  Created by Admin on 17/1/12.
//  Copyright © 2017年 yyf. All rights reserved.
//

#import "YSZBBanerScrollview.h"
#import "EGOImageView.h"

#define WIDTH ([UIScreen mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define PAGE_HEIGHT 37
#define rightDirection 1
#define zeroDirection 0
#define INTERVALE 5
@interface YSZBBanerScrollview()<UIScrollViewDelegate>
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
@implementation YSZBBanerScrollview
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
    
    self = [super initWithFrame:CGRectMake(0, offsetY, WIDTH, heightValue)];
    //    self.x=offsetx;
    if (self) {
        //        self.backgroundColor = [UIColor blueColor];
        pageNumber=0;//设置当前页为1
        imageNameArr = imageArr;
        titleStrArr=titleArr;
        
        [self addADScrollView:imageArr.count height:heightValue];
        [self addImages:imageArr titles:titleArr];
        [self addPageControl:imageArr.count];
        
        //设置NSTimer
        _timer = [NSTimer scheduledTimerWithTimeInterval:INTERVALE target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        
    }
    return self;
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

            
            EGOImageView * egoimg = [[EGOImageView alloc] initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH, CGRectGetHeight(self.frame))];
            egoimg.placeholderImage=[UIImage imageNamed:@"影视背景.jpg"];
            [egoimg setImageURL:[ShareFun makeImageUrl:imageURL]];
            egoimg.userInteractionEnabled=YES;
            egoimg.tag = i;
            //添加视图
            [imageSV addSubview:egoimg];
            
            UILabel *tlab=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH*i+10, CGRectGetMaxY(egoimg.frame), WIDTH, 30)];
            tlab.text=title;
            tlab.font=[UIFont systemFontOfSize:15];
//            [imageSV addSubview:tlab];
            
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
    if (count<=1&&count>0) {
        
    }else{
        CGRect rect =  CGRectMake(240, 130, 70, 30);
        pageControl = [[UIPageControl alloc]initWithFrame:rect];
        pageControl.numberOfPages = count;
        pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        pageControl.currentPageIndicatorTintColor = [UIColor colorHelpWithRed:0 green:140 blue:218 alpha:1];
        [self addSubview:pageControl];
    }
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
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fireToSpaceTimer) object:nil];
    [self fireToSpaceTimer];
    
    
}
- (void)fireToSpaceTimer {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.timer setFireDate:[NSDate date]];
    });
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self.timer setFireDate:[NSDate distantFuture]];
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
    [self.vDelegate yszbbuttonClick:vid];
}
-(void)clickbtn:(UIButton *)sender{
    NSInteger tag=sender.tag;
    [self.vDelegate yszbbuttonClick:tag];
}
-(void)closeview{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
