//
//  ShareFun.m
//  ZtqCountry
//
//  Created by 林炳阳	 on 14-6-30.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "ShareFun.h"
#import "ZipArchive.h"

NSString *URL_SERVER;
NSString *sharecontenturl;
BOOL isopendw;
NSMutableDictionary *g_iconWs = nil;
NSMutableDictionary *g_iconLs = nil;
NSMutableDictionary *g_bgImages = nil;
TreeNode *m_treeNodeProvince;
TreeNode *m_treeNodeAllCity;
TreeNode *m_treeNodelLandscape;
TreeNode *m_treeNodearea;
TreeNode *m_treeNodebirthcity;
TreeNode *m_treeNodebirthcountry;


@implementation ShareFun

+ (BOOL) isMobile:(NSString *)mobileNumbel{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }
    
    return NO;
}
+ (void) alertNotice:(NSString *)title withMSG:(NSString *)msg cancleButtonTitle:(NSString *)cancleTitle otherButtonTitle:(NSString *)otherTitle
{
	UIAlertView *alert;
	if([otherTitle isEqualToString:@""])
		alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancleTitle otherButtonTitles:nil,nil];
	else
		alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancleTitle otherButtonTitles:otherTitle,nil];
	[alert show];
    //	[alert release];
}

+ (NSDate *) NSStringToNSDate:(NSString *)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:string];
    //    [formatter release];
    return date;
}

+ (NSString *) NSDateToNSString:(NSDate *)date {
	
    //	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	//unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
	unsigned int unitFlags = NSDayCalendarUnit;
	NSDateComponents *comps = [gregorian components:unitFlags fromDate:date toDate:[NSDate date] options:0];
    
	int days = [comps day];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:kCFDateFormatterFullStyle];
	
	[dateFormatter setDateFormat:@"dd"];
	NSString *nowDD = [dateFormatter stringFromDate:[NSDate date]];
	int nowD = [nowDD intValue];
	
	[dateFormatter setDateFormat:@"dd"];
	NSString *udDD = [dateFormatter stringFromDate:date];
	int udD = [udDD intValue];
	
	[dateFormatter setDateFormat:@"HH:mm"];
	NSString *strDate = [dateFormatter stringFromDate:date];
    //	[dateFormatter release];
	
	if (udD == nowD && days == 0)
		return strDate;
	else if (days <= 1)
		return @"一天前";
	else if (days == 2)
		return @"两天前";
	else if (days == 3)
		return @"三天前";
	else if (days <= 14)
		return [NSString stringWithFormat:@"%d天前", days];
	else if (days <= 30)
		return @"半月前";
	else if (days <= 60)
		return @"一月前";
	else if (days <= 90)
		return @"两月前";
	else if (days <= 120)
		return @"三月前";
	else
		return @"很久前";
}

#pragma mark Encode Chinese to ISO8859-1 in URL
+ (NSString *) EncodeUTF8Str:(NSString *)encodeStr{
	CFStringRef nonAlphaNumValidChars = CFSTR("![                ]’()*+,-./:;=?@_~");
    //	NSString *preprocessedString = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodeStr, CFSTR(""), kCFStringEncodingUTF8);
    //    NSString *newStr = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingUTF8) autorelease];
    NSString *preprocessedString = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodeStr, CFSTR(""), kCFStringEncodingUTF8));
	NSString *newStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingUTF8));
    
	
	NSLog(@"EncodeUTF8Str = %@", newStr);
	return newStr;
}

#pragma mark Encode Chinese to GB2312 in URL
+ (NSString *) EncodeGB2312Str:(NSString *)encodeStr{
	CFStringRef nonAlphaNumValidChars = CFSTR("![                ]’()*+,-./:;=?@_~");
    //	NSString *preprocessedString = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodeStr, CFSTR(""), kCFStringEncodingGB_18030_2000);
    //	NSString *newStr = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingGB_18030_2000) autorelease];
    NSString *preprocessedString = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodeStr, CFSTR(""), kCFStringEncodingGB_18030_2000));
	NSString *newStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingGB_18030_2000));
	
	NSLog(@"EncodeGB2312Str = %@", newStr);
	return newStr;
}

