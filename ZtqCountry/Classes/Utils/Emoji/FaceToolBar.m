//
//  FaceToolBar.m
//  TestKeyboard
//
//  Created by wangjianle on 13-2-26.
//  Copyright (c) 2013年 wangjianle. All rights reserved.
//

#import "FaceToolBar.h"

@implementation FaceToolBar
@synthesize theSuperView,delegate;
//@synthesize textView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame superView:(UIView *)superView withController:(id)controler
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //初始化为NO
        keyboardIsShow=NO;
        self.theSuperView=superView;
        //默认toolBar在视图最下方
        
        UIToolbar * toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,0,superView.bounds.size.width,toolBarHeight)];
        self.toolBar = toolBar;
        //        toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        //        UIEdgeInsets insets = UIEdgeInsetsMake(40, 0, 40, 0);
        //        [toolBar setBackgroundImage:[[UIImage imageNamed:@"keyBoardBack"] resizableImageWithCapInsets:insets] forToolbarPosition:0 barMetrics:0];
        [toolBar setBackgroundColor: [UIColor colorHelpWithRed:236 green:236 blue:236 alpha:1]];
        [self addSubview:toolBar];
        //        [toolBar setBarStyle:UIBarStyleBlackOpaque];
        
        //可以自适应高度的文本输入框
        //        textView = [[UIExpandingTextView alloc] initWithFrame:CGRectMake(40, 5, 210, 36)];
        //        textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
        //        [textView.internalTextView setReturnKeyType:UIReturnKeySend];
        //        textView.delegate = self;
        //        textView.maximumNumberOfLines=5;
        //        [toolBar addSubview:textView];
        //        [textView release];
        
        _commentTF = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 218, 40)];
        _commentTF.backgroundColor = [UIColor whiteColor];
        _commentTF.delegate = controler;
        _commentTF.clearButtonMode = UITextFieldViewModeAlways;
        _commentTF.placeholder = @"请输入评论";
        _commentTF.layer.cornerRadius = 5;
        _commentTF.layer.masksToBounds = YES;
        //        _textView = commentTF;
        [toolBar addSubview:_commentTF];
        
        UIImageView * tfLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 20, 32)];
        tfLeftView.image = [UIImage imageNamed:@"比_11.png"];
        _commentTF.leftView = tfLeftView;
        _commentTF.leftViewMode = UITextFieldViewModeAlways;
        //        //音频按钮
        //        voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        voiceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        //        [voiceButton setBackgroundImage:[UIImage imageNamed:@"Voice"] forState:UIControlStateNormal];
        //        [voiceButton addTarget:self action:@selector(voiceChange) forControlEvents:UIControlEventTouchUpInside];
        //        voiceButton.frame = CGRectMake(5,toolBar.bounds.size.height-38.0f,buttonWh,buttonWh);
        //        [toolBar addSubview:voiceButton];
        
        
        
        //表情按钮
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _faceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        [_faceButton setBackgroundImage:[UIImage imageNamed:@"表情.png"] forState:UIControlStateNormal];
        [_faceButton addTarget:self action:@selector(disFaceKeyboard) forControlEvents:UIControlEventTouchUpInside];
        _faceButton.frame = CGRectMake(5,5,40,40);
        [toolBar addSubview:_faceButton];
        
        
        
        //        //表情按钮
        //        sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //        [sendButton setTitle:@"send" forState:UIControlStateNormal];
        //        sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        //        sendButton.enabled=NO;
        ////        [sendButton setBackgroundImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
        //        [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
        //        sendButton.frame = CGRectMake(toolBar.bounds.size.width - 40.0f,toolBar.bounds.size.height-38.0f,buttonWh+4,buttonWh);
        //        [toolBar addSubview:sendButton];
        
        
        UIView * senderBg = [[UIView alloc] initWithFrame:CGRectMake(273, 5, 40, 40)];
        senderBg.backgroundColor = [UIColor whiteColor];
        senderBg.layer.cornerRadius = 5;
        [toolBar addSubview:senderBg];
        
        UIImageView * senderLogo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 20)];
        senderLogo.image = [UIImage imageNamed:@"发送.png"];
        [senderBg addSubview:senderLogo];
        
        UILabel * senderLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 40, 20)];
        senderLab.backgroundColor = [UIColor clearColor];
        senderLab.textColor = [UIColor grayColor];
        senderLab.textAlignment = NSTextAlignmentCenter;
        senderLab.font = [UIFont fontWithName:kBaseFont size:13];
        senderLab.text = @"发送";
        [senderBg addSubview:senderLab];
        
        _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        //    [sender setImage:[UIImage imageNamed:@"发送.png"] forState:UIControlStateNormal];
        //    [sender setImage:[UIImage imageNamed:@"发送点击_06"] forState:UIControlStateHighlighted];
        //    [sender setTitle:@"发送" forState:UIControlStateNormal];
        //    [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //    [sender setImageEdgeInsets:UIEdgeInsetsMake(2, 11, 20, 11)];
        //    [sender setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
        //    [sender setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
        [_sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
        [senderBg addSubview:_sendButton];
        
        //给键盘注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        //创建表情键盘
        if (_scrollView==nil) {
            _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, superView.frame.size.height, superView.frame.size.width, keyboardHeight)];
            [_scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack"]]];
            for (int i=0; i<9; i++) {
                FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(12+320*i, 15, facialViewWidth, facialViewHeight)];
                [fview setBackgroundColor:[UIColor clearColor]];
                [fview loadFacialView:i size:CGSizeMake(33, 43)];
                fview.delegate=self;
                [_scrollView addSubview:fview];
                //                [fview release];
            }
        }
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        _scrollView.contentSize=CGSizeMake(320*9, keyboardHeight);
        _scrollView.pagingEnabled=YES;
        _scrollView.delegate=self;
        [superView addSubview:_scrollView];
        //        [scrollView release];
        _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(85, superView.frame.size.height-40, 150, 30)];
        [_pageControl setCurrentPage:0];
        _pageControl.pageIndicatorTintColor=RGBACOLOR(195, 179, 163, 1);
        _pageControl.currentPageIndicatorTintColor=RGBACOLOR(132, 104, 77, 1);
        _pageControl.numberOfPages = 9;//指定页面个数
        [_pageControl setBackgroundColor:[UIColor clearColor]];
        _pageControl.hidden=YES;
        [_pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
        [superView addSubview:_pageControl];
        //        [pageControl release];
        
        
        //        [toolBar release];
        // Do any additional setup after loading the view, typically from a nib.
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = _scrollView.contentOffset.x / 320;//通过滚动的偏移量来判断目前页面所对应的小白点
    _pageControl.currentPage = page;//pagecontroll响应值的变化
}
//pagecontroll的委托方法

