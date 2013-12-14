//
//  ELUHeroesTableView.h
//  Dota Companion
//
//  Created by EDWARD LU on 12/13/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ELUHeroDelegate;

@interface ELUHeroesTableView : UIScrollView <UIScrollViewDelegate>

- (id)initWithFrame:(CGRect)frame delegate:(id<ELUHeroDelegate>)delegate;
@property (strong, nonatomic) id<ELUHeroDelegate> heroDelegate;

@end
