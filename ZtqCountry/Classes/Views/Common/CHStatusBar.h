#import <Foundation/Foundation.h>


//自定义状态栏，状态栏显示灰色背景并【indicator message】。用于耗时操作的状态栏信息提示
//例如：访问网络时，提示正在获取网络数据，或者正在提交数据至服务器等提示
@interface CHStatusBar : UIWindow {
	@private
		UILabel *lblStatus;
		UIImageView *m_imageView;
}


-(void)showWithStatusMessage:(NSString*)msg withImage:(NSString *)image;
-(void)hide;


@end
