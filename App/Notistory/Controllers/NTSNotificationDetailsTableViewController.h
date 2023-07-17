#import <UIKit/UIKit.h>
#import "NTSNotification.h"
#import "UIView+Gradient.h"

@interface NTSNotificationDetailsTableViewController : UITableViewController
@property (nonatomic, strong) NTSNotification *notification;

-(instancetype)initWithNotification:(NTSNotification *)notification;
@end

@interface UIImage ()
+(id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2;
@end
