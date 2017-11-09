//
//  SJKPmodel.h
//  ZtqCountry
//
//  Created by Admin on 14-10-21.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJKPmodel : NSObject{
    
	NSString *des;
	NSString *address;
	NSString *weather;
	NSString *userImageUrl;
	NSString *praise;
	NSArray *images;
    NSString *userid;
    NSString *commentcount;//评论数
    NSString *forwardcount;//转发数
}

@property (nonatomic, strong)NSString *des;
@property (nonatomic, strong)NSString *address;
@property (nonatomic, strong)NSString *weather;
@property (nonatomic, strong)NSString *userImageUrl;
@property (nonatomic, strong)NSString *praise;
@property (nonatomic, strong)NSArray *images;
@property (nonatomic, strong)NSString *userid;
@property (nonatomic, strong)NSString *commentcount;
@property (nonatomic, strong)NSString *forwardcount;

@end
