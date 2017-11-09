//
//  WBShareKey.h
//  WBShareKit
//
//  Created by Gao Semaus on 11-8-8.
//  Copyright 2011年 Chlova. All rights reserved.
//

typedef enum {
    InvalidType = 0,
    Sina,
    Tencent,
    RenrenShare
} WBShareType;

#define WeiboMaxWordCount 140

//新浪
#define SINAAPPKEY @"3779491882" //设置sina appkey
#define SINAAPPSECRET @"2150b7d2f94e41566589b554a2bdf637"
#define CallBackURL @"http://sns.whalecloud.com/sina2/callback" 

//腾讯
#define WiressSDKDemoAppKey     @"801119897"
#define WiressSDKDemoAppSecret  @"d7cd456fe3208824fbbaf4b65bfd20b6"
#define REDIRECTURI             @"http://weather.ikan365.cn"

//人人
#define kAPP_ID     @"217104"
#define kAPI_Key    @"e5978f6b221a465a9d6635249b6c32b5"
