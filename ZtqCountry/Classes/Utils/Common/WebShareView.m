//
//  WebShareView.m
//  ztqFj
//
//  Created by Admin on 16/11/9.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import "WebShareView.h"
#import "UIColor+utils.h"
#import "weiboVC.h"
#define sheetHeight 100
@interface WebShareView ()

@property (strong, nonatomic) UIView * sheetScrollView;
@property(nonatomic,copy) NSString *title;
@end
@implementation WebShareView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)creatViewWithButtonNum:(int)num
{
    //半透明黑色遮挡层
    UIView * barrierView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    barrierView.backgroundColor = [UIColor blackColor];
    barrierView.alpha = 0.3;
    [self addSubview:barrierView];
    //添加手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [barrierView addGestureRecognizer:tap];
    _sheetBgView = [[UIImageView alloc] init];
    //    UIImage * image = [UIImage imageNamed:@"fx框.png"];
    //    _sheetBgView.image = image;
    _sheetBgView.backgroundColor=[UIColor whiteColor];
    _sheetBgView.userInteractionEnabled = YES;
    _sheetBgView.layer.shadowColor = [UIColor grayColor].CGColor;
    _sheetBgView.layer.shadowRadius = 0.5;
    _sheetBgView.layer.cornerRadius = 3;
    _sheetBgView.layer.masksToBounds = YES;
    _sheetBgView.frame = CGRectMake(10, kScreenHeitht/2-50, kScreenWidth-20, sheetHeight);
    //    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(50, 0, 0, 0)];
    
    [self addSubview:_sheetBgView];
    

    
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 120, 25)];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textColor = [UIColor blackColor];
    //    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont systemFontOfSize:13];
    _titleLab.text = self.title;
    //    _titleLab.centerX=kScreenWidth*0.5;
    [_sheetBgView addSubview:_titleLab];
    
    
    UIButton * cancleBut = [[UIButton alloc] initWithFrame:CGRectMake(0, sheetHeight-35, kScreenWidth-2, 34)];
    [cancleBut setBackgroundImage:[UIImage imageNamed:@"fx取消按钮.png"] forState:UIControlStateNormal];
    [cancleBut setBackgroundImage:[UIImage imageNamed:@"fx取消按钮点击.png"] forState:UIControlStateHighlighted];
    [cancleBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleBut setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleBut addTarget:self action:@selector(cancleButAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [_sheetBgView addSubview:cancleBut];
}


-(void)cancleButAction:(UIButton *)sender
{
    [self hide];
}

-(id)initWithTitle:(NSString *)title withButImages:(NSArray *)imageNames withHightLightImage:(NSArray *)hightlightimg withButTitles:(NSArray *)titles withDelegate:(id)delegate
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeitht)];
    if(self){
        [self creatViewWithButtonNum:(int)imageNames.count];
        float margin = 20;//边距
        float spacing = 20;//每个按钮的间隔
        float scale = 50;//每个按钮的大小
        if(imageNames.count){
            for(int i=0;i<imageNames.count;i++){
                int line;//行
                int column;//列
                line = i/4;
                column = i%4;
                UIButton * but = [[UIButton alloc] initWithFrame:CGRectMake(margin+(spacing+scale)*column, 25+60*line, scale, scale)];
                but.tag = i;
                [but setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
                [but setImage:[UIImage imageNamed:hightlightimg[i]] forState:UIControlStateHighlighted];
                [but addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
                [_sheetBgView addSubview:but];
            }
        }
        if(titles.count){
            for(int i=0;i<titles.count;i++){
                int line;//行
                int column;//列
                line = i/4;
                column = i%4;
                UILabel * butTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(margin+(spacing+scale)*column ,75+75*line, scale,20)];
                butTitleLab.textAlignment = NSTextAlignmentCenter;
                butTitleLab.backgroundColor = [UIColor clearColor];
                butTitleLab.textColor = [UIColor blackColor];
                butTitleLab.font = [UIFont systemFontOfSize:13];
                butTitleLab.text = titles[i];
                [_sheetBgView addSubview:butTitleLab];
                if(i>=imageNames.count){
                    break;
                }
            }
        }
    }
    return self;
}

-(id)initDefaultWithTitle:(NSString *)title WithShareContext:(NSString *)sharecontxt subtitile:(NSString *)subtitile WithShareimg:(UIImage *)shareimg WithControllview:(UIViewController*)delegatevc
{
    self.shareStr= sharecontxt;
    self.title=title;
    self.shareimg=shareimg;
    self.mydelegate=delegatevc;
    if (subtitile != nil) {
        self.subtitle = subtitile;
    }
    NSArray * images = [[NSArray alloc] initWithObjects:@"微信图标",@"朋友圈图标",@"新浪微博图标",@"QQ空间图标", nil];
    NSMutableArray * titles = [[NSMutableArray alloc] initWithObjects:@"微信",@"朋友圈",@"微博",@"QQ空间",nil];
    return  [self initWithTitle:title withButImages:images withHightLightImage:nil withButTitles:titles withDelegate:delegatevc];
}

