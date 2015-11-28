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

@interface ProfileViewController () <MFMessageComposeViewControllerDelegate>

@end

@implementation ProfileViewController

@synthesize recepientStr;

@synthesize recepientIdStr;

@synthesize propertyStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    recentPostArray = [NSMutableArray arrayWithObjects:@"Lorem ipsum dolor sit er elit lamet.", @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", @"Lorem ipsum dolor sit er elit lamet.", @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", @"Quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", nil];

    NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Group - 1", @"groupName", @"1", @"status", nil];
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Group - 2", @"groupName", @"1", @"status", nil];
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Group - 3", @"groupName", @"0", @"status", nil];
    NSMutableDictionary *dict4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Group - 4", @"groupName", @"1", @"status", nil];
    NSMutableDictionary *dict5 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Group - 5", @"groupName", @"0", @"status", nil];
    NSMutableDictionary *dict6 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Group - 6", @"groupName", @"0", @"status", nil];
    NSMutableDictionary *dict7 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Group - 7", @"groupName", @"1", @"status", nil];
    NSMutableDictionary *dict8 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Group - 8", @"groupName", @"0", @"status", nil];
    
    groupsArray = [NSMutableArray arrayWithObjects:dict1, dict2, dict3, dict4, dict5, dict6, dict7, dict8, nil];

    recepientlbl.text = recepientStr;
    
    titlelbl1.text = [NSString stringWithFormat:@"Groups %@ is part of", recepientStr];
    
    titlelbl2.text = [NSString stringWithFormat:@"Recent posts by %@", recepientStr];

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
    
    mobileNumber.text = [NSString stringWithFormat:@"%@ %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"CountryCode"], [[NSUserDefaults standardUserDefaults] objectForKey:@"mobileNumber"]];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Button Action Method

-(IBAction)backBtnTapped:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)chatBtnTapped:(id)sender {
    
    [APP_DELEGATE addChatScreen:self.threadIdStr titleStr:self.propertyStr];
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

        groupCell.titlelbl.text = [dict objectForKey:@"groupName"];

        if ([[dict objectForKey:@"status"] isEqualToString:@"0"]) {
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
        
    NSMutableDictionary *dict = [groupsArray objectAtIndex:indexPath.row];
    
    if ([[dict objectForKey:@"status"] isEqualToString:@"0"]) {
        NSLog(@"Not Joined");
        
        [dict setValue:@"1" forKey:@"status"];
    }
    else {
        NSLog(@"Already Joined");
        
        [dict setValue:@"0" forKey:@"status"];
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
    cell.titlelbl.text = [recentPostArray objectAtIndex:indexPath.row];
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
    
    return size.height + 1.0f; // Add 1.0f for the cell separator height
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
