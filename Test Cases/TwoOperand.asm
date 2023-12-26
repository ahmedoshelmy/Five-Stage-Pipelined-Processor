# all numbers in hex format
# we always start by reset signal
# this is a commented line

#you should ignore empty lines

in   R1       #add 5 in R1
in   R2       #add 19 in R2
in   R3       #FFFD
in   R4       #F320
ADDI R5,R3,2  #R5 = FFFF , flags no change
ADD  R4,R1,R4    #R4= F325 , C-->0, N-->1, Z-->0
SUB  R6,R5,R4    #R6= 0CDA , C-->1, N-->0,Z-->0  // R6 = R5 - R4
AND  R6,R7,R6    #R6= 00000000 , C-->no change, N-->0, Z-->1
OR   R1,R2,R1    #R1=1D  , C--> no change, N-->0, Z--> 0
RCL  R2,2     #R2=66  , C--> 0, N -->0 , Z -->0
RCR  R2,3     #R2=8000000C  , C -->1, N-->0 , Z-->0
SWAP R2,R5    #R5=8000000C ,R2=FFFF  ,no change for flags
ADD  R2,R5,R2    #R2= 8001000B
BITSET R2, 2     #R2= 8001000F, no change for flags
XOR R1,R1,R1     #R1=00000000, Z=1