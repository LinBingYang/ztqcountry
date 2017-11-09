#import "CHStatusBar.h"


@implementation CHStatusBar


- (id) initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
		// 将窗体置于正确的位置和级别，就是比状态栏的级别稍高即可
		// 否则该窗体会被标准状态栏遮住，相当于web开发的zoom
		self.windowLevel = UIWindowLevelStatusBar + 1.0;
		// 使窗体的框架和状态栏框架一致
		//self.frame = CGRectMake(200, 0, 320, 20);
		
		[self setBackgroundColor:[UIColor blackColor]];
		
		// 创建一个灰色图片背景，使他视觉上还是一个标准状态栏的感觉
//		UIImageView* backgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
//		backgroundImageView.image = [[UIImage imageNamed:@"statusbar_background.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:0];
//		[self addSubview:backgroundImageView];
//		[backgroundImageView release];
		[self setClipsToBounds:YES];
		
		//文字信息，用于和用户进行交互，最好能提示用户当前是什么操作
		lblStatus = [[UILabel alloc] initWithFrame:CGRectZero];
		lblStatus.backgroundColor = [UIColor clearColor];
		lblStatus.textColor = [UIColor whiteColor];
		lblStatus.font = [UIFont systemFontOfSize:13.0f];
		[self addSubview:lblStatus];	
		
		m_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[self addSubview:m_imageView];
	}
	return self;
}

- (void) showWithStatusMessage:(NSString*)msg withImage:(NSString *)image{
	if (!msg) return;

	[lblStatus setFrame:(CGRect){.origin.x = self.frame.size.height, .origin.y = 20.0f, .size.width = 120.0f, .size.height = self.frame.size.height}];
	[m_imageView setFrame:CGRectMake(2.5, 20, 15, 15)];
	
	lblStatus.text = msg;
	m_imageView.image = [UIImage imageNamed:image];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[lblStatus setFrame:(CGRect){.origin.x = self.frame.size.height, .origin.y = 0.0f, .size.width = 120.0f, .size.height = self.frame.size.height}];
	[m_imageView setFrame:CGRectMake(2.5, 2.5, 15, 15)];
	[UIView commitAnimations];
	
	self.hidden = NO;
}


- (void) hide {

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[lblStatus setFrame:(CGRect){.origin.x = self.frame.size.height, .origin.y = -20.0f, .size.width = 120.0f, .size.height = self.frame.size.height}];
	[m_imageView setFrame:CGRectMake(2.5, -20, 15, 15)];
	[UIView commitAnimations];
	
	[self performSelector:@selector(hideSelf) withObject:nil afterDelay:1.5];
}

- (void) hideSelf
{
	self.hidden = YES;
}


//- (void) dealloc {
//	[lblStatus release];
//	[m_imageView release];
//	[super dealloc];
//}


@end
