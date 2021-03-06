//
//  HomePageViewController.h
//  دعوات قطر
//
//  Created by Adham Gad on 29,6//15.
//  Copyright (c) 2015 Bixls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UICollectionViewRightAlignedLayout.h>
#import "ASINetworkQueue.h"
#import "FooterContainerViewController.h"
#import "MiddleContainerViewController.h"

@interface HomePageViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegateRightAlignedLayout , MiddleContainerDelegate , FooterContainerDelegate,UIApplicationDelegate>

@property (weak, nonatomic) IBOutlet UIView *myView;

@property (weak, nonatomic) IBOutlet UICollectionView *groupsCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *VIPPointsNumber;

@property (weak, nonatomic) IBOutlet UILabel *lblVIPPoints;
@property (weak, nonatomic) IBOutlet UIButton *btnInvitationsBuySmall;
@property (weak, nonatomic) IBOutlet UIButton *btnInvitationsBuy;
@property (weak, nonatomic) IBOutlet UIButton *btnMyProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateNewInvitation;
@property (weak, nonatomic) IBOutlet UIButton *btnMyMessages;
@property (weak, nonatomic) IBOutlet UIButton *btnSupport;


@property (weak, nonatomic) IBOutlet UIButton *btnBuyInvitations;
@property (weak, nonatomic) IBOutlet UILabel *buyInv;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UICollectionView *newsCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *btnUnReadMsgs;
@property (weak, nonatomic) IBOutlet UICollectionView *eventCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *btnInvitationNum;
@property (weak, nonatomic) IBOutlet UILabel *noEventsLabel;
@property (weak, nonatomic) IBOutlet UIButton *showAllEventsBtn;
@property (weak, nonatomic) IBOutlet UILabel *showAllEventsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newsCollectionViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *noNewsLabel;

@property (weak, nonatomic) IBOutlet UILabel *myProfileLabel;

@property (weak, nonatomic) IBOutlet UILabel *lblLatestEvents;
- (IBAction)btnSeeMorePressed:(id)sender;

- (IBAction)btnSupportPressed:(id)sender;

- (IBAction)myProfileBtnPressed:(id)sender;


@end
