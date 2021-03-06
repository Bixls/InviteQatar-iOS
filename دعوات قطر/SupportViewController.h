//
//  SupportViewController.h
//  دعوات قطر
//
//  Created by Adham Gad on 11,7//15.
//  Copyright (c) 2015 Bixls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customAlertView.h"
#import "HeaderContainerViewController.h"
#import "FooterContainerViewController.h"

@interface SupportViewController : UIViewController <UITextViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,customAlertViewDelegate,headerContainerDelegate,FooterContainerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;


@property (weak, nonatomic) IBOutlet UITextView *msgField;

@property (weak, nonatomic) IBOutlet UIButton *btnChooseType;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

- (IBAction)btnChooseTypePressed:(id)sender;

- (IBAction)btnSendPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSendFeedback;

@end
