//
//  SecEventsViewController.m
//  دعوات قطر
//
//  Created by Adham Gad on 5,7//15.
//  Copyright (c) 2015 Bixls. All rights reserved.
//

#import "SecEventsViewController.h"
#import "ASIHTTPRequest.h"
#import "SecEventTableViewCell.h"


@interface SecEventsViewController ()

@property (nonatomic,strong) NSMutableArray *allEvents;
@property (nonatomic) NSInteger start;
@property (nonatomic) NSInteger limit;


@end

@implementation SecEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.start = 0 ;
    self.limit = 10;
    self.allEvents = [[NSMutableArray alloc]init];
    [self getEvents];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allEvents.count;
}
-(SecEventTableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    SecEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[SecEventTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *event = self.allEvents[indexPath.row];
    cell.eventSubject.text = event[@"subject"];
    cell.eventCreator.text = event[@"CreatorName"];
    cell.eventDate.text = event[@"TimeEnded"] ;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        NSString *imageURL = @"http://www.bixls.com/Qatar/uploads/user/201507/6-02032211.jpg"; //needs to be dynamic
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
        UIImage *img = [[UIImage alloc]initWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
            cell.eventPicture.image = img;
            
        });
    });

    
    return cell ;
}


#pragma mark - Connection Setup

-(void)getEvents {
    
        NSDictionary *getEvents = @{@"FunctionName":@"getEvents" , @"inputs":@[@{@"groupID":@"2",
                                                                                 @"catID":[NSString stringWithFormat:@"%ld",(long)self.selectedSection],
                                                                                 @"start":[NSString stringWithFormat:@"%ld",(long)self.start],
                                                                                 @"limit":[NSString stringWithFormat:@"%ld",(long)self.limit]}]};
        NSMutableDictionary *getEventsTag = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"sectionEvents",@"key", nil];
        
        [self postRequest:getEvents withTag:getEventsTag];
    
}

#pragma mark - Connection Setup

-(void)postRequest:(NSDictionary *)postDict withTag:(NSMutableDictionary *)dict{
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"admin", @"admin"];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    NSString *urlString = @"http://bixls.com/Qatar/" ;
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
    
    //NSString *responseString = [request responseString];
    
    NSData *responseData = [request responseData];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    NSString *key = [request.userInfo objectForKey:@"key"];
    if ([key isEqualToString:@"sectionEvents"]&& array ) {
        [self.allEvents addObjectsFromArray:array];
        
    }
    NSLog(@"%@",self.allEvents);
    [self.tableView reloadData];
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
}





@end