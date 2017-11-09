//
//  AutoShareViewController.h
//  ZtqCountry
//
//  Created by linxg on 14-7-21.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "BaseViewController.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "TCWBEngine.h"

@interface AutoShareViewController : BaseViewController<SinaWeiboDelegate, SinaWeiboRequestDelegate>
{
    SinaWeibo		*_sinaweibo;
    TCWBEngine      *_TCWeibo;
}

@end
