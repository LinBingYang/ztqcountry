//
//  ZXContViewController.h
//  ZtqCountry
//
//  Created by Admin on 14-11-3.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "BaseViewController.h"
#import "artTitleModel.h"
#import "artTextModel.h"
#import "ShareFun.h"
@interface ZXContViewController : BaseViewController<UIWebViewDelegate>{
    UIWebView *mConentWebView;
    artTextModel *textModel;
}
@property(nonatomic,strong)NSString *titlestr;
@property(nonatomic, strong) NSString *contentstr;
@property(nonatomic,strong)NSString *Contitle;
@property(nonatomic,strong)NSString *putstr;
@property(strong,nonatomic)NSString *imagename;

@property(nonatomic, strong)artTextModel *textModel;
@property(nonatomic, strong) NSString *mArticleTemplate;
@property(nonatomic, readonly) UIWebView *mConentWebView;
@end
