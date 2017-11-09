//
//  CustomPickView.m
//  ZtqCountry
//
//  Created by linxg on 14-7-18.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "CustomPickView.h"

@interface CustomPickView ()

@property (strong, nonatomic) UILabel * oneNumLab;
@property (strong, nonatomic) UILabel * twoNumLab;
@property (strong, nonatomic) UILabel * oneNum1;
@property (strong, nonatomic) UILabel * oneNum3;
@property (strong, nonatomic) UILabel * twoNum1;
@property (strong, nonatomic) UILabel * twoNum3;
@property (strong, nonatomic) UILabel * titleLab;

@end

@implementation CustomPickView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withFirstGroupDataSourse:(NSArray *)firstDataSourse withSecondGroupDataSourse:(NSArray *)secondDataSourse withOnView:(UIView *)onView withOneIdx:(int)one withTwoIdx:(int)two
{
    CGRect newFram = CGRectMake(0, 0, kScreenWidth, kScreenHeitht);
    self = [super initWithFrame:newFram];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        NSLog(@"%d",one);
        NSLog(@"%d",two);
        self.oneIdx = one;
        self.twoIdx = two;
        self.firstDataSourse = firstDataSourse;
        self.secondDataSourse = secondDataSourse;
        self.onView = onView;
        [self creatView];
    }
    return self;
}


