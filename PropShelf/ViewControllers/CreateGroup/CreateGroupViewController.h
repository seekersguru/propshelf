//
//  CreateGroupViewController.h
//  PropShelf
//
//  Created by Gaurang Patel on 10/26/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CreateGroupModelClass.h"

#import "LocationModelClass.h"

@interface CreateGroupViewController : BaseViewController <CreateGroupModelClassDelegate, LocationModelClassDelegate> {
    
    IBOutlet UITextField *txtGroupName;
    IBOutlet UITextField *txtCity;
    IBOutlet UITextField *txtLocation;
    IBOutlet UITextField *descriptionPlaceHolder;
    IBOutlet UITextView *description;
    IBOutlet UIButton *createGroupBtn;
    
    BOOL isCity, isLocation;
}

@property (nonatomic,strong) CreateGroupModelClass *createGroupModelClass;
@property (nonatomic,strong) LocationModelClass *locationModelClass;

-(IBAction)createGroupBtnTapped:(id)sender;

@end
