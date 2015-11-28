//
//  ProfileViewController.h
//  PropShelf
//
//  Created by Gaurang Patel on 10/14/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController {
    
    IBOutlet UIView *view1;
    IBOutlet UIView *view2;
    IBOutlet UIView *view3;
    IBOutlet UILabel *recepientlbl;
    IBOutlet UILabel *titlelbl1;
    IBOutlet UILabel *titlelbl2;
    IBOutlet UILabel *mobileNumber;

    NSMutableArray *groupsArray;
    NSMutableArray *recentPostArray;
}

@property (nonatomic, weak) IBOutlet UITableView* groupTableView;
@property (nonatomic, weak) IBOutlet UITableView* postTableView;
@property (nonatomic, strong) IBOutlet NSString *recepientStr;
@property (nonatomic, strong) IBOutlet NSString *recepientIdStr;
@property (nonatomic, strong) IBOutlet NSString *threadIdStr;
@property (nonatomic, strong) IBOutlet NSString *propertyStr;

-(IBAction)backBtnTapped:(id)sender;
-(IBAction)callBtnTapped:(id)sender;
-(IBAction)msgBtnTapped:(id)sender;
-(IBAction)chatBtnTapped:(id)sender;

@end
