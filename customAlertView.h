//
//  customAlertView.h
//  دعوات قطر
//
//  Created by Adham Gad on 13,9//15.
//  Copyright (c) 2015 Bixls. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol customAlertViewDelegate <NSObject>

-(void)customAlertCancelBtnPressed;

@end


@interface customAlertView : UIView

@property (nonatomic) NSInteger tag;
@property (nonatomic,weak) id <customAlertViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

- (IBAction)viewCloseBtnPressed:(id)sender;
-(void)showAlertWithMsg:(NSString *)msg alertTag:(NSInteger )tag customAlertView:(UIView *)alertView customAlert:(customAlertView *)customAlert;

@end
