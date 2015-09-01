//
//  SearchViewController.h
//  LoLApp
//
//  Created by LT on 2015-08-29.
//  Copyright (c) 2015 LT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTxtFld;
@property (weak, nonatomic) IBOutlet UILabel *champName;
@property (weak, nonatomic) IBOutlet UITableView *champTable;
@end
