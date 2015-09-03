//
//  SearchViewController.h
//  LoLApp
//
//  Created by LT on 2015-08-29.
//  Copyright (c) 2015 LT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTabBarViewController.h"
#import "NormalViewController.h"
#import "ChampionViewController.h"
#import "ChampTableViewCell.h"
#import "DataDownloader.h"

@interface SearchViewController : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,DataDownloaderDelegate>

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTxtFld;
@property (weak, nonatomic) IBOutlet UILabel *champName;
@property (weak, nonatomic) IBOutlet UITableView *champTable;
@end
