//
//  ROPublishPhotoRequestParam.h
//  Renren Open-platform
//
//  Created by xiawenhai on 11-8-17.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RORequestParam.h"


@interface ROPublishPhotoRequestParam : RORequestParam {
	UIImage *_imageFile;
	NSString *_caption;
	NSString *_albumID;
	NSString *_placeID;
}

/**
 *照片文件
 */
@property (strong,nonatomic)UIImage *imageFile;

/**
 *照片的描述信息
 */
@property (strong,nonatomic)NSString *caption;

/**
 *相册的ID
 */
@property (strong,nonatomic)NSString *albumID;

/**
 *地点的ID
 */
@property (strong,nonatomic)NSString *placeID;

@end
