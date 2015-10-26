//
//  SearchViewController.m
//  LoLApp
//
//  Created by LT on 2015-08-29.
//  Copyright (c) 2015 LT. All rights reserved.
//

#import "SearchViewController.h"


@interface SearchViewController () {

    NSString *searchName;
    NSData *summonerData;
    NSDictionary *playerInfo;
    NSDictionary *dictChamps;
    NSArray *champNames;
    NSString *selectedChamp;
    BOOL isFiltered;
    NSMutableArray *filteredData;
    NSString *currentData;
    DataDownloader *downloader;
}

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    downloader = [[DataDownloader alloc] init];
    downloader.delegate = self;
    
    [self setUp];
    [self getChampNames];
    
}

-(void)setUp{
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    bg.image = [UIImage imageNamed:@"bg.jpeg"];
    [bg setAlpha:0.50];
    [self.view insertSubview:bg atIndex:0];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:0.7]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:134.0/255.0 green:11.0/255.0 blue:16.0/255.0 alpha:0.7]];
    
    [self.champTable setBackgroundColor:[UIColor clearColor]];
    
    [self.champTable setBounces:NO];
    [self.searchBtn setTitleColor:[UIColor colorWithRed:134.0/255.0 green:11.0/255.0 blue:16.0/255.0 alpha:1] forState:UIControlStateNormal];
    [self.searchBtn.layer setBorderWidth:2];
    [self.searchBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    self.searchBtn.layer.cornerRadius = 10;
    self.searchBtn.layer.masksToBounds = YES;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor colorWithRed:134.0/255.0 green:11.0/255.0 blue:16.0/255.0 alpha:1];
    title.font = [UIFont fontWithName:@"GurmukhiMN-Bold" size:30];
    title.shadowColor = [UIColor lightGrayColor];
    title.text = @"Champions";
    [title setBackgroundColor:[UIColor grayColor]];
    [title.layer setBorderWidth:1];
    [title.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(isFiltered)
    {
        return filteredData.count;
    }else{
        return champNames.count;
    }

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
 
    UITextField *textField = [searchBar valueForKey:@"_searchField"];
    textField.clearButtonMode = UITextFieldViewModeNever;
    
    if(searchText.length == 0)
    {
        isFiltered = NO;
        
    }else
    {
        isFiltered = YES;
        
        filteredData = [[NSMutableArray alloc] init];
        
        for (NSObject *champ in champNames)
        {
            NSString *name = [NSString stringWithFormat:@"%@", champ];
            
            NSRange champRange = [name rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
            
            if(champRange.location != NSNotFound)
            {
                [filteredData addObject:champ];
            }
        }
    
    }
    
    [self.champTable reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChampTableViewCell *cell = [self.champTable dequeueReusableCellWithIdentifier:@"champ"];
    
        if(isFiltered)
        {
            [cell getDataForChamp:[filteredData objectAtIndex:indexPath.row]];
            
        }else{
            [cell getDataForChamp:[champNames objectAtIndex:indexPath.row]];
        }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if([self.searchTxtFld isFirstResponder])
    {
        [self.searchTxtFld resignFirstResponder];
    }
    
    indexPath = [self.champTable indexPathForSelectedRow];
    
    UIAlertView *noInfo;
    
    if([[champNames objectAtIndex:indexPath.row] isEqual:@"Bard"] || [[champNames objectAtIndex:indexPath.row] isEqual:@"Ekko"] || [[champNames objectAtIndex:indexPath.row] isEqual:@"TahmKench"] || [[champNames objectAtIndex:indexPath.row] isEqual:@"Kindred"])
    {
        noInfo = [[UIAlertView alloc] initWithTitle:@"Champ Info" message:@"Champ information not available at this time" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
    }else if([[filteredData objectAtIndex:indexPath.row] isEqual:@"Bard"] || [[filteredData objectAtIndex:indexPath.row] isEqual:@"Ekko"] || [[filteredData objectAtIndex:indexPath.row] isEqual:@"TahmKench"] || [[filteredData objectAtIndex:indexPath.row] isEqual:@"Kindred"]){
        
        noInfo = [[UIAlertView alloc] initWithTitle:@"Champ Info" message:@"Champ information not available at this time" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
    }else{
        
        if(isFiltered)
        {
            selectedChamp = [NSString stringWithFormat:@"%@", [filteredData objectAtIndex:indexPath.row]];
            
            
        }else{
            selectedChamp = [NSString stringWithFormat:@"%@", [champNames objectAtIndex:indexPath.row]];
            
        }
        
        [self.champTable deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"champion" sender:self];

    }
    
    [noInfo show];
}

-(void)getChampNames{
    
    currentData = @"champions";
    
    [downloader downloadDataForURL:@"https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion?champData=image&api_key=c1d89e3c-dea9-44f3-b9a3-11d85d099822" for:currentData];

}

-(void)getSummoner{
    
    currentData = @"summoner";
    
    searchName = [[self.searchTxtFld.text stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
    
    [downloader downloadDataForURL:[NSString stringWithFormat:@"https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/%@?api_key=c1d89e3c-dea9-44f3-b9a3-11d85d099822",searchName] for:currentData];
}

-(void)theDataIs:(NSData *)data{
    
    if([downloader.name isEqualToString:@"champions"])
    {
        dictChamps = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] objectForKey:@"data"];
        champNames = [dictChamps allKeys];
        champNames = [champNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        
        [self.champTable reloadData];
    }
    
    if ([downloader.name isEqualToString:@"summoner"]) {
        
        summonerData = data;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Summoner's name" message:@"Summoner's name does not exist" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        if(summonerData == nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                    [alert show];
                [self.searchTxtFld becomeFirstResponder];
            });
            
        }else{
            playerInfo = [NSJSONSerialization JSONObjectWithData:summonerData options:NSJSONReadingMutableContainers error:nil];
            
            if (playerInfo [searchName]) {
                [self.searchTxtFld resignFirstResponder];
                [self performSegueWithIdentifier:@"search" sender:self];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [alert show];
                    [self.searchTxtFld becomeFirstResponder];
                });
            }
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self getSummoner];
    
    return YES;
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    if([identifier isEqualToString: @"search"])
    {
        [self getSummoner];
    }
    
    return NO;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"search"])
    {
        MyTabBarViewController *tbVc = segue.destinationViewController;
        
        tbVc.playerInfo = [playerInfo objectForKey:searchName];

    }
    
    if([[segue identifier] isEqualToString:@"champion"])
    {
        if ([self.filterSearchBar isFirstResponder]) {
            
            [self.filterSearchBar resignFirstResponder];
        }
        
        ChampionViewController *cVc = segue.destinationViewController;
        
        cVc.champName = selectedChamp;
    }
    
}

@end
