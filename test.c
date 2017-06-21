

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

// finds the length of the string
int myStrlen(char * s)
{
  int len = 0;
  // only loop while there is a character left besides null
  while(*s++)
    len++;
  return len;
}

// get length of string
// malloc memory for new string
// copy byte by byte using while loop
/* Makes a copy of a string by copying byte by byte  */
char* makeCopy(char* s){
  // get length and make a copy pointer for original string
  int len = myStrlen(s);
  char* sc = s;
  // allocate memory for copy
  char* copy = (char*)malloc(len + 1);
  char* copyC = copy;
  int i;
  // clear each slot of space
  for(i = 0; i < len+1; i++){
    *copyC = '\0';
    copyC++;
  }
  // copy each character of original string manually
  char* copyD = copy;
  while(*sc != '\0'){
    *copyD = *sc;
    sc++;
    copyD++;
  }
  return copy;
}

/* Takes in a string and makes it uppercase, aka woOp will return WOOP  */
char* toUpper(char* s){
  char* sc = makeCopy(s);
  char* sv = sc;
  // loop while s still has valid characters
  while(*sv != '\0'){
    if(*sv >= 'a' && *sv <= 'z')
      *sv = *sv - 32;
    sv++;
  }
  return sc;
}

/* Compares two strings and sees if they are the same, ignoring case  */
bool sameString(char* s1, char* s2){
  bool result = true;
  // use toUpper to check
  char* up1 = toUpper(s1);
  char* up2 = toUpper(s2);
  char* upc1 = up1;
  char* upc2 = up2;
  // loop only while there are characters left in each
  while((*upc1 != '\0') && (*upc2 != '\0')){
    // compare the current pair of characters
    int d = *upc1 - *upc2;
    // if the difference isn't zero, change result to false
    if(d != 0)
      result = false;
    // increment pointer addresses
    upc1++;
    upc2++;
    // account for case of similar to a point, but one string ends before
    //  the other, this would obviously mean strings are different
    if((*up1 != '\0' && *up2 == '\0') || (*up2 != '\0' && *up1 == '\0'))
      result = false; 
  }
  // free up the space allocated for uppercase strings (???)
  free (up1);
  free(up2);
  return result;
}

/* Sorts a string in place  */
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
  byte1--;
  byte2--;
  unsigned char *b1, *b2, tmp;

  int* val = *x;
  b1 = val;
  b2 = val;

  b1 += byte1;
  b2 += byte2;

  tmp = *b1;
  *b1 = *b2;
  *b2 = tmp;
}

int main()
{
  char* s = "woop";
  char* t = "wOOp";
  char* u = "yeah";
  char* copy = makeCopy(s);
  printf("string s: %s\n", s);
  copy = toUpper(copy);
  printf("uppercase s: %s\n\n", copy);
  int len = myStrlen(s);
  bool same = sameString(s, t);
  bool diff = sameString(t, u);
  printf("String s: %s\nString t: %s\n Are they the same: %d\n", s, t, same);
  printf("String t: %s\nString u: %s\n Are they the same: %d\n\n", t, u, diff);

  char* sort = "DCBAdcba";
  char* sortC = makeCopy(sort);
  printf("Unsorted string: %s\n", sort);
  mySort(sortC);
  printf("Sorted string: %s\n\n", sortC);

  double* array = makeArray(1000, 5);
  showArray(array, 5);
  
  return 0;
}
