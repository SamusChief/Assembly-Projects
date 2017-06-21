/*
  Tristan Adams
  Due 10/16/2014
  Homework 3
  Section 03
  Takes in an odd number, and uses it to spproximate pi using Gregory-Leibniz
  formula:
     pi = 4*(1 - 1/3 + 1/5 - 1/7 + 1/9 - ... 1/x)
     where x is the number input by a user
  Uses at least one if/else, one for loop, one while loop, and one switch
 */

//include printing, scanning, and booleans
#include <stdio.h>
#include <stdbool.h>

// define starting number for loop (always 1) and positive and negative signs
#define START 1
#define POS '+'
#define NEG '-'

/* Prints a plus or minus, then 1/x  */
void printVal(bool positive, int x){
  char sign = 'n';
  // determine which sign should be used based on parameters
  switch(positive){
    case true:
      sign = POS;
      break;
    case false:
      sign = NEG;
      break;
  }
  // print the sign, and the fraction
  printf(" %c 1/%u", sign, x);
}

/* The equivalent of printVal, but prints to a file  */
void printFile(bool positive, int x, FILE *file){
  char sign = 'n';
  // determine which sign to use here
  switch(positive){
    case true:
      sign = POS;
      break;
    case false:
      sign = NEG;
      break;
  }
  // print to the file
  fprintf(file, " %c 1/%u", sign, x);
}

/* 
   Loops through from 1 to 1/x using Gregory-Leibniz formula 
   returns the final result of the operation
 */
void looperConsole(int x){
  bool format = false;
  int i;
  // store pi value, add and subtract as needed, then finally, multiply by 4
  double pi = 0.00;
  bool positive = true;
  // use to keep track of how many fractions are on a line
  int lineCount = 0;
  // loop through every number leading up to the input
  for(i = START; i <= x; i++){
    // only do operations if n is odd
    if(i % 2 == 1){
      lineCount ++;
      // do a different operation if n is exactly 1
      if(i == 1){
	// initiate pi
	pi = pi + 1.00;
	printf("\nOK, I will calculate ...\n 4 X ( 1");
	// change value of positive variable
	if(positive == false)
	  positive = true;
	else
	  positive = false;
      }
      // do regular operations
      else{
	// convert i to double, add 1/i to pi
	if(positive == true){
	  double num = i;
	  pi = pi + (1.00/num);
	}
	// convert i to double, subtract 1/i to pi
	else{
	  double num = i;
	  pi = pi - (1.00/i);
	}
	// print out a properly formatted number
	printVal(positive, i);
	// change sign value
	if(positive == true)
	  positive = false;
	else
	  positive = true;
	// move to a new line if needed
	if(lineCount % 5 == 0){
	  if (i == x){
	    printf(" )");
	    format = true;
	  }
	  if(format == true){
	    printf("\n");
	  }
	  else{
	    printf("\n\t");
	  }
	}
      }
    }
  }
  // final pi multiplication
  pi *= 4;
  // print pi
  if(format == false)
    printf(" )\n...which is equal to %f\n", pi);
  else
    printf("...which is equal to %f\n", pi);
}

/* 
   Equivalent to looperConsole, only this calls printFile instead of printVal
   and uses fprintf instead of printf
 */
void looperFile(int x, FILE *file){
  bool format = false;
  int i;
  // store pi value, add and subtract as needed, then finally, multiply by 4
  double pi = 0.00;
  bool positive = true;
  // use to keep track of how many fractions are on a line
  int lineCount = 0;
  // loop through every number leading up to the input
  for(i = START; i <= x; i++){
    // only do operations if n is odd
    if(i % 2 == 1){
      lineCount ++;
      // do a different operation if n is exactly 1
      if(i == 1){
	// initiate pi
	pi = pi + 1.00;
	fprintf(file, "OK, I will calculate ...\n 4 X ( 1");
	// change value of positive variable
	if(positive == false)
	  positive = true;
	else
	  positive = false;
      }
      // do regular operations
      else{
	// convert i to double, add 1/i to pi
	if(positive == true){
	  double num = i;
	  pi = pi + (1.00/num);
	}
	// convert i to double, subtract 1/i to pi
	else{
	  double num = i;
	  pi = pi - (1.00/i);
	}
	// print out a properly formatted number
	printFile(positive, i, file);
	// change sign value
	if(positive == true)
	  positive = false;
	else
	  positive = true;
	// move to a new line if needed
	if(lineCount % 5 == 0){
	  if (i == x){
	    fprintf(file, " )");
	    format = true;
	  }
	  if(format == true){
	    fprintf(file, "\n");
	  }
	  else{
	    fprintf(file, "\n\t");
	  }
	}
      }
    }
  }
  // final pi multiplication
  pi *= 4;
  // print pi
  if(format == false)
    fprintf(file, " )\n...which is equal to %f\n", pi);
  else
    fprintf(file, "...which is equal to %f\n", pi);
}

/* Prints the prompt for a positive number */
int promptNum(){
  int num = 0;

  printf("\nEnter a positive odd integer: ");
  scanf("%d", &num);
  while (num % 2 == 0 || num < 0){
    printf("\nEnter a positive odd integer: ");
    scanf("%d", &num);
  }
  return num;
}

/* Get a choice from the user for either printing to screen or to a file  */
int promptChoice(){
  int num = 0;
  // take in the first choice
  printf("\nEnter 1 to write to a file");
  printf("\nEnter 2 to write to the screen: ");
  scanf("%d", &num);
  bool valid = false;
  // validate the input, if choice is not 1 or 2
  if(num == 1 || num == 2)
    valid = true;
  while(valid == false){
    printf("\nYou did not enter 1 or 2");
    printf("\nEnter 1 to write to a file");
    printf("\nEnter 2 to write to the screen: ");
    scanf("%d", &num);
    if(num == 1 || num == 2)
      valid = true;
  }

  return num;
}

/* Gets a filename from the user */
char* getFilename(char* file){
  printf("Please input a filename (9 char or less): ");
  scanf("%s", file);
  return file;
}

int main(){
  // get the odd number, and the output choice
  int x = promptNum();
  int choice = promptChoice();
  // print to a file
  if(choice == 1){
    char filename[9];
    getFilename(filename);
    FILE *file = fopen(filename, "w");
    looperFile(x, file);
    fclose(file);
  }
  // print to the console
  else{
  looperConsole(x);
  }
  return 0;
}
