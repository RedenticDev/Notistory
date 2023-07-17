#import "NTSAppDelegate.h"
#import "NTSRootTableViewController.h"
#import "NTSNotificationDetailsTableViewController.h"

@implementation NTSAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	UINavigationController *mainViewController = [self navigationViewControllerForClass:NTSRootTableViewController.class];
	UINavigationController *secondaryViewController = [self navigationViewControllerForClass:NTSNotificationDetailsTableViewController.class];
	
	if (@available(iOS 14.0, *)) {
		self.rootViewController = [[UISplitViewController alloc] initWithStyle:UISplitViewControllerStyleDoubleColumn];
		[self.rootViewController setViewController:mainViewController forColumn:UISplitViewControllerColumnPrimary];
		[self.rootViewController setViewController:secondaryViewController forColumn:UISplitViewControllerColumnSecondary];
	} else {
		self.rootViewController = [[UISplitViewController alloc] init];
		self.rootViewController.viewControllers = @[mainViewController, secondaryViewController];
	}
	self.rootViewController.delegate = mainViewController.viewControllers.firstObject;
	self.window.rootViewController = self.rootViewController;
	[self.window makeKeyAndVisible];
}

- (UINavigationController *)navigationViewControllerForClass:(Class)class {
	return [[UINavigationController alloc] initWithRootViewController:[[class alloc] init]];
}

@end
