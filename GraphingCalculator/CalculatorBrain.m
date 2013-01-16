//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Bob Gardner on 12/23/12.
//  Copyright (c) 2012 edu.stanford.cs193p.rhg259. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack {
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation {
    
    [self.programStack addObject:operation];
    id result = [CalculatorBrain runProgram:self.program];
    if (![result isKindOfClass:[NSNumber class]]) return 0;
    return [result doubleValue];
}

- (id)program {
    return [self.programStack copy];
}


- (void)clearStack {
    [self.programStack removeAllObjects];
}

- (void)removeLastOperand {
    [self.programStack removeLastObject];
}

+ (NSString *)descriptionOfProgram:(id)program {
    NSMutableArray *stack;
    if (![program isKindOfClass:[NSArray class]]) return @"";
    stack = [program mutableCopy];
    NSString *description = [self descriptionOfTopOfStack:stack];
    description = [self withoutSurroundingParens:description];
    while (stack.count > 0) {
        description = [description stringByAppendingFormat:@", %@", [self withoutSurroundingParens:[self descriptionOfTopOfStack:stack]]];
    }
    return description;
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack {
    NSString *description = @"";
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        description = [topOfStack stringValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]){
        if ([self isTwoOperand:topOfStack]) {
            NSString *second = [self descriptionOfTopOfStack:stack];
            NSString *first = [self descriptionOfTopOfStack:stack];
            if ([first isEqualToString:@""]) first = @"0";
            if ([second isEqualToString:@""]) second = @"0";
            if ([topOfStack isEqualToString:@"+"] || [topOfStack isEqualToString:@"-"]) {
                first = [self withoutSurroundingParens:first];
                second = [self withoutSurroundingParens:second];
            }

            description = [NSString stringWithFormat:@"(%@ %@ %@)", first, topOfStack, second];
            if ([topOfStack isEqualToString:@"*"] || [topOfStack isEqualToString:@"/"]) {
                description = [self withoutSurroundingParens:description];
            }
        } else if ([self isOneOperand:topOfStack]) {
            NSString *argument = [self descriptionOfTopOfStack:stack];
            if ([argument isEqualToString:@""]) argument = @"0";
            description = [NSString stringWithFormat:@"%@(%@)", topOfStack, [self withoutSurroundingParens:argument]];
        } else {
            description = topOfStack;
        }
    }
    return description;
}

+ (NSString *)withoutSurroundingParens:(NSString *)argument {
    if (!([argument hasPrefix:@"("] && [argument hasSuffix:@")"])) return argument;
    return [argument substringWithRange:NSMakeRange(1, argument.length - 2)];
}

+ (BOOL)isTwoOperand:(NSString *)operation {
    return [[NSSet setWithObjects:@"+", @"-", @"*", @"/", nil] containsObject:operation];
}

+ (BOOL)isOneOperand:(NSString *)operation {
    return [[NSSet setWithObjects:@"sin", @"cos", @"sqrt", @"log", nil] containsObject:operation];
}

+ (BOOL)isZeroOperand:(NSString *)operation {
    return [[NSSet setWithObjects:@"π", @"e", nil] containsObject:operation];
}

+ (BOOL)isOperation:(NSString *)operation {
    return ([self isTwoOperand:operation] || [self isOneOperand:operation] || [self isZeroOperand:operation]);
}

+ (NSSet *)variablesUsedInProgram:(id)program {
    NSMutableSet *variables = [[NSMutableSet alloc] init];
    if (![program isKindOfClass:[NSArray class]]) return nil;
    NSMutableArray *stack = [program mutableCopy];
    for (id item in stack) {
        if ([item isKindOfClass:[NSNumber class]]) continue;
        if ([self isOperation:item]) continue;
        [variables addObject:item];
    }
    if (variables.count == 0) return nil;
    return variables;
}

+ (id)popOperandOffStack:(NSMutableArray *)stack {
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    if (topOfStack == nil) return nil;
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([self isTwoOperand:operation]) {
            id argumentTwo = [self popOperandOffStack:stack];
            id argumentOne = [self popOperandOffStack:stack];
            if (argumentOne == nil || argumentTwo == nil) return @"Insufficient Operands";
            if ([argumentOne isKindOfClass:[NSString class]] || [argumentTwo isKindOfClass:[NSString class]]) return argumentTwo;
            
            if ([@"+" isEqualToString:operation]) {
                result = [argumentOne doubleValue] + [argumentTwo doubleValue];
            } else if ([@"-" isEqualToString:operation]) {
                result = [argumentOne doubleValue] - [argumentTwo doubleValue];
            } else if ([@"*" isEqualToString:operation]) {
                result = [argumentOne doubleValue] * [argumentTwo doubleValue];
            } else if ([@"/" isEqualToString:operation]) {
                if ([argumentTwo doubleValue] == 0) return @"Divide by Zero Error";
                result = [argumentOne doubleValue] / [argumentTwo doubleValue];
            } 
        } else if ([self isOneOperand:operation]) {
            id argument = [self popOperandOffStack:stack];
            if (argument == nil) return @"Insufficient Operands";
            if ([argument isKindOfClass:[NSString class]]) return argument;
            
            if ([@"sin" isEqualToString:operation]) {
                result = sin([argument doubleValue]);
            } else if ([@"cos" isEqualToString:operation]) {
                result = cos([argument doubleValue]);
            } else if ([@"sqrt" isEqualToString:operation]) {
                if ([argument doubleValue] < 0) return @"Sqrt Negative Error";
                result = sqrt([argument doubleValue]);
            } else if ([@"log" isEqualToString:operation]) {
                if ([argument doubleValue] <= 0) return @"Log Arg Error";
                result = log10([argument doubleValue]);
            }
        } else if ([self isZeroOperand:operation]) {
            if ([@"π" isEqualToString:operation]) {
                result = M_PI;
            } else if ([@"e" isEqualToString:operation]) {
                result = M_E;
            }
        }
    }
    return [NSNumber numberWithDouble:result];
}

+ (id)runProgram:(id)program {
    NSMutableArray *stack;
    if (![program isKindOfClass:[NSArray class]]) return @"Not an array";
    stack = [program mutableCopy];
    if (stack.count == 0) return [NSNumber numberWithDouble:0];

    return [self popOperandOffStack:stack];
}

+ (id)runProgram:(id)program usingVariables:(NSDictionary *)variableValues {
    NSMutableArray *stack;
    if (![program isKindOfClass:[NSArray class]]) return @"Not an array";
    stack = [program mutableCopy];
    if (stack.count == 0) return [NSNumber numberWithDouble:0];
    for (int i = 0; i < stack.count; i++) {
        id item = stack[i];
        if ([item isKindOfClass:[NSNumber class]]) continue;
        if ([self isOperation:item]) continue; // slow operation
        NSNumber *value = [NSNumber numberWithDouble:[[variableValues objectForKey:item] doubleValue]];
        if (!value) value = [NSNumber numberWithDouble:0];
        [stack replaceObjectAtIndex:i withObject:value];
    }
    return [self popOperandOffStack:stack];
}
@end
