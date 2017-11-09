//
//  RiLiView.h
//  ZtqCountry
//
//  Created by Admin on 16/10/20.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LunarDB.h"
#import "Calendar.h"
#import "EGOImageView.h"
@protocol RiLidelegate <NSObject>
-(void)rilibtnAction;
@end
@interface RiLiView : UIView{
    LunarDB *m_lunarDB;
    Calendar *m_calendar;
    NSDate *m_currentDate;
    NSArray *nstr1;
}
@property(strong,nonatomic)EGOImageView *rl_img;
@property (weak, nonatomic) id<RiLidelegate>delegate;
@property(strong,nonatomic)UIImageView *tbgimg;
@end
