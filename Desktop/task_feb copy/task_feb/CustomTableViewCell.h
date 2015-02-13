//
//  CustomTableViewCell.h
//  task_feb
//
//  Created by AEL5356 on 02/02/15.
//  Copyright (c) 2015 AEL5250. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleProgressView.h"
@interface CustomTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *BookImage;
@property (strong, nonatomic) IBOutlet UIProgressView *ProgressBar;
@property (strong, nonatomic) IBOutlet UILabel *BookNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *PercentageLabel;
@property (strong, nonatomic) IBOutlet UIButton *Play_PauseButton;





@end
