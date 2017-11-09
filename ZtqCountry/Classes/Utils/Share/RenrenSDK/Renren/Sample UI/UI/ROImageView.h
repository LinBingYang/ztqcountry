//
//  ROImageView.h
//  SimpleDemo
//
//  Created by Winston on 11-8-18.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ROImageView : UIView{

    UIImageView *_imageView;
    UIActivityIndicatorView *_activityIndcator;
    NSString *_imageUrl;
    NSMutableData *_imageData;
    NSURLResponse *_imageResponse;
    NSURLConnection *_imageConnection;
}
@property (nonatomic ,strong)UIImageView *imageView;
@property (nonatomic ,strong)NSString *imageUrl;
@property (nonatomic ,strong)UIActivityIndicatorView *activityIndcator;
@property (nonatomic ,strong)NSMutableData *imageData;
@property (nonatomic ,strong)NSURLResponse *imageResponse;
@property (nonatomic ,strong)NSURLConnection *imageConnection;

- (void)setImageUrl:(NSString *)imageUrl;
- (void)setImage:(UIImage *)image;
- (UIImage *)image;
@end
