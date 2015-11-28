//
//  ChatViewController.h
//  PropShelf
//
//  Created by Gaurang Patel on 10/14/15.
//  Copyright © 2015 Gaurang Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HPGrowingTextView.h"

#import "BaseViewController.h"

#import "TextMsg.h"

#import "ThreadDetails.h"

@interface ChatViewController : BaseViewController <HPGrowingTextViewDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TextMsgModelClassDelegate, ThreadDetailsModelClassDelegate>
{
    UIView *containerView;
    NSMutableArray *filterArray;
    NSMutableArray *chatsArray;

    IBOutlet UIView *popUpView;
    IBOutlet UIImageView *bgImg;
    IBOutlet UIView *innerPopUpView;

    HPGrowingTextView *textView;
    
    int selectedRow;
    BOOL newMedia;
    IBOutlet UISearchBar *SearchBar;
    
    BOOL searching;
}

@property (nonatomic, readwrite, assign) NSUInteger reloads;
@property (weak, nonatomic) IBOutlet UIImageView *Uploadedimage;
@property (weak, nonatomic) IBOutlet UITableView *sphChatTable;
@property (nonatomic, strong) IBOutlet NSString *propertyStr;
@property (nonatomic) BOOL isCameFromWall;
@property (nonatomic,strong) TextMsg *textMsgModelClass;
@property (nonatomic, strong) IBOutlet NSString *threadIdStr;
@property (nonatomic, strong) IBOutlet NSString *groupId;
@property (nonatomic, strong) IBOutlet NSString *recipientId;
@property (nonatomic, strong) IBOutlet NSString *recipientStr;
@property (nonatomic) BOOL isGroup;
@property (nonatomic,strong) ThreadDetails *threadDetailsModelClass;

@end
