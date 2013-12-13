//
//  ELUHeroesCardView.h
//  Dota Companion
//
//  Created by EDWARD LU on 12/13/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ELUHeroDelegate;

@interface ELUHeroesCardView : UIView

- (id)initWithFrame:(CGRect)frame delegate:(id<ELUHeroDelegate>) delegate;
@property (strong, nonatomic) id<ELUHeroDelegate> heroDelegate;

@end
