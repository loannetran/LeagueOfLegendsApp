//
//  ChampTableViewCell.h
//  LoLApp
//
//  Created by LT on 2015-09-02.
//  Copyright (c) 2015 LT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChampTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *champImgView;
@property (weak, nonatomic) IBOutlet UILabel *champLbl;

-(void)setImageAndLabelFor:(NSString *)champName;

@end
