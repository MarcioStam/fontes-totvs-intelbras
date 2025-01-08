/*----------------------------------------------------------------------------------------------------------------------*/         
/*  Inclusde esp/esb/esesb003.i - define a procedure para criaá∆o do registro filho da conta corrente, contendo o saldo */
/*                                no momento da criaá∆o da conta para os benef°cios que n∆o possuem controle apenas     */
/*                                trimestral, ser∆o gravados mais movimentos para a mesma conta corrente, atendendo as  */
/*                                seguintes c¢digos de transaá‰es:                                                      */
/*                                                                                                                      */
/*                                10 - Movimento de saldo na criaá∆o/calculo da conta corrente para o trimestre 1       */
/*                                20 - Movimento de saldo na criaá∆o/calculo da conta corrente para o trimestre 2       */
/*                                30 - Movimento de saldo na criaá∆o/calculo da conta corrente para o trimestre 3       */
/*                                40 - Movimento de saldo na criaá∆o/calculo da conta corrente para o trimestre 4       */
/*                                                                                                                      */
/*                                Essa movimentaá∆o se faz necess†ria para quando for utilizada a opá∆o RECµLCULO       */
/*                                do programa esesb005rp.p, para reconstruá∆o de saldo                                  */
/*                                                                                                                      */
/*  Roger Marcelino Bruhn -01/07/2014                                                                                   */
/*----------------------------------------------------------------------------------------------------------------------*/         
DEF BUFFER b-int-cc-benef-movto-trimestre FOR int-cc-benef-movto.

PROCEDURE pi-cria-transacao-saldo-trimestre:
    DEF INPUT PARAM p-canal          AS INT     NO-UNDO.
    DEF INPUT PARAM p-tipo-beneficio AS INTEGER NO-UNDO.
    DEF INPUT PARAM p-unidade        AS CHAR    NO-UNDO.
    DEF INPUT PARAM p-periodo-ini    AS DATE    NO-UNDO.
    DEF INPUT PARAM p-periodo-fim    AS DATE    NO-UNDO.
    DEF INPUT PARAM p-usuario        AS CHAR    NO-UNDO.
    DEF INPUT PARAM p-saldo          AS DEC     NO-UNDO.
    
    DEF VAR i-transacao   AS INTEGER                 NO-UNDO.
    DEF VAR c-trimestre   AS CHAR    FORMAT "X(20)"  NO-UNDO.
    DEF VAR i-sequencia   AS INTEGER                 NO-UNDO.
    DEF VAR c-recalculado AS CHAR    FORMAT "X(100)" NO-UNDO. 

    CASE  MONTH(p-periodo-fim):
        WHEN 3 THEN ASSIGN  i-transacao = 10
                            c-trimestre = "Primeiro Trimestre: ".
        WHEN 6 THEN ASSIGN  i-transacao = 20
                            c-trimestre = "Segundo Trimestre: ".
        WHEN 9 THEN ASSIGN  i-transacao = 30
                            c-trimestre = "Terceiro Trimestre: ".
        WHEN 4 THEN ASSIGN  i-transacao = 40
                            c-trimestre = "Quarto Trimestre: ".
    END.

    /* VERIFICA SE Jµ EXISTE UM REGISTRO DE SALDO INICIAL PARA TRIMESTRE */
    FOR LAST b-int-cc-benef-movto-trimestre FIELDS(sequencia) EXCLUSIVE-LOCK
        WHERE b-int-cc-benef-movto-trimestre.tp-movto       = 2
          AND b-int-cc-benef-movto-trimestre.canal          = p-canal
          AND b-int-cc-benef-movto-trimestre.tipo-beneficio = p-tipo-beneficio
          AND b-int-cc-benef-movto-trimestre.unid-neg       = p-unidade
          AND b-int-cc-benef-movto-trimestre.dt-periodo-ini = p-periodo-ini
          AND b-int-cc-benef-movto-trimestre.dt-periodo-fim = p-periodo-fim
          AND b-int-cc-benef-movto-trimestre.transacao      = i-transacao:
    END.

    IF  NOT AVAIL b-int-cc-benef-movto-trimestre THEN DO:
    
        /* BUSCAR A ÈLTIMA SEQU“NCIA PARA CRIAÄ«O DA NOVA CONTA*/
        FOR LAST b-int-cc-benef-movto-trimestre FIELDS(sequencia) NO-LOCK
            WHERE b-int-cc-benef-movto-trimestre.tp-movto       = 2
              AND b-int-cc-benef-movto-trimestre.canal          = p-canal          
              AND b-int-cc-benef-movto-trimestre.tipo-beneficio = p-tipo-beneficio 
              AND b-int-cc-benef-movto-trimestre.unid-neg       = p-unidade        
              AND b-int-cc-benef-movto-trimestre.dt-periodo-ini = p-periodo-ini    
              AND b-int-cc-benef-movto-trimestre.dt-periodo-fim = p-periodo-fim:    
              ASSIGN i-sequencia = int-cc-benef-movto.sequencia.
        END.
    
        CREATE b-int-cc-benef-movto-trimestre.
        ASSIGN b-int-cc-benef-movto-trimestre.tp-movto          = 2       
               b-int-cc-benef-movto-trimestre.canal             = p-canal         
               b-int-cc-benef-movto-trimestre.tipo-beneficio    = p-tipo-beneficio  
               b-int-cc-benef-movto-trimestre.unid-neg          = p-unidade      
               b-int-cc-benef-movto-trimestre.dt-periodo-ini    = p-periodo-ini 
               b-int-cc-benef-movto-trimestre.dt-periodo-fim    = p-periodo-fim
               b-int-cc-benef-movto-trimestre.sequencia         = i-sequencia + 10
               b-int-cc-benef-movto-trimestre.transacao         = i-transacao. /* Saldo na ocasi∆o da apuraá∆o */
    END.

    IF  b-int-cc-benef-movto-trimestre.hist-automatico <> "" THEN 
        c-recalculado = "Saldo " + TRIM (STRING(p-saldo, ">>>,>>>,>>9.99")) + " Recalculado em: " + STRING(TODAY, "99/99/9999") + 
                         " as " + STRING(TIME, "HH:MM:SS") + " por " + p-usuario + CHR(10).
    ELSE
        c-recalculado = "Primeiro saldo para o trimestre: " + trim(STRING(p-saldo, ">>>,>>>,>>9.99")) + CHR(10).
 
    ASSIGN b-int-cc-benef-movto-trimestre.dt-movto          = TODAY
           b-int-cc-benef-movto-trimestre.hr-movto          = STRING(TIME, "HH:MM:SS")
           b-int-cc-benef-movto-trimestre.id-operacao       = 1 /*a maior*/
           b-int-cc-benef-movto-trimestre.hist-automatico   = b-int-cc-benef-movto-trimestre.hist-automatico + c-recalculado 
           b-int-cc-benef-movto-trimestre.hist-usuario      = ""
           b-int-cc-benef-movto-trimestre.usuario           = p-usuario
           b-int-cc-benef-movto-trimestre.vl-saldo-anterior = 0
           b-int-cc-benef-movto-trimestre.vl-movto          = p-saldo.

    FIND CURRENT b-int-cc-benef-movto-trimestre NO-LOCK.
    RELEASE b-int-cc-benef-movto-trimestre NO-ERROR.

    RETURN "OK".

END.
