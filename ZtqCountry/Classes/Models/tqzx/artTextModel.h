//
//  artTextModel.h
//  ZtqNew
//
//  Created by lihj on 12-7-3.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface artTextModel : NSObject {

	NSString *tid;//文章编号
	NSString *titles;//文章标题
	NSArray *icos;//图片列表
	NSString *txt;//文章内容
	NSString *pubt;//发布时间
	NSString *imgURL;
}

@property (nonatomic, strong)NSString *tid;
@property (nonatomic, strong)NSString *titles;
@property (nonatomic, strong)NSArray *icos;
@property (nonatomic, strong)NSString *txt;
@property (nonatomic, strong)NSString *pubt;
@property (nonatomic, strong)NSString *imgURL;

@end
