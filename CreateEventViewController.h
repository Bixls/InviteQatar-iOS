//
//  CreateEventViewController.h
//  دعوات قطر
//
//  Created by Adham Gad on 1,7//15.
//  Copyright (c) 2015 Bixls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateEventViewController : UIViewController <UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imagePicker;

@property (weak, nonatomic) IBOutlet UIButton *btnChoosePic;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *btnMarkComments;

@property (weak, nonatomic) IBOutlet UIButton *btnMarkVIP;

- (IBAction)btnChoosePicPressed:(id)sender;

- (IBAction)btnChooseInvitation:(id)sender;

- (IBAction)btnSubmitPressed:(id)sender;


- (IBAction)btnMarkCommentsPressed:(id)sender;

- (IBAction)btnMarkVipPressed:(id)sender;


@end