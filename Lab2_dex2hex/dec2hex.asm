.386
.model flat,stdcall
option casemap :none
include \masm32\include\windows.inc
include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data
ask_str BYTE "Please input a decimal number(0~4294967295):",0
;存放要输出的询问字符串
output_str BYTE "The hexdecimal number is:",0
;存放要输出的回答字符串
var BYTE 12 DUP(?) ;存放输入的ASCII码
confirmed_10d DWORD 10d
lpHexString BYTE"0123456789ABCDEFF"
answ BYTE 8 DUP(?) ;保存答案的一段内存

.code
dec2dw proc ;以下为过程dec2dw
mov eax,0h
mov esi,0h

L1:
sub var[esi],30h ;减去30h，转为二进制数
movzx edx,var[esi] ;将二进制数存在edx中
add eax,edx ;二进制数加到eax上
inc esi
cmp var[esi],0d ;若ebx为0，则进入L4
je EXIT1
mul confirmed_10d ;eax中的二进制数*10d以便加上下一个二进制数
jmp L1

EXIT1:RET
dec2dw endp

dw2hex_my proc ;以下为过程dw2hex_my
mov ecx,8h
mov edi,0h

L3:
mov esi,eax
and esi,0F0000000h
shr esi,28
movzx edx,byte ptr[lpHexString+esi]
mov BYTE ptr answ[edi],dl
shl eax,4
inc edi
dec ecx
cmp ecx,0h
jne L3
RET
dw2hex_my endp

start:
invoke StdOut, addr ask_str
invoke StdIn,addr var,12 ;var1存放输入的字符串
CALL dec2dw ;调用过程dec2dw
CALL dw2hex_my ;调用过程dw2hex_my
invoke StdOut,addr output_str
invoke StdOut,addr answ
invoke ExitProcess,0
end start