- (IBAction)changePage:(id)sender {
    int page = _pageControl.currentPage;//获取当前pagecontroll的值
    [_scrollView setContentOffset:CGPointMake(320 * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
}


#pragma mark -
#pragma mark UIExpandingTextView delegate
//改变键盘高度
//-(void)expandingTextView:(UIExpandingTextView *)expandingTextView willChangeHeight:(float)height
//{
//    /* Adjust the height of the toolbar when the input component expands */
//    float diff = (textView.frame.size.height - height);
//    CGRect r = toolBar.frame;
//    r.origin.y += diff;
//    r.size.height -= diff;
//    toolBar.frame = r;
//    if (expandingTextView.text.length>2&&[[Emoji allEmoji] containsObject:[expandingTextView.text substringFromIndex:expandingTextView.text.length-2]]) {
//        NSLog(@"最后输入的是表情%@",[textView.text substringFromIndex:textView.text.length-2]);
//        textView.internalTextView.contentOffset=CGPointMake(0,textView.internalTextView.contentSize.height-textView.internalTextView.frame.size.height );
//    }
//
//}
//return方法
- (BOOL)expandingTextViewShouldReturn:(UIExpandingTextView *)expandingTextView{
    [self sendAction];
    return YES;
}
//文本是否改变
-(void)expandingTextViewDidChange:(UIExpandingTextView *)expandingTextView
{
    NSLog(@"文本的长度%d",_commentTF.text.length);
    /* Enable/Disable the button */
    if ([expandingTextView.text length] > 0)
        _sendButton.enabled = YES;
    else
        _sendButton.enabled = NO;
}
#pragma mark -
#pragma mark ActionMethods  发送sendAction 音频 voiceChange  显示表情 disFaceKeyboard
-(void)sendAction{
    if (_commentTF.text.length>0) {
        NSLog(@"点击发送");
        [self dismissKeyBoard];
        if ([delegate respondsToSelector:@selector(sendTextAction:)])
        {
            [delegate sendTextAction:_commentTF.text];
            _commentTF.text = @"";
        }
        //        [textView clearText];
    }
}
-(void)voiceChange{
    [self dismissKeyBoard];
}
-(void)disFaceKeyboard{
    //如果直接点击表情，通过toolbar的位置来判断
    if (self.frame.origin.y== self.theSuperView.bounds.size.height - toolBarHeight&&self.frame.size.height==toolBarHeight) {
        [UIView animateWithDuration:Time animations:^{
            self.frame = CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight-toolBarHeight,  self.theSuperView.bounds.size.width,toolBarHeight);
        }];
        [UIView animateWithDuration:Time animations:^{
            [_scrollView setFrame:CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight,self.theSuperView.frame.size.width, keyboardHeight)];
        }];
        [_pageControl setHidden:NO];
        [_faceButton setBackgroundImage:[UIImage imageNamed:@"cssz编辑.png"] forState:UIControlStateNormal];
        return;
    }
    //如果键盘没有显示，点击表情了，隐藏表情，显示键盘
    if (!keyboardIsShow) {
        [UIView animateWithDuration:Time animations:^{
            [_scrollView setFrame:CGRectMake(0, self.theSuperView.frame.size.height, self.theSuperView.frame.size.width, keyboardHeight)];
        }];
        [_commentTF becomeFirstResponder];
        [_pageControl setHidden:YES];
        
    }else{
        
        //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
        [UIView animateWithDuration:Time animations:^{
            self.frame = CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight-self.frame.size.height,  self.theSuperView.bounds.size.width,self.frame.size.height);
        }];
        
        [UIView animateWithDuration:Time animations:^{
            [_scrollView setFrame:CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight,self.theSuperView.frame.size.width, keyboardHeight)];
        }];
        [_pageControl setHidden:NO];
        [_commentTF resignFirstResponder];
    }
    
}
#pragma mark 隐藏键盘
-(void)dismissKeyBoard{
    //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
    [UIView animateWithDuration:Time animations:^{
        self.frame = CGRectMake(0, self.theSuperView.frame.size.height-self.frame.size.height,  self.theSuperView.bounds.size.width,self.frame.size.height);
    }];
    
    [UIView animateWithDuration:Time animations:^{
        [_scrollView setFrame:CGRectMake(0, self.theSuperView.frame.size.height,self.theSuperView.frame.size.width, keyboardHeight)];
    }];
    [_pageControl setHidden:YES];
    NSLog(@"%@",self.commentTF);
    [self.commentTF resignFirstResponder];
    [_faceButton setBackgroundImage:[UIImage imageNamed:@"表情.png"] forState:UIControlStateNormal];
}
#pragma mark 监听键盘的显示与隐藏
-(void)inputKeyboardWillShow:(NSNotification *)notification{
    //键盘显示，设置toolbar的frame跟随键盘的frame
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        NSLog(@"键盘即将出现：%@", NSStringFromCGRect(keyBoardFrame));
        if (self.frame.size.height>50) {
            self.frame = CGRectMake(0, keyBoardFrame.origin.y-20-self.frame.size.height,  self.theSuperView.bounds.size.width,self.frame.size.height);
        }else{
            //            toolBar.frame = CGRectMake(0, keyBoardFrame.origin.y-65,  self.theSuperView.bounds.size.width,toolBarHeight);
            self.frame = CGRectMake(0, self.theSuperView.frame.size.height-keyboardHeight-self.frame.size.height,  self.theSuperView.bounds.size.width,self.frame.size.height);
            
        }
    }];
    [_faceButton setBackgroundImage:[UIImage imageNamed:@"表情.png"] forState:UIControlStateNormal];
    keyboardIsShow=YES;
    [_pageControl setHidden:YES];
}
-(void)inputKeyboardWillHide:(NSNotification *)notification{
    [_faceButton setBackgroundImage:[UIImage imageNamed:@"cssz编辑.png"] forState:UIControlStateNormal];
    keyboardIsShow=NO;
}

