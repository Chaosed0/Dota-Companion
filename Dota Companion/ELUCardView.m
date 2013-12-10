//
//  ELUCardView.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/3/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "AsyncImageView.h"
#import "ELUCardView.h"
#import "ELUHero.h"

#import <QuartzCore/QuartzCore.h>

@interface ELUCardView ()

@property (strong, nonatomic) UILabel *heroNameLabel;
@property (strong, nonatomic) AsyncImageView *heroImageView;
@property (strong, nonatomic) UILabel *heroRolesLabel;

@end

@implementation ELUCardView

- (void)baseInit {
    self.backgroundColor = [UIColor grayColor];
    static const float topMargin = 20.0;
    static const float bottomMargin = 20.0;
    static const float imageMargin = 20.0;
    static const float sideMargin = 20.0;
    static const float nameLabelHeight = 50.0;
    static const float rolesLabelHeight = 100.0;
    self.heroNameLabel = [[UILabel alloc] init];
    self.heroImageView = [[AsyncImageView alloc] init];
    self.heroRolesLabel = [[UILabel alloc] init];
    [self.heroImageView setContentMode:UIViewContentModeScaleAspectFit];
    self.heroNameLabel.textAlignment = NSTextAlignmentCenter;
    self.heroRolesLabel.textAlignment = NSTextAlignmentCenter;
    self.heroRolesLabel.numberOfLines = 0;
    
    self.heroNameLabel.frame = CGRectMake(sideMargin, topMargin, self.bounds.size.width - sideMargin * 2, nameLabelHeight);
    self.heroRolesLabel.frame = CGRectMake(sideMargin, self.bounds.size.height - bottomMargin - rolesLabelHeight, self.bounds.size.width - sideMargin * 2, rolesLabelHeight);
    self.heroImageView.frame = CGRectMake(sideMargin, self.heroNameLabel.frame.origin.y + self.heroNameLabel.frame.size.height + imageMargin, self.bounds.size.width - sideMargin * 2, self.bounds.size.height - self.heroNameLabel.frame.size.height - self.heroRolesLabel.frame.size.height - topMargin - bottomMargin - imageMargin*2);
    
    self.heroNameLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    self.heroImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.heroRolesLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    [self addSubview:self.heroNameLabel];
    [self addSubview:self.heroImageView];
    [self addSubview:self.heroRolesLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedLoadingImage:) name:AsyncImageLoadDidFail object:nil];
}

- (void)failedLoadingImage:(NSNotification*) notification {
    if(notification.object == self.heroImageView) {
        NSLog(@"Failed to load image: %@", ((NSError*)notification.userInfo[AsyncImageErrorKey]).localizedDescription);
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self baseInit];
    }
    return self;
}

- (void) setupWithHero: (ELUHero*) hero {
    self.heroNameLabel.text = hero.name;
    self.heroRolesLabel.text = [hero.roles componentsJoinedByString:@" - "];
    self.heroImageView.imageURL = hero.imageUrlPortrait;
}

/*- (void)layoutSubviews {
    [super layoutSubviews];
    self.heroNameLabel.frame = CGRectMake(self.sideMargin, self.topMargin, self.frame.size.width - self.sideMargin * 2, self.nameLabelHeight);
    self.heroImageView.frame = CGRectMake(self.sideMargin, self.topMargin + self.nameLabelHeight + self.imageMargin, self.frame.size.width - self.sideMargin * 2, self.frame.size.height * self.imageHeight);
    self.heroRolesLabel.frame = CGRectMake(self.sideMargin, self.topMargin + self.nameLabelHeight + self.imageMargin * 2 + self.heroImageView.frame.size.height, self.frame.size.width - self.sideMargin * 2, self.rolesLabelHeight);
}*/

@end
