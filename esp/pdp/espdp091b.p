/***********************************************************************
*                    Copia do ESPDP091A                                 *
************************************************************************/
/****************************  Temp-Tables   ****************************/
{esapi/esapi006tt.i}
{esapi/esapi007tt.i}
{upc/btb910za-upc.i}
{esinc/es0005.i v_cod_estab_usuar} /* Busca Data Ultimo Faturamento - vDtFatur */

DEFINE TEMP-TABLE tt-reporte-item
      FIELD cod-estabel   LIKE estabelec.cod-estabel
      FIELD log-reporta   AS LOGICAL 
      FIELD it-codigo     LIKE ITEM.it-codigo
      FIELD desc-item     LIKE ITEM.desc-item FORMAT 'X(50)'
      FIELD qt-saldo      AS DEC
      INDEX id it-codigo.

/****************************  Variaveis    ****************************/
def input param pCodEstabel    as char  no-undo.
DEF INPUT  PARAM pRowWtItDocto AS ROWID NO-UNDO.
DEF INPUT  PARAM pQtOrdem      AS INT   NO-UNDO.
DEF INPUT  PARAM vCod-depos    AS CHARACTER NO-UNDO.
DEF INPUT  PARAM vLocalizacao  AS CHARACTER NO-UNDO.
DEF OUTPUT PARAM pOrdemGerada  AS CHAR  NO-UNDO.
DEF OUTPUT PARAM pMsgErro      AS CHAR  NO-UNDO.

DEF VAR c-grupo-aloca   LIKE estabelec.grupo-aloca      NO-UNDO.
DEF VAR deQtDisponivel  LIKE saldo-estoq.qtidade-atu    NO-UNDO.
DEF VAR de-saldo        AS DECIMAL                      NO-UNDO.
DEF VAR cReturn         AS CHAR                         NO-UNDO.

/* FOR FIRST param-estoq NO-LOCK: END. */
/*    */
RUN PiCriaTempTable.

FOR FIRST tt-reporte-item.
    RUN PiGeraReporteCentrais.
END.

PROCEDURE PiGeraReporteCentrais:

  
    FOR EACH tt-ordem. DELETE tt-ordem. END.

    FOR FIRST  tt-reporte-item:

        CREATE tt-ordem.
        ASSIGN tt-ordem.it-codigo               = tt-reporte-item.it-codigo
               tt-ordem.qt-ordem                = tt-reporte-item.qt-saldo
               tt-ordem.tipo                    = 1 /* Interna */
               tt-ordem.estado                  = 1 /* NÆo Iniciada */
               /* tt-ordem.nr-linha                = lin-prod.nr-linha*/ 
               tt-ordem.rep-prod                = 1 /* por Ordem */
               tt-ordem.sit-aloc                = 1 /* Total */
               tt-ordem.cod-estabel             = tt-reporte-item.cod-estabel
               tt-ordem.cod-depos               = vCod-depos
               /*tt-ordem.cd-planejado            = lin-prod.cd-planejado*/ 
               tt-ordem.log-reporta             = YES
               tt-ordem.log-altera-dep-reservas = YES
               tt-ordem.dep-reservas            = tt-ordem.cod-depos
               tt-ordem.local-reservas          = "".
    END.

    /* 
      Cria Ordem de Produ‡Æo 
     */
     
    RUN esapi/esapi007.p (INPUT "ES-PD4000K",
                          INPUT-OUTPUT TABLE tt-ordem,
                          OUTPUT cReturn).
        
    IF  cReturn = "NOK" THEN
        ASSIGN pMsgErro = "NOK".

    FOR EACH tt-ordem:
        IF pOrdemGerada = "" THEN 
             ASSIGN pOrdemGerada = string(tt-ordem.nr-ord-produ).
        ELSE ASSIGN pOrdemGerada = pOrdemGerada + "," + string(tt-ordem.nr-ord-produ).
    END.
END.

