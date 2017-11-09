//
//  HDWebJSbean.h
//  ztqFj
//
//  Created by 胡彭飞 on 2017/1/20.
//  Copyright © 2017年 yyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
@protocol HDwebJSObjectProtocol<JSExport>
-(void)my:(NSString *)message1 Share:(NSString *)message2;


@end
@interface HDWebJSbean : NSObject<HDwebJSObjectProtocol>

@end
