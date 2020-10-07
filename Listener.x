#include <objc/runtime.h>
#include <dlfcn.h>
#import <libactivator/libactivator.h>

@interface CPNotification : NSObject
+ (void)hideAlertWithBundleId:(NSString *)bundleId uuid:(NSString *)uuid;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message userInfo:(NSDictionary *)userInfo badgeCount:(int)badgeCount soundName:(NSString *)soundName delay:(double)delay repeats:(BOOL)repeats bundleId:(NSString *)bundleId uuid:(NSString *)uuid silent:(BOOL)silent;
@end

static NSString *bundleID = @"com.lns.notificatorListener";
static LAActivator *_LASharedActivator;
static NSMutableArray *uniqueIdentifiers;
static NSMutableDictionary *listeners;
static NSArray *items;

@interface NotificatorListener : NSObject <LAListener>
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *uniqueIdentifier;
@property (nonatomic, assign) BOOL revoked;

+ (void)loadPrefs;
- (void)revoke;
@end

static void loadPrefs() {
	[NotificatorListener loadPrefs];
}

@implementation NotificatorListener

+ (void)load {
	uniqueIdentifiers=[NSMutableArray array];
	listeners=[NSMutableDictionary dictionary];
	void *la = dlopen("/usr/lib/libactivator.dylib", RTLD_LAZY);
	if (!la) {
		HBLogDebug(@"Failed to load libactivator");
		_LASharedActivator = nil;
	} else {
		_LASharedActivator = [objc_getClass("LAActivator") sharedInstance];
	}

	[self loadPrefs];
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.lns.notificator/prefsupdate"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}

+ (void)loadPrefs {
	NSFileManager *fm=[NSFileManager defaultManager];
	if(![fm fileExistsAtPath:@"/User/Library/Preferences/com.lns.notificator.prefs.plist" isDirectory:nil]){
		return;
	}
	NSMutableDictionary *prefs=[NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.lns.notificator.prefs.plist"]];
	items=prefs[@"array"];
	for(NSString *idt in uniqueIdentifiers){
		BOOL __keep=NO;
		for(NSArray *subarr in items){
			if([subarr[2] isEqualToString:idt]){
				__keep=YES;
				break;
			}
		}
		if(!__keep){
			[listeners[idt] revoke];
			[listeners removeObjectForKey:idt];
		}
	}
	[uniqueIdentifiers removeAllObjects];
	for(NSArray *subarr in prefs[@"array"]){
		if(listeners[subarr[2]]==nil){
			listeners[subarr[2]]=[[self alloc] initWithTitle:subarr[0] content:subarr[1] uniqueIdentifier:subarr[2]];
		}
		//[_LASharedActivator registerListener:self forName:[@"com.lns.notificator.sub." stringByAppendingString:subarr[2]]];
		[uniqueIdentifiers addObject:subarr[2]];
	}
}

- (NSString *)fullIdentifier {
	return [@"com.lns.notificator.sub." stringByAppendingString:self.uniqueIdentifier];
}

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content uniqueIdentifier:(NSString *)uniqueIdentifier {
	if (self=[super init]) {
		self.title=title;
		self.content=content;
		self.uniqueIdentifier=uniqueIdentifier;
		[_LASharedActivator registerListener:self forName:[self fullIdentifier]];
	}
	return self;
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
	return [NSString stringWithFormat:@"Notificator/%@",self.title,nil];
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
	return @"Notificator: Display a notification.";
}

- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName {
    return @[@"springboard", @"lockscreen", @"application"];
}

- (UIImage *)activator:(LAActivator *)activator requiresIconForListenerName:(NSString *)listenerName scale:(CGFloat)scale {
	return nil;
}

- (UIImage *)activator:(LAActivator *)activator requiresSmallIconForListenerName:(NSString *)listenerName scale:(CGFloat)scale {
	return nil;
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	void *handle = dlopen("/usr/lib/libnotifications.dylib", RTLD_LAZY);
	if (handle != NULL && [bundleID length] > 0) {      
		NSString *uid = [[NSUUID UUID] UUIDString];        
  		[%c(CPNotification) showAlertWithTitle:self.title
							message:self.content
							userInfo:@{@"" : @""}
							badgeCount:0
							soundName:nil
							delay:1.00
							repeats:NO
							bundleId:@"com.apple.Preferences"
							uuid:uid
							silent:NO];
		dlclose(handle);
	}
}

- (void)revoke {
	[_LASharedActivator unregisterListenerWithName:[self fullIdentifier]];
	self.revoked=YES;
}

- (void)dealloc {
	if(!self.revoked)[self revoke];
}


@end
