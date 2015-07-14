//
//  InviteViewController.h
//  دعوات قطر
//
//  Created by Adham Gad on 4,7//15.
//  Copyright (c) 2015 Bixls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic) NSInteger creatorID;
@property(nonatomic) NSInteger eventID;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnMarkAll;
- (IBAction)btnInvitePressed:(id)sender;
@end
