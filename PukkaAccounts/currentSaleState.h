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
    
    NSTextField *__strong currentBalanceDisplay;
    NSArrayController *__strong allTransactions;
    NSTextField *__strong priceEach;
    NSImageCell *__strong greenImageCell;
    NSImageCell *__strong redImageCell;
}
@property (strong) IBOutlet NSTextField *currentBalanceDisplay;
@property (strong) IBOutlet NSArrayController *allTransactions;
@property (strong) IBOutlet NSTextField *priceEach;


@property (readonly) NSImage * processSaleButtonImage;  //calculated value
@property (readonly) NSColor * newBalanceDisplayColor;  //calculated value

@property (strong) IBOutlet NSImageCell *greenImageCell;
@property (strong) IBOutlet NSImageCell *redImageCell;


@end
