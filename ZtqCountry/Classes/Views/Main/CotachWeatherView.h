//
//  CotachWeatherView.h
//  ZtqCountry
//
//  Created by Admin on 16/10/20.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@protocol Cotachdelegate <NSObject>
-(void)tqzxaction;
-(void)zjjdaction;
-(void)clickbtntagActionWithtag:(NSString *)tag withindex:(NSInteger)indextag;
@end
@interface CotachWeatherView : UIView
@property(strong,nonatomic)NSArray *lists;
@property(strong,nonatomic)UIImageView *bgimg;
@property (weak, nonatomic) id<Cotachdelegate>delegate;
@property(strong,nonatomic)NSMutableArray *titlearrs,*timearrs,*icoarrs;
- (id)initWithFrame:(CGRect)frame WithInfos:(NSArray *)lists;
-(void)getinfoslist:(NSMutableArray *)lists Withtqname:(NSString *)tqname Withzjname:(NSString *)zjname withcount:(int)count;
@end
