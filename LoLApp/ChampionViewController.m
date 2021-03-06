//
//  ChampionViewController.m
//  LoLApp
//
//  Created by LT on 2015-08-30.
//  Copyright (c) 2015 LT. All rights reserved.
//

#import "ChampionViewController.h"
#import <Parse/Parse.h>

@interface ChampionViewController ()

@end

@implementation ChampionViewController

-(void)setUp{
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    bg.image = [UIImage imageNamed:@"bg.jpeg"];
    [bg setAlpha:0.50];
    
    [self.view insertSubview:bg atIndex:0];
    
    self.title = self.champName;
    self.abilitiesView.hidden = YES;
    self.backBtn.hidden = YES;
    [self.backBtn.layer setCornerRadius:10];
    [self.backBtn.layer setBorderWidth:2];
    [self.backBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-3.14/2);
    rotate = CGAffineTransformScale(rotate, 0.75, 3.0);
    [self.skinPicker setTransform:rotate];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    downloader = [[DataDownloader alloc] init];
    downloader.delegate = self;
    
    [self setUp];
    [self getData];
    [self setUpGestures];
    
}

-(void)getData{
    
    currentData = @"championData";
    
    [downloader downloadDataForURL:[NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/5.2.1/data/en_US/champion/%@.json", self.champName] for:currentData];

}

-(void)theDataIs:(NSData *)data{
    
    if([downloader.name isEqualToString:@"championData"])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
            champInfo = [[[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] objectForKey:@"data"] objectForKey:[NSString stringWithFormat:@"%@",self.champName]];
            skins = [champInfo objectForKey:@"skins"];
            passive = [champInfo objectForKey:@"passive"];
            spells = [champInfo objectForKey:@"spells"];
            
            [self setData];
            
        });
        
    }
    
}

-(void)setData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *passImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/5.2.1/img/passive/%@",[[passive objectForKey:@"image"] objectForKey:@"full"]]]]];
        
        NSString *qSpell = [[[spells objectAtIndex:0] objectForKey:@"image"] objectForKey:@"full"];
        NSString *wSpell = [[[spells objectAtIndex:1] objectForKey:@"image"] objectForKey:@"full"];
        NSString *eSpell = [[[spells objectAtIndex:2] objectForKey:@"image"] objectForKey:@"full"];
        NSString *rSpell = [[[spells objectAtIndex:3] objectForKey:@"image"] objectForKey:@"full"];
        
        UIImage *qImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/5.2.1/img/spell/%@",qSpell]]]];
        UIImage *wImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/5.2.1/img/spell/%@",wSpell]]]];
        UIImage *eImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/5.2.1/img/spell/%@",eSpell]]]];
        UIImage *rImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/5.2.1/img/spell/%@",rSpell]]]];

        PFObject *champ = [PFObject objectWithClassName:@"Champion"];
        champ[@"name"] = [NSString stringWithFormat:@"%@", self.champName];
        champ[@"passive"] = [NSString stringWithFormat:@"%@", [passive objectForKey:@"name"]];
        champ[@"qSpell"] = [NSString stringWithFormat:@"%@", [[spells objectAtIndex:0] objectForKey:@"name"]];
        champ[@"wSpell"] = [NSString stringWithFormat:@"%@", [[spells objectAtIndex:1] objectForKey:@"name"]];
        champ[@"eSpell"] = [NSString stringWithFormat:@"%@", [[spells objectAtIndex:2] objectForKey:@"name"]];
        champ[@"rSpell"] = [NSString stringWithFormat:@"%@", [[spells objectAtIndex:3] objectForKey:@"name"]];
        [champ saveInBackground];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.passiveImg.image = passImg;
            self.passiveName.text = [passive objectForKey:@"name"];
            self.passiveInfo.text = [passive objectForKey:@"description"];
            self.passiveInfo.textColor = [UIColor whiteColor];
            
            [self roundedBorder:self.passiveImg];
            [self roundedBorder:self.QImg];
            [self roundedBorder:self.WImg];
            [self roundedBorder:self.EImg];
            [self roundedBorder:self.RImg];
            
            self.QImg.image = qImg;
            self.WImg.image = wImg;
            self.EImg.image = eImg;
            self.RImg.image = rImg;
            
        });
        
    });
    
}


