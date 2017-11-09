//
//  QXxzbBean.m
//  ZtqCountry
//
//  Created by 胡彭飞 on 2017/1/13.
//  Copyright © 2017年 yyf. All rights reserved.
//

#import "QXxzbBean.h"
#import "NSDictionary+UrlEncodedString.h"
@implementation QXxzbBean
-(void)commit:(NSString *)message1 Movice:(NSString *)message2{
//    NSLog(@"点击了上传按钮%@,%@",message1,message2);
    _userID=message1;
    _activityID=message2;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReciviceQXxzbBeanData" object:@{@"userID":message1,@"activityID":message2}];

}
-(void)commitPicture:(NSString *)message1{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"ReciviceQXxzbBeanPictureData" object:@{@"activityID":message1}];
}
-(void)my:(NSString *)message1 Share:(NSString *)message2
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReciviceWebBeanData" object:@{@"act_id":message1,@"share_type":message2}];
    
    
}
-(void)shareUrl:(NSString *)Shareurl AndContent:(NSString *)Sharecontent{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReciviceWebBeanDataURLandContent" object:@{@"Shareurl":Shareurl,@"Sharecontent":Sharecontent}];
    
    
}
-(NSString *)JsGetDatasFromApp
{
    NSDictionary *locationaddresss=[[NSUserDefaults standardUserDefaults] objectForKey:@"formattedAddress"];
    
    NSMutableDictionary *datas=[NSMutableDictionary dictionary];
    [datas setObject:locationaddresss forKey:@"locationaddress"];
    [datas setObject:[ShareFun localVersion] forKey:@"appVersion"];
    [datas setObject:[setting getSysUid] forKey:@"imei"];
    [datas setObject:[setting sharedSetting].currentCity forKey:@"xianshiid"];
    [datas setObject:[setting sharedSetting].currentCityID forKey:@"currentCityID"];
    [datas setObject:@"知天气公众版" forKey:@"appType"];
    NSString *jsonDatas=[datas urlEncodedStringCustom];
    return jsonDatas;
}
@end
