//
//  NetWorkCenter.h
//  ZtqCountry
//
//  Created by linxg on 14-6-11.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkCenter : NSObject

+(id)share;

//先读缓存，再下载，更新两次
-(void)getCacheAndPostHttpWithUrl:(NSString *)url
             withParam:(NSDictionary *)param
              withFlag:(int)flag
           withSuccess:(void(^)(NSDictionary * returnData))success
           withFailure:(void(^)(NSError * error))failure
             withCache:(BOOL)cache;

//读缓存，有数据就不下载
-(void)getCacheWithUrl:(NSString *)url
             withParam:(NSDictionary *)param
              withFlag:(int)flag
           withSuccess:(void(^)(NSDictionary * returnData))success
           withFailure:(void(^)(NSError * error))failure
             withCache:(BOOL)cache;
//只下载，不读缓存
-(void)postHttpWithUrl:(NSString *)url
             withParam:(NSDictionary *)param
              withFlag:(int)flag
           withSuccess:(void(^)(NSDictionary * returnData))success
           withFailure:(void(^)(NSError * error))failure
             withCache:(BOOL)cache;

//-(void)getHttpWithUrl:(NSString *)url
//             withFlag:(int)flag
//          withSuccess:(void(^)(NSDictionary * returnData))success
//          withFailure:(void(^)(NSError * error))failure
//            withCache:(BOOL)cache;

-(void)postImageWithUrl:(NSString *)url
              withParam:(NSDictionary *)param
               withFlag:(int)flag
            withSuccess:(void(^)(NSData * returnData))success
            withFailure:(void(^)(NSError * error))failure
              withCache:(BOOL)cache;

-(void)postVersionWithSuccess:(void(^)(NSDictionary * returnData))success
                  withFailure:(void(^)(NSError * error))failure;


@end
