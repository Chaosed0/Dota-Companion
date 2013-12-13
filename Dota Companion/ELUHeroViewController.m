//
//  ELUHeroViewController.m
//  Dota Companion
//
//  Created by EDWARD LU on 12/6/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

#import "ELUHeroViewController.h"
#import "ELUHero.h"
#import "ELUHeroAbility.h"
#import "ELUAbilityViewController.h"
#import "AsyncImageView.h"

#import <objc/runtime.h>

#define kPadding 5.0

#define kAbilityImagePadding 15.0

@interface ELUHeroViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *abilityScrollView;
@property (weak, nonatomic) IBOutlet AsyncImageView *heroImageView;
- (IBAction)backPressed:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextView *heroBioTextView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (strong, nonatomic) ELUHeroAbility *segueAbility;
@property (strong, nonatomic) UINavigationItem *titleItem;

@end

@implementation ELUHeroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [ELUConstants sharedInstance].darkBackColor;
    [self fillScrollView];
    self.title = self.hero.name;
    self.heroImageView.imageURL = self.hero.imageUrlLarge;
    self.heroBioTextView.text = self.hero.bio;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)fillScrollView {
    float scrollViewHeight = self.abilityScrollView.bounds.size.height;
    NSInteger curX = 0;
    
    for(int i = 0; i < self.hero.abilities.count; i++) {
        AsyncImageView *imageView = [[AsyncImageView alloc] init];
        ELUHeroAbility *ability = self.hero.abilities[i];
        //Let's just assume that all of these images are squares
        imageView.frame = CGRectMake(curX, 0, scrollViewHeight, scrollViewHeight);
        imageView.imageURL = ability.imageUrlSmall;
        
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(abilityTapped:)];
        gestureRecognizer.numberOfTapsRequired = 1;
        objc_setAssociatedObject(gestureRecognizer, @"ability", ability, OBJC_ASSOCIATION_ASSIGN);
        [imageView addGestureRecognizer:gestureRecognizer];
        [imageView setUserInteractionEnabled:YES];
        
        [self.abilityScrollView addSubview:imageView];
        curX += scrollViewHeight + kAbilityImagePadding;
    }
    
    self.abilityScrollView.contentSize = CGSizeMake(curX - kAbilityImagePadding, scrollViewHeight);
}

- (void)abilityTapped:(UITapGestureRecognizer*)gestureRecognizer {
    self.segueAbility = objc_getAssociatedObject(gestureRecognizer, @"ability");
    [self performSegueWithIdentifier:@"HeroAbilitySegue" sender:self];
}

-(void)viewWillAppear:(BOOL)animated {
    [self checkOrientation:self.interfaceOrientation];
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self checkOrientation:toInterfaceOrientation];
}

- (void)checkOrientation:(UIInterfaceOrientation)orientation {
    CGSize frameSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    NSInteger toolbarHeight = self.toolbar.frame.size.height;
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        NSInteger xPosition = self.heroImageView.frame.origin.x + self.heroImageView.frame.size.width + kPadding;
        self.heroBioTextView.frame = CGRectMake(xPosition, kPadding, frameSize.width - xPosition - kPadding*2, frameSize.height - toolbarHeight - kPadding*2);
    } else if(UIInterfaceOrientationIsPortrait(orientation)) {
        NSInteger yPosition = self.abilityScrollView.frame.origin.y + self.abilityScrollView.frame.size.height + kPadding;
        self.heroBioTextView.frame = CGRectMake(kPadding, yPosition, frameSize.width - kPadding * 2, frameSize.height - yPosition - kPadding*2 - toolbarHeight);
    }
}

- (void)backPressed:(UIBarButtonItem *)sender {
    self.onCompletion();
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"HeroAbilitySegue"]) {
        ELUAbilityViewController *viewController = segue.destinationViewController;
        viewController.ability = self.segueAbility;
    }
}
@end
