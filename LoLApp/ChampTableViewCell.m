//
//  ChampTableViewCell.m
//  LoLApp
//
//  Created by LT on 2015-09-02.
//  Copyright (c) 2015 LT. All rights reserved.
//

#import "ChampTableViewCell.h"

@implementation ChampTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setImageAndLabelFor:(NSString *)champName{
    
    self.champImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/5.2.1/img/champion/%@.png", champName]]]];
    
    self.champLbl.text = [NSString stringWithFormat:@"%@",champName];
    
    self.champImgView.layer.cornerRadius = 10;
    self.champImgView.layer.masksToBounds = YES;
    self.champLbl.textAlignment = NSTextAlignmentCenter;

}

@end
