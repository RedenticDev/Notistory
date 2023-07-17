#import "NTSListTableViewCell.h"

@interface NTSListTableViewController : UITableViewController {
	NTSListTableViewCell * __autoreleasing *_cell;
}
-(instancetype)initWithCell:(NTSListTableViewCell **)cell;
@end
