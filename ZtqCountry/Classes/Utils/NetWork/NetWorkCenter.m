//
//  NetWorkCenter.m
//  ZtqCountry
//
//  Created by linxg on 14-6-11.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "NetWorkCenter.h"
#import "NetWork.h"
#import "CacheMgr.h"
#import "NSDictionary+UrlEncodedString.h"
#import "SBJson.h"

@interface NetWorkCenter ()
@property (strong, nonatomic) NSMutableArray * postArr;
@property (strong, nonatomic) NSMutableArray * getArr;
@property (strong, nonatomic) SBJsonParser * jsonParser;
@end

static NetWorkCenter * shareCenter = nil;
@implementation NetWorkCenter

+(id)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareCenter = [[NetWorkCenter alloc] init];
    });
    return shareCenter;
}


-(id)init{
    self = [super init];
    if(self){
        self.postArr = [[NSMutableArray alloc] init];
        self.getArr = [[NSMutableArray alloc] init];
        self.jsonParser = [[SBJsonParser alloc] init];
    }
    return self;
}



-(void)postHttpWithUrl:(NSString *)url
             withParam:(NSDictionary *)param
              withFlag:(int)flag
           withSuccess:(void (^)(NSDictionary * returnData))success
           withFailure:(void (^)(NSError * error))failure
             withCache:(BOOL)cache
{
    NSString *cacheTag;
	if (param != nil)
		cacheTag =[NSString stringWithFormat:@"%@", [param urlEncodedStringCustom]];
	else
		cacheTag = url;
//    NSLog(@"#####################cacheTag = %@#",cacheTag);
    //    if(cache){
    //        //取缓存数据
    //        if (![[CacheMgr sharedCacheMgr] check:cacheTag] && [[CacheMgr sharedCacheMgr] getCache:cacheTag] != nil){
    //            NSData *t_data = [[CacheMgr sharedCacheMgr] getCache:cacheTag];
    //			NSString *t_str = [[NSString alloc] initWithData:t_data encoding:NSUTF8StringEncoding];
    //			NSDictionary *resultDict = [self.jsonParser objectWithString:t_str];
    //            if(resultDict != nil){
    //                NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:resultDict];
    //                [dic setObject:@"YES" forKey:@"isCacheData"];
    //                success(dic);
    //            }
    //        }
    //    }
    NetWork * netWork = [[NetWork alloc] init];
//    NSLog(@"$$$$$$$netWork = %@$$$$$$$$$$$$",netWork);
    [netWork postHttpWithUrl:url withParma:param withFlag:flag withSuccess:success withFailure:failure withCache:cache];
}
//先读缓存，再下载，更新两次
-(void)getCacheAndPostHttpWithUrl:(NSString *)url
                        withParam:(NSDictionary *)param
                         withFlag:(int)flag
                      withSuccess:(void(^)(NSDictionary * returnData))success
                      withFailure:(void(^)(NSError * error))failure
                        withCache:(BOOL)cache
{
    //
    NSString * cacheTag;
    NSMutableDictionary * retuInfo = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * newB = [[NSMutableDictionary alloc] init];
    [retuInfo setObject:newB forKey:@"b"];
    if(param != nil)
    {
        NSDictionary * b = [param objectForKey:@"b"];
        NSArray * keys = [b allKeys];
        for(int i=0;i<keys.count;i++)
        {
            NSString * key = [keys objectAtIndex:i];
            //传入的 yjxx_index
            NSDictionary * keyInfo =[b objectForKey:key];
            if(keyInfo != nil)
            {
                NSString * newKey = [[key componentsSeparatedByString:@"#"] objectAtIndex:0];
                NSDictionary * newParam = [[NSDictionary alloc] initWithObjectsAndKeys:keyInfo,newKey, nil];
                NSString * cacheTag = [NSString stringWithFormat:@"%@",[newParam urlEncodedStringCustom]];
                //取缓存数据
                if (![[CacheMgr sharedCacheMgr] check:cacheTag] && [[CacheMgr sharedCacheMgr] getCache:cacheTag] != nil)
                {
                    NSData *t_data = [[CacheMgr sharedCacheMgr] getCache:cacheTag];
                    NSString *t_str = [[NSString alloc] initWithData:t_data encoding:NSUTF8StringEncoding];
                    NSDictionary *resultDict = [self.jsonParser objectWithString:t_str];
                    id value = [resultDict objectForKey:newKey];
                    if (value!=nil) {
                        [newB setObject:value forKey:key];
                    }
                    NSLog(@"$$$$$$$$%@##",resultDict);
                }
            }
        }
        if(retuInfo != nil){
            NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:retuInfo];
            NSLog(@"##%@##",dic);
            [dic setObject:@"YES" forKey:@"isCacheData"];
            success(dic);
        }
    }
    else
    {
        cacheTag = url;
        if (![[CacheMgr sharedCacheMgr] check:cacheTag] && [[CacheMgr sharedCacheMgr] getCache:cacheTag] != nil){
            NSData *t_data = [[CacheMgr sharedCacheMgr] getCache:cacheTag];
            NSString *t_str = [[NSString alloc] initWithData:t_data encoding:NSUTF8StringEncoding];
            NSDictionary *resultDict = [self.jsonParser objectWithString:t_str];
            if(resultDict != nil){
                NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:resultDict];
                [dic setObject:@"YES" forKey:@"isCacheData"];
                success(dic);
            }
        }
        
    }
    NetWork * netWork = [[NetWork alloc] init];
    [netWork postHttpWithUrl:url withParma:param withFlag:flag withSuccess:success withFailure:failure withCache:cache];
    
    
    
    
    
    
    
    //    NSString *cacheTag;
    //	if (param != nil)
    //		cacheTag =[NSString stringWithFormat:@"%@", [param urlEncodedStringCustom]];
    //	else
    //		cacheTag = url;
    //    NSLog(@"#####################cacheTag = %@#",cacheTag);
    //
    //    //取缓存数据
    //    if (![[CacheMgr sharedCacheMgr] check:cacheTag] && [[CacheMgr sharedCacheMgr] getCache:cacheTag] != nil){
    //        NSData *t_data = [[CacheMgr sharedCacheMgr] getCache:cacheTag];
    //        NSString *t_str = [[NSString alloc] initWithData:t_data encoding:NSUTF8StringEncoding];
    //        NSDictionary *resultDict = [self.jsonParser objectWithString:t_str];
    //        if(resultDict != nil){
    //            NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:resultDict];
    //            [dic setObject:@"YES" forKey:@"isCacheData"];
    //            success(dic);
    //        }
    //    }
    //
    //    NetWork * netWork = [[NetWork alloc] init];
    //    [netWork postHttpWithUrl:url withParma:param withFlag:flag withSuccess:success withFailure:failure withCache:cache];
    
}
//读缓存，有数据就不下载
-(void)getCacheWithUrl:(NSString *)url
             withParam:(NSDictionary *)param
              withFlag:(int)flag
           withSuccess:(void(^)(NSDictionary * returnData))success
           withFailure:(void(^)(NSError * error))failure
             withCache:(BOOL)cache
{
    
    NSString * cacheTag;
    NSMutableDictionary * retuInfo = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * newB = [[NSMutableDictionary alloc] init];
    [retuInfo setObject:newB forKey:@"b"];
    if(param != nil)
    {
        NSDictionary * b = [param objectForKey:@"b"];
        NSArray * keys = [b allKeys];
        for(int i=0;i<keys.count;i++)
        {
            NSString * key = [keys objectAtIndex:i];
            //传入的 yjxx_index
//            读取参数 b的value
            NSDictionary * keyInfo =[b objectForKey:key];
            if(keyInfo != nil)
            {
                //去除# 生成新key
                NSString * newKey = [[key componentsSeparatedByString:@"#"] objectAtIndex:0];
                //拼接新的参数，这个是保存的数据的关键字，没有#
                NSDictionary * newParam = [[NSDictionary alloc] initWithObjectsAndKeys:keyInfo,newKey, nil];
                NSString * cacheTag = [NSString stringWithFormat:@"%@",[newParam urlEncodedStringCustom]];
                //取缓存数据
                if (![[CacheMgr sharedCacheMgr] check:cacheTag] && [[CacheMgr sharedCacheMgr] getCache:cacheTag] != nil)
                {
                    NSData *t_data = [[CacheMgr sharedCacheMgr] getCache:cacheTag];
                    NSString *t_str = [[NSString alloc] initWithData:t_data encoding:NSUTF8StringEncoding];
                    NSDictionary *resultDict = [self.jsonParser objectWithString:t_str];
                    id value = [resultDict objectForKey:newKey];
                    if (value!=nil) {
                        [newB setObject:value forKey:key];
                    }
//                    NSLog(@"$$$$$$$$%@##",resultDict);
                }
                else
                {
                    NetWork * netWork = [[NetWork alloc] init];
                    [netWork postHttpWithUrl:url withParma:param withFlag:flag withSuccess:success withFailure:failure withCache:cache];
                    return;
                }
            }
        }
        if(retuInfo != nil){
            NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:retuInfo];
            NSLog(@"##%@##",dic);
            [dic setObject:@"YES" forKey:@"isCacheData"];
            success(dic);
        }
        else
        {
            NetWork * netWork = [[NetWork alloc] init];
            [netWork postHttpWithUrl:url withParma:param withFlag:flag withSuccess:success withFailure:failure withCache:cache];
        }
    }
    else
    {
        cacheTag = url;
        if (![[CacheMgr sharedCacheMgr] check:cacheTag] && [[CacheMgr sharedCacheMgr] getCache:cacheTag] != nil){
            NSData *t_data = [[CacheMgr sharedCacheMgr] getCache:cacheTag];
            NSString *t_str = [[NSString alloc] initWithData:t_data encoding:NSUTF8StringEncoding];
            NSDictionary *resultDict = [self.jsonParser objectWithString:t_str];
            if(resultDict != nil){
                NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:resultDict];
                [dic setObject:@"YES" forKey:@"isCacheData"];
                success(dic);
            }
        }
        else
        {
            NetWork * netWork = [[NetWork alloc] init];
            [netWork postHttpWithUrl:url withParma:param withFlag:flag withSuccess:success withFailure:failure withCache:cache];
        }
        
    }
    
}

