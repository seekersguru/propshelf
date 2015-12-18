//
//  GroupProfileViewController.m
//  PropShelf
//
//  Created by Gaurang Patel on 10/14/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import "GroupProfileViewController.h"

#import "ProfileViewController.h"

#import "UserProfileViewController.h"

@interface GroupProfileViewController () <UIActionSheetDelegate>

@end

@implementation GroupProfileViewController

@synthesize propertyStr;

@synthesize groupId;

@synthesize createGroupModelClass;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
    leaveGroupBtn.layer.cornerRadius = 5.0f;
    leaveGroupBtn.layer.masksToBounds = YES;

    CGFloat borderWidth = 1.0f;
    
    containerView.layer.borderColor = [UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:207.0/255.0 alpha:1.0].CGColor;
    containerView.layer.borderWidth = borderWidth;
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.cornerRadius = 4.0f;
    containerView.layer.masksToBounds = YES;
    
    containerView1.layer.borderColor = [UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:207.0/255.0 alpha:1.0].CGColor;
    containerView1.layer.borderWidth = borderWidth;
    containerView1.backgroundColor = [UIColor whiteColor];
    containerView1.layer.cornerRadius = 4.0f;
    containerView1.layer.masksToBounds = YES;

    propertylbl.text = self.propertyStr;
    descriptionTxtView.text = self.descriptionStr;
    
    [self getGroupUsers];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.isGroupJoined = [[NSUserDefaults standardUserDefaults] integerForKey:@"isGroupJoined"];

    if (self.isGroupJoined == 1) {
        
        [leaveGroupBtn setTitle:@"Leave Group" forState:UIControlStateNormal];
    }
    else {

        [leaveGroupBtn setTitle:@"Join Group" forState:UIControlStateNormal];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

#pragma mark - getGroupUsers Method

-(void)getGroupUsers {
    
    if ([NetworkError checkNetwork]) {
        
        [self showLoaderWithTitle:@"Loading Users..."];
        
        if (self.createGroupModelClass == nil) {
            
            self.createGroupModelClass = [[CreateGroupModelClass alloc] init];
            self.createGroupModelClass.delegate = self;
        }
                
        [self.createGroupModelClass getGroupUserRequest:groupId];
    }
    else {
        
        [self showAlertViewWithTitle:NSLocalizedString(@"NO_INTERNET_ALERT_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET_ALERT_MESSAGE", nil)];
        
        return;
    }
}

#pragma mark - Get Group Users Model Class Delegate

-(void)didCreateGroupSuccessfully:(NSString *)message {
    
    [self removeLoader];
}

-(void)didCreateGroupFailed:(ASIHTTPRequest *)therequest {
    
    [self removeLoader];
}

-(void)didGetGroupUserSuccessfully:(NSMutableArray *)userArray {
    
    recepientsArray = [userArray mutableCopy];
    
    [self.tableView reloadData];
    
    [self removeLoader];
}

-(void)didGetGroupUserFailed:(ASIHTTPRequest *)therequest {
    
    [self removeLoader];
}

#pragma mark - Button Action Method

-(IBAction)chatBtnTapped:(id)sender {
    
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)backBtnTapped:(id)sender {
    
    self.navigationController.navigationBarHidden = NO;

    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)unjoinBtnTapped:(id)sender {
    
    if ([leaveGroupBtn.titleLabel.text isEqualToString:@"Leave Group"]) {
     
        if ([NetworkError checkNetwork]) {
            
            [self showLoaderWithTitle:@"Leaving Group..."];
            
            if (self.getGroupsModelClass == nil) {
                
                self.getGroupsModelClass = [[GetGroupsModelClass alloc] init];
                self.getGroupsModelClass.delegate = self;
            }
            
            [self.getGroupsModelClass joinUnJoinGroupRequest:groupId url:UnJoin_URL];
        }
        else {
            
            [self showAlertViewWithTitle:NSLocalizedString(@"NO_INTERNET_ALERT_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET_ALERT_MESSAGE", nil)];
            
            return;
        }
    }
    else {
        
        if ([NetworkError checkNetwork]) {
            
            [self showLoaderWithTitle:@"Joining Group..."];
            
            if (self.getGroupsModelClass == nil) {
                
                self.getGroupsModelClass = [[GetGroupsModelClass alloc] init];
                self.getGroupsModelClass.delegate = self;
            }
            
            [self.getGroupsModelClass joinUnJoinGroupRequest:groupId url:Join_URL];
        }
        else {
            
            [self showAlertViewWithTitle:NSLocalizedString(@"NO_INTERNET_ALERT_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET_ALERT_MESSAGE", nil)];
            
            return;
        }
    }
}

-(IBAction)menuDotsBtnTapped:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"New Group", @"Settings", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    if (actionSheet.tag == 0) {
        
        switch (buttonIndex) {
            case 0: {
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CreateGroupStoryboard" bundle:nil];
                CreateGroupViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"CreateGroup"];
                [self.navigationController pushViewController:viewController animated:YES];
            }
                break;
            case 1: {
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SettingsStoryboard" bundle:nil];
                SettingsViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"Settings"];
                [self.navigationController pushViewController:viewController animated:YES];
            }
                break;
            default:
                
                break;
        }
    }
    else {
        
        switch (buttonIndex) {
            case 0:
                
                break;
            case 1:
                
                break;
                
            default:
                break;
        }
    }
}

#pragma mark -
#pragma mark Groups Model Classes Delegate

-(void)didGetGroupsSuccessfully:(NSMutableArray *)groupArray {
    
    [self removeLoader];
}

-(void)didGetGroupsFailed:(ASIHTTPRequest *)therequest {
    
    [self removeLoader];
}

-(void)didJoinUnJoinGroupSuccessfully {
    
    if ([leaveGroupBtn.titleLabel.text isEqualToString:@"Leave Group"]) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"isGroupJoined"];
        
        [leaveGroupBtn setTitle:@"Join Group" forState:UIControlStateNormal];
    }
    else {
        
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"isGroupJoined"];

        [leaveGroupBtn setTitle:@"Leave Group" forState:UIControlStateNormal];
    }
    
    [self removeLoader];
}

-(void)didJoinUnJoinGroupFailed:(ASIHTTPRequest *)therequest {
    
    [self removeLoader];
}

-(void)didGroupDeletedSuccessfully {
    
    [self removeLoader];
}

-(void)didGroupDeletedFailed:(ASIHTTPRequest *)therequest {
    
    [self removeLoader];
}

#pragma mark - tablview datasource required methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return recepientsArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    NSMutableDictionary *dict = [recepientsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    cell.textLabel.text = [dict objectForKey:@"name"];
    
    return cell;
}

#pragma mark - tablview delegate  methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selectedIndexPath = indexPath.row;
    
    NSDictionary *loggedInInfoDict = [Common retriveLoggedInUserInfo];
    
    NSMutableDictionary *dict = [recepientsArray objectAtIndex:indexPath.row];
    
    if ([[loggedInInfoDict objectForKey:@"id"] intValue] == [[dict objectForKey:@"id"] intValue]) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserProfileStoryboard" bundle:nil];
        UserProfileViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"UserProfile"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
 
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ProfileStoryboard" bundle:nil];
        ProfileViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"Profile"];
        viewController.userDict = dict;
        [self.navigationController pushViewController:viewController animated:YES];
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
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"Profile"])
    {
        // Get reference to the destination view controller
        ProfileViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.recepientlbl.text = [recepientsArray objectAtIndex:selectedIndexPath];
    }
}
*/

@end
