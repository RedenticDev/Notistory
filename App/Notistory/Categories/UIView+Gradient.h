#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Gradient)
+ (UIView *)nts_addGradientToView:(UIView * _Nonnull * _Nonnull)view firstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor rotation:(float)rotation;
@end

NS_ASSUME_NONNULL_END
