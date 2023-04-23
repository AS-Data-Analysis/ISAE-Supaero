#include "communicate.h"

/*
 * communicate.c
 *
 * This MEX-file is an interface to the WINDOWS SERIAL APIs.
 * There are three modes of operation for this MEX-file; 'open',
 * 'comopen' and 'comclose'.  The syntax for calling this MEX-file is as follows:
 *
 * ID = COMMUNICATE('comopen',S)
 *  initializes the interface to the COM port	and returns ID, a unique integer ID
 *  corresponding to the open com port configurated by S.
 *  The MATLAB M-file WINSERIAL/FOPEN should be used to call this routine.
 *
 *  COMMUNICATE('comclose',ID) finishes writing the COM port represented by ID.
 *  This routine should be called by the MATLAB M-file WINSERIAL/FCLOSE.
 *
 */

static int mexAtExitIsSet = 0;

void mexFunction(int nArgout, mxArray *varArgout[], int nArgin, const mxArray *varArgin[])
{
  char *mode;
  void (*opMode)(int nArgout, mxArray *varArgout[], int nArgin, const mxArray *varArgin[]);
  
  if( (nArgin < 2) && (nArgin > 8) )   mexErrMsgIdAndTxt("WINSERIAL:communicate","Invalid number of input arguments.");
  
  if(!mexAtExitIsSet)
  {
    InitNode();
    mexAtExit(exitMex);
    mexAtExitIsSet = 1;
  }
  
  if( mxIsChar(varArgin[0]) )  mode = mxArrayToString(varArgin[0]);
  else  mexErrMsgIdAndTxt("WINSERIAL:communicate","First input to COMMUNICATE must be a string.");
  
  if( mode == NULL )  mexErrMsgIdAndTxt("WINSERIAL:communicate","Memory allocation failed.");
  
  if     (!strcmp(mode,"comopen"))  opMode = comopen;
  else if(!strcmp(mode,"comclose")) opMode = comclose;
  else if(!strcmp(mode,"comwrite")) opMode = comwrite;
  else if(!strcmp(mode,"comread"))  opMode = comread;
  else mexErrMsgIdAndTxt("WINSERIAL:communicate","Unrecognized mode for COMMUNICATE.");
  
  mxFree(mode);
  // call the subfunction
  (*opMode)( nArgout, varArgout, nArgin, varArgin);
  
}

/*
 * COMOPEN opens the COM port and returns a unique file ID in varArgout
 *
 *   obj.FileID = communicate('comopen', obj);
 */
