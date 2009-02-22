/*
 * Jet Set Willy room names dump
 * (c) Mikko Nummelin 2002
 * allrooms.c
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "roomdef.h"

#define MAX_FILENAME_LENGTH (0x80)

int main(int argc, char*argv[]){
  int i,j;
  char filename[MAX_FILENAME_LENGTH];
  FILE *ifile_p;
  unsigned char mem_dmp[MEMDMP_SIZE];
  jsw_room_format *room_ptr;
  char room_name[0x21];

  if(argc<2){
    printf("Too few arguments.\n");
    return 0;
  }

  /* Handles file */
  strncpy(filename,argv[1],MAX_FILENAME_LENGTH-1);
  ifile_p=fopen(filename,"rb");
  fread(mem_dmp,1,MEMDMP_SIZE,ifile_p);
  fclose(ifile_p);

  /* Prints headers */
  printf("JSW rooms list program by Mikko Nummelin.\n");
  printf("email: mnummeli@cc.hut.fi\n\n");
  printf("N:o :           Room name            :   <   >   %c   v\n\n",94);

  /* Loops through all the rooms */
  for(j=0x00;j<0x40;j++){

    /* Sets pointer to correct page in memory dump */
    room_ptr=(jsw_room_format *)(&mem_dmp[(0x4000)+j*(0x100)]);
    
    /* Retrieves room name into a proper C string. */
    for(i=0;i<0x20;i++){
      if((room_ptr->name[i]>=32) && (room_ptr->name[i]<=126)){
	room_name[i]=room_ptr->name[i];
      } else {
	room_name[i]=' ';
      }
    }
    room_name[0x20]=0;


    printf("%3d :%s",j,room_name);
    printf(": %3d %3d %3d %3d\n",
	   room_ptr->directions.left,
	   room_ptr->directions.right,
	   room_ptr->directions.above,
	   room_ptr->directions.below);
  }

  return 0;
}
