//
//  HourWtScrollview.h
//  ZtqCountry
//
//  Created by Admin on 15/7/15.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HourWtScrollview : UIView<UIScrollViewDelegate>
@property(strong,nonatomic)NSArray *valuearr,*rains;
@property(strong,nonatomic)NSArray *icons;
@property(strong,nonatomic)NSArray *times;
@property(strong,nonatomic)NSString  *maxhight,*minlowt,*nowct,*maxrain,*minrain;
@property(strong,nonatomic)UIScrollView *mscro;
@property(strong,nonatomic)UIImageView *t_img;
@property(assign)float nextvalue;
@property(nonatomic, strong)NSMutableArray *windDircationValues,  *windValues,* weatherValues;
@property(assign)CGFloat obrandious;
@property(assign)BOOL isscroll;//是否滚动
@property(strong,nonatomic)UILabel *nowlab,*maxlab,*minlab,*nowctlab,*signlab;
@property(nonatomic, strong)UILabel *rainValue;
@property(strong,nonatomic)CAShapeLayer *templay,*rainlay;
-(void)gethights:(NSArray *)wd Withicons:(NSArray *)icons withtimes:(NSArray *)times Withmax:(NSString *)maxhight Withmin:(NSString *)minlowt withnowct:(NSString *)ct withrains:(NSArray *)rains withrainmax:(NSString *)rainmax withrainmin:(NSString *)rainmin withWeatherValue:(NSMutableArray *)weatherValues winddir:(NSMutableArray *)winddir windpow:(NSMutableArray *)windpow;
//- (void)addBezierThroughPoints:(NSArray *)pointArray;
@end
