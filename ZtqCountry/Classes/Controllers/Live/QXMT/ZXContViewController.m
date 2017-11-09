//
//  ZXContViewController.m
//  ZtqCountry
//
//  Created by Admin on 14-11-3.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "ZXContViewController.h"
#import "EGOImageView.h"
#import "UILabel+utils.h"
#define ARITICLE_TEMPLATE_FILE @"ShowArtileTemplate.txt"
@interface ZXContViewController ()

@end

@implementation ZXContViewController
@synthesize textModel;
@synthesize mArticleTemplate;
@synthesize mConentWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    self.barHiden=NO;
    self.titleLab.text=self.titlestr;
    
   

    
   
	UIScrollView *scro = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.barHeight, kScreenWidth, [UIScreen mainScreen].bounds.size.height-20-45)];
	scro.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
	scro.contentSize=CGSizeMake(self.view.width, kScreenHeitht+100);
	[self.view addSubview:scro];
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    title.textColor=[UIColor blackColor];
    title.numberOfLines=0;
    title.textAlignment=NSTextAlignmentCenter;
    title.backgroundColor=[UIColor clearColor];
    title.text=self.Contitle;
    title.font=[UIFont systemFontOfSize:18];
    [scro addSubview:title];
    
    UILabel *put=[[UILabel alloc]initWithFrame:CGRectMake(0, 30, kScreenWidth, 50)];
    put.textColor=[UIColor grayColor];
    put.text=self.putstr;
    put.textAlignment=NSTextAlignmentCenter;
    put.backgroundColor=[UIColor clearColor];
    put.font=[UIFont systemFontOfSize:12];
    [scro addSubview:put];
    
    EGOImageView *img=[[EGOImageView alloc]initWithFrame:CGRectMake(10, 80, kScreenWidth-20, 180)];
    [img setImageURL:[ShareFun makeImageUrl:self.imagename]];
    [scro addSubview:img];
    
//    NSFileManager *fileManage = [NSFileManager defaultManager];
//    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:ARITICLE_TEMPLATE_FILE];
//    NSString *mContent;
//    if([fileManage fileExistsAtPath:filePath]){
//        NSData *tFileData = [fileManage contentsAtPath:filePath];
//        mContent = [[NSString alloc] initWithData:tFileData encoding:NSUTF8StringEncoding];
//    }
//    [self setMArticleTemplate:mContent];
//    
//    mConentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.barHeight, 320, [UIScreen mainScreen].bounds.size.height-20-45)];
//    mConentWebView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
//    mConentWebView.opaque = NO;
//    self.mConentWebView.scalesPageToFit = YES;
//    self.mConentWebView.delegate = self;
//    [self.view addSubview:mConentWebView];
//    
//    textModel = [[artTextModel alloc] init];
//        textModel.imgURL=self.imagename;
//        textModel.titles=self.Contitle;
//    textModel.txt=self.contentstr;
//        textModel.pubt=self.putstr;
//    [self imageInserString];
//    [mConentWebView loadHTMLString:[self htmlFilePathByTemplate] baseURL:nil];
  
    UILabel *cont=[[UILabel alloc]initWithFrame:CGRectMake(10, 265, kScreenWidth-20, 300)];
    cont.textColor=[UIColor blackColor];
    cont.adjustsFontSizeToFitWidth = YES;
    cont.contentMode = UIViewContentModeScaleAspectFit;
    cont.text=self.contentstr;
    cont.numberOfLines=0;
    cont.textAlignment=NSTextAlignmentLeft;
    cont.backgroundColor=[UIColor clearColor];
    cont.font=[UIFont systemFontOfSize:18];
    [scro addSubview:cont];
    float H=[cont labelheight:self.contentstr withFont:[UIFont fontWithName:kBaseFont size:18]];
    cont.frame=CGRectMake(10, 260, kScreenWidth-20, H);
    scro.contentSize=CGSizeMake(self.view.width, 260+H);
    
//    UITextView *context=[[UITextView alloc]initWithFrame:CGRectMake(10, 260, kScreenWidth-20, 500)];
//    context.textColor=[UIColor blackColor];
//    context.text=self.contentstr;
//    context.editable=NO;
//    context.textAlignment=NSTextAlignmentLeft;
//    context.backgroundColor=[UIColor clearColor];
//    context.font=[UIFont systemFontOfSize:15];
//    [scro addSubview:context];
}
//将模板进行内容填充
- (NSString *)htmlFilePathByTemplate
{
    //如果对应的属性为空，将属性转化为空
    if (([textModel titles] == nil)) {
        [textModel setTitles:@""];
    }
    if (([textModel pubt] == nil)) {
        [textModel setPubt:@""];
    }
    if ((textModel.txt == nil)) {
        [textModel setTxt:@""];
    }
    if ((textModel.imgURL == nil)) {
        [textModel setImgURL:@""];
    }
    
    //将网络数据和模帮进行匹配，并替换
//    textModel.titles = [textModel.txt stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    
    NSString *htmlContent = [[self mArticleTemplate] stringByReplacingOccurrencesOfString:@"{$title}" withString:[textModel titles]];
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"{$ptime}" withString:textModel.pubt];
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"{$content}" withString:textModel.txt];
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"{$imgURL}" withString:textModel.imgURL];
//    NSLog(@"%@", textModel.txt);
    return htmlContent;//filePath;
    
}
#pragma mark 将模板进行内容填充
- (void) imageInserString
{
    //将图片地址插入内容中
    if (textModel.imgURL.length > 0) {
        NSString *tArticleContent = [textModel txt];
        NSString *tImageUrl = [ShareFun makeImageUrlStr:textModel.imgURL];
        
        NSString *tImageHtml;
        //if (i == 0) {
        tImageHtml = [NSString stringWithFormat:@"<div id=\"image\"><img src=\"%@\" alt=\"%@\" width=\"300\"/></div>&nbsp;",tImageUrl,nil];
        //}//else {
        //tImageHtml = [NSString stringWithFormat:@"<div id = \"image\"><img src=\"%@\" alt=\"%@\" width=\"300\"/></div>&nbsp;",tImageUrl,@""];
        //		}
        tArticleContent = [tArticleContent stringByReplacingOccurrencesOfString:@"<-img->" withString:tImageHtml];
        
        
        [textModel setTxt:tArticleContent];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