void comopen(int nArgout, mxArray *varArgout[], int nArgin, const mxArray *varArgin[])
{
  const mxArray *obj,*m;
  HANDLE hComm;
  DCB dcb;
//  COMMTIMEOUTS TimeOuts;
  char *portname, *fname;
  const char *prefix = "\\\\.\\";
  int identifier;
  NodeType *handle;
  double databits, stopbits, baudrate;
  /* Validate inputs */
  if( nArgin!=2 )         mexErrMsgIdAndTxt("WINSERIAL:communicate:comopen","Invalid number of inputs to COMOPEN.");
  obj = varArgin[1];
  if( !mxIsStruct(obj) )  mexErrMsgIdAndTxt("WINSERIAL:communicate:comopen","The first input to COMOPEN must be a valid WINSERIAL object.");
  portname = mxArrayToString(mxGetField(obj, 0, "PortName"));
  if( portname==NULL )    mexErrMsgIdAndTxt("WINSERIAL:communicate:comopen","Invalid PortName in input to COMOPEN.");
  identifier = IdFromName(portname);
  if( identifier==0 )     mexErrMsgIdAndTxt("WINSERIAL:communicate:comopen","Invalid PortName in input to COMOPEN.");
  // close hComm if already opened
  handle = FindNodeInList(identifier);
  if( handle!=NULL )
  {
    if( handle->hComm!=NULL ) CloseHandle(handle->hComm);
    deleteNodeFromList(identifier);
  }
  fname = (char *)mxMalloc(strlen(prefix) + strlen(portname) + 1);
  strcpy(fname, prefix);
  strcat(fname, portname);
  // Create Connection
  hComm = CreateFile((LPCTSTR)fname,
          GENERIC_READ | GENERIC_WRITE,
          0,
          NULL,
          OPEN_EXISTING,
          FILE_ATTRIBUTE_NORMAL,
          NULL
          );
  if( hComm==INVALID_HANDLE_VALUE )
  {
    mxFree(fname);
    mxFree(portname);
    mexErrMsgIdAndTxt("WINSERIAL:communicate:comopen","Cannot open com port.");
  }
    
  GetCommState(hComm, &dcb);
  // Disable the flow controls
  dcb.fDtrControl = DTR_CONTROL_DISABLE;
  dcb.fRtsControl = RTS_CONTROL_DISABLE;
  // Set BaudRate
  m = mxGetField(obj, 0, "BaudRate");
  if( m!=NULL )
  {
    baudrate = mxGetScalar(m);
    dcb.BaudRate = (DWORD)baudrate;
  }
  // Set Parity
  m = mxGetField(varArgin[1], 0, "Parity");
  if( m!=NULL )
  {
    char *parity = mxArrayToString(m);
    if(     !_strcmpi(parity, "even"))  dcb.Parity = EVENPARITY;
    else if(!_strcmpi(parity, "mark"))  dcb.Parity = MARKPARITY;
    else if(!_strcmpi(parity, "none"))  dcb.Parity = NOPARITY;
    else if(!_strcmpi(parity, "odd"))   dcb.Parity = ODDPARITY;
    else if(!_strcmpi(parity, "space")) dcb.Parity = SPACEPARITY;
  }
  // Set StopBits
  m = mxGetField(obj, 0, "StopBits");
  if( m!= NULL )
  {
    stopbits = mxGetScalar(m);
    if(stopbits == 1)         dcb.StopBits = ONESTOPBIT;
    else if(stopbits == 1.5)  dcb.StopBits = ONE5STOPBITS;
    else if(stopbits == 2)    dcb.StopBits = TWOSTOPBITS;
  }
  // Set ByteSize
  m = mxGetField(obj, 0, "DataBits");
  if (m != NULL)
  {
    databits = mxGetScalar(m);
    dcb.ByteSize = (BYTE)databits;
  }
  if(!SetCommState(hComm, &dcb))
  {
    mxFree(fname);
    mxFree(portname);
    CloseHandle(hComm);
    mexErrMsgIdAndTxt("WINSERIAL:communicate:comopen","Error Setting Comm State.");
  }
//  GetCommTimeouts(hComm, &TimeOuts);

  /* Keep track of COM handles */
  if( addNodetoList(identifier,hComm)!=identifier )
  {
    mxFree(fname);
    mxFree(portname);
    CloseHandle(hComm);
    mexErrMsgIdAndTxt("WINSERIAL:communicate:comopen","Error Creating FileID.");
  }
  
  /* Return a unique number */
  varArgout[0] = mxCreateDoubleScalar(identifier);
  mxFree(fname);
  mxFree(portname);
}


/*
 * COMCLOSE close the stream and the file then remove this information from	the list.
 *
 * communicate('comclose', FileID);
 */
void comclose(int nArgout, mxArray *varArgout[], int nArgin, const mxArray *varArgin[])
{
  int identifier;
  NodeType *handle;
  
  /* Need to find the stream handle for this particular file. */
  identifier = mxGetScalar(varArgin[1]);
  handle = FindNodeInList(identifier);
  if(handle == NULL)              mexErrMsgIdAndTxt("WINSERIAL:communicate:comclose","Cannot close the port.");
  else if(handle->hComm == NULL)  mexErrMsgIdAndTxt("WINSERIAL:communicate:comclose","Cannot close the port.");
  CloseHandle(handle->hComm);
  deleteNodeFromList(identifier);
}


/*
 * COMWRITE write the data to the com port
 *
 * wsize = communicate('comwrite', FileID, data, count);
 */
