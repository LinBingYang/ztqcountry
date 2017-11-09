//
//  typhoonYearModel.h
//  ZtqNew
//
//  Created by lihj on 12-8-16.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface typhoonYearModel : NSObject {

	NSString *name;  //台风名称
	NSString *code;  //台风编号
	NSString *date;  //生成时间
	NSMutableArray *dotted_points;	//北京预测路线	
	NSMutableArray *dotted_1_points;	//东京预测路线
	NSMutableArray *dotted_2_points;	//福建预测路线
    NSMutableArray *dotted_3_points;//台湾预测路线
	NSMutableArray *ful_points;	//实线路径信息
}

@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *code;
@property (nonatomic, strong)NSString *date;
@property (nonatomic, strong)NSMutableArray *dotted_points;
@property (nonatomic, strong)NSMutableArray *dotted_1_points;
@property (nonatomic, strong)NSMutableArray *dotted_2_points;
@property (nonatomic, strong)NSMutableArray *dotted_3_points;
@property (nonatomic, strong)NSMutableArray *ful_points;  

@end
