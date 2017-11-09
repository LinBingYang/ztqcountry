//
//  LiveViewController.m
//  ZtqCountry
//
//  Created by linxg on 14-8-6.
//  Copyright (c) 2014年 yyf. All rights reserved.
//

#import "LiveViewController.h"

@interface LiveViewController ()

@end

@implementation LiveViewController

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
    [self setNavigation];
    
}

-(void)creatViews
{
    UIButton * cameraBut = [[UIButton alloc] initWithFrame:CGRectMake(100, 20+self.barHeight, 60, 30)];
    [cameraBut setTitle:@"相机" forState:UIControlStateNormal];
    [cameraBut setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cameraBut addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraBut];
}

-(void)cameraAction:(UIButton *)sender
{
    //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        //    [self presentModalViewController:picker animated:YES];//进入照相界面
        [self presentViewController:picker animated:YES completion:nil];//进入照相界面
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"知天气" message:@"此设备不支持拍照功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    //    sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
    //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
    //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
    //    [picker release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavigation
{
    self.barHiden = NO;
    self.titleLab.text = @"开拍";
    
}



#pragma mark -UIImagePickerControllerDelegate
//点击相册中的图片 货照相机照完后点击use  后触发的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    // Save the image to the album
    UIImageWriteToSavedPhotosAlbum(image, self,@selector(imagedidFinishSavingWithError:contextInfo:), nil);
    [self dismissViewControllerAnimated:YES completion:nil];
    //    [picker release];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    // Handle the end of the image write process
    if (!error)
        NSLog(@"成功");
    else
        NSLog(@"%@",[error localizedDescription]);
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
