//
//  SingleToPersonCenterTransitonAnimation.m
//  ZtqCountry
//
//  Created by linxg on 14-8-19.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "SingleToPersonCenterTransitonAnimation.h"
#import "SinglePhotoViewController.h"
#import "PersonalCenterVC.h"
#import "LiveUserInfoCell.h"
#import "LiveFriendTableViewCell.h"
#import "PersonImageCell.h"

@implementation SingleToPersonCenterTransitonAnimation

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 3;
}


-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    SinglePhotoViewController * fromVC = (SinglePhotoViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    PersonalCenterVC * toVC = (PersonalCenterVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    UITableView * fromVCTableView = fromVC.table;
    NSIndexPath * selectedIP = [[fromVCTableView indexPathsForSelectedRows] firstObject];
    UIView * cellImageVSnapshot = nil;
    CGRect cellFrameOnContainerView = CGRectZero;
    UITableViewCell * fromCell;
    if(selectedIP.section ==0)
    {
        if(selectedIP.section == 1)
        {
            LiveUserInfoCell * userInfoCell = (LiveUserInfoCell *)[fromVCTableView cellForRowAtIndexPath:selectedIP];
            cellImageVSnapshot = [userInfoCell.userImgV snapshotViewAfterScreenUpdates:YES];
            cellImageVSnapshot.frame = [containerView convertRect:userInfoCell.userImgV.frame fromView:userInfoCell.contentView];
            fromCell = userInfoCell;
            userInfoCell.userImgV.hidden = YES;
            
        }
    }
    else
    {
        LiveFriendTableViewCell * friendCell = (LiveFriendTableViewCell *)[fromVCTableView cellForRowAtIndexPath:selectedIP];
        cellImageVSnapshot = [friendCell.userImg snapshotViewAfterScreenUpdates:YES];
        cellImageVSnapshot.frame = [containerView convertRect:friendCell.userImg.frame fromView:friendCell.contentView];
        fromCell = friendCell;
        friendCell.userImg.hidden = YES;
    }
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0;
    PersonImageCell * personCell = (PersonImageCell *)[toVC.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSLog(@"#%@#",toVC.table.visibleCells);
    NSLog(@"$%@$",personCell);
    NSLog(@"###%d#",toVC.table.numberOfSections);
    personCell.userImg_Min.hidden = YES;
    [containerView addSubview:toVC.view];
    [containerView addSubview:cellImageVSnapshot];
    
    [UIView animateWithDuration:3 animations:^{
        toVC.view.alpha = 1.0;
        CGRect frame = [containerView convertRect:personCell.userImg_Min.frame fromView:personCell.contentView];
        cellImageVSnapshot.frame = frame;
    } completion:^(BOOL finished) {
        personCell.userImg_Min.hidden = NO;
        if(selectedIP.section == 0)
        {
            if(selectedIP.row == 1)
            {
                LiveUserInfoCell * cellUser = (LiveUserInfoCell *)fromCell;
                cellUser.userImgV.hidden = NO;
            }
        }
        else
        {
            LiveFriendTableViewCell * cellFriend = (LiveFriendTableViewCell *)fromCell;
            cellFriend.userImg.hidden = NO;
        }
        [cellImageVSnapshot removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}
@end
