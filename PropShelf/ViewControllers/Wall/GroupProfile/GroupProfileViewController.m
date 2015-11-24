//
//  GroupProfileViewController.m
//  PropShelf
//
//  Created by Gaurang Patel on 10/14/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import "GroupProfileViewController.h"

#import "ProfileViewController.h"

@interface GroupProfileViewController ()

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
    
    propertylbl.text = propertyStr;
    
    [self getGroupUsers];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

#pragma mark - getGroupUsers Method

-(void)getGroupUsers {
    
    if ([NetworkError checkNetwork]) {
        
        [self showLoaderWithTitle:@"Getting User..."];
        
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

-(void)didCreateGroupSuccessfully {
    
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

-(IBAction)backBtnTapped:(id)sender {
    
    self.navigationController.navigationBarHidden = NO;

    [self.navigationController popViewControllerAnimated:YES];
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
    
    NSMutableDictionary *dict = [recepientsArray objectAtIndex:indexPath.row];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ProfileStoryboard" bundle:nil];
    ProfileViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"Profile"];
    viewController.recepientStr = [dict objectForKey:@"name"];
    viewController.recepientIdStr = [dict objectForKey:@"id"];
    viewController.threadIdStr = self.threadIdStr;
    viewController.propertyStr = propertyStr;
    [self.navigationController pushViewController:viewController animated:YES];
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
