//
//  ROBaseNavigationViewController.h
//  RenrenSDKDemo
//
//  Created by xiawh on 11-11-11.
//  Copyright (c) 2011年 renren－inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ROBaseNavigationViewController : UIViewController {
    UINavigationBar *_navigationBar;
    UIDeviceOrientation _orientation;
    UIViewController *_lastViewController;
}
@property (nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic, assign) UIDeviceOrientation orientation;
@property (nonatomic, strong) UIViewController *lastViewController;

- (void)show;
- (void)close;
- (void)change:(ROBaseNavigationViewController *)newController;

- (void)selfChangeOption:(ROBaseNavigationViewController *)newController;
- (void)otherChangeOption:(ROBaseNavigationViewController *)newController;

@end
