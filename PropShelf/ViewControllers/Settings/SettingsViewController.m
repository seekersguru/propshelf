//
//  SettingsViewController.m
//  PropShelf
//
//  Created by Gaurang Patel on 11/19/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import "SettingsViewController.h"

#import "UserProfile/UserProfileViewController.h"

#import "AboutViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"SETTINGS_NAV_TITLE", nil);
}

#pragma mark - tablview datasource required methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"Profile";
        
        cell.imageView.image = [UIImage imageNamed:@"Profile"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row == 1) {
        
        cell.textLabel.text = @"About";
        
        cell.imageView.image = [UIImage imageNamed:@"About"];

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row == 2) {
        
        cell.textLabel.text = @"LogOut";
        
        cell.imageView.image = [UIImage imageNamed:@"logout"];

        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - tablview delegate  methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserProfileStoryboard" bundle:nil];
        UserProfileViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"UserProfile"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == 1) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AboutStoryboard" bundle:nil];
        AboutViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"About"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == 2) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"PropShelf" message:@"Are you sure you want to logout?" delegate:nil cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
