//
//  ModalClass.h
//  task_feb
//
//  Created by AEL5356 on 04/02/15.
//  Copyright (c) 2015 AEL5250. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ModalClass : NSObject



@property (nonatomic, strong) NSString *fileTitle;

@property (nonatomic, strong) NSString *downloadSource;

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic, strong) NSData *taskResumeData;

@property (nonatomic) double downloadProgress;

@property (nonatomic) BOOL isDownloading;

@property (nonatomic) BOOL downloadComplete;

@property (nonatomic) unsigned long taskIdentifier;

-(id)initWithTitle:(NSString *)title andDownloadSource:(NSString *)source;


@end
