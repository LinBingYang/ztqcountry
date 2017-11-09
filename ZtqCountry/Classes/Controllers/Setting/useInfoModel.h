//
//  useInfoModel.h
//  WeatherForecast
//
//  Created by 黄 芦荣 on 13-4-7.
//  Copyright 2013 卓派. All rights reserved.
//

#import <Foundation/Foundation.h>
#define KUserName @"KUserName"
#define KUserPhoneNum @"KUserPhoneNum"
#define KUserPw @"KUserPw"
#define KUserID @"KUserID"

typedef enum {
	WrongPhoneNumError,	//手机号码输入有误
} PhoneNumErrorType;

@interface useInfoModel : NSObject {
	NSString *_userName;		//用户名
	NSString *_userPhoneNum;	//用户手机号码
	NSString *_userPw;			//密码
	
	NSString *_userID;		
	
}

@property (nonatomic, strong)NSString *userName;
@property (nonatomic, strong)NSString *userPhoneNum;
@property (nonatomic, strong)NSString *userPw;
@property (nonatomic, strong)NSString *userID;

+(useInfoModel *)shareduseInfoModel;

//检查aPhoneNum是否为正确的联通手机号码
+ (BOOL)phoneNumCheck:(NSString *)aPhoneNum withErrorType:(PhoneNumErrorType *)errorType;

//检查aPw是否为正确密码
+ (BOOL)pwCheck:(NSString *)aPw;

- (void)setUserPhoneNum:(NSString *)aPhoneNum;

@end
