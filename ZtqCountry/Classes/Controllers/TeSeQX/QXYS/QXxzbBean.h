//
//  QXxzbBean.h
//  ZtqCountry
//
//  Created by 胡彭飞 on 2017/1/13.
//  Copyright © 2017年 yyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "CustomSheet.h"
@protocol QXzxbJSObjectProtocol <JSExport>
-(void)commitPicture:(NSString *)message1;
-(void)commit:(NSString *)message1 Movice:(NSString *)message2;
//-(void)TestOneParameter:(NSString *)message;
//-(void)TestTowParameter:(NSString *)message1 SecondParameter:(NSString *)message2;
-(void)my:(NSString *)message1 Share:(NSString *)message2;
-(void)shareUrl:(NSString *)url AndContent:(NSString *)content;

@end
@interface QXxzbBean : NSObject<QXzxbJSObjectProtocol>
@property(nonatomic,copy) NSString *userID;
@property(nonatomic,copy) NSString *activityID;
@property(nonatomic,strong) CustomSheet *acsheetview;
-(NSString *)JsGetDatasFromApp;
@end
