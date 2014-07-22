//
//  IssueTableOfContentsTVCell.m
//  Hau
//
//  Created by Andrew on 7/7/14.
//  Copyright (c) 2014 Andrew. All rights reserved.
//

#import "IssueTableOfContentsTVCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation IssueTableOfContentsTVCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPdfFileURL:(NSString *)pdfFileURL
{
    if (pdfFileURL) {
        [self.hasPDFLabel setHidden:NO];
        self.hasPDFLabel.layer.borderColor = [UIColor greenColor].CGColor;
        self.hasPDFLabel.layer.borderWidth = 4.0;
        self.hasPDFLabel.layer.cornerRadius = 4.0;        
    } else {
        [self.hasPDFLabel setHidden:YES];
    }    
}

@end
