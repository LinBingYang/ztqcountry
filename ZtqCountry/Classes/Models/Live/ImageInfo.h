//
//  ImageInfo.h
//  hlrenTest
//
//  Created by blue on 13-4-23.
//  Copyright (c) 2013年 blue. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageInfo : NSObject<NSURLConnectionDelegate>

@property float width;
@property float height;
@property (nonatomic, strong) NSString * thumbURL;
@property (nonatomic, strong) NSString * userImg;
@property (nonatomic, assign) int zanNum;
@property (nonatomic, assign) int commentNum;
@property (nonatomic, assign) int forwardNum;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * des;//描述
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString * shareTime;
@property (nonatomic, strong) NSString * imageType;//1是名字
@property(nonatomic,strong)NSString *weather;
@property (nonatomic, strong) NSData * imageData;
@property (nonatomic, strong) NSData * userImageData;


@property(strong,nonatomic)UIImageView *imageview;

@property(strong,nonatomic)NSString *itemid;//条目id
@property(strong,nonatomic)NSString *click_type;//是否被用户点赞过

@property(nonatomic,retain)NSMutableData *mutableData;

-(id)initWithDictionary:(NSDictionary*)dictionary;
@end
