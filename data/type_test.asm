KEYSET :keypressed
JMP #0000
:keypressed
MOV RD RA

MOV RA #0041
JMPE :A
MOV RA #0042
JMPE :B
MOV RA #0043
JMPE :C
MOV RA #0044
JMPE :D
MOV RA #0045
JMPE :E
MOV RA #0046
JMPE :F
MOV RA #0047
JMPE :G
MOV RA #0048
JMPE :H
MOV RA #0049
JMPE :I
MOV RA #004A
JMPE :J
MOV RA #004B
JMPE :K
MOV RA #004C
JMPE :L
MOV RA #004D
JMPE :M
MOV RA #004E
JMPE :N
MOV RA #004F
JMPE :O
MOV RA #0050
JMPE :P
MOV RA #0051
JMPE :Q
MOV RA #0052
JMPE :R
MOV RA #0053
JMPE :S
MOV RA #0054
JMPE :T
MOV RA #0055
JMPE :U
MOV RA #0056
JMPE :V
MOV RA #0057
JMPE :W
MOV RA #0058
JMPE :X
MOV RA #0059
JMPE :Y
MOV RA #005A
JMPE :Z
MOV RA #0020
JMPE :SPACE
MOV RA #0008
JMPE :BACKSPACE
MOV RA #0031
JMPE :EXCLAMATION_POINT
MOV RA #002E
JMPE :PERIOD
MOV RA #002C
JMPE :COMMA
JMP #0000
:A
PSHCHR 'A'
MOV RD #01B8
JMP #0000
:B
PSHCHR 'B'
MOV RD #01ED
JMP #0000
:C
PSHCHR 'C'
MOV RD #020B
JMP #0000
:D
PSHCHR 'D'
MOV RD #024B
JMP #0000
:E
PSHCHR 'E'
MOV RD #0293
JMP #0000
:F
PSHCHR 'F'
MOV RD #02BA
JMP #0000
:G
PSHCHR 'G'
MOV RD #030F
JMP #0000
:H
PSHCHR 'H'
MOV RD #0370
MOV 13 FFF0
JMP #0000
:I
PSHCHR 'I'
MOV RD #03DB
JMP #0000
:J
PSHCHR 'J'
MOV RD #0416
JMP #0000
:K
PSHCHR 'K'
MOV RD #0496
JMP #0000
:L
PSHCHR 'L'
MOV RD #0526
JMP #0000
:M
PSHCHR 'M'
MOV RD #0574
JMP #0000
:N
PSHCHR 'N'
MOV RD #061F
JMP #0000
:O
PSHCHR 'O'
MOV RD #06E0
JMP #0000
:P
PSHCHR 'P'
MOV RD #07B7
JMP #0000
:Q
PSHCHR 'Q'
MOV RD #082D
JMP #0000
:R
PSHCHR 'R'
MOV RD #092D
JMP #0000
:S
PSHCHR 'S'
MOV RD #01B8
JMP #0000
:T
PSHCHR 'T'
MOV RD #01B8
MOV 13 FFF0
JMP #0000
:U
PSHCHR 'U'
MOV RD #01B8
JMP #0000
:V
PSHCHR 'V'
MOV RD #01B8
JMP #0000
:W
PSHCHR 'W'
MOV RD #01B8
JMP #0000
:X
PSHCHR 'X'
MOV RD #01B8
MOV 13 FFF0
JMP #0000
:Y
PSHCHR 'Y'
MOV RD #01B8
JMP #0000
:Z
PSHCHR 'Z'
MOV RD #01B8
JMP #0000
:SPACE
PSHCHR ' '
JMP #0000
:BACKSPACE
POPCHR
MOV RD #0000
JMP #0000
:EXCLAMATION_POINT
PSHCHR '!'
JMP #0000
:PERIOD
PSHCHR '.'
JMP #0000
:COMMA
PSHCHR ','
JMP #0000
