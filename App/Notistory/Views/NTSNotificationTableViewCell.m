#import "NTSNotificationTableViewCell.h"

@implementation NTSNotificationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		BOOL showIcon = [[NSUserDefaults standardUserDefaults] objectForKey:@"showAppIcon"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showAppIcon"];
		// Icon
		if (showIcon) {
			self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
			self.icon.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
			self.icon.center = CGPointMake(self.icon.center.x + 20, self.contentView.center.y);
			[self.contentView addSubview:self.icon];
		}

		// Main label
		self.titleLabel = [[UILabel alloc] init];
		self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize] + 2.0f];
		self.titleLabel.numberOfLines = 1;
		self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview:self.titleLabel];

		// Detail label
		self.detailLabel = [[UILabel alloc] init];
		if (@available(iOS 13.0, *)) {
			self.detailLabel.textColor = [UIColor secondaryLabelColor];
		} else {
			self.detailLabel.textColor = [UIColor systemGrayColor];
		}
		self.detailLabel.numberOfLines = 2;
		self.detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
		self.detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview:self.detailLabel];

		// Time label
		self.timeLabel = [[UILabel alloc] init];
		if (@available(iOS 13.0, *)) {
			self.timeLabel.textColor = [UIColor secondaryLabelColor];
		} else {
			self.timeLabel.textColor = [UIColor systemGrayColor];
		}
		self.timeLabel.numberOfLines = 1;
		self.timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview:self.timeLabel];

		NSDictionary *views;
		if (showIcon) {
			views = @{
				@"icon" : self.icon,
				@"title" : self.titleLabel,
				@"detail" : self.detailLabel,
				@"time" : self.timeLabel
			};
		} else {
			views = @{
				@"title" : self.titleLabel,
				@"detail" : self.detailLabel,
				@"time" : self.timeLabel
			};
		}

		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[time]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[title]-[detail]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:showIcon ? @"H:[icon]-12-[title]-[time]-|" : @"H:|-[title]-[time]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:showIcon ? @"H:[icon]-12-[detail]-|" : @"H:|-[detail]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];

		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	return self;
}

@end
