//
//  SuperherosViewController.m
//  FlixDemo
//
//  Created by Stephanie Santana on 6/10/20.
//  Copyright © 2020 Stephanie Santana. All rights reserved.
//

#import "SuperherosViewController.h"
#import "SuperheroCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"


@interface SuperherosViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoader;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property(nonatomic, strong) NSArray *movie;
@property(nonatomic, strong) NSArray *filteredMovies;

@end

@implementation SuperherosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.searchBar.delegate = self;
    
    [self fetchMovies];
    
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;

        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;

        CGFloat postersPerLine = 2;
        CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
        CGFloat itemHeight = itemWidth * 1.5;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityLoader startAnimating];
    });

}

- (void)fetchMovies {
        NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/618344/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
               if (error != nil) {
                   NSLog(@"%@", [error localizedDescription]);
                   [self errorAlert:[error localizedDescription]];
               }
               else {
                   NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                   
                   self.movie = dataDictionary[@"results"];
                   self.filteredMovies = self.movie;
                   [self.collectionView reloadData];
               }
            [self.activityLoader stopAnimating];
           }];
        [task resume];
}

- (void)errorAlert: (NSString*)errorString {
     UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Cannot Get Movies"
                                 message:errorString
                                 preferredStyle:UIAlertControllerStyleAlert];


    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Try Again"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
        [self fetchMovies];
        
    }];

    [alert addAction:okButton];

    [self presentViewController:alert animated:YES completion:nil];

}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SuperheroCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SuperheroCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.filteredMovies[indexPath.item];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    
    NSString *fullPath = [baseURLString stringByAppendingString:posterURLString];
    cell.movieImageView.image = nil;
    NSURL *posterURL = [NSURL URLWithString:fullPath];
    
    cell.movieImageView.alpha = 0;
    [cell.movieImageView setImageWithURL:posterURL];
    [UIImageView animateWithDuration:1 animations:^{
        cell.movieImageView.alpha = 1;
    }];


    return cell;
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredMovies.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
    
    NSDictionary *movie = self.filteredMovies[indexPath.item];
    
    DetailsViewController * detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSString *substring = [NSString stringWithString:searchText];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[c] %@",substring];
        self.filteredMovies =  [self.movie filteredArrayUsingPredicate:predicate];

        NSLog(@"%@", self.filteredMovies);
    
    } else {
        self.filteredMovies = self.movie;
    }
    
    [self.collectionView reloadData];

}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [self.collectionView reloadData];
}

@end
