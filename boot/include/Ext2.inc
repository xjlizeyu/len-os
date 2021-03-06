; -----------------------------------------------------------------------------------
; 记录Ext2文件系统相关参数
; 在写入boot和了loader之前需要使用linux下指令mkfs.ext2将镜像文件格式化为ext2格式
; -----------------------------------------------------------------------------------

;   超级块的物理位置
SuperBlock_LBA_L	equ 02h	  ;超级块 磁盘地址(1 Kb)
SuperBlock_LBA_H	equ 00h

;   GroupDescriptors的物理位置
GroupDescriptors_LBA_L      equ 04h
GroupDescriptors_LBA_H      equ 00h

; 记录目录项中的数据结构偏移
Inode_Number_Offset    equ 0
Record_Length_Offset   equ 4
Name_Len_Offset    equ 6
File_Type_Offset   equ 7
File_Name_Offset   equ 8