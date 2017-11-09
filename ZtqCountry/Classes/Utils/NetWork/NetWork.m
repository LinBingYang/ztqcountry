//
//  NetWork.m
//  ZtqCountry
//
//  Created by linxg on 14-6-11.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "NetWork.h"
#import "NSDictionary+UrlEncodedString.h"
#import "SBJson.h"
#import "CacheMgr.h"

@interface NetWork ()
@property (strong, nonatomic) NSMutableData * returnData;
@property (assign, nonatomic) BOOL cache;
@property (strong, nonatomic) NSString * url;
@property (strong, nonatomic) NSDictionary * param;
@property (assign, nonatomic) BOOL isImage;

@end

@implementation NetWork


-(void)postHttpWithUrl:(NSString *)url
             withParma:(NSDictionary *)param
              withFlag:(int)flag
           withSuccess:(void (^)(NSDictionary * returnData))success
           withFailure:(void (^)(NSError * error))failure
             withCache:(BOOL)cache
{
    self.isImage = NO;
    self.success = success;
    self.failure = failure;
    self.cache = cache;
    self.url = url;
    self.param = param;
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.timeoutInterval=10.0;
    request.HTTPMethod = @"POST";
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    NSString * paramString =[NSString stringWithFormat:@"p=%@", [param urlEncodedStringCustom]];
    request.HTTPBody = [paramString dataUsingEncoding:NSUTF8StringEncoding];
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

-(void)getHttpWithUrl:(NSString *)url
             withFlag:(int)flag
          withSuccess:(void (^)(NSDictionary * returnData))success
          withFailure:(void (^)(NSError * error))failure
            withCache:(BOOL)cache
{
    self.isImage = NO;
    self.success = success;
    self.failure = failure;
}

-(void)getImageWithUrl:(NSString *)url
              withFlag:(int)flag
           withSuccess:(void (^)(NSData *))success
           withFailure:(void (^)(NSError *))failure
             withCache:(BOOL)cache
{
    
}


-(void)postImageWithUrl:(NSString *)url
              withParam:(NSDictionary *)param
               withFlag:(int)flag
            withSuccess:(void (^)(NSData *))success
            withFailure:(void (^)(NSError *))failure
              withCache:(BOOL)cache
{
    self.isImage = YES;
    self.imageSuccess = success;
    self.failure = failure;
    self.cache = cache;
    self.url = url;
    self.param = param;
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSString * paramStr = [param urlEncodedStringCustom];
    [request setHTTPBody:[paramStr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

-(void)postVersionWithSuccess:(void (^)(NSDictionary *))success withFailure:(void (^)(NSError *))failure
{
    self.success = success;
    self.failure = failure;
    NSURL * url = [NSURL URLWithString:@"http://itunes.apple.com/lookup?id=548561548"];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10];
    //    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    
    NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection start];
}


#pragma mark -
#pragma mark -NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.returnData = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.returnData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(self.isImage)
    {
        if(self.cache){
            NSString *cacheTag;
            if (self.param != nil){
                cacheTag =[NSString stringWithFormat:@"%@", [self.param urlEncodedStringCustom]];
            }
            else{
                cacheTag = self.url;
            }
            [[CacheMgr sharedCacheMgr] saveImage:self.returnData url:cacheTag cache:3*24*60*60];
        }
        if(self.imageSuccess){
            self.imageSuccess(self.returnData);
        }
    }
    else
    {
        NSString * resultStr = [[NSString alloc] initWithData:self.returnData encoding:NSUTF8StringEncoding];
        SBJsonParser * parser = [[SBJsonParser alloc] init];
        NSDictionary * resultDic = [parser objectWithString:resultStr];
        NSDictionary * resultB = [resultDic objectForKey:@"b"];
//        NSLog(@"^^^^^^^^^^^^^^^^^^^%@^",resultDic);
        if(self.cache){
            //            NSString *cacheTag;
            //            if (self.param != nil){
            //                cacheTag =[NSString stringWithFormat:@"%@", [self.param urlEncodedStringCustom]];
            //            }
            //            else{
            //                cacheTag = self.url;
            //            }
            //       		[[CacheMgr sharedCacheMgr] setCache:self.returnData tag:cacheTag cache:60 * 10];
            
            
            
            if(self.param != nil)
            {
                NSDictionary * b = [self.param objectForKey:@"b"];
                NSArray * keys = [b allKeys];
                NSDictionary * infoB = [resultDic objectForKey:@"b"];
                for(int i=0;i<keys.count;i++)
                {
                    //旧的key有#
                    NSString * key = [keys objectAtIndex:i];
                    //传入的 yjxx_index
                    NSDictionary * keyInfo =[b objectForKey:key];
                    if(keyInfo != nil)
                    {
                        NSString * newKey = [[key componentsSeparatedByString:@"#"] objectAtIndex:0];
                        NSDictionary * newParam = [[NSDictionary alloc] initWithObjectsAndKeys:keyInfo,newKey, nil];
                        NSString * cacheTag = [NSString stringWithFormat:@"%@",[newParam urlEncodedStringCustom]];
                        
                        NSDictionary * bChildren = [resultB objectForKey:key];
                        NSDictionary * acaheDic = [[NSDictionary alloc] initWithObjectsAndKeys:bChildren,newKey, nil];
                        //缓存数据
                        NSString * dicStr = [acaheDic urlEncodedStringCustom];
                        if (dicStr.length>0) {
                            [[CacheMgr sharedCacheMgr] setCache:[dicStr dataUsingEncoding:NSUTF8StringEncoding] tag:cacheTag cache:60*24*60*3];
                        }

                        //                        if (![[CacheMgr sharedCacheMgr] check:cacheTag] && [[CacheMgr sharedCacheMgr] getCache:cacheTag] != nil)
                        //                        {
                        //                            NSData *t_data = [[CacheMgr sharedCacheMgr] getCache:cacheTag];
                        //                            NSString *t_str = [[NSString alloc] initWithData:t_data encoding:NSUTF8StringEncoding];
                        //                            NSDictionary *resultDict = [self.jsonParser objectWithString:t_str];
                        //                            id value = [resultDict objectForKey:newKey];
                        //                            [newB setObject:value forKey:key];
                        //                        }
                    }
                }
                
            }
            else
            {
                NSString *  cacheTag = self.url;
                [[CacheMgr sharedCacheMgr] setCache:self.returnData tag:cacheTag cache:60 * 24*60*3];
            }
            
            
        }
        if(self.success){
            NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:resultDic];
            [dic setObject:@"NO" forKey:@"isCacheData"];
            self.success(dic);
        }
        
    }
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",self.failure);
    if(self.failure){
        self.failure(error);
    }
}

@end
