//
//  ShareSheet.m
//  ZtqCountry
//
//  Created by linxg on 14-6-25.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "ShareSheet.h"
#import "UIColor+utils.h"
#define sheetHeight 150

@interface ShareSheet ()

@property (strong, nonatomic) UIScrollView * sheetScrollView;

@end



@implementation ShareSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)creatViewWithButtonNum:(int)num
{
    //半透明黑色遮挡层
    UIView * barrierView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    barrierView.backgroundColor = [UIColor blackColor];
    barrierView.alpha = 0.3;
    [self addSubview:barrierView];
    //添加手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [barrierView addGestureRecognizer:tap];
    _sheetBgView = [[UIImageView alloc] init];
    UIImage * image = [UIImage imageNamed:@"fx框.png"];
    _sheetBgView.image = image;
    _sheetBgView.userInteractionEnabled = YES;
    _sheetBgView.layer.shadowColor = [UIColor grayColor].CGColor;
    _sheetBgView.layer.shadowRadius = 1;
    _sheetBgView.layer.cornerRadius = 5;
    _sheetBgView.layer.masksToBounds = YES;

//    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(50, 0, 0, 0)];

    [self addSubview:_sheetBgView];
    
    _sheetScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth-2, sheetHeight-30*2)];
    _sheetScrollView.backgroundColor = [UIColor whiteColor];
    [_sheetBgView addSubview:_sheetScrollView];
    if(num<=5)
    {
        _sheetBgView.frame = CGRectMake(1, kScreenHeitht-sheetHeight-1, kScreenWidth-2, sheetHeight);
        _sheetScrollView.contentSize = CGSizeMake(kScreenWidth, sheetHeight-30*2);
    }
    else
    {
        int rowNum = 1;
        if(num%5)
        {
            rowNum = num/5+1;
        }
        else
        {
            rowNum = num/5;
        }
        _sheetBgView.frame = CGRectMake(1, kScreenHeitht-2*sheetHeight-1, kScreenWidth-2, sheetHeight*2);
        _sheetScrollView.contentSize = CGSizeMake(kScreenWidth, (sheetHeight-30*2)*rowNum);
    }

    
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-2, 30)];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textColor = [UIColor blackColor];
//    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont systemFontOfSize:13];
    [_sheetBgView addSubview:_titleLab];
    

    
    UIButton * cancleBut = [[UIButton alloc] initWithFrame:CGRectMake(0, sheetHeight-28, kScreenWidth-2, 28)];
    [cancleBut setBackgroundImage:[UIImage imageNamed:@"fx取消按钮.png"] forState:UIControlStateNormal];
    [cancleBut setBackgroundImage:[UIImage imageNamed:@"fx取消按钮点击.png"] forState:UIControlStateHighlighted];
//    [cancleBut setTitleColor:[UIColor colorHelpWithRed:0 green:115 blue:250 alpha:1] forState:UIControlStateNormal];
    [cancleBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleBut setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBut addTarget:self action:@selector(cancleButAction:) forControlEvents:UIControlEventTouchUpInside];
    [_sheetBgView addSubview:cancleBut];
}


-(void)cancleButAction:(UIButton *)sender
{
    [self hide];
}

-(id)initWithTitle:(NSString *)title withButImages:(NSArray *)imageNames withHightLightImage:(NSArray *)hightlightimg withButTitles:(NSArray *)titles withDelegate:(id)delegate
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    if(self){
        [self creatViewWithButtonNum:imageNames.count];
        self.delegate = delegate;
        if(title.length&&title){
            _titleLab.text = @"分享到";
        }
        float margin = 15;//边距
        float spacing = (self.width-200)/5;//每个按钮的间隔
        float scale = 50;//每个按钮的大小
        float sheetScrollViewContentWidth = (spacing+scale)*imageNames.count;//计算_sheetScrollView所需要的content的宽度
        if(imageNames.count){
            for(int i=0;i<imageNames.count;i++){
                int line;//行
                int column;//列
                line = i/5;
                column = i%5;
                UIButton * but = [[UIButton alloc] initWithFrame:CGRectMake(spacing+(spacing+scale)*column, 10+75*line, scale, scale)];
                but.tag = i;
                [but setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
                [but setImage:[UIImage imageNamed:hightlightimg[i]] forState:UIControlStateHighlighted];
                [but addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
                [_sheetScrollView addSubview:but];
            }
        }
        if(titles.count){
            for(int i=0;i<titles.count;i++){
                int line;//行
                int column;//列
                line = i/5;
                column = i%5;
                UILabel * butTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(spacing-10+(spacing+scale)*i ,65+75*line, 20+scale,20)];
                butTitleLab.textAlignment = NSTextAlignmentCenter;
                butTitleLab.backgroundColor = [UIColor clearColor];
                butTitleLab.textColor = [UIColor blackColor];
                butTitleLab.font = [UIFont systemFontOfSize:13];
                butTitleLab.text = titles[i];
                [_sheetScrollView addSubview:butTitleLab];
                if(i>=imageNames.count){
                    break;
                }
            }
        }
        _sheetScrollView.contentSize = CGSizeMake(sheetScrollViewContentWidth, sheetHeight-30*2);
    }
    return self;
}

-(id)initDefaultWithTitle:(NSString *)title withDelegate:(id)delegate
{
    NSArray * images = [[NSArray alloc] initWithObjects:@"fx新浪微博",@"fx微信",@"fx朋友圈",@"分享更多More.jpg", nil];
    NSArray * hightLightImgs = [[NSArray alloc] initWithObjects:@"fx新浪微博点击",@"fx微信点击",@"fx朋友圈点击",@"分享更多More点击态.jpg" ,nil];
    NSMutableArray * titles = [[NSMutableArray alloc] initWithObjects:@"新浪微博",@"微信好友",@"朋友圈",@"更多", nil];
    return  [self initWithTitle:title withButImages:images withHightLightImage:hightLightImgs withButTitles:titles withDelegate:delegate];
}

-(void)butAction:(UIButton *)sender
{
    if(self.delegate &&[self.delegate respondsToSelector:@selector(ShareSheetClickWithIndexPath:)]){
        [self.delegate ShareSheetClickWithIndexPath:sender.tag];
    }
    [self hide];
}


-(void)show
{
    CGRect originFram = _sheetBgView.frame;
    CGRect newFram = CGRectOffset(originFram, 0, +CGRectGetHeight(originFram));
    _sheetBgView.frame = newFram;
    
    if([[self class] isSubclassOfClass:[UIViewController class]]){
        UIView * addView = [(UIViewController *)self.delegate view];
        [addView addSubview:self];
    }else{
        UIWindow * window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:self];
    }

    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];
    _sheetBgView.frame = originFram;
    [UIView commitAnimations];
}

-(void)hide
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect originFram = _sheetBgView.frame;
        CGRect newFram = CGRectOffset(originFram, 0, +CGRectGetHeight(originFram));
        _sheetBgView.frame = newFram;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
