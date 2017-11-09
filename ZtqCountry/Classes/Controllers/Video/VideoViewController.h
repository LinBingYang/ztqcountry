//
//  VideoViewController.h
//  ZtqCountry
//
//  Created by linxg on 14-8-7.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "BaseViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "DirectionMPMoviePlayerController.h"

@interface VideoViewController : BaseViewController
@property (strong, nonatomic) DirectionMPMoviePlayerController * moviePlayer;

@property(strong,nonatomic)NSString *viedoname;
-(void)playMovie:(NSString *)fileName;
 @property(assign) BOOL      m_IsPlay;

@end