void comwrite(int nArgout, mxArray *varArgout[], int nArgin, const mxArray *varArgin[])
{
  DWORD nobtw, size;
  void *buf;
  int cnt;
  int identifier;
  NodeType *handle;
  
  if( nArgin!=4 ) mexErrMsgIdAndTxt("WINSERIAL:communicate:comwrite","Invalid number of inputs to COMWRITE.");
  
  identifier = mxGetScalar(varArgin[1]);
  handle = FindNodeInList(identifier);
  if(handle == NULL)             mexErrMsgIdAndTxt("WINSERIAL:communicate:comwrite","Cannot write the port.");
  else if(handle->hComm == NULL) mexErrMsgIdAndTxt("WINSERIAL:communicate:comwrite","Cannot write the port.");
  
  buf = mxGetData(varArgin[2]);
  cnt = mxGetScalar(varArgin[3]);
  
  switch(mxGetClassID(varArgin[2])) {
    case mxINT8_CLASS:
    case mxUINT8_CLASS:
    case mxCHAR_CLASS:
      nobtw = cnt;
      break;
    case mxINT16_CLASS:
    case mxUINT16_CLASS:
      nobtw = cnt * 2;
      break;
    case mxINT32_CLASS:
    case mxUINT32_CLASS:
    case mxSINGLE_CLASS:
      nobtw = cnt * 4;
      break;
    case mxINT64_CLASS:
    case mxUINT64_CLASS:
    case mxDOUBLE_CLASS:
      nobtw = cnt * 8;
      break;
//     case mxUNKNOWN_CLASS:
//       break;
//     case mxCELL_CLASS:
//       break;
//     case mxSTRUCT_CLASS:
//       break;
//     case mxLOGICAL_CLASS:
//       break;
    default:
      mexErrMsgIdAndTxt("WINSERIAL:communicate:comwrite","Invalid data type to COMWRITE");
      break;
  }
  WriteFile(handle->hComm, buf, nobtw, &size, NULL);
  /* Return a number of bytes written */
  varArgout[0] = mxCreateDoubleScalar(size);
}


/*
 * COMREAD read the data to the com port
 *
 * [data,numRead] = communicate('comread', FileID, totalSize);
 */
void comread(int nArgout, mxArray *varArgout[], int nArgin, const mxArray *varArgin[])
{
  DWORD nobtw,tsize, rsize;
  void *buf;
  int cnt;
  int identifier;
  NodeType *handle;
  
  if( nArgin!=3 )    mexErrMsgIdAndTxt("WINSERIAL:communicate:comread","Invalid number of inputs to COMREAD.");
  
  identifier = mxGetScalar(varArgin[1]);
  handle = FindNodeInList(identifier);
  if(handle == NULL)              mexErrMsgIdAndTxt("WINSERIAL:communicate:comread","Cannot read the port.");
  else if(handle->hComm == NULL)  mexErrMsgIdAndTxt("WINSERIAL:communicate:comread","Cannot read the port.");
  
  tsize = mxGetScalar(varArgin[2]);
  
  buf = mxCalloc(tsize, sizeof(unsigned char));
  
  if( ReadFile(handle->hComm, buf, tsize, &rsize, NULL)!=0 ) {
    varArgout[0] = mxCreateDoubleMatrix(1, (int)rsize, mxREAL);
    for(cnt = 0; cnt < (signed)rsize; cnt++) {
      *((double *)mxGetPr(varArgout[0]) + cnt) = *((unsigned char *)buf + cnt);
    }
    varArgout[1] = mxCreateDoubleScalar(rsize);
  }
  else {
    varArgout[0] = mxCreateDoubleScalar(0);
    varArgout[1] = mxCreateDoubleScalar(rsize);
  }
  mxFree(buf);
}

/*
 * commutil --- support for communicate.mex
 *
 * This module maintains a linked list of COM identifiers.
 * Each call to communicate('open',...) generates a unique file and stream identifier.
 * Since these identifiers are INTERFACE types (COM) they must be kept in memory.
 * Also, in case of a premature "clear mex", "quit" or an accidental crash, 
 * the identifiers in the list can be closed.
 *
 */

