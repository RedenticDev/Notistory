#import "NTSRootTableViewController.h"

/**
 TODO:
 - fix UISplitViewController iPad (everything lives on the left panel instead of full iPad screen) -> check RuntimeBrowser!
 - fix preview & imagedetail not appearing on iPad (write prefs at first startup?)
 - fix multiline in details
 - fix unreliable showAppIcon
 - improve dark mode
 https://github.com/zbrateam/Zebra/blob/master/Zebra/Extensions/ZBTableViewController.m

 - improve ImageController (more zoom features, tap to change background black/white/none) -> Peach too?
 - handle Info.plist (downloads + https://stackoverflow.com/questions/12414290/info-plist-and-its-variables-like-appname)
 - save actions (whole NCNotificationRequest?)
 - delete notif peek & pop (uipreviewaction)
 - model sharedManager?
 - finir links settings + UIStackView pour header
 - fixer twitter pp with HBLinkTableCell.m line 147 (+ find fetch app icons in "open in" of HBPackageTableCell)
 - add no notification message (+ tableFooterView)
 - error message image preview + improve double tap to zoom (Peach)
 - download button image detail + for preview
 - find notificationbuilder iOS to finish preview
 - swipe with 2 fingers for multi selection
 https://developer.apple.com/documentation/uikit/uitableviewdelegate/selecting_multiple_items_with_a_two-finger_pan_gesture?language=objc
 - sort by dates
 - clean UIKit imports
 - localize everything
 - support 3D Touch on app icon and cells + hold to copy detail cells
 - add haptics (+ settings?)
 - UIActivityIndicator during auto refresh
 - NS_ASSUME_NONNULL_BEGIN/END for all .h files as in Categories
 - delete UIImage+Size?
 - search bar
 https://github.com/LacertosusRepo/Open-Source-Tweaks/blob/master/TweakSearch/Tweak.x
 - save records lol
 - make Hook part (+ open in Notistory/delete from the app for banners quick actions)
 - explanation README for App and Hook
 - widget iOS 14?

 Later:
 - Pin notifications
 - Filter
 - Import/export
 */

@implementation NTSRootTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	// Search controller
	self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
	self.searchController.searchBar.delegate = self;
	if (@available(iOS 9.1, *)) {
		self.searchController.obscuresBackgroundDuringPresentation = YES;
	}
	self.searchController.hidesNavigationBarDuringPresentation = YES;
	[self.searchController.searchBar sizeToFit];

	if (@available(iOS 11.0, *)) {
		self.navigationItem.hidesSearchBarWhenScrolling = YES;
		self.navigationItem.searchController = self.searchController;
	}

	// Table view cells height
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 44.0;

	// Theme
	NSInteger forcedTheme = [[NSUserDefaults standardUserDefaults] integerForKey:@"forcedTheme"];
	if (forcedTheme != 0) {
		if (@available(iOS 13.0, *)) {
			self.overrideUserInterfaceStyle = forcedTheme == self.overrideUserInterfaceStyle ? self.overrideUserInterfaceStyle : forcedTheme;
		}
	}

	// Peek & Pop registration
	[self registerForPreviewingWithDelegate:self sourceView:self.tableView];

	// Notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUITheme:) name:@"updateUI" object:nil];
	[[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"showAppIcon" options:NSKeyValueObservingOptionNew context:nil];
	[self updateUITheme:nil];
}

