#import <Foundation/Foundation.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSEditableTableCell.h>
#import <UIKit/UIKit.h>

#define DEFAULTS "com.lns.notificator.prefs"

@interface PSEditableTableCell ()

- (UITextField *)textField;

@end

@interface NCTRootListController : UITableViewController
@property (nonatomic, strong) NSMutableDictionary *prefs;
@property (nonatomic, strong) NSMutableDictionary *editableCells;
- (NSString *)senderApplication;

- (void)readPrefs;
- (void)writePrefs;
@end
