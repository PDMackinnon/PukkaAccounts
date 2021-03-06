//
//  StudioCredit.h
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 26/03/2012.
//  Copyright (c) 2012 DJCAD, Dundee University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudioCredit : NSObject
@property (strong) IBOutlet NSTextField *descriptionTextField;
@property (strong) IBOutlet NSTextField *amountTextField;

@property (nonatomic, strong) NSString * creditDescription;
@property (nonatomic, strong) NSDecimalNumber * creditAmount;


@end
