//
//  CurrentSaleState.h
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 27/10/2011.
//  Copyright 2011 DJCAD, Dundee University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CurrentSaleState : NSObject {
@private
    
    NSTextField *newBalanceDisplay;
    NSArrayController *allTransactions;
    NSTextField *priceEach;
    NSImageCell *greenImageCell;
    NSImageCell *redImageCell;
}
@property (assign) IBOutlet NSTextField *newBalanceDisplay;
@property (assign) IBOutlet NSArrayController *allTransactions;
@property (assign) IBOutlet NSTextField *priceEach;


@property (readonly) NSImage * processSaleButtonImage;  //calculated value
@property (readonly) NSColor * newBalanceDisplayColor;  //calculated value

@property (assign) IBOutlet NSImageCell *greenImageCell;
@property (assign) IBOutlet NSImageCell *redImageCell;


@end
