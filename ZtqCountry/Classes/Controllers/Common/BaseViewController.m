//
//  BaseViewController.m
//  ZtqCountry
//
//  Created by linxg on 14-6-10.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //    self.view.frame = CGRectMake(se, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    [self createBar];
    [self setBarHiden:YES];
    
}

-(void)setBarHiden:(BOOL)barHiden
{
    if(barHiden)
    {
        if(_navigationBarBg)
        {
            _navigationBarBg.hidden = YES;
            self.barHeight = 0;
        }
    }
    else
    {
        float place = 0;
        if(kSystemVersionMore7)
        {
            place = 20;
        }
        self.barHeight = 44+ place;
        if(_navigationBarBg)
        {
            _navigationBarBg.hidden = NO;
        }
        else
        {
            [self createBar];
            _navigationBarBg.hidden = NO;
        }
    }
}

-(void)createBar
{
    if(kSystemVersionMore7)
    {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    self.navigationController.navigationBarHidden = YES;
    //    self.title = @"推送设置";
    float place = 0;
    if(kSystemVersionMore7)
    {
        place = 20;
    }
    self.barHeight = 44+ place;
    _navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
    _navigationBarBg.userInteractionEnabled = YES;
    _navigationBarBg.image=[UIImage imageNamed:@"导航栏.png"];
//    _navigationBarBg.backgroundColor = [UIColor colorHelpWithRed:28 green:136 blue:240 alpha:1];
    [self.view addSubview:_navigationBarBg];
    
    UIImageView *leftimg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 7+place, 29, 29)];
    leftimg.image=[UIImage imageNamed:@"返回.png"];
    leftimg.userInteractionEnabled=YES;
    [_navigationBarBg addSubview:leftimg];
    
    _leftBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 7+place, 60, 44+place)];
    [_leftBut addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarBg addSubview:_leftBut];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 12+place, self.view.width-120, 20)];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont fontWithName:kBaseFont size:20];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textColor = [UIColor whiteColor];
    [_navigationBarBg addSubview:_titleLab];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-(void)setNavigation
//{
//    if(kSystemVersionMore7)
//    {
//        self.edgesForExtendedLayout =  UIRectEdgeNone;
//    }
//    self.navigationController.navigationBarHidden = YES;
//    //    self.title = @"推送设置";
//    float place = 0;
//    if(kSystemVersionMore7)
//    {
//        place = 20;
//    }
//    _navigationBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+place)];
//    _navigationBarBg.userInteractionEnabled = YES;
//    _navigationBarBg.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_navigationBarBg];
//
//    _leftBut = [[UIButton alloc] initWithFrame:CGRectMake(5, 7+place, 50, 30)];
////    [_leftBut setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
////    [_leftBut setTitle:@"back" forState:UIControlStateNormal];
//    [_leftBut addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_navigationBarBg addSubview:_leftBut];
//
//    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 7+place, 200, 30)];
//    _titleLab.textAlignment = NSTextAlignmentCenter;
//    _titleLab.font = [UIFont fontWithName:kBaseFont size:20];
//    _titleLab.backgroundColor = [UIColor clearColor];
//    _titleLab.textColor = [UIColor blackColor];
//    [_navigationBarBg addSubview:_titleLab];
//}




-(void)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIButton *)rightBut
{
    float place = 0;
    if(kSystemVersionMore7)
    {
        place = 20;
    }
    if(_rightBut == nil)
    {
        _rightBut =[[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-20-12, 7+place, 12, 21)];
        [self.navigationBarBg addSubview:_rightBut];
    }
    return _rightBut;
}

@end
