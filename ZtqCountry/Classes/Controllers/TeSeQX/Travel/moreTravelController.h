//
//  moreTravelController.h
//  ZtqNew
//
//  Created by lihj on 12-6-27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCSScrollView.h"
#import "mainVCmainVModel.h"
#import "travelWeaView.h"
#import "travelDetailView.h"
#import "travelAD.h"
#import "TravelViewController.h"
#import <MessageUI/MessageUI.h>
//#import "UMSocial.h"

@interface moreTravelController : UIViewController<MFMessageComposeViewControllerDelegate>{
    UIImageView *m_gdBg;
	NSString *city;
    
	mainVCmainVModel *m_mainVCmainVModel;
	travelWeaView *m_travelWea;
	travelDetailView *m_travelDetail;
    travelAD *m_traveAD;
	BOOL isFromCollect;//是否从收藏夹进来
    
    TreeNode *m_province;
	TreeNode *m_allCity;
}

@property (strong, nonatomic) travelWeaView * m_travelWea;
@property (strong, nonatomic) travelDetailView * m_travelDetail;
@property (strong, nonatomic) travelAD * m_traveAD;
@property(strong,nonatomic) NSString *mycity;
@property(assign)float barhight;
@property(strong,nonatomic)NSString *sharecontent;//分享内容
@property(strong,nonatomic)UIImage *shareimg;
- (void)setIsFromCollect:(BOOL)b;
- (void)setTravelCity:(NSString *)detailCity;
- (UIView *) createDetailView;
- (UIView *) createWeaView;
- (UIView *) createADView;

@end