-(void)creatView
{
    UIView * pollutionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    pollutionView.backgroundColor = [UIColor blackColor];
    pollutionView.alpha = 0.7;
    [self addSubview:pollutionView];
    
    UIImageView * bgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 100,290, 270)];
    bgImgV.image = [UIImage imageNamed:@"nzsz2底纹.png"];
    bgImgV.userInteractionEnabled = YES;
    [self addSubview:bgImgV];
    
    //
    //    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(self.frame), 1)];
    //    line.backgroundColor = [UIColor greenColor];
    //    [self addSubview:line];
    
    UIView * oneBg = [[UIView alloc] initWithFrame:CGRectMake(77, 60, 63, 170)];
    oneBg.backgroundColor = [UIColor clearColor];
    [bgImgV addSubview:oneBg];
    
    UIButton * oneAdd = [[UIButton alloc] initWithFrame:CGRectMake(22, 0, 22, 12)];
    //    [oneAdd setBackgroundColor:[UIColor clearColor]];
    //    [oneAdd setTitle:@"+" forState:UIControlStateNormal];
    //    [oneAdd setTintColor:[UIColor blackColor]];
    [oneAdd setImage:[UIImage imageNamed:@"nzsz2上箭头.png"] forState:UIControlStateNormal];
    [oneAdd addTarget:self action:@selector(oneAdd:) forControlEvents:UIControlEventTouchUpInside];
    [oneBg addSubview:oneAdd];
    
    _oneNum1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, 63, 36)];
    [_oneNum1 setBackgroundColor:[UIColor clearColor]];
    _oneNum1.textAlignment = NSTextAlignmentCenter;
    _oneNum1.font = [UIFont fontWithName:kBaseFont size:15];
    _oneNum1.textColor = [UIColor grayColor];
    
    int a1 = self.oneIdx-1;
    if(a1<0)
    {
        a1 = self.firstDataSourse.count-1;
    }
    _oneNum1.text = [self.firstDataSourse objectAtIndex:a1];
    [oneBg addSubview:_oneNum1];
    
    UIImageView * oneUpLine = [[UIImageView alloc] initWithFrame:CGRectMake(15, 64, 33, 1)];
    oneUpLine.image = [UIImage imageNamed:@"nzsz2隔条.png"];
    [oneBg addSubview:oneUpLine];
    
    UILabel * oneNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 63, 36)];
    //    self.oneIdx = 0;
    oneNum.text = [self.firstDataSourse objectAtIndex:self.oneIdx];
    self.oneNumLab = oneNum;
    [oneNum setBackgroundColor:[UIColor clearColor]];
    oneNum.textAlignment = NSTextAlignmentCenter;
    oneNum.font = [UIFont fontWithName:kBaseFont size:15];
    oneNum.textColor = [UIColor blackColor];
    [oneBg addSubview:oneNum];
    
    UIImageView * oneDownLine = [[UIImageView alloc] initWithFrame:CGRectMake(15, 102, 33, 1)];
    oneDownLine.image = [UIImage imageNamed:@"nzsz2隔条.png"];
    [oneBg addSubview:oneDownLine];
    
    
    _oneNum3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 106, 63, 36)];
    [_oneNum3 setBackgroundColor:[UIColor clearColor]];
    _oneNum3.textAlignment = NSTextAlignmentCenter;
    _oneNum3.font = [UIFont fontWithName:kBaseFont size:15];
    _oneNum3.textColor = [UIColor grayColor];
    int a3 = self.oneIdx+1;
    if(a3<0)
    {
        a3 = self.firstDataSourse.count-1;
    }
    _oneNum3.text = [self.firstDataSourse objectAtIndex:a3];
    [oneBg addSubview:_oneNum3];
    
    
    UIButton * oneReduce = [[UIButton alloc] initWithFrame:CGRectMake(22, 145, 22, 12)];
    //    [oneReduce setBackgroundColor:[UIColor clearColor]];
    //    [oneReduce setTitle:@"-" forState:UIControlStateNormal];
    //    [oneReduce setTintColor:[UIColor blackColor]];
    [oneReduce setImage:[UIImage imageNamed:@"nzsz2下箭头.png"] forState:UIControlStateNormal];
    [oneReduce addTarget:self action:@selector(oneReduce:) forControlEvents:UIControlEventTouchUpInside];
    [oneBg addSubview:oneReduce];
    
    UIView * twoBg = [[UIView alloc] initWithFrame:CGRectMake(154, 60, 63, 170)];
    twoBg.backgroundColor = [UIColor clearColor];
    [bgImgV addSubview:twoBg];
    
    UIButton * twoAdd = [[UIButton alloc] initWithFrame:CGRectMake(22, 0, 22, 12)];
    //    [twoAdd setBackgroundColor:[UIColor clearColor]];
    //    [twoAdd setTitle:@"+" forState:UIControlStateNormal];
    //    [twoAdd setTintColor:[UIColor blackColor]];
    [twoAdd setImage:[UIImage imageNamed:@"nzsz2上箭头.png"] forState:UIControlStateNormal];
    [twoAdd addTarget:self action:@selector(twoAdd:) forControlEvents:UIControlEventTouchUpInside];
    [twoBg addSubview:twoAdd];
    
    _twoNum1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, 63, 36)];
    [_twoNum1 setBackgroundColor:[UIColor clearColor]];
    _twoNum1.textAlignment = NSTextAlignmentCenter;
    _twoNum1.font = [UIFont fontWithName:kBaseFont size:15];
    _twoNum1.textColor = [UIColor grayColor];
    int b1 = self.twoIdx-1;
    if(b1<0)
    {
        b1 = self.secondDataSourse.count-1;
    }
    _twoNum1.text = [self.secondDataSourse objectAtIndex:b1];
    [twoBg addSubview:_twoNum1];
    
    UIImageView * twoUpLine = [[UIImageView alloc] initWithFrame:CGRectMake(15, 64, 33, 1)];
    twoUpLine.image = [UIImage imageNamed:@"nzsz2隔条.png"];
    [twoBg addSubview:twoUpLine];
    
    
    UILabel * twoNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 63, 36)];
    //    self.twoIdx = 0;
    twoNum.text = [self.secondDataSourse objectAtIndex:self.twoIdx];
    self.twoNumLab = twoNum;
    [twoNum setBackgroundColor:[UIColor clearColor]];
    twoNum.textAlignment = NSTextAlignmentCenter;
    twoNum.font = [UIFont fontWithName:kBaseFont size:15];
    twoNum.textColor = [UIColor blackColor];
    [twoBg addSubview:twoNum];
    
    UIImageView * twoDownLine = [[UIImageView alloc] initWithFrame:CGRectMake(15, 102, 33, 1)];
    twoDownLine.image = [UIImage imageNamed:@"nzsz2隔条.png"];
    [twoBg addSubview:twoDownLine];
    
    _twoNum3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 106, 63, 36)];
    [_twoNum3 setBackgroundColor:[UIColor clearColor]];
    _twoNum3.textAlignment = NSTextAlignmentCenter;
    _twoNum3.font = [UIFont fontWithName:kBaseFont size:15];
    _twoNum3.textColor = [UIColor grayColor];
    int b3 = self.twoIdx+1;
    if(b3<0)
    {
        b3 = self.secondDataSourse.count-1;
    }
    _twoNum3.text = [self.secondDataSourse objectAtIndex:b3];
    [twoBg addSubview:_twoNum3];
    
    
    UIButton * twoReduce = [[UIButton alloc] initWithFrame:CGRectMake(22, 145, 22, 12)];
    //    [twoReduce setBackgroundColor:[UIColor clearColor]];
    //    [twoReduce setTitle:@"-" forState:UIControlStateNormal];
    //    [twoReduce setTintColor:[UIColor blackColor]];
    [twoReduce setImage:[UIImage imageNamed:@"nzsz2下箭头.png"] forState:UIControlStateNormal];
    [twoReduce addTarget:self action:@selector(twoReduce:) forControlEvents:UIControlEventTouchUpInside];
    [twoBg addSubview:twoReduce];
    
    UIImageView * heng = [[UIImageView alloc] initWithFrame:CGRectMake(5, 229, 280, 1)];
    heng.image = [UIImage imageNamed:@"sz横隔条.png"];
    [bgImgV addSubview:heng];
    
    UIImageView * shu = [[UIImageView alloc] initWithFrame:CGRectMake(153, 235, 1, 25)];
    shu.image = [UIImage imageNamed:@"sz竖隔条.png"];
    [bgImgV addSubview:shu];
    
    UIButton * determine = [[UIButton alloc] initWithFrame:CGRectMake(10, 230, 117, 35)];
    [determine setBackgroundColor:[UIColor clearColor]];
    [determine setTitle:@"设定" forState:UIControlStateNormal];
    [determine setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [determine setBackgroundImage:[UIImage imageNamed:@"nzsz2按钮点击.png"] forState:UIControlStateHighlighted];
    [determine addTarget:self action:@selector(determine:) forControlEvents:UIControlEventTouchUpInside];
    [bgImgV addSubview:determine];
    
    UIButton * cancle = [[UIButton alloc] initWithFrame:CGRectMake(154, 230, 117, 35)];
    [cancle setBackgroundColor:[UIColor clearColor]];
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    [cancle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancle setBackgroundImage:[UIImage imageNamed:@"nzsz2按钮点击.png"] forState:UIControlStateHighlighted];
    [cancle addTarget:self action:@selector(cancle:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [bgImgV addSubview:cancle];
    
    UIImageView * clockIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
    clockIcon.image = [UIImage imageNamed:@"nzsz2闹钟_10.png"];
    [bgImgV addSubview:clockIcon];
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 200, 25)];
    self.titleLab = title;
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont fontWithName:kBaseFont size:20];
    title.textColor = [UIColor whiteColor];
    [bgImgV addSubview:title];
    [self setTitle];
}

