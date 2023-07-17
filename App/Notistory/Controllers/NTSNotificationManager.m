#import "NTSNotificationManager.h"

@implementation NTSNotificationManager

+ (instancetype)manager {
	static NTSNotificationManager *sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[NTSNotificationManager alloc] init];
	});

	return sharedInstance;
}

@end
