#########################################################################
# File Name:    Download.sh
# Author:       BZXT
# mail:         15537262582@163.com
# Created Time: Tuesday, December 10, 2024 PM10:25:51
#########################################################################
#!/bin/bash

# 使用 openocd 工具将程序烧录进 STM32
openocd -f interface/stlink.cfg -f target/stm32f4x.cfg -c "program stm32_app.elf verify reset exit"

