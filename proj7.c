/* Tristan Adams
 * Due 11/20/2014
 * Section 03
 * CMSC 313 Project 7
 * Description:
     Implement generic functions which take in void pointers:
       display array and sort array
 */

#include<stdio.h>
#include<stdbool.h>
#include <stdlib.h>
#include <string.h>

typedef struct student
{
  int id;
  double gpa;
} STUDENT;

/* Prints a double using a void pointer  */
void printDouble(void * d)
{
  printf("Value: %.1f, ",*(double*)d);
}

/* Prints a student using a void pointer  */
void printStudent(void * s)
{
  printf("id: %d, gpa: %.1f, ", (*(STUDENT*)s).id, (*(STUDENT*)s).gpa);
}

/* Prints a student using an adress of an address  */
void printStudentPtr(void  *s)
{
  printf("id: %d, gpa: %.1f, ", (**(STUDENT**)s).id, (**(STUDENT**)s).gpa);
}

/* Prints out the elements of the void base  */
void showValues(void * base, int nElem, int sizeofEachElem, void (*fptr)(void *))
{
  int i;
  // iterate 
  for(i = 0; i < (nElem * sizeofEachElem); i += sizeofEachElem){
    if(i != 0 && i % (sizeofEachElem * 5) == 0)
      printf("\n");
    fptr((base + i));
  }
  printf("\n");
}

/* compares two double values from void pointers  */
bool cmpDouble (void *v1, void *v2)
{
  double d1;
  double d2;
  d1 = *(double*)v1;
  d2 = *(double*)v2;
  return d1 > d2;
}

/* compares two student ID's using their pointers */
bool cmpStudent (void *v1, void *v2)
{
  int id1;
  int id2;
  id1 = (*(STUDENT*)v1).id;
  id2 = (*(STUDENT*)v2).id;
  return id1 > id2;
}

/* compares two student ids based on addresses of addresses  */
bool cmpStudentPtr (void *v1, void *v2)
{
  int id1;
  id1 = (**(STUDENT**)v1).id;
  int id2;
  id2 = (**(STUDENT**)v2).id;
  return id1 > id2;
}

/* performs a selection sort using generics  */
void selectionSort(void * base, int nElem, int sizeofEachElem, bool (*cmp)(void *, void *), void (*fptr)(void *))
{
  int size = nElem * sizeofEachElem;
  int plus = sizeofEachElem;
  int iMin, i, j;
  // advance the position through the entire array
  for (j = 0; j < size; j+= plus) {
    iMin = j;
    // begin inner loop
    for ( i = j; i < size; i+= plus) { 
      if (cmp((base + iMin), (base + i))) {
          iMin = i;
      }
    }
 
    // if a new min has been made, do a swap
    if(iMin != j) {
      char* tmp1[sizeofEachElem];
      char* tmp2[sizeofEachElem];
      // copy values of j and min indexes
      memcpy(tmp1, (base + j), sizeofEachElem);
      memcpy(tmp2, (base + iMin), sizeofEachElem);
      // swap the values
      memcpy((base + j), tmp2, sizeofEachElem);
      memcpy((base + iMin), tmp1, sizeofEachElem);
      // print results
      showValues(base, nElem, sizeofEachElem, fptr);
      printf("\n");
    }
  }
}

/* frees the memory that has been allocated so far  */
void freeHeapMem(STUDENT ** ptr, int size)
{
  int i;
  // iterate through the pointer and free allocated memory
  for(i = 0; i < size; i ++){
    free(*(ptr+i));
  }
}

int main(int argC, char * argV[])
{

  // seed value provided as command-line arg.
  srand(atoi(argV[1]));

  // rand % 8 just evaluates to an int from 0 to 7, gets added to num < 1 to get a "random" double

  double myDouble []={ rand()%8 + .2, rand()%8 +  .3, rand()%8 +  .7, rand()%8 +  .5, rand()%8 +  .6,
                       rand()%8 + .4, rand()%8 +  .1, rand()%8 +  .2, rand()%8 +  .3, rand()%8 +  .4};




  // produce "random" student info
  STUDENT sArray [] ={ {rand()%1000, rand()%4 + .3}, {rand()%1000, rand()%4 + .9}, {rand()%1000, rand()%4 + .5}, {rand()%1000, rand()%4 + .7},
                       {rand()%1000, rand()%4 + .1}, {rand()%1000, rand()%4 + .8}, {rand()%1000, rand()%4 + .5}, {rand()%1000, rand()%4 + .9},
                       {rand()%1000, rand()%4 + .3}, {rand()%1000, rand()%4 + .7}};



 
  STUDENT * ptrArray[10];

  int i;
  for(i =0; i <10; i++)
    {
      ptrArray[i] = (STUDENT *)malloc(sizeof(STUDENT));
      ptrArray[i]-> id = sArray[i].id  + 1;
      ptrArray[i]->gpa = sArray[i].gpa + .1;

    }

  printf("---------------------------------------\n");
  printf("Print index 5 of each array\n");
  printDouble(&myDouble[5]);
  printStudent(&sArray[5]);
  printStudentPtr(&ptrArray[5]);

  printf("\n---------------------------------------\n");
  printf("Print all elements by calling the showValues on myDouble\n");
  showValues(myDouble, 10, sizeof(double), &printDouble);
  printf("\n---------------------------------------\n");
  printf("Print all elements by calling the showValues on printStudent\n");
  showValues(sArray, 10, sizeof(STUDENT), &printStudent);
  printf("\n---------------------------------------\n");
  printf("Print all elements by calling the showValues on printStudentPtr\n");
  showValues(ptrArray, 10, sizeof(STUDENT *), &printStudentPtr);

  printf("\n---------------------------------------\n");
  printf("Selection Sort on myDouble\n");
  selectionSort(myDouble, 10, sizeof(double), &cmpDouble, &printDouble);


  printf("\n---------------------------------------\n");
  printf("Selection Sort on sArray\n");
  selectionSort(sArray, 10, sizeof(STUDENT), &cmpStudent, &printStudent);


  printf("\n---------------------------------------\n");
  printf("Selection Sort on ptrArray\n");
  selectionSort(ptrArray, 10, sizeof(STUDENT *), &cmpStudentPtr, &printStudentPtr);




  freeHeapMem(ptrArray, 10);

  return 0;

}
