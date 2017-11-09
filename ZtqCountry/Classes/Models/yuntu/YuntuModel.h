//
//  YuntuModel.h
//  ztq_heilj
//
//  Created by linxg on 12-9-11.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YuntuModel : NSObject {
	NSString *time;
	NSString *url;
	NSData *imageData;
}


@property (nonatomic, strong)NSString *time;
@property (nonatomic, strong)NSString *url;
@property (nonatomic, strong)NSData *imageData;
@end
