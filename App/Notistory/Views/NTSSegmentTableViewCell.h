#import <UIKit/UIKit.h>

@interface NTSSegmentTableViewCell : UITableViewCell
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISegmentedControl *segment;
-(void)configureCellWithTitle:(NSString *)title segmentElements:(NSArray<NSString *> *)elements index:(NSInteger)index key:(NSString *)key;
-(void)segmentChanged:(UISegmentedControl *)sender;
@end
