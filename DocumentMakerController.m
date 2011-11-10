//
//  DocumentMakerController.m
//  SproutedInterface
//
//  Created by Philip Dow on 9/28/07.
//  Copyright Philip Dow / Sprouted. All rights reserved.
//

/*
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of the organization nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

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
