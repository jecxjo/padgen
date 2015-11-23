# padgen
Printable One Time Pad generatator written in BASH.

Using your system's random number generator (which should be a hardware, true
random number generator) or a source file, padgen can create simple printable
one time pads.

Most of the output is similar to [Numbers][1] without the need to install
Windows or Wine. Just need BASH and RNG source.

# Checkerboards

padgen can generate checkboard layouts both in a larger format:

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

as well as in a one time pad printout:

    +                               +
   
        |  LETTERS   |   | NUMBER    
        |     7   8  | 9 |  NN       
       -+-------------------------   
       0|CODE B   P  |FIG|  0        
       1| A   C   Q  | . |  1        
       2| E   D   R  | : |  2        
       3| I   F   S  | ' |  3        
       4| N   G   U  |() |  4        
       5| O   H   V  | + |  5        
       6| T   J   W  | - |  6        
       7|     K   X  | = |  7        
       8|     L   Y  |REQ|  8        
       9|     M   Z  |SPC|  9        
    
    +                               +

Pads generated with page numbers, both in and out copies in a run. Cut down the middle and give the IN to the sender and OUT to the receiver.

# Usage

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
    

# Instructions

**TODO:** Make this section better

1. Print Pad, cut in half. IN is used to encrypt and OUT is used to decrypt.
2. Using an agreed upon checkerboard, convert your Clear text to a sequence of numbers.
3. In groups of 5 characters, line up Clear Text and Pad.

    Clear:   12345 67890
    Pad:     01928 49285

4. To encrypt subtract Pad from Clear Text without borrowing (5 - 9 = 6, not 15 - 9)

      Clear:   12345 67890
    - Pad:     01928 49285
    ---------------------
    Cipher:    11427 28515

5. To decrypt add Pad to Cipher without carring (6 + 9 = 5, not 15)

      Cipher:  11427 28515
    + Pad:     01928 49285
    ---------------------
    Clear:     12345 67890

6. First 5 digits of Cipher text should be the Page Number of the pad used. Be
sure to destroy it after use.

      00001 11427 28515
      -----------------
      Page# Cipher.....

# Good Practices

Be sure to use a good RNG source. For example a [Raspberry Pi's Hardware RNG][2]
or a USB Hardware RNG.

Make sure to keep all outputs from this script either in files on a `tempfs` partition or pipe all output directly to your printer so no copy ever is written to disk.

    ./padgen.sh -p | lp

**NEVER** reuse a pad. Print one copy, cut it and distribute. When you use
a page to encrypt, destroy it once you are done encrypting. If you do not use
the entire page...still destroy it.

Always encrypt with the `IN` pad and always decrypt with the `OUT` pad. For two
people to communicate this means you need to print out two different pads.
Person A's IN pad matches person B's OUT pad. This way if both are sending
messages there should be no accidental reuse of any pad since each one only has
an IN or an OUT from a given pad, but not both.

[1]: http://users.telenet.be/d.rijmenants/en/numbersgen.htm
[2]: https://wiki.gentoo.org/wiki/Raspberry_Pi/Quick_Install_Guide#Hardware_Random_Number_Generator
