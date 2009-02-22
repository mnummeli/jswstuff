/*
 * Jet Set Willy room definition as a C structure
 * (c) Mikko Nummelin 2002
 * roomdef.h
 */

#define FALSE                  0
#define TRUE                   1
#define EMPTY                  (0x00)
#define FLOOR                  (0x01)
#define WALL                   (0x02)
#define NASTY                  (0x03)
#define CNV_RAMP_LEFT          (0x00)
#define CNV_RAMP_RIGHT         (0x01)
#define CNV_OFF                (0x02)
#define CNV_STICKY             (0x03)
#define MEMDMP_SIZE            (0x8000)
#define NUMBER_OF_ROOMS        (0x40)
#define ROOMSIZE_X             (0x20)
#define ROOMSIZE_Y             (0x10)
#define EMPTY_CHAR             ' '
#define FLOOR_CHAR             '^'
#define WALL_CHAR              'X'
#define NASTY_CHAR             '*'
#define CONVEYOR_OFF_CHAR      '='
#define CONVEYOR_LEFT_CHAR     '<'
#define CONVEYOR_RIGHT_CHAR    '>'
#define CONVEYOR_STICKY_CHAR   '|'
#define RAMP_RIGHT_CHAR        '/'
#define RAMP_LEFT_CHAR         '\\'

typedef struct {
  unsigned char color_byte;
  unsigned char pattern[0x08];
} brickdef;

typedef struct {
  unsigned char left;
  unsigned char right;
  unsigned char above;
  unsigned char below;
} roomds;

typedef struct {
  unsigned char number;
  unsigned char start_byte;
} guaentry;

typedef struct {
  unsigned char screen_definition[0x80];
  char name[0x20];
  brickdef background_brick;
  brickdef floor_brick;
  brickdef wall_brick;
  brickdef nasty_brick;
  brickdef ramp_brick;
  brickdef conveyor_brick;
  unsigned char conveyor_direction;
  unsigned char conveyor_position[0x02];
  unsigned char conveyor_length;
  unsigned char ramp_direction;
  unsigned char ramp_position[0x02];
  unsigned char ramp_length;
  unsigned char border_color;
  unsigned char misc1[0x02];
  unsigned char object_pattern[0x08];
  roomds directions;
  unsigned char misc2[0x03];
  guaentry guardians[0x08];
} jsw_room_format;
