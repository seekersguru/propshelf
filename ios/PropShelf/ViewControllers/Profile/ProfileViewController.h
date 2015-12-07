//
//  ProfileViewController.h
//  PropShelf
//
//  Created by Gaurang Patel on 10/14/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GetUserDetails.h"

#import "GetGroupsModelClass.h"

@interface ProfileViewController : BaseViewController <GetUserDetailsModelClassDelegate, GetGroupsModelClassDelegate> {
    
    IBOutlet UIView *view1;
    IBOutlet UIView *view2;
    IBOutlet UIView *view3;
    IBOutlet UILabel *recepientlbl;
    IBOutlet UILabel *titlelbl1;
    IBOutlet UILabel *titlelbl2;
    IBOutlet UILabel *mobileNumber;

    int selectedIndexPath;

    NSMutableArray *groupsArray;
    NSMutableArray *recentPostArray;
    
    NSString *threadId;
}

@property (nonatomic, weak) IBOutlet UITableView* groupTableView;
@property (nonatomic, weak) IBOutlet UITableView* postTableView;
@property (nonatomic, strong) GetUserDetails *getUserDetails;
@property (nonatomic, strong) NSMutableDictionary *userDict;
@property (nonatomic,strong) GetGroupsModelClass *getGroupsModelClass;

-(IBAction)backBtnTapped:(id)sender;
-(IBAction)callBtnTapped:(id)sender;
-(IBAction)msgBtnTapped:(id)sender;
-(IBAction)chatBtnTapped:(id)sender;

@end
