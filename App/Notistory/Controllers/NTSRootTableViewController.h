#import <UIKit/UIKit.h>
#import "NTSNotification.h"
#import "NTSNotificationDetailsTableViewController.h"
#import "NTSNotificationTableViewCell.h"
#import "NTSSettingsTableViewController.h"

@interface NTSRootTableViewController : UITableViewController <UISearchBarDelegate, UIViewControllerPreviewingDelegate>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray<NTSNotification *> *cells;

-(void)updateUITheme:(id)sender;
-(void)keyboardWillHide:(id)sender;
@end

@interface UIImage ()
+(id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2;
@end
