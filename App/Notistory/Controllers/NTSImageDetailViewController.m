#import "NTSImageDetailViewController.h"

@implementation NTSImageDetailViewController

- (instancetype)initWithImage:(UIImage *)image {
	if (self = [super init]) {
		self.image = image;
	}
	return self;
}

- (void)loadView {
	[super loadView];
	
	self.title = NSLocalizedString(@"ATTACHMENT", nil);
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	if (self.image) {
		CGFloat topHeight = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
		NSInteger zoomType = [[NSUserDefaults standardUserDefaults] integerForKey:@"zoomType"];

		self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topHeight, self.view.frame.size.width, self.view.frame.size.height - topHeight)];
		self.scrollView.minimumZoomScale = 1.0;
		self.scrollView.maximumZoomScale = zoomType == 0 ? 1.0 : 10.0;
		if (@available(iOS 13.0, *)) {
			self.scrollView.backgroundColor = [UIColor systemBackgroundColor];
		} else {
			self.scrollView.backgroundColor = [UIColor whiteColor];
		}
		self.scrollView.delegate = self;

		self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
		self.imageView.contentMode = UIViewContentModeScaleAspectFit;
		self.imageView.image = self.image;
		if (zoomType == 2) {
			UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomToInitialScale:)];
			doubleTap.numberOfTapsRequired = 2;
			[self.scrollView addGestureRecognizer:doubleTap];
		}

		[self.scrollView addSubview:self.imageView];
		[self.view addSubview:self.scrollView];
	}
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
	if ([[NSUserDefaults standardUserDefaults] integerForKey:@"zoomType"] == 1) {
		[self zoomToInitialScale:nil];
	}
}

- (void)zoomToInitialScale:(UIGestureRecognizer *)sender {
	if ((sender && [(UIScrollView *)sender.view zoomScale] > 1.0) || !sender) {
		[self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
	}
}

@end
