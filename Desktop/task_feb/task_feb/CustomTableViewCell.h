//
//  CustomTableViewCell.h
//  task_feb
//
//  Created by AEL5356 on 02/02/15.
//  Copyright (c) 2015 AEL5250. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *Display_Image;
@property (strong, nonatomic) IBOutlet UIProgressView *Display_Status;
@property (strong, nonatomic) IBOutlet UILabel *Display_name;
@property (strong, nonatomic) IBOutlet UILabel *Ready_Status;
@property (strong, nonatomic) IBOutlet UIButton *Play_Pause;

@end
