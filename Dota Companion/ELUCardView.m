//
//  ELUCardView.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/3/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUCardView.h"
#import "ELUHero.h"

@interface ELUCardView ()

@property (strong, nonatomic) UILabel *heroNameLabel;
@property (strong, nonatomic) UIImageView *heroImageView;
@property (strong, nonatomic) UILabel *heroRolesLabel;

@property double topMargin;
@property double imageMargin;
@property double sideMargin;
@property double imageHeight;
@property double nameLabelHeight;
@property double rolesLabelHeight;

@end

@implementation ELUCardView

- (void)baseInit {
    self.topMargin = 20.0;
    self.imageMargin = 20.0;
    self.imageHeight = 0.4;
    self.sideMargin = 20.0;
    self.nameLabelHeight = 50.0;
    self.rolesLabelHeight = 50.0;
    self.heroNameLabel = [[UILabel alloc] init];
    self.heroImageView = [[UIImageView alloc] init];
    self.heroRolesLabel = [[UILabel alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { }
    return self;
}

- (void) setupWithHero: (ELUHero*) hero {
    self.heroNameLabel.text = hero.name;
    self.heroRolesLabel.text = [hero.roles componentsJoinedByString:@" - "];
    self.heroImageView.image = hero.image_medium;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.heroNameLabel.frame = CGRectMake(self.topMargin, self.sideMargin, self.frame.size.width - self.sideMargin * 2, self.nameLabelHeight);
    self.heroImageView.frame = CGRectMake(self.topMargin + self.nameLabelHeight + self.imageMargin, self.sideMargin, self.frame.size.width - self.sideMargin * 2, self.frame.size.height * self.imageHeight);
    self.heroRolesLabel.frame = CGRectMake(self.topMargin + self.nameLabelHeight + self.imageMargin * 2 + self.heroImageView.frame.size.height, self.sideMargin, self.frame.size.width - self.sideMargin * 2, self.rolesLabelHeight);
}

@end
