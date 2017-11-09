//
//  LiveHeadYesTableViewCell.m
//  ZtqCountry
//
//  Created by linxg on 14-9-3.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "LiveHeadYesTableViewCell.h"
#import "UILabel+utils.h"

@implementation LiveHeadYesTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withImageInfo:(ImageInfo *)info
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.imginfo=info;
        float width = info.width;
        float height = info.height;
        NSString *thumbURL = info.thumbURL;
        float newHeight = height/width*CGRectGetWidth(self.frame);
        _photo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), newHeight)];
        if([info.imageType isEqualToString:@"1"])
        {
            _photo.image = [UIImage imageNamed:thumbURL];
        }
        else
        {
            if([info.imageType isEqualToString:@"2"])
            {
                _photo.image = [UIImage imageWithData:info.imageData];
            }
        }
        
        [self.contentView addSubview:_photo];
        
        UIButton * guanyuBut = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-150, 20, 150, 20)];
        self.guanyuBut = guanyuBut;
        guanyuBut.titleLabel.font = [UIFont fontWithName:kBaseFont size:15];
        guanyuBut.titleLabel.textColor = [UIColor whiteColor];
        [guanyuBut setBackgroundImage:[UIImage imageNamed:@"grzx1@张三背景.png"] forState:UIControlStateNormal];
        [guanyuBut setTitle:[NSString stringWithFormat:@"@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currendUserName"]] forState:UIControlStateNormal];
        [guanyuBut addTarget:self action:@selector(guanyuButAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:guanyuBut];
        
        UIImageView * interactionBg = [[UIImageView alloc] initWithFrame:CGRectMake(100, newHeight+35, 60, 30)];
        interactionBg.userInteractionEnabled = YES;
        interactionBg.image = [UIImage imageNamed:@"grzx1转发背景.png"];
        [self.contentView addSubview:interactionBg];
        
        UIButton * guanzhuBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-60-80)/2.0-30, 30)];
        self.guanzhubut=guanzhuBut;
        guanzhuBut.titleLabel.font = [UIFont fontWithName:kBaseFont size:15];
        [guanzhuBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [guanzhuBut setTitle:@"+关注" forState:UIControlStateNormal];
        [guanzhuBut addTarget:self action:@selector(guanzhuAction:) forControlEvents:UIControlEventTouchUpInside];
        [interactionBg addSubview:guanzhuBut];
        
        UIImageView * interactionBg1 = [[UIImageView alloc] initWithFrame:CGRectMake(170, newHeight+35, 60, 30)];
        interactionBg1.userInteractionEnabled = YES;
        interactionBg1.image = [UIImage imageNamed:@"grzx1转发背景.png"];
        [self.contentView addSubview:interactionBg1];
        
        UIImageView * zhuanfaLogo = [[UIImageView alloc] initWithFrame:CGRectMake(5, 9, 15, 15)];
        zhuanfaLogo.image = [UIImage imageNamed:@"grzx1转发图标.png"];
        [interactionBg1 addSubview:zhuanfaLogo];
        UIButton * zhuanfaBut = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, (kScreenWidth-60-80)/2.0-20, 30)];
        zhuanfaBut.titleLabel.font = [UIFont fontWithName:kBaseFont size:15];
        [zhuanfaBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [zhuanfaBut setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [zhuanfaBut setTitle:@"点赞" forState:UIControlStateNormal];
        [zhuanfaBut addTarget:self action:@selector(zhuanfaAction:) forControlEvents:UIControlEventTouchUpInside];
        [interactionBg1 addSubview:zhuanfaBut];
        
        UIImageView * userImageBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, newHeight-20, 80, 80)];
        userImageBg.userInteractionEnabled = YES;
        userImageBg.backgroundColor = [UIColor whiteColor];
        userImageBg.layer.cornerRadius = 40;
        userImageBg.layer.masksToBounds = YES;
        [self.contentView addSubview:userImageBg];
        
        UIImageView * userImage = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 76, 76)];
        userImage.userInteractionEnabled = YES;
        userImage.layer.cornerRadius = 38;
        userImage.layer.masksToBounds = YES;
        NSData * userImageData =  [[NSUserDefaults standardUserDefaults] objectForKey:@"currendIco"];
        userImage.image = [UIImage imageWithData:userImageData];
        [userImageBg addSubview:userImage];
        //
        //        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseUserImage:)];
        //        [userImage addGestureRecognizer:tap];
        
        UIButton * userImageBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 76, 76)];
        [userImageBut addTarget:self action:@selector(chooseUserImage:) forControlEvents:UIControlEventTouchUpInside];
        [userImage addSubview:userImageBut];
        //
        _userName = [[UILabel alloc] initWithFrame:CGRectMake(0, newHeight+5, kScreenWidth, 25)];
        _userName.backgroundColor = [UIColor clearColor];
        _userName.textColor = [UIColor colorHelpWithRed:92 green:170 blue:232 alpha:1];
        _userName.textAlignment = NSTextAlignmentCenter;
        _userName.font = [UIFont fontWithName:kBaseFont size:20];
        _userName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"currendUserName"];
        [self.contentView addSubview:_userName];
        
        
        
        UIImageView * addressLogo = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-100, newHeight-30, 10, 15)];
