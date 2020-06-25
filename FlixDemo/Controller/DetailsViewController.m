//
//  DetailsViewController.m
//  FlixDemo
//
//  Created by Stephanie Santana on 6/9/20.
//  Copyright © 2020 Stephanie Santana. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MovieTrailerViewController.h"


@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backDropImageView;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.movieTitleLabel.text = [self.movie[@"title"] uppercaseString];
    self.releaseDateLabel.text = self.movie[@"release_date"];
    self.overviewLabel.text = self.movie[@"overview"];
    
    if ([self.movie[@"poster_path"] isKindOfClass:[NSString class]]) {
        [self setImageForView:self.movie[@"poster_path"] imageViewPassed:self.posterImageView];
    } else {
        self.posterImageView.image = nil;
    }

    
    if ([self.movie[@"backdrop_path"] isKindOfClass:[NSString class]]) {
    [self setImageForView:self.movie[@"backdrop_path"] imageViewPassed:self.backDropImageView];
    } else {
        self.backDropImageView.image = nil;
    }
    
    self.navigationItem.title = [self.movie[@"title"] uppercaseString];
    

}

- (void)setImageForView: (NSString *)urlPath imageViewPassed:(UIImageView *)imageViewPassed {
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *fullPath = [baseURLString stringByAppendingString:urlPath];
    NSURL *posterURL = [NSURL URLWithString:fullPath];
    [imageViewPassed setImageWithURL:posterURL];

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {    
    NSString *movieID = self.movie[@"id"];
    
    NSString *fullPath = [NSString stringWithFormat: @"https://api.themoviedb.org/3/movie/%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed", movieID];
        
    MovieTrailerViewController * movieTrailerController = [segue destinationViewController];
    movieTrailerController.movieURL = fullPath;
}

@end