-(void)getHttpWithUrl:(NSString *)url
             withFlag:(int)flag
          withSuccess:(void (^)(NSDictionary * returnData))success
          withFailure:(void (^)(NSError * error))failure
            withCache:(BOOL)cache{
    NetWork * netWork = [[NetWork alloc] init];
    [netWork getHttpWithUrl:url withFlag:flag withSuccess:success withFailure:failure withCache:cache];
    
}

-(void)postImageWithUrl:(NSString *)url
              withParam:(NSDictionary *)param
               withFlag:(int)flag
            withSuccess:(void (^)(NSData *))success
            withFailure:(void (^)(NSError *))failure
              withCache:(BOOL)cache
{
    NSString *cacheTag;
	if (param != nil)
		cacheTag =[NSString stringWithFormat:@"%@", [param urlEncodedStringCustom]];
	else
		cacheTag = url;
    NSLog(@"#####################cacheTag = %@#",cacheTag);
    if(cache){
        //取缓存数据
        if (![[CacheMgr sharedCacheMgr] check:cacheTag] && [[CacheMgr sharedCacheMgr] getImage:cacheTag] != nil){
            NSData *t_data = [[CacheMgr sharedCacheMgr] getImage:cacheTag];
            if (t_data != nil)
            {
                success(t_data);
            }
        }
        
    }
    NetWork * netWork = [[NetWork alloc] init];
    [netWork postImageWithUrl:url withParam:param withFlag:flag withSuccess:success withFailure:failure withCache:cacheTag];
    
}


-(void)postVersionWithSuccess:(void (^)(NSDictionary *))success withFailure:(void (^)(NSError *))failure
{
    NetWork * netWork = [[NetWork alloc] init];
    [netWork postVersionWithSuccess:success withFailure:failure];
}




@end
