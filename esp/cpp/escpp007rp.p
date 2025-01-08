/***********************************************************************
**  Programa..: ESP\CCP\ESCCP007RP.P
**  Autor.....: Giovane Oliveira
**  Data......: OUTUBRO/2005 - Desenvolvimento
**  Descricao.: Emitir relatorio com a producao de determinado periodo
**  VersÆo....: 001 03/10/2005
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCPP007 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/cpp/escpp007tt.i}
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
/****************************  Variaveis    ****************************/
/****************************  Frames       ****************************/
/****************************  Functions    ****************************/
FUNCTION fGetIntOfTimeString RETURNS INTEGER
   (INPUT ip_cTimeString AS CHARACTER):

   DEFINE VARIABLE iHours AS INTEGER NO-UNDO.
   DEFINE VARIABLE iMinutes AS INTEGER NO-UNDO.
   DEFINE VARIABLE iSeconds AS INTEGER NO-UNDO.
   DEFINE VARIABLE iTime AS INTEGER NO-UNDO.

   ASSIGN iTime = 0
          iHours   = INT(SUBSTRING(ip_cTimeString,1,2))
          iMinutes = INT(SUBSTRING(ip_cTimeString,4,2))
          iSeconds = INT(SUBSTRING(ip_cTimeString,7,2))
          iTime    = iSeconds * 1
                   + (iMinutes * 60)
                   + (iHours * 3600).
   RETURN iTime.
END FUNCTION.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

DEFINE VARIABLE chExcel AS COM-HANDLE      NO-UNDO.

create tt-param.
raw-transfer raw-param to tt-param.

form header
     "Item    Descri‡Æo                                 Custo            Qtde       Peso" skip
     "------- ------------------------------------ ---------- --------------- ----------"
     with width 132 no-box page-top frame f-lin-cab STREAM-IO.
     
form header
     skip(1)
     "Data       Item    Descri‡Æo                                  Custo            Qtde        Peso":U skip
     "---------- ------- ------------------------------------ ----------- --------------- -----------":U
     with width 170 no-box page-top frame f-cab-export STREAM-IO.

form header
     skip(1)
     "Nr Ordem    Item    Descri‡Æo                                 Custo            Qtde       Peso       Data Linha Est":U skip
     "----------- ------- ------------------------------------ ---------- --------------- ---------- ---------- ----- ---":U
     with width 170 no-box page-top frame f-cab-ordem STREAM-IO.

def buffer b-movto-estoq    for movto-estoq.

def temp-table tt-prod
    field nr-linha    like item.nr-linha 
    FIELD nr-ordem    AS INTEGER FORMAT ">>>,>>>,>>9"
    field desc-linha  like lin-prod.descricao
    field dt-trans    like movto-estoq.dt-trans
    field it-codigo   as char   format "x(7)"
    field desc-item   as char format "X(36)"
    field quantidade  like movto-estoq.quantidade format "->>>,>>>,>>9.99"
    field peso        like item.peso-bruto
    field custo       like item-estab.val-unit-mat-m[1] format ">>>,>>9.99"
    FIELD cod-estabel LIKE ord-prod.cod-estabel
    index tt-data is primary nr-linha dt-trans it-codigo
    index tt-item nr-linha it-codigo. 

DEF TEMP-TABLE tt-data
    FIELD dt-trans AS DATE.

DEF TEMP-TABLE tt-item
    FIELD it-codigo   AS CHAR
    FIELD nr-linha    AS INT
    FIELD cod-estabel AS CHAR.

def var h-acomp      as handle no-undo.
DEF VAR c-arq-excel AS CHAR.

DEFINE STREAM st-excel.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK WHERE
         empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relat¢rio de Produ‡Æo do Per¡odo"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCPP007"
       c-versao       = "2.04"
       c-revisao      = "000".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}    
    {include/i-rpout.i}
    
    run utp/ut-acomp.p persistent set h-acomp.      
    run pi-inicializar in h-acomp (input "Imprimindo...").
    run piImprimeRelat.

