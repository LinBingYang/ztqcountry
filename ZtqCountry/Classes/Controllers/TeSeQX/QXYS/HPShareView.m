//
//  HPShareView.m
//  ztqFj
//
//  Created by 胡彭飞 on 2017/2/17.
//  Copyright © 2017年 yyf. All rights reserved.
//

#import "HPShareView.h"
#import "weiboVC.h"
@implementation HPShareView

-(void)ShareSheetClickWithIndexPath:(NSInteger)indexPath
{
    
    if ([self.delegate respondsToSelector:@selector(ShareSheetClickWithIndexPath:andShareView:)]) {
        [self.delegate ShareSheetClickWithIndexPath:indexPath andShareView:self];
    }
}
//短信取消
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self.mydelegate dismissViewControllerAnimated:YES completion:nil];
}

//拨号
-(void)mobileAction{
    if ([[UIDevice currentDevice].systemVersion doubleValue]<=7.0) {
        picker = [[ABPeoplePickerNavigationController alloc]init];
        picker.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeitht);
        picker.peoplePickerDelegate = self;
        picker.delegate=self;
        [self addSubview:picker.view];
        
        
    }else if ([[UIDevice currentDevice].systemVersion doubleValue]<9.0){
        ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        peoplePicker.peoplePickerDelegate = self;
        [self.mydelegate presentViewController:peoplePicker animated:YES completion:nil];
        
        
    }else{
        CNContactPickerViewController *contactVc = [[CNContactPickerViewController alloc] init];
        // 2.设置代理
        contactVc.delegate = self;
        // 3.弹出控制器
        [self.mydelegate presentViewController:contactVc animated:YES completion:nil];
    }
}
#pragma mark -- ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef,index);
    
    [self.mydelegate dismissViewControllerAnimated:YES completion:^{
        NSString *num = (__bridge NSString*)value;
        NSString *num1=[num stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSString *num2 = [[NSString alloc]initWithFormat:@"tel://%@",num1];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num2]]; //拨号
    }];
}


#pragma mark - peoplePickerDelegate Methods
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    //获取該Label下的电话值
    NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone,0);
    NSString *num = personPhone;
    NSString *num1=[num stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *num2 = [[NSString alloc]initWithFormat:@"tel://%@",num1];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num2]]; //拨号
    
    [peoplePicker.view removeFromSuperview];
    
    return NO;
}


//“取消”按钮的委托响应方法
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    //assigning control back to the main controller
    
    if ([[UIDevice currentDevice].systemVersion doubleValue]<=8.0) {
        [peoplePicker.view removeFromSuperview];
        
    }else{
        [super.mydelegate dismissModalViewControllerAnimated:YES];
    }
}
// 当选中某一个联系人的某一个属性时会执行该方法
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    //    NSString *key = contactProperty.key;
    CNPhoneNumber *phoneNumer = contactProperty.value;
    NSString *value = phoneNumer.stringValue;
    //    NSLog(@"%@号码是phone:%@---",key,value);
    NSString *num = value;
    NSString *num1=[num stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *num2 = [[NSString alloc]initWithFormat:@"tel://%@",num1];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num2]]; //拨号
}

// 点击了取消按钮会执行该方法
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    [self.mydelegate dismissViewControllerAnimated:YES completion:nil];
}
@end
