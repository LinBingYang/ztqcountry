//
//  CommentViewController.h
//  ztqFj
//
//  Created by Admin on 15-1-16.
//  Copyright (c) 2015年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageInfo.h"
@interface CommentViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) ImageInfo * imageData;
@property (strong, nonatomic) UITableView * table;
@property (assign, nonatomic) int single;//1能点击 2不能点击 点赞
@property(assign,nonatomic)int t_count;//加载页数
@property(strong,nonatomic)NSMutableArray *commentslist;//评论
@property(assign)BOOL isguanzhu;
@property(assign)BOOL isdianzan, isclickgood;
@property (strong, nonatomic) UIScrollView * backgroundScrollView;
@property(strong,nonatomic)NSString *tvtext;

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property(nonatomic,strong)NSMutableArray *imagedatas;//
@property(assign)int page;
@property(nonatomic,strong)NSString *grtype;
@property (nonatomic,strong)UIScrollView *scroll;
@property (nonatomic,strong)UIImageView *imageView;
@property(nonatomic,assign)float myheight;

//用户昵称和头像  (2016.10.10新增)
@property(nonatomic,strong) NSString *head_url;
@property(nonatomic,copy) NSString *nickname;

-(id)initWithImageData:(ImageInfo *)imageData;
-(id)initWithImageData:(ImageInfo *)imageData with:(NSString *)type;
@end
