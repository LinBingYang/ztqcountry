//
//  mainVCmainVModel.h
//  ZtqNew
//
//  Created by wang zw on 12-6-18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SstqModel.h"
#import "FcModel.h"
#import "tipModel.h"

@interface mainVCmainVModel : NSObject {

	SstqModel *sstq;  //实时天气
	NSArray *fcModelArray;  //一周天气
	NSArray *tipModelArray;  //提示信息
}

@property(nonatomic, strong)SstqModel *sstq;  //实时天气
@property(nonatomic, strong)NSArray *fcModelArray;  //一周天气
@property(nonatomic, strong)NSArray *tipModelArray;  //提示信息

@end
