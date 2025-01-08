/***********************************************************************
**  Programa..: esp\pdp\espdp091a.p 
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Gera 1 Ordem Produá∆o por execuss∆o
**  Vers∆o....: 001 16/11/2004
**                  Desenvolvimento Programa
************************************************************************/
/****************************   Temp-Tables  ****************************/
{esapi/esapi006tt.i}
{esapi/esapi007tt.i}
{upc/btb910za-upc.i}
{esinc/es0005.i "v_cod_estab_usuar"} /* Busca Data Ultimo Faturamento - vDtFatur */
/* IF v_cod_estab_usuar = "102" THEN DO:                     */
/*     FOR FIRST b-estabelec NO-LOCK                                   */
/*        WHERE b-estabelec.cod-estabel = v_cod_estab_usuar, */
/*        FIRST ser-estab NO-LOCK                                      */
/*           WHERE ser-estab.cod-estabel = b-estabelec.cod-estabel     */
/*             AND ser-estab.serie       = "1.":                       */
/*        ASSIGN vDtFatur = ser-estab.dt-ult-fat.                      */
/*     END.                                                            */
/* END.                                                                */
DEFINE TEMP-TABLE tt-reporte-item
      FIELD cod-estabel   LIKE estabelec.cod-estabel
      FIELD log-reporta   AS LOGICAL 
      FIELD it-codigo     LIKE ITEM.it-codigo
      FIELD desc-item     LIKE ITEM.desc-item FORMAT 'X(50)'
      FIELD qt-saldo      AS DEC
      INDEX id it-codigo.

/****************************  Variaveis    ****************************/
def input param pCodEstabel    as char  no-undo.
DEF INPUT  PARAM pRowPedEnt    AS ROWID NO-UNDO.
DEF INPUT  PARAM pQtOrdem      AS INT   NO-UNDO.
DEF INPUT  PARAM vCod-depos    AS CHARACTER NO-UNDO.
DEF INPUT  PARAM vLocalizacao  AS CHARACTER   NO-UNDO.
DEF OUTPUT PARAM pOrdemGerada  AS CHAR  NO-UNDO.
DEF OUTPUT PARAM pMsgErro      AS CHAR  NO-UNDO.

DEF VAR c-grupo-aloca   LIKE estabelec.grupo-aloca      NO-UNDO.
DEF VAR deQtDisponivel  LIKE saldo-estoq.qtidade-atu    NO-UNDO.
DEF VAR de-saldo        AS DECIMAL                      NO-UNDO.
DEF VAR cReturn         AS CHAR                         NO-UNDO.

DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.

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
               tt-ordem.estado                  = 1 /* N∆o Iniciada */
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
      Cria Ordem de Produá∆o 
     */

/*     FOR EACH saldo-estoq NO-LOCK                                                   */
/*         WHERE saldo-estoq.cod-estabel = pCodEstabel                                */
/*         AND   saldo-estoq.it-codigo   = tt-reporte-item.it-codigo                  */
/*         AND   saldo-estoq.cod-depos   = vCod-depos:                                */
/*                                                                                    */
/*         MESSAGE 'Antes saldo-estoq.qtidade-atu   ' saldo-estoq.qtidade-atu    SKIP */
/*                 'saldo-estoq.qt-alocada    ' saldo-estoq.qt-alocada     SKIP       */
/*                 'saldo-estoq.qt-aloc-ped   ' saldo-estoq.qt-aloc-ped    SKIP       */
/*                 'saldo-estoq.qt-aloc-prod  ' saldo-estoq.qt-aloc-prod              */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                     */
/*                                                                                    */
/*     END.                                                                           */

    RUN esapi/esapi007.p (INPUT "ES-PD4000K",
                          INPUT-OUTPUT TABLE tt-ordem,
                          OUTPUT cReturn).

/*     FOR EACH saldo-estoq NO-LOCK                                                    */
/*         WHERE saldo-estoq.cod-estabel = pCodEstabel                                 */
/*         AND   saldo-estoq.it-codigo   = tt-reporte-item.it-codigo                   */
/*         AND   saldo-estoq.cod-depos   = vCod-depos:                                 */
/*                                                                                     */
/*         MESSAGE 'Depois saldo-estoq.qtidade-atu   ' saldo-estoq.qtidade-atu    SKIP */
/*                 'saldo-estoq.qt-alocada    ' saldo-estoq.qt-alocada     SKIP        */
/*                 'saldo-estoq.qt-aloc-ped   ' saldo-estoq.qt-aloc-ped    SKIP        */
/*                 'saldo-estoq.qt-aloc-prod  ' saldo-estoq.qt-aloc-prod               */
/*             VIEW-AS ALERT-BOX INFO BUTTONS OK.                                      */
/*                                                                                     */
/*     END.                                                                            */

    IF  cReturn = "NOK" THEN
        ASSIGN pMsgErro = "NOK".
    ELSE IF  cReturn <> "" THEN
        ASSIGN pMsgErro = cReturn.

    FOR EACH tt-ordem:
        IF pOrdemGerada = "" THEN 
             ASSIGN pOrdemGerada = string(tt-ordem.nr-ord-produ).
        ELSE ASSIGN pOrdemGerada = pOrdemGerada + "," + string(tt-ordem.nr-ord-produ).
    END.
END.