+ (NSString *) fullPath4Document:(NSString *)t_fileName
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentpath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	
	if (documentpath == nil)
		return nil;
	
	if (t_fileName == nil || [t_fileName length] == 0)
		return documentpath;
	
	NSString* fullPath = [documentpath stringByAppendingString:[NSString stringWithFormat:@"/%@", t_fileName]];
	NSLog(@"fullPath = %@", fullPath);
	return fullPath;
}

+ (NSString *) fileName4Document:(NSString *)t_fullPath
{
	NSRange t_range = [t_fullPath rangeOfString:@"/" options:NSBackwardsSearch];
	NSString *fileName = [t_fullPath substringWithRange:NSMakeRange(t_range.location+1, [t_fullPath length]-t_range.location-1)];
	NSLog(@"filename = %@", fileName);
	
	return fileName;
}

+ (BOOL) fileExistInDocument:(NSString *)t_fileName
{
	return [[NSFileManager defaultManager] fileExistsAtPath:[ShareFun fullPath4Document:t_fileName]];
}

+ (NSString *) unzipInDocument:(NSString *)t_fileName
{
	if ([t_fileName hasSuffix:@".zip"] || [t_fileName hasSuffix:@".gzip"])
	{
		//待解压完整文件路径
		NSString* l_zipfile = [ShareFun fullPath4Document:t_fileName];
		
		//解压后地文件夹路径
		NSRange t_range = [t_fileName rangeOfString:@"." options:NSBackwardsSearch];
		NSString *pathName = [t_fileName substringWithRange:NSMakeRange(0, t_range.location)];
		NSString* unzipPath = [ShareFun fullPath4Document:pathName];
		
		ZipArchive* zip = [[ZipArchive alloc] init];
		if( [zip UnzipOpenFile:l_zipfile] )
		{
			BOOL ret = [zip UnzipFileTo:unzipPath overWrite:YES];
			if( NO==ret )
			{
			}
			[zip UnzipCloseFile];
		}
        //		[zip release];
		
		return unzipPath;
	}
	return nil;
}
+ (NSString *) unzipToDocument:(NSString *)t_fileName
{
	NSString *t_path = [NSString stringWithString:t_fileName];
	if ([t_path hasSuffix:@".zip"] || [t_path hasSuffix:@".gzip"])
	{
		NSRange t_range = [t_path rangeOfString:@"." options:NSBackwardsSearch];
		t_path = [t_path substringWithRange:NSMakeRange(0, t_range.location)];
		
		
		
		//待解压完整文件路径
		NSString *l_zipfile= [[NSBundle mainBundle] pathForResource:t_path ofType:@"zip"];
		
		//解压后地文件夹路径
		NSString* unzipPath = [ShareFun fullPath4Document:t_path];
		
		ZipArchive* zip = [[ZipArchive alloc] init];
		if( [zip UnzipOpenFile:l_zipfile] )
		{
			BOOL ret = [zip UnzipFileTo:unzipPath overWrite:YES];
			if( NO==ret )
			{
			}
			[zip UnzipCloseFile];
		}
        //		[zip release];
		
		return unzipPath;
	}
	
	return nil;
}
//uisearchview cleancolor
+(void)cleanBackground:(UISearchBar*)search{
    for (UIView *subview in search.subviews)
	{
		if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
		{
			[subview removeFromSuperview];
			break;
		}
	}//*/
    if ([search respondsToSelector: @selector (barTintColor)]) {
        
        [[[[search.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
        [search setBarTintColor:[UIColor clearColor]];
    }
    
}
//获取文本高度
+ (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
	float fPadding = 16.0; // 8.0px x 2
	CGSize constraint = CGSizeMake(textView.contentSize.width - fPadding, CGFLOAT_MAX);
	CGSize size = [strText sizeWithFont: textView.font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	float fHeight = size.height + 16.0;
	return fHeight;
}

+ (UIImage *) captureView:(UIView *)theView
{
	//CGRect rect = theView.frame;
	UIGraphicsBeginImageContext(theView.bounds.size);
	//CGContextRef context = UIGraphicsGetCurrentContext();
	[theView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return img;
}

+ (UIImage *) captureScreen
{
    
    UIWindow *screenWindow = [[UIApplication sharedApplication].delegate window];
    CGRect rect=screenWindow.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL)
    {
        return nil;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    [screenWindow.layer renderInContext:context];
    CGContextRestoreGState(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//nsstring nsdata互相转换
+(NSString *)stringFromdata:(NSData *)data
{
    return [[NSString alloc] initWithData:data encoding:NSUTF32StringEncoding];
    
}
+(NSData *)dataFromstring:(NSString *)string{
    return [string dataUsingEncoding: NSUTF8StringEncoding];
}

+(NSString*)localVersion{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    return appVersion;
}

+ (BOOL) isNight
{
//	NSDate *t_current = [NSDate date];
    long long time=[setting sharedSetting].systime.doubleValue;
    NSDate *t_current = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *t_day = [dateFormatter stringFromDate:t_current];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSDate *t_morning = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 06:40", t_day]];
	NSDate *t_night = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 18:30", t_day]];
    //	[dateFormatter release];
	
	if ([[t_current earlierDate:t_night] isEqualToDate:t_current]&& [[t_current laterDate:t_morning] isEqualToDate:t_current])
		return NO;
	
	return YES;
    
}


+ (HL_Temperature)timeRules
{
    
//    NSDate *t_current = [NSDate date];
    long long time=[setting sharedSetting].systime.doubleValue;
    NSDate *t_current = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *t_day = [dateFormatter stringFromDate:t_current];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSDate *t_morning = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 06:40", t_day]];
	NSDate *t_night = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 18:30", t_day]];
    NSDate *t_zero = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 00:00", t_day]];
    if(([t_current isEqualToDate:t_zero]||[[t_current laterDate:t_zero] isEqualToDate:t_current])&&[[t_current earlierDate:t_morning] isEqualToDate:t_current])
    {
        return Morning;
    }else
        if(([t_current isEqualToDate:t_morning]||[[t_current laterDate:t_morning] isEqualToDate:t_current])&&[[t_current earlierDate:t_night] isEqualToDate:t_current])
        {
            return Noon;
        }
        else
        {
            return Evening;
        }
    //    NSDate *
    //    NSData *t_zero = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 00:00",t_day]];
    //	[dateFormatter release];
    // if([t_current ])
    //    else if([[t_current laterDate:t_morning]isEqualToDate:t_current]&&[[t_current earlierDate:t_night] isEqualToDate:t_current])
    //    {
    //        return Noon;
    //    }
    //    else if([[t_current laterDate:t_morning]isEqualToDate:t_current]&&[[t_current earlierDate:t_night] isEqualToDate:t_current])
    //    {
    //        return Evening;
    //    }

}
+ (AppDelegate *) shareAppDelegate
{
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	return appDelegate;
}
+ (NSString *) makeImageUrlStr:(NSString *)t_imgName
{
//	NSString *urlStr = [NSString stringWithFormat:@"http://218.85.78.125:8099/ftp/%@",t_imgName];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.fjqxfw.cn:8099/ftp/%@",t_imgName];
	//NSLog(@"image URL = %@", urlStr);
	return urlStr;
}
+ (NSURL *) makeImageUrl:(NSString *)t_imgName
{
	//NSLog(@"==>imageUrl:%@", [self makeImageUrlStr:t_imgName]);
	NSURL *url = [NSURL URLWithString:[self makeImageUrlStr:t_imgName]];
	return url;
}
//2014-06-13 10:57
+(NSDate *)dateWithString:(NSString *)dateString
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate * date = [dateFormatter dateFromString:dateString];
    return date;
}

+(NSString *)stringWithDate:(NSDate *)date
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString * dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

+(NSString *)compareCurrentTime:(NSString *)compareDate
{
    NSString * dateStr = [[NSString alloc] init];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate * compare = [dateFormatter dateFromString:compareDate];
    NSTimeInterval timeInterval = [compare timeIntervalSinceNow];
    timeInterval = -timeInterval;
    int temp = timeInterval/60/60/24;
    if(temp >=1)
    {
        dateStr = [NSString stringWithFormat:@"%d天前",temp];
    }
    else
    {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        dateStr = [dateFormatter stringFromDate:compare];
    }
    return dateStr;
}
+ (void) openUrl:(NSString *)t_url
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[t_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}
+(float)heihtForyuntu{
    float hegth;
    if (iPhone5) {
        hegth=455;
        return hegth;
    }else{
    hegth=366;
        return hegth;
    }
}



+(UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+(NSDictionary *)readSingleShareInfo
{
    NSArray * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filePath = [path objectAtIndex:0];
    NSString * plistPath = [filePath stringByAppendingString:@"singleShare.plist"];
    NSDictionary * singleShareInfo = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    return singleShareInfo;
}

+(void)writeSingleShareInfo:(NSDictionary *)infoDic
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSArray * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filePath = [path objectAtIndex:0];
    NSString * plistPaht = [filePath stringByAppendingString:@"singleShare.plist"];
    if(![fileManager fileExistsAtPath:plistPaht])
    {
        [fileManager createFileAtPath:plistPaht contents:nil attributes:nil];
        NSArray * shareInfos = [[NSArray alloc] initWithObjects:infoDic, nil];
        NSMutableDictionary * allUserShareDic = [[NSMutableDictionary alloc] init];
        [allUserShareDic setObject:shareInfos forKey:@"info"];
        [allUserShareDic writeToFile:plistPaht atomically:YES];
    }
    else
    {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:[ShareFun readUserShareInfo]];
        NSArray * shareInfos = [dic objectForKey:@"info"];
        NSMutableArray * newShareInfos = [[NSMutableArray alloc] initWithArray:shareInfos];
        [newShareInfos insertObject:infoDic atIndex:0];
        [dic setObject:newShareInfos forKey:@"info"];
        [dic writeToFile:plistPaht atomically:YES];
    }
    
}

+(NSDictionary *)readUserShareInfo
{
    NSArray * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filePath = [path objectAtIndex:0];
    NSString * plistPaht = [filePath stringByAppendingString:@"userShare.plist"];
    NSDictionary * shareInfo = [NSDictionary dictionaryWithContentsOfFile:plistPaht];
    return shareInfo;
}

+(void)writeShareInfoWithInfo:(NSDictionary *)infoDic withUserName:(NSString *)userName
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSArray * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filePath = [path objectAtIndex:0];
    NSString * plistPaht = [filePath stringByAppendingString:@"userShare.plist"];
    if(![fileManager fileExistsAtPath:plistPaht])
    {
        [fileManager createFileAtPath:plistPaht contents:nil attributes:nil];
        NSArray * shareInfos = [[NSArray alloc] initWithObjects:infoDic, nil];
        NSMutableDictionary * allUserShareDic = [[NSMutableDictionary alloc] init];
        [allUserShareDic setObject:shareInfos forKey:userName];
        [allUserShareDic writeToFile:plistPaht atomically:YES];
    }
    else
    {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:[ShareFun readUserShareInfo]];
        NSArray * keys = [dic allKeys];
        for(int i=0;i<keys.count;i++)
        {
            NSString * key = [keys objectAtIndex:i];
            if([key isEqualToString:userName])
            {
                NSArray * oneUserShares = [dic objectForKey:key];
                NSMutableArray * oneUserNewShares = [[NSMutableArray alloc] initWithArray:oneUserShares];
                [oneUserNewShares insertObject:infoDic atIndex:0];
                [dic setObject:oneUserNewShares forKey:userName];
            }
            else
            {
                NSMutableArray * oneUserNewShares = [[NSMutableArray alloc] init];
                [oneUserNewShares addObject:infoDic];
                [dic setObject:oneUserNewShares forKey:userName];
            }
            
        }
        [dic writeToFile:plistPaht atomically:YES];
    }
}
//ios解析json NSData <--->NSDictionary
+(NSDictionary *)jsonWithData:(NSData*)t_data{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:t_data options:kNilOptions error:&error];
    return json;
    
}
+ (NSString *)encryptWithText:(NSString *)sText withkey:(NSString *)key
{
    return [self encrypt:sText encryptOrDecrypt:kCCEncrypt key:key];
}

+ (NSString *)decryptWithText:(NSString *)sText withkey:(NSString *)key
{
    return [self encrypt:sText encryptOrDecrypt:kCCDecrypt key:key];
}
//+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key
//{
//    
////    char keyPtr[kCCKeySizeAES256+1];
////    bzero(keyPtr, sizeof(keyPtr));
////    
////    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
////    
////    NSData *decryptData = [GTMBase64 decodeData:[sText dataUsingEncoding:NSUTF8StringEncoding]];
////    NSUInteger dataLength = [decryptData length];
////    
////    size_t bufferSize = dataLength + kCCBlockSizeAES128;
////    void *buffer = malloc(bufferSize);
////    
////    size_t numBytesDecrypted = 0;
////    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
////                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
////                                          keyPtr, kCCBlockSizeDES,
////                                          NULL,
////                                          [decryptData bytes], dataLength,
////                                          buffer, bufferSize,
////                                          &numBytesDecrypted);
////    
////    if (cryptStatus == kCCSuccess) {
////        NSData *data=[NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
////        NSString *str=[GTMBase64 stringByEncodingData:data];
////        return str;
////    }
////    
////    free(buffer);
////    return nil;
//    
//    const void *vplainText;
//    size_t plainTextBufferSize;
//    
//    if (encryptOperation == kCCDecrypt)
//    {
//        NSData *decryptData = [GTMBase64 decodeData:[sText dataUsingEncoding:NSUTF8StringEncoding]];
//        plainTextBufferSize = [decryptData length];
//        vplainText = [decryptData bytes];
//    }
//    else
//    {
//        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
//        plainTextBufferSize = [encryptData length];
//        vplainText = (const void *)[encryptData bytes];
//    }
//    
//    CCCryptorStatus ccStatus;
//    uint8_t *bufferPtr = NULL;
//    size_t bufferPtrSize = 0;
//    size_t movedBytes = 0;
//    
//    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
//    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
//    memset((void *)bufferPtr, 0x0, bufferPtrSize);
//    
//    NSString *initVec = @"";
//    const void *vkey = (const void *) [key UTF8String];
//    const void *vinitVec = (const void *) [initVec UTF8String];
//    
//    ccStatus = CCCrypt(encryptOperation,
//                       kCCAlgorithm3DES,
//                       kCCOptionPKCS7Padding,
//                       vkey,
//                       kCCKeySize3DES,
//                       vinitVec,
//                       vplainText,
//                       plainTextBufferSize,
//                       (void *)bufferPtr,
//                       bufferPtrSize,
//                       &movedBytes);
//    
//    NSString *result = nil;
//    
//    if (encryptOperation == kCCDecrypt)
//    {
//        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
//    }
//    else
//    {
//        NSData *data = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
//        result = [GTMBase64 stringByEncodingData:data];
//    }
//    
//    return result;
//}
+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key
{
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递过来的是decrypt 解码
    {
        //解码 base64
        NSData *decryptData = [GTMBase64 decodeData:[sText dataUsingEncoding:NSUTF8StringEncoding]];//转成utf-8并decode
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    /*
     DES加密 ：用CCCrypt函数加密一下，然后用base64编码下，传过去
     DES解密 ：把收到的数据根据base64，decode一下，然后再用CCCrypt函数解密，得到原本的数据
     */
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    NSString *initIv = @"12345678";
    const void *vkey = (const void *) [key UTF8String];
    const void *iv = (const void *) [initIv UTF8String];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithmDES,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,  //密钥    加密和解密的密钥必须一致
                       kCCKeySizeDES,//   DES 密钥的大小（kCCKeySizeDES=8）
                       iv, //  可选的初始矢量
                       dataIn, // 数据的存储单元
                       dataInLength,// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //得到解密出来的data数据，改变为utf-8的字符串
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding] ;
    }
    else //encryptOperation==0  （加密过程中，把加好密的数据转成base64的）
    {
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [GTMBase64 stringByEncodingData:data];
    }
    
    return result;

}
//32位MD5加密方式
+(NSString *)getMd5_32Bit_String:(NSString *)srcString{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}
+(NSString *)returnFormatString:(NSString *)str
{
    return [str stringByReplacingOccurrencesOfString:@" "withString:@" "];
}
@end
