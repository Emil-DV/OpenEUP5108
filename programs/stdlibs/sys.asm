#$---- 
#$##  stdlibs/sys.asm
#$     System constants and memory mapped I/O
#$
C sys.topline 6      # 1 based
C sys.cursorChar 0x5F
C sys.scrwidth 80
C sys.scrheight 25

# The realtime clock resides at address 0x00..0x08
# and contains the clock in binary bytes in the format

# Year: years since 2000 - Year 2255 no problem for me
# Month: 1..12
# Day: 1..31
# Hour: 0..23   24 Hour format is just easier
# Minute: 0..59
# Second: 0..59
# msec (2 bytes) 0..999

# OR...

#$    The realtime clock resides at address 0x00..0x0F
#$    and contains the clock in two strings in the format
#$    YYMMDD\0HHMMSS\0
#$    With the YY being years since 2000 - it will have the year
#$    2100 problem - but I won't
#$
#$    Followed by the two byte value of the current mS in binary

# The reasoning here is that I am not likely to do datetime
# calculations and need it mostly for on screen display
# The mSec is a convient fast turn over value for seeding rand
A 00
V RTCDate  # Date string
a 0x06
V RTCTrigger # Set to 1 to get local, 2 for GMT
a 0x01
V RTCTime  # Time string
a 0x07
V RTCmSec  # mSec in short
a 0x02

A 0x020
# The random number generator resides after the clock
# and contains a range, seed, and produced values
V PRNSeed  # Normally 0x00 write a value to trigger
a 1	   # reseeding using the clock
V PRNRange # Normally 0x00 write a value to trigger
a 1
V PRNValue # The new value
a 1

A 0x100    # Move the ADA so all other vars start beyond 
           # The I/O memory map area

#$ Syscall (execute function on emulator's host)

# int socket(int domain, int type, int protocol);
C sysSockSocket	0x00
# domain := AF_INET, protocol := 0, type = SOCK_STREAM (TCP) || SOCK_DGRAM (UDP)

# ssize_t send(int sockfd, const void *buf, size_t len, int flags);
C sysSockSend	0x01

# ssize_t write(int fd, const void *buf, size_t count); // Alternative to send
C sysSockWrite	0x02

# ssize_t recv(int sockfd, void *buf, size_t len, int flags);
C sysSockRecv	0x03

# ssize_t read(int fd, void *buf, size_t count); // Alternative to recv
C sysSockRead	0x04

# int close(int fd);
C sysSockClose	0x05

# int shutdown(int sockfd, int how);
C sysSockShutdown	0x06

# int setsockopt(int sockfd, int level, int optname, const void *optval, socklen_t optlen);
C sysSockSetsockopt	0x07

# int getsockopt(int sockfd, int level, int optname, void *optval, socklen_t *optlen);
C sysSockGetsockopt	0x08

# // Server-Side Specific APIs

# int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
C sysSockBind	0x09

# int listen(int sockfd, int backlog);
C sysSockListen	0x0A

# int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
C sysSockAccept	0x0B

# // Client-Side Specific API

# int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
C sysSockConnect	0x0C
# // Helper functions (for address manipulation and byte order)

# These could be defined as passing the * to the param in DR with the swapping happening in place
# uint16_t htons(uint16_t hostshort);
# uint32_t htonl(uint32_t hostlong);
# uint16_t ntohs(uint16_t netshort);
# uint32_t ntohl(uint32_t netlong);

# int inet_pton(int af, const char *src, void *dst);
C sysSockInet_pton	0x0D

# const char *inet_ntop(int af, const void *src, char *dst, socklen_t size);
C sysSockInet_ntop	0x0E

# int getaddrinfo(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res);
C sysSockGetaddrinfo	0x0F

# void freeaddrinfo(struct addrinfo *res);
C sysSockFreeaddrinfo	0x10

V syscallmake
a 1
V syscallnum
a 1
V syscallRtn
a 4
V syscallCmd
a 4
V syscallParam
a 4
V syscallData
a 0x400

# Plan, set syscallnum, cmd, param, data as needed for the call then set syscallmake to 1
#       wait for syscallmake to return to 0
#       read return value from syscallRtn






           

