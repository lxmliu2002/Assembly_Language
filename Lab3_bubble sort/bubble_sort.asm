.386
.model flat, stdcall
option casemap :none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
.stack 4096
.data;定义数据段
     str1 byte "请输入十个无符号整数:",0
     str2 byte "冒泡排序结果为:",0
     istr byte 80 dup(0)
     ostr byte 80 dup(0)
     array dword 12 dup(0)
	 const10 dword 10
.code;定义代码段

main PROC
     invoke StdOut,addr str1
     invoke StdIn,addr istr,80
	 call str2array
	 call bubble
	 call array2str
     invoke StdOut,addr str2
     invoke StdOut,addr ostr
     invoke ExitProcess,0
main ENDP

str2array proc;即上一次的字符串转数字
     mov eax,0
	 mov ebx,0
	 mov ecx,0
	 mov esi,0
L1:
     mov bl,[istr+esi]
	 cmp bl,20h
	 jne L2
	 add ecx,4
	 inc esi
	 mov bl,[istr+esi]
L2:
     sub bl,30h
	 mov eax,[array+ecx]
	 mul const10
	 add eax,ebx
	 mov [array+ecx],eax
	 inc esi
	 cmp [istr+esi],0
	 jne L1
	 ret
str2array endp

bubble proc
     mov ecx,10;共十个数
L3:
     dec ecx;十个数，外层循环需9次，每次-1
     cmp ecx,0;判断是否循环结束
     je exit;若结束，则退出排序循环
     mov ebx,ecx;将外层循环的值赋给ebx，用来计数内层循环
     mov esi,0
L4:
     mov eax,[array+esi];需要用array来访问字符串元素！！
     cmp eax,[array+esi+4]
     jle L5
     xchg eax,[array+esi+4];若不相等，则交换值
     mov [array+esi],eax
L5:
     dec ebx
     cmp ebx,0
     je L3
     add esi,4h
     jmp L4
exit:
     ret
bubble endp

array2str proc;
	 mov esi,0;访问ostr每一位
	 mov edi,0;访问array每一位
	 mov ecx,10;计数外层循环(共10个数)
	 mov ebx,0;计数出栈次数
	 mov eax,[array+edi]
L6:
	 mov edx,0;存商
	 div const10;商存在eax，余数存在edx
	 add edx,30h
	 push edx;入栈（先算的末位，先进后出）
	 inc ebx;计数栈中有几个字符，决定出栈次数
	 cmp eax,0;若商为0，则该数已取完
	 jne L6
L7:
     pop eax
	 mov [ostr+esi],al
	 inc esi
	 dec ebx
	 cmp ebx,0;ebx为0则说明当前整数的各位已经全部出栈，跳出循环
	 jne L7
	 mov [ostr+esi],20h;加一个空格
	 inc esi
L8:;判断是否终止
     dec ecx
	 cmp ecx,0;ecx为0则说明十个整数全被弹出，结束过程
	 je L9
	 add edi,4
	 mov eax,[array+edi]
	 jmp L6
L9:
     ret
array2str endp
end main