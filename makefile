#工程根目录 请勿修改
PROJ_ROOT_DIR=$(shell pwd)
#制定编译器
CC=g++
#可执行目标文件名
TARGET=marswater
#可执行文件输出目录
EXE_DIR=$(PROJ_ROOT_DIR)/bin
#添加中间文件生产目录
OBJS_DIR=$(PROJ_ROOT_DIR)/objs
#添加C源文件目录
C_SRC_DIR+=$(PROJ_ROOT_DIR)/src

#添加C++源文件目录
CPP_SRC_DIR+=$(PROJ_ROOT_DIR)/src


#添加头文件路径
INCLUDE+=$(PROJ_ROOT_DIR)/inc/

#将头文件目录前加上-I前缀 为编译器产生头文件搜索路径
CFLAGS=-Wall 
CFLAGS+=$(foreach n,$(INCLUDE),$(addprefix -I,$(n)))

#添加汇编源文件目录
ASM_SRC_DIR+=$(PROJ_ROOT_DIR)

#构建VPATH变量，该变量将为编译器生产源文件搜索路径
VPATH+=$(foreach n,$(C_SRC_DIR),$(addsuffix :,$(n)))
VPATH+=$(foreach n,$(CPP_SRC_DIR),$(addsuffix :,$(n)))
VPATH+=$(foreach n,$(ASM_SRC_DIR),$(addsuffix :,$(n)))

#产生所有.c文件集合
C_SRC+=$(foreach n,$(C_SRC_DIR),$(wildcard $(n)/*.c))
#产生所有.cpp文件集合
CPP_SRC+=$(foreach n,$(CPP_SRC_DIR),$(wildcard $(n)/*.cpp))
#产生所有.S文件集合
ASM_SRC+=$(foreach n,$(ASM_SRC_DIR),$(wildcard $(n)/*.S))

#产生目标文件集合
C_OBJS=$(patsubst %.c,%.o,$(notdir $(C_SRC)))
CPP_OBJS=$(patsubst %.cpp,%.o,$(notdir $(CPP_SRC)))
ASM_OBJS=$(patsubst %.S,%.o,$(notdir $(ASM_SRC)))

#声明为目标
.PHONIY: clean rebuild build usage

usage:
	@echo "  usage:"
	@echo "      make build : build this project!"
	@echo "      make rebuild : rebuild this project!"
	@echo "      make clean : clean this project!"

#第一个目标
rebuild:
	make clean
	make $(TARGET)
	
build:
	make $(TARGET)

#编译工程  采用自动推导方式
$(TARGET):$(C_OBJS) $(CPP_OBJS) $(ASM_OBJS)
	$(CC) $(OBJS_DIR)/*.o -o $(EXE_DIR)/$@ $(CFLAGS)

$(C_OBJS):%.o:%.c
	$(CC) -c $< -o $(OBJS_DIR)/$@ $(CFLAGS)
$(CPP_OBJS):%.o:%.cpp
	$(CC) -c $< -o $(OBJS_DIR)/$@ $(CFLAGS)
$(ASM_OBJS):%.o:%.S
	$(CC) -c $< -o $(OBJS_DIR)/$@ $(CFLAGS)
		
clean:
	rm -rf $(EXE_DIR)/*
	rm -rf $(OBJS_DIR)/*
