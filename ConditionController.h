//
//  ConditionController.h
//  SproutedInterface
//
//  Created by Philip Dow on xx.
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

#import <Cocoa/Cocoa.h>

#define kConditionViewHeight 26

#define PDConditionContains		0
#define PDConditionNotContains	1
#define PDConditionBeginsWith	2
#define PDConditionEndsWith		3
#define PDConditionIs			4

#define PDConditionBefore		0
#define PDConditionAfter		1
#define PDConditionBetween		2
#define PDConditionInTheLast	3
#define PDConditionInTheNext	4

#define PDConditionDay			0
#define PDConditionWeek			1
#define PDConditionMonth		2

@interface ConditionController : NSObject
{
    IBOutlet NSView	*conditionView;
	IBOutlet NSView	*specifiedConditionView;
	IBOutlet NSPopUpButton *keyPop;
	
	IBOutlet NSButton *removeButton;
	
	int tag;
	id target;
	
	BOOL _allowsEmptyCondition;
	BOOL _autogeneratesDynamicDates;
	BOOL _sendsLiveUpdate;
	
}

- (id) initWithTarget:(id)anObject;
- (void) setInitialPredicate:(NSPredicate*)aPredicate;
- (void) setInitialCondition:(NSString*)condition;

- (NSView*) conditionView;
- (NSPredicate*) predicate;
- (NSString*) predicateString;

- (int) tag;
- (void) setTag:(int)newTag;

- (id) target;
- (void) setTarget:(id)anObject;

- (BOOL) sendsLiveUpdate;
- (void) setSendsLiveUpdate:(BOOL)updates;

- (BOOL) autogeneratesDynamicDates;
- (void) setAutogeneratesDynamicDates:(BOOL)autogenerate;

- (BOOL) allowsEmptyCondition;
- (void) setAllowsEmptyCondition:(BOOL)allowsEmpty;

- (BOOL) removeButtonEnabled;
- (void) setRemoveButtonEnabled:(BOOL)enabled;

- (IBAction) addCondition:(id)sender;
- (IBAction) removeCondition:(id)sender;
- (IBAction) changeCondition:(id)sender;
- (IBAction) changeConditionKey:(id)sender;

- (id) selectableView;
- (void) appropriateFirstResponder:(NSWindow*)aWindow;
- (void) removeFromSuper;

- (void) _sendUpdateIfRequested;

// utility for creating spotlight based conditions - subclasses feel free to use
- (NSString*) _spotlightConditionStringWithAttribute:(NSString*)anAttribute condition:(NSString*)aCondition operation:(int)anOperation;
- (NSString*) _spotlightConditionStringWithAttributes:(NSArray*)theAttributes condition:(NSString*)aCondition operation:(int)anOperation;

- (BOOL) validatePredicate;
@end


#pragma mark -

@interface NSObject (ConditionControllerDelegate)

- (void) conditionDidChange:(id)condition;

@end