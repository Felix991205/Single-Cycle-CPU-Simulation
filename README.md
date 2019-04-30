# Single Cycle CPU simulation

### 提供者

武汉大学
2017级计算机科学与技术8班
张鉴鼎

### 仿真环境

Mars
Modelsim
Vivado

### 文件说明

本单周期CPU仿真工程源文件包含以下内容

顶层设计文件：
+ Mips.v

元件设计文件：
+ Alu.v     （算术逻辑运算单元）
+ clk_div.v （时钟分频单元）
+ Ctrl.v    （控制单元）
+ Extender.v（位数拓展单元）
+ GPR.v     （寄存器组单元）
+ PcUnit.v  （PC单元）
+ seg7x16.v  (数码显示管单元)

指令及控制信号定义文件
+ ctrl_encode_def.v （控制信号定义）
+ instruction_def.v

存储设计文件：
+ DMem.v    （数据存储单元，初始排序数据写在initial部分）
+ IM（IM由vivado提供的ip封装自动生成，其中位宽为32位，共有1024个存储单元，利用mips.coe进行初始化）

指令文件
+ mips.asm  (可在Mars上执行的asm排序文件)
+ mips.coe （用于Vivado中IM的初始化）
+ mips.txt （用于Modelsim中提供指令序列）
  



  