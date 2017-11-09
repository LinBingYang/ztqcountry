//
//  AirDialog.h
//  ZtqNew
//
//  Created by linxg on 13-8-7.
//
//

#import <UIKit/UIKit.h>
typedef enum{
    dialog_label,
    dialog_city,
    dialog_air
}dialogType;


@protocol AirDialogDelegate <NSObject>

@required
-(void)selectTable:(NSInteger)row type:(dialogType)t_type;

@end

@interface AirDialog : UIView<UITableViewDelegate, UITableViewDataSource>{
    id <AirDialogDelegate> delegate;
    UITableView *m_tableView;
	NSMutableArray *m_tableData;
    NSMutableArray *m_value;
    UILabel *m_label;
    UIScrollView *bgscrollview;
    dialogType m_type;
}
@property(nonatomic,strong) id <AirDialogDelegate>delegate;
@property(nonatomic,strong)NSMutableArray *m_tableData;
@property(nonatomic,strong)NSMutableArray *m_value;
@property(nonatomic,strong)UILabel *m_label;
///名称label
@property(nonatomic,strong)UILabel *titleLabel;
@property(assign)float barhight;
@property dialogType m_type;
-(void)initWithArray:(NSArray*)t_array1 Value:(NSArray*)t_array2 labelString:(NSString*)t_string flag:(dialogType)t_type;

@end
