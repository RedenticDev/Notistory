#import "UIView+Gradient.h"

@implementation UIView (Gradient)

+ (UIView *)nts_addGradientToView:(UIView **)view firstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor rotation:(float)rotation {

	// - 'rotation' is between 0 and 1 (0 - 360 degrees)
	// - firstColor starts on top, with secondColor below
	// - rotations move anti-clockwise

	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = (*view).frame;
	gradient.colors = @[(id)firstColor.CGColor, (id)secondColor.CGColor];
	[(*view).layer insertSublayer:gradient atIndex:0];

	float x1 = pow(sinf((2 * M_PI * ((rotation + 0.75) / 2))), 2);
	float y1 = pow(sinf((2 * M_PI * (rotation / 2))), 2);
	float x2 = pow(sinf((2 * M_PI * ((rotation + 0.25) / 2))), 2);
	float y2 = pow(sinf((2 * M_PI * ((rotation + 0.5) / 2))), 2);

	gradient.startPoint = CGPointMake(x1, y1);
	gradient.endPoint = CGPointMake(x2, y2);

	return *view;
}

@end
