//
//  LYMark.h
//  ZtqCountry
//
//  Created by Admin on 15/7/3.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface LYMark : NSObject<MKAnnotation>
//实现MKAnnotation协议必须要定义这个属性
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
//标题
@property (nonatomic,copy) NSString *title;
@property (nonatomic, assign) NSInteger mTag;
@property(nonatomic,strong)NSString *iconame;
@property(nonatomic,strong)NSString *cityid;
//初始化方法
-(id)initWithCoordinate:(CLLocationCoordinate2D)c andTitle:(NSString*)t;

@end
