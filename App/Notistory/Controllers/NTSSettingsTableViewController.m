#import "NTSContributorsTableViewController.h"
#import "NTSLinkTableViewCell.h"
#import "NTSListTableViewCell.h"
#import "NTSListTableViewController.h"
#import "NTSSegmentTableViewCell.h"
#import "NTSSettingsTableViewController.h"
#import "NTSSwitchTableViewCell.h"

@implementation NTSSettingsTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
	if (@available(iOS 13.0, *)) {
		return self = [super initWithStyle:UITableViewStyleInsetGrouped];
	} else {
		return self = [super initWithStyle:UITableViewStyleGrouped];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];

	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];

	UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	shadowView.translatesAutoresizingMaskIntoConstraints = NO;
	shadowView.clipsToBounds = NO;
	shadowView.layer.shadowColor = [UIColor systemGrayColor].CGColor;
	shadowView.layer.shadowOpacity = .5;
	shadowView.layer.shadowOffset = CGSizeMake(1, 1);
	shadowView.layer.shadowRadius = 7.0;
	shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:shadowView.bounds cornerRadius:shadowView.frame.size.width / 6.4].CGPath;

	UIImageView *logoView = [[UIImageView alloc] initWithFrame:shadowView.bounds];
	logoView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AppIcon1024x1024" ofType:@".png" inDirectory:@"Assets"]];
	logoView.clipsToBounds = YES;
	logoView.layer.cornerRadius = logoView.frame.size.width / 6.4;
	[shadowView addSubview:logoView];

	UILabel *titleView = [[UILabel alloc] init];
	titleView.translatesAutoresizingMaskIntoConstraints = NO;
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"] attributes:@{
		NSFontAttributeName : [UIFont boldSystemFontOfSize:[UIFont systemFontSize] + 8.0]
	}];
	[string appendAttributedString:[[NSAttributedString alloc] initWithString:[@" • v%@" stringByAppendingString: [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]] attributes:@{
		NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize] + 8.0]
	}]];
	titleView.attributedText = string;
	titleView.textAlignment = NSTextAlignmentCenter;

	[headerView addSubview:shadowView];
	[headerView addSubview:titleView];

	NSDictionary *views = @{@"shadow" : shadowView, @"label" : titleView};

	[headerView addConstraints:@[
		[NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100],
		[NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100],
		[NSLayoutConstraint constraintWithItem:shadowView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]
	]];
	[headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	[headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[shadow]-10-[label]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

	self.tableView.tableHeaderView = headerView;
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 44.0;
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUITheme:) name:@"updateUI" object:nil];
	[self updateUITheme:nil];
}

- (void)loadView {
	[super loadView];

	self.title = NSLocalizedString(@"SETTINGS", nil);
	if (@available(iOS 11.0, *)) {
		self.navigationController.navigationBar.prefersLargeTitles = YES;
	}
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeSettings:)];
}

- (void)closeSettings:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateUITheme:(id)sender {
	if (@available(iOS 13.0, *)) {
		NSInteger forcedTheme = [[NSUserDefaults standardUserDefaults] integerForKey:@"forcedTheme"];
		UIViewController *navVC = self.navigationController;
		if (forcedTheme > 0 && navVC.overrideUserInterfaceStyle != forcedTheme) {
			navVC.overrideUserInterfaceStyle = forcedTheme == navVC.overrideUserInterfaceStyle ? navVC.overrideUserInterfaceStyle : forcedTheme;
		}
	}
}

