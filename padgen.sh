#!/bin/bash - 
#===============================================================================
#
#          FILE: padgen.sh
# 
#         USAGE: ./padgen.sh [OPTIONS]
# 
#   DESCRIPTION: One Time Pad Generator
# 
#       OPTIONS: See Usage
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Jeff (jeff@commentedcode.org)
#       CREATED: 11/19/2015 23:15
#      REVISION:  0.1
#       LICENSE: BSD-3
#===============================================================================

set -o nounset                              # Treat unset variables as an error

function Generate5() {
  if [[ "${RAND_SRC}" == "-" ]]
  then
    dd iflag=skip_bytes skip=${OFFSET} bs=1 count=5 status=none | \
    od -vAn -N5 -tu1 | \
    awk '{print ($1 % 10)($2 % 10)($3 % 10)($4 % 10)($5 % 10);}'
  else
    dd iflag=skip_bytes skip=${OFFSET} bs=1 count=5 status=none if="${RAND_SRC}" | \
    od -vAn -N5 -tu1 | \
    awk '{print ($1 % 10)($2 % 10)($3 % 10)($4 % 10)($5 % 10);}'
  fi
}


function CardBasic() {
  cat << EOF
------------------------------------------
| A  B  C  D  E  F  G  H  I  J  K  L  M  |
| 01 02 03 04 05 06 07 08 09 10 11 12 13 |
|----------------------------------------|
| N  O  P  Q  R  S  T  U  V  W  X  Y  Z  |
| 14 15 16 17 18 19 20 21 22 23 24 25 26 |
|----------------------------------------|
| 0  1  2  3  4  5  6  7  8  9 |CODE SPC |
| 30 31 32 33 34 35 36 37 38 39| 99  00  |
|----------------------------------------|
| .  ,  ?  :  ;  "  '  /  (  )  +  -  =  |
| 40 41 42 43 44 45 46 47 48 49 50 51 52 |
------------------------------------------
EOF
}

function CardStandardTableNo1() {
  cat << EOF
-----------------------------------------------------
| CODE  A    E    I    N    O    T    | STANDARD    |
|  0    1    2    3    4    5    6    | TABLE No. 1 |
|---------------------------------------------------|
|  B    C    D    F    G    H    J    K    L    M   |
|  70   71   72   73   74   75   76   77   78   79  |
|---------------------------------------------------|
|  P    Q    R    S    U    V    W    X    Y    Z   |
|  80   81   82   83   84   85   86   87   88   89  |
|---------------------------------------------------|
|  FIG  .    :    '    ()   +    -    =    REQ  SPC |
|  90   91   92   93   94   95   96   97   98   99  |
-----------------------------------------------------
EOF
}

function CardCT37() {
  cat << EOF
-----------------------------------------------------
|  E    S    T    O    N    I    A    |    CT-37    |
|  0    1    2    3    4    5    6    |             |
|---------------------------------------------------|
|  B    C    D    F    G    H    J    K    L    M   |
|  70   71   72   73   74   75   76   77   78   79  |
|---------------------------------------------------|
|  P    Q    R    U    V    W    X    Y    Z    FIG |
|  80   81   82   83   84   85   86   87   88   89  |
|---------------------------------------------------|
|  SPC  .    ,    '    ?    /    +    -    "   CODE |
|  90   91   92   93   94   95   96   97   98   99  |
-----------------------------------------------------
EOF
}

function CardCT46() {
  cat << EOF
-----------------------------------------------------
|  A    E    I    N    O    R    |      CT-46       |
|  1    2    3    4    5    6    |                  |
|---------------------------------------------------|
|  B    C    D    F    G    H    J    K    L    M   |
|  70   71   72   73   74   75   76   77   78   79  |
|---------------------------------------------------|
|  P    Q    S    T    U    V    W    X    Y    Z   |
|  80   81   82   83   84   85   86   87   88   89  |
|---------------------------------------------------|
|  SPC  .    ,    :    ?    /    (    )    "  CODE  |
|  90   91   92   93   94   95   96   97   98   99  |
|---------------------------------------------------|
|  0    1    2    3    4    5    6    7    8    9   |
|  00   01   02   03   04   05   06   07   08   09  |
-----------------------------------------------------
EOF
}

