//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Bob Gardner on 12/23/12.
//  Copyright (c) 2012 edu.stanford.cs193p.rhg259. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (void)removeLastOperand;
- (void)clearStack;

@property (readonly) id program; // future proof, ambiguous

+ (id)runProgram:(id)program;
+ (id)runProgram:(id)program usingVariables:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;

@end
