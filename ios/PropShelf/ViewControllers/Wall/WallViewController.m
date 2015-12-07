//
//  WallViewController.m
//  PropShelf
//
//  Created by Gaurang Patel on 10/13/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import "WallViewController.h"

#import "ChatCustomCell.h"

#import "GroupCustomCell.h"

#import "GroupProfileViewController.h"

#import "ChatViewController.h"

@interface WallViewController () <UIActionSheetDelegate>

@end

@implementation WallViewController

@synthesize getGroupsModelClass;

@synthesize getWallModelClass;

@synthesize groupSearchModelClass;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"WALL_NAV_TITLE", nil);
    
    isChat = YES;
    searching = NO;

    selectedIndexPath = 1000000;
    
    self.tableView.tableHeaderView = SearchBar;
    
    [self getWallDetails];
    
    [self setNavigationBarItems];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;

    self.tableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);

    [self.tableView setContentOffset:CGPointMake(0, 44)];
    
    BOOL isNewCreated = [[NSUserDefaults standardUserDefaults] boolForKey:@"isNewCreated"];
    
    if (isNewCreated == YES) {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isNewCreated"];
        
        [self getGroupsDetails];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark setNavigationBarItems Methods

-(void)setNavigationBarItems {
    
    UIButton *whiteDotBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [whiteDotBtn setFrame:CGRectMake(0, 0, 4, 15)];
    [whiteDotBtn setBackgroundImage:[UIImage imageNamed:@"Menu-dots"] forState:UIControlStateNormal];
    [whiteDotBtn addTarget:self action:@selector(menuDotsBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    whiteDotBtn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *dotBtn = [[UIBarButtonItem alloc] initWithCustomView:whiteDotBtn];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 15.0f;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: dotBtn, fixedSpace, nil];
    
    UIView *navTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    navTitleView.backgroundColor = [UIColor clearColor];
    
    CGFloat lblXAxis = 0;
    
    lblXAxis = navTitleView.frame.origin.x + 40.0;
    
    // Customize the title text for *all* UINavigationBars
    UILabel *navTitle = [[UILabel alloc] init];
    navTitle.frame = CGRectMake(lblXAxis, 2, 240, 44);
    navTitle.text = NSLocalizedString(@"WALL_NAV_TITLE", nil);
    navTitle.textColor = [UIColor whiteColor];
    navTitle.backgroundColor = [UIColor clearColor];
    navTitle.textAlignment = NSTextAlignmentCenter;
    [navTitleView addSubview:navTitle];
    
    self.navigationItem.titleView = navTitleView;
    
    [self.navigationController.navigationBar setNeedsLayout];
}

#pragma mark - getWallDetails Method

-(void)getWallDetails {
    
    if ([NetworkError checkNetwork]) {
        
        [self showLoaderWithTitle:@"Loading Chats..."];
        
        if (self.getWallModelClass == nil) {
            
            self.getWallModelClass = [[Wall alloc] init];
            self.getWallModelClass.delegate = self;
        }
        
        [self.getWallModelClass getWallRequest:1];
    }
    else {
        
        [self showAlertViewWithTitle:NSLocalizedString(@"NO_INTERNET_ALERT_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET_ALERT_MESSAGE", nil)];
        
        return;
    }
}

#pragma mark - getGroupsDetails Method

-(void)getGroupsDetails {
    
    if ([NetworkError checkNetwork]) {
        
        [self showLoaderWithTitle:@"Loading Groups..."];
        
        if (self.getGroupsModelClass == nil) {
            
            self.getGroupsModelClass = [[GetGroupsModelClass alloc] init];
            self.getGroupsModelClass.delegate = self;
        }
        
        [self.getGroupsModelClass getGroupsRequest:1];
    }
    else {
        
        [self showAlertViewWithTitle:NSLocalizedString(@"NO_INTERNET_ALERT_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET_ALERT_MESSAGE", nil)];
        
        return;
    }
}

#pragma mark - Button Action Method

- (IBAction)segmentedControlDidChange:(UISegmentedControl *)sender {
    
    searching = NO;

    if (sender.selectedSegmentIndex == 0) {
        
        isChat = YES;
        
        [self getWallDetails];
    }
    else {
        
        isChat = NO;
        
        [self getGroupsDetails];
    }
    
    [self.tableView reloadData];
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

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(searching) {
        
        return filterArray.count;
    }

    if (isChat == YES) {
        
        return chatArray.count;
    }
    else {
        
        return groupsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier1;
    cellIdentifier1 = @"ChatCustomCell";
    
    ChatCustomCell *chatCell = (ChatCustomCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    
    if (chatCell == nil) {
        //load from Nib
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"ChatCustomCell" owner:self options:nil];
        
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[ChatCustomCell class]])
                chatCell = (ChatCustomCell *)oneObject;
        
        chatCell.selectionStyle = UITableViewCellSelectionStyleNone;
        chatCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.tableView.backgroundColor = [UIColor clearColor];
    }
    
    NSString *cellIdentifier2;
    cellIdentifier2 = @"GroupCustomCell";
    
    GroupCustomCell *groupCell = (GroupCustomCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
    
    if (groupCell == nil) {
        //load from Nib
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"GroupCustomCell" owner:self options:nil];
        
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[GroupCustomCell class]])
                groupCell = (GroupCustomCell *)oneObject;
        
        groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
        groupCell.accessoryType = UITableViewCellAccessoryNone;
        
        self.tableView.backgroundColor = [UIColor clearColor];
    }

    chatCell.imgIcon.layer.cornerRadius = 20.0;
    chatCell.imgIcon.layer.masksToBounds = YES;
    
    groupCell.imgIcon.layer.cornerRadius = 20.0;
    groupCell.imgIcon.layer.masksToBounds = YES;

    if (isChat == YES) {
        
        NSMutableDictionary *dict = [chatArray objectAtIndex:indexPath.row];
        
        NSMutableArray *recipientArray = [[dict objectForKey:@"reciepents"] mutableCopy];

        NSMutableDictionary *recipientDict = [recipientArray objectAtIndex:0];
        
        if([[dict objectForKey:@"isGroup"] boolValue] == YES) {
            
            chatCell.imgIcon.image = [UIImage imageNamed:@"Group-icon"];
            
            chatCell.titlelbl.text = [recipientDict objectForKey:@"name"];
        }
        else {

            chatCell.imgIcon.image = [UIImage imageNamed:@"profile-1"];
            
            //chatCell.titlelbl.text = [dict objectForKey:@"text"];
            
            NSString *txtStr = [NSString stringWithFormat:@"%@  %@", [recipientDict objectForKey:@"firstName"], [dict objectForKey:@"text"]];
            
            UIFont *font = [UIFont systemFontOfSize:12.0f];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.paragraphSpacing = 0.25 * font.lineHeight;
            NSDictionary *attributes = @{NSFontAttributeName:font,
                                         
                                         NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                         
                                         NSBackgroundColorAttributeName:[UIColor clearColor],
                                         
                                         NSParagraphStyleAttributeName:paragraphStyle,
                                         };
            
            NSMutableAttributedString *tmpAttrTxt = [[NSMutableAttributedString alloc] initWithString:txtStr];
            
            [tmpAttrTxt addAttributes:attributes range:NSMakeRange([[recipientDict objectForKey:@"firstName"] length], [[dict objectForKey:@"text"] length] + 2)];

            chatCell.titlelbl.attributedText = tmpAttrTxt;
            
            paragraphStyle = nil;
            tmpAttrTxt = nil;
        }

        dict = nil;
        recipientDict = nil;
        recipientArray = nil;
        
        return chatCell;
    }
    else {

        NSMutableArray *msgFilterArray = nil;
        
        if(searching)
            msgFilterArray = filterArray;
        
        else {
            msgFilterArray = groupsArray;
        }

        NSMutableDictionary *dict = [[msgFilterArray objectAtIndex:indexPath.row] mutableCopy];

        CGFloat borderWidth = 1.0f;
        
        groupCell.joinBtn.layer.borderColor = [UIColor colorWithRed:245.0/255.0 green:65.0/255.0 blue:62.0/255.0 alpha:1.0].CGColor;
        groupCell.joinBtn.layer.borderWidth = borderWidth;
        groupCell.joinBtn.backgroundColor = [UIColor whiteColor];
        groupCell.joinBtn.layer.cornerRadius = 1.5;
        groupCell.joinBtn.layer.masksToBounds = YES;
        [groupCell.joinBtn addTarget:self action:@selector(joinBtnTapped:event:) forControlEvents:UIControlEventTouchUpInside];
        
        groupCell.titlelbl.text = [dict objectForKey:@"name"];

        groupCell.imgIcon.image = [UIImage imageNamed:@"Group-icon"];

        if ([[dict objectForKey:@"joined"] intValue] == 0) {
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
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ChatStoryboard" bundle:nil];
    ChatViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"Chat"];
    viewController.isCameFromWall = YES;
    
    if (isChat == YES) {
        
        NSMutableDictionary *dict = [chatArray objectAtIndex:indexPath.row];

        if ([[dict objectForKey:@"isGroup"] boolValue] == YES) {
            
            NSMutableArray *recipientArray = [[dict objectForKey:@"reciepents"] mutableCopy];
            
            NSMutableDictionary *recipientDict = [recipientArray objectAtIndex:0];

            NSMutableDictionary *groupDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"description"], @"description", [recipientDict objectForKey:@"name"], @"name", [recipientDict objectForKey:@"id"], @"id", @"1", @"joined", nil];
            
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"isGroupJoined"];
            viewController.dataDict = groupDict;
        }
        else {
            
            viewController.dataDict = dict;
        }
        
        viewController.isGroup = [[dict objectForKey:@"isGroup"] boolValue];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        
        NSMutableArray *msgFilterArray = nil;
        
        if(searching)
            msgFilterArray = filterArray;
        
        else {
            msgFilterArray = groupsArray;
        }

        NSMutableDictionary *dict = [[msgFilterArray objectAtIndex:indexPath.row] mutableCopy];
        
        [[NSUserDefaults standardUserDefaults] setInteger:[[dict objectForKey:@"joined"] intValue] forKey:@"isGroupJoined"];
        viewController.isGroup = YES;
        viewController.dataDict = dict;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (isChat == YES) {

        return NO;
    }
    else {
       
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        //remove the deleted object from your data source.
        //If you're data source is an NSMutableArray, do this
        
        selectedIndexPath = indexPath.row;

        if ([NetworkError checkNetwork]) {
            
            NSMutableArray *msgFilterArray = nil;
            
            if(searching)
                msgFilterArray = filterArray;
            
            else {
                msgFilterArray = groupsArray;
            }

            NSMutableDictionary *dict = [msgFilterArray objectAtIndex:indexPath.row];

            [self showLoaderWithTitle:@"Deleting Group..."];
            
            if (self.getGroupsModelClass == nil) {
                
                self.getGroupsModelClass = [[GetGroupsModelClass alloc] init];
                self.getGroupsModelClass.delegate = self;
            }
            
            [self.getGroupsModelClass deleteGroupRequest:[[dict objectForKey:@"id"] intValue]];
        }
        else {
            
            [self showAlertViewWithTitle:NSLocalizedString(@"NO_INTERNET_ALERT_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET_ALERT_MESSAGE", nil)];
            
            return;
        }
    }
}

-(void) joinBtnTapped:(id) sender event:(id)event {
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    //NSLog(@"Selected  row:%d in section:%d",indexPath.row,indexPath.section);
    
    selectedIndexPath = indexPath.row;
    
    NSMutableArray *msgFilterArray = nil;
    
    if(searching)
        msgFilterArray = filterArray;
    
    else {
        msgFilterArray = groupsArray;
    }

    NSMutableDictionary *dict = [[msgFilterArray objectAtIndex:indexPath.row] mutableCopy];

    if ([[dict objectForKey:@"joined"] intValue] == 0) {
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
}

#pragma mark -
#pragma mark Search Bar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    SearchBar.showsCancelButton = YES;
    
    return YES;
}

/*
- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
    //Remove all objects first.
    if ([filterArray count] > 0) {
        [filterArray removeAllObjects];
        filterArray = nil;
    }
    
    filterArray = [[NSMutableArray alloc] init];
    
    if([searchText length] > 0) {
        
        segmentedControl.selectedSegmentIndex = 1;
        
        isChat = NO;
        searching = YES;
        
        [self searchTableView];
    }
    else {
        searching = NO;
        
        [self.tableView reloadData];
    }
}
*/

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [SearchBar resignFirstResponder];
    
    //Remove all objects first.
    if ([filterArray count] > 0) {
        [filterArray removeAllObjects];
        filterArray = nil;
    }
    
    filterArray = [[NSMutableArray alloc] init];
    
    if([searchBar.text length] > 0) {
        
        segmentedControl.selectedSegmentIndex = 1;
        
        isChat = NO;
        searching = YES;
        
        [self searchTableView];
    }
    else {
        searching = NO;
        
        [self.tableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    
    isChat = YES;
    
    segmentedControl.selectedSegmentIndex = 0;
    
    searching = NO;
    
    SearchBar.showsCancelButton = NO;
    
    // Make the keyboard go away.
    [SearchBar resignFirstResponder];
    
    //Remove all objects first.
    if ([filterArray count] > 0) {
        [filterArray removeAllObjects];
        filterArray = nil;
    }
    
    SearchBar.text = @"";
    
    [self.tableView reloadData];
}

- (void) searchTableView {
    
    NSString *searchText = SearchBar.text;
    
    if ([NetworkError checkNetwork]) {
        
        [self showLoaderWithTitle:@"Searching..."];
        
        if (self.groupSearchModelClass == nil) {
            
            self.groupSearchModelClass = [[GroupSearch alloc] init];
            self.groupSearchModelClass.delegate = self;
        }
        
        NSMutableDictionary *dictPayload = [NSMutableDictionary dictionaryWithObjectsAndKeys:searchText, @"search_string", @"1", @"page_no", nil];

        [self.groupSearchModelClass searchGroupRequest:dictPayload];
    }
    else {
        
        [self showAlertViewWithTitle:NSLocalizedString(@"NO_INTERNET_ALERT_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET_ALERT_MESSAGE", nil)];
        
        return;
    }
}

#pragma mark -
#pragma mark SearchGroup Model Classes Delegate

-(void)didSearchGroupSuccessfully:(NSMutableArray *)responseArray {
 
    filterArray = [responseArray mutableCopy];
    
    [self.tableView reloadData];
    
    [self removeLoader];
}

-(void)didSearchGroupFailed:(ASIHTTPRequest *)therequest {
    
}

#pragma mark -
#pragma mark Wall Model Classes Delegate

-(void)didGetWallSuccessfully:(NSMutableArray *)wallArray {
    
    chatArray = [wallArray mutableCopy];
    
    [self.tableView reloadData];
    
    [self removeLoader];
}

-(void)didGetWallFailed:(ASIHTTPRequest *)therequest {
    
    [self removeLoader];
}

#pragma mark -
#pragma mark Groups Model Classes Delegate

-(void)didGetGroupsSuccessfully:(NSMutableArray *)groupArray {
    
    groupsArray = [groupArray mutableCopy];
    
    [self.tableView reloadData];
    
    [self removeLoader];
}

-(void)didGetGroupsFailed:(ASIHTTPRequest *)therequest {
    
    [self removeLoader];
}

-(void)didJoinUnJoinGroupSuccessfully {
    
    NSMutableArray *msgFilterArray = nil;
    
    if(searching)
        msgFilterArray = filterArray;
    
    else {
        msgFilterArray = groupsArray;
    }

    NSMutableDictionary *dict = [[msgFilterArray objectAtIndex:selectedIndexPath] mutableCopy];

    if ([[dict objectForKey:@"joined"] intValue] == 0) {
        
        [dict setValue:[NSNumber numberWithInt:1] forKey:@"joined"];
    }
    else {
        
        [dict setValue:[NSNumber numberWithInt:0] forKey:@"joined"];
    }
    
    [groupsArray replaceObjectAtIndex:selectedIndexPath withObject:dict];
    
    [self.tableView reloadData];
    
    [self removeLoader];
}

-(void)didJoinUnJoinGroupFailed:(ASIHTTPRequest *)therequest {
    
    [self removeLoader];
}

-(void)didGroupDeletedSuccessfully {
    
    [groupsArray removeObjectAtIndex:selectedIndexPath];
    
    [self.tableView reloadData];
    
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
    // Make sure your segue name in storyboard is the same as this line
    
    if (isChat == YES) {
        
    }
    else {
        
        if ([[segue identifier] isEqualToString:@"GroupProfile"])
        {
            // Get reference to the destination view controller
            GroupProfileViewController *vc = [segue destinationViewController];
            
            // Pass any objects to the view controller here, like...
            vc.propertylbl.text = [groupsArray objectAtIndex:selectedIndexPath];
        }
    }
}
*/

@end
