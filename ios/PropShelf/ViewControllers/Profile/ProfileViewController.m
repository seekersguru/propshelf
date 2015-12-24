//
//  ProfileViewController.m
//  PropShelf
//
//  Created by Gaurang Patel on 10/14/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import "ProfileViewController.h"

#import "ProfileGroupCustomCell.h"

#import "RecentPostCustomCell.h"

#import "ChatViewController.h"

#import <MessageUI/MessageUI.h>

@interface ProfileViewController () <MFMessageComposeViewControllerDelegate, UIActionSheetDelegate>

@end

@implementation ProfileViewController

@synthesize getUserDetails;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    selectedIndexPath = 100000;

    if ([self.userDict objectForKey:@"mobile"] != nil) {
        
        mobileNumber.text = [NSString stringWithFormat:@"+91 %@", [self.userDict objectForKey:@"mobile"]];
    }

    recepientlbl.text = [self.userDict objectForKey:@"firstName"];
    titlelbl1.text = [NSString stringWithFormat:@"Groups %@ is part of", [self.userDict objectForKey:@"firstName"]];
    titlelbl2.text = [NSString stringWithFormat:@"Recent posts by %@", [self.userDict objectForKey:@"firstName"]];

    if ([NetworkError checkNetwork]) {
        
        [self showLoaderWithTitle:@"Loading Data..."];
        
        if (self.getUserDetails == nil) {
            
            self.getUserDetails = [[GetUserDetails alloc] init];
            self.getUserDetails.delegate = self;
        }
        
        [self.getUserDetails getUserDetailsRequest:[self.userDict objectForKey:@"id"]];
    }
    else {
        
        [self showAlertViewWithTitle:NSLocalizedString(@"NO_INTERNET_ALERT_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET_ALERT_MESSAGE", nil)];
        
        return;
    }

    CGFloat borderWidth = 1.0f;
    
    view1.layer.borderColor = [UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:207.0/255.0 alpha:1.0].CGColor;
    view1.layer.borderWidth = borderWidth;
    view1.backgroundColor = [UIColor whiteColor];
    view1.layer.cornerRadius = 4.0f;
    view1.layer.masksToBounds = YES;
    
    view2.layer.borderColor = [UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:207.0/255.0 alpha:1.0].CGColor;
    view2.layer.borderWidth = borderWidth;
    view2.backgroundColor = [UIColor whiteColor];
    view2.layer.cornerRadius = 4.0f;
    view2.layer.masksToBounds = YES;
    
    view3.layer.borderColor = [UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:207.0/255.0 alpha:1.0].CGColor;
    view3.layer.borderWidth = borderWidth;
    view3.backgroundColor = [UIColor whiteColor];
    view3.layer.cornerRadius = 4.0f;
    view3.layer.masksToBounds = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Get User Details Model Class Delegate Method

-(void)didGetUserDetailsSuccessfully:(NSMutableDictionary *)userDict {
    
    recentPostArray = [[userDict objectForKey:@"recent_non_media_posts"] mutableCopy];
    
    groupsArray = [[userDict objectForKey:@"groups"] mutableCopy];

    mobileNumber.text = [NSString stringWithFormat:@"+91 %@", [userDict objectForKey:@"mobile"]];
    
    threadId = [userDict objectForKey:@"for_chat_thread_id_for_1_to_1_chat"];
    
    [self.groupTableView reloadData];
    
    [self.postTableView reloadData];
    
    [self removeLoader];
}

-(void)didGetUserDetailsFailed:(ASIHTTPRequest *)therequest {
    
    [self removeLoader];
}

#pragma mark - Button Action Method

-(IBAction)backBtnTapped:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)chatBtnTapped:(id)sender {
    
    NSMutableDictionary *dict = [self.userDict mutableCopy];
        
    [dict setObject:threadId forKey:@"threadId"];
    
    [APP_DELEGATE addChatScreen:dict];
}

-(IBAction)msgBtnTapped:(id)sender {
    
    [self showMessageComposeView];
}