-(void)butAction:(UIButton *)sender
{
    
    [self ShareSheetClickWithIndexPath:sender.tag];
    [self hide];
    //    self.hidden=YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shareDownAndChange" object:nil];
}
-(void)ShareSheetClickWithIndexPath:(NSInteger)indexPath
{
    NSString *shareContent = self.shareStr;
    switch (indexPath)
    {
        case 2: {
            weiboVC *t_weibo = [[weiboVC alloc] initWithNibName:@"weiboVC" bundle:nil];
            [t_weibo setShareText:shareContent];
            [t_weibo setShareImage:@"weiboShare.png"];
            [t_weibo setShareType:1];
            [self.mydelegate presentViewController:t_weibo animated:YES completion:nil];
            //			[t_weibo release];
            break;
        }
            
                    case 0:{
//                        //创建分享消息对象
//                        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//            
//                        //创建图片内容对象
//                        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
//                        //如果有缩略图，则设置缩略图
//                        [shareObject setShareImage:self.shareimg];
//            
//                        //分享消息对象设置分享内容对象
//                        messageObject.shareObject = shareObject;
                        NSString *url;
                        if ([self.shareStr rangeOfString:@"http"].location!=NSNotFound) {
                            NSArray *arr=[self.shareStr componentsSeparatedByString:@"http"];
                            if (arr.count>0) {
                                url=[NSString stringWithFormat:@"http%@",arr[1]];
                            }
                        }
                        if (url.length<=0) {
                            url=@"http://www.fjqxfw.com:8099/gz_wap/";
                        }
                        //创建分享消息对象
                        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                        UMShareWebpageObject *shareweb=[[UMShareWebpageObject alloc]init];
                        shareweb.webpageUrl=url;
                        shareweb.title=@"知天气分享";
                        shareweb.thumbImage=self.shareimg;
                        shareweb.descr=self.shareStr;
                        //分享消息对象设置分享内容对象
                        messageObject.shareObject = shareweb;
                        //调用分享接口
                        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                            if (error) {
                                NSLog(@"************Share fail with error %@*********",error);
                            }else{
                                NSLog(@"response data is %@",data);
                                NSString *type=@"3";
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"sharesuccess" object:type];
                            }
                        }];
            
                        break;
                    }
        case 1: {
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            //创建图片内容对象
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            //如果有缩略图，则设置缩略图
            [shareObject setShareImage:self.shareimg];
            
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
            shareObject.title=shareContent;
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    NSLog(@"************Share fail with error %@*********",error);
                }else{
                    NSLog(@"response data is %@",data);
                    NSString *type=@"3";
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"sharesuccess" object:type];
                }
            }];
            break;
        }
            
        case 3: {
            NSString *url;
            if ([self.shareStr rangeOfString:@"http"].location!=NSNotFound) {
                NSArray *arr=[self.shareStr componentsSeparatedByString:@"http"];
                if (arr.count>0) {
                    url=[NSString stringWithFormat:@"http%@",arr[1]];
                }
            }
            if (url.length<=0) {
                url=@"http://www.fjqxfw.com:8099/gz_wap/";
            }
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            
            //创建图片内容对象
            //            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            //            //如果有缩略图，则设置缩略图
            //            [shareObject setShareImage:self.shareimg];
            UMShareWebpageObject *shareweb=[[UMShareWebpageObject alloc]init];
            shareweb.webpageUrl=url;
            shareweb.title=@"知天气分享";
            shareweb.thumbImage=self.shareimg;
            shareweb.descr=self.shareStr;
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareweb;
            
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Qzone messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    NSLog(@"************Share fail with error %@*********",error);
                }else{
                    NSLog(@"response data is %@",data);
                    NSString *type=@"2";
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"sharesuccess" object:type];
                }
            }];
            
            break;
        }
            
            
    }
}

-(void)show
{
    CGRect originFram = _sheetBgView.frame;
    CGRect newFram = CGRectOffset(originFram, 0, +CGRectGetHeight(originFram));
    _sheetBgView.frame = newFram;
    
    if([[self.mydelegate class] isSubclassOfClass:[UIViewController class]]){
        UIView * addView = [(UIViewController *)self.mydelegate view];
        [addView addSubview:self];
    }else{
        UIWindow * window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:self];
    }
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];
    _sheetBgView.frame = originFram;
    [UIView commitAnimations];
}

-(void)hide
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect originFram = _sheetBgView.frame;
        CGRect newFram = CGRectOffset(originFram, 0, +CGRectGetHeight(originFram));
        _sheetBgView.frame = newFram;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
