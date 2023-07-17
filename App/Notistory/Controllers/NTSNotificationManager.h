#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NTSNotificationManager : NSObject
@property(nonatomic, strong) NSMutableArray *notifications;
+ (instancetype)manager;
@end

NS_ASSUME_NONNULL_END
