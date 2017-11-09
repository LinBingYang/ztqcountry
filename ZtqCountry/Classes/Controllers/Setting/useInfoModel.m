//
//  useInfoModel.m
//  WeatherForecast
//
//  Created by 黄 芦荣 on 13-4-7.
//  Copyright 2013 卓派. All rights reserved.
//

#import "useInfoModel.h"


@implementation useInfoModel
@synthesize userName = _userName;
@synthesize userPhoneNum = _userPhoneNum;
@synthesize userPw = _userPw;
@synthesize userID = _userID;


static useInfoModel *useInfoModelSingleton = nil;
 
 + (useInfoModel *) shareduseInfoModel
 {
	 @synchronized(self)
	 {
		 if (!useInfoModelSingleton)
		{
			useInfoModelSingleton = [[useInfoModel alloc] init];
 
		}
		 return useInfoModelSingleton;
	 }
 }
 
 +(id) allocWithZone:(NSZone *)zone
 {  
	 @synchronized(self)
	 {      
		 if (useInfoModelSingleton == nil)
		 {  
			 useInfoModelSingleton = [super allocWithZone:zone];    
			 return useInfoModelSingleton;     
		 }
	 }  
	 return nil;
 }

- (id)init {
    self = [super init];
	if (self) {
		NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
		
		if ([sud objectForKey:KUserName])
			_userName = [[NSString alloc] initWithString:[sud objectForKey:KUserName]];
		if ([sud objectForKey:KUserPhoneNum])
			_userPhoneNum = [[NSString alloc] initWithString:[sud objectForKey:KUserPhoneNum]];
		if ([sud objectForKey:KUserPw])
			_userPw = [[NSString alloc] initWithString:[sud objectForKey:KUserPw]];
		if ([sud objectForKey:KUserID])
			_userID = [sud objectForKey:KUserID];
	}
	return self;
}

#pragma mark -

#pragma mark setter
- (void)setUserName:(NSString *)aName
{
		_userName = aName;
	
	NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
	[sud setObject:aName forKey:KUserName];
}

- (void)setUserPhoneNum:(NSString *)aPhoneNum
{
	
	_userPhoneNum = aPhoneNum;
	
	NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
	[sud setObject:aPhoneNum forKey:KUserPhoneNum];
}

- (void)setUserPw:(NSString *)aPw
{
	
	_userPw = aPw;
	
	NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
	[sud setObject:aPw forKey:KUserPw];
}

- (void)setUserID:(NSString *)aID
{
	
	if (_userID != nil) {
		
		_userID = nil;
	}
	_userID = aID;
	
	NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
	if (aID)
	{
		[sud setObject:aID forKey:KUserID];
	}
	else
	{
		[sud removeObjectForKey:KUserID];
	}
}

#pragma mark check
+ (BOOL)phoneNumCheck:(NSString *)aPhoneNum withErrorType:(PhoneNumErrorType *)errorType
{
	/**
	 * 手机号码
	 * 移动：134[0-8],135,136,137,138,139,150,151,152,157,158,159,182,187,188
	 * 联通：130,131,132,155,156,185,186
	 * 电信：133,1349,153,180,189
	 */
	NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
	//NSString *CU = @"^1(3[0-2]|5[56]|8[56])\\d{8}$";
	
	NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
	//NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
	
	if ([regextestmobile evaluateWithObject:aPhoneNum] == YES)
	{
		return YES;
	}
	else
	{
		PhoneNumErrorType error = -1;
		
		//if ([regextestcu evaluateWithObject:aPhoneNum] == NO)
			//error = NotUnicomNumError;
		
		if ([regextestmobile evaluateWithObject:aPhoneNum] == NO)
			error = WrongPhoneNumError;
		
		if (error != -1 && errorType != nil)
			*errorType = error;
		
		return NO;
	}
}

+ (BOOL)pwCheck:(NSString *)aPw
{
	//英文字母、数字组成，不小于6位
	NSString *PW = @"^[A-Za-z0-9]{6,16}$";
	
	NSPredicate *regextespw = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PW];
	
	return [regextespw evaluateWithObject:aPw];
}



@end
