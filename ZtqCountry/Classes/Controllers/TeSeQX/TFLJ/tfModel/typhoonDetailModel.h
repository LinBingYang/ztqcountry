//
//  typhoonDetailModel.h
//  ZtqNew
//
//  Created by lihj on 12-8-16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface typhoonDetailModel : NSObject {

	NSString *fl;  //风力
	NSString *fl_10;  //10级风圈
	NSString *fl_7;	//7级风圈
	NSString *fs;	//未知
	NSString *fs_max;  //未知
	NSString *jd;	//经度
	NSString *qy;	//气压
	NSString *time;	//台风时间
	NSString *tip;	//路径表达
	NSString *wd;	//纬度
    NSString *ydss;//移动时速
    NSString *qx;//气旋
}

@property (nonatomic, strong)NSString *fl;
@property (nonatomic, strong)NSString *fl_10;
@property (nonatomic, strong)NSString *fl_7;
@property (nonatomic, strong)NSString *fs;
@property (nonatomic, strong)NSString *fs_max;
@property (nonatomic, strong)NSString *jd;
@property (nonatomic, strong)NSString *qy;
@property (nonatomic, strong)NSString *time;
@property (nonatomic, strong)NSString *tip;
@property (nonatomic, strong)NSString *wd;
@property(nonatomic,strong)NSString *ydss;
@property(nonatomic,strong)NSString *qx;

@end
