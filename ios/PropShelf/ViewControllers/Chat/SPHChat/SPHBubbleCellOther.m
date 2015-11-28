//
//  SPHBubbleCellOther.m
//  ChatBubble
//
//  Created by ivmac on 10/2/13.
//  Copyright (c) 2013 Conciergist. All rights reserved.
//

#import "SPHBubbleCellOther.h"

#import "Constant.h"

#define messageWidth 250


@implementation SPHBubbleCellOther

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        
    }
    return self;
}

-(void)SetCellData:(SPHChatData *)feed_data targetedView:(id)ViewControllerObject Atrow:(NSInteger)indexRow;
{
    NSString *messageText = feed_data.messageText;
    CGSize boundingSize = CGSizeMake(messageWidth - 20, 10000000);
    CGRect itemTextSize = [messageText boundingRectWithSize:boundingSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:12.0]}
                                             context:nil];
    float textHeight = itemTextSize.size.height+7;
    
    UIImageView *bubbleImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"Bubbletyperight"] stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
    bubbleImage.tag = 55;
    [self.contentView addSubview:bubbleImage];
    [bubbleImage setFrame:CGRectMake(self.frame.size.width - itemTextSize.size.width - 26, 5, itemTextSize.size.width+27, textHeight+8)];
    bubbleImage.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleBottomMargin;

    UILabel *messagelbl=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - itemTextSize.size.width - 17, 5, itemTextSize.size.width+8, textHeight+2)];
    [self.contentView addSubview:messagelbl];
    messagelbl.text = messageText;
    messagelbl.numberOfLines = 0;
    messagelbl.textAlignment = NSTextAlignmentJustified;
    messagelbl.font = [UIFont fontWithName:@"Helvetica Neue" size:12.0];
    messagelbl.backgroundColor = [UIColor clearColor];
    messagelbl.tag = indexRow;
    messagelbl.backgroundColor = [UIColor clearColor];
    messagelbl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleBottomMargin;

    messagelbl = nil;
    bubbleImage = nil;
    
    /*self.Avatar_Image.image=[UIImage imageNamed:@"Customer_icon"];
    
    self.time_Label.text=feed_data.messageTime;
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if ([feed_data.messagestatus isEqualToString:kStatusSent]) {
        
        self.statusindicator.alpha=0.0;
        [self.statusindicator stopAnimating];
        self.statusImage.alpha=1.0;
        [self.statusImage setImage:[UIImage imageNamed:@"success"]];
        
    }else  if ([feed_data.messagestatus isEqualToString:kStatusSeding])
    {
        self.statusImage.alpha=0.0;
        self.statusindicator.alpha=1.0;
        [self.statusindicator startAnimating];
        
    }
    else
    {
        self.statusindicator.alpha=0.0;
        [self.statusindicator stopAnimating];
        self.statusImage.alpha=1.0;
        [self.statusImage setImage:[UIImage imageNamed:kStatusFailed]];
        
    }
    
    self.Avatar_Image.layer.cornerRadius = 20.0;
    self.Avatar_Image.layer.masksToBounds = YES;
    self.Avatar_Image.layer.borderColor = [UIColor whiteColor].CGColor;
    self.Avatar_Image.layer.borderWidth = 2.0;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:ViewControllerObject action:@selector(tapRecognized:)];
    [messagelbl addGestureRecognizer:singleFingerTap];
    singleFingerTap.delegate = ViewControllerObject;*/
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
