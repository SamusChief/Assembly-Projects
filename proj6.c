/*
  Tristan Adams
  Due 11/13/14
  Section 03
  Project 6
  Description: Makes a C++ style vector in C
 */

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <stdbool.h>

typedef struct fraction{
  int num;   //numerator
  int denom; //denominator
} FRACTION;

typedef struct myVector{
  FRACTION * ptr;
  int numAllocated;  //number of elements actually allocated
  int numUsed;  //the logical length

} MYVECTOR;

/* makes a new vector and allocates 2 slots for it */
void makeVector(MYVECTOR* v){
  v->numAllocated = 2;
  v->numUsed = 0;
  v->ptr = (FRACTION*)malloc(2 * sizeof(FRACTION));
  FRACTION f;
  f.num = 0;
  f.denom = 0;
  *(v->ptr) = f;
  *((v->ptr)+1) = f;
}

/* get rid of the vector by freeing its pointer */
void disposeVector(MYVECTOR* v){
  v->numAllocated = 0;
  v->numUsed = 0;
  free((*v).ptr);
}

/* returns the total slots used of the vector  */
int size(MYVECTOR* v){
  return v->numUsed;
}

/* returns the capacity of the vector  */
int capacity(MYVECTOR* v){
  return v->numAllocated;
}

/* takes in a fraction and an index and prints, with formatting  */
void printFraction(FRACTION f, int i){
  if(i % 5 == 0 && i != 0)
    printf("\n");
  printf("%d/%d, ", f.num, f.denom);
}

/* Runs through the vector and prints its contents  */
void displayVector(MYVECTOR* v){
  int i = 0;
  for(i = 0; i < size(v); i++){
    FRACTION f = *((v->ptr) + i);
    printFraction(f, i);
  }
  printf("\n");
}

/* takes the vector in src, and copies its contents to dest  */
void copyVector(MYVECTOR* src, MYVECTOR* dest){
  // copy all of the base members
  dest->numAllocated = capacity(src);
  dest->numUsed = 0;
  // create a new set of space for the copy, same size as the original pointer
  dest->ptr = (FRACTION*)malloc((capacity(dest)) * sizeof(FRACTION));
  int i = 0;
  // loop through, creating fractions each time and inserting them into the copy
  for(i = 0; i < size(src); i++){
    FRACTION f = *((src->ptr) + i);
    *((dest->ptr) + i) = f;
    dest->numUsed ++;
  }
}

/* Increase the capacity of the vector by two and recopy it  */
void grow(MYVECTOR* v){
  // make a copy of the original vector
  MYVECTOR copy;
  copyVector(v, &copy);

  // reallocate memory for the original vector, + 2 slots
  disposeVector(v);
  v->numUsed = size(&copy);
  v->numAllocated = capacity(&copy) + 2;
  v->ptr = malloc(capacity(v) * sizeof(FRACTION));

  // copy the contents back to the original vector
  int i = 0;
  for(i = 0; i < size(&copy); i++){
    FRACTION f = *((copy.ptr) + i);
    *((v->ptr) + i) = f;
  }

  // destroy the copy's pointer to save space
  disposeVector(&copy);
}

/* add a value onto the end of the vector  */
void append(MYVECTOR* v, FRACTION f){
  if((v->numUsed) == (v->numAllocated))
    grow(v);
  int slot = size(v);
  *((v->ptr) + slot) = f;
  v->numUsed += 1;
}

/* takes in two fractions, and tells whether or not the first is bigger  */
bool isLarger(FRACTION f1, FRACTION f2){
  double frac1 = (f1.num / 1.0)/(f1.denom / 1.0);
  double frac2 = (f2.num / 1.0)/(f2.denom / 1.0);
  return (frac1 > frac2);
}

/* Sorts a vector based on the selection sort  */
void sortVector(MYVECTOR* v, bool (*isBigger)(FRACTION f1, FRACTION f2)){
  int i = 0, j = 0;
  int min = 0;

  // search through the whole list
  for(j = 0; j < size(v); j++) {
    min = j;
    // check to update current minimum
    for(i = j+1; i < size(v); i++) {
      if( isBigger( *((v->ptr) + min) ,  *((v->ptr) + i) ) )
	min = i;
    }
    // swap if minimum is new
    if(min != j){
      FRACTION jf = *((v->ptr) + j);
      FRACTION minf = *((v->ptr) + min);
      FRACTION* f1 = ((v->ptr) + j);
      FRACTION* f2 = ((v->ptr) + min);

      *f1 = minf;
      *f2 = jf;
    }
  }
}

/* Inserts the fraction element at an input index of the array  */
void insertAt(MYVECTOR* v, int index, FRACTION element){
  // print error if index is out of bounds, and return
  if(index < 0 || index > capacity(v)){
    printf("Error, no element at %d\n", index);
    return;
  }

  // make a copy of the original vector
  MYVECTOR copy;
  copyVector(v, &copy);

  // reallocate memory for the original vector, + 2 slots
  disposeVector(v);
  v->numAllocated = capacity(&copy);
  v->numUsed = size(&copy) + 1;
  v->ptr = malloc(capacity(v) * sizeof(FRACTION));
  if(size(v) > capacity(v)){
    grow(v);
  }

  // copy the contents back to the original vector
  int i = 0;
  int j = 0;
  for(i = 0; i < size(&copy); i++){
    // if the index matches input, insert here
    if(i == index){
      *((v->ptr) + j) = element;
      j++;
    }
    // otherwise, recopy as normal
    *((v->ptr) + j) = *((copy.ptr) + i);
    j++;
  }

  // destroy the copy's pointer to save space
  disposeVector(&copy);

}

/* Remove the element at the input index of a vector  */
void removeAt(MYVECTOR* v, int index){
  // print error message
  if(index < 0 || index > size(v)){
    printf("Error, no element at %d\n", index);
    return;
  }
  MYVECTOR copy;
  copyVector(v, &copy);

  disposeVector(v);
  v->numUsed = size(&copy) - 1;
  v->numAllocated = capacity(&copy);
  v->ptr = malloc(capacity(v) * sizeof(FRACTION));

  // loop through and reinsert all values from v
  // except for the one at element index
  int i = 0;
  int j = 0;
  for(i = 0; i < size(&copy); i++){
    // only insert if the index is not to be removed
    if(i != index){
      *((v->ptr)+j) = *((copy.ptr) + i);
      j++;
    }
  }

  // free the space of the copy
  disposeVector(&copy);
}


int main()
{

  FRACTION fracArray [10] ={ {1,2},{2,3},{3,4},{7,8},{22,7},
                             {1,3},{1,4},{1,8},{2,5},{3,5}};

  int n, d;
  printf("Enter n/d: ");
  scanf("%d/%d", &n, &d);

  FRACTION f1= {n,d};
  FRACTION f2 = {d,n};


  int i =0;
  MYVECTOR myV;
  MYVECTOR copyMyV;


  makeVector(&myV);

  for (i =0; i<10; i++)
  {
      append(&myV, fracArray[i]);
      printf("%d/%d appended to the vector.  ", fracArray[i].num,
                                              fracArray[i].denom);
      printf("Size is: %d, ", size(&myV));
      printf("Cap is: %d\n", capacity(&myV));
  }

  printf("----------------------\n");
  printf("Here are the values: \n");
  displayVector(&myV);

  printf("----------------------\n");
  sortVector(&myV, &isLarger);
  printf("Here are the values after sort: \n");
  displayVector(&myV);

  printf("----------------------\n");
  printf("Inserting %d/%d at index %d\n", n,d,n % 10);
  insertAt(&myV, n % 10 , f1);
  printf("After inserts, values are: \n");
  displayVector(&myV);
  printf("Size is: %d, and Cap is: %d\n ", size(&myV), capacity(&myV));


  printf("----------------------\n");
  printf("Inserting %d/%d at index %d\n", d,n,d % 10);
  insertAt(&myV, d % 10 , f2);
  printf("After inserts, values are: \n");
  displayVector(&myV);
  printf("Size is: %d, and Cap is: %d\n ", size(&myV), capacity(&myV));

  printf("----------------------\n");
  printf("Inserting %d/%d at index %d\n", n , d,-(n % 10));
  insertAt(&myV, -(n % 10), f1);


  printf("----------------------\n");
  printf("Inserting %d/%d at index %d\n", d,n, size(&myV) + (d % 10));
  insertAt(&myV, size(&myV) + (d % 10), f2);

  printf("----------------------\n");
  printf("Call copyVector\n");
  copyVector(&myV, &copyMyV);

  printf("----------------------\n");
  printf("Here is the original: \n");
  displayVector(&myV);

  printf("----------------------\n");
  printf("Here is the copy: \n");
  displayVector(&copyMyV);

  printf("----------------------\n");
  printf("Adding many new values to the copy\n");

  for (i =0; i<10; i++)
    {
      append(&copyMyV, fracArray[i]);
      printf("%d/%d appended to the vector.  ", fracArray[i].num,
             fracArray[i].denom);
      printf("Size is: %d, ", size(&copyMyV));
      printf("Cap is: %d\n", capacity(&copyMyV));
    }

  printf("----------------------\n");
  printf("Here is the copy after adding 10 new fractions: \n");
  displayVector(&copyMyV);

  printf("----------------------\n");
  sortVector(&copyMyV, &isLarger);
  printf("Here is the copy after sorting: \n");
  displayVector(&copyMyV);

  printf("----------------------\n");
  printf("Here is the original vector: \n");
  displayVector(&myV);

  printf("----------------------\n");
  printf("Removing value at index %d.", n % 10);
  removeAt(&copyMyV, n % 10);
  printf("Size is: %d, ", size(&copyMyV));
  printf("Cap is: %d\n", capacity(&copyMyV));
  printf("Here is the copy after removing the value at %d: \n", n % 10);
  displayVector(&copyMyV);

  printf("----------------------\n");
  printf("Removing value at index %d.", d % 10);
  removeAt(&copyMyV, d % 10);
  printf("Size is: %d, ", size(&copyMyV));
  printf("Cap is: %d\n", capacity(&copyMyV));
  printf("Here is the copy after removing the value at %d: \n", d % 10);
  displayVector(&copyMyV);


  printf("----------------------\n");
  printf("Calling disposeVector\n");
  disposeVector(&myV);
  disposeVector(&copyMyV);


  return 0;

}
