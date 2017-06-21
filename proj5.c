/*
  Tristan Adams
  Due 11/6/2014
  Project 5
  Section 03
  Description: uses 2 command line args as strings then performs the following
    operations on them:
      - get length of each
      - check if they are the same string
      - make a copy of the strings
      - sort the strings
      - swap two bytes of an integer
      - dynamically create an array of doubles based on size input
      - show the array which has been made
 */

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

// finds the length of the string
int myStrlen(char * s)
{
  int len = 0;
  // only loop while there is a character left besides null
  while(*s++)
    len++;
  return len;
}

// get the length
// use malloc to allocate memory for copy
// copy byte by byte
/* Makes a copy of a string by copying byte by byte  */
char* makeCopy(char* s){
  // get length and make a copy pointer for original string
  int len = myStrlen(s);
  char* sc = s;
  // allocate memory for copy
  char* copy = (char*)malloc(len + 1);
  char* copyC = copy;
  int i;
  // clear each slot of space in the copy
  for(i = 0; i < len + 1; i++){
    *copyC = '\0';
    copyC++;
  }
  // copy each character of original string manually
  copyC = copy;
  while(*sc != '\0'){
    *copyC = *sc;
    sc++;
    copyC++;
  }
  return copy;
}

/* Compares two strings and sees if they are the same, ignoring case  */
bool sameString(char* s1, char* s2){
  bool result = false;
  char* sc1 = s1;
  char* sc2 = s2;
  // loop only while there are characters left in each
  while((*sc1 != '\0') && (*sc2 != '\0')){
    // compare the current pair of characters
    int d = *sc1 - *sc2;
    // if the difference isn't zero, change result to false
    if(d == 0 || d == 32)
      result = true;
    else
      result = false;
    // increment pointer addresses
    sc1++;
    sc2++;
    // account for case of similar to a point, but one string ends before
    //  the other, this would obviously mean strings are different
    if((*sc1 != '\0' && *sc2 == '\0') || (*sc2 != '\0' && *sc1 == '\0'))
      result = false; 
  }
  return result;
}

/* Sorts a string in place using a selection sort algorithm  */
void mySort(char* s){
  // iterators for inner and outer loops
  int i, j;
  // keep track of minimum and string length
  int min;
  int len = myStrlen(s);

  // outer loop, loops through the main structure of the loop
  for(j = 0; j < len; j++){
    // reset minimum
    min = j;
    // loop from current position to the end, searching for a smaller value
    for(i = j+1; i < len; i++){
      // if this character is smaller, make the min index this index
      if(*(s + i) < *(s + min)){
	min = i;
      }
    }

    // swap the values of the min character and the current loop iterator
    if(min != j){
      char jc = *(s + j);
      char minc = *(s + min);
      char* sj = s + j;
      char* sm = s + min;
      *sj = minc;
      *sm = jc;
    }
  }
}

/* Make an array of doubles using pointer logic  */
double* makeArray(int x, int size){
  // allocate memory for array for size
  double* result = malloc(size * sizeof(double));
  // assign value to a double to do math with it
  double val = x / 1.0;
  // loop through array slots, assigning values
  int i;
  for(i = 0; i < size; i++){
    // cut value in half each time
    val /= 2;
    *(result + i) = val;
  }
  return result;
}

/* Print an array based on its size, along with memory addresses for indexes  */
void showArray(double* ptr, int size){
  int i;
  for(i = 0; i < size; i++){
    printf("The value is %f at address %p\n", *(ptr + i), (ptr + i));
  }
}

/* swaps the bytes of an input integer  */
void swapHex(int x, int byte1, int byte2){
  // print out current value and swaps to be made
  printf("%d in hex is %x\n", x, x);
  printf("swapping byte %d with byte %d\n", byte1, byte2);

  // make a new pointer that points to x
  int *ptr = &x;
  // make character values for bytes
  //  since an int is 4 bytes and a character is one
  char *b1, *b2, tmp;
  b1 = ptr;
  b2 = ptr;
  // update b1 and b2 to proper slots
  b1 += byte1;
  b2 += byte2;

  // swap the two values
  tmp = *b1;
  *b1 = *b2;
  *b2 = tmp;

  // print final result
  printf("%d in hex is %x\n", x, x);
}

int main(int argc, char * argv[])
{

  char * copyOfArg1;
  char * copyOfArg2;
  double * myArr[2];

  printf("myStrlen Function\n");
  printf("The number of characters in %s is %d\n", argv[1], myStrlen(argv[1]));
  printf("The number of characters in %s is %d\n", argv[2], myStrlen(argv[2]));
  printf("--------------------------\n");
  printf("sameString Function\n");
  if (sameString(argv[1], argv[2]))
    printf("%s and %s are the same string\n", argv[1], argv[2]);
  else
    printf("%s and %s are not the same string\n", argv[1], argv[2]);
  printf("--------------------------\n");
  printf("makeCopy Function\n");
  copyOfArg1 = makeCopy(argv[1]);
  printf("argv[1] is %s and copy is %s\n", argv[1], copyOfArg1);
  copyOfArg2 = makeCopy(argv[2]);
  printf("argv[2] is %s and copy is %s\n", argv[2], copyOfArg2);
  printf("--------------------------\n");
  printf("mySort Function--Based on ASCII Codes\n");
  mySort(copyOfArg1);
  printf("argv[1] is %s and copy is %s\n", argv[1], copyOfArg1);
  mySort(copyOfArg2);
  printf("argv[2] is %s and copy is %s\n", argv[2], copyOfArg2);
  printf("--------------------------\n");
  printf("swapHex Function\n");
  swapHex(atoi(argv[3]),0,1);
  swapHex(atoi(argv[3]),0,2);
  swapHex(atoi(argv[3]),0,3);
  swapHex(atoi(argv[3]),1,2);
  swapHex(atoi(argv[3]),1,3);
  swapHex(atoi(argv[3]),2,3);
  printf("--------------------------\n");
  printf("makeArray Function\n");
  myArr[0] = makeArray(atoi(argv[3]), myStrlen(argv[1]));
  myArr[1] = makeArray(atoi(argv[3]), myStrlen(argv[2]));
  printf("--------------------------\n");
  printf("showArray Function for argv[1]\n");
  showArray(myArr[0], myStrlen(argv[1]));
  printf("--------------------------\n");
  printf("showArray Function for argv[2]\n");
  showArray(myArr[1], myStrlen(argv[2]));
  printf("--------------------------\n");
  printf("End of Demo\n");
  free(copyOfArg1);
  free(copyOfArg2);
  free(myArr[0]);
  free(myArr[1]);

  return 0;
}
