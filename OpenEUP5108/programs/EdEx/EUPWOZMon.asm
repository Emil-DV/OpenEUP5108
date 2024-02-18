#-------------------------------------------------------------------------
#
#  The WOZ Monitor for the EUP 5108
#  Re-Written by Emil DeVries 2023
#  Original by Steve Wozniak 1976 for the Apple 1
#
#-------------------------------------------------------------------------
#  The WOZ monitor was a simple memory read/write capibility
#  Cursor '\'
#  Read Memory by entering an address:
#  \3F <e>
#  003F: F0

#  \23AB <e>
#  23AB: FE

#  To read additional bytes enter '.' and the end address
#  \.23AF <e>
#  23AC: ED AB 19 69

#  You can combine these commands to read a range
#  \4E.59
#  004E: 0F 76 
#  0050: 00 01 02 03 04 05 06 07
#  0058: 08 09 

#  Or read a combination of locations and ranges
#  \3F 23AB 4E.59
#  003F: F0
#  23AB: FE
#  004E: 0F 76 
#  0050: 00 01 02 03 04 05 06 07
#  0058: 08 09 

# I'd rather do my own of \AddressTypechar
# \3F <enter> = no type character or space = 1 byte
# 003F: F0

# \3F.<enter> = '.' type = 2 bytes
# 003F: F0 0D

# \3F&<enter> = '&' type = 4 bytes
