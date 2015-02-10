//
//  ViewController.h
//  task_feb
//
//  Created by AEL5356 on 02/02/15.
//  Copyright (c) 2015 AEL5250. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadModelClass.h"
#import "CustomTableViewCell.h"
#import "AppDelegate.h"
#import "Reachability.h"
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLSessionDelegate, NSURLSessionDownloadDelegate, NSURLSessionTaskDelegate>
@property (strong, nonatomic) IBOutlet UITableView *Mytableview;
@property (nonatomic, strong) NSURLSession *session;
@property(nonatomic) NSString *documentsDirectory;
@property(nonatomic) NSArray *Arrarypaths;
@property(nonatomic)  NSString *SourcePath;
@property (strong, nonatomic) NSMutableArray *Downloadlist;
@property(nonatomic) NSMutableArray *BookNameArray;
@property(nonatomic) NSMutableArray *BookURLArray;
@property (nonatomic) Reachability *NetworkReachability;
@property (nonatomic) NetworkStatus *networkStatus;

-(int)getFileDownloadInfoIndexWithTaskIdentifier:(unsigned long)taskIdentifier;
-(void)createStoreingDirectory:(NSURL *)urlname;
-(void)StartDownload:(DownloadModelClass *) Modelobj;
-(void)Pause_or_CancelDownload:(DownloadModelClass *) Modelobj;
-(void)ResumeDownload:(DownloadModelClass *)Modelobj;
-(NSString *) ChecktheInternetConnection;
-(void)initializeValue;
-(void)addValuetoModelclass;
- (void)Play_Pause:(UIButton*)button event:(UIEvent*)event;
//-(void)Play_Pause:(UIButton *)Index;
//- (IBAction)Play_Pause:(id)sender;

@end