-(void)setUpGestures{
    
    UITapGestureRecognizer *passiveText = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandInfo)];
    
    UITapGestureRecognizer *QTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openSpells:)];
    
    UITapGestureRecognizer *WTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openSpells:)];
    
    UITapGestureRecognizer *ETap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openSpells:)];
    
    UITapGestureRecognizer *RTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openSpells:)];
    
    [self.passiveImg addGestureRecognizer:passiveText];
    [self.QImg addGestureRecognizer:QTap];
    [self.WImg addGestureRecognizer:WTap];
    [self.EImg addGestureRecognizer:ETap];
    [self.RImg addGestureRecognizer:RTap];
    
}

-(void)roundedBorder:(UIView *)view{
    
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 3;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
}


-(void)openSpells:(UIGestureRecognizer *)gesture{
    
    if(gesture.view == self.QImg)
    {
        
        self.passiveTitle.text = @"Q";
        self.passiveName.text = [NSString stringWithFormat:@"%@",[[spells objectAtIndex:0] objectForKey:@"name"]];
        [self expandSpell:self.QImg.image withDescription:[NSString stringWithFormat:@"%@",[[spells objectAtIndex:0] objectForKey:@"description"]]];
        
    }else if (gesture.view == self.WImg)
    {
        self.passiveTitle.text = @"W";
        self.passiveName.text = [NSString stringWithFormat:@"%@",[[spells objectAtIndex:1] objectForKey:@"name"]];
        [self expandSpell:self.WImg.image withDescription:[NSString stringWithFormat:@"%@",[[spells objectAtIndex:1] objectForKey:@"description"]]];
        
        
    }else if(gesture.view == self.EImg)
    {
        self.passiveTitle.text = @"E";
        self.passiveName.text = [NSString stringWithFormat:@"%@",[[spells objectAtIndex:2] objectForKey:@"name"]];
        [self expandSpell:self.EImg.image withDescription:[NSString stringWithFormat:@"%@",[[spells objectAtIndex:2] objectForKey:@"description"]]];
        
    }else{

        self.passiveTitle.text = @"R";
        self.passiveName.text = [NSString stringWithFormat:@"%@",[[spells objectAtIndex:3] objectForKey:@"name"]];
        self.passiveImg.image = self.RImg.image;
        [self expandSpell:self.RImg.image withDescription:[NSString stringWithFormat:@"%@",[[spells objectAtIndex:3] objectForKey:@"description"]]];
        
    }
    
}

-(IBAction)goBack{
    
    self.passiveTitle.text = @"Passive";
    self.passiveImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/5.2.1/img/passive/%@",[[passive objectForKey:@"image"] objectForKey:@"full"]]]]];
    
    self.passiveName.text = [passive objectForKey:@"name"];
    self.passiveInfo.text = [passive objectForKey:@"description"];
    self.passiveInfo.textColor = [UIColor whiteColor];

    [self.backBtn setHidden:YES];
    [self.passiveInfo setScrollEnabled:NO];
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         CGRect frame = self.passiveInfo.frame;
                         frame.size.height -= 100.0f;
                         self.passiveInfo.frame = frame;
                     }
                     completion:^(BOOL finished){
                     }];
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.4;
    [self.QImg.layer addAnimation:animation forKey:nil];
    [self.WImg.layer addAnimation:animation forKey:nil];
    [self.EImg.layer addAnimation:animation forKey:nil];
    [self.RImg.layer addAnimation:animation forKey:nil];
    
    [self.abilitiesTitle setHidden:NO];
    [self.QImg setHidden:NO];
    [self.WImg setHidden:NO];
    [self.EImg setHidden:NO];
    [self.RImg setHidden:NO];

}

