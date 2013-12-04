//
//  ELUCardView.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/3/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUCardView.h"

@interface ELUCardView ()
@property (strong, nonatomic) UILabel *heroName;
@property (strong, nonatomic) UIImageView *heroImage;
@property (strong, nonatomic) UILabel *heroRoles;
@end

@implementation ELUCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

@end