#pragma mark - Table View Delegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 1:
			return @"Global Settings";

		case 2:
			return @"Main page";

		case 3:
			return @"Details page";

		case 4:
			return @"Attachment detail page";

		case 5:
			return @"Contributors";

		case 6:
			return @"Support";

		case 0:
		default:
			return [super tableView:tableView titleForHeaderInSection:section];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 55.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	if (section == [tableView numberOfSections] - 1) {
		UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0 - self.tableView.separatorInset.left, 0, self.tableView.bounds.size.width, 100)];
		UILabel *footerLabel = [[UILabel alloc] initWithFrame:footerView.frame];
		footerLabel.text = @"Made with ❤️ by RedenticDev";
		footerLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize] - 1.0];
		footerLabel.textColor = [UIColor grayColor];
		footerLabel.textAlignment = NSTextAlignmentCenter;
		[footerView addSubview:footerLabel];

		return footerView;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (section == [tableView numberOfSections] - 1) {
		return 100;
	}
	return [super tableView:tableView heightForFooterInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *identifier = [NSString stringWithFormat:@"s%li-r%li", (long)indexPath.section, (long)indexPath.row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0:
					cell = [[NTSLinkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
					[(NTSLinkTableViewCell *)cell twitterCellWithName:@"Redentic" profile:@"RedenticDev"];
					break;

				case 1: {
					cell = [[NTSSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
					[(NTSSwitchTableViewCell *)cell configureCellWithLabel:@"Enabled" defaultValue:YES key:@"enabled"];
					break;
				}

				default:
					break;
			}
			break;

		case 1:
			switch (indexPath.row) {
				case 0:
					cell = [[NTSSegmentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
					[(NTSSegmentTableViewCell *)cell configureCellWithTitle:@"Force theme (iOS 13+)" segmentElements:@[
						@"Default", @"Light Theme", @"Dark Theme"
					] index:0 key:@"forcedTheme"];
					break;

				case 1:
					cell = [[NTSListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
					[(NTSListTableViewCell *)cell configureCellWithLabel:@"Date format" titles:@[ @"Date format", @"Time format" ] contents:@[
						@[
							@"No date", @"Short style",
							@"Medium style", @"Long style",
							@"Full style"
						],
						@[
							@"No time", @"Short style",
							@"Medium style", @"Long style",
							@"Full style"
						]
					] defaults:@[ @1, @1 ] keys:@[ @"dateFormat", @"timeFormat" ]];
					// https://github.com/zbrateam/Zebra/blob/master/Zebra/Tabs/Home/Settings/ZBSettingsTableViewController.m#L413
					// https://github.com/zbrateam/Zebra/blob/master/Zebra/Tabs/Home/Settings/ZBSettingsSelectionTableViewController.m
					// https://stackoverflow.com/questions/5210535/passing-data-between-view-controllers/9736559
					// https://stackoverflow.com/questions/49139209/passing-data-between-view-controllers-without-segue
					// or reloading from viewWillAppear?
					break;

				case 2:
					cell = [[NTSListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
					[(NTSListTableViewCell *)cell configureCellWithLabel:@"Auto-delete after" titles:nil contents:@[
						@[
							@"Never", @"10 min", @"30 min", @"1 hour",
							@"1 day", @"1 week", @"1 month"
						]
					] defaults:@[ @0 ] keys:@[ @"autoDelete" ]];
					break;

				case 3: {
					cell = [[NTSSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
					[(NTSSwitchTableViewCell *)cell configureCellWithLabel:@"Always show main column (iPad)" defaultValue:NO key:@"showMainColumnIpad"];
					break;
				}

				default:
					break;
			}
			break;

		case 2:
			switch (indexPath.row) {
				case 0:
					cell = [[NTSSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
					[(NTSSwitchTableViewCell *)cell configureCellWithLabel:@"Show alert before deletion" defaultValue:YES key:@"alertBeforeDeletion"];
					break;

				case 1:
					cell = [[NTSSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
					[(NTSSwitchTableViewCell *)cell configureCellWithLabel:@"Show application icon" defaultValue:YES key:@"showAppIcon"];
					break;

				case 2:
					cell.textLabel.text = @"Customize items?";
					break;

				default:
					break;
			}
			break;

		case 3:
			switch (indexPath.row) {
				case 0:
					cell = [[NTSSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
					[(NTSSwitchTableViewCell *)cell configureCellWithLabel:@"Show notification preview" defaultValue:YES key:@"showPreview"];
					break;

				case 1:
					cell.textLabel.text = @"Customize preview?";

				default:
					break;
			}
			break;

		case 4:
			switch (indexPath.row) {
				case 0:
					cell = [[NTSSegmentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
					[(NTSSegmentTableViewCell *)cell configureCellWithTitle:@"Zoom type" segmentElements:@[ @"No Zoom", @"Auto", @"Manual" ] index:1 key:@"zoomType"];
					break;

				default:
					break;
			}
			break;

		case 5:
			switch (indexPath.row) {
				case 0:
					cell.textLabel.text = @"Contributors";
					cell.selectionStyle = UITableViewCellSelectionStyleDefault;
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					break;

				case 1:
					cell = [[NTSLinkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
					[(NTSLinkTableViewCell *)cell linkCellWithText:@"📖 Contribute to translations!" URL:[NSURL URLWithString:@"https://github.com/RedenticDev/TweaksLocalizations"]];
					break;

				default:
					break;
			}
			break;

		case 6:
			cell = [[NTSLinkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
			switch (indexPath.row) {
				case 0:
					[(NTSLinkTableViewCell *)cell linkCellWithText:@"☕️ Buy me a coffee" URL:[NSURL URLWithString:@"https://paypal.me/redenticdev"]];
					break;

				case 1:
					[(NTSLinkTableViewCell *)cell linkCellWithText:@"💡 Feature request?" URL:[NSURL URLWithString:@"mailto:hello@redentic.dev?subject=Notistory%20Feature%20Request"]];
					break;

				case 2:
					[(NTSLinkTableViewCell *)cell linkCellWithText:@"🐞 Found a bug?" URL:[NSURL URLWithString:@"https://github.com/RedenticDev/Notistory/issues/new"]];
					break;

				case 3:
					[(NTSLinkTableViewCell *)cell linkCellWithText:@"💻 Source code" URL:[NSURL URLWithString:@"https://github.com/RedenticDev/Notistory"]];
					break;

				default:
					break;
			}
			break;

		default:
			break;
		}
	}

	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
	case 0: // twitter + enable
		return 2;

	case 1: // global settings
		return 4;

	case 2: // root
		return 3;

	case 3: // detail
		return 2;

	case 4: // image details
		return 1;

	case 5: // contributors
		return 2;

	case 6: // contact
		return 4;

	default:
		return [super tableView:tableView numberOfRowsInSection:section];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	if ([cell isKindOfClass:[NTSSegmentTableViewCell class]]) {
		return 90;
	}
	if ([cell isKindOfClass:[NTSLinkTableViewCell class]]) {
		return 60;
	}
	return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath == [NSIndexPath indexPathForRow:0 inSection:5]) {
		[self.navigationController pushViewController:[[NTSContributorsTableViewController alloc] init] animated:YES];
	} else {
		UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
		if ([cell isKindOfClass:[NTSLinkTableViewCell class]]) {
            [[UIApplication sharedApplication] openURL:((NTSLinkTableViewCell *)cell).url options:@{} completionHandler:nil];
		} else if ([cell isKindOfClass:[NTSListTableViewCell class]]) {
			[self.navigationController pushViewController:[[NTSListTableViewController alloc] initWithCell:(NTSListTableViewCell **)&cell] animated:YES];
		}
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
 Settings:
 - Enable/disable app

 Global Settings
 - Force theme
 - Customize date format
 - Auto-delete after period of time
 - Main column always here or not in in portrait iPad

 Root
 - Enable/disable alert on delete
 - Enable/disable notification icon on main page
 - Customize root cell items?

 Detail
 - Enable/disable preview in detail
 - Customize preview (background choose color with app colors or custom/gradient
 with rotation and colors/none, use tweaks hs/ls)

 Image detail
 - Change zoom type in image details (instant dezoom/double tap to go back to
 original size)
 */
@end
