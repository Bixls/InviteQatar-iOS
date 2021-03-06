//
//  EventAttendeesViewController.m
//  دعوات قطر
//
//  Created by Adham Gad on 7,7//15.
//  Copyright (c) 2015 Bixls. All rights reserved.
//

#import "EventAttendeesViewController.h"
#import "AttendeeTableViewCell.h"
#import "ASIHTTPRequest.h"
#import <SVPullToRefresh.h>
#import "UserViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HomePageViewController.h"

@interface EventAttendeesViewController ()

@property (nonatomic,strong) NSMutableArray *allUsers;
@property (nonatomic) NSInteger start;
@property (nonatomic) NSInteger limit;
@property (nonatomic) BOOL populate;
@property (nonatomic,strong)NSDictionary *selectedUser;
@property (nonatomic,strong) NSUserDefaults *userDefaults;
@property (weak, nonatomic) IBOutlet UIView *footerContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerHeight;
@end

@implementation EventAttendeesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationItem.backBarButtonItem = nil;
    UIBarButtonItem *backbutton =  [[UIBarButtonItem alloc] initWithTitle:@"عوده" style:UIBarButtonItemStylePlain target:nil action:nil];
    [backbutton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:18],NSFontAttributeName,
                                        nil] forState:UIControlStateNormal];
    backbutton.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backbutton;
    self.view.backgroundColor = [UIColor blackColor];
    
//    [self.tableView addInfiniteScrollingWithActionHandler:^{
        self.populate = YES ;
//        self.start = self.start+10 ;
//        //self.limit = 10;
//        [self getAttendees];
//    }];
    self.start = 0 ;
    self.limit = 10 ;
    self.allUsers = [[NSMutableArray alloc]init];
    
    [self.navigationItem setHidesBackButton:YES];
    [self addOrRemoveFooter];
}

-(void)addOrRemoveFooter {
    BOOL remove = [[self.userDefaults objectForKey:@"removeFooter"]boolValue];
    [self removeFooter:remove];
    
}

-(void)adjustFooterHeight:(NSInteger)height{
    self.footerHeight.constant = height;
}

-(void)removeFooter:(BOOL)remove{
    self.footerContainer.clipsToBounds = YES;
    if (remove == YES) {
        self.footerHeight.constant = 0;
    }else if (remove == NO){
        self.footerHeight.constant = 492;
    }
    [self.userDefaults setObject:[NSNumber numberWithBool:remove] forKey:@"removeFooter"];
    [self.userDefaults synchronize];
}

-(void)viewDidAppear:(BOOL)animated{
   [self getAttendees]; 
}

-(void)viewWillDisappear:(BOOL)animated{
    for (ASIHTTPRequest *request in ASIHTTPRequest.sharedQueue.operations)
    {
        if(![request isCancelled])
        {
            [request cancel];
            [request setDelegate:nil];
        }
    }
}

- (void)insertRowAtBottomWithArray:(NSArray *)arr {
    if (arr) {
        __weak EventAttendeesViewController *weakSelf = self;
        
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf.tableView beginUpdates];
            [self.allUsers addObjectsFromArray:arr];
            [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.allUsers.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.tableView endUpdates];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            
        });
        
    }
    
}

#pragma mark - TableView DataSource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.allUsers.count >0) {
        return self.allUsers.count +1;
    }else{
        return 0;
    }
}

-(AttendeeTableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.tableViewHeight.constant = tableView.contentSize.height;
    if(indexPath.row<(self.allUsers.count)){
        AttendeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        if (cell==nil) {
            cell=[[AttendeeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        
        NSDictionary *user = self.allUsers[indexPath.row];
        cell.userName.text = user[@"name"];

        NSString *imgURLString = [NSString stringWithFormat:@"http://Bixls.com/api/image.php?id=%@&t=150x150",user[@"ProfilePic"]];
        NSURL *imgURL = [NSURL URLWithString:imgURLString];
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [cell.userImage sd_setImageWithURL:imgURL placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            spinner.center = cell.userImage.center;
            spinner.hidesWhenStopped = YES;
            [cell addSubview:spinner];
            [spinner startAnimating];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.userImage.image = image;
            [spinner stopAnimating];
        }];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (indexPath.row == self.allUsers.count){
        
        AttendeeTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
        if (cell1==nil) {
            cell1=[[AttendeeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell1"];
        }
        
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell1;
    }
    
    
    return nil ;

}

#pragma mark - Table View Delegate Methods 

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.allUsers.count) {
        self.selectedUser = self.allUsers[indexPath.row];
        [self performSegueWithIdentifier:@"showUser" sender:self];
    }
    
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showUser"]) {
        UserViewController *userController = segue.destinationViewController;
        userController.user = self.selectedUser;
        self.populate = NO;
    }else if ([segue.identifier isEqualToString:@"header"]){
        HeaderContainerViewController *header = segue.destinationViewController;
        header.delegate = self;
    }else if ([segue.identifier isEqualToString:@"footer"]){
        FooterContainerViewController *footerController = segue.destinationViewController;
        footerController.delegate = self;
    }
}

#pragma mark - Connection Setup

-(void)getAttendees {

    NSDictionary *getUsers = @{@"FunctionName":@"ViewEventAttendees" , @"inputs":@[@{@"eventID":[NSString stringWithFormat:@"%ld",(long)self.eventID],
                                                                                      @"start":[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:self.start]],
                                                                                      @"limit":[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:self.limit]]
                                                                             }]};
    NSMutableDictionary *getUsersTag = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"getAttendees",@"key", nil];
    
    [self postRequest:getUsers withTag:getUsersTag];
    
}

-(void)postRequest:(NSDictionary *)postDict withTag:(NSMutableDictionary *)dict{
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"admin", @"admin"];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    NSString *urlString = @"http://Bixls.com/api/" ;
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.username =@"admin";
    request.password = @"admin";
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Authorization" value:authValue];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"content-type" value:@"application/json"];
    request.allowCompressedResponse = NO;
    request.useCookiePersistence = NO;
    request.shouldCompressRequestBody = NO;
    request.userInfo = dict;
    [request setPostBody:[NSMutableData dataWithData:[NSJSONSerialization dataWithJSONObject:postDict options:kNilOptions error:nil]]];
    [request startAsynchronous];
    
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSData *responseData = [request responseData];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    NSString *key = [request.userInfo objectForKey:@"key"];
    
    if ([key isEqualToString:@"getAttendees"] && ! [array isEqualToArray:self.allUsers]) {
        [self.allUsers addObjectsFromArray:array];
        [self.tableView reloadData];
    }else{

    }

    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
//    NSLog(@"%@",error);
}

#pragma mark - Header Delegate

-(void)homePageBtnPressed{
    HomePageViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"home"]; //
    [self.navigationController pushViewController:homeVC animated:NO];
}

-(void)backBtnPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Buttons


- (IBAction)btnSeeMorePressed:(id)sender {
    self.start = self.allUsers.count;
    [self getAttendees];
}


@end
