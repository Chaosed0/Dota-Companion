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
#import "AsyncImageView.h"

#define kPadding 5.0

@interface ELUHeroViewController ()
@property (weak, nonatomic) IBOutlet UILabel *heroNameLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *abilityImageViews;
@property (weak, nonatomic) IBOutlet AsyncImageView *heroImageView;
- (IBAction)backPressed:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextView *heroBioTextView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation ELUHeroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.heroNameLabel.text = self.hero.name;
    self.heroImageView.imageURL = self.hero.imageUrlLarge;
    for(int i = 0; i < self.abilityImageViews.count; i++) {
        AsyncImageView *imageView = self.abilityImageViews[i];
        ELUHeroAbility *ability = self.hero.abilities[i];
        imageView.imageURL = ability.imageUrlSmall;
    }
    self.heroBioTextView.text = self.hero.bio;
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSInteger toolbarHeight = self.toolbar.frame.size.height;
    if(UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
        NSInteger xPosition = self.heroImageView.frame.origin.x + self.heroImageView.frame.size.width + kPadding;
        self.heroBioTextView.frame = CGRectMake(xPosition, kPadding, self.view.frame.size.height - xPosition - kPadding*2, self.view.frame.size.width - toolbarHeight - kPadding*2);
    } else if(UIDeviceOrientationIsPortrait(toInterfaceOrientation)) {
        AsyncImageView *abilityView = (AsyncImageView*)self.abilityImageViews[0];
        NSInteger yPosition = abilityView.frame.origin.y + abilityView.frame.size.height + kPadding;
        self.heroBioTextView.frame = CGRectMake(kPadding, yPosition, self.view.frame.size.width - kPadding * 2, self.view.frame.size.height - yPosition - kPadding*2 - toolbarHeight);
    }
}

- (IBAction)backPressed:(UIBarButtonItem *)sender {
    self.onCompletion();
}
@end
