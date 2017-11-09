//
//  EGOImageLoadQueue.m
//  ZtqNew
//
//  Created by wang zw on 12-12-6.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "EGOImageLoadQueue.h"
#import "EGOCache.h"

@implementation EGOImageLoadQueue

@synthesize delegate;

- (id)init
{
	if((self = [super init])) {
		downQueue = [[NSOperationQueue alloc] init];
		//[downQueue setMaxConcurrentOperationCount:1];
	}
	
	return self;
}

- (void)dealloc
{
	self.delegate = nil;
	[downQueue cancelAllOperations];
//	[downQueue release];
//	[super dealloc];
}

- (NSString *)keyForURL:(NSURL *)aURL
{
	return [NSString stringWithFormat:@"EGOImageLoadQueue-%u", [[aURL description] hash]];
}

- (void)successCallBack:(NSDictionary *)dic
{
	if([self.delegate respondsToSelector:@selector(aLoadConnectionDidFinishLoading:andTag:)]) {
		[self.delegate aLoadConnectionDidFinishLoading:[dic objectForKey:@"imgData"] andTag:[[dic objectForKey:@"aTag"] intValue]];
	}
}

- (void)failedCallBack:(NSDictionary *)dic
{
	if([self.delegate respondsToSelector:@selector(aLoadConnection:didFailWithError:)]) {
		[self.delegate aLoadConnection:[[dic objectForKey:@"aTag"] intValue] didFailWithError:[dic objectForKey:@"error"]];
	}
}

#pragma mark public action
- (void)clearCacheForURL:(NSURL*)aURL
{
	[[EGOCache currentCache] removeCacheForKey:[self keyForURL:aURL]];
}

- (void)addDownImageWithURL:(NSURL *)aURL andTag:(NSInteger)aTag
{
	NSBlockOperation *getImage = [NSBlockOperation blockOperationWithBlock:^{
		NSError *error;
		NSData *imgData;
		imgData = [[EGOCache currentCache] dataForKey:[self keyForURL:aURL]];
		
		if (imgData)
		{
			NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:imgData, @"imgData", [NSNumber numberWithInt:aTag], @"aTag", nil];
			
			[self performSelectorOnMainThread:@selector(successCallBack:) withObject:argDic waitUntilDone:YES];
		}
		else
		{
			imgData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:aURL] returningResponse:nil error:&error];
			
			if (imgData)
			{
				[[EGOCache currentCache] setData:imgData forKey:[self keyForURL:aURL]];
				NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:imgData, @"imgData", [NSNumber numberWithInt:aTag], @"aTag", nil];
				
				[self performSelectorOnMainThread:@selector(successCallBack:) withObject:argDic waitUntilDone:YES];
			}
			else
			{
				NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:error, @"error", [NSNumber numberWithInt:aTag], @"aTag", nil];
				
				[self performSelectorOnMainThread:@selector(failedCallBack:) withObject:argDic waitUntilDone:YES];
			}
		}
	}];
	
	[downQueue addOperation:getImage];
}

- (void)cancel
{
	[downQueue cancelAllOperations];
}

@end
