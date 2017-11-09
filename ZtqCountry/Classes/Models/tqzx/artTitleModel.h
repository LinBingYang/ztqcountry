//
//  artTitleModel.h
//  ZtqNew
//
//  Created by lihj on 12-7-3.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface artTitleModel : NSObject {
	NSString *tid;//文章编号
	NSString *title;//文章标题
	NSString *type;//文章类型
	NSString *desc;//间断描述
	NSString *pubt;//发布时间
	NSString *ico;//缩略图
	NSString *url;//连接
    NSString *small_ico;//缩率图
    NSString *big_cio;//大图
}

@property (nonatomic, strong)NSString *tid;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *type;
@property (nonatomic, strong)NSString *desc;
@property (nonatomic, strong)NSString *pubt;
@property (nonatomic, strong)NSString *ico;
@property (nonatomic, strong)NSString *url;
@property(nonatomic,strong)NSString *small_ico;
@property(nonatomic,strong)NSString *big_ico;

@end
