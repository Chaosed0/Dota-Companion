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

#import <objc/runtime.h>

#define kMainCardWidth 0.7
#define kMainCardHeight 0.7
#define kSideCardWidth 0.6
#define kSideCardHeight 0.6
#define kCardPadding 10.0
#define kNumCards 5

@interface ELUHeroesCardView ()

@property NSInteger currentHero;
@property (strong, nonatomic) NSMutableArray *cardViews;

@property double timeWhenTouchBegan;
@property CGPoint locationWhenTouchBegan;
@property CGPoint *centersWhenTouchBegan;
@property BOOL subviewsLaidOut;

@end

@implementation ELUHeroesCardView

- (CGSize) mainCardSize {
    return CGSizeMake(kMainCardWidth * self.bounds.size.width, kMainCardHeight * self.bounds.size.height);
}

- (CGSize) sideCardSize {
    return CGSizeMake(kSideCardWidth * self.bounds.size.width, kSideCardHeight * self.bounds.size.height);
}

- (CGAffineTransform) transformForCardAt:(NSInteger)index {
    if(index != 2) {
        return CGAffineTransformMakeScale(kSideCardWidth, kSideCardHeight);
    } else {
        return CGAffineTransformMakeScale(kMainCardWidth, kMainCardHeight);
    }
}

- (CGPoint) centerForCardAt:(NSInteger)index {
    switch(index) {
        case 0:
            return CGPointMake(self.bounds.size.width / 2.0 - self.mainCardSize.width / 2.0 - self.sideCardSize.width / 2.0 - self.sideCardSize.width - 2 * kCardPadding, self.bounds.size.height/2.0);
        case 1:
            return CGPointMake(self.bounds.size.width / 2.0 - self.mainCardSize.width / 2.0 - self.sideCardSize.width / 2.0 - kCardPadding, self.bounds.size.height/2.0);
        case 2:
            return CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
        case 3:
            return CGPointMake(self.bounds.size.width / 2.0 + self.mainCardSize.width / 2.0 + self.sideCardSize.width / 2.0 + kCardPadding, self.bounds.size.height/2.0);
        case 4:
            return CGPointMake(self.bounds.size.width / 2.0 + self.mainCardSize.width / 2.0 + self.sideCardSize.width / 2.0 + self.sideCardSize.width + 2 * kCardPadding, self.bounds.size.height/2.0);
        default:
            return CGPointMake(0,0);
    }
}

- (id)initWithFrame:(CGRect)frame delegate:(id<ELUHeroDelegate>) delegate;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.subviewsLaidOut = NO;
        self.backgroundColor = [ELUConstants sharedInstance].darkBackColor;
        self.heroDelegate = delegate;
        
        self.currentHero = 0;
        
        self.userInteractionEnabled = YES;
        
        self.centersWhenTouchBegan = malloc(sizeof(CGPoint)*kNumCards);
        NSMutableArray *cardViews = [NSMutableArray arrayWithCapacity:kNumCards];
        
        for(int i = 0; i < kNumCards; i++) {
            ELUCardView *cardView = [[ELUCardView alloc] initWithFrame:self.bounds];
            UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)];
            gestureRecognizer.numberOfTapsRequired = 1;
            [cardView addGestureRecognizer:gestureRecognizer];
            
            if(i > 1) {
                [self activateCardView:cardView heroAtIndex:i-2];
            } else {
                [self disableCardView:cardView];
            }
            
            [cardViews addObject:cardView];
        }
            
        self.cardViews = cardViews;
                  
        [self addSubview:self.cardViews[0]];
        [self addSubview:self.cardViews[4]];
        [self addSubview:self.cardViews[1]];
        [self addSubview:self.cardViews[3]];
        [self addSubview:self.cardViews[2]];
    }
    return self;
}

- (void) dealloc {
    free(self.centersWhenTouchBegan);
}

