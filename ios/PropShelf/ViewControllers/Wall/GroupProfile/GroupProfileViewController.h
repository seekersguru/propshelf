//
//  GroupProfileViewController.h
//  PropShelf
//
//  Created by Gaurang Patel on 10/14/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CreateGroupModelClass.h"

#import "GetGroupsModelClass.h"

@interface GroupProfileViewController : BaseViewController <CreateGroupModelClassDelegate, GetGroupsModelClassDelegate> {
    
    IBOutlet UIView *containerView;
    IBOutlet UIView *containerView1;
    IBOutlet UIButton *leaveGroupBtn;
    IBOutlet UILabel *propertylbl;
    IBOutlet UITextView *descriptionTxtView;

    NSMutableArray *recepientsArray;
    
    int selectedIndexPath;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet NSString *propertyStr;
@property (nonatomic, strong) IBOutlet NSString *threadIdStr;
@property (nonatomic, strong) IBOutlet NSString *descriptionStr;
@property (nonatomic) int groupId;
@property (nonatomic,strong) CreateGroupModelClass *createGroupModelClass;
@property (nonatomic,strong) GetGroupsModelClass *getGroupsModelClass;
@property (nonatomic) int isGroupJoined;

-(IBAction)backBtnTapped:(id)sender;
-(IBAction)unjoinBtnTapped:(id)sender;
-(IBAction)chatBtnTapped:(id)sender;

@end
