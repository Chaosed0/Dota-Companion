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

@interface ELUHeroViewController ()
@property (weak, nonatomic) IBOutlet UILabel *heroNameLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *abilityImageViews;
@property (weak, nonatomic) IBOutlet AsyncImageView *heroImageView;
- (IBAction)backPressed:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextView *heroBioTextView;

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

- (IBAction)backPressed:(UIBarButtonItem *)sender {
    self.onCompletion();
}
@end
