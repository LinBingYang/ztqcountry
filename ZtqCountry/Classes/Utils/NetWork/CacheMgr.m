//
//  CacheMgr.m
//  HttpTest
//
//  Created by on 11-12-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CacheMgr.h"


@implementation CacheMgr
static CacheMgr *cacheMgrSingleton = nil;

+ (CacheMgr*) sharedCacheMgr
{
	@synchronized(self)
	{
//		if (!cacheMgrSingleton)
//			cacheMgrSingleton = [[CacheMgr alloc] init];
//		return cacheMgrSingleton;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            cacheMgrSingleton = [[CacheMgr alloc]init];
        });
	}
    return cacheMgrSingleton;
}

//- (id) retain
//{
//    return self;	
//}
//
//- (NSUInteger) retainCount
//{
//    return NSUIntegerMax;  //denotes an object that cannot be released	
//}
//
//- (void) release
//{
//    //do nothing
//}

//- (id) autorelease
//{
//    return self;
//}

- (BOOL) check:(NSString *)tag
{//缓存是否过期
	NSString *appFile = [self fullPath:@"cacheTime.plist"];
	
//	NSMutableDictionary *t_dic = [[[NSMutableDictionary alloc] initWithContentsOfFile:appFile] autorelease];
    NSMutableDictionary *t_dic = [[NSMutableDictionary alloc] initWithContentsOfFile:appFile];
	if(t_dic == nil)
		return YES;
	else
	{
		NSString *timeIntervalText = [t_dic objectForKey:tag];	
		if (timeIntervalText == nil)
			return YES;
		NSTimeInterval cacheTime = [timeIntervalText intValue];
		
		NSDate *date = [NSDate date];
		NSTimeInterval nowTime = [date timeIntervalSince1970];//单位秒
		
		if (cacheTime <= nowTime)
			return YES;
	}
	return NO;
}

- (void) setCache:(NSData *)t_data tag:(NSString *)tag cache:(NSTimeInterval)cache;
{
	if (t_data == nil) {
		return;
	}
	
	NSString *appFile = [self fullPath:@"cache.plist"];
	NSMutableDictionary *t_dic = [[NSMutableDictionary alloc] initWithContentsOfFile:appFile];
	if(t_dic == nil)
		t_dic = [[NSMutableDictionary alloc] init];
	[t_dic setObject:t_data forKey:tag];
	[t_dic writeToFile:appFile atomically:NO];
//	[t_dic release];
	
	appFile = [self fullPath:@"cacheTime.plist"];
	t_dic = [[NSMutableDictionary alloc] initWithContentsOfFile:appFile];
	if(t_dic == nil)
		t_dic = [[NSMutableDictionary alloc] init];
	NSDate *date = [NSDate date];
	NSTimeInterval timeInterval = [date timeIntervalSince1970];
	timeInterval += cache;
	NSString *cacheTimeText = [NSString stringWithFormat:@"%f", timeInterval];
	[t_dic setObject:cacheTimeText forKey:tag];
	[t_dic writeToFile:appFile atomically:NO];
//	[t_dic release];
}

- (void) saveImage:(NSData *)data url:(NSString *)url cache:(NSTimeInterval)cache
{
	if (data == nil)
		return;
	NSRange t_range = [url rangeOfString:@"/" options:NSBackwardsSearch];
	NSString *t = [url substringWithRange:NSMakeRange(t_range.location+1, [url length]-t_range.location-1)];
	NSString *imageName = [NSString stringWithFormat:@"%@",t];
	NSString *appFile = [self fullPath:imageName];
	[data writeToFile:appFile atomically:NO];

	appFile = [self fullPath:@"cacheTime.plist"];
	NSMutableDictionary *t_dic = [[NSMutableDictionary alloc] initWithContentsOfFile:appFile];
	if(t_dic == nil)
		t_dic = [[NSMutableDictionary alloc] init];
	NSDate *date = [NSDate date];
	NSTimeInterval timeInterval = [date timeIntervalSince1970];
	timeInterval += cache;
	NSString *cacheTimeText = [NSString stringWithFormat:@"%f", timeInterval];
	[t_dic setObject:cacheTimeText forKey:url];
	[t_dic writeToFile:appFile atomically:NO];

}

- (NSData *) getCache:(NSString *)url
{
	NSString *appFile = [self fullPath:@"cache.plist"];
//	NSMutableDictionary *t_dic = [[[NSMutableDictionary alloc] initWithContentsOfFile:appFile] autorelease];
    NSMutableDictionary *t_dic = [[NSMutableDictionary alloc] initWithContentsOfFile:appFile];
	if(t_dic == nil)
		return nil;
	else
		return [t_dic objectForKey:url];
}

- (NSData *) getImage:(NSString *)url
{
	NSRange t_range = [url rangeOfString:@"/" options:NSBackwardsSearch];
	NSString *t = [url substringWithRange:NSMakeRange(t_range.location+1, [url length]-t_range.location-1)];
	NSString *imageName = [NSString stringWithFormat:@"%@",t];
	
	NSString *appFile = [self fullPath:imageName];
	NSData *data = [NSData dataWithContentsOfFile:appFile];
	return data;
}

- (void) clearCache:(NSString *)tag
{
	NSString *appFile = [self fullPath:@"cache.plist"];
	NSMutableDictionary *t_dic = [[NSMutableDictionary alloc] initWithContentsOfFile:appFile];
	if(t_dic == nil)
		t_dic = [[NSMutableDictionary alloc] init];
	[t_dic removeObjectForKey:tag];
	[t_dic writeToFile:appFile atomically:NO];
//	[t_dic release];
	
	appFile = [self fullPath:@"cacheTime.plist"];
	t_dic = [[NSMutableDictionary alloc] initWithContentsOfFile:appFile];
	if(t_dic == nil)
		t_dic = [[NSMutableDictionary alloc] init];
	[t_dic removeObjectForKey:tag];
	[t_dic writeToFile:appFile atomically:NO];
//	[t_dic release];
}

- (void) clearAllCache
{
	NSString* documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil];
	if (fileList == nil || [fileList count] == 0)
		return;
	
	for(int i=0; i<[fileList count]; i++)
	{
		NSString *filePath = [self fullPath:[fileList objectAtIndex:i]];
		if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
			[[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
	}
}

- (NSDate *) getCacheDate:(NSString *)tag
{
	NSString *appFile = [self fullPath:@"cacheTime.plist"];
	
//	NSMutableDictionary *t_dic = [[[NSMutableDictionary alloc] initWithContentsOfFile:appFile] autorelease];
    NSMutableDictionary *t_dic = [[NSMutableDictionary alloc] initWithContentsOfFile:appFile];
	if(t_dic == nil)
		return nil;
	else
	{
		NSString *timeIntervalText = [t_dic objectForKey:tag];	
		if (timeIntervalText == nil)
			return nil;
		NSTimeInterval cacheTime = [timeIntervalText intValue];
		
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:cacheTime];
		return date;
	}
	return nil;
}

- (NSString *) fullPath:(NSString *)fileName
{
	NSString* documentsDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	NSString* appFile = [NSString stringWithString:[documentsDirectory stringByAppendingPathComponent:fileName]];
	return appFile;
}

@end
