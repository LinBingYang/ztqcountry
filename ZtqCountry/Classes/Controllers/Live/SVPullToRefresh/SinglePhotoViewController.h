//
//  SinglePhotoViewController.h
//  ZtqCountry
//
//  Created by linxg on 14-8-8.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "BaseViewController.h"
#import "ImageInfo.h"
#import <MessageUI/MessageUI.h>
@interface SinglePhotoViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) ImageInfo * imageData;
@property (strong, nonatomic) UITableView * table;
@property (assign, nonatomic) int single;//1能点击 2不能点击

@property(strong,nonatomic)NSMutableArray *commentslist;//评论
@property(assign)BOOL isguanzhu;

-(id)initWithImageData:(ImageInfo *)imageData;

@end
