#import "NTSListTableViewController.h"

@implementation NTSListTableViewController

- (instancetype)initWithCell:(NTSListTableViewCell **)cell {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		_cell = cell;
		NSLog(@"1. %ld", (unsigned long)(*_cell).contents.count);
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)loadView {
	[super loadView];

	self.title = (*_cell).textLabel.text;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSLog(@"2. %ld", (unsigned long)(*_cell).contents.count);
    return (*_cell).contents.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return (*_cell).contents[section].count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return (*_cell).titles[section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
	}
	cell.textLabel.text = (*_cell).contents[indexPath.section][indexPath.row];
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	if (indexPath.row == ([settings objectForKey:(*_cell).keys[indexPath.section]] ? [settings integerForKey:(*_cell).keys[indexPath.section]] : [(*_cell).defaults[indexPath.section] intValue])) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	for (int i = 0; i < [tableView numberOfRowsInSection:indexPath.section]; i++) {
		[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]].accessoryType = i == indexPath.row ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:(*_cell).keys[indexPath.section]];
	NSMutableArray *newIndexes = [(*_cell).defaults mutableCopy];
	newIndexes[indexPath.section] = [NSNumber numberWithLong:indexPath.row];
	[*_cell setAccessoryLabelFromContents:(*_cell).contents indexes:newIndexes keys:(*_cell).keys];
}

@end
