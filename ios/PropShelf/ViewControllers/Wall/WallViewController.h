//
//  WallViewController.h
//  PropShelf
//
//  Created by Gaurang Patel on 10/13/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GetGroupsModelClass.h"

#import "Wall.h"

@interface WallViewController : BaseViewController <GetGroupsModelClassDelegate, GetWallModelClassDelegate> {
    
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UISearchBar *SearchBar;
    
    NSMutableArray *filterArray;

    NSMutableArray *groupsArray;
    NSMutableArray *chatArray;

    int selectedIndexPath;

    BOOL isChat;
    BOOL searching;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) GetGroupsModelClass *getGroupsModelClass;
@property (nonatomic,strong) Wall *getWallModelClass;

- (IBAction)segmentedControlDidChange:(UISegmentedControl *)sender;

@end
