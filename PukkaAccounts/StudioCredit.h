//
//  StudioCredit.h
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 26/03/2012.
//  Copyright (c) 2012 DJCAD, Dundee University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudioCredit : NSObject
@property (assign) IBOutlet NSTextField *descriptionTextField;
@property (assign) IBOutlet NSTextField *amountTextField;

@property (nonatomic, retain) NSString * creditDescription;
@property (nonatomic, retain) NSDecimalNumber * creditAmount;


@end