PROCEDURE PiCriaTempTable:

    FOR FIRST wt-it-docto NO-LOCK
        WHERE ROWID(wt-it-docto) = pRowWtItDocto 
        /*AND  (ped-ent.qt-pedida - ped-ent.qt-atendida) > 0*/ ,
        FIRST ITEM NO-LOCK 
        WHERE item.it-codigo = wt-it-docto.it-codigo,
        FIRST item-uni-estab NO-LOCK
        WHERE item-uni-estab.cod-estabel = pCodEstabel
        AND   item-uni-estab.it-codigo   = ITEM.it-codigo:
        IF  item-uni-estab.nr-linha <> 20 THEN DO:
            ASSIGN pMsgErro = "Ordem de produ‡Æo nÆo ‚ do tipo Centrais Configuradas".
            LEAVE.
        END.

        FIND FIRST tt-reporte-item 
             WHERE tt-reporte-item.it-codigo = item.it-codigo NO-ERROR.
        IF NOT AVAIL tt-reporte-item THEN
        DO:
           CREATE tt-reporte-item.
           ASSIGN tt-reporte-item.cod-estabel = pCodEstabel
                  tt-reporte-item.it-codigo   = ITEM.it-codigo
                  tt-reporte-item.desc-item   = ITEM.desc-item
                  tt-reporte-item.qt-saldo    = pQtOrdem.

           RUN piVarreEstrutura(INPUT-OUTPUT tt-reporte-item.qt-saldo).
           IF tt-reporte-item.qt-saldo = 0 THEN DELETE tt-reporte-item.
        END.
    END.
END PROCEDURE.

PROCEDURE piVarreEstrutura:
    DEFINE INPUT-OUTPUT PARAM pQtSaldo  AS INT.

    FOR EACH tt-estrutura. DELETE tt-estrutura. END.

    RUN esapi/esapi091.p ( INPUT ROWID(ITEM),  /* Rowid */
                           INPUT "",           /* Refer */
                           INPUT 1,            /* Quantidade */
                           INPUT 0,            /* Quantidade Liq */
                           INPUT 0,            /* N¡vel */
                           INPUT-OUTPUT TABLE tt-estrutura,
                           INPUT vDtFatur,     /* Data Corte */
                           INPUT YES,          /* Recursivo */
                           INPUT 19,           /* N¡veis */
                           INPUT pCodEstabel ).       /* Estabel */


    FOR EACH  tt-estrutura
        WHERE NOT tt-estrutura.log-fantasma
        AND   tt-estrutura.compr-fabric = 2:

        RUN PiBuscaSaldo(INPUT tt-estrutura.es-codigo,
                         INPUT tt-estrutura.refer).
        IF de-saldo = 0 THEN
           ASSIGN pMsgErro = "NÆo h  Saldo Estoque para o Componente " + tt-estrutura.es-codigo.
        IF  de-saldo > pQtSaldo  THEN
             ASSIGN pQtSaldo = pQtSaldo.
        ELSE ASSIGN pQtSaldo = de-saldo / tt-estrutura.quant-usada.
    END.
END.

PROCEDURE PiBuscaSaldo:
    DEFINE INPUT PARAM pItCodigo LIKE saldo-estoq.it-codigo NO-UNDO.
    DEFINE INPUT PARAM pCodRefer LIKE saldo-estoq.cod-refer NO-UNDO.

    ASSIGN de-saldo = 0.    

    FOR EACH saldo-estoq NO-LOCK
        WHERE saldo-estoq.cod-estabel = pCodEstabel
        AND   saldo-estoq.it-codigo   = pItCodigo
        AND   saldo-estoq.cod-refer   = pCodRefer
        AND   saldo-estoq.cod-depos   = vCod-depos
/*         AND   saldo-estoq.cod-localiz = vLocalizacao  */
        AND   saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada  +
                                         saldo-estoq.qt-aloc-ped +
                                         saldo-estoq.qt-aloc-prod) > 0:  
        

        FOR FIRST int-saldo-estoq NO-LOCK
            {dbini/es322.i1 int-saldo-estoq saldo-estoq}:
        END.
        IF AVAIL int-saldo-estoq AND int-saldo-estoq.log-bloqueado THEN NEXT.        
        
        ASSIGN de-saldo = de-saldo + saldo-estoq.qtidade-atu - 
                                    (saldo-estoq.qt-alocada  +
                                     saldo-estoq.qt-aloc-ped +
                                     saldo-estoq.qt-aloc-prod).

    END.
END.