/*    IF tt-param.imprime-param THEN DO:*/
    if tt-param.tipo-rel = 1 OR
       tt-param.tipo-rel = 3 then do:
        HIDE FRAME f-lin-cab.
        PAGE.

        PUT skip(1)
            "SELE€ÇO"         
            skip(1)
            "Item: "    TO 40 tt-param.it-codigo-ini FORMAT "x(16)" " < > "      AT 58 tt-param.it-codigo-fim FORMAT "x(16)"
            "Linha: "   TO 40 tt-param.num-linha-ini FORMAT ">>9"   " < > "      AT 58 tt-param.num-linha-fim FORMAT ">>9"
            "Per¡odo: " TO 40 tt-param.periodo-ini   FORMAT "99/99/9999" " < > " AT 58 tt-param.periodo-fim   FORMAT "99/99/9999"
            "Hora: "    TO 40 tt-param.hora-ini      FORMAT "x(10)"  " < > "      AT 58 tt-param.hora-fim      FORMAT "x(10)" SKIP(1).

        PUT skip(1)
            "CLASSIFICA€ÇO"
            skip(1)
            tt-param.desc-classifica AT 1. 

         PUT skip(1)
            "IMPRESSÇO"
            skip(1)
            "Destino: "           TO 40 
            tt-param.arquivo    
            "Usu rio: " TO 40 tt-param.usuario     
            skip(1).
    END.
    run pi-finalizar in h-acomp.
    {include/i-rpclo.i}
    RETURN "OK".   
END.




