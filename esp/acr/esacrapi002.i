
FUNCTION fnDataProrrogadaDiaMES RETURNS DATE
  ( INPUT p-vencto-orig AS DATE,
    INPUT p-dia-mes LIKE int-cond-pag-cli.mes)  FORWARD.

FUNCTION fnDataProrrogadaDiaSEMANA RETURNS DATE
  ( INPUT p-vencto-orig AS DATE,
    INPUT p-dia-semana LIKE int-cond-pag-cli.semana)  FORWARD.

FUNCTION fnDataProrrogadaDiaMES RETURNS DATE
  ( INPUT p-vencto-orig AS DATE,
    INPUT p-dia-mes LIKE int-cond-pag-cli.mes) :
    /*------------------------------------------------------------------------------
      Purpose:  Retornar nova data de vencimento de acordo com o dia do mˆs fixo
                parametrizado no esesb070
    ------------------------------------------------------------------------------*/
    DEF VAR i                AS INTEGER NO-UNDO.
    DEF VAR l-mudou-mes      AS LOG     NO-UNDO.
    DEF VAR da-new-vencto    AS DATE    NO-UNDO.
    DEF VAR i-ultimo-dia-mes AS INTEGER NO-UNDO.
    DEF VAR l-ja-encontrou-data AS LOG INIT NO NO-UNDO.
        
    /* Verifica qual ‚ o £ltimo dia do mˆs da data de vencimento */
    ASSIGN da-new-vencto = date(month(p-vencto-orig), 28, YEAR(p-vencto-orig)) + 5.
           da-new-vencto = date(month(da-new-vencto), 01, YEAR(da-new-vencto)) - 1.
           i-ultimo-dia-mes = DAY(da-new-vencto).
    
    /* Verifica se encontra dia de vencimento cadastrado dentro do mesmo mˆs */
    DO  i = DAY(p-vencto-orig) TO i-ultimo-dia-mes:
    
        IF  p-dia-mes[i] = YES AND i >= DAY(p-vencto-orig) THEN DO:
            ASSIGN l-ja-encontrou-data = YES.
            LEAVE.
        END.
    END.
    
    IF  NOT l-ja-encontrou-data THEN
        IF  (i-ultimo-dia-mes = 28 OR  i-ultimo-dia-mes = 29 OR  i-ultimo-dia-mes = 30) AND p-dia-mes[31] = YES THEN 
                ASSIGN l-ja-encontrou-data = YES
                       i = i-ultimo-dia-mes.

    IF  NOT l-ja-encontrou-data THEN DO:
        /* Verifica qual ‚ o £ltimo dia do mˆs da data de vencimento */
        ASSIGN da-new-vencto = date(month(da-new-vencto), 28, YEAR(da-new-vencto)) + 5.
        ASSIGN da-new-vencto = date(month(da-new-vencto), 28, YEAR(da-new-vencto)) + 5.
               da-new-vencto = date(month(da-new-vencto), 01, YEAR(da-new-vencto)) - 1.
               i-ultimo-dia-mes = DAY(da-new-vencto).

        /* Verifica se encontra dia de vencimento cadastrado dentro do mesmo mˆs */
        DO  i = 1 TO i-ultimo-dia-mes:
        
            IF  p-dia-mes[i] = YES  THEN DO:
                ASSIGN l-ja-encontrou-data = YES.
                LEAVE.
            END.
        END.
    END.

    ASSIGN da-new-vencto =  DATE(MONTH(da-new-vencto), i, YEAR(da-new-vencto)).

/*     /* Busca o pr¢ximo dia v lido no mˆs subsequente */                                  */
/*     IF  NOT l-ja-encontrou-data THEN DO:                                                 */
/*         DO  i = 1 TO DAY(p-vencto-orig) - 1:                                             */
/*             IF  p-dia-mes[i] = YES THEN                                                  */
/*                 LEAVE.                                                                   */
/*         END.                                                                             */
/*         ASSIGN da-new-vencto = date(month(p-vencto-orig), 28, YEAR(p-vencto-orig)) + 5.  */
/*                da-new-vencto = DATE(month(da-new-vencto), i, YEAR(da-new-vencto)).       */
/*     END.                                                                                 */
/*     ELSE /* no mesmo mˆs */                                                              */
/*         ASSIGN da-new-vencto =  DATE(MONTH(p-vencto-orig), i, YEAR(p-vencto-orig)).      */
    
    RETURN da-new-vencto.