-(void)expandInfo{
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.20;
    [self.QImg.layer addAnimation:animation forKey:nil];
    [self.WImg.layer addAnimation:animation forKey:nil];
    [self.EImg.layer addAnimation:animation forKey:nil];
    [self.RImg.layer addAnimation:animation forKey:nil];
    
    [self.abilitiesTitle setHidden:YES];
    [self.QImg setHidden:YES];
    [self.WImg setHidden:YES];
    [self.EImg setHidden:YES];
    [self.RImg setHidden:YES];
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         CGRect frame = self.passiveInfo.frame;
                         frame.size.height += 100.0f;
                         self.passiveInfo.frame = frame;
                     }
                     completion:^(BOOL finished){
                     }];
    [self.backBtn setHidden:NO];
}

-(void)expandSpell:(UIImage *)image withDescription:(NSString *)desc{
    
    [self.abilitiesTitle setHidden:YES];
    [self.QImg setHidden:YES];
    [self.WImg setHidden:YES];
    [self.EImg setHidden:YES];
    [self.RImg setHidden:YES];
    
    [self.passiveInfo setScrollEnabled:YES];
    [self.passiveInfo setClipsToBounds:NO];
    
    self.passiveImg.image = image;
    self.passiveInfo.text = desc;
    self.passiveInfo.textColor = [UIColor whiteColor];
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.20;
    [self.QImg.layer addAnimation:animation forKey:nil];
    [self.WImg.layer addAnimation:animation forKey:nil];
    [self.EImg.layer addAnimation:animation forKey:nil];
    [self.RImg.layer addAnimation:animation forKey:nil];

    
    [UIView animateWithDuration:0.25f
                     animations:^{

                         CGRect frame = self.passiveInfo.frame;
                         frame.size.height += 100.0f;
                         self.passiveInfo.frame = frame;
                    
                     }
                     completion:^(BOOL finished){
                     }];
    [self.backBtn setHidden:NO];

}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 50;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    
    UIView *skinView = view;
    
    if (skinView == nil) {
        skinView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 92, 200)];
        
//        NSLog(@"created");
    }
    
    UIImageView *skinImage = [[UIImageView alloc] initWithFrame:CGRectMake(4, 20, 80, 130)];
    CGColorRef color = [[UIColor darkGrayColor] CGColor];
    skinImage.layer.masksToBounds = NO;
    skinImage.layer.shadowRadius = 1.0f;
    skinImage.layer.shadowOpacity = 0.8f;
    skinImage.layer.shadowColor = color;
    skinImage.layer.shadowOffset = CGSizeMake( 4.0f, 5.0f);
    skinImage.layer.shouldRasterize = YES;
    skinImage.layer.borderWidth = 0.8;
    UILabel *skinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 138, 90, 50)];
    skinLabel.textColor = [UIColor colorWithRed:134.0/255.0 green:11.0/255.0 blue:16.0/255.0 alpha:1];
    skinLabel.font = [UIFont fontWithName:@"Arial" size:11];
    skinLabel.numberOfLines = 2;
    skinLabel.textAlignment = NSTextAlignmentCenter;
    
    for (int i = 0; i<skins.count; i++) {
        if(row == i)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                UIImage *currentSkin = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/img/champion/loading/%@_%@.jpg",self.champName, [[skins objectAtIndex:i] objectForKey:@"num"]]]]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    skinImage.image = currentSkin;
                    
                    [skinView addSubview:skinImage];
                    
                    skinLabel.text = [NSString stringWithFormat:@"%@", [[skins objectAtIndex:i]objectForKey:@"name"]];
                    
                    [skinView addSubview:skinLabel];
                    
                });
                
            });
            

        }
    }

    
    CGAffineTransform rotate = CGAffineTransformMakeRotation(3.14/2);
    rotate = CGAffineTransformScale(rotate, 0.50, 2.0);
    [skinView setTransform:rotate];
    
    return skinView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
//    NSLog(@"%lu", (unsigned long)skins.count);
    return 1;
    
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return skins.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
