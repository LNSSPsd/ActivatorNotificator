#import "NCTRootListController.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AppList/AppList.h>
#import <AppList/ALValueCell.h>


@interface NCTSenderSetViewController : UITableViewController
@property (nonatomic, strong) NCTRootListController *preferencesManager;
@property (nonatomic, strong) NSMutableArray *allApps;

- (instancetype)initWithPreferencesManager:(NCTRootListController *)manager;
@end
