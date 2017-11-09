//
//  SKMoveView.h
//  ZtqCountry
//
//  Created by Admin on 15/6/19.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKLineView.h"
#import "SkWtScrollview.h"
@interface SKMoveView : UIView
@property(strong,nonatomic)UIImageView *icoimg;
@property(strong,nonatomic)UILabel *timelab,*weathlab;
@property(strong,nonatomic)SKLineView *skline;
@property(strong,nonatomic)UIScrollView *mscro;
@property(strong,nonatomic)UIImageView *bgimg;
@property(strong,nonatomic)SkWtScrollview *skwtsc;
@property(strong,nonatomic)UILabel *lab;
-(void)upWithicon:(NSString *)imgname Withtitle:(NSString *)titlename Withdatas:(NSMutableArray *)datas WithTimes:(NSMutableArray *)times Withnowinfo:(NSString *)now Withflag:(NSString *)flag;
@end
