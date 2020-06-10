//
//  DetailsViewController.m
//  FlixDemo
//
//  Created by Stephanie Santana on 6/9/20.
//  Copyright © 2020 Stephanie Santana. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"


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
    
    [self setImageForView:self.movie[@"poster_path"] imageViewPassed:self.posterImageView];
    
    [self setImageForView:self.movie[@"backdrop_path"] imageViewPassed:self.backDropImageView];

    self.navigationItem.title = [self.movie[@"title"] uppercaseString];
    

}

- (void)setImageForView: (NSString *)urlPath imageViewPassed:(UIImageView *)imageViewPassed {
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *fullPath = [baseURLString stringByAppendingString:urlPath];
    NSURL *posterURL = [NSURL URLWithString:fullPath];
    [imageViewPassed setImageWithURL:posterURL];

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
