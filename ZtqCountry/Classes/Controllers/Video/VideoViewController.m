//
//  VideoViewController.m
//  ZtqCountry
//
//  Created by linxg on 14-8-7.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "VideoViewController.h"




@interface VideoViewController ()

@end

@implementation VideoViewController

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
    [self playMovie:self.viedoname];
  
}


-(BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    _moviePlayer.view.frame = CGRectMake(0,0,self.view.bounds.size.width, self.view.bounds.size.height);
    
    
    return UIInterfaceOrientationMaskAll;
}


-(void)playMovie:(NSString *)fileName{
    //视频文件路径
//    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mov"];
    //视频URL
    NSString *medaiurl=[ShareFun makeImageUrlStr:fileName];
    NSURL *url = [NSURL URLWithString:medaiurl];
    //视频播放对象
    if (_moviePlayer == nil) {
        _moviePlayer = [[DirectionMPMoviePlayerController alloc] initWithContentURL:url];
    }else {
        [_moviePlayer setContentURL:url];
    }
    _moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
//    [_moviePlayer.view setFrame:self.view.bounds];
    _moviePlayer.view.frame = CGRectMake(0.0,0,self.view.bounds.size.width,self.view.bounds.size.height);
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%f!%f!%f!%f!!!!!!!!!!!!!!!!!",self.view.bounds.origin.x,self.view.bounds.origin.y,self.view.bounds.size.width,self.view.bounds.size.height);
    _moviePlayer.repeatMode = MPMovieRepeatModeOne;
    _moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
//    _moviePlayer.initialPlaybackTime = -1;
    [self.view addSubview:_moviePlayer.view];
    // 注册一个播放结束的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    [_moviePlayer play];
}

-(void)viewWillLayoutSubviews
{
//    [_moviePlayer.view setFrame:self.view.bounds];
    _moviePlayer.view.frame = CGRectMake(0.0,kSystemVersionMore7 ?0 : -20.0,self.view.bounds.size.width,kSystemVersionMore7 ?self.view.bounds.size.height:self.view.bounds.size.height+20);
}
//-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return toInterfaceOrientation !=UIDeviceOrientationPortraitUpsideDown;
//}
//
//-(BOOL)shouldAutorotate
//{
//    return YES;
//}

//-(NSUInteger)supportedInterfaceOrientations
//{
////    return  UIInterfaceOrientationMaskAllButUpsideDown;
//}


#pragma mark -------------------视频播放结束委托--------------------

/*
 @method 当视频播放完毕释放对象
 */
-(void)myMovieFinishedCallback:(NSNotification*)notify
{
    //视频播放对象
    MPMoviePlayerController* theMovie = [notify object];
    //销毁播放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    [theMovie.view removeFromSuperview];
    // 释放视频对象
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
