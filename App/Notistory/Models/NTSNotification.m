#import "NTSNotification.h"

@implementation NTSNotification

- (instancetype)initWithIdentifier:(NSString *)bundleIdentifier name:(NSString *)name title:(NSString *)title content:(NSString *)content attachedImage:(UIImage *)attachedImage date:(NSDate *)date {
	if (self = [super init]) {
		self.applicationIdentifier = bundleIdentifier; // bundle identifier
		self.applicationName = name; // app name
		self.notificationTitle = title; // header
		self.notificationContent = content; // message
		self.attachedImage = attachedImage; // attachmentImage
		self.notificationDate = date; // date
	}
	return self;
}

- (NSDictionary *)notificationDictionary {
	return @{
		@"name" : self.applicationName,
		@"identifier" : self.applicationIdentifier,
		@"header" : self.notificationTitle,
		@"content" : self.notificationContent,
		@"attachment" : self.attachedImage ?: [NSNull null],
		@"date" : self.notificationDate
	};
}

- (BOOL)isUsable {
	return self.applicationIdentifier && self.applicationName && (self.notificationTitle || self.notificationContent) && self.notificationDate;
}

@end
