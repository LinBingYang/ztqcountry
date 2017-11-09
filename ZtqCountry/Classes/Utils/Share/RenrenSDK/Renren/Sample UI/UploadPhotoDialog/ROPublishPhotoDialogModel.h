//
//  ROPublishPhotoDialogModal.h
//  SimpleDemo
//
//  Created by Winston on 11-8-18.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "RODialogModel.h"
#import "Renren.h"
@class ROPublishPhotoInternal;
@protocol RenrenDelegate;

@interface ROPublishPhotoDialogModel : RODialogModel <RenrenDelegate>{
    UIImage *_photo;
    NSString *_caption;
    NSString *_userName;
    NSString *_headUrl;
    
    ROPublishPhotoInternal *_internal;
}
/**
 *准备上传的照片photo
 */
@property (nonatomic ,strong)UIImage *photo;
/**
 *上传照片的描述caption
 */
@property (nonatomic ,strong)NSString *caption;
/**
 *上传者的姓名
 */
@property (nonatomic ,strong)NSString *userName;
/**
 *上传者的头像
 */
@property (nonatomic ,strong)NSString *headUrl;

- (void)upload;

- (void)cancel;

@end
