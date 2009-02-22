/*
 * Jet Set Willy room definition dump
 * (c) Mikko Nummelin 2002
 * roomdef.c
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "roomdef.h"

#define MAX_FILENAME_LENGTH (0x80)

int main(int argc, char*argv[]){
  int i,j,room_number,convpos_row,convpos_column;
  int ramppos_row,ramppos_column;
  char filename[MAX_FILENAME_LENGTH];
  FILE *ifile_p;
  unsigned char mem_dmp[MEMDMP_SIZE];
  jsw_room_format *room_ptr;
  char tmp_roomspace[ROOMSIZE_Y*ROOMSIZE_X];
  char room_name[0x21];
  char rampchr,convchr;

  if(argc<3){
    printf("Too few arguments.\n");
    return 0;
  }

  /* Handles file and checks room number */
  strncpy(filename,argv[1],MAX_FILENAME_LENGTH-1);
  room_number = atoi(argv[2]);
  ifile_p=fopen(filename,"rb");
  fread(mem_dmp,1,MEMDMP_SIZE,ifile_p);
  fclose(ifile_p);

  /* Clears the temporary room space */
  for(j=0;j<ROOMSIZE_Y;j++){
    for(i=0;i<ROOMSIZE_X;i++){
      tmp_roomspace[i+j*ROOMSIZE_X]=EMPTY_CHAR;
    }
  }

  /* Sets pointer to correct page in memory dump */
  room_ptr=(jsw_room_format *)(&mem_dmp[(0x4000)+room_number*(0x100)]);

  /* Converts room image to more printable format to the
     temporary room space */
  for(i=0;i<0x80;i++){
    for(j=3;j>=0;j--){
      switch(((room_ptr->screen_definition[i])>>(2*j))&0x03){
      case EMPTY:
        tmp_roomspace[i*4-j+3]=EMPTY_CHAR;
	break;
      case FLOOR:
        tmp_roomspace[i*4-j+3]=FLOOR_CHAR;
	break;
      case WALL:
        tmp_roomspace[i*4-j+3]=WALL_CHAR;
	break;
      case NASTY:
        tmp_roomspace[i*4-j+3]=NASTY_CHAR;
	break;
      }
    }
  }

  /* Obtains possible ramp and conveyor positions */
  convpos_row     =
    (((room_ptr -> conveyor_position[1])&0x01)<<3) +
    (((room_ptr -> conveyor_position[0])&0xe0)>>5);
  convpos_column  = (room_ptr -> conveyor_position[0])&0x1f;
  ramppos_row     =
    (((room_ptr -> ramp_position[1])&0x01)<<3) +
    (((room_ptr -> ramp_position[0])&0xe0)>>5);
  ramppos_column  = (room_ptr -> ramp_position[0])&0x1f;


  /* Dump conveyor */
  if(((room_ptr -> conveyor_position[1])&0xfe)==0x5e){

    /* Gets appropriate character for conveyor. */
    switch(room_ptr->conveyor_direction){
    case CNV_RAMP_LEFT:
      convchr = CONVEYOR_LEFT_CHAR;
      break;
    case CNV_RAMP_RIGHT:
      convchr = CONVEYOR_RIGHT_CHAR;
      break;
    case CNV_OFF:
      convchr = CONVEYOR_OFF_CHAR;
      break;
    case CNV_STICKY:
      convchr = CONVEYOR_STICKY_CHAR;
      break;
    }
    for(i=0;i<room_ptr->conveyor_length;i++){

      /* To keep the conveyor in the appropriate area. */
      if(((convpos_column+convpos_row*0x20)<0x200) && 
	 ((convpos_column+convpos_row*0x20)>=0x00)){
	tmp_roomspace[convpos_column+convpos_row*0x20] = convchr;
      }
      convpos_column++;
    }
  }
  
  /* Dump ramp */
  if(((room_ptr -> ramp_position[1])&0xfe)==0x5e){
    /* Gets appropriate character for ramp. */
    switch(room_ptr->ramp_direction){
    case CNV_RAMP_LEFT:
      rampchr = RAMP_LEFT_CHAR;
      break;
    case CNV_RAMP_RIGHT:
      rampchr = RAMP_RIGHT_CHAR;
      break;
    }
    for(i=0;i<room_ptr->ramp_length;i++){

      /* To keep the ramp in the appropriate area. */
      if(((ramppos_column+ramppos_row*0x20)<0x200) && 
	 ((ramppos_column+ramppos_row*0x20)>=0x00)){
	tmp_roomspace[ramppos_column+ramppos_row*0x20] = rampchr;
      }
      ramppos_row--;
      (room_ptr->ramp_direction==CNV_RAMP_LEFT) ?
	ramppos_column-- :
	ramppos_column++;
    }
  }
  
  /* Retrieves room name into a proper C string. */
  for(i=0;i<0x20;i++){
    if((room_ptr->name[i]>=32) && (room_ptr->name[i]<=126)){
      room_name[i]=room_ptr->name[i];
    } else {
      room_name[i]=' ';
    }
  }
  room_name[0x20]=0;

  /* Prints room number to be considered, in DECIMAL */
  printf("\nRoom number: %d\n\n   ",room_number);

  for(i=0;i<0x08;i++){
    printf("%1X/%1X-",i&0x07,(i&0x07)|0x8);
  }
  printf("\n\n");

  /* Prints room contents onto the screen. */
  for(j=0;j<ROOMSIZE_Y;j++){
    printf(" %1x ",j>>1);
    for(i=0;i<ROOMSIZE_X;i++){
      printf("%c",tmp_roomspace[i+j*ROOMSIZE_X]);
    }
    fputc('\n',stdout);
  }

  printf("   %s\n\n",room_name);

  printf("                 %2d\n\n",
	 room_ptr->directions.above);
  printf("               %2d  %2d\n\n",
	 room_ptr->directions.left,
	 room_ptr->directions.right);
  printf("                 %2d\n",
	 room_ptr->directions.below);

  return 0;
}