static NodeType OpenFiles;

/*
 * InitNode : Initialize the list.
 */
void InitNode(void)
{
	OpenFiles.number   = -1;
	OpenFiles.hComm    = NULL;
	OpenFiles.next     = NULL;
	OpenFiles.previous = NULL;
}
/*
 * IdFromName : Create a unique identifier from portname (COM1->COM256)
 */
int IdFromName(char * portname)
{
  int identifier=0;
  if( portname!=NULL )
  {
    while(*portname!=0)
    {
      identifier += *portname;
      portname++;
    }
  }
  return identifier;
}
/*
 * addNodetoList
 *	Insert a new node at the begninning of the OpenFiles list.
 *
 *	Inputs:  identifier  - A unique identification number
 *	         hComm       - HANDLE to CommPort
 *
 *	Outputs: A unique identification number
 */
int addNodetoList(int identifier, HANDLE hComm)
{
  NodeType *NewNode = NULL;
  NodeType *ListHead;
  
  ListHead = &OpenFiles;
  
  NewNode = (NodeType *) mxMalloc(sizeof(NodeType));
  if( NewNode != NULL )
  {
    mexMakeMemoryPersistent((void *) NewNode);
    //NewNode->number   = (ListHead->next == NULL)?1:ListHead->next->number+1;
    NewNode->number   = identifier;
    NewNode->hComm    = hComm;
    NewNode->next     = NULL;
    NewNode->previous = NULL;
  }
  else
    mexErrMsgTxt("Out of memory in MEX-file");
  /* Add node to begining of list */
  NewNode ->next = ListHead->next;
  NewNode->previous = ListHead;
  ListHead->next = NewNode;
  if (NewNode->next != NULL)
  {
    NewNode->next->previous = NewNode;
  }
  
  return(NewNode->number);
}

/*
 * FindNodeInList
 *	Find a node in the OpenFiles list given a unique identification number.
 *
 *	Inputs:  number - a unique number identifying the node
 *	Outputs: pointer to the node found
 */
NodeType *FindNodeInList(int number)
{  
  NodeType *current;
  int found = 0;
  
  current =  &OpenFiles;
  current = current->next;
  while( current!= NULL )
  {
    if(current->number == number)
    {
      found = 1;
      break;
    }
    current = current->next;
  }
  if( found==0 )  current = NULL;
  
  return(current);
}

/*
 * deleteNodeFromList
 *	Remove a node from the OpenFiles list given a unique identification number.
 *
 *	Inputs: number - a unique number identifying the node.
 *  Outputs: none
 */
void deleteNodeFromList(int number)
{
  NodeType *MatchNode;
  NodeType *ListHead;
  
  ListHead = &OpenFiles;
  
  MatchNode = FindNodeInList(number);
  
  if(MatchNode != NULL)
  {
    MatchNode->previous->next = MatchNode->next;
    if (MatchNode->next != NULL)
      MatchNode->next->previous = MatchNode->previous;
    mxFree((void *)MatchNode);
  }
  else
    mexErrMsgTxt("Unable to find node in list");
}

/*
 * cleanList
 * For each node in the OpenFiles list, close the file. 
 */
void cleanList(void)
{
  NodeType *ListHead;
  NodeType *current;
  
  ListHead = &OpenFiles;
  while (ListHead->next != NULL)
  {
    current = ListHead->next;
    if (current->hComm)
    {
      CloseHandle(current->hComm);
      current->hComm = NULL;
    }
    ListHead->next = current->next;
    mxFree((void *)current);
  }
}


void exitMex(void)
{
	NodeType *ListHead;
  
	ListHead = &OpenFiles;
	if( ListHead->next!=NULL )
	{
		mexWarnMsgTxt("Closing all open Serial Port. It is no longer possible to write to any previously open Serial Port.");
		cleanList();
	}
}

