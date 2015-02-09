//
//  DownloadModelClass.m
//  task_feb
//
//  Created by AEL5356 on 07/02/15.
//  Copyright (c) 2015 AEL5250. All rights reserved.
//

#import "DownloadModelClass.h"

@implementation DownloadModelClass

-(id)initWithTitle:(NSString *)title andDownloadSource:(NSString *)source{
    if (self == [super init]) {
        self.fileTitle = title;
        self.downloadSource = source;
        self.downloadProgress = 0.0;
        self.isDownloading = NO;
        self.downloadComplete = NO;
        self.taskIdentifier = -1;
    }
    
    return self;
}
@end
