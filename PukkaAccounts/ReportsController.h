//
//  ReportsController.h
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 06/06/2012.
//  Copyright (c) 2012 Dundee University. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <Foundation/Foundation.h>

#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"


#import "DataManager.h"
#import "User.h"
#import "Transaction.h"



@interface ReportsController : NSArrayController

- (IBAction)exportReportJSON:(id)sender;

@end
