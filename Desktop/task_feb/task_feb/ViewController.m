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

-(void)Play_Pause:(UIButton *)button event:(UIEvent *)event
{
    
    NSIndexPath* indexPath = [Mytableview indexPathForRowAtPoint:
                              [[[event touchesForView:button] anyObject]
                               locationInView:Mytableview]];
    
              DownloadModelClass *fdi = [Downloadlist objectAtIndex:indexPath.row];
    if ([[self ChecktheInternetConnection] isEqualToString:@"YES"])
    {
    if (!fdi.isDownloading) {
            
            if (fdi.taskIdentifier == -1) {
                                fdi.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:fdi.downloadSource]];
                
                               fdi.taskIdentifier = fdi.downloadTask.taskIdentifier;
                
               
                [fdi.downloadTask resume];
            }
            else{
                
                [self ResumeDownload:fdi];
                
            }
        }
        else{
            
            [self Pause_or_CancelDownload:fdi];
        
        }
       
        fdi.isDownloading = !fdi.isDownloading;
       
   [Mytableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"NetWork Unavailable" message:@"Check Your Internet Connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    
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
    
   [cell.Play_Pause addTarget:self action:@selector(Play_Pause:event:) forControlEvents:UIControlEventTouchUpInside];
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

return cell;
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





-(void)Pause_or_CancelDownload:(DownloadModelClass *) Modelobj
{
    [Modelobj.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
        if (resumeData != nil)
        {
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
    DownloadModelClass *tempobj=[Downloadlist objectAtIndex:index];
     [self createStoreingDirectory:[NSURL URLWithString:[tempobj downloadSource]]];
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
        fdi.DownloadStatusChecking =YES;
        
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

@end
