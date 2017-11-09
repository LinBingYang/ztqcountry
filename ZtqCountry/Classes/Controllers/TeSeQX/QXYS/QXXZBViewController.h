//
//  QXXZBViewController.h
//  ZtqCountry
//
//  Created by 胡彭飞 on 2017/1/12.
//  Copyright © 2017年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QXXZBViewController : UIViewController<NSURLConnectionDelegate>{
    NSURLRequest*_originRequest;
    
    NSURLConnection*_urlConnection;
    
    BOOL _authenticated;
}
@property(assign)float barhight;
@property (strong, nonatomic) UILabel * titlelab;
@property (copy, nonatomic) NSString * titleString;


@property (strong, nonatomic) UIActivityIndicatorView * activity;
@property (copy, nonatomic) NSString * url,*userid,*sharetype,*nolgurl;
@property (copy, nonatomic) NSString * shareContent;
@property (copy, nonatomic) NSString *type;

@property(strong,nonatomic)UIImage *shareimg;
@property(assign)BOOL isshare;
@property(nonatomic,copy) NSString *websharetype;
@property (strong, nonatomic) UIImageView * navigationBarBg;
@property (nonatomic, copy)NSString *rightBtnType;
@end
