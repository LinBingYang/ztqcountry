//
//  EGOImageLoadQueue.h
//  ZtqNew
//
//  Created by wang zw on 12-12-6.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EGOImageLoadQueueDelegate <NSObject>

@optional

- (void)aLoadConnectionDidFinishLoading:(NSData *)imgDta andTag:(NSInteger)aTag;
- (void)aLoadConnection:(NSInteger)aTag didFailWithError:(NSError *)error;

@end

@interface EGOImageLoadQueue : NSObject {
	__weak id<EGOImageLoadQueueDelegate> delegate;
	NSOperationQueue *downQueue;
}

@property (nonatomic, weak)id<EGOImageLoadQueueDelegate> delegate;

- (void)clearCacheForURL:(NSURL*)aURL;
- (void)addDownImageWithURL:(NSURL *)aURL andTag:(NSInteger)aTag;
- (void)cancel;

@end
