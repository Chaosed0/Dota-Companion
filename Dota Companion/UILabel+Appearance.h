//
//  UILabel+Appearance.h
//  Dota Companion
//
//  Created by EDWARD LU on 12/10/13.
//  Copyright (c) 2013 EDWARD LU. All rights reserved.
//

//This category gets around the fact that UILabel has no methods marked
// with UI_APPEARANCE_SELECTOR.

#import <UIKit/UIKit.h>

@interface UILabel (Appearance)

-(void)setTextColorAppearance:(UIColor *)textColor UI_APPEARANCE_SELECTOR;
-(void)setBackgroundColorAppearance:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;

@end
