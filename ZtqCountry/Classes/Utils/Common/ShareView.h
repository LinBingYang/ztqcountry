//
//  ShareView.h
//  ztqFj
//
//  Created by Admin on 16/9/13.
//  Copyright © 2016年 yyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
@interface ShareView : UIView<MFMessageComposeViewControllerDelegate,ABPersonViewControllerDelegate,ABNewPersonViewControllerDelegate,ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate,CNContactViewControllerDelegate>{
    ABPeoplePickerNavigationController *picker;
    ABNewPersonViewController *personViewController;
}
@property (strong, nonatomic) UIImageView * sheetBgView;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) NSArray * butTitles;
@property (strong, nonatomic) NSArray * butImages;
@property (strong, nonatomic) NSArray * hightLightImages;
@property (strong, nonatomic)UIViewController* mydelegate;
@property(strong,nonatomic)NSString *shareStr;
@property(strong,nonatomic)UIImage *shareimg;
@property(strong, nonatomic)NSString *subtitle;


-(id)initWithTitle:(NSString *)title withButImages:(NSArray *)imageNames withHightLightImage:(NSArray *)hightlightimg withButTitles:(NSArray *)titles withDelegate:(id)delegate;
-(id)initDefaultWithTitle:(NSString *)title WithShareContext:(NSString *)sharecontxt subtitile:(NSString *)subtitile WithShareimg:(UIImage *)shareimg WithControllview:(UIViewController*)delegatevc;
-(void)show;
@end