/*****************************************************************************************
**
** PROCEDURES INTERNAS
**
*****************************************************************************************/
PROCEDURE piImprimeRelat:
    DEF VAR da-data       AS DATE NO-UNDO.
    DEF VAR de-quantidade AS DEC FORMAT "->>>,>>>,>>9.99".

    find FIRST tt-param no-lock no-error.
    
    FOR EACH tt-prod:
        DELETE tt-prod.
    END.

    DO da-data = tt-param.periodo-ini to tt-param.periodo-fim:

        IF  tt-param.classifica <> 3 THEN DO:
            FOR EACH movto-estoq NO-LOCK
               WHERE movto-estoq.esp-docto = 1
                 and movto-estoq.dt-trans = da-data
                 and movto-estoq.cod-estabel >= tt-param.estabi
                 AND movto-estoq.cod-estabel <= tt-param.estabf
                 and movto-estoq.it-codigo   >= tt-param.it-codigo-ini
                 and movto-estoq.it-codigo   <= tt-param.it-codigo-fim
                 break by movto-estoq.nr-ord-prod:                   
            
                find ord-prod where
                     ord-prod.nr-ord-prod = movto-estoq.nr-ord-produ no-lock no-error.
                if not avail ord-prod then next.
                
                /* ID de Incidente: IR50798 */
                /*if ord-prod.nr-linha = 20 then next.*/
             
                IF ord-prod.nr-linha < tt-param.num-linha-ini OR
                   ord-prod.nr-linha > tt-param.num-linha-fim THEN NEXT.

                IF fGetIntOfTimeString(INPUT movto-estoq.hr-trans) < fGetIntOfTimeString(INPUT tt-param.hora-ini) THEN NEXT.
                IF fGetIntOfTimeString(INPUT movto-estoq.hr-trans) > fGetIntOfTimeString(INPUT tt-param.hora-fim) THEN NEXT.
    
                if tt-param.ordem <> 10 and ord-prod.tipo <> tt-param.ordem then next.            
                
                RUN pi-acompanhar IN h-acomp (INPUT "Lendo ACA data: " + string(movto-estoq.dt-trans)).
                
                FIND tt-prod                                     WHERE
                     tt-prod.nr-linha  = ord-prod.nr-linha AND
                     tt-prod.it-codigo = movto-estoq.it-codigo   AND
                     tt-prod.dt-trans  = movto-estoq.dt-trans    NO-ERROR.
                IF NOT AVAIL tt-prod THEN DO:                                     
                    CREATE tt-prod.
                    ASSIGN tt-prod.nr-linha    = ord-prod.nr-linha 
                           tt-prod.dt-trans    = movto-estoq.dt-trans
                           tt-prod.it-codigo   = movto-estoq.it-codigo
                           tt-prod.cod-estabel = movto-estoq.cod-estabel.
                           
                    find item where item.it-codigo = tt-prod.it-codigo no-lock no-error.
                    if avail item then
                        assign tt-prod.desc-item = item.desc-item
                               tt-prod.peso      = item.peso-liquido.
                    
                    find item-estab where item-estab.it-codigo = tt-prod.it-codigo and
                                          item-estab.cod-estabel = movto-estoq.cod-estabel
                                          no-lock no-error.
                    if avail item-estab then
                        assign tt-prod.custo = item-estab.val-unit-mat-m[1] +
                                               item-estab.val-unit-mob-m[1] +
                                               item-estab.val-unit-ggf-m[1].
                       
                    find first lin-prod NO-LOCK 
                         where lin-prod.nr-linha = ord-prod.nr-linha no-error.
                    if avail lin-prod then
                        assign tt-prod.desc-linha = lin-prod.descricao.
                END.
    
                ASSIGN tt-prod.quantidade = tt-prod.quantidade + movto-estoq.quantidade.
                
            END. /* FOR EACH movto-estoq NO-LOCK */
    
            FOR EACH movto-estoq NO-LOCK
               WHERE movto-estoq.esp-docto = 8
                 and movto-estoq.dt-trans = da-data
                 and movto-estoq.cod-estabel >= tt-param.estabi
                 AND movto-estoq.cod-estabel <= tt-param.estabf
                 and movto-estoq.it-codigo   >= tt-param.it-codigo-ini
                 and movto-estoq.it-codigo   <= tt-param.it-codigo-fim
                 break by movto-estoq.nr-ord-prod:                   
            
                find ord-prod where
                     ord-prod.nr-ord-prod = movto-estoq.nr-ord-produ no-lock no-error.
                if not avail ord-prod then next.
                
                /* ID de Incidente: IR50798 */
                /*if ord-prod.nr-linha = 20 then next.*/
    
                IF ord-prod.nr-linha < tt-param.num-linha-ini OR
                   ord-prod.nr-linha > tt-param.num-linha-fim THEN NEXT.
    
                if tt-param.ordem <> 10 and ord-prod.tipo <> tt-param.ordem then next.
                
                RUN pi-acompanhar IN h-acomp (INPUT "Lendo EAC data: " + string(movto-estoq.dt-trans)).
                
                FIND tt-prod                                     WHERE
                     tt-prod.nr-linha  = ord-prod.nr-linha AND
                     tt-prod.it-codigo = movto-estoq.it-codigo   AND
                     tt-prod.dt-trans  = movto-estoq.dt-trans    NO-ERROR.
                IF NOT AVAIL tt-prod THEN DO:
                    CREATE tt-prod.
                    ASSIGN tt-prod.nr-linha    = ord-prod.nr-linha 
                           tt-prod.dt-trans    = movto-estoq.dt-trans
                           tt-prod.it-codigo   = movto-estoq.it-codigo
                           tt-prod.cod-estabel = movto-estoq.cod-estabel.
                           
                    find item where item.it-codigo = tt-prod.it-codigo no-lock no-error.
                    if avail item then
                        assign tt-prod.desc-item = item.desc-item
                               tt-prod.peso      = item.peso-liquido.
                        
                    find item-estab where item-estab.it-codigo = tt-prod.it-codigo and
                                          item-estab.cod-estabel = movto-estoq.cod-estabel
                                          no-lock no-error.
                    if avail item-estab then
                        assign tt-prod.custo = item-estab.val-unit-mat-m[1] +
                                               item-estab.val-unit-mob-m[1] +
                                               item-estab.val-unit-ggf-m[1].
                    
                    find first lin-prod NO-LOCK 
                         where lin-prod.nr-linha = ord-prod.nr-linha no-error.
                    if avail lin-prod then
                        assign tt-prod.desc-linha = lin-prod.descricao.                    
                END.
    
                ASSIGN tt-prod.quantidade = tt-prod.quantidade - movto-estoq.quantidade.
                
            END. /* FOR EACH movto-estoq NO-LOCK */ 
        END.
        ELSE DO: /* POR ORDEM */
            FOR EACH movto-estoq NO-LOCK
               WHERE movto-estoq.esp-docto = 1
                 and movto-estoq.dt-trans = da-data
                 and movto-estoq.cod-estabel >= tt-param.estabi
                 AND movto-estoq.cod-estabel <= tt-param.estabf
                 and movto-estoq.it-codigo   >= tt-param.it-codigo-ini
                 and movto-estoq.it-codigo   <= tt-param.it-codigo-fim
                 break by movto-estoq.nr-ord-prod:                   
            
                find ord-prod where
                     ord-prod.nr-ord-prod = movto-estoq.nr-ord-produ no-lock no-error.
                if not avail ord-prod then next.
                
                /* ID de Incidente: IR50798 */
                /*if ord-prod.nr-linha = 20 then next.*/
             
                IF ord-prod.nr-linha < tt-param.num-linha-ini OR
                   ord-prod.nr-linha > tt-param.num-linha-fim THEN NEXT.
    
                IF fGetIntOfTimeString(INPUT movto-estoq.hr-trans) < fGetIntOfTimeString(INPUT tt-param.hora-ini) THEN NEXT.
                IF fGetIntOfTimeString(INPUT movto-estoq.hr-trans) > fGetIntOfTimeString(INPUT tt-param.hora-fim) THEN NEXT.

                if tt-param.ordem <> 10 and ord-prod.tipo <> tt-param.ordem then next.            
                
                RUN pi-acompanhar IN h-acomp (INPUT "Lendo ACA data: " + string(movto-estoq.dt-trans)).
                
                FIND tt-prod 
                    WHERE tt-prod.nr-ordem  = ord-prod.nr-ord-prod
                      AND tt-prod.it-codigo = movto-estoq.it-codigo   NO-ERROR.
                IF NOT AVAIL tt-prod THEN DO:                                     
                    CREATE tt-prod.
                    ASSIGN tt-prod.nr-ordem    = ord-prod.nr-ord-prod
                           tt-prod.it-codigo   = movto-estoq.it-codigo
                           tt-prod.cod-estabel = movto-estoq.cod-estabel
                           tt-prod.nr-linha    = ord-prod.nr-linha
                           tt-prod.dt-trans    = movto-estoq.dt-trans.
                           
                    find item where item.it-codigo = tt-prod.it-codigo no-lock no-error.
                    if avail item then
                        assign tt-prod.desc-item = item.desc-item
                               tt-prod.peso      = item.peso-liquido.
                    
                    find item-estab where item-estab.it-codigo = tt-prod.it-codigo and
                                          item-estab.cod-estabel = movto-estoq.cod-estabel
                                          no-lock no-error.
                    if avail item-estab then
                        assign tt-prod.custo = item-estab.val-unit-mat-m[1] +
                                               item-estab.val-unit-mob-m[1] +
                                               item-estab.val-unit-ggf-m[1].
                END.
    
                ASSIGN tt-prod.quantidade = tt-prod.quantidade + movto-estoq.quantidade.
                
            END. /* FOR EACH movto-estoq NO-LOCK */
    
            FOR EACH movto-estoq NO-LOCK
               WHERE movto-estoq.esp-docto = 8
                 and movto-estoq.dt-trans = da-data
                 and movto-estoq.cod-estabel >= tt-param.estabi
                 AND movto-estoq.cod-estabel <= tt-param.estabf
                 and movto-estoq.it-codigo   >= tt-param.it-codigo-ini
                 and movto-estoq.it-codigo   <= tt-param.it-codigo-fim
                 break by movto-estoq.nr-ord-prod:                   
            
                find ord-prod where
                     ord-prod.nr-ord-prod = movto-estoq.nr-ord-produ no-lock no-error.
                if not avail ord-prod then next.
                
                /* ID de Incidente: IR50798 */
                /*if ord-prod.nr-linha = 20 then next.*/
    
                IF ord-prod.nr-linha < tt-param.num-linha-ini OR
                   ord-prod.nr-linha > tt-param.num-linha-fim THEN NEXT.
    
                if tt-param.ordem <> 10 and ord-prod.tipo <> tt-param.ordem then next.
                
                RUN pi-acompanhar IN h-acomp (INPUT "Lendo EAC data: " + string(movto-estoq.dt-trans)).
                
                FIND tt-prod 
                    WHERE tt-prod.nr-ordem  = ord-prod.nr-ord-prod 
                      AND tt-prod.it-codigo = movto-estoq.it-codigo   NO-ERROR.
                IF NOT AVAIL tt-prod THEN DO:                                     
                    CREATE tt-prod.
                    ASSIGN tt-prod.nr-ordem    = ord-prod.nr-ord-prod 
                           tt-prod.it-codigo   = movto-estoq.it-codigo
                           tt-prod.cod-estabel = movto-estoq.cod-estabel.

                    find item where item.it-codigo = tt-prod.it-codigo no-lock no-error.
                    if avail item then
                        assign tt-prod.desc-item = item.desc-item
                               tt-prod.peso      = item.peso-liquido.
                        
                    find item-estab where item-estab.it-codigo = tt-prod.it-codigo and
                                          item-estab.cod-estabel = movto-estoq.cod-estabel
                                          no-lock no-error.
                    if avail item-estab then
                        assign tt-prod.custo = item-estab.val-unit-mat-m[1] +
                                               item-estab.val-unit-mob-m[1] +
                                               item-estab.val-unit-ggf-m[1].
                    
                    find first lin-prod NO-LOCK 
                         where lin-prod.nr-linha = ord-prod.nr-linha no-error.
                    if avail lin-prod then
                        assign tt-prod.desc-linha = lin-prod.descricao.                    
                END.
    
                ASSIGN tt-prod.quantidade = tt-prod.quantidade - movto-estoq.quantidade.
            END.
        END.

    end.
    
    /* PadrÆo */
    if tt-param.tipo-rel = 1 then do:
        VIEW FRAME f-cabec.
        VIEW FRAME f-rodape.    
    
        IF tt-param.classifica = 1 THEN DO:
           VIEW FRAME f-lin-cab.
           FOR EACH tt-prod BREAK BY tt-prod.nr-linha
                                  BY tt-prod.dt-trans 
                                  BY tt-prod.it-codigo:
               RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo linha: " + STRING(tt-prod.nr-linha)).
               
               IF FIRST-OF(tt-prod.nr-linha) THEN DO:
                  DISP tt-prod.nr-linha label "Linha "
                       tt-prod.desc-linha WITH FRAME f-linha NO-LABELS SIDE-LABELS.
               END.
               IF FIRST-OF(tt-prod.dt-trans) THEN DO:
                  DISP tt-prod.dt-trans label "Data Transa‡Æo: "
                       SKIP(1)
                       WITH SIDE-LABELS NO-LABELS FRAME f-data.
               END.
               IF LAST-OF(tt-prod.it-codigo) THEN DO:
                  disp tt-prod.it-codigo AT 01
                       tt-prod.desc-item 
                       tt-prod.custo
                       tt-prod.quantidade (total by tt-prod.nr-linha)
                       tt-prod.peso * tt-prod.quantidade (total)
                       with width 142 no-labels frame f-imp-1 stream-io.
               END.
           END.
        END.
        ELSE 
            IF  tt-param.classifica = 2 THEN DO:
                VIEW FRAME f-lin-cab.
                FOR EACH tt-prod BREAK BY tt-prod.nr-linha
                                       BY tt-prod.it-codigo:
                    RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo linha: " + STRING(tt-prod.nr-linha)).
               
                    IF FIRST-OF(tt-prod.nr-linha) THEN DO:
                       DISP tt-prod.nr-linha label "Linha "
                            tt-prod.desc-linha
                            SKIP(1)
                            WITH SIDE-LABELS FRAME f-linha1 NO-LABELS.
                    END.
                    ASSIGN de-quantidade = de-quantidade + tt-prod.quantidade.
               
                    IF LAST-OF(tt-prod.it-codigo) THEN DO:
                       disp tt-prod.it-codigo at 01
                            tt-prod.desc-item space(1)
                            tt-prod.custo
                            de-quantidade (total by tt-prod.nr-linha)
                            tt-prod.peso * de-quantidade (total)
                            with width 142 no-labels frame f-imp-2 stream-io.
                       ASSIGN de-quantidade = 0.
                    END.
                END.
            END.
            ELSE DO: /* por Ordem */
                  VIEW FRAME f-cab-ordem.
                  FOR EACH tt-prod 
                      BREAK BY tt-prod.nr-ordem
                            BY tt-prod.it-codigo:
                      RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo Ordem: " + STRING(tt-prod.nr-ordem)).
                
                      IF LAST-OF(tt-prod.it-codigo) THEN DO:
                         disp tt-prod.nr-ordem COLUMN-LABEL "Ordem" AT 1
                              tt-prod.it-codigo TO 19
                              tt-prod.desc-item space(1)
                              tt-prod.custo
                              tt-prod.quantidade (TOTAL)
                              tt-prod.peso * tt-prod.quantidade (total)
                              tt-prod.dt-trans    COLUMN-LABEL "Data"
                              tt-prod.nr-linha    COLUMN-LABEL "Linha" FORMAT "zzzz9"
                              tt-prod.cod-estabel COLUMN-LABEL "Est"
                              with width 142 no-labels frame f-imp-3 stream-io.
                         ASSIGN de-quantidade = 0.
                      END.
                  END.
            END.
    end.

    /* Exporta‡Æo */
    else if tt-param.tipo-rel = 2 then do:

        IF tt-param.classifica = 1 THEN DO:
        
            VIEW FRAME f-cab-export.
            
            FOR EACH tt-prod BREAK BY tt-prod.nr-linha
                                  BY tt-prod.dt-trans 
                                  BY tt-prod.it-codigo:
                                  
                RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo linha: " + STRING(tt-prod.nr-linha)).
                
                put unformatted
                     string(tt-prod.dt-trans, "99/99/9999":U)                   at 01
                     string(tt-prod.it-codigo, "x(7)":U)                        at 12
                     string(tt-prod.desc-item, "x(36)":U)                       at 20
                     string(tt-prod.custo, "->>>,>>9.99":U)                     at 57
                     string(tt-prod.quantidade, "->>>,>>>,>>9.99":U)            at 69
                     string(tt-prod.peso * tt-prod.quantidade, "->>>,>>9.99":U) at 85.
           END.
        END.
        ELSE IF  tt-param.classifica = 2 THEN DO:
                 FOR EACH tt-prod
                    BREAK by tt-prod.nr-linha
                          by tt-prod.it-codigo:
                    RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo linha: " + STRING(tt-prod.nr-linha)).
                    
                    ASSIGN de-quantidade = de-quantidade + tt-prod.quantidade.
                
                    IF LAST-OF(tt-prod.it-codigo) THEN DO:
                          
                       PUT tt-prod.it-codigo at 17
                           tt-prod.desc-item space(2)
                           tt-prod.custo
                           tt-prod.peso * de-quantidade
                           de-quantidade.
                       ASSIGN de-quantidade = 0.
                    END.
                END.
             END.    
             ELSE DO: /* Por Ordem */   
                 FOR EACH tt-prod
                    BREAK by tt-prod.nr-ordem
                          by tt-prod.it-codigo:
                    RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo ordem: " + STRING(tt-prod.nr-ordem)).
             
                    IF LAST-OF(tt-prod.it-codigo) THEN DO:
             
                       PUT tt-prod.nr-ordem TO 9
                           tt-prod.it-codigo at 17
                           tt-prod.desc-item space(2)
                           tt-prod.custo
                           tt-prod.peso * tt-prod.quantidade
                           de-quantidade.
                       ASSIGN de-quantidade = 0.
                    END.
                END.
             END.
    end.

    /* Excel */
    else if tt-param.tipo-rel = 3 then do:

        EMPTY TEMP-TABLE tt-data.

        IF  tt-param.classifica <> 3 THEN DO:
    
            FOR EACH tt-prod:
    
                IF NOT can-find(FIRST tt-data
                                WHERE tt-data.dt-trans  = tt-prod.dt-trans) THEN DO:
    
                    CREATE tt-data.
                    ASSIGN tt-data.dt-trans   = tt-prod.dt-trans.
    
                END.
    
                IF NOT CAN-FIND(FIRST tt-item
                                WHERE tt-item.it-codigo = tt-prod.it-codigo
                                AND   tt-item.nr-linha  = tt-prod.nr-linha) THEN DO:
    
                    CREATE tt-item.
                    ASSIGN tt-item.it-codigo   = tt-prod.it-codigo
                           tt-item.nr-linha    = tt-prod.nr-linha
                           tt-item.cod-estabel = tt-prod.cod-estabel.
    
                END.
                
    
            END.
    
            ASSIGN c-arq-excel = SESSION:TEMP-DIR + "escpp007" + STRING(TIME) + ".csv".
    
            OUTPUT STREAM st-excel TO value(c-arq-excel).
    
            PUT STREAM st-excel UNFORMATTED 
                "Item;Linha".
    
            FOR EACH tt-data BY tt-data.dt-trans:
                PUT STREAM st-excel UNFORMATTED
                    ";" tt-data.dt-trans.
            END.
    
            PUT STREAM st-excel UNFORMATTED
                SKIP.
            
            FOR EACH tt-item BY tt-item.nr-linha:
    
                PUT STREAM st-excel UNFORMATTED
                    tt-item.it-codigo ";" tt-item.nr-linha ";".
    
                FOR EACH tt-data BY tt-data.dt-trans:
    
                    FOR FIRST tt-prod
                        WHERE tt-prod.it-codigo = tt-item.it-codigo
                        AND   tt-prod.dt-trans  = tt-data.dt-trans
                        AND   tt-prod.nr-linha  = tt-item.nr-linha:
                    END.
    
                    IF AVAIL tt-prod THEN
                        PUT STREAM st-excel UNFORMATTED
                            tt-prod.quantidade ";".
                    ELSE
                        PUT STREAM st-excel UNFORMATTED
                            0 ";".
    
                END.
    
                PUT STREAM st-excel UNFORMATTED
                    SKIP.
    
            END.
    
            OUTPUT STREAM st-excel CLOSE.
        END.
        ELSE DO: /* Por Ordem */

            ASSIGN c-arq-excel = SESSION:TEMP-DIR + "escpp007" + STRING(TIME) + ".csv".
    
            OUTPUT STREAM st-excel TO value(c-arq-excel).
    
            PUT STREAM st-excel UNFORMATTED "Nr Ordem;Item;Quantidade;Data;Linha;Est" SKIP.
            
            FOR EACH tt-prod 
                BREAK BY tt-prod.nr-ordem
                      BY tt-prod.it-codigo:

                IF  LAST-OF(tt-prod.it-codigo) THEN DO:
                    PUT STREAM st-excel UNFORMATTED tt-prod.nr-ordem ";" 
                                                    tt-prod.it-codigo ";" 
                                                    tt-prod.quantidade ";" 
                                                    tt-prod.dt-trans ";"
                                                    tt-prod.nr-linha ";"
                                                    tt-prod.cod-estabel ";"
                                                    SKIP.
                END.
            END.
    
            OUTPUT STREAM st-excel CLOSE.
        END.
        /**/

        create "Excel.Application":U chExcel connect no-error.
        if error-status:error then 
            create "Excel.Application":U chExcel.

        chExcel:WorkBooks:Open(c-arq-excel).

        ASSIGN chExcel:visible = true.

        release object chExcel.



    END.


END.


/**** Fim do programa ****/
