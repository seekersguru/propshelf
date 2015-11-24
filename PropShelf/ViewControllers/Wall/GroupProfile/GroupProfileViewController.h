//
//  GroupProfileViewController.h
//  PropShelf
//
//  Created by Gaurang Patel on 10/14/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CreateGroupModelClass.h"

@interface GroupProfileViewController : BaseViewController <CreateGroupModelClassDelegate> {
    
    IBOutlet UIView *containerView;
    IBOutlet UIButton *leaveGroupBtn;
    IBOutlet UILabel *propertylbl;
    
    NSMutableArray *recepientsArray;
    
    int selectedIndexPath;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet NSString *propertyStr;
@property (nonatomic, strong) IBOutlet NSString *threadIdStr;
@property (nonatomic) int groupId;
@property (nonatomic,strong) CreateGroupModelClass *createGroupModelClass;

-(IBAction)backBtnTapped:(id)sender;

@end
