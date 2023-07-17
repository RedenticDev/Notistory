#import <UIKit/UIKit.h>

@interface NTSAppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UISplitViewController *rootViewController;

-(UINavigationController *)navigationViewControllerForClass:(Class)class;
@end