//        addressLogo.backgroundColor=[UIColor redColor];
        addressLogo.image = [UIImage imageNamed:@"grzx1地图.png"];
        [self.contentView addSubview:addressLogo];
        
        _addressLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-80, newHeight-30, 80, 15)];
        _addressLab.backgroundColor = [UIColor clearColor];
        _addressLab.textColor = [UIColor grayColor];
        _addressLab.textAlignment = NSTextAlignmentLeft;
        _addressLab.font = [UIFont fontWithName:kBaseFont size:15];
        _addressLab.text = info.address;
        [self.contentView addSubview:_addressLab];
        
        float addressLenght = [_addressLab labelLength:info.address withFont:_addressLab.font];
        addressLogo.frame = CGRectMake(kScreenWidth-160, newHeight-30, 10, 15);
        _addressLab.frame = CGRectMake(kScreenWidth-150, newHeight-30, 150, 15);
        
        UIImageView * butBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, newHeight+90, kScreenWidth, 50)];
        butBg.image = [UIImage imageNamed:@"grzx1浏览回复线框.png"];
        butBg.userInteractionEnabled = YES;
        [self.contentView addSubview:butBg];
        
        //        @property (strong, nonatomic) UILabel * browseNumLab;
        //        @property (strong, nonatomic) UILabel * answerNumLab;
        //        @property (strong, nonatomic) UILabel * attentionLab;
        
        _browseNumLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5 , kScreenWidth/3.0, 20)];
        _browseNumLab.backgroundColor = [UIColor clearColor];
        _browseNumLab.textColor = [UIColor colorHelpWithRed:77 green:163 blue:230 alpha:1];
        _browseNumLab.textAlignment = NSTextAlignmentCenter;
        _browseNumLab.font = [UIFont fontWithName:kBaseFont size:13];
        _browseNumLab.text = [NSString stringWithFormat:@"%d",info.forwardNum];
        [butBg addSubview:_browseNumLab];
        
        UILabel * browseTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 25 , kScreenWidth/3.0, 20)];
        browseTitleLab.text = @"浏览量";
        browseTitleLab.backgroundColor = [UIColor clearColor];
        browseTitleLab.textColor = [UIColor grayColor];
        browseTitleLab.textAlignment = NSTextAlignmentCenter;
        browseTitleLab.font = [UIFont fontWithName:kBaseFont size:15];
        [butBg addSubview:browseTitleLab];
        
        UIImageView * line1 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/3.0-1, 0, 1, 50)];
        line1.image = [UIImage imageNamed:@"grzx1竖隔条.png"];
        [butBg addSubview:line1];
        
        _answerNumLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/3.0, 5 , kScreenWidth/3.0, 20)];
        _answerNumLab.backgroundColor = [UIColor clearColor];
        _answerNumLab.textColor = [UIColor colorHelpWithRed:77 green:163 blue:230 alpha:1];
        _answerNumLab.textAlignment = NSTextAlignmentCenter;
        _answerNumLab.font = [UIFont fontWithName:kBaseFont size:13];
        _answerNumLab.text = [NSString stringWithFormat:@"%d",info.commentNum];
        [butBg addSubview:_answerNumLab];
        
        UILabel * answerTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/3.0, 25 , kScreenWidth/3.0, 20)];
        answerTitleLab.text = @"评论数";
        answerTitleLab.backgroundColor = [UIColor clearColor];
        answerTitleLab.textColor = [UIColor grayColor];
        answerTitleLab.textAlignment = NSTextAlignmentCenter;
        answerTitleLab.font = [UIFont fontWithName:kBaseFont size:15];
        [butBg addSubview:answerTitleLab];
        
        UIImageView * line2 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/3.0*2-1, 0, 1, 50)];
        line2.image = [UIImage imageNamed:@"grzx1竖隔条.png"];
        [butBg addSubview:line2];
        
        _attentionLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/3.0*2, 5 , kScreenWidth/3.0, 20)];
        _attentionLab.backgroundColor = [UIColor clearColor];
        _attentionLab.textColor = [UIColor colorHelpWithRed:77 green:163 blue:230 alpha:1];
        _attentionLab.textAlignment = NSTextAlignmentCenter;
        _attentionLab.font = [UIFont fontWithName:kBaseFont size:13];
        _attentionLab.text = [NSString stringWithFormat:@"%d",info.zanNum];
        [butBg addSubview:_attentionLab];
        
        UILabel * attentionTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/3.0*2, 25 , kScreenWidth/3.0, 20)];
        attentionTitleLab.text = @"点赞数";
        attentionTitleLab.backgroundColor = [UIColor clearColor];
        attentionTitleLab.textColor = [UIColor grayColor];
        attentionTitleLab.textAlignment = NSTextAlignmentCenter;
        attentionTitleLab.font = [UIFont fontWithName:kBaseFont size:15];
        [butBg addSubview:attentionTitleLab];
        
        
    }
    return self;
}

