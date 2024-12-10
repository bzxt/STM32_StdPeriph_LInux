# 设置 vpath 查找路径
vpath %.c ./Myfiles/src ./Library/StdPeriph_Driver/src ./User
vpath %.s ./CMSIS

# 头文件目录
INCLUDE = ./Myfiles/inc ./Library/StdPeriph_Driver/inc ./User ./CMSIS

# 获取所有的 .c 文件
C_PATH = $(wildcard ./Myfiles/src/*.c ./Library/StdPeriph_Driver/src/*.c ./User/*.c)

# 去掉路径，只保留文件名
C_SRC = $(notdir $(C_PATH))

# 单独设置 startup.s 文件
S_SRC = startup_stm32f40_41xxx.s

# 设置临时文件夹目录
TEMPDIR = Temp

# 编译生成的 .o 文件
OBJS = $(C_SRC:%.c=$(TEMPDIR)/%.o)
OBJS += $(S_SRC:%.s=$(TEMPDIR)/%.o)

# 目标文件
TARGET = stm32_app.elf

# 编译器及标志
CC = arm-none-eabi-gcc
CPUFLAGS = -mcpu=cortex-m4 -mthumb
LDFLAGS = $(CPUFLAGS) -T STM32F4.ld -Wl,--gc-sections
ASFLAGS = $(CPUFLAGS) -O1 -g
CFLAGS = $(CPUFLAGS) -O1 -g -ffunction-sections -fdata-sections

# 添加宏定义到 CFLAGS
CFLAGS += -DSTM32F40_41xxx
CFLAGS += -DUSE_STDPERIPH_DRIVER

# 将头文件路径添加到 CFLAGS
CFLAGS += $(addprefix -I, $(INCLUDE))

# 默认目标
all : $(TARGET)

# 链接目标文件
$(TARGET) : $(OBJS)
	$(CC) $(LDFLAGS) -o $(TARGET) $(OBJS)

# 编译 .c 文件到 .o 文件
$(TEMPDIR)/%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

# 编译 .s 文件到 .o 文件
$(TEMPDIR)/%.o : %.s
	$(CC) $(ASFLAGS) -c $< -o $@

# 生成依赖文件
$(TEMPDIR)/%.d : %.c
	$(CC) $(CFLAGS) -MM $< > $@

$(TEMPDIR)/%.d : %.s
	$(CC) $(ASFLAGS) -MM $< > $@

# 包含依赖文件（可选）
-include $(OBJS:.o=.d)

# 清理命令
.PHONY : clean
clean :
	rm -f $(TEMPDIR)/*.o $(TEMPDIR)/*.d 

# 确保目标目录存在
#$(TEMPDIR):
#	mkdir -p $(TEMPDIR)

