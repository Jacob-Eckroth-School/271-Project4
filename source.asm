;Name: Jacob Eckroth
;Date: October 25, 2020
;Program Number Four
;Program Description: This program asks the user to enter a number between 1 and 400.
;It then calculates and prints that many composite numbers. A composite number is any
;non-prime number. It then says goodbye, and exits the program.
TITLE Composite Numbers

 .386
 .model flat,stdcall
 .stack 4096
 ExitProcess PROTO, dwExitCode:DWORD



INCLUDE Irvine32.inc


.data				;Messages initialized here

programTitle BYTE "Composite Numbers    Programmed by Jacob Eckroth",13,10,13,10,0
compositeInfo BYTE "Enter the number of composite numbers you would like to see.",13,10,0
howManyInfo BYTE "I",39,"ll accept orders for up to 400 composites.",13,10,13,10,0

enterPrompt BYTE "Enter the number of composites to display [1, 400]: ",0
outOfRangePrompt BYTE "Out of range. Try again.",13,10,0

goodbyePrompt   BYTE "Results certified by Jacob Eckroth. Goodbye.",0
spacer BYTE "    ",0

factor DWORD 0          ;Keeps track of the highest factor of a number

numberOnLine DWORD 0    ;Keeps track of the amount of numbers on a line.


;Color Declarations
defaultColor = 7
userInputColor = 11
errorColor = 4
maxNumbersPerLine = 8


;Limits DEFINED AS CONSTANTS
upperLimit = 400
lowerLimit = 1

.data?
userNumber  DWORD ?
testNumber  DWORD ?


.code


;Executes the entire program.
main PROC
    
    call introduction
    call getUserData
    call showComposites
    call farewell


INVOKE ExitProcess, 0
main ENDP


;-----------------------------------------------------
; Name: introduction
; Description: Prints the introductions and first instructions
; Receives: None
; Returns: None
; Preconditions: messages are defined
;-----------------------------------------------------
introduction PROC
    mov     edx, offset programTitle
    call    WriteString
    mov     edx, offset compositeInfo
    call    WriteString
    mov     edx, offset howManyInfo
    call    WriteString
    ret
introduction ENDP



;-----------------------------------------------------
; Name: getUserData
; Description: gets valid user input for a number between 1-400
; Receives: None
; Returns: Sets userNumber to the user entered number in between 1-400
; Preconditions: None
;-----------------------------------------------------
getUserData PROC
start:
    mov     edx, offset enterPrompt
    call    WriteString

    call    readDec
    mov     userNumber, eax

    call    validate               

    cmp     ecx, 1
    je      valid

    mov     edx, offset outOfRangePrompt        ;If validate did not set ecx to 1, it's invalid so loop again
    call    WriteString
    jmp     start

valid:
    ret 
getUserData ENDP


;-----------------------------------------------------
; Name: validate
; Description: Validates the user input is between 1-400
; Receives: User inputted number into userNumber
; Returns: Sets ecx to 1 if user input is in range 1-400, 0 otherwise
; Preconditions: User number is stored in userNumber, in decimal format.
;-----------------------------------------------------
validate PROC
    cmp     userNumber, lowerLimit
    jl      invalid
    cmp     userNumber, upperLimit
    jg      invalid
    mov     ecx, 1
    ret
invalid:
    mov     ecx, 0
    ret 
validate ENDP

;-----------------------------------------------------
; Name: showComposites
; Description: Prints a certain amount of composite numbers
; Receives: User inputted number into userNumber
; Returns: Prints numbers to screen.
; Preconditions: User inputted number is in userNumber
;-----------------------------------------------------
showComposites PROC
    call crlf

    mov     ecx, userNumber        
    mov     eax, 2                                   ;Our starting number for looking for, that we'll keep increasing.
countLoop:                                           ;Beginning of ASM LOOP
    push    ecx                      

    infiniteLoop:
        mov     testNumber, eax
        push    eax                                   
        call    isComposite
        pop     eax
        cmp     ecx, 1
        jne     notComposite

        call    WriteDec                            ;Writes the composite number to the screen, continues the loop.
        mov     edx, offset spacer
        call    WriteString
        jmp     Composite

    notComposite:
        inc     eax
        jmp     InfiniteLoop
    Composite:
        inc     eax

    inc     numberOnLine                            ;Checks whether we need to print a newline
    cmp     numberOnLine, maxNumbersPerLine         
    jl      noNewLine
    call    crlf
    mov     numberOnLine, 0

noNewLine:
    
    pop     ecx
    loop    countLoop                               ;Loops back up to countLoop with ASM LOOP command, for the amount of numbers requested.

    call    crlf
    call    crlf

    ret
showComposites ENDP


;-----------------------------------------------------
; Name: isComposite
; Description: Sets ECX to 0 if number in testNumber is composite, sets to ECX otherwise
; Receives: Number to test in testNumber
; Returns: 1 or 0 in ECX
; Preconditions: there is a number in testNumber
;-----------------------------------------------------
isComposite PROC
    mov     ecx, 1      ;starting with factor 2
    mov     factor, 1

checkLoop:
    mov     eax, testNumber
    cdq                                     ;Clears out EDX
    div     ecx
    cmp     edx, 0                          ;Checks to see if there's a remainder
    jne     notAFactor
    mov     factor, ecx     

notAFactor:                                 ;If a number isn't a factor, we continue and increase the number to check as a factor.
    inc     ecx
    cmp     ecx, testNumber
    jne     checkLoop

    cmp     factor, 1                       ;If the number has a factor greater than 1, and less than itself then we say the number is a composite.
    jle     invalid
    mov     ecx, 1
    jmp     doneFactoring

invalid:
    mov     ecx, 0
    
doneFactoring:
    ret
isComposite ENDP



;-----------------------------------------------------
; Name: farewell
; Description: Prints farewell message
; Receives: None
; Returns: None
; Preconditions: goodbyePrompt is defined
;-----------------------------------------------------
farewell PROC
    mov     edx, offset goodbyePrompt
    call    writeString

    ret
farewell ENDP









END main