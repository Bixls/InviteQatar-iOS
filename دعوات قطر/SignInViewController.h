//
//  SignInViewController.h
//  دعوات قطر
//
//  Created by Adham Gad on 28,6//15.
//  Copyright (c) 2015 Bixls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customAlertView.h"
#import "SignInViewController.h"
#import "HeaderContainerViewController.h"

@interface SignInViewController : UIViewController <UITextFieldDelegate,customAlertViewDelegate,headerContainerDelegate>

@property (nonatomic) NSInteger userID;


@property (weak, nonatomic) IBOutlet UITextField *mobileField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)btnSignInPressed:(id)sender;


@end
