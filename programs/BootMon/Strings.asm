#######################################################
## BootMon String table
#######################################################

#######################################################
D HelpMessage                                       
S ?-This Message\n
S m-Memory\n
S d-Display hex characters\n
S a-ASCII Table\n
S g-Etch-n Game\n
S s-Play hex Tones val*100hz\n
S v-Echo a VT Escape Code\n\0

#######################################################
D Prompt                                    
S EUP:>\0 

#######################################################
D MemoryHelp   
S \n[m]meory read/write\n                                 
S rXXXX Prints one line (16 bytes) starting at hex addr XXXX\n
S wXXXX[xx][....] Write xx values [...] starting at hex addr XXXX\n\0 

#######################################################
D strHelloWorld
S Hello World!\n\n\0


