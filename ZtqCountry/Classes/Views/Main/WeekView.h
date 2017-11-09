//
//  WeekView.h
//  ztqFj
//
//  Created by Admin on 15/3/4.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekView : UIView
@property(strong,nonatomic)NSArray *valuearr;
@property(strong,nonatomic)NSArray *lowarr;
@property(assign)float maxhight,minlowt;
@property(strong,nonatomic)CAShapeLayer *hightlay,*lowlay;
-(void)gethights:(NSArray *)hights Withlowts:(NSArray *)lowts Withmax:(float)maxhight Withmin:(float)minlowt;
@end