- (void) resetCards {
    for (int i = 0; i < self.cardViews.count; i++) {
        ELUCardView *cardView = self.cardViews[i];
        cardView.transform = [self transformForCardAt:i];
        cardView.center = [self centerForCardAt:i];
    }
    [self bringSubviewToFront:self.cardViews[0]];
    [self bringSubviewToFront:self.cardViews[4]];
    [self bringSubviewToFront:self.cardViews[1]];
    [self bringSubviewToFront:self.cardViews[3]];
    [self bringSubviewToFront:self.cardViews[2]];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    if(!self.subviewsLaidOut) {
        [self resetCards];
        self.subviewsLaidOut = YES;
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.timeWhenTouchBegan = CACurrentMediaTime();
    
    UITouch *touch = [touches anyObject];
    self.locationWhenTouchBegan = [touch locationInView:self];
    
    for(int i = 0; i < self.cardViews.count; i++) {
        self.centersWhenTouchBegan[i] = ((ELUCardView*)self.cardViews[i]).center;
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGFloat relX = self.locationWhenTouchBegan.x - location.x;
    [self setMainCardCenter:relX];
    [self checkCardOutOfBounds];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}

- (void) checkCardOutOfBounds {
    BOOL moveCards = NO;
    BOOL right = NO;
    
    ELUCardView *cardView = self.cardViews[2];
    if(cardView.frame.origin.x < - self.mainCardSize.width / 2.0) {
        right = NO;
        moveCards = YES;
        self.locationWhenTouchBegan = CGPointMake(self.locationWhenTouchBegan.x - ((ELUCardView*)self.cardViews[2]).frame.size.width, self.locationWhenTouchBegan.y);
    } else if(cardView.frame.origin.x + cardView.frame.size.width > self.bounds.size.width + self.mainCardSize.width / 2.0) {
        right = YES;
        moveCards = YES;
        self.locationWhenTouchBegan = CGPointMake(self.locationWhenTouchBegan.x + ((ELUCardView*)self.cardViews[2]).frame.size.width, self.locationWhenTouchBegan.y);
    }
    if(moveCards && right && self.currentHero > 0) {
        //Previous hero
        self.currentHero--;
        
        ELUCardView *tempCardView = self.cardViews[4];
        for (int i = 3; i >= 0; i--) {
            ELUCardView *cardView = self.cardViews[i];
            self.cardViews[i+1] = cardView;
        }
        
        ELUCardView *prevCardView = self.cardViews[1];
        tempCardView.center = CGPointMake(prevCardView.frame.origin.x - kCardPadding - tempCardView.frame.size.width / 2.0, self.bounds.size.height / 2.0);
        if(self.currentHero - 2 >= 0) {
            [self activateCardView:tempCardView heroAtIndex:self.currentHero-2];
        } else {
            [self disableCardView:tempCardView];
        }
        self.cardViews[0] = tempCardView;
    }
    if(moveCards && !right && self.currentHero < self.heroDelegate.heroCount-1) {
        //Next hero
        self.currentHero++;
        
        ELUCardView *tempCardView = self.cardViews[0];
        for (int i = 1; i < self.cardViews.count; i++) {
            ELUCardView *cardView = self.cardViews[i];
            self.cardViews[i-1] = cardView;
        }
        
        ELUCardView *prevCardView = self.cardViews[3];
        tempCardView.center = CGPointMake(prevCardView.frame.origin.x + prevCardView.frame.size.width + kCardPadding + tempCardView.frame.size.width / 2.0, self.bounds.size.height / 2.0);
        if(self.currentHero + 2 < [self.heroDelegate heroCount]) {
            [self activateCardView:tempCardView heroAtIndex:self.currentHero+2];
        } else {
            [self disableCardView:tempCardView];
        }
        
        self.cardViews[4] = tempCardView;
    }
    
    [(UIView*)self.cardViews[2] setUserInteractionEnabled:YES];
    [self bringSubviewToFront:self.cardViews[0]];
    [self bringSubviewToFront:self.cardViews[4]];
    [self bringSubviewToFront:self.cardViews[1]];
    [self bringSubviewToFront:self.cardViews[3]];
    [self bringSubviewToFront:self.cardViews[2]];
}

- (void) disableCardView:(ELUCardView*) cardView {
    cardView.hidden = YES;
    cardView.userInteractionEnabled = NO;
}

- (void) activateCardView:(ELUCardView*) cardView heroAtIndex:(NSUInteger)index {
    ELUHero *hero = [self.heroDelegate heroForIndex:index];
    cardView.hidden = NO;
    cardView.userInteractionEnabled = YES;
    objc_setAssociatedObject(cardView, @"hero", hero, OBJC_ASSOCIATION_ASSIGN);
    [cardView setupWithHero:hero];
    
}

- (void) setMainCardCenter: (CGFloat)delta {
    //Interpolate between where the center should be and where it was
    for(int i = 0; i < self.cardViews.count; i++) {
        ELUCardView *cardView = self.cardViews[i];
        CGFloat distance = self.centersWhenTouchBegan[i].x - self.bounds.size.width / 2.0 - delta;
        CGFloat totalDistance = self.bounds.size.width / 2.0 - [self centerForCardAt:1].x;
        CGFloat ratio = MIN(1.0, (distance * distance) / (totalDistance * totalDistance));
        //Interpolate the size of the image
        CGFloat width = kMainCardWidth - (kMainCardWidth - kSideCardWidth) * ratio;
        CGFloat height = kMainCardWidth - (kMainCardHeight - kSideCardHeight) * ratio;
        //Make the card this size
        cardView.transform = CGAffineTransformMakeScale(width, height);
        cardView.center = CGPointMake(self.centersWhenTouchBegan[i].x - delta, self.bounds.size.height/2.0);
    }
}

- (void) cardTapped:(UITapGestureRecognizer*)gestureRecognizer {
    ELUCardView *cardView = (ELUCardView*)gestureRecognizer.view;
    ELUHero *hero = (ELUHero*)objc_getAssociatedObject(cardView, @"hero");
    [self.heroDelegate heroTapped:hero];
}

@end
