//
//  NetWork.h
//  ZtqCountry
//
//  Created by linxg on 14-6-11.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWork : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property (strong, nonatomic) void(^success)(NSDictionary * dataDic);
@property (strong, nonatomic) void(^failure)(NSError * error);
@property (strong, nonatomic) void(^imageSuccess)(NSData * data);



-(void)postHttpWithUrl:(NSString *)url
             withParma:(NSDictionary *)param
              withFlag:(int)flag
           withSuccess:(void(^)(NSDictionary * returnData))success
           withFailure:(void(^)(NSError * error))failure
             withCache:(BOOL)cache;

-(void)getHttpWithUrl:(NSString *)url
             withFlag:(int)flag
          withSuccess:(void(^)(NSDictionary * returnData))success
          withFailure:(void(^)(NSError * error))failure
            withCache:(BOOL)cache;

-(void)postImageWithUrl:(NSString *)url
              withParam:(NSDictionary *)param
               withFlag:(int)flag
            withSuccess:(void(^)(NSData * returnData))success
            withFailure:(void(^)(NSError * error))failure
              withCache:(BOOL)cache;

-(void)getImageWithUrl:(NSString *)url
              withFlag:(int)flag
           withSuccess:(void(^)(NSData * returnData))success
           withFailure:(void(^)(NSError * error))failure
             withCache:(BOOL)cache;

-(void)postVersionWithSuccess:(void(^)(NSDictionary * returnData))success
                  withFailure:(void(^)(NSError * error))failure;
@end