END FUNCTION.

FUNCTION fnDataProrrogadaDiaSEMANA RETURNS DATE
  ( INPUT p-vencto-orig AS DATE,
    INPUT p-dia-semana LIKE int-cond-pag-cli.semana) :
    /*------------------------------------------------------------------------------
      Purpose:  Retornar nova data de vencimento de acordo com o dia da semana
                parametrizado no esesb070
    ------------------------------------------------------------------------------*/
    DEF VAR i              AS INTEGER NO-UNDO.
    DEF VAR i-soma         AS INTEGER NO-UNDO.
    DEF VAR l-mudou-semana AS LOG     NO-UNDO.

    CASE WEEKDAY(p-vencto-orig):
        /* Domingo */
        WHEN 1 THEN DO: 
            DO  i = 1 TO 5:
                IF p-dia-semana
                    [i] = YES THEN DO:
                    i-soma = i.
                    LEAVE.
                END.
            END.
        END.
        
        /* Segunda */
        WHEN 2 THEN DO: 
            DO  i = 1 TO 5:
                IF p-dia-semana[i] = YES
                AND i >= 1 THEN
                    LEAVE.
                ELSE
                    i-soma = i-soma + 1.
            END.
        END.
    
        /* Ter‡a */
        WHEN 3 THEN DO: 
            l-mudou-semana = YES.
            DO  i = 2 TO 5:
                IF p-dia-semana[i] = YES THEN DO:
                    l-mudou-semana = NO.
                    LEAVE.
                END.
                ASSIGN i-soma = i-soma + 1.
            END.
            IF  l-mudou-semana THEN
                i-soma = 6.
        END.
    
        /* Quarta */
        WHEN 4 THEN DO: 
            l-mudou-semana = YES.
            DO  i = 3 TO 5:
                IF p-dia-semana[i] = YES THEN DO:
                    l-mudou-semana = NO.
                    LEAVE.
                END.
                ASSIGN i-soma = i-soma + 1.
            END.
            IF  l-mudou-semana THEN DO:
                i-soma = 5.
                DO  i = 1 TO 2:
                    IF p-dia-semana[i] = YES THEN DO:
                        LEAVE.
                    END.
                    ASSIGN i-soma = i-soma + 1.
                END.
            END.
        END.
    
        /* Quinta */
        WHEN 5 THEN DO: 
            l-mudou-semana = YES.
            DO  i = 4 TO 5:
                IF p-dia-semana[i] = YES THEN DO:
                    l-mudou-semana = NO.
                    LEAVE.
                END.
                ASSIGN i-soma = i-soma + 1.
            END.
            
            IF  l-mudou-semana THEN DO:
                i-soma = 4.
                DO  i = 1 TO 3:
                    IF p-dia-semana[i] = YES THEN DO:
                        LEAVE.
                    END.
                    ASSIGN i-soma = i-soma + 1.
                END.
            END.
        END.
    
        /* Sexta */
        WHEN 6 THEN DO: 
            l-mudou-semana = YES.
            IF p-dia-semana[5] = YES THEN DO:
                l-mudou-semana = NO.
            END.
            IF  l-mudou-semana THEN DO:
                i-soma = 3.
                DO  i = 1 TO 4:
                    IF p-dia-semana[i] = YES THEN DO:
                        LEAVE.
                    END.
                    ASSIGN i-soma = i-soma + 1.
                END.
            END.
        END.
        WHEN 7 THEN DO: /* Sabado */
            DO  i = 1 TO 5:
                i-soma = 1.
                IF p-dia-semana[i] = YES THEN DO:
                    i-soma = i-soma + i.
                    LEAVE.
                END.
            END.
        END.
    
    END CASE.
    
    RETURN  p-vencto-orig + i-soma.


END FUNCTION.

