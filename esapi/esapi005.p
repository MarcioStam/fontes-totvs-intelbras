{include/i-prgvrs.i ESAPI005 2.04.00.001}
/***********************************************************************
**  Programa..: ESP\ESAPI005.P
**  Autor.....: Chaves - APORTE 
**  Data......: OUTUBRO/2004 - Desenvolvimento
**  Descricao.: Busca Dep¢sitos do Item/Linha
                L¢gica espec°fica para busca do dep¢sito
**  Vers∆o....: 001 - 13/10/2004
**                  Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ************************** */

DEFINE INPUT  PARAM pItCodigo    LIKE item.it-codigo     NO-UNDO.
DEFINE INPUT  PARAM pcod-estab   AS CHAR  NO-UNDO.
DEFINE OUTPUT PARAM c-depos-ent  LIKE deposito.cod-depos NO-UNDO.
DEFINE OUTPUT PARAM c-depos-sai  LIKE deposito.cod-depos NO-UNDO.
DEFINE OUTPUT PARAM pReturn      AS CHAR                 NO-UNDO.

FOR FIRST item-uni-estab NO-LOCK
    WHERE item-uni-estab.cod-estabel  = pcod-estab
    AND   item-uni-estab.it-codigo    = pItCodigo,
    FIRST ITEM NO-LOCK
    WHERE ITEM.it-codigo = item-uni-estab.it-codigo:

    IF ITEM.ge-codigo = 40 OR
       ITEM.ge-codigo = 42 OR
       ITEM.ge-codigo = 45 THEN
        ASSIGN c-depos-ent = "ACA".
    ELSE
        ASSIGN c-depos-ent = item-uni-estab.deposito-pad.
    
    ASSIGN c-depos-sai = "".  
    
    FIND FIRST int-lin-prod 
        WHERE int-lin-prod.cod-estabel = item-uni-estab.cod-estabel AND
              int-lin-prod.nr-linha    = item-uni-estab.nr-linha NO-LOCK NO-ERROR.
    IF AVAIL int-lin-prod THEN DO:
        IF int-lin-prod.transf-auto = YES AND
           int-lin-prod.deposito-trans <> "" THEN
            ASSIGN c-depos-ent = int-lin-prod.deposito-trans.

        ASSIGN c-depos-sai = int-lin-prod.deposito-saida.
    END.

    /* Codigo criado para contemplar regra de um kit */
    IF item-uni-estab.cod-estabel = "101" THEN DO:
        CASE item-uni-estab.nr-linha:
             WHEN 02 THEN DO: 
                 IF item-uni-estab.it-codigo BEGINS "4" THEN DO:
                     IF CAN-FIND(FIRST prod-composto WHERE prod-composto.it-codigo-filho = item-uni-estab.it-codigo) THEN
                         ASSIGN c-depos-ent = item-uni-estab.deposito-pad.
                     
                 END.
             END.
        END.
    END.
    /* fim kit */
    if c-depos-sai = "" then ASSIGN pReturn = "NOK".
END.
