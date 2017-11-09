//
//  CacheMgr.h
//  
//
//  Created by on 11-12-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CacheMgr : NSObject {
}

+ (CacheMgr*) sharedCacheMgr;

- (BOOL) check:(NSString *)tag;
- (void) setCache:(NSData *)t_data tag:(NSString *)tag cache:(NSTimeInterval)cache;
- (void) saveImage:(NSData *)data url:(NSString *)url cache:(NSTimeInterval)cache;
- (NSData *) getCache:(NSString *)tag;
- (NSData *) getImage:(NSString *)url;
- (void) clearCache:(NSString *)tag;
- (void) clearAllCache;
- (NSDate *) getCacheDate:(NSString *)tag;
- (NSString *) fullPath:(NSString *)fileName;

@end
