//
//  DocumentMakerController.m
//  SproutedInterface
//
//  Created by Philip Dow on 9/28/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/DocumentMakerController.h>


@implementation DocumentMakerController

- (id) init 
{
	return [self initWithOwner:nil managedObjectContext:nil];
}

- (id) initWithOwner:(id)anObject managedObjectContext:(NSManagedObjectContext*)moc
{
	if ( self = [super init] )
	{
		// subclasses should call super's implementation
		[self setDelegate:anObject];
		[self setManagedObjectContext:moc];
	}
	return self;
}

- (void) dealloc
{	
	// local variables
	[representedObject release];
	[managedObjectContext release];
	
	[super dealloc];
}

#pragma mark -

- (int) numberOfViews
{
	NSLog(@"%@ %s - **** subclasses must override ****", [self className], _cmd);
	return 0;

	// subclasses must override and return the number of views/steps
	// invovled in creating this particular kind of document
}

- (NSView*) contentViewAtIndex:(int)index
{
	// subclasses should override and return the content view for the given index
	// this allows subclasses to walk the user through
	// the custom creation of a document however they see fit.
	// the index is 1 based. 0 is where the user choose the kind of 
	// document they want to create.
	
	NSLog(@"%@ %s - **** subclasses must override ****", [self className], _cmd);
	return nil;
}

- (void) willSelectViewAtIndex:(int)index
{
	// subclasses may override to perform setup
	// before the view at index is display
	// index is 1 based
	
	return;
}

- (void) didSelectViewAtIndex:(int)index
{
	// subclasses may override to perform postprocessing
	// for example setting the new first responder,
	// which is recommended.
	// index is 1 based
	
	return;
}

- (NSString*) titleOfViewAtIndex:(int)index
{
	// subclasses must override to provide a localized 
	// description for the name of the view at index.
	// index is one based.
	
	NSLog(@"%@ %s - **** subclasses must override ****", [self className], _cmd);
	return [NSString string];
}

- (id) delegate 
{ 
	return delegate; 
}

- (void) setDelegate:(id)anObject 
{
	delegate = anObject;
}

- (NSManagedObjectContext*) managedObjectContext
{
	return managedObjectContext;
}

- (void) setManagedObjectContext:(NSManagedObjectContext*)moc
{
	if ( managedObjectContext != moc )
	{
		[managedObjectContext release];
		managedObjectContext = [moc retain];
	}
}

- (id) representedObject
{
	return representedObject;
}

- (void) setRepresentedObject:(id)anObject
{
	if ( representedObject != anObject )
	{
		[representedObject release];
		representedObject = [anObject retain];
	}
}

#pragma mark -

- (NSArray*) documentDictionaries:(NSError**)error
{
	NSLog(@"%@ %s - **** subclasses must override ****", [self className], _cmd);
	return nil;
	
	// return an array of dictionaries describing how the pasteboard data
	// should be handled by Lex. each dictionary should include
	//	1. kSproutedAppHelperURL -> NSURL, uniformly and uniquely indicating the data
	//	2. kSproutedAppHelperFlags -> NSNumber, a set of flags indicating how the 
	//								  data should be handled, eg "force copy"
	//	3. kSproutedAppHelperMetadata -> NSDictionary, contains key-value pairs
	//									 of Spotlight metadata attributes
	//
	//	These keys are defined in the plugin framework
}

@end
