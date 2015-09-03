//
//  ChampionViewController.h
//  LoLApp
//
//  Created by LT on 2015-08-30.
//  Copyright (c) 2015 LT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataDownloader.h"

@interface ChampionViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate,DataDownloaderDelegate>{

    NSArray *champSkins;
    NSDictionary *champInfo;
    NSArray *skins;
    NSArray *spells;
    NSDictionary *passive;
    NSString *currentData;
    DataDownloader *downloader;
}

@property (weak, nonatomic) IBOutlet UILabel *passiveName;
@property (weak, nonatomic) IBOutlet UITextView *passiveInfo;
@property (weak, nonatomic) IBOutlet UIPickerView *skinPicker;
@property (weak, nonatomic) NSString *champName;

@property (weak, nonatomic) IBOutlet UIImageView *passiveImg;

@property (weak, nonatomic) IBOutlet UIImageView *QImg;
@property (weak, nonatomic) IBOutlet UIImageView *WImg;
@property (weak, nonatomic) IBOutlet UIImageView *EImg;
@property (weak, nonatomic) IBOutlet UIImageView *RImg;
@property (weak, nonatomic) IBOutlet UILabel *abilitiesTitle;
@property (weak, nonatomic) IBOutlet UILabel *passiveTitle;
@property (weak, nonatomic) IBOutlet UIView *abilitiesView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

- (IBAction)goBack;
@end
