.386
.model flat, stdcall
option casemap :none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
.stack 4096
.data;�������ݶ�
     str1 byte "������ʮ���޷�������:",0
     str2 byte "ð��������Ϊ:",0
     istr byte 80 dup(0)
     ostr byte 80 dup(0)
     array dword 12 dup(0)
	 const10 dword 10
.code;��������

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

str2array proc;����һ�ε��ַ���ת����
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
     mov ecx,10;��ʮ����
L3:
     dec ecx;ʮ���������ѭ����9�Σ�ÿ��-1
     cmp ecx,0;�ж��Ƿ�ѭ������
     je exit;�����������˳�����ѭ��
     mov ebx,ecx;�����ѭ����ֵ����ebx�����������ڲ�ѭ��
     mov esi,0
L4:
     mov eax,[array+esi];��Ҫ��array�������ַ���Ԫ�أ���
     cmp eax,[array+esi+4]
     jle L5
     xchg eax,[array+esi+4];������ȣ��򽻻�ֵ
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
	 mov esi,0;����ostrÿһλ
	 mov edi,0;����arrayÿһλ
	 mov ecx,10;�������ѭ��(��10����)
	 mov ebx,0;������ջ����
	 mov eax,[array+edi]
L6:
	 mov edx,0;����
	 div const10;�̴���eax����������edx
	 add edx,30h
	 push edx;��ջ�������ĩλ���Ƚ������
	 inc ebx;����ջ���м����ַ���������ջ����
	 cmp eax,0;����Ϊ0���������ȡ��
	 jne L6
L7:
     pop eax
	 mov [ostr+esi],al
	 inc esi
	 dec ebx
	 cmp ebx,0;ebxΪ0��˵����ǰ�����ĸ�λ�Ѿ�ȫ����ջ������ѭ��
	 jne L7
	 mov [ostr+esi],20h;��һ���ո�
	 inc esi
L8:;�ж��Ƿ���ֹ
     dec ecx
	 cmp ecx,0;ecxΪ0��˵��ʮ������ȫ����������������
	 je L9
	 add edi,4
	 mov eax,[array+edi]
	 jmp L6
L9:
     ret
array2str endp
end main