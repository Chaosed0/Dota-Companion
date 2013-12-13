//
//  ELUHeroesCardView.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/13/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUHeroesCardView.h"
#import "ELUHeroDelegate.h"
#import "ELUCardView.h"
#import "ELUHero.h"

#define kMainCardWidth 0.7
#define kMainCardHeight 0.7
#define kSideCardWidth 0.6
#define kSideCardHeight 0.6
#define kSideCardPadding -50

@interface ELUHeroesCardView ()

@property NSInteger currentHero;
@property (strong, nonatomic) NSMutableArray *cardViews;

@end

@implementation ELUHeroesCardView

- (id)initWithFrame:(CGRect)frame delegate:(id<ELUHeroDelegate>) delegate;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [ELUConstants sharedInstance].darkBackColor;
        self.heroDelegate = delegate;
        
        self.currentHero = 0;
        
        UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeGesture:)];
        [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:swipeLeftRecognizer];
        
        UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeGesture:)];
        [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
        [self addGestureRecognizer:swipeRightRecognizer];
        
        self.userInteractionEnabled = YES;
        
        NSMutableArray *cardViews = [NSMutableArray arrayWithCapacity:5];
        
        for(int i = 0; i < 5; i++) {
            ELUCardView *cardView = [[ELUCardView alloc] initWithFrame:self.bounds];
            UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped)];
            gestureRecognizer.numberOfTapsRequired = 1;
            [cardView addGestureRecognizer:gestureRecognizer];
            cardView.userInteractionEnabled = NO;
            
            if(i > 1) {
                [cardView setupWithHero:[self.heroDelegate heroForIndex:i-2]];
                if(i == 2) {
                    cardView.userInteractionEnabled = YES;
                }
            }
            
            [cardViews addObject:cardView];
        }
            
            self.cardViews = cardViews;
        
        [self addSubview:self.cardViews[0]];
        [self addSubview:self.cardViews[4]];
        [self addSubview:self.cardViews[1]];
        [self addSubview:self.cardViews[3]];
        [self addSubview:self.cardViews[2]];
        
        {
            ELUCardView *cardView = self.cardViews[0];
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(kSideCardWidth, kSideCardHeight);
            cardView.transform = scaleTransform;
            cardView.center = CGPointMake(-cardView.frame.size.width/2.0, self.bounds.size.height/2.0);
            cardView.alpha = 0.0;
        }
        
        {
            ELUCardView *cardView = self.cardViews[1];
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(kSideCardWidth, kSideCardHeight);
            cardView.transform = scaleTransform;
            cardView.center = CGPointMake(kSideCardPadding, self.bounds.size.height/2.0);
            cardView.alpha = 0.0;
        }
        
        {
            ELUCardView *cardView = self.cardViews[2];
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(kMainCardWidth, kMainCardHeight);
            cardView.transform = scaleTransform;
        }
        
        {
            ELUCardView *cardView = self.cardViews[3];
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(kSideCardWidth, kSideCardHeight);;
            cardView.transform = scaleTransform;
            cardView.center = CGPointMake(self.bounds.size.width - kSideCardPadding, self.bounds.size.height/2.0);
        }
        
        {
            ELUCardView *cardView = self.cardViews[4];
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(kSideCardWidth, kSideCardHeight);;
            cardView.transform = scaleTransform;
            cardView.center = CGPointMake(self.bounds.size.width + cardView.frame.size.width/2.0, self.bounds.size.height/2.0);
        }
    }
    return self;
}

- (void) changeCards: (BOOL) right {
    if(right && self.currentHero > 0) {
        //Previous hero
        self.currentHero--;
        
        ELUCardView *tempCardView = self.cardViews[4];
        CGAffineTransform tempTransform = [(UIView*)self.cardViews[4] transform];
        CGRect tempFrame = [(UIView*)self.cardViews[4] frame];
        for (int i = 3; i >= 0; i--) {
            ELUCardView *cardView = self.cardViews[i];
            CGAffineTransform swapTransform = cardView.transform;
            CGRect swapFrame = cardView.frame;
            [UIView animateWithDuration:0.5 animations:^{
                cardView.transform = tempTransform;
                cardView.frame = tempFrame;
            }];
            tempTransform = swapTransform;
            tempFrame = swapFrame;
            self.cardViews[i+1] = cardView;
            
            cardView.userInteractionEnabled = NO;
            
            if((int)self.currentHero - 1 + i < 0 || (int)self.currentHero - 1 + i >= self.heroDelegate.heroCount) {
                cardView.alpha = 0.0;
            } else {
                cardView.alpha = 1.0;
            }
        }
        
        tempCardView.transform = tempTransform;
        tempCardView.frame = tempFrame;
        self.cardViews[0] = tempCardView;
        [self.cardViews[0] setupWithHero:[self.heroDelegate heroForIndex:self.currentHero-2]];
    } else if(right) {
        //Do a bounce animation
    }
    if(!right && self.currentHero < self.heroDelegate.heroCount-1) {
        //Next hero
        self.currentHero++;
        
        ELUCardView *tempCardView = self.cardViews[0];
        CGAffineTransform tempTransform = [(UIView*)self.cardViews[0] transform];
        CGRect tempFrame = [(UIView*)self.cardViews[0] frame];
        for (int i = 1; i < self.cardViews.count; i++) {
            ELUCardView *cardView = self.cardViews[i];
            CGAffineTransform swapTransform = cardView.transform;
            CGRect swapFrame = cardView.frame;
            [UIView animateWithDuration:0.5 animations:^{
                cardView.transform = tempTransform;
                cardView.frame = tempFrame;
            }];
            tempTransform = swapTransform;
            tempFrame = swapFrame;
            self.cardViews[i-1] = cardView;
            
            cardView.userInteractionEnabled = NO;
            
            if((int)self.currentHero - 3 + i < 0 || (int)self.currentHero - 3 + i >= self.heroDelegate.heroCount) {
                cardView.alpha = 0.0;
            } else {
                cardView.alpha = 1.0;
            }
        }
        
        tempCardView.transform = tempTransform;
        tempCardView.frame = tempFrame;
        self.cardViews[4] = tempCardView;
        [self.cardViews[4] setupWithHero:[self.heroDelegate heroForIndex:self.currentHero+2]];
    } else if(!right) {
        //Do a bounce animation
    }
           
    [(UIView*)self.cardViews[2] setUserInteractionEnabled:YES];
    [self bringSubviewToFront:self.cardViews[0]];
    [self bringSubviewToFront:self.cardViews[4]];
    [self bringSubviewToFront:self.cardViews[1]];
    [self bringSubviewToFront:self.cardViews[3]];
    [self bringSubviewToFront:self.cardViews[2]];
}

- (void) onSwipeGesture: (UISwipeGestureRecognizer*) gestureRecognizer {
    BOOL right = gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight;
    [self changeCards:right];
}

- (void) cardTapped {
    [self.heroDelegate heroTapped:[self.heroDelegate heroForIndex:self.currentHero]];
}

@end
