#import "NTSListTableViewCell.h"

@implementation NTSListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

		// Accessory label
		self.accessoryLabel = [[UILabel alloc] init];
		self.accessoryLabel.text = @"None";
		self.accessoryLabel.textColor = [UIColor systemGrayColor];
		self.accessoryLabel.numberOfLines = 1;
		self.accessoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview:self.accessoryLabel];

		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[accessory]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"accessory" : self.accessoryLabel}]];
		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[accessory]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"accessory" : self.accessoryLabel}]];

		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	return self;
}

- (void)configureCellWithLabel:(NSString *)title titles:(NSArray *)titles contents:(NSArray<NSArray *> *)contents defaults:(NSArray *)defaults keys:(NSArray *)keys {
	self.textLabel.text = title;
	[self setAccessoryLabelFromContents:contents indexes:defaults keys:keys];
	self.titles = titles;
	self.contents = contents;
	self.defaults = defaults;
	self.keys = keys;
}

- (void)setAccessoryLabelFromContents:(NSArray<NSArray *> *)contents indexes:(NSArray *)indexes keys:(NSArray *)keys {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	for (int i = 0; i < keys.count; i++) {
		[array addObject:[settings objectForKey:keys[i]] ? contents[i][[settings integerForKey:keys[i]]] : contents[i][[indexes[i] intValue]]];
	}
	self.accessoryLabel.text = [array componentsJoinedByString:@", "];
}

@end