#pragma mark -
#pragma mark facialView delegate 点击表情键盘上的文字
-(void)selectedFacialView:(NSString*)str
{
    NSLog(@"进代理了");
    NSString *newStr;
    if ([str isEqualToString:@"删除"]) {
        if (_commentTF.text.length>0) {
            if ([[Emoji allEmoji] containsObject:[_commentTF.text substringFromIndex:_commentTF.text.length-2]]) {
                NSLog(@"删除emoji %@",[_commentTF.text substringFromIndex:_commentTF.text.length-2]);
                newStr=[_commentTF.text substringToIndex:_commentTF.text.length-2];
            }else{
                NSLog(@"删除文字%@",[_commentTF.text substringFromIndex:_commentTF.text.length-1]);
                newStr=[_commentTF.text substringToIndex:_commentTF.text.length-1];
            }
            _commentTF.text=newStr;
        }
        NSLog(@"删除后更新%@",_commentTF.text);
    }else{
        NSString *newStr=[NSString stringWithFormat:@"%@%@",_commentTF.text,str];
        [_commentTF setText:newStr];
        NSLog(@"点击其他后更新%d,%@",str.length,_commentTF.text);
    }
    NSLog(@"出代理了");
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    //    [super dealloc];
}

#pragma mark -textFiele

#pragma mark-
#pragma mark-UITextFieldDelegate
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    NSString * userName =[[NSUserDefaults standardUserDefaults] objectForKey:@"currendUserName"];
//    if(userName.length)
//    {
//        [self.table addGestureRecognizer:_tapGesture];
//    }
//    else
//    {
//        [textField resignFirstResponder];
//        //        LoginAlertView * loginAlert = [[LoginAlertView alloc] initWithDelegate:self];
//        //        [loginAlert show];
//        LGViewController * loginVC = [[LGViewController alloc] init];
//        [self.navigationController pushViewController:loginVC animated:YES];
//    }
//
//}
//
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [self.table removeGestureRecognizer:_tapGesture];
//}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
