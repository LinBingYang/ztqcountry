//
//  CustomNavigationController.m
//  ZtqCountry
//
//  Created by linxg on 14-8-7.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "CustomNavigationController.h"
#import "VideoViewController.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation !=UIDeviceOrientationPortraitUpsideDown;
}

-(BOOL)shouldAutorotate
{
    if([self.topViewController isKindOfClass:[VideoViewController class]])
    {
        return YES;
    }
    return NO;
}

//-(NSUInteger)supportedInterfaceOrientations
//{
////    return  UIInterfaceOrientationMaskAllButUpsideDown;
//}

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
