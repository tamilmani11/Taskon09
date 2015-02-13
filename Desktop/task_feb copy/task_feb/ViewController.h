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
#import "Reachability.h"
#import "CircleProgressView.h"
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLSessionDelegate, NSURLSessionDownloadDelegate, NSURLSessionTaskDelegate,UIAlertViewDelegate>
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
@property (nonatomic) UILongPressGestureRecognizer *longPresstoStoptheDownload;

-(int)getFileDownloadInfoIndexWithTaskIdentifier:(unsigned long)taskIdentifier;
-(void)createDirectory:(NSURL *)urlname;
-(void)Pause_or_CancelDownload:(DownloadModelClass *) Modelobj;
-(void)ResumeDownload:(DownloadModelClass *)Modelobj;
-(void)StopDownload:(NSIndexPath *) Index;
-(NSString *) ChecktheInternetConnection;
-(void)initializeValue;
-(void)addValuetoModelclass;
- (void)Play_Pause:(UIButton*)button event:(UIEvent*)event;
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer;

@end

