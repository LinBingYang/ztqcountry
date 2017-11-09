//
//  EditGRXXController.h
//  ztqFj
//
//  Created by 胡彭飞 on 16/9/5.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditGRXXController : UIViewController
{

    TreeNode *m_allCity;
    TreeNode *m_allprovice;
}
@property (strong, nonatomic) UIButton * leftBut,*rightBut;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UIImageView * navigationBarBg;
@property (assign, nonatomic) float barHeight;
@property (assign, nonatomic) BOOL barHiden;
@end
