//
//  ELUViewController.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/3/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUHeroesCardViewController.h"
#import "ELUHeroViewController.h"
#import "ELUHeroesTableViewController.h"
#import "ELUHeroesModel.h"
#import "ELUCardView.h"

#import <QuartzCore/QuartzCore.h>

#define kMainCardWidth 0.7
#define kMainCardHeight 0.7
#define kSideCardWidth 0.6
#define kSideCardHeight 0.6
#define kSideCardPadding -50

@interface ELUHeroesCardViewController ()
@property(strong, nonatomic) ELUHeroesModel *heroesModel;

@property (strong, nonatomic) NSMutableArray *cardViews;

@property NSUInteger currentHero;
@property NSInteger curCard;

- (IBAction)playButtonPressed:(UIBarButtonItem *)sender;

@end

@implementation ELUHeroesCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [ELUConstants sharedInstance].darkBackColor;
    
    self.currentHero = 0;
    self.heroesModel = [ELUHeroesModel sharedInstance];
    
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeGesture:)];
    [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeftRecognizer];
    
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeGesture:)];
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRightRecognizer];
    
    self.view.userInteractionEnabled = YES;
    
    self.cardViews = [NSMutableArray arrayWithCapacity:5];
    
    for(int i = 0; i < 5; i++) {
        ELUCardView *cardView = [[ELUCardView alloc] initWithFrame:self.view.bounds];
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped)];
        gestureRecognizer.numberOfTapsRequired = 1;
        [cardView addGestureRecognizer:gestureRecognizer];
        cardView.userInteractionEnabled = NO;
        
        if(i > 1) {
            [cardView setupWithHero:[self.heroesModel heroAtIndex:i-2]];
            if(i == 2) {
                cardView.userInteractionEnabled = YES;
            }
        }
        
        [self.cardViews addObject:cardView];
    }
    
    [self.view addSubview:self.cardViews[0]];
    [self.view addSubview:self.cardViews[4]];
    [self.view addSubview:self.cardViews[1]];
    [self.view addSubview:self.cardViews[3]];
    [self.view addSubview:self.cardViews[2]];
    
    {
        ELUCardView *cardView = self.cardViews[0];
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(kSideCardWidth, kSideCardHeight);
        cardView.transform = scaleTransform;
        cardView.center = CGPointMake(-cardView.frame.size.width/2.0, self.view.bounds.size.height/2.0);
        cardView.alpha = 0.0;
    }
    
    {
        ELUCardView *cardView = self.cardViews[1];
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(kSideCardWidth, kSideCardHeight);
        cardView.transform = scaleTransform;
        cardView.center = CGPointMake(kSideCardPadding, self.view.bounds.size.height/2.0);
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
        cardView.center = CGPointMake(self.view.bounds.size.width - kSideCardPadding, self.view.bounds.size.height/2.0);
    }
    
    {
        ELUCardView *cardView = self.cardViews[4];
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(kSideCardWidth, kSideCardHeight);;
        cardView.transform = scaleTransform;
        cardView.center = CGPointMake(self.view.bounds.size.width + cardView.frame.size.width/2.0, self.view.bounds.size.height/2.0);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkOrientation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)checkOrientation {
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
        [self.navigationController popViewControllerAnimated:NO];
        [self.navigationController pushViewController:[[ELUHeroesTableViewController alloc] initWithNibName:<#(NSString *)#> bundle:<#(NSBundle *)#>] animated:NO]
        [self performSegueWithIdentifier:@"OrientationChangeSegue" sender:self];
    }
}

- (IBAction)playButtonPressed:(UIBarButtonItem *)sender {
    [self changeCards:NO];
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
            
            if((int)self.currentHero - 1 + i < 0 || (int)self.currentHero - 1 + i >= self.heroesModel.count) {
                cardView.alpha = 0.0;
            } else {
                cardView.alpha = 1.0;
            }
        }
        
        tempCardView.transform = tempTransform;
        tempCardView.frame = tempFrame;
        self.cardViews[0] = tempCardView;
        [self.cardViews[0] setupWithHero:[self.heroesModel heroAtIndex:self.currentHero-2]];
    } else if(right) {
        //Do a bounce animation
    }
    if(!right && self.currentHero < self.heroesModel.count-1) {
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
            
            if((int)self.currentHero - 3 + i < 0 || (int)self.currentHero - 3 + i >= self.heroesModel.count) {
                cardView.alpha = 0.0;
            } else {
                cardView.alpha = 1.0;
            }
        }
        
        tempCardView.transform = tempTransform;
        tempCardView.frame = tempFrame;
        self.cardViews[4] = tempCardView;
        [self.cardViews[4] setupWithHero:[self.heroesModel heroAtIndex:self.currentHero+2]];
    } else if(!right) {
        //Do a bounce animation
    }
           
    [(UIView*)self.cardViews[2] setUserInteractionEnabled:YES];
    [self.view bringSubviewToFront:self.cardViews[0]];
    [self.view bringSubviewToFront:self.cardViews[4]];
    [self.view bringSubviewToFront:self.cardViews[1]];
    [self.view bringSubviewToFront:self.cardViews[3]];
    [self.view bringSubviewToFront:self.cardViews[2]];
}

- (void) onSwipeGesture: (UISwipeGestureRecognizer*) gestureRecognizer {
    BOOL right = gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight;
    [self changeCards:right];
}

- (void) cardTapped {
    [self performSegueWithIdentifier:@"PortraitHeroSegue" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueId = segue.identifier;
    if([segueId isEqualToString:@"PortraitHeroSegue"]) {
        UINavigationController *navViewController = segue.destinationViewController;
        ELUHeroViewController *viewController = navViewController.viewControllers[0];
        viewController.hero = [self.heroesModel heroAtIndex:self.currentHero];
        viewController.onCompletion = ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
}
@end
