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

#import "ImageMsg.h"

#import "GetGroupsModelClass.h"

@interface ChatViewController : BaseViewController <HPGrowingTextViewDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TextMsgModelClassDelegate, ThreadDetailsModelClassDelegate, ImageMsgModelClassDelegate, GetGroupsModelClassDelegate>
{
    UIView *containerView;
    NSMutableArray *filterArray;
    NSMutableArray *chatsArray;

    IBOutlet UIView *popUpView;
    IBOutlet UIImageView *bgImg;
    IBOutlet UIView *innerPopUpView;
    
    IBOutlet UIButton *joinBtn;

    HPGrowingTextView *textView;
    
    int selectedRow;
    BOOL newMedia;
}

@property (nonatomic, readwrite, assign) NSUInteger reloads;
@property (weak, nonatomic) IBOutlet UIImageView *Uploadedimage;
@property (weak, nonatomic) IBOutlet UITableView *sphChatTable;
@property (nonatomic) BOOL isCameFromWall;
@property (nonatomic) BOOL isGroup;
@property (nonatomic) int isGroupJoined;
@property (nonatomic, strong) NSMutableDictionary *dataDict;
@property (nonatomic, strong) ThreadDetails *threadDetailsModelClass;
@property (nonatomic, strong) TextMsg *textMsgModelClass;
@property (nonatomic, strong) ImageMsg *imgMsgModelClass;
@property (nonatomic, strong) GetGroupsModelClass *getGroupsModelClass;

- (IBAction)joinBtnTapped:(id)sender;

@end
