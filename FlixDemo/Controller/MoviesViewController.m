//
//  MoviesViewController.m
//  FlixDemo
//
//  Created by Stephanie Santana on 6/3/20.
//  Copyright © 2020 Stephanie Santana. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MoviesViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, weak) IBOutlet UITableView *moviesTableView;
@property(nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoader;

@end

@implementation MoviesViewController
// This is a test of rebase in git

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.moviesTableView.delegate = self;
    self.moviesTableView.dataSource = self;
    
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    
    [self.moviesTableView addSubview:self.refreshControl];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityLoader startAnimating];
        });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self.moviesTableView deselectRowAtIndexPath:[self.moviesTableView indexPathForSelectedRow] animated:animated];

}

- (void)fetchMovies {
        NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
               if (error != nil) {
                   NSLog(@"%@", [error localizedDescription]);
                   [self errorAlert:[error localizedDescription]];
               }
               else {
                   NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                   
                   self.movies = dataDictionary[@"results"];
                   
                   for (NSDictionary *movie in self.movies) {
                       NSLog(@"MOVIE MOVIE %@", movie[@"title"]);
                   }
                   [self.moviesTableView reloadData];
               }
            [self.refreshControl endRefreshing];
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];

    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = [movie[@"title"] uppercaseString];
    cell.descriptionLabel.text = movie[@"overview"];
    
    NSString *highResURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *lowResURLString = @"https://image.tmdb.org/t/p/w342";
            
    NSString *posterURLString = movie[@"backdrop_path"];
    
    if ([movie[@"backdrop_path"] isKindOfClass:[NSString class]]) {

    //setting low res image
    NSString *lowResFullPath = [lowResURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:lowResFullPath];
    cell.posterImageView.alpha = 0;
    [cell.posterImageView setImageWithURL:posterURL];

    //setting high res image
    NSString *highResFullPath = [highResURLString stringByAppendingString:posterURLString];
    NSURL *posterHighResURL = [NSURL URLWithString:highResFullPath];
    [UIView animateWithDuration:1 animations:^ {
        cell.posterImageView.alpha = 1;
        [cell.posterImageView setImageWithURL:posterHighResURL];
    }];
    
    } else {
        cell.posterImageView.image = nil;
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.moviesTableView indexPathForCell:tappedCell];
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    DetailsViewController * detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
}

@end
