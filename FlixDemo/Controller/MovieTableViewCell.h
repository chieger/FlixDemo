//
//  MovieTableViewCell.h
//  FlixDemo
//
//  Created by Stephanie Santana on 6/4/20.
//  Copyright © 2020 Stephanie Santana. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieTableViewCell : UITableViewCell
@property(nonatomic, weak) IBOutlet UIImageView *posterImageView;
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UILabel *descriptionLabel;

@end

NS_ASSUME_NONNULL_END
