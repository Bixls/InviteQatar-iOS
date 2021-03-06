//
//  SearchPageViewController.m
//  دعوات قطر
//
//  Created by Adham Gad on 19,8//15.
//  Copyright (c) 2015 Bixls. All rights reserved.
//

#import "SearchPageViewController.h"
#import "ASIHTTPRequest.h"
#import "UserViewController.h"
#import "NetworkConnection.h"
#import "InviteTableViewCell.h"
#import "HomePageViewController.h"

@interface SearchPageViewController ()

@property (nonatomic,strong) NSDictionary *postDict;
@property (nonatomic,strong) NSDictionary *selectedUser;
@property (nonatomic,strong) NetworkConnection *searchUsersConnection;
@property (nonatomic,strong) NSUserDefaults *userDefaults;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerHeight;
@property (weak, nonatomic) IBOutlet UIView *footerContainer;



@end

@implementation SearchPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.filteredNames = [[NSMutableArray alloc]init];
    [self.textField addTarget:self
                       action:@selector(textFieldDidChange)
             forControlEvents:UIControlEventEditingChanged];
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
   // self.viewHeight.constant = self.view.bounds.size.height - 35;

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

-(void)viewWillAppear:(BOOL)animated{
    self.searchUsersConnection = [[NetworkConnection alloc]init];
    [self.searchUsersConnection addObserver:self forKeyPath:@"response" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.searchUsersConnection removeObserver:self forKeyPath:@"response"];
    
    for (ASIHTTPRequest *request in ASIHTTPRequest.sharedQueue.operations)
    {
        if(![request isCancelled])
        {
            [request cancel];
            [request setDelegate:nil];
        }
    }
}

#pragma mark - Methods

-(void)textFieldDidChange{
    [self.searchUsersConnection searchDataBaseWithText:self.textField.text];
}

#pragma mark - KVO Methods

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"response"]) {
        NSData *responseData = [change valueForKey:NSKeyValueChangeNewKey];
        self.filteredNames = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
//        NSLog(@"%@",self.filteredNames);
        [self.tableView reloadData];
    }
}


#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"user"]) {
        UserViewController *userController = segue.destinationViewController;
        userController.user = self.selectedUser;
        
    }else if ([segue.identifier isEqualToString:@"header"]){
        HeaderContainerViewController *header = segue.destinationViewController;
        header.delegate = self;
    }else if ([segue.identifier isEqualToString:@"footer"]){
        FooterContainerViewController *footerController = segue.destinationViewController;
        footerController.delegate = self;
    }
}


#pragma mark - Table View Datasource Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredNames.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
//    if (cell==nil) {
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//
    
    InviteTableViewCell *cell = (InviteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell==nil) {
        cell=[[InviteTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    NSDictionary *user = self.filteredNames[indexPath.row];
    NSLog(@"%@",user);
    cell.userName.text = user[@"name"];
    
    NSString *imgURLString = [NSString stringWithFormat:@"http://Bixls.com/api/image.php?id=%@&t=150x150",user[@"ProfilePic"]];
    NSURL *imgURL = [NSURL URLWithString:imgURLString];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [cell.userPic sd_setImageWithURL:imgURL placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        spinner.center = cell.userPic.center;
        spinner.hidesWhenStopped = YES;
        [cell addSubview:spinner];
        [spinner startAnimating];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.userPic.image = image;
        [spinner stopAnimating];
        //        NSLog(@"Cache Type %ld",(long)cacheType);
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tableViewHeight.constant = tableView.contentSize.height;
    return cell ;
}

#pragma mark - Table view Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedUser = self.filteredNames[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self.searchController.searchBar setHidden:YES];
    [self performSegueWithIdentifier:@"user" sender:self];
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


@end
