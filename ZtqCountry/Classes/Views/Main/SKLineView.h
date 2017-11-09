//
//  SKLineView.h
//  ZtqCountry
//
//  Created by Admin on 15/6/26.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKScrollview.h"
@interface SKLineView : UIView<UIScrollViewDelegate>
@property(strong,nonatomic)NSArray *valuearr;
@property(strong,nonatomic)NSArray *icons;
@property(strong,nonatomic)NSArray *times;
@property(strong,nonatomic)NSString  *maxhight,*minlowt,*nowct,*flag;
@property(strong,nonatomic)UIScrollView *mscro;
@property(strong,nonatomic)UIImageView *t_img;
@property(assign)float nextvalue;
@property(assign)BOOL isscroll;//是否滚动
@property(strong,nonatomic)UILabel *nowlab,*maxlab,*minlab,*nowctlab,*signlab;
@property(strong,nonatomic)SKScrollview *skscrol;
-(void)getValues:(NSArray *)values  withtimes:(NSArray *)times Withmax:(NSString *)maxhight Withmin:(NSString *)minlowt withnowct:(NSString *)ct withflag:(NSString *)flag;
@end
