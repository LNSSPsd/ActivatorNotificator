#import "NCTSenderSetViewController.h"

@implementation NCTSenderSetViewController

- (instancetype)initWithPreferencesManager:(NCTRootListController *)manager {
	self=[super initWithStyle:UITableViewStyleGrouped];
	self.preferencesManager=manager;
	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
	return 3;
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
	if(section==0){
		return @"Current";
	}else if(section==1){
		return @"Recommended";
	}else{
		return @"All apps";
	}
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	if(section==0||section==1)return 1;
	self.allApps=[NSMutableArray array];
	self.title=@"Change sender";
	for(id index in [ALApplicationList sharedApplicationList].applications){
		[self.allApps addObject:[ALApplicationList sharedApplicationList].applications[index]];
	}
	return [ALApplicationList sharedApplicationList].applications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section==0){
		ALValueCell *valueCell=[ALValueCell new];
		[valueCell loadValue:[ALApplicationList sharedApplicationList].applications[[self.preferencesManager senderApplication]]];
		return valueCell;
	}else if(indexPath.section==1){
		ALValueCell *valueCell=[ALValueCell new];
		[valueCell loadValue:[ALApplicationList sharedApplicationList].applications[@"com.apple.Preferences"]];
		return valueCell;
	}else{
		ALValueCell *valueCell=[ALValueCell new];
		[valueCell loadValue:self.allApps[indexPath.row]];
		return valueCell;
	}
}

@end