- (void)loadView {
	[super loadView];

	self.title = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
	if (@available(iOS 11.0, *)) {
		self.navigationController.navigationBar.prefersLargeTitles = YES;
	}
	if (@available(iOS 13.0, *)) {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"gear"] style:UIBarButtonItemStylePlain target:self action:@selector(openSettings:)];
	} else {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SETTINGS", nil) style:UIBarButtonItemStylePlain target:self action:@selector(openSettings:)];
	}

	self.cells = [NSMutableArray new];
	self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	// TEST ONLY
	NSArray *notifs = @[
		[[NTSNotification alloc] initWithIdentifier:@"com.google.ios.youtube" name:@"YouTube" title:@"Creator" content:@"Video title" attachedImage:nil date:[NSDate date]],
		[[NTSNotification alloc] initWithIdentifier:@"ph.telegra.Telegraph" name:@"Telegram" title:@"r/jailbreak" content:@"[FREE RELEASE] Notistory - Keep track of your notifications!" attachedImage:nil date:[NSDate date]],
		[[NTSNotification alloc] initWithIdentifier:@"com.apple.MobileSMS" name:@"Messages" title:@"Mom" content:@"Attachment: 1 image" attachedImage:[UIImage _applicationIconImageForBundleIdentifier:@"com.apple.MobileSMS" format:2] date:[NSDate date]],
		[[NTSNotification alloc] initWithIdentifier:@"com.reddit.Reddit" name:@"Reddit" title:@"New answer for your comment" content:@"user7890 said: \"You definitely should hurry up and release this app.\nIt would be so useful!\"" attachedImage:[UIImage _applicationIconImageForBundleIdentifier:@"com.github.stormbreaker.prod" format:2] date:[NSDate date]]
	];
	
	[self.cells insertObject:[notifs objectAtIndex:arc4random_uniform((int)notifs.count)] atIndex:0];
	[self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)openSettings:(id)sender {
	[self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[NTSSettingsTableViewController alloc] init]] animated:YES completion:nil];
}

- (void)updateUITheme:(id)sender {
	if (@available(iOS 13.0, *)) {
		NSInteger forcedTheme = [[NSUserDefaults standardUserDefaults] integerForKey:@"forcedTheme"];
		UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
		if (forcedTheme > 0 && rootVC.overrideUserInterfaceStyle != forcedTheme) {
			rootVC.overrideUserInterfaceStyle = forcedTheme;
		}
	}
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"showAppIcon"];
}

#pragma mark - NSUserDefaults Delegate
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	if ([keyPath isEqualToString:@"showAppIcon"]) {
		[self.tableView beginUpdates];
		[self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.tableView numberOfSections])] withRowAnimation:UITableViewRowAnimationAutomatic];
		[self.tableView endUpdates];
	}
}

#pragma mark - Split View Controller Delegate
- (UISplitViewControllerColumn)splitViewController:(UISplitViewController *)svc topColumnForCollapsingToProposedTopColumn:(UISplitViewControllerColumn)proposedTopColumn API_AVAILABLE(ios(14.0)) {
	return UISplitViewControllerColumnPrimary;
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
	if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [((UINavigationController *)secondaryViewController).topViewController isKindOfClass:[NTSNotificationDetailsTableViewController class]]) {
		return YES;
	}
	return NO;
}

#pragma mark - Search Bar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	[searchBar setShowsCancelButton:YES animated:YES];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil]; // handles iPad 'hide keyboard' key
}

