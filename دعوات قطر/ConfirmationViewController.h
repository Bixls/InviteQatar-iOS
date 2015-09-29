//
//  ConfirmationViewController.h
//  دعوات قطر
//
//  Created by Adham Gad on 28,6//15.
//  Copyright (c) 2015 Bixls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customAlertView.h"
#import "HeaderContainerViewController.h"
@interface ConfirmationViewController : UIViewController <UITextFieldDelegate,customAlertViewDelegate,headerContainerDelegate>


@property (nonatomic) NSInteger userID;

@property (weak, nonatomic) IBOutlet UITextField *confirmField;

- (IBAction)btnConfirmPressed:(id)sender;

@end
