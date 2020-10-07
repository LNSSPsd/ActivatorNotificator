#include "NCTRootListController.h"
#import "NCTSenderSetViewController.h"

@implementation NCTRootListController

- (void)setRootController:(id)rc {
}
- (void)setParentController:(id)rc {
}
- (void)setSpecifier:(id)spec {
}

- (void)dismissKeyboard {
	[self.view endEditing:YES];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
	return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)changeSender {
	NCTSenderSetViewController *pvc=[[NCTSenderSetViewController alloc] initWithPreferencesManager:self];
	[self.navigationController pushViewController:pvc animated:YES];
}

- (void)viewDidLoad {
	self.navigationItem.rightBarButtonItems=@[[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveSettings)]/*,[[UIBarButtonItem alloc] initWithTitle:@"Change sender" style:UIBarButtonItemStylePlain target:self action:@selector(changeSender)]*/];
	self.editableCells=[NSMutableDictionary dictionary];
	self.title=@"Notificator";
	[self readPrefs];
	[super viewDidLoad];
	self.tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeInteractive;
	//[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
}

/*- (NSArray *)specifiers {
	return nil;
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}*/

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	/*if([self.prefs[@"array"] count]==0){
		return 2;
	}else{
		if(section==[self.prefs[@"array"] count]){
			return 2;
		}else{
			return 2;
		}
	}*/
	if([self.prefs[@"array"] count]!=0&&section<[self.prefs[@"array"] count]){
		return 4;
	}
	return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
	return [self.prefs[@"array"] count]+1;
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
	return nil;
}

- (void)saveSettings {
	for(id idx in self.editableCells){
		NSArray *arr=self.editableCells[idx];
		if([[[arr[0] textField] text] length]==0||[[[arr[1] textField] text] length]==0||[[[arr[2] textField] text] length]==0){
			UIAlertController *errorTip=[UIAlertController alertControllerWithTitle:@"Error" message:@"Values can't be empty." preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *dismissAction=[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
			[errorTip addAction:dismissAction];
			[self presentViewController:errorTip animated:YES completion:nil];
			return;
		}
	}
	for(int i=0;i<self.editableCells.count;i++){
		self.prefs[@"array"][i]=@[[self.editableCells[[NSNumber numberWithInt:i]][0] textField].text,[self.editableCells[[NSNumber numberWithInt:i]][1] textField].text,[self.editableCells[[NSNumber numberWithInt:i]][2] textField].text];
	}
	[self writePrefs];
	self.editableCells=[NSMutableDictionary dictionary];
	[self.tableView reloadData];
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tv deselectRowAtIndexPath:indexPath animated:YES];
	if(([self.prefs[@"array"] count]==0||indexPath.section==[self.prefs[@"array"] count])){
		if(indexPath.row==1){
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/LNSSPsd/ActivatorNotificator"] options:@{} completionHandler:nil];
			return;
			
			//ORIGINAL SAVE METHOD
			for(id idx in self.editableCells){
				NSArray *arr=self.editableCells[idx];
				if([[[arr[0] textField] text] length]==0||[[[arr[1] textField] text] length]==0||[[[arr[2] textField] text] length]==0){
					UIAlertController *errorTip=[UIAlertController alertControllerWithTitle:@"Error" message:@"Values can't be empty." preferredStyle:UIAlertControllerStyleAlert];
					UIAlertAction *dismissAction=[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
					[errorTip addAction:dismissAction];
					[self presentViewController:errorTip animated:YES completion:nil];
					return;
				}
			}
			for(int i=0;i<self.editableCells.count;i++){
				self.prefs[@"array"][i]=@[[self.editableCells[[NSNumber numberWithInt:i]][0] textField].text,[self.editableCells[[NSNumber numberWithInt:i]][1] textField].text,[self.editableCells[[NSNumber numberWithInt:i]][2] textField].text];
			}
			[self writePrefs];
			self.editableCells=[NSMutableDictionary dictionary];
			[tv reloadData];
			return;
		}
		if(!self.prefs[@"array"]){
			self.prefs[@"array"]=[NSMutableArray array];
		}else{
			self.prefs[@"array"]=[NSMutableArray arrayWithArray:self.prefs[@"array"]];
		}
		[self.prefs[@"array"] addObject:@[@"",@"",@""]];
		//[self writePrefs];
		self.editableCells=[NSMutableDictionary dictionary];
		[tv reloadData];
	}else{
		if(indexPath.row==3){
			[self.prefs[@"array"] removeObjectAtIndex:indexPath.section];
			[self writePrefs];
			self.editableCells=[NSMutableDictionary dictionary];
			[tv reloadData];
		}
	}
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if([self.prefs[@"array"] count]==0||indexPath.section==[self.prefs[@"array"] count]){
		UITableViewCell *simpleClickCell=[UITableViewCell new];
		if(indexPath.row==0){
			simpleClickCell.textLabel.text=@"Add notification item";
		}else{
			simpleClickCell.textLabel.text=@"Source Code";
		}
		simpleClickCell.textLabel.textColor=[UIColor colorWithRed:0 green:0.478 blue:1 alpha:1];
		return simpleClickCell;
	}else{
		if(indexPath.row==3){
			UITableViewCell *simpleClickCell=[UITableViewCell new];
			simpleClickCell.textLabel.text=@"Remove ^";
			simpleClickCell.textLabel.textColor=[UIColor redColor];
			return simpleClickCell;
		}
		NSArray *things=self.prefs[@"array"][indexPath.section];
		PSEditableTableCell *editableCell=[[PSEditableTableCell alloc] initWithStyle:1000 reuseIdentifier:nil specifier:nil];
		if(indexPath.row==0){
			[editableCell textField].placeholder=@"Title";
		}else if(indexPath.row==1){
			[editableCell textField].placeholder=@"Content";
		}else if(indexPath.row==2){
			[editableCell textField].placeholder=@"UNIQUE IDENTIFIER";
		}
		if([things[indexPath.row] length]!=0){
			editableCell.userInteractionEnabled=NO;
		}
		//[editableCell textField].placeholder=(indexPath.row==0)?@"Title":@"Content";
		[editableCell textField].text=things[indexPath.row];
		if(!self.editableCells[[NSNumber numberWithInt:indexPath.section]]){
			self.editableCells[[NSNumber numberWithInt:indexPath.section]]=[NSMutableArray array];
		}
		self.editableCells[[NSNumber numberWithInt:indexPath.section]][indexPath.row]=editableCell;
		return editableCell;
	}
}

/*- (void)prefs {
	NSFileManager *fm=[NSFileManager defaultManager];
	if(![fm fileExistsAtPath:@"/User/Library/Preferences/com.lns.notificator.prefs.plist" isDirectory:nil]){
		return [NSMutableDictionary dictionary];
	}
	_prefs=[NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.lns.notificator.prefs.plist"]];
	return _prefs;
}*/

- (void)readPrefs {
	NSFileManager *fm=[NSFileManager defaultManager];
	if(![fm fileExistsAtPath:@"/User/Library/Preferences/com.lns.notificator.prefs.plist" isDirectory:nil]){
		_prefs=[NSMutableDictionary dictionary];
		return;
	}
	_prefs=[NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.lns.notificator.prefs.plist"]];
}

- (void)writePrefs {
	[_prefs writeToFile:@"/User/Library/Preferences/com.lns.notificator.prefs.plist" atomically:YES];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lns.notificator/prefsupdate"), NULL, NULL, YES);
	return;
}

- (NSString *)senderApplication {
	if(self.prefs[@"sender"]==nil)return @"com.apple.Preferences";
	return self.prefs[@"sender"];
}

@end
