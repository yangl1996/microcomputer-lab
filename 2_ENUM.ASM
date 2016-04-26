STACK SEGMENT PARA STACK
        DW 128H DUP(0)
STACK ENDS

DATA SEGMENT
        COUNT DB 00H
DATA ENDS

CODE SEGMENT
        ASSUME CS:CODE, SS:STACK, DS:DATA
START:
        MOV AX, DATA
        MOV DS, AX      ; SET UP DATA SEGMENT
        MOV BX, 0000H   ; BX HOLDS PCI INDEX, 0H TO 08FFH
                        ; H-BUS(8)-DEV(5)-FUNC(3)-L
LOOP0:
        CMP BX, 08FFH   ; EXIT LOOP WHEN BUS NUMBER EXCEEDS 8
        JG ENDLP
        MOV AX, 0B109H  ; PREPARE FOR PCI BIOS CALL
        MOV DI, 00H     ; FIRST GET VENDOR ID
        INT 1AH         ; PERFORM PCI CALL
        CMP CX, 0FFFFH  ; CHECK WHETHER HAS DEVICE ATTACHED
        JE NO
YES:
        MOV AX, COUNT
        CALL DISP
        MOV AX, COUNT
        INC AX
        MOV COUNT, AX
        MOV DL, ' '
        MOV AH, 2
        INT 21H
        MOV AX, CX
        CALL DISP       ; DISPLAY VENDOR ID
        MOV DL, ' '     ; PRINT ' '
        MOV AH, 2
        INT 21H
        MOV AX, 0B109H
        MOV DI, 02H
        INT 1AH         ; INVOKE PCI BIOS AND GET DEVICE ID
        MOV AX, CX
        CALL DISP       ; DISPLAY DEVICE ID
        MOV DL, 0AH     ; PRINT ENTER
        MOV AH, 2
        INT 21H
        MOV DL, 0DH
        MOV AH, 2
        INT 21H
        MOV AX, 0B108H
        MOV DI, 0EH
        INT 1AH         ; INVOKE PCI BIOS AND GET HEADER TYPE
        MOV AH, CL
        MOV CL, 7
        SHR AH, CL      ; SHIFT CH RIGHT TO CHECK MSB
        CMP AH, 0       ; CHECK WHETHER MULTI FUNCTION
        JE SING1
MULT:
        INC BX
        JMP LOOP0
SING1:
        MOV AH, BL
        MOV CL, 5
        SHL AH, CL
        SHR AH, CL
        CMP AH, 0
        JE SING
        JMP MULT
SING:
        ADD BX, 08H
        JMP LOOP0
NO:
        INC BX
        JMP LOOP0
ENDLP:
        MOV AX, 4C00H
        INT 21H

END START
