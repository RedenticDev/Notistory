#import "NTSSegmentTableViewCell.h"

@implementation NTSSegmentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		// Label
		self.titleLabel = [[UILabel alloc] init];
		self.titleLabel.numberOfLines = 1;
		self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
		self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview:self.titleLabel];
		// frame + sizeToFit

		// Segment
		self.segment = [[UISegmentedControl alloc] initWithItems:@[]];
		self.segment.selectedSegmentIndex = 0;
		self.segment.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview:self.segment];

		self.selectionStyle = UITableViewCellSelectionStyleNone;

		NSDictionary *views = @{
			@"title" : self.titleLabel,
			@"segment" : self.segment
		};

		CGFloat leftInset = self.separatorInset.left;

		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[title]-10-[segment]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%.f-[title]-|", leftInset] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
		[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%.f-[segment]-|", leftInset] options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:views]];
	}
	return self;
}

- (void)configureCellWithTitle:(NSString *)title segmentElements:(NSArray<NSString *> *)elements index:(NSInteger)index key:(NSString *)key {
	self.titleLabel.text = title;
	[self.segment removeAllSegments];
	for (NSString *element in elements) {
		[self.segment insertSegmentWithTitle:element atIndex:[elements indexOfObject:element] animated:YES];
	}
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults objectForKey:key]) {
		self.segment.selectedSegmentIndex = [defaults integerForKey:key];
	} else {
		self.segment.selectedSegmentIndex = index;
		[defaults setInteger:index forKey:key];
	}
	[self.segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
	self.key = key;
}

- (void)segmentChanged:(UISegmentedControl *)sender {
	[[NSUserDefaults standardUserDefaults] setInteger:self.segment.selectedSegmentIndex forKey:self.key];

	if ([self.key isEqualToString:@"forcedTheme"]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"updateUI" object:nil];
	}
}

@end