-(void)guanyuButAction:(UIButton *)sender
{
    
}

-(void)guanzhuAction:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(guanzhuClick)])
    {
        [self.delegate guanzhuClick];
    }
//    [self readuserinfo];
//     [[NSNotificationCenter defaultCenter] postNotificationName:@"GuanZhu" object:nil];
//    [self openFocus];
}
-(void)openFocus{
    NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"currendUserID"];
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *getFocusList = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [getFocusList setObject:userid forKey:@"usrId"];
    [getFocusList setObject:self.imginfo.userID forKey:@"focusId"];
    [t_b setObject:getFocusList forKey:@"openFocus"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            NSDictionary *getFocusList=[t_b objectForKey:@"openFocus"];
            self.result=[getFocusList objectForKey:@"result"];
            NSLog(@"%@",self.result);
            [self.guanzhubut setTitle:@"已关注" forState:UIControlStateNormal];
        }
        //        [self.table reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GuanZhu" object:nil];
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
    
}

-(void)zhuanfaAction:(UIButton *)sender
{
    NSLog(@"点赞");
     NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"currendUserID"];
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_h = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *t_b = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableDictionary *getFocusList = [NSMutableDictionary dictionaryWithCapacity:4];
    [t_h setObject:[setting sharedSetting].app forKey:@"p"];
    [getFocusList setObject:userid forKey:@"usrId"];
    [getFocusList setObject:self.imginfo.itemid forKey:@"itemId"];
    [t_b setObject:getFocusList forKey:@"clickGood"];
    [t_dic setObject:t_h forKey:@"h"];
    [t_dic setObject:t_b forKey:@"b"];
    [[NetWorkCenter share]postHttpWithUrl:URL_SERVER withParam:t_dic withFlag:10 withSuccess:^(NSDictionary *returnData) {
        // NSLog(@"%@",returnData);
        
        
        NSDictionary *t_b = [returnData objectForKey:@"b"];
        
        if (t_b != nil)
        {
            NSDictionary *getFocusList=[t_b objectForKey:@"clickGood"];
            NSString *result=[getFocusList objectForKey:@"result"];
            NSLog(@"%@",result);
        }
        //        [self.table reloadData];
        
    } withFailure:^(NSError *error) {
        NSLog(@"failure");
        
    } withCache:YES];
}

-(void)chooseUserImage:(UITapGestureRecognizer *)sender
{
    if([self.delegate respondsToSelector:@selector(LiveHeadYesTableViewCellUserImageClick)])
    {
        [self.delegate LiveHeadYesTableViewCellUserImageClick];
    }
}

@end
