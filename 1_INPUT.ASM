DATA SEGMENT
        INPUT_PROMPT DB "Please type in two numbers, one each time.$"
        ADDER DB 00H
        TEMP DB 00H
DATA ENDS

CODE SEGMENT
        ASSUME CS:CODE, DS:DATA
START:  MOV AX, DATA
        MOV DS, AX      ;SET UP DATA SEGMENT
        LEA DX, INPUT_PROMPT
        MOV AH, 09H
        INT 21H

GET:    MOV DX, 2H
        MOV BX, 0H

LOOP1:  SUB DX, 0H
        JZ END1

RE_IN:  MOV AH, 01H
        INT 21H
        CMP AL, 0DH
        JZ EX_IN        ;IS ENTER
        SUB AL, '0'
        JL RE_IN        ;WRONG RANGE
        CMP AL, 9
        JG RE_IN        ;WRONG RANGE
        MOV AH, ADDER
        MOV CL, 4
        SHL AH, CL
        ADD AH, AL
        MOV ADDER, AH
        JMP RE_IN

EX_IN:  SUB DX, 1H
        MOV AL, BL
        ADD AL, ADDER
        DAA
        MOV BL, AL
        JMP LOOP1

END1:   MOV CL, 4
        MOV AH, AL
        MOV BH, AL
        SHR AX, CL
        ADD AH, '0'
        MOV DL, AH
        MOV AH, 02H
        INT 21H
        SHL BH, CL
        SHR BH, CL
        ADD BH, '0'
        MOV DL, BH
        MOV AH, 02H
        INT 21H

EXIT:   MOV AX, 4C00H
        INT 21H

CODE ENDS
END START
