//
//  ADViewController.h
//  ZtqNew
//
//  Created by linxg on 13-11-27.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface ADViewController : UIViewController<UIWebViewDelegate,MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) UIWebView * web;
@property (strong, nonatomic) UIActivityIndicatorView * activity;
@property (strong, nonatomic) NSString * url;
@property (strong, nonatomic) NSString * shareContent;
@property (strong, nonatomic) UILabel * titlelab;
@property (strong, nonatomic) NSString * titleString;
@property(assign)float barhight;
@property(strong,nonatomic)UIImage *shareimg;
//-(void)loadWeb:(NSString *)urlS;
@property(strong,nonatomic)NSString *sharecontent;//分享内容
-(void)setBG:(NSString *)bg withLeftBarBG:(NSString *)left withRightBarBG:(NSString *)right;


@end
