//
//  SKScrollview.h
//  ZtqCountry
//
//  Created by Admin on 15/6/26.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKScrollview : UIView
@property(strong,nonatomic)NSArray *valuearr;
@property(strong,nonatomic)NSArray *icons;
@property(strong,nonatomic)NSArray *times;
@property(strong,nonatomic)NSString  *maxhight,*minlowt,*nowct;
@property(strong,nonatomic)UIImageView *t_img;
@property(assign)float nextvalue;
@property(strong,nonatomic)UILabel *ctlab,*timelab;
-(void)drawlin:(float)netxvalue;
@end
