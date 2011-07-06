//
//  PDRankCell.h
//  SproutedInterface
//
//  Created by Philip Dow on 9/13/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>


@interface PDRankCell : NSTextFieldCell {
	float minRank, maxRank, rank;
}

- (float) minRank;
- (void) setMinRank:(float)value;

- (float) maxRank;
- (void) setMaxRank:(float)value;

- (float) rank;
- (void) setRank:(float)value;


@end
