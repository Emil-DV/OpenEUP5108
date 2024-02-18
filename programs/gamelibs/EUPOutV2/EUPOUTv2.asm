#######################################################
## EUPOUT - "Breakout clone" Video Game
#######################################################

# Screen should be clear
D EUPOUT
#  HLT
  NOP
  
  LDR VTCLR
  CAL printStr1E

  LDR VTHOME
  CAL printStr1E
  
D CmdLoop
  W1E 0xDB
  W1E 'BS
  CAL getCharB  
  # If character is w,a,s,d then move cursor
  LAE 'w
  MAB
  JLN CmdLoop.nw
  #W1E 'SP
  #W1E 'BS
  LDR VTUP
  CAL printStr1E
  JPL CmdLoop

D CmdLoop.nw  
  LAE 'a
  MAB
  JLN CmdLoop.na
  #W1E 'SP
  #W1E 'BS
  LDR VTLEFT
  CAL printStr1E
  JPL CmdLoop

D CmdLoop.na
  LAE 's
  MAB
  JLN CmdLoop.ns
  #W1E 'SP
  #W1E 'BS
  LDR VTDWN
  CAL printStr1E
  JPL CmdLoop

D CmdLoop.ns
  LAE 'd
  MAB
  JLN CmdLoop.nd
  #W1E 'SP
  #W1E 'BS
  LDR VTRIGHT
  CAL printStr1E
  JPL CmdLoop
  
  # If character is q then exit game
D CmdLoop.nd
  LAE 'q
  MAB
  JLN CmdLoop.nq

  LDR VTCLR
  CAL printStr1E

  LDR VTHOME
  CAL printStr1E
  
  LDR VTRST
  CAL printStr1E

  RTL
  
  # If character is c then clear screen
D CmdLoop.nq
  LAE 'c
  MAB
  JLN CmdLoop.nc

  LDR VTCLR
  CAL printStr1E

  LDR VTHOME
  CAL printStr1E

  JPL CmdLoop
  
  # If character is 1 then change fg color
D CmdLoop.nc
  LAE '1
  MAB
  JLN CmdLoop.n1
  CAL setFGColorB
  JPL CmdLoop

D CmdLoop.n1
  LAE '2
  MAB
  JLN CmdLoop.n2
  CAL setFGColorB
  JPL CmdLoop

D CmdLoop.n2
  LAE '3
  MAB
  JLN CmdLoop.n3
  CAL setFGColorB
  JPL CmdLoop

D CmdLoop.n3
  LAE '4
  MAB
  JLN CmdLoop.n4
  CAL setFGColorB
  JPL CmdLoop

D CmdLoop.n4
  LAE '5
  MAB
  JLN CmdLoop.n5
  CAL setFGColorB
  JPL CmdLoop

D CmdLoop.n5
  LAE '6
  MAB
  JLN CmdLoop.n6
  CAL setFGColorB
  JPL CmdLoop

D CmdLoop.n6
  LAE '7
  MAB
  JLN CmdLoop.n7
  CAL setFGColorB
  JPL CmdLoop

D CmdLoop.n7
  LAE '0
  MAB
  JLN CmdLoop
  CAL setFGColorB
  JPL CmdLoop



D setFGColorB  
  W1E 'ESC
  W1E '[
  W1E '9
  W1B
  W1E 'm
  W1E 'ESC
  RTL
  