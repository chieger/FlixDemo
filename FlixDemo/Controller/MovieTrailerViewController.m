//
//  MovieTrailerViewController.m
//  FlixDemo
//
//  Created by Stephanie Santana on 6/10/20.
//  Copyright © 2020 Stephanie Santana. All rights reserved.
//

#import "MovieTrailerViewController.h"
#import <WebKit/WebKit.h>

@interface MovieTrailerViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *movieWebView;
@property (weak, nonatomic) NSArray *trailerKey;
@property (weak, nonatomic) NSString *youtubeKey;

@end

@implementation MovieTrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self fetchVideo];
}

- (void)fetchVideo {
    NSString *urlString = self.movieURL;
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            [self errorAlert:[error localizedDescription]];
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            self.trailerKey = dataDictionary[@"results"];
            
                for (NSDictionary *youtubeKey in self.trailerKey) {
                    NSLog(@"MOVIE MOVIE %@", youtubeKey[@"key"]);
                    self.youtubeKey = youtubeKey[@"key"];
                    
                }
            
            NSString *youtubeURL = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@", self.youtubeKey];
            NSURL *youtubeFinalURL = [NSURL URLWithString:youtubeURL];

            //    // Place the URL in a URL Request.
            NSURLRequest *finalRequest = [NSURLRequest requestWithURL:youtubeFinalURL
                                                   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                    timeoutInterval:10.0];
            //    // Load Request into WebView.
            [self.movieWebView loadRequest:finalRequest];

        }
    }];
    [task resume];

}

- (void)errorAlert: (NSString*)errorString {
     UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Cannot Get Video"
                                 message:errorString
                                 preferredStyle:UIAlertControllerStyleAlert];


    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Try Again"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
    [self fetchVideo];
        
    }];

    [alert addAction:okButton];

    [self presentViewController:alert animated:YES completion:nil];

}


@end
