
//
//  ConditionController.m
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/ConditionController.h>

@implementation ConditionController

- (id) initWithTarget:(id)anObject {
	
	if ( self = [super init] ) {
	
		//[NSBundle loadNibNamed:@"Condition" owner:self];
		
		target = anObject;
		tag = 0;
		
		_sendsLiveUpdate = YES;
		_allowsEmptyCondition = NO;
		_autogeneratesDynamicDates = NO;
	}
	
	return self;
}

- (void) dealloc {
	
	[conditionView release];
		conditionView = nil;
	
	[super dealloc];
	
}

- (void) awakeFromNib 
{	

}

#pragma mark -

- (NSView*) conditionView 
{ 
	return conditionView; 
}

#pragma mark -

- (int) tag 
{ 
	return tag; 
}

- (void) setTag:(int)newTag 
{
	tag = newTag;
}

- (id) target
{
	return target;
}

- (void) setTarget:(id)anObject
{
	target = anObject;
}

- (BOOL) sendsLiveUpdate 
{ 
	return _sendsLiveUpdate; 
}

- (void) setSendsLiveUpdate:(BOOL)updates 
{
	_sendsLiveUpdate = updates;
}

- (BOOL) autogeneratesDynamicDates
{
	return _autogeneratesDynamicDates;
}

- (void) setAutogeneratesDynamicDates:(BOOL)autogenerate
{
	_autogeneratesDynamicDates = autogenerate;
}

- (BOOL) allowsEmptyCondition
{
	return _allowsEmptyCondition;
}

- (void) setAllowsEmptyCondition:(BOOL)allowsEmpty
{
	_allowsEmptyCondition = allowsEmpty;
}

- (BOOL) removeButtonEnabled
{
	return [removeButton isEnabled];
}

- (void) setRemoveButtonEnabled:(BOOL)enabled
{
	[removeButton setEnabled:enabled];
}

#pragma mark -

- (void)controlTextDidChange:(NSNotification *)aNotification 
{
	[self _sendUpdateIfRequested];
}

- (IBAction) changeCondition:(id)sender 
{
	[self _sendUpdateIfRequested];
}

- (void) _sendUpdateIfRequested 
{
	if ( [self sendsLiveUpdate] && [target respondsToSelector:@selector(conditionDidChange:)] )
		[target conditionDidChange:self];
}

#pragma mark -

- (void) setInitialPredicate:(NSPredicate*)aPredicate
{
	//
	// used to reproduce the saved condition
	[self setInitialCondition:[aPredicate predicateFormat]];
}

- (void) setInitialCondition:(NSString*)condition 
{
	
	//
	// used to reproduce the saved condition
	
}

- (NSPredicate*) predicate
{
	//
	// derive a predicate from the specified condition
	NSString *predicateString = [self predicateString];
	return ( predicateString != nil ? [NSPredicate predicateWithFormat:predicateString] : nil );
}

- (NSString*) predicateString {
	
	//
	// build the predicate string from our current conditions
	return nil;
}

#pragma mark -

- (IBAction)addCondition:(id)sender
{
	if ( [target respondsToSelector:@selector(addCondition:)] )
		[target performSelector:@selector(addCondition:) withObject:self];
	//[self _sendUpdateIfRequested];
}

- (IBAction)removeCondition:(id)sender
{
	if ( [target respondsToSelector:@selector(removeCondition:)] )
		[target performSelector:@selector(removeCondition:) withObject:self];
	//[self _sendUpdateIfRequested];
}

- (IBAction)changeConditionKey:(id)sender
{
	//
	// remove and add superviews as needed
	[self _sendUpdateIfRequested];	
}

- (id) selectableView 
{	
	//
	// return the a responder that may become first responder
	return nil;
}

- (void) appropriateFirstResponder:(NSWindow*)aWindow
{
	// should depend on the condition 
}

- (void) removeFromSuper 
{
	[conditionView removeFromSuperviewWithoutNeedingDisplay];
}

#pragma mark -

- (NSString*) _spotlightConditionStringWithAttribute:(NSString*)anAttribute condition:(NSString*)aCondition operation:(int)anOperation
{
	// handy utility method for creating text based spotlight conditions
	
	NSString *predicateString = nil;
	NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
	
	if ( [aCondition length] == 0 )
	{
		if ( _allowsEmptyCondition == NO )
			return nil;
		else if ( anOperation == PDConditionNotContains )
			predicateString = [NSString stringWithFormat:@"%@ != \"%@\"", anAttribute, @"^"];
		else
			predicateString = [NSString stringWithFormat:@"%@ == %@", anAttribute, @"^"];
	}
	
	else if ( [aCondition rangeOfCharacterFromSet:charSet].location != NSNotFound )
		return nil;
	
	switch ( anOperation ) 
	{
	
	case PDConditionContains:
		predicateString = [NSString stringWithFormat:@"%@ like[cd] \"*%@*\"", anAttribute, aCondition];
		break;
	
	case PDConditionNotContains:
		predicateString = [NSString stringWithFormat: @"not %@ like[cd] \"*%@*\"", anAttribute, aCondition];
		break;
	
	case PDConditionBeginsWith:
		predicateString = [NSString stringWithFormat:@"%@ like[cd] \"%@*\"", anAttribute, aCondition];
		break;
	
	case PDConditionEndsWith:
		predicateString = [NSString stringWithFormat:@"%@ like[cd] \"*%@\"", anAttribute, aCondition];
		break;
	
	case PDConditionIs:
		//predicateString = [NSString stringWithFormat:@"%@ ==[cd] \"%@\"", anAttribute, aCondition];
		predicateString = [NSString stringWithFormat:@"%@ like[cd] \"%@\"", anAttribute, aCondition];
		break;
		
	}
	
	return predicateString;
}

