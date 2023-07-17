#import <UIKit/UIKit.h>
#import "NTSNotification.h"

@interface NTSNotificationTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end
