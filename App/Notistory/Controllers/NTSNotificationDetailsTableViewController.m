#import "NTSNotificationDetailsTableViewController.h"
#import "NTSImageDetailViewController.h"

@implementation NTSNotificationDetailsTableViewController

- (instancetype)initWithNotification:(NTSNotification *)notification {
    if (self = [super init]) {
        self.notification = notification;
    }
    return self;
}

- (void)loadView {
	[super loadView];
	
	if (self.notification.applicationIdentifier && self.notification.notificationDate) {
		self.title = [NSString stringWithFormat:@"%@ - %@", self.notification.applicationName, [NSDateFormatter localizedStringFromDate:self.notification.notificationDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]];
		if (@available(iOS 11.0, *)) {
			self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
		}
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"showPreview"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showPreview"]) {
		UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
		if (self.notification.isUsable) {
			// background
			[UIView nts_addGradientToView:&headerView firstColor:[UIColor lightGrayColor] secondColor:[UIColor grayColor] rotation:0];
			// banner
			dispatch_async(dispatch_get_main_queue(), ^{
				// TODO: create banner
			});
		} else {
			UILabel *errorLabel = [[UILabel alloc] init];
			errorLabel.numberOfLines = 0;
			errorLabel.text = NSLocalizedString(@"PREVIEW_ERROR", nil);
			errorLabel.textAlignment = NSTextAlignmentCenter;
			[errorLabel sizeToFit];
			errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
			[headerView addSubview:errorLabel];

			[NSLayoutConstraint activateConstraints:@[
				[errorLabel.widthAnchor constraintLessThanOrEqualToConstant:headerView.frame.size.width],
				[errorLabel.centerXAnchor constraintEqualToAnchor:headerView.centerXAnchor],
				[errorLabel.centerYAnchor constraintEqualToAnchor:headerView.centerYAnchor]
			]];
		}

		self.tableView.tableHeaderView = headerView;
	}
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 44.0;
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Table View Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
	}
	NSArray *labels = @[@"name", @"identifier", @"header", @"content", @"attachment", @"date"];
	if (@available(iOS 14.0, *)) {
		UIListContentConfiguration *config = [UIListContentConfiguration subtitleCellConfiguration];
		config.secondaryTextProperties.numberOfLines = 0;
		config.secondaryTextProperties.lineBreakMode = NSLineBreakByTruncatingTail;
		config.text = NSLocalizedString([labels[indexPath.row] uppercaseString], nil);
		if ([self.notification.notificationDictionary[labels[indexPath.row]] isKindOfClass:[NSDate class]]) {
			config.secondaryText = [NSDateFormatter localizedStringFromDate:self.notification.notificationDictionary[labels[indexPath.row]] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
		} else if ([labels[indexPath.row] isEqualToString:@"attachment"]) {
			BOOL isImage = self.notification.notificationDictionary[labels[indexPath.row]] != [NSNull null];
			config.secondaryText = [NSString stringWithFormat:NSLocalizedString(@"IMAGE", nil), isImage ? 1 : 0];
			if (isImage) {
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
		} else {
			config.secondaryText = self.notification.notificationDictionary[labels[indexPath.row]];
		}
		cell.contentConfiguration = config;
	} else {
		cell.detailTextLabel.numberOfLines = 0;
		cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
		cell.textLabel.text = NSLocalizedString([labels[indexPath.row] uppercaseString], nil);
		if ([self.notification.notificationDictionary[labels[indexPath.row]] isKindOfClass:[NSDate class]]) {
			cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:self.notification.notificationDictionary[labels[indexPath.row]] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
		} else if ([labels[indexPath.row] isEqualToString:@"attachment"]) {
			BOOL isImage = self.notification.notificationDictionary[labels[indexPath.row]] != [NSNull null];
			cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"IMAGE", nil), isImage ? 1 : 0];
			if (isImage) {
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
		} else {
			cell.detailTextLabel.text = self.notification.notificationDictionary[labels[indexPath.row]];
		}
	}
	if (cell.accessoryType != UITableViewCellAccessoryDisclosureIndicator) {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.notification.notificationDictionary.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	CGFloat goodHeight = [cell.detailTextLabel.text boundingRectWithSize:CGSizeMake(cell.frame.size.width * 2 / 3, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont systemFontSize]]} context:nil].size.height;
	return goodHeight > 44.0 ? goodHeight + 20.0 : 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"ATTACHMENT", nil)] && cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
		[self.navigationController pushViewController:[[NTSImageDetailViewController alloc] initWithImage:self.notification.notificationDictionary[@"attachment"]] animated:YES];
	} else {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
	return @[
		[UIPreviewActionGroup actionGroupWithTitle:@"Copy..." style:UIPreviewActionStyleDefault actions:@[
			[UIPreviewAction actionWithTitle:@"Copy Application Name" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
				[UIPasteboard generalPasteboard].string = self.notification.applicationName;
			}],
			[UIPreviewAction actionWithTitle:@"Copy Bundle Identifier" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
				[UIPasteboard generalPasteboard].string = self.notification.applicationIdentifier;
			}],
			[UIPreviewAction actionWithTitle:@"Copy Header" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
				[UIPasteboard generalPasteboard].string = self.notification.notificationTitle;
			}],
			[UIPreviewAction actionWithTitle:@"Copy Content" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
				[UIPasteboard generalPasteboard].string = self.notification.notificationContent;
			}],
			[UIPreviewAction actionWithTitle:@"Copy Attachment" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
				[UIPasteboard generalPasteboard].image = self.notification.attachedImage;
			}],
			[UIPreviewAction actionWithTitle:@"Copy Date" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
				[UIPasteboard generalPasteboard].string = [NSDateFormatter localizedStringFromDate:self.notification.notificationDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
			}],
			[UIPreviewAction actionWithTitle:@"Cancel" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {}]
		]],
		[UIPreviewActionGroup actionGroupWithTitle:@"Delete" style:UIPreviewActionStyleDestructive actions:@[
			[UIPreviewAction actionWithTitle:@"Delete" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
			NSLog(@"%@, %@", action, previewViewController);
			}],
			[UIPreviewAction actionWithTitle:@"Cancel" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {}]
		]]
	];
}

@end
