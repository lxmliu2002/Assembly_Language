.386
.model flat, stdcall
option casemap :none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data 
    output db 100 DUP(0)     ;最后输出的字符串
    fileName db 100 DUP(0)   ;文件名
    hFile HANDLE 0
    content db 4000 DUP(0)
    e_lfnew dd 0

    ;定义的待输出字符串
    str1 db "Please input a PE file :",0    
    str2 db 0Ah,"IMAGE_DOS_HEADER",0Ah,"   e_magic: ",0
    str3 db 0Ah,"   e_lfanew: ",0
    str4 db 0Ah,"IMAGE_NT_HEADERS",0Ah,"   Signature: ",0 
    str5 db 0Ah,"IMAGE_FILE_HEADER",0Ah,"   Number0fSections: ",0 
    str6 db 0Ah,"   TimeDateStamp: ",0
    str7 db 0Ah,"   Charateristics: ",0
    str8 db 0Ah,"IMAGE_OPTIONAL_HEADER",0Ah,"   Address0fEntryPoint: ",0 
    str9 db 0Ah,"   ImageBase: ",0
    str10 db 0Ah,"   SectionAlignment: ",0
    str11 db 0Ah,"   FileAlignment: ",0
    
    
.code
start:
    invoke StdOut, ADDR str1
    invoke StdIn, ADDR fileName, 100
    invoke StdOut, ADDR fileName
    
    ;调用函数CreateFile来打开文件
    invoke CreateFile, ADDR fileName,\
                       GENERIC_READ,\
                       FILE_SHARE_READ,\
                       0,\
                       OPEN_EXISTING,\
                       FILE_ATTRIBUTE_ARCHIVE,\
                       0
   
    ;调用函数SetFilePointer和ReadFile读取
    mov hFile, eax
    invoke SetFilePointer, hFile,\
                           0,\
                           0,\
                           FILE_BEGIN
    invoke ReadFile, hFile,\
                     ADDR content,\
                     4000,\
                     0,\
                     0
   
    ;e_magic转化为16进制输出
    mov eax, 0
    mov ax, WORD PTR content
    invoke dw2hex, eax, ADDR output
    
    invoke StdOut, ADDR str2
    invoke StdOut, ADDR output+4
    
    ;e_lfanew转化为16进制输出
    mov eax, 0
    mov eax, DWORD PTR [content+3ch]
    mov e_lfnew, eax
    invoke dw2hex, eax, ADDR output
    
    invoke StdOut, ADDR str3
    invoke StdOut, ADDR output
    
    
    ;Signature转化为16进制输出
    lea ebx, content
    add ebx, e_lfnew
    mov eax, 0
    mov eax, DWORD PTR [ebx]
    invoke dw2hex, eax, ADDR output
    
    invoke StdOut, ADDR str4
    invoke StdOut, ADDR output
    
    ;Number0fSections转化为16进制输出
    lea ebx, content
    add ebx, e_lfnew
    mov eax, 0
    mov ax, WORD PTR [ebx+6h]
    invoke dw2hex, eax, ADDR output
    
    invoke StdOut, ADDR str5
    invoke StdOut, ADDR output+4
    
    ;TimeDateStamp转化为16进制输出
    lea ebx, content
    add ebx, e_lfnew
    mov eax, 0
    mov eax, DWORD PTR [ebx+8h]
    invoke dw2hex, eax, ADDR output
    
    invoke StdOut, ADDR str6
    invoke StdOut, ADDR output
    
    ;Charateristics转化为16进制输出
    lea ebx, content
    add ebx, e_lfnew
    mov eax, 0
    mov ax, WORD PTR [ebx+16h]
    invoke dw2hex, eax, ADDR output
    
    invoke StdOut, ADDR str7
    invoke StdOut, ADDR output+4
    
    ;AddressOfEntryPoint转化为16进制输出
    lea ebx, content
    add ebx, e_lfnew
    mov eax, 0
    mov eax, DWORD PTR [ebx+28h]
    invoke dw2hex, eax, ADDR output
    
    invoke StdOut, ADDR str8
    invoke StdOut, ADDR output
    
    ;ImageBase转化为16进制输出
    lea ebx, content
    add ebx, e_lfnew
    mov eax, 0
    mov eax, DWORD PTR [ebx+34h]
    invoke dw2hex, eax, ADDR output
    
    invoke StdOut, ADDR str9
    invoke StdOut, ADDR output
    
    ;SectionAlignment转化为16进制输出
    lea ebx, content
    add ebx, e_lfnew
    mov eax, 0
    mov eax, DWORD PTR [ebx+38h]
    invoke dw2hex, eax, ADDR output
    
    invoke StdOut, ADDR str10
    invoke StdOut, ADDR output
    
    ;FileAlignment转化为16进制输出
    lea ebx, content
    add ebx, e_lfnew
    mov eax, 0
    mov eax, DWORD PTR [ebx+3Ch]
    invoke dw2hex, eax, ADDR output
    
    invoke StdOut, ADDR str11
    invoke StdOut, ADDR output
    
    ;调用函数CloseHandle关闭句柄
    invoke CloseHandle, hFile
    invoke ExitProcess, 0
END start
