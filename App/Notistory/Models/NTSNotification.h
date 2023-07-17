#import <UIKit/UIKit.h>

@interface NTSNotification : NSObject
@property (nonatomic, strong) NSString *applicationIdentifier;
@property (nonatomic, strong) NSString *applicationName;
@property (nonatomic, strong) UIImage *attachedImage;
@property (nonatomic, strong) NSString *notificationTitle;
@property (nonatomic, strong) NSString *notificationContent;
@property (nonatomic, strong) NSDate *notificationDate;

-(instancetype)initWithIdentifier:(NSString *)bundleIdentifier name:(NSString *)name title:(NSString *)title content:(NSString *)content attachedImage:(UIImage *)attachedImage date:(NSDate *)date;
-(NSDictionary *)notificationDictionary;
-(BOOL)isUsable;
@end