- (NSString*) _spotlightConditionStringWithAttributes:(NSArray*)theAttributes condition:(NSString*)aCondition operation:(int)anOperation
{
	NSMutableArray *theStrings = [NSMutableArray array];
	
	NSString *predicateString = nil;
	NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
	
	NSString *anAttribute;
	NSEnumerator *enumerator = [theAttributes objectEnumerator];
	
	while ( anAttribute = [enumerator nextObject] )
	{
		NSString *aPredicateString = nil;
		
		if ( [aCondition length] == 0 )
		{
			if ( _allowsEmptyCondition == NO )
				return nil;
			else if ( anOperation == PDConditionNotContains )
				aPredicateString = [NSString stringWithFormat:@"%@ != \"%@\"", anAttribute, @"^"];
			else
				aPredicateString = [NSString stringWithFormat:@"%@ == %@", anAttribute, @"^"];
		}
		
		else if ( [aCondition rangeOfCharacterFromSet:charSet].location != NSNotFound )
			return nil;
		
		switch ( anOperation ) 
		{
		
		case PDConditionContains:
			aPredicateString = [NSString stringWithFormat:@"%@ like[cd] \"*%@*\"", anAttribute, aCondition];
			break;
		
		case PDConditionNotContains:
			aPredicateString = [NSString stringWithFormat: @"not %@ like[cd] \"*%@*\"", anAttribute, aCondition];
			break;
		
		case PDConditionBeginsWith:
			aPredicateString = [NSString stringWithFormat:@"%@ like[cd] \"%@*\"", anAttribute, aCondition];
			break;
		
		case PDConditionEndsWith:
			aPredicateString = [NSString stringWithFormat:@"%@ like[cd] \"*%@\"", anAttribute, aCondition];
			break;
		
		case PDConditionIs:
			//aPredicateString = [NSString stringWithFormat:@"%@ ==[cd] \"%@\"", anAttribute, aCondition];
			aPredicateString = [NSString stringWithFormat:@"%@ like[cd] \"%@\"", anAttribute, aCondition];
			break;
			
		}
		
		if ( aPredicateString != nil )
			[theStrings addObject:aPredicateString];
	
	}
	
	// put them all together
	if ( [aCondition length] == 0 )
		predicateString = [theStrings componentsJoinedByString:@" && "];
	else if ( anOperation == PDConditionNotContains )
		predicateString = [theStrings componentsJoinedByString:@" && "];
	else
		predicateString = [theStrings componentsJoinedByString:@" || "];
	
	return predicateString;

}

- (BOOL) validatePredicate
{
	NSLog(@"%@ %s - subclasses must override to validate their own predicate formats", [self className], _cmd);
	return NO;
}

/*
if ( [[stringConditionValue stringValue] length] == 0 )
{
	if ( _allowsEmptyCondition == NO )
		return nil;
	else if ( [[stringOperationPop selectedItem] tag] == PDConditionNotContains )
		predicateString = [NSString stringWithFormat:
		@"kMDItemAuthorEmailAddresses != \"%@\" && kMDItemAuthors != \"%@\"", @"^", @"^"];
	else
		predicateString = [NSString stringWithFormat:
		@"kMDItemAuthorEmailAddresses == %@ && kMDItemAuthors == %@", @"^", @"^"];
}

else if ( [[stringConditionValue stringValue] rangeOfCharacterFromSet:charSet].location != NSNotFound )
	return nil;

switch ( [[stringOperationPop selectedItem] tag] ) 
{

case PDConditionContains:
	predicateString = [NSString stringWithFormat:
	@"kMDItemAuthorEmailAddresses like[cd] \"*%@*\" || kMDItemAuthors like[cd] \"*%@*\"",
	[stringConditionValue stringValue], [stringConditionValue stringValue]];
	break;

case PDConditionNotContains:
	predicateString = [NSString stringWithFormat:
	@"not kMDItemAuthorEmailAddresses like[cd] \"*%@*\" && not kMDItemAuthors like[cd] \"*%@*\"",
	[stringConditionValue stringValue], [stringConditionValue stringValue]];
	break;

case PDConditionBeginsWith:
	predicateString = [NSString stringWithFormat:
	@"kMDItemAuthorEmailAddresses like[cd] \"%@*\" || kMDItemAuthors like[cd] \"%@*\"",
	[stringConditionValue stringValue], [stringConditionValue stringValue]];
	break;

case PDConditionEndsWith:
	predicateString = [NSString stringWithFormat:
	@"kMDItemAuthorEmailAddresses like[cd] \"*%@\" || kMDItemAuthors like[cd] \"*%@\"",
	[stringConditionValue stringValue], [stringConditionValue stringValue]];
	break;

case PDConditionIs:
	predicateString = [NSString stringWithFormat:
	@"kMDItemAuthorEmailAddresses ==[cd] \"%@\" || kMDItemAuthors ==[cd] \"%@\"",
	[stringConditionValue stringValue], [stringConditionValue stringValue]];
	break;
	
}
		*/

@end
