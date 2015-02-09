//
//  ViewController.m
//  task_feb
//
//  Created by AEL5356 on 02/02/15.
//  Copyright (c) 2015 AEL5250. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end
@implementation ViewController
@synthesize Downloadlist,session,Arrarypaths,documentsDirectory,Mytableview,SourcePath,NetworkReachability,networkStatus,BookNameArray,BookURLArray;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [Mytableview setDelegate:self];
    [Mytableview setDataSource:self];
    [self initializeValue];
}
-(void)initializeValue
{
    BookNameArray=[[NSMutableArray alloc]initWithObjects:@"Book1",@"Book2",@"Book3",@"Book4",@"Book5",@"Book6", nil];
    BookURLArray=[[NSMutableArray alloc]initWithObjects:@"http://www.lektz.com/epub/cbc_files/604.epub",@"http://www.lektz.com/epub/cbc_files/612.epub",@"http://www.lektz.com/epub/cbc_files/620.epub",@"http://www.lektz.com/epub/cbc_files/651.epub",@"http://www.lektz.com/epub/cbc_files/652.epub",@"http://www.lektz.com/epub/cbc_files/662.epub", nil];
     [self addValuetoModelclass];
}
-(void)addValuetoModelclass
{
     Downloadlist = [[NSMutableArray alloc] init];
    for (int i=0; i<BookURLArray.count; i++)
    {
    [Downloadlist addObject:[[DownloadModelClass alloc]initWithTitle:[BookNameArray objectAtIndex:i] andDownloadSource:[BookURLArray objectAtIndex:i]]];
    }
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 5;
    session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:self
                                            delegateQueue:nil];

}

- (IBAction)Play_Pause:(id)sender
{
    
}

-(int)getFileDownloadInfoIndexWithTaskIdentifier:(unsigned long)taskIdentifier{
    int index = 0;
    for (int i=0; i<[self.Downloadlist count]; i++) {
        DownloadModelClass *fdi = [self.Downloadlist objectAtIndex:i];
        if (fdi.taskIdentifier == taskIdentifier) {
            index = i;
            break;
        }
    }
    
    return index;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
  
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Downloadlist count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableIdentifier = @"CustomCell";
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableIdentifier];
    if (cell == nil)
    {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableIdentifier];
    }
    
    DownloadModelClass *tempobj=[Downloadlist objectAtIndex:indexPath.row];
    cell.Display_name.text=[tempobj fileTitle];
    
    [cell.Play_Pause addTarget:self action:@selector(Play_Pause:) forControlEvents:UIControlEventTouchUpInside];
    if (!tempobj.isDownloading)
    {
        cell.Display_Status.hidden=NO;
    }
    else
    {
        cell.Display_Status.hidden = NO;
        cell.Display_Status.progress = tempobj.downloadProgress;
    }
    if(tempobj.downloadProgress==1)
    {
        cell.Display_Status.hidden = YES;
    }
//     cell.Display_Image.image=tempobj.Tempimage;
return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownloadModelClass *modelTempobj=[Downloadlist objectAtIndex:indexPath.row];
    if (modelTempobj.downloadComplete==YES && modelTempobj.downloadProgress==1)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"These file have been downloaded!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        CustomTableViewCell *cell = (CustomTableViewCell *)[Mytableview cellForRowAtIndexPath:indexPath];
        NSIndexPath *cellIndexPath = [Mytableview indexPathForCell:cell];
            int cellIndex = cellIndexPath.row;
            DownloadModelClass *fdi = [Downloadlist objectAtIndex:cellIndex];
        //Create the new directory
          [self createStoreingDirectory:[NSURL URLWithString:fdi.downloadSource]];
        //start your download
        [self StartDownload:fdi];
        [Mytableview reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
}

-(void)createStoreingDirectory:(NSURL *)urlname
{
    Arrarypaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [Arrarypaths objectAtIndex:0];
    NSError *error;
    NSLog(@"%@",urlname);
    NSString *tempstring=[[urlname lastPathComponent] stringByDeletingPathExtension];
    SourcePath = [documentsDirectory stringByAppendingPathComponent:tempstring];
    if (![[NSFileManager defaultManager] fileExistsAtPath:SourcePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:SourcePath withIntermediateDirectories:NO attributes:nil error:&error];
    }
}

-(void)StartDownload:(DownloadModelClass *) Modelobj
{
    if ([[self ChecktheInternetConnection] isEqualToString:@"YES"])
    {
        
    if (!Modelobj.isDownloading)
    {
        if (Modelobj.taskIdentifier == -1)
        {
            Modelobj.downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:Modelobj.downloadSource]];
            Modelobj.taskIdentifier = Modelobj.downloadTask.taskIdentifier;
            [Modelobj.downloadTask resume];
        }
    }
   
    Modelobj.isDownloading = !Modelobj.isDownloading;
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"NetWork Unavailable" message:@"Check Your Internet Connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }

}
-(void)Pause_or_CancelDownload:(DownloadModelClass *) Modelobj
{
    [Modelobj.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
        if (resumeData != nil) {
            Modelobj.taskResumeData = [[NSData alloc] initWithData:resumeData];
            
        }
    }];

}
-(void)ResumeDownload:(DownloadModelClass *)Modelobj
{
    if (Modelobj.taskResumeData)
    {
        Modelobj.downloadTask = [session downloadTaskWithResumeData:Modelobj.taskResumeData];
        [Modelobj.downloadTask resume];
        Modelobj.taskIdentifier = Modelobj.downloadTask.taskIdentifier;
    }
}
#pragma mark - NSURLSession Delegate method implementation

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSData *data = [NSData dataWithContentsOfURL:location];
    int index = [self getFileDownloadInfoIndexWithTaskIdentifier:downloadTask.taskIdentifier];
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *destinationFilename = downloadTask.originalRequest.URL.lastPathComponent;
    NSString *storethedata=[SourcePath stringByAppendingPathComponent:destinationFilename];

    if ([fileManager fileExistsAtPath:storethedata])
    {
        [fileManager removeItemAtPath:storethedata error:nil];
       
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [data writeToFile:storethedata atomically:YES];
        NSLog(@"File Saved !");
    });
    if (storethedata) {
        DownloadModelClass *fdi = [Downloadlist objectAtIndex:index];
        fdi.isDownloading = NO;
        fdi.downloadComplete = YES;
        fdi.taskIdentifier = -1;
        fdi.taskResumeData = nil;
       // NSLog(@"URL===%@",location);
        [Mytableview reloadData];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [Mytableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                                 withRowAnimation:UITableViewRowAnimationNone];
            
        }];
        
    }
    else{
        NSLog(@"Unable to copy temp file. Error: %@", [error localizedDescription]);
    }
}



-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
   
    
    
    if (error != nil) {
        NSLog(@"Download completed with error: %@", [error localizedDescription]);
    }
    else{
        NSLog(@"Download finished successfully.");
    }
   
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    if (totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown) {
        NSLog(@"Unknown transfer size");
    }
    else{
               int index = [self getFileDownloadInfoIndexWithTaskIdentifier:downloadTask.taskIdentifier];
        DownloadModelClass *fdi = [Downloadlist objectAtIndex:index];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            fdi.downloadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
            
       
            CustomTableViewCell *cell = (CustomTableViewCell *)[Mytableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
          cell.Display_Status.progress = fdi.downloadProgress;
        }];
    }
}

-(NSString *) ChecktheInternetConnection
{
    NetworkReachability=[Reachability reachabilityForInternetConnection];
    networkStatus=[NetworkReachability currentReachabilityStatus];
    NSString *NetStatus;
    if (networkStatus == NotReachable)
    {
        NetStatus=@"NO";
         NSLog(@"NetWork Unavailable");
        
    }
    else
    {
        NetStatus=@"YES";
       NSLog(@"NetWork Available");
    }
    return  NetStatus;
}
-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        
        if ([downloadTasks count] == 0) {
            if (appDelegate.backgroundTransferCompletionHandler != nil) {
                void(^completionHandler)() = appDelegate.backgroundTransferCompletionHandler;
                appDelegate.backgroundTransferCompletionHandler = nil;
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    completionHandler();
                   
                    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                    localNotification.alertBody = @"All files have been downloaded!";
                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                }];
            }
        }
    }];
}

@end