PROCEDURE PiCriaTempTable:
    FOR FIRST ped-ent NO-LOCK
        WHERE ROWID(ped-ent) = pRowPedEnt 
        /*AND  (ped-ent.qt-pedida - ped-ent.qt-atendida) > 0*/ ,
        FIRST ITEM NO-LOCK 
        WHERE item.it-codigo = ped-ent.it-codigo,
        FIRST item-uni-estab NO-LOCK
        WHERE item-uni-estab.cod-estabel = pCodEstabel
        AND   item-uni-estab.it-codigo   = ITEM.it-codigo:
        IF  item-uni-estab.nr-linha <> 20 THEN DO:
            ASSIGN pMsgErro = "Ordem de produá∆o n∆o Ç do tipo Centrais Configuradas".
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
                           INPUT 0,            /* N°vel */
                           INPUT-OUTPUT TABLE tt-estrutura,
                           INPUT vDtFatur,     /* Data Corte */
                           INPUT YES,          /* Recursivo */
                           INPUT 19,           /* N°veis */
                           INPUT "101").       /* Estabel */
    FOR EACH  tt-estrutura
        WHERE NOT tt-estrutura.log-fantasma
        AND   tt-estrutura.compr-fabric = 2:

        FIND ITEM
             WHERE ITEM.it-codigo = tt-estrutura.es-codigo NO-LOCK NO-ERROR.
        IF AVAIL ITEM AND ITEM.baixa-estoq = YES THEN DO:
            RUN PiBuscaSaldo(INPUT tt-estrutura.es-codigo,
                             INPUT tt-estrutura.refer).
            IF de-saldo = 0 THEN
               ASSIGN pMsgErro = "N∆o h† Saldo Estoque para o Componente " + tt-estrutura.es-codigo.
            IF  de-saldo > pQtSaldo  THEN
                 ASSIGN pQtSaldo = pQtSaldo.
            ELSE ASSIGN pQtSaldo = de-saldo / tt-estrutura.quant-usada.
        END.
    END.
END.

PROCEDURE PiBuscaSaldo:
    DEFINE INPUT PARAM pItCodigo LIKE saldo-estoq.it-codigo NO-UNDO.
    DEFINE INPUT PARAM pCodRefer LIKE saldo-estoq.cod-refer NO-UNDO.

    ASSIGN de-saldo = 0.    
    IF pCodEstabel = "102" THEN
        FOR EACH saldo-estoq NO-LOCK
            WHERE saldo-estoq.cod-estabel = pCodEstabel
            AND   saldo-estoq.it-codigo   = pItCodigo
            AND   saldo-estoq.cod-refer   = pCodRefer
            AND   saldo-estoq.cod-depos   = vCod-depos
            AND   saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada  +
                                             saldo-estoq.qt-aloc-ped +
                                             saldo-estoq.qt-aloc-prod) > 0:  
            FOR FIRST ponto-programa
                where ponto-programa.nome-programa = "espdp091"
                  AND ponto-programa.ponto = 2,
                FIRST conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                  AND ENTRY(1,conteudo-programa.conteudo) = saldo-estoq.cod-depos
                  AND ENTRY(2,conteudo-programa.conteudo) = saldo-estoq.cod-localiz:     /* desconsidera as localizaá‰es cadastradas aqui */
            END.
            IF AVAIL conteudo-programa THEN DO:
                NEXT.                   
            END.

            IF vLocalizacao <> "" AND
               saldo-estoq.cod-localiz <> vLocalizacao THEN NEXT.
    
            FOR FIRST int-saldo-estoq NO-LOCK
                {dbini/es322.i1 int-saldo-estoq saldo-estoq}:
            END.
            IF AVAIL int-saldo-estoq AND int-saldo-estoq.log-bloqueado THEN NEXT.        
            
            ASSIGN de-saldo = de-saldo + saldo-estoq.qtidade-atu - 
                                        (saldo-estoq.qt-alocada  +
                                         saldo-estoq.qt-aloc-ped +
                                         saldo-estoq.qt-aloc-prod).
        END.
    ELSE
        FOR EACH saldo-estoq NO-LOCK
            WHERE saldo-estoq.cod-estabel = pCodEstabel
            AND   saldo-estoq.it-codigo   = pItCodigo
            AND   saldo-estoq.cod-refer   = pCodRefer
            AND   saldo-estoq.cod-depos   = vCod-depos
            AND   saldo-estoq.qtidade-atu - (saldo-estoq.qt-alocada  +
                                             saldo-estoq.qt-aloc-ped +
                                             saldo-estoq.qt-aloc-prod) > 0:  
            
            FOR FIRST ponto-programa
                where ponto-programa.nome-programa = "espdp091"
                  AND ponto-programa.ponto = 2,
                FIRST conteudo-programa NO-LOCK
                WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa
                  AND ENTRY(1,conteudo-programa.conteudo) = saldo-estoq.cod-depos
                  AND ENTRY(2,conteudo-programa.conteudo) = saldo-estoq.cod-localiz:     /* desconsidera as localizaá‰es cadastradas aqui */
            END.
            IF AVAIL conteudo-programa THEN DO:
                NEXT.                   
            END.    
            IF vLocalizacao <> "" AND
               saldo-estoq.cod-localiz <> vLocalizacao THEN NEXT.

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
