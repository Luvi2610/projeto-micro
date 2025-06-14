.global _led

_led:
    addi        r9,     r9,  1 #0p 00
    
    ldb         r10,    (r9) #guarda opção -> acende: 0x30 | apaga: 0x31
    subi		r10,	r10, 0x30

    #Tratar número do LED
    addi        r9,     r9,  2 #00 p0

    ldb         r11,    (r9)  
    subi        r11,    r11, 0x30 #(n + 30) - 30

    slli        r12,    r11, 3 #8*n

    slli        r13,    r11, 1 #2*n

    add		    r14,	r12, r13 #10*n -> dezena

    addi        r9,     r9,  1 #00 0p

    ldb         r11,    (r9)
    subi        r11,    r11, 0x30 #unidade

    add         r14,    r14, r11 #x = [dezena][unidade]   
    ###

    movi        r12, 1
    sll         r14,    r12, r14 #posicao do led a apagar/acender

    movia       r13,    LED_STATE     # r16 = estado atual dos leds
    ldw         r16,    (r13)

    beq         r10,    r0, ACENDER_LED 

    #APAGAR_LED
    nor         r14, r14, r14    #invertendo o r14
    and         r16, r16, r14    #Excluir utilizando and

    br    ATUALIZAR_LED



ACENDER_LED:
    or     r16, r16, r14            # seto o bit para acender


ATUALIZAR_LED:
    movia       r11,    0x10000000 #Endereço base LED's
    stwio       r16,    (r11)       # escreve nos LEDs
    stw		    r16,    (r13)       # salva na memória estado atual

END_LED:
ret