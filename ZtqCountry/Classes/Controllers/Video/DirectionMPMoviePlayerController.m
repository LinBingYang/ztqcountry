//
//  DirectionMPMoviePlayerController.m
//  ZtqCountry
//
//  Created by linxg on 14-8-7.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "DirectionMPMoviePlayerController.h"

@implementation DirectionMPMoviePlayerController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];

    return UIDeviceOrientationIsLandscape(interfaceOrientation);
}
@end
