#import <UIKit/UIKit.h>

@interface NTSListTableViewCell : UITableViewCell
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) UILabel *accessoryLabel;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray<NSArray *> *contents;
@property (nonatomic, strong) NSArray<NSNumber *> *defaults;
-(void)configureCellWithLabel:(NSString *)title titles:(NSArray *)titles contents:(NSArray<NSArray *> *)contents defaults:(NSArray *)defaults keys:(NSArray *)keys;
-(void)setAccessoryLabelFromContents:(NSArray<NSArray *> *)contents indexes:(NSArray *)indexes keys:(NSArray *)keys;
@end
