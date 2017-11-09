//
//  CityRankDialog.h
//  ZtqNew
//
//  Created by linxg on 13-8-7.
//
//

#import <UIKit/UIKit.h>
#import "TreeNode.h"
#import "GetXMLData.h"

@protocol CityDialogDelegate <NSObject>

@required
-(void)selectTable:(NSString*)t_city isProvince:(BOOL)isProvince;

@end

@interface CityRankDialog : UIView<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>{
    id <CityDialogDelegate> delegate;
    UITableView *m_tableView;
	NSMutableArray *m_tableData;
    NSMutableArray *m_provinceAndcity;
    NSMutableArray *m_value;
    bool isSearch;
    UISearchBar *m_searchBar;
    
    TreeNode *m_pmcityNode;

}
@property(nonatomic,strong) id <CityDialogDelegate>delegate;
@property(nonatomic,strong)NSMutableArray *m_tableData;
@property(nonatomic,strong)NSMutableArray *m_provinceAndcity;
@property(nonatomic,strong)NSMutableArray *m_value;
@property(nonatomic, strong)UILabel *titleLabel;
@property(assign)float barhight;
-(void)setData:(NSArray*)t_array1 Value:(NSArray*)t_array2;

@end
