//
//  chooseGroupViewController.m
//  دعوات قطر
//
//  Created by Adham Gad on 29,6//15.
//  Copyright (c) 2015 Bixls. All rights reserved.
//

#import "chooseGroupViewController.h"
#import "ASIHTTPRequest.h"
#import "ChooseGroupTableViewCell.h"
#import "InviteViewController.h"
#import "NetworkConnection.h"

@interface chooseGroupViewController ()

@property (nonatomic , strong) NSArray *responseArray;
@property (nonatomic , strong) NSMutableArray *mutableResponse;
@property (nonatomic,strong) NSUserDefaults *userDefaults;
@property (nonatomic,strong) NSDictionary *selectedGroup;
@property (nonatomic,strong) NetworkConnection *getAllGroupsConn;

@end

@implementation chooseGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.hidden = YES;
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.getAllGroupsConn = [[NetworkConnection alloc]init];
    self.mutableResponse = [[NSMutableArray alloc]init];

    
}

-(void)viewDidAppear:(BOOL)animated{
    [self.getAllGroupsConn addObserver:self forKeyPath:@"response" options:NSKeyValueObservingOptionNew context:nil];
    
    NSDictionary *postDict = @{
                               @"FunctionName":@"getGroupList" ,
                               @"inputs":@[@{@"limit":[NSNumber numberWithInt:1000]}]};
    
    if (self.mutableResponse.count > 0) {
        [self.mutableResponse removeAllObjects];
    }else{
        //donothing
    }
    [self.getAllGroupsConn postRequest:postDict withTag:nil];
    

}

-(void)viewWillDisappear:(BOOL)animated{
    
    [self.getAllGroupsConn removeObserver:self forKeyPath:@"response"];
    
    for (ASIHTTPRequest *request in ASIHTTPRequest.sharedQueue.operations)
    {
        if(![request isCancelled])
        {
            [request cancel];
            [request setDelegate:nil];
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"response"]) {
        
        NSData *responseData = [change valueForKey:NSKeyValueChangeNewKey];
        self.responseArray =[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        for (int i = 0; i < self.responseArray.count ; i++) {
            if (i == 1) {
                [self.mutableResponse insertObject:self.responseArray[i] atIndex:0];
            }else{
                [self.mutableResponse addObject:self.responseArray[i]];
            }
        }
        
        if ([self.responseArray isEqualToArray:[self.userDefaults objectForKey:@"groupArray"]]) {
            //do nothing
        }else{
            [self.userDefaults setObject:self.mutableResponse forKey:@"groupArray"];
            [self.userDefaults synchronize];
            [self.tableView reloadData];
        }

    }
}


#pragma mark - Segue 

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"invite"]) {
        if (self.createMsgFlag != 1) {
            InviteViewController *inviteController = segue.destinationViewController;
            inviteController.normORVIP = self.VIPFlag;
            inviteController.group = self.selectedGroup;
            inviteController.eventID = self.eventID;
            inviteController.inviteOthers = self.inviteOthers;
            inviteController.editingMode = self.editingMode;
            if (self.invitees.count > 0) {
                inviteController.invitees = self.invitees;
            }
            if (self.editingMode == YES && self.previousInvitees.count > 0) {
                inviteController.previousInvitees = self.previousInvitees;
            }
        }else if (self.createMsgFlag == 1 ){
            InviteViewController *inviteController = segue.destinationViewController;
            inviteController.createMsgFlag = self.createMsgFlag;
            inviteController.group = self.selectedGroup;
        }
      
    }
}

#pragma mark - Table view Data Source Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *tempArray = [self.userDefaults objectForKey:@"groupArray"];
    return tempArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    ChooseGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[ChooseGroupTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSArray *tempArray = [self.userDefaults objectForKey:@"groupArray"];

    cell.groupName.text = tempArray[indexPath.row][@"name"];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell ;
}

#pragma mark - Table view Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *tempArray = [self.userDefaults objectForKey:@"groupArray"];
    NSDictionary *selectedGroup = tempArray[indexPath.row];
    if (self.flag != 1 && self.createMsgFlag != 1) {
        if ([self.delegate respondsToSelector:@selector(selectedGroup:)]) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self.delegate selectedGroup:selectedGroup];

            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else if (self.flag ==1){
        NSArray *tempArray = [self.userDefaults objectForKey:@"groupArray"];
        self.selectedGroup = tempArray[indexPath.row];
        [self performSegueWithIdentifier:@"invite" sender:self];
    }else if (self.createMsgFlag == 1){
        self.selectedGroup = tempArray[indexPath.row];
        [self performSegueWithIdentifier:@"invite" sender:self];
        
    }
}

- (IBAction)btnDismissPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
