#********************************************************************
#	File Name		: Makefile 	    	
#	Author			: Cheng_Qingdong
#	Copyright 1992-2013, ZheJiang Dahua Technology Stock Co.Ltd.
# 						All Rights Reserved
#
#	Description		: for Carlogo recognization
#	Created			: 2014/09/23  14:08
#	Changelog		: (date:author:modify sth)
#
#*********************************************************************

CROSS	= 
# Compilation Tools
CC	= $(CROSS)gcc
XX	= $(CROSS)g++
LD	= $(CROSS)g++
AR	= $(CROSS)ar
AS	= $(CROSS)as
RM 	= rm -f
CP	= cp -r

LIB_TARGET	=vec
DEMO_TARGET	=demo_test 

INSTALL_DIR=./lib/linux
LOCAL_PATH = $(shell pwd)

# Q1 BITS未传进时，默认为32位，传进来时，定义为传进值
#BITS	= 64
debug:=1
LDFLAGS	= -lm -L$(INSTALL_DIR) -l$(LIB_TARGET)
#LDFLAGS	+= -e main #ld来链接时，指定入口函数

ifeq ($(BITS),32)
	CFLAGS_COMMON	+= -m32
	LDFLAGS	+= -m32
	#LDFLAGS	+= -melf_i386 #使用ld链接时指定链接的是32位库:
endif

# 1. 优化级别
ifeq ($(debug), 1)
	CFLAGS_COMMON += -g3
else
	CFLAGS_COMMON += -O3
endif

# 2. 宏定义
# .c
#CFLAGS_COMMON += -D_LINUX_ -DM_DCODE_SYNC=1 -D_TARGET_X86_
CFLAGS_COMMON += -fPIC

# .cpp
CXXFLAGS +=

# 3. AR Options
ARFLAGS	= crus

# 指定源文件、头文件、库路径
# lib_src
vpath %.c 

vpath %.cpp	

# demo_src
vpath %.cpp

# 5. 输出变量


# 6. 头文件路径
# .c

INC_DIR	+=	-I.			\
			-I./src/



# 7. 库的源文件、obj
C_SRCS		:=./src/addvec.c
CXX_SRCS	:=


C_OBJS	= $(patsubst %.c,%.o, $(C_SRCS))
CXX_OBJS	= $(patsubst %.cpp,%.o, $(CXX_SRCS))

# 8. demo的源目录、obj
DEMO_C_SRCS  =./src/main.c 
DEMO_C_OBJS  = $(patsubst %.c, %.o,$(DEMO_C_SRCS))

DEMO_CXX_SRCS	= 
DEMO_CXX_OBJS	= $(patsubst %.cpp,%.o, $(DEMO_CXX_SRCS))

# 9. 默认的输出
all: mk_file_dir dll install exe

# 10. 库的生成
dll : $(C_OBJS) $(CXX_OBJS)
	$(CXX) $^  -o lib$(LIB_TARGET).so --shared

lib : $(C_OBJS) $(CXX_OBJS)
	$(AR) $(ARFLAGS) lib$(LIB_TARGET).a $^

install:                                                                                                                                                             
	$(CP) lib$(LIB_TARGET).so  $(INSTALL_DIR)/                                                                                                                       
	#$(CP) lib$(LIB_TARGET).a   $(INSTALL_DIR)/

exe: $(DEMO_C_OBJS) $(DEMO_CXX_SRCS)
	$(LD)  $^ -o $(DEMO_TARGET) $(LDFLAGS) 


mk_file_dir:
		mkdir -p $(INSTALL_DIR)

$(CXX_OBJS): %.o: %.cpp
	$(CXX) -c $(CFLAGS_COMMON)	$(INC_DIR) $(CXXFLAGS)  -o $@ $<

$(C_OBJS): %.o: %.c
	$(CC) -c $(CFLAGS_COMMON)	$(INC_DIR) $(CFLAGS)  -o $@ $<
	
# 11. demo生成
$(DEMO_CXX_OBJS): %.o: %.cpp
	$(CXX) -c $(CXXFLAGS)  -o $@ $<

$(DEMO_C_OBJS): %.o: %.c
	$(CC) -c $(CFLAGS_COMMON)	$(INC_DIR) $(CFLAGS)  -o $@ $<
	
# 12. 创建目录
.phony:build
	#
# 13. 清理
clean:
	$(RM) $(C_OBJS)  $(CXX_OBJS) $(DEMO_C_OBJS)  $(DEMO_CXX_OBJS)
	$(RM) lib$(LIB_TARGET).so lib$(LIB_TARGET).a
	$(RM) $(DEMO_TARGET) 
	
# 14. 打印消息
print:
	echo $(C_SRCS)
	echo $(C_OBJS) $(CXX_OBJS)
	echo $(CFLAGS)
	echo $(CXXFLAGS)