- (void)keyboardWillHide:(id)sender {
	[self.searchController.searchBar setShowsCancelButton:NO animated:YES];
	[self.searchController.searchBar endEditing:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	[searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	searchBar.text = @"";
	[searchBar endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {}

#pragma mark - Table View Delegate
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
     return nil;
 }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NTSNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (!cell) {
		cell = [[NTSNotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
	}
	NTSNotification *data = self.cells[indexPath.row];
	UIImage *appIcon = [UIImage _applicationIconImageForBundleIdentifier:data.applicationIdentifier format:1];
	cell.titleLabel.text = data.notificationTitle;
	cell.detailLabel.text = data.notificationContent;
	cell.icon.image = appIcon;
	cell.timeLabel.text = [NSDateFormatter localizedStringFromDate:data.notificationDate dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self showDetailViewController:[[NTSNotificationDetailsTableViewController alloc] initWithNotification:self.cells[indexPath.row]] sender:self];
//	[self.navigationController pushViewController:[[NTSNotificationDetailsViewController alloc] initWithCell:self.cells[indexPath.row]] animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		if ([[NSUserDefaults standardUserDefaults] boolForKey:@"alertBeforeDeletion"]) {
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"] message:@"Do you really want to delete this notification? This cannot be undone." preferredStyle:UIAlertControllerStyleActionSheet];
			[alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
				[self.cells removeObjectAtIndex:indexPath.row];
				[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			}]];
			[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
			[self presentViewController:alert animated:YES completion:nil];

		} else {
			[self.cells removeObjectAtIndex:indexPath.row];
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
		}
	}
}

#pragma mark - Context Menu (iOS 13.0+)
- (UIContextMenuConfiguration *)tableView:(UITableView *)tableView contextMenuConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point API_AVAILABLE(ios(13.0)) {

	UIAction *deleteAction = [UIAction actionWithTitle:@"Delete" image:[UIImage systemImageNamed:@"trash.fill"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
		[self.cells removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	}];
	deleteAction.attributes = UIMenuElementAttributesDestructive;

	return [UIContextMenuConfiguration configurationWithIdentifier:[NSString stringWithFormat:@"%ld|%ld", (long)indexPath.row, (long)indexPath.section] previewProvider:nil actionProvider:^UIMenu * _Nullable (NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
		return [UIMenu menuWithTitle:@"" children:@[
			[UIMenu menuWithTitle:@"Copy..." children:@[
				[UIAction actionWithTitle:@"Copy Application Name" image:[UIImage systemImageNamed:@"doc.on.doc"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
					[UIPasteboard generalPasteboard].string = self.cells[indexPath.row].applicationName;
				}],
				[UIAction actionWithTitle:@"Copy Bundle Identifier" image:[UIImage systemImageNamed:@"doc.on.doc"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
					[UIPasteboard generalPasteboard].string = self.cells[indexPath.row].applicationIdentifier;
				}],
				[UIAction actionWithTitle:@"Copy Header" image:[UIImage systemImageNamed:@"doc.on.doc"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
					[UIPasteboard generalPasteboard].string = self.cells[indexPath.row].notificationTitle;
				}],
				[UIAction actionWithTitle:@"Copy Content" image:[UIImage systemImageNamed:@"doc.on.doc"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
					[UIPasteboard generalPasteboard].string = self.cells[indexPath.row].notificationContent;
				}],
				[UIAction actionWithTitle:@"Copy Attachment" image:[UIImage systemImageNamed:@"doc.on.doc"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
					[UIPasteboard generalPasteboard].image = self.cells[indexPath.row].attachedImage;
				}],
				[UIAction actionWithTitle:@"Copy Date" image:[UIImage systemImageNamed:@"doc.on.doc"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
					[UIPasteboard generalPasteboard].string = [NSDateFormatter localizedStringFromDate:self.cells[indexPath.row].notificationDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
				}]
			]],
			[UIMenu menuWithTitle:@"Delete" image:[UIImage systemImageNamed:@"trash.fill"] identifier:nil options:UIMenuOptionsDestructive children:@[
				deleteAction,
				[UIAction actionWithTitle:@"Cancel" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {}]
			]]
		]];
	}];
}

- (void)tableView:(UITableView *)tableView willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator API_AVAILABLE(ios(13.0)) {
	[animator addCompletion:^{
		[self showDetailViewController:[[NTSNotificationDetailsTableViewController alloc] initWithNotification:self.cells[[[(NSString *)configuration.identifier componentsSeparatedByString:@"|"][0] intValue]]] sender:self];
	}];
	animator.preferredCommitStyle = UIContextMenuInteractionCommitStyleDismiss; // avoid leftover cell highlight
}

#pragma mark - Peek & Pop
- (nullable UIViewController *)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	previewingContext.sourceRect = cell.frame;
	return [[NTSNotificationDetailsTableViewController alloc] initWithNotification:self.cells[indexPath.row]];
}

- (void)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext commitViewController:(nonnull UIViewController *)viewControllerToCommit {
	[self showDetailViewController:viewControllerToCommit sender:self];
}

@end