-(void)oneAdd:(UIButton *)sender
{
    self.oneIdx +=1;
    self.oneIdx = self.oneIdx%self.firstDataSourse.count;
    self.oneNumLab.text = [self.firstDataSourse objectAtIndex:self.oneIdx];
    int a = self.oneIdx-1;
    if(a<0)
    {
        a = self.firstDataSourse.count-1;
    }
    a=a%self.firstDataSourse.count;
    int a1 = self.oneIdx +1;
    a1 = a1%self.firstDataSourse.count;
    _oneNum1.text = [self.firstDataSourse objectAtIndex:a];
    _oneNum3.text = [self.firstDataSourse objectAtIndex:a1];
    [self setTitle];
}

-(void)oneReduce:(UIButton *)sender
{
    self.oneIdx -=1;
    if(self.oneIdx <0)
    {
        self.oneIdx = self.firstDataSourse.count-1;
    }
    self.oneIdx = self.oneIdx%self.firstDataSourse.count;
    self.oneNumLab.text = [self.firstDataSourse objectAtIndex:self.oneIdx];
    int a = self.oneIdx-1;
    if(a<0)
    {
        a = self.firstDataSourse.count-1;
    }
    a=a%self.firstDataSourse.count;
    int a1 = self.oneIdx +1;
    a1 = a1%self.firstDataSourse.count;
    _oneNum1.text = [self.firstDataSourse objectAtIndex:a];
    _oneNum3.text = [self.firstDataSourse objectAtIndex:a1];
    [self setTitle];
}

