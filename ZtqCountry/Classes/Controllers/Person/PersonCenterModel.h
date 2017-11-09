//
//  PersonCenterModel.h
//  ZtqCountry
//
//  Created by Admin on 14-10-17.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonCenterModel : NSObject{
    
	NSString *des;
	NSString *address;
	NSString *weather;
	NSString *datetime;
	NSString *praise;
	NSArray *images;
}

@property (nonatomic, strong)NSString *des;
@property (nonatomic, strong)NSString *address;
@property (nonatomic, strong)NSString *weather;
@property (nonatomic, strong)NSString *datetime;
@property (nonatomic, strong)NSString *praise;
@property (nonatomic, strong)NSArray *images;


@end