function CardCT55() {
  cat << EOF
---------------------------------------------------------
|  A    E    I    N    O    S    T   |     CT-55    |   |
|  0    1    2    3    4    5    6   |              | L |
|---------------------------------------------------| E |
|  B    C    D    F    G    H    J    K    L    M   | T |
|  70   71   72   73   74   75   76   77   78   79  | T |
|---------------------------------------------------| E |
|  P    Q    R    U    V    W    X    Y    Z    LF  | R |
|  80   81   82   83   84   85   86   87   88   89  |   |
|-------------------------------------------------------|
|  SPC CODE  RPT (.)  (,)  (')  (:)   (    )        | L |
|  90   91   92   93   94   95   96   97   98       | F |
|-------------------------------------------------------|
|  ?    !    /    +    -    *    =    ^         LF  |   |
|  80   81   82   83   84   85   86   87        89  | F |
|---------------------------------------------------| I |
|  0    1    2    3    4    5    6    7    8    9   | G |
|  00   11   22   33   44   55   66   77   88   99  |   |
---------------------------------------------------------
EOF
}

function CutCorners() {
 echo "+                               +                               +"
}

function InsertCover() {
  local sn=$(printf "%05d" $1)
  cat << EOF

  +---------------------------+   +---------------------------+
  |                           |   |                           |
  |                           |   |                           |
  |  ONE WAY ENCRYPTION PAD   |   |  ONE WAY ENCRYPTION PAD   |
  |                           |   |                           |
  |            IN             |   |           OUT             |
  |                           |   |                           |
  |         SN ${sn}          |   |         SN ${sn}          |
  |                           |   |                           |
  |                           |   |                           |
  |       S E C R E T         |   |       S E C R E T         |
  |                           |   |                           |
  |                           |   |                           |
  +---------------------------+   +---------------------------+

EOF
}

function InsertBasic() {
  cat << EOF

    |                               |
    | 0  1  2  3  4  5              | 0  1  2  3  4  5
   -+-------------------------     -+-------------------------
   0| A  K  U  0  .  +             0| A  K  U  0  .  +
   1| B  L  V  1  ,  -             1| B  L  V  1  ,  -
   2| C  M  W  2  ?  =             2| C  M  W  2  ?  =
   3| D  N  X  3  :                3| D  N  X  3  :
   4| E  O  Y  4  ;   00 SPC       4| E  O  Y  4  ;   00 SPC
   5| F  P  Z  5  "                5| F  P  Z  5  "
   6| G  Q     6  '   99 CODE      6| G  Q     6  '   99 CODE
   7| H  R     7  /                7| H  R     7  /
   8| I  S     8  (                8| I  S     8  (
   9| J  T     9  )                9| J  T     9  )

EOF
}

function InsertStdTblNo1() {
  cat << EOF

    |  LETTERS   |   | NUMBER       |  LETTERS   |   | NUMBER
    |     7   8  | 9 |  NN          |     7   8  | 9 |  NN
   -+-------------------------     -+-------------------------
   0|CODE B   P  |FIG|  0          0|CODE B   P  |FIG|  0
   1| A   C   Q  | . |  1          1| A   C   Q  | . |  1
   2| E   D   R  | : |  2          2| E   D   R  | : |  2
   3| I   F   S  | ' |  3          3| I   F   S  | ' |  3
   4| N   G   U  |() |  4          4| N   G   U  |() |  4
   5| O   H   V  | + |  5          5| O   H   V  | + |  5
   6| T   J   W  | - |  6          6| T   J   W  | - |  6
   7|     K   X  | = |  7          7|     K   X  | = |  7
   8|     L   Y  |REQ|  8          8|     L   Y  |REQ|  8
   9|     M   Z  |SPC|  9          9|     M   Z  |SPC|  9

EOF
}

function InsertCT37() {
  cat << EOF

    |  LETTERS   |                  |  LETTERS   |
    |     7   8  | 9                |     7   8  | 9
   -+-------------------------     -+-------------------------
   0| E   B   P  |SPC              0| E   B   P  |SPC
   1| S   C   Q  | .               1| S   C   Q  | .
   2| T   D   R  | ,               2| T   D   R  | ,
   3| O   F   U  | '               3| O   F   U  | '
   4| N   G   V  | ?               4| N   G   V  | ?
   5| I   H   W  | /               5| I   H   W  | /
   6| A   J   X  | +               6| A   J   X  | +
   7|     K   Y  | -               7|     K   Y  | -
   8|     L   Z  | "               8|     L   Z  | "
   9|     M  FIG |CODE             9|     M  FIG |CODE

EOF
}

function InsertCT46() {
  cat << EOF

    |  LETTERS   |    | NUM         |  LETTERS   |    | NUM
    |     7   8  | 9  | 0           |     7   8  | 9  | 0
   -+-------------------------     -+--------------------------
   0|     B   P  |SPC | 0          0|     B   P  |SPC | 0
   1| A   C   Q  | .  | 1          1| A   C   Q  | .  | 1
   2| E   D   S  | ,  | 2          2| E   D   S  | ,  | 2
   3| I   F   T  | :  | 3          3| I   F   T  | :  | 3
   4| N   G   U  | ?  | 4          4| N   G   U  | ?  | 4
   5| O   H   V  | /  | 5          5| O   H   V  | /  | 5
   6| R   J   W  | (  | 6          6| R   J   W  | (  | 6
   7|     K   X  | )  | 7          7|     K   X  | )  | 7
   8|     L   Y  | "  | 8          8|     L   Y  | "  | 8
   9|     M   Z  |CODE| 9          9|     M   Z  |CODE| 9

EOF
}

function InsertCT55() {
  cat << EOF

    |  LETTERS   |L/F |  FIG        |  LETTERS   |L/F |  FIG
    |     7   8  | 9  | 8   N       |     7   8  | 9  | 8   N
   -+-------------------------     -+------------------------- 
   0| A   B   P  |SPC | ?   0      0| A   B   P  |SPC | ?   0
   1| E   C   Q  |CODE| !   1      1| E   C   Q  |CODE| !   1
   2| I   D   R  |RPT | /   2      2| I   D   R  |RPT | /   2
   3| N   F   U  |(.) | +   3      3| N   F   U  |(.) | +   3
   4| O   G   V  |(,) | -   4      4| O   G   V  |(,) | -   4
   5| S   H   W  |(') | *   5      5| S   H   W  |(') | *   5
   6| T   J   X  |(:) | =   6      6| T   J   X  |(:) | =   6
   7|     K   Y  | (  | ^   7      7|     K   Y  | (  | ^   7
   8|     L   Z  | )  |     8      8|     L   Z  | )  |     8
   9|     M  L/F |    | L/F 9      9|     M  L/F |    | L/F 9

EOF
}

function InsertCard() {
  local n=$(printf "%05d" $1)
  local pad=()

  for i in $(seq 1 50)
  do
    pad+=($(Generate5))
    OFFSET=$((${OFFSET} + 5))
  done

  cat << EOF

             IN ${n}                       OUT ${n}

  ${pad[0]} ${pad[1]} ${pad[2]} ${pad[3]} ${pad[4]}   ${pad[0]} ${pad[1]} ${pad[2]} ${pad[3]} ${pad[4]}
  ${pad[5]} ${pad[6]} ${pad[7]} ${pad[8]} ${pad[9]}   ${pad[5]} ${pad[6]} ${pad[7]} ${pad[8]} ${pad[9]}
  ${pad[10]} ${pad[11]} ${pad[12]} ${pad[13]} ${pad[14]}   ${pad[10]} ${pad[11]} ${pad[12]} ${pad[13]} ${pad[14]}
  ${pad[15]} ${pad[16]} ${pad[17]} ${pad[18]} ${pad[19]}   ${pad[15]} ${pad[16]} ${pad[17]} ${pad[18]} ${pad[19]}
  ${pad[20]} ${pad[21]} ${pad[22]} ${pad[23]} ${pad[24]}   ${pad[20]} ${pad[21]} ${pad[22]} ${pad[23]} ${pad[24]}
  ${pad[25]} ${pad[26]} ${pad[27]} ${pad[28]} ${pad[29]}   ${pad[25]} ${pad[26]} ${pad[27]} ${pad[28]} ${pad[29]}
  ${pad[30]} ${pad[31]} ${pad[32]} ${pad[33]} ${pad[34]}   ${pad[30]} ${pad[31]} ${pad[32]} ${pad[33]} ${pad[34]}
  ${pad[35]} ${pad[36]} ${pad[37]} ${pad[38]} ${pad[39]}   ${pad[35]} ${pad[36]} ${pad[37]} ${pad[38]} ${pad[39]}
  ${pad[40]} ${pad[41]} ${pad[42]} ${pad[43]} ${pad[44]}   ${pad[40]} ${pad[41]} ${pad[42]} ${pad[43]} ${pad[44]}
  ${pad[45]} ${pad[46]} ${pad[47]} ${pad[48]} ${pad[49]}   ${pad[45]} ${pad[46]} ${pad[47]} ${pad[48]} ${pad[49]}

        DESTROY AFTER USE               DESTROY AFTER USE

EOF
}

function Version() {
  >&2 echo "padgen.sh Version ${VERSION}"
}

function Usage() {
  cat << EOF
usage: padgen.sh [OPTIONS]

    -h, --help    Display this info

    -v, --version Display version number

  Checkerboard

    -cb TYPE      Print Checkerboard

        Types:
            Basic    Basic board with no condensed letters.
                     Two numbers per character, Code, Space
                     and 12 punctuation.

            StdTbl   Standard Table No. 1. 6 condensed characters
                     7 punctuation. Numbers enabled using FIG and
                     questions enabled using REQ.

            CT37     CT-37

            CT46     CT-46

            CT55     CT-55

  Pad

    -p, --pad     Print One Time Pads, additional options

    -f FILE       Source of random data. Stdin set with "-"
                  and defaults to /dev/urandom.

    -sn NUM       Serial Number. This define the id for the
                  entire pad. Default 0.

    -idx NUM      Index. This defines the id of an individual
                  page. Each new page increments. Default 0

    -cnt NUM      Count. This defines the number of pages to
                  include in the pad. Default 1.

    -t            Disable title card

    -cb TYPE      Insert a small Checkerboard into each set of
                  cards.

EOF
}

function UsageExit() {
  Usage
  exit 1
}

function ErrExit() {
  >&2 echo "$1"
  exit 1
}

# MAIN
VERSION=0.1

RAND_SRC=/dev/urandom
CB_TYPE=None
PAD=0
SN=0
IDX=0
CNT=1
TITLE=1
OFFSET=0

while [[ $# > 0 ]]
do
  case $1 in
    -h|--help)
      Usage
      exit 0
      ;;

    -v|--version)
      Version
      exit 0
      ;;

    -cb)
      [[ $# > 1 ]] || UsageExit
      case $2 in
        Basic|StdTbl|CT37|CT46|CT55)
          CB_TYPE=$2
          shift
          ;;
        *)
          ErrExit "Unsupported Checkerboard: $2"
          ;;
      esac
      ;;

    -p|--pad)
      PAD=1
      ;;

    -sn)
      [[ $# > 1 ]]  &&
      [[ $2 =~ ^[0-9]+$ ]] || UsageExit
      SN=$2
      shift
      ;;

    -idx)
      [[ $# > 1 ]] || UsageExit
      [[ $2 =~ ^[0-9]+$ ]] || UsageExit
      IDX=$2
      shift
      ;;

    -cnt)
      [[ $# > 1 ]] || UsageExit
      [[ $2 =~ ^[0-9]+$ ]] || UsageExit
      CNT=$2
      shift
      ;;

    -t)
      TITLE=0
      ;;

    -f)
      [[ $# > 1 ]] || UsageExit
      if [[ "$2" == "-" ]] || [[ -e "$2" ]]
      then
        RAND_SRC="$2"
      else
        ErrExit "Filed Not Found: $2"
      fi
      shift
      ;;


    *)
      ErrExit "Unknown flag: $1"
      ;;
  esac
  shift
done

if [[ ${PAD} -eq 0 ]]
then
  case ${CB_TYPE} in
    Basic)
      CardBasic
      ;;
    StdTbl)
      CardStandardTableNo1
      ;;
    CT37)
      CardCT37
      ;;
    CT46)
      CardCT46
      ;;
    CT55)
      CardCT55
      ;;
    *)
      Usage
  esac
  exit 0
else
  CutCorners
  [[ ${TITLE} -eq 0 ]] || InsertCover ${SN}
  CutCorners

  case ${CB_TYPE} in
    Basic)
      InsertBasic
      CutCorners
      ;;
    StdTbl)
      InsertStdTblNo1
      CutCorners
      ;;
    CT37)
      InsertCT37
      CutCorners
      ;;
    CT46)
      InsertCT46
      CutCorners
      ;;
    CT55)
      InsertCT55
      CutCorners
      ;;
  esac

  for i in $(seq 1 ${CNT})
  do
    InsertCard $((${IDX} + ${CNT} - $i))
    CutCorners
  done
fi