-(void)twoAdd:(UIButton *)sender
{
    self.twoIdx +=1;
    if(self.twoIdx >= self.secondDataSourse.count)
    {
        [self oneAdd:nil];
    }
    self.twoIdx = self.twoIdx%self.secondDataSourse.count;
    self.twoNumLab.text = [self.secondDataSourse objectAtIndex:self.twoIdx];
    int a = self.twoIdx-1;
    if(a<0)
    {
        a = self.secondDataSourse.count-1;
    }
    a=a%self.secondDataSourse.count;
    int a1 = self.twoIdx +1;
    a1 = a1%self.secondDataSourse.count;
    _twoNum1.text = [self.secondDataSourse objectAtIndex:a];
    _twoNum3.text = [self.secondDataSourse objectAtIndex:a1];
    [self setTitle];
}

-(void)twoReduce:(UIButton *)sender
{
    self.twoIdx -=1;
    if(self.twoIdx <0)
    {
        [self oneReduce:nil];
        self.twoIdx = self.secondDataSourse.count-1;
    }
    self.twoIdx = self.twoIdx%self.secondDataSourse.count;
    self.twoNumLab.text = [self.secondDataSourse objectAtIndex:self.twoIdx];
    int a = self.twoIdx-1;
    if(a<0)
    {
        a = self.secondDataSourse.count-1;
    }
    a=a%self.secondDataSourse.count;
    int a1 = self.twoIdx +1;
    a1 = a1%self.secondDataSourse.count;
    _twoNum1.text = [self.secondDataSourse objectAtIndex:a];
    _twoNum3.text = [self.secondDataSourse objectAtIndex:a1];
    [self setTitle];
}

-(void)setTitle
{
    self.titleLab.text = [NSString stringWithFormat:@"%@:%@",self.oneNumLab.text,self.twoNumLab.text];
}

-(void)determine:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(determineWithTime:)])
    {
        [self.delegate determineWithTime:self.titleLab.text];
    }
    [self hiden];
}

-(void)cancle:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(cancle)])
    {
        [self.delegate cancle];
    }
    [self hiden];
}


-(void)show
{
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    CGAffineTransform scale = CGAffineTransformMakeScale(0.1, 0.1);
    self.transform = scale;
    [UIView animateWithDuration:0.3 animations:^{
        CGAffineTransform newScale = CGAffineTransformMakeScale(1.1, 1.1);
        self.transform = newScale;
    } completion:^(BOOL finished) {
        CGAffineTransform scale = CGAffineTransformMakeScale(1, 1);
        self.transform = scale;
    }];
}

-(void)hiden
{
    [self removeFromSuperview];
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
