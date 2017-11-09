//
//  TravelCollectVC.h
//  ZtqCountry
//
//  Created by Admin on 15/7/6.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelViewController.h"
#import "moreTravelController.h"
@interface TravelCollectVC : UIViewController{
 
    NSMutableDictionary *city_tq;
}
@property(assign)float barHeight,heiht;
@property(retain,nonatomic)UIImageView *navigationBarBg;
@property(strong,nonatomic)UIButton *rightbtn;
@property(strong,nonatomic)NSMutableArray *allarr;//收藏城市
@property(strong,nonatomic)UIScrollView *bgscro;
@property(strong,nonatomic)UILabel *lab;
@end
