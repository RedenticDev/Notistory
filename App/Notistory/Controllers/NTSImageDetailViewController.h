#import <UIKit/UIKit.h>

@interface NTSImageDetailViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

-(instancetype)initWithImage:(UIImage *)image;
-(void)zoomToInitialScale:(UIGestureRecognizer *)sender;
@end