-(IBAction)callBtnTapped:(id)sender {
    
    NSString *number = [NSString stringWithFormat:@"%@", mobileNumber.text];
    number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSURL* callUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",number]];
    
    //check  Call Function available only in iphone
    if([[UIApplication sharedApplication] canOpenURL:callUrl])
    {
        [[UIApplication sharedApplication] openURL:callUrl];
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

#pragma mark - tablview datasource required methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.groupTableView) {
      
        return groupsArray.count;
    }
    else {
     
        return recentPostArray.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.groupTableView) {
        
        NSString *cellIdentifier;
        cellIdentifier = @"ProfileGroupCustomCell";
        
        ProfileGroupCustomCell *groupCell = (ProfileGroupCustomCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (groupCell == nil) {
            //load from Nib
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileGroupCustomCell" owner:self options:nil];
            
            for (id oneObject in nib)
                if ([oneObject isKindOfClass:[ProfileGroupCustomCell class]])
                    groupCell = (ProfileGroupCustomCell *)oneObject;
            
            groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
            groupCell.accessoryType = UITableViewCellAccessoryNone;
            
            self.groupTableView.backgroundColor = [UIColor clearColor];
        }

        CGFloat borderWidth = 1.0f;
        
        groupCell.joinBtn.layer.borderColor = [UIColor colorWithRed:245.0/255.0 green:65.0/255.0 blue:62.0/255.0 alpha:1.0].CGColor;
        groupCell.joinBtn.layer.borderWidth = borderWidth;
        groupCell.joinBtn.backgroundColor = [UIColor whiteColor];
        groupCell.joinBtn.layer.cornerRadius = 1.5;
        groupCell.joinBtn.layer.masksToBounds = YES;
        [groupCell.joinBtn addTarget:self action:@selector(joinBtnTapped:event:) forControlEvents:UIControlEventTouchUpInside];

        NSMutableDictionary *dict = [groupsArray objectAtIndex:indexPath.row];

        groupCell.titlelbl.text = [dict objectForKey:@"name"];

        if ([[dict objectForKey:@"logged_in_user_joined_unjoined"] intValue] == 0) {
            //NSLog(@"Not Joined");
            
            [groupCell.joinBtn setTitleColor:[UIColor colorWithRed:245.0/255.0 green:65.0/255.0 blue:62.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [groupCell.joinBtn setTitle:@"Join" forState:UIControlStateNormal];
        }
        else {
            //NSLog(@"Already Joined");
            
            groupCell.joinBtn.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:65.0/255.0 blue:62.0/255.0 alpha:1.0];
            [groupCell.joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [groupCell.joinBtn setTitle:@"Joined" forState:UIControlStateNormal];
        }

        return groupCell;

    } else { //tableView == self.secondTableView
        
        
        return [self basicCellAtIndexPath:indexPath];
    }
}

-(void) joinBtnTapped:(id) sender event:(id)event {
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.groupTableView];
    NSIndexPath *indexPath = [self.groupTableView indexPathForRowAtPoint: currentTouchPosition];
    //NSLog(@"Selected  row:%d in section:%d",indexPath.row,indexPath.section);
    
    selectedIndexPath = indexPath.row;

    NSMutableDictionary *dict = [[groupsArray objectAtIndex:indexPath.row] mutableCopy];
    
    if ([[dict objectForKey:@"logged_in_user_joined_unjoined"] intValue] == 0) {
        NSLog(@"Not Joined");
        
        if ([NetworkError checkNetwork]) {
            
            [self showLoaderWithTitle:@"Joining Group..."];
            
            if (self.getGroupsModelClass == nil) {
                
                self.getGroupsModelClass = [[GetGroupsModelClass alloc] init];
                self.getGroupsModelClass.delegate = self;
            }
            
            [self.getGroupsModelClass joinUnJoinGroupRequest:[[dict objectForKey:@"id"] intValue] url:Join_URL];
        }
        else {
            
            [self showAlertViewWithTitle:NSLocalizedString(@"NO_INTERNET_ALERT_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET_ALERT_MESSAGE", nil)];
            
            return;
        }
    }
    else {
        NSLog(@"Already Joined");
        
        if ([NetworkError checkNetwork]) {
            
            [self showLoaderWithTitle:@"Leaving Group..."];
            
            if (self.getGroupsModelClass == nil) {
                
                self.getGroupsModelClass = [[GetGroupsModelClass alloc] init];
                self.getGroupsModelClass.delegate = self;
            }
            
            [self.getGroupsModelClass joinUnJoinGroupRequest:[[dict objectForKey:@"id"] intValue] url:UnJoin_URL];
        }
        else {
            
            [self showAlertViewWithTitle:NSLocalizedString(@"NO_INTERNET_ALERT_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET_ALERT_MESSAGE", nil)];
            
            return;
        }
    }
    
    [groupsArray replaceObjectAtIndex:indexPath.row withObject:dict];
    
    [self.groupTableView reloadData];
}

- (RecentPostCustomCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath {
    RecentPostCustomCell *cell = [self.postTableView dequeueReusableCellWithIdentifier:@"RecentPostCustomCell" forIndexPath:indexPath];
    [self configureBasicCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureBasicCell:(RecentPostCustomCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *dict = [recentPostArray objectAtIndex:indexPath.row];
    
    cell.titlelbl.text = [dict objectForKey:@"text"];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.groupTableView) {
        
        return 38.0f;
    }
    else {
        
        return [self heightForBasicCellAtIndexPath:indexPath];
    }
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static RecentPostCustomCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.postTableView dequeueReusableCellWithIdentifier:@"RecentPostCustomCell"];
    });
    
    [self configureBasicCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.postTableView.frame), CGRectGetHeight(sizingCell.bounds));
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    //NSLog(@"%f", size.height);
    
    return size.height + 1.0f - 5.0f; // Add 1.0f for the cell separator height
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.groupTableView) {
        
        return 120.0f;
    }
    else {
        
        return 155.0f;
    }
}

#pragma mark - tablview delegate  methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.groupTableView) {
        
    }
    else {
        
    }
}

- (void)showMessageComposeView {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[];
    NSString *message = @"Hi this test msg...";
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RELOAD_DATA object:nil];

    NSMutableDictionary *dict = [[groupsArray objectAtIndex:selectedIndexPath] mutableCopy];
    
    if ([[dict objectForKey:@"logged_in_user_joined_unjoined"] intValue] == 0) {
        
        [dict setValue:[NSNumber numberWithInt:1] forKey:@"logged_in_user_joined_unjoined"];
    }
    else {
        
        [dict setValue:[NSNumber numberWithInt:0] forKey:@"logged_in_user_joined_unjoined"];
    }
    
    [groupsArray replaceObjectAtIndex:selectedIndexPath withObject:dict];
    
    [self.groupTableView reloadData];
    
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
