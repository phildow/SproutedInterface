//
//  PDPredicateBuilder.h
//  SproutedInterface
//
//  Created by Philip Dow on 4/10/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//
//	And the .m?

@protocol PDPredicateBuilder

- (NSCompoundPredicateType) compoundPredicateType;
- (void) setCompoundPredicateType:(NSCompoundPredicateType)predicateType;

- (NSPredicate*) predicate;
- (void) setPredicate:(NSPredicate*)aPredicate;

- (id) delegate;
- (void) setDelegate:(id)anObject;

- (NSView*) contentView;

- (NSSize) requiredSize;
- (void) setMinWidth:(float)width;

- (BOOL) validatePredicate;

@end

@interface NSObject (PDPredicateBuilderDelegate)

- (void) predicateBuilder:(id)aPredicateBuilder predicateDidChange:(NSPredicate*)newPredicate;
- (void) predicateBuilder:(id)aPredicateBuilder sizeDidChange:(NSSize)newSize;

@end