//
//  User.m
//  PukkaAccounts
//
//  Created by Paul Mackinnon on 10/10/2011.
//  Copyright (c) 2011 DJCAD, Dundee University. All rights reserved.
//

#import "User.h"
#import "Transaction.h"


@implementation User
@dynamic currentYearofStudy;
@dynamic userName;
@dynamic emailAddress;
@dynamic matricNumber;
@dynamic fullName;
@dynamic subjectOfStudy;
@dynamic transactions;

- (void)addTransactionsObject:(Transaction *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"transactions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"transactions"] addObject:value];
    [self didChangeValueForKey:@"transactions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeTransactionsObject:(Transaction *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"transactions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"transactions"] removeObject:value];
    [self didChangeValueForKey:@"transactions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addTransactions:(NSSet *)value {    
    [self willChangeValueForKey:@"transactions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"transactions"] unionSet:value];
    [self didChangeValueForKey:@"transactions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeTransactions:(NSSet *)value {
    [self willChangeValueForKey:@"transactions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"transactions"] minusSet:value];
    [self didChangeValueForKey:@"transactions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
