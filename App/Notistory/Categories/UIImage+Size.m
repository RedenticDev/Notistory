#import "UIImage+Size.h"

@implementation UIImage (Size)

- (UIImage *)nts_imageScaledToSize:(CGSize)newSize {
	UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
	[self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end
