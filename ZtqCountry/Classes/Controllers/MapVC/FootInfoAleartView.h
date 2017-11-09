//
//  FootInfoAleartView.h
//  ZtqCountry
//
//  Created by Admin on 15/7/2.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FootInfoAleartView : UIView
@property(strong,nonatomic)UIScrollView *bgscro;
-(void)getdata:(NSArray *)datas withaddress:(NSString *)address;
@end
