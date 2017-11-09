//
//  ShareFun.h
//  ZtqCountry
//
//  Created by 林炳阳	 on 14-6-30.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetXMLData.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>
typedef enum : NSUInteger {
    Morning = 0,
    Noon,
    Evening,
} HL_Temperature;
@interface ShareFun : NSObject

extern NSString *URL_SERVER;
extern NSMutableDictionary *g_iconWs;  //加载图标
extern NSMutableDictionary *g_iconLs;  //生活指数图标
extern NSMutableDictionary *g_bgImages;
extern TreeNode *m_treeNodeProvince;
extern TreeNode *m_treeNodeAllCity;
extern TreeNode *m_treeNodelLandscape;
extern TreeNode *m_treeNodearea;
extern TreeNode *m_treeNodebirthcity;
extern TreeNode *m_treeNodebirthcountry;
extern NSString *sharecontenturl;
extern BOOL isopendw;
//提示框
+ (void) alertNotice:(NSString *)title withMSG:(NSString *)msg
   cancleButtonTitle:(NSString *)cancleTitle
	otherButtonTitle:(NSString *)otherTitle;

+ (AppDelegate *) shareAppDelegate;

+ (NSDate *) NSStringToNSDate:(NSString *)string;
+ (NSString *) NSDateToNSString:(NSDate *)date;
//发送短信
+ (int) sendSMS:(NSString *)t_num withContent:(NSString *)t_content;

//编码转换
+ (NSString *) EncodeUTF8Str:(NSString *)encodeStr;
+ (NSString *) EncodeGB2312Str:(NSString *)encodeStr;

//获取document目录下 文件名之完整文件路径
+ (NSString *) fullPath4Document:(NSString *)t_fileName;
//获取document目录下 完整文件路径之文件名
+ (NSString *) fileName4Document:(NSString *)t_fullPath;
//判断document目录下 是否存在文件名
+ (BOOL) fileExistInDocument:(NSString *)t_fileName;
//解压文件a.zip(a.zip需在document目录下)
+ (NSString *) unzipInDocument:(NSString *)t_fileName;
//解压文件a.zip(a.zip为安装包自带)
+ (NSString *) unzipToDocument:(NSString *)t_fileName;


//截取theView图片
+ (UIImage *) captureView:(UIView *)theView;
//截取屏幕图片
+ (UIImage *) captureScreen;


//nsstring nsdata互相转换
+(NSString *)stringFromdata:(NSData *)data;
+(NSData *)dataFromstring:(NSString *)string;



//uisearchview cleancolor
+(void)cleanBackground:(UISearchBar*)search;
//本地版本
+(NSString*)localVersion;
//根据文本动态调整UITextView高度
+ (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText;

+(float)heihtForyuntu;

//判断是白天还是夜晚
+ (BOOL) isNight;
//高低温时间规则
+ (HL_Temperature)timeRules;

//根据图片名称生成完整下载地址
+ (NSString *) makeImageUrlStr:(NSString *)t_imgName;
+ (NSURL *) makeImageUrl:(NSString *)t_imgName;
//打开网页
+ (void) openUrl:(NSString *)t_url;

////获取客户端用户编号
//-(void)initApp;



//字符串转时间
+(NSDate *)dateWithString:(NSString *)dateString;
+(NSString *)stringWithDate:(NSDate *)date;
+(NSString *)compareCurrentTime:(NSString *)compareDate;

+(UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size;

//用户数据读取及写入
+(NSDictionary *)readUserShareInfo;
+(void)writeShareInfoWithInfo:(NSDictionary *)infoDic withUserName:(NSString *)userName;

+(NSDictionary *)readSingleShareInfo;
+(void)writeSingleShareInfo:(NSDictionary *)infoDic;

//解析json NSData <--->NSDictionary
+(NSDictionary *)jsonWithData:(NSData*)t_data;
+ (NSString *)encryptWithText:(NSString *)sText withkey:(NSString *)key;//加密
 + (NSString *)decryptWithText:(NSString *)sText withkey:(NSString *)key;//解密
+(NSString *)getMd5_32Bit_String:(NSString *)srcString;
+ (BOOL) isMobile:(NSString *)mobileNumbel;//手机号码
+(NSString *)returnFormatString:(NSString *)str;//空格替换
@end
