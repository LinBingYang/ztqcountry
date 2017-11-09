//
//  HourLineView.h
//  ZtqCountry
//
//  Created by Admin on 15/6/15.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hourscrollview.h"
@interface HourLineView : UIView<UIScrollViewDelegate>
@property(strong,nonatomic)NSArray *valuearr;
@property(strong,nonatomic)NSArray *icons;
@property(strong,nonatomic)NSArray *times;
@property(strong,nonatomic)NSString  *maxhight,*minlowt,*nowct;
@property(strong,nonatomic)UIScrollView *mscro;
@property(strong,nonatomic)UIImageView *t_img;
@property(assign)float nextvalue;
@property(strong,nonatomic)hourscrollview *hscrllview;
@property(assign)BOOL isscroll;//是否滚动
@property(strong,nonatomic)UILabel *nowlab,*maxlab,*minlab,*nowctlab,*signlab;
-(void)gethights:(NSArray *)wd Withicons:(NSArray *)icons withtimes:(NSArray *)times Withmax:(NSString *)maxhight Withmin:(NSString *)minlowt withnowct:(NSString *)ct;
@end
