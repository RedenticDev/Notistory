// @interface NCNotificationContent : NSObject
// @property (nonatomic, readonly) UIImage *attachmentImage;
// @property (nonatomic, copy, readonly) NSString *title;
// @property (nonatomic, copy, readonly) NSString *message;
// @property (nonatomic, readonly) NSDate *date;
// @end

// @interface NCNotificationRequest : NSObject
// @property (nonatomic, copy, readonly) NSString *sectionIdentifier;
// @property (nonatomic, readonly) NCNotificationContent *content;
// @end

// @interface LSResourceProxy : NSObject
// @property (nonatomic, copy) NSString *localizedName;
// @end

// @interface LSApplicationProxy : LSResourceProxy
// + (LSApplicationProxy *)applicationProxyForIdentifier:(NSString *)identifier;
// @end

%hook NCNotificationRequest

- (instancetype)init {
    id notification = %orig;

    if (notification) {
        // Get data
        NSString *bundleID = self.sectionIdentifier;
        NSString *appName = [LSApplicationProxy applicationProxyForIdentifier:bundleID].localizedName;
        UIImage *attachment = self.content.attachmentImage;
        NSString *title = self.content.title;
        NSString *content = self.content.message;
        NSDate *date = self.content.date;
        NSLog(@"[Notistory] New notification received: %@ - %@", appName, content);
        // Save in file
        if (![bundleID isEqualToString:@"com.apple.nanosystemsettingsd.batterychargedreminder"]) {}
    }

    return notification;
}

%end