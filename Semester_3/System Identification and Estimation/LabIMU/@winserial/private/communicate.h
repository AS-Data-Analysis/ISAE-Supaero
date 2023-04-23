#include <windows.h>
#include "mex.h"

typedef struct node
{
	int number;                              // Unique identifier
	HANDLE hComm;                            // File handle
	struct node *next;                       // Pointer to the next     NodeType Struct
	struct node *previous;                   // Pointer to the previous NodeType Struct
} NodeType;

void comopen( int nArgout, mxArray *varArgout[], int nArgin, const mxArray *varArgin[]);
void comclose(int nArgout, mxArray *varArgout[], int nArgin, const mxArray *varArgin[]);
void comwrite(int nArgout, mxArray *varArgout[], int nArgin, const mxArray *varArgin[]);
void comread( int nArgout, mxArray *varArgout[], int nArgin, const mxArray *varArgin[]);

void cleanList(void);                      // used in exitMex function
void InitNode(void);                       // used in MEX gateway function
int IdFromName(char*);                     // used in comopen function
int addNodetoList(int, HANDLE);            // used in comopen function
NodeType *FindNodeInList(int);             // used in comopen/comclose/comwrite function
void deleteNodeFromList(int);              // used in comclose function
void exitMex(void);                        // used in MEX gateway function
