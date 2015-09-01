//
//  NormalViewController.h
//  LoLApp
//
//  Created by LT on 2015-08-29.
//  Copyright (c) 2015 LT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalViewController : UIViewController

@property (weak,nonatomic) NSDictionary *playerInfo;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UILabel *totalWins;
@property (weak, nonatomic) IBOutlet UIImageView *playerIcon;
@property (weak, nonatomic) IBOutlet UITextView *playerStatsTitles;
@property (weak, nonatomic) IBOutlet UITextView *playerStats;
@property (weak, nonatomic) NSString *playerID;

@end
