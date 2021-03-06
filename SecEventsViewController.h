//
//  SecEventsViewController.h
//  دعوات قطر
//
//  Created by Adham Gad on 5,7//15.
//  Copyright (c) 2015 Bixls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderContainerViewController.h"
#import "FooterContainerViewController.h"


@interface SecEventsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,headerContainerDelegate,FooterContainerDelegate>

@property (nonatomic) NSInteger groupID;
@property (nonatomic) NSInteger selectedSection;
@property (nonatomic,strong) NSString *sectionName;

@property (weak, nonatomic) IBOutlet UILabel *sectionNameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *eventsCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eventsCollectionViewHeight;

@end
