{include/i-prgvrs.i ESOFP001 2.04.00.001}
/***********************************************************************
**  Programa..: ESP\OFP\ESOFP001RP.P
**  Autor.....: Marcio Chaves - Gestech
**  Data......: NOVEMBRO/2004 - Desenvolvimento
**  Descricao.: Relatorio IBAMA
**  VersÆo....: 001 03/11/2004
**                  Desenvolvimento Programa
**  ConversÆo.: es0750.p - Claudiney
************************************************************************/

/****************************  Definitions  ****************************/
{esp/ofp/esofp001tt.i}
{esp/ofp/table-teste.i}

{include/i-rpvar.i}


/****************************  Temp-Tables  ****************************/
def temp-table tt-aca
    FIELD cd-grupo     AS CHARACTER
    FIELD ds-grupo     AS CHARACTER FORMAT "X(30)"
    field cd-unid-com  AS CHARACTER
    field ds-unid-com  AS CHARACTER FORMAT "x(30)"
    field cd-seg-com   AS CHARACTER
    field ds-seg-com   AS CHARACTER FORMAT "x(30)"
    FIELD cd-fam-com   AS CHARACTER
    field ds-fam-com   AS CHARACTER FORMAT "x(30)"
    field qtde         as dec
    index tt-aca is primary unique cd-grupo cd-unid-com cd-seg-com cd-fam-com.

def temp-table tt-mp
    FIELD cd-grupo     LIKE grup-estoque.ge-codigo
    FIELD ds-grupo     AS CHARACTER FORMAT "X(30)"
    field fm-codigo    like item.fm-codigo
    field qtde         as dec
    field qt-faturada  as dec
    index tt-itens is primary unique cd-grupo fm-codigo.

/****************************  Variaveis    ****************************/
def var da-data            as date.
DEFINE VAR c-ini           AS CHAR.
DEFINE VAR c-fim           AS CHAR.
DEFINE VAR c-ini2          AS CHAR.
DEFINE VAR c-fim2          AS CHAR.
/****************************  Frames       ****************************/

DEF BUFFER b-fam-com-item FOR fam-com-item.
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/*
 * for each tt-raw-digita:
 *     create tt-digita.
 *     raw-transfer tt-raw-digita.raw-digita to tt-digita.
 * end. 
 */

def var h-acomp      as handle no-undo.
find first mgcad.empresa NO-LOCK
     where empresa.ep-codigo = tt-param.ep-codigo no-error.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relat¢rio IBAMA"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESOFP001"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i}
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Montando Relat¢rio...").
   run pi-relat.
   run pi-inicializar in h-acomp (input "Imprimindo...").
   run pi-imprime.

   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */
PROCEDURE pi-relat:
     DO da-data = tt-param.da-ini to tt-param.da-fim:
        FOR each movto-estoq fields(movto-estoq.cod-estabel movto-estoq.it-codigo movto-estoq.esp-docto movto-estoq.quantidade movto-estoq.dt-trans movto-estoq.it-codigo) USE-INDEX data-esp no-lock 
            where movto-estoq.dt-trans = da-data
              AND (movto-estoq.esp-docto = 1  /** aca **/
               OR movto-estoq.esp-docto = 8)  /**eac**/
              AND movto-estoq.cod-estabel >= tt-param.cod-estabel-ini
              AND movto-estoq.cod-estabel <= tt-param.cod-estabel-fim
              and movto-estoq.it-codigo BEGINS "4":
    
            IF movto-estoq.it-codigo <= c-it-codigo-ini OR
               movto-estoq.it-codigo >= c-it-codigo-fim THEN NEXT.
    
            RUN pi-acompanhar IN h-acomp (INPUT "Data-Item.: " + string(movto-estoq.dt-trans)
                                          + " - " + movto-estoq.it-codigo).

            FIND FIRST ITEM                                                                    
                 WHERE ITEM.it-codigo = movto-estoq.it-codigo NO-LOCK NO-ERROR.                
                                                                                               
            find first fam-com-item                                                        
                 where fam-com-item.fm-cod-com = SUBSTRING(ITEM.fm-cod-com,1,2)  NO-ERROR.  
                                                                                               
            find first b-fam-com-item                                                       
                 where b-fam-com-item.fm-cod-com = SUBSTRING(ITEM.fm-cod-com,1,4)  NO-ERROR.

            find first tt-aca where
                 tt-aca.cd-grupo    = STRING(ITEM.ge-codigo) and
                 tt-aca.cd-unid-com = SUBSTRING(ITEM.fm-cod-com,1,2) and
                 tt-aca.cd-seg-com  = SUBSTRING(ITEM.fm-cod-com,1,4) and
                 tt-aca.cd-fam-com  = SUBSTRING(ITEM.fm-cod-com,1,5) 
                no-error.

            if not avail tt-aca then do:
               create tt-aca.
               ASSIGN tt-aca.cd-grupo    = STRING(ITEM.ge-codigo) 
                      tt-aca.cd-unid-com = SUBSTRING(ITEM.fm-cod-com,1,2) 
                      tt-aca.cd-seg-com  = SUBSTRING(ITEM.fm-cod-com,1,4) 
                      tt-aca.cd-fam-com  = SUBSTRING(ITEM.fm-cod-com,1,5). 
                       
               If avail fam-com-item then 
                  assign tt-aca.ds-unid-com = fam-com-item.descricao.
               if avail b-fam-com-item then 
                  assign tt-aca.ds-seg-com = b-fam-com-item.descricao.
               find first fam-com-item
                    where fam-com-item.fm-cod-com = SUBSTRING(ITEM.fm-cod-com,1,5)  NO-ERROR.
               If avail fam-com-item then 
                  assign tt-aca.ds-fam-com = fam-com-item.descricao.
               FIND grup-estoque
                   WHERE grup-estoque.ge-codigo = ITEM.ge-codigo NO-LOCK NO-ERROR.
               IF AVAIL grup-estoque THEN
                   ASSIGN tt-aca.ds-grupo      = grup-estoque.descricao.

            end.
    
            if movto-estoq.esp-docto = 1 /*"aca"*/ then
               assign tt-aca.qtde = tt-aca.qtde + 
                                    movto-estoq.quantidade.
            if movto-estoq.esp-docto = 8 /*"eac"*/ then
               assign tt-aca.qtde = tt-aca.qtde -
                                    movto-estoq.quantidade.
        END.
     END.
    
     DO da-data = tt-param.da-ini to tt-param.da-fim:
       FOR each movto-estoq fields(movto-estoq.cod-estabel movto-estoq.it-codigo movto-estoq.esp-docto movto-estoq.quantidade movto-estoq.dt-trans movto-estoq.it-codigo) USE-INDEX data-esp no-lock 
           WHERE movto-estoq.dt-trans = da-data
             AND (movto-estoq.esp-docto = 28
             OR   movto-estoq.esp-docto = 31
             OR   movto-estoq.esp-docto = 31)
             AND movto-estoq.cod-estabel >= tt-param.cod-estabel-ini
           AND   movto-estoq.cod-estabel <= tt-param.cod-estabel-fim
           AND   movto-estoq.it-codigo BEGINS "1":
                                                  
           IF movto-estoq.it-codigo <= c-it-codigo-ini OR
              movto-estoq.it-codigo >= c-it-codigo-fim THEN NEXT.
   
           RUN pi-acompanhar IN h-acomp (INPUT "Data-Item.: " + string(movto-estoq.dt-trans)
                                         + " - " + movto-estoq.it-codigo).


           FIND FIRST ITEM
                WHERE ITEM.it-codigo = movto-estoq.it-codigo NO-LOCK NO-ERROR.

           FIND grup-estoque
           WHERE grup-estoque.ge-codigo = ITEM.ge-codigo NO-LOCK NO-ERROR. 


           find first tt-mp WHERE 
                tt-mp.cd-grupo  = ITEM.ge-codigo AND
                tt-mp.fm-codigo = item.fm-codigo no-error.
           if not avail tt-mp then do:
              create tt-mp.
              ASSIGN tt-mp.cd-grupo  = ITEM.ge-codigo
                     tt-mp.ds-grupo  = grup-estoq.descricao.
              assign tt-mp.fm-codigo = item.fm-codigo.
           end.
           if movto-estoq.esp-docto = 28 /*"req"*/ then
              assign tt-mp.qtde = tt-mp.qtde + 
                                  movto-estoq.quantidade.
           if movto-estoq.esp-docto = 31 /*"rrq"*/ or
              movto-estoq.esp-docto = 5 /*"dev"*/ then
              assign tt-mp.qtde = tt-mp.qtde -
                                  movto-estoq.quantidade.

       END.
    
       for each it-nota-fisc
            where it-nota-fisc.it-codigo    = item.it-codigo
              and it-nota-fisc.cod-estabel >= tt-param.cod-estabel-ini
              AND it-nota-fisc.cod-estabel <= tt-param.cod-estabel-fim
              and it-nota-fisc.dt-emis-nota = da-data NO-LOCK,
              first natur-oper no-lock
              where natur-oper.nat-operacao = it-nota-fisc.nat-operacao 
                and natur-oper.tipo = 2:
             RUN pi-acompanhar IN h-acomp (INPUT "Lendo Nota.: " + string(it-nota-fisc.dt-emis-nota)
                                         + " - " + ITEM.it-codigo).
              
               find first tt-mp where
                    tt-mp.fm-codigo = item.fm-codigo AND
                    tt-mp.cd-grupo  = ITEM.ge-codigo
                   no-error.
               if not avail tt-mp then do:
                  create tt-mp.
                  assign tt-mp.fm-codigo = item.fm-codigo
                         tt-mp.cd-grupo  = ITEM.ge-codigo
                         tt-mp.ds-grupo  = grup-estoq.descricao.
               end.
               assign tt-mp.qt-faturada  = tt-mp.qt-faturada + it-nota-fisc.qt-faturada[2].
       END.
     END.
END PROCEDURE.


PROCEDURE pi-imprime:
   
    find first tt-aca no-lock no-error.
    if avail tt-aca then
       put "QUANTIDADE PRODUZIDA" skip(1).
    
    for each tt-aca:

        RUN pi-acompanhar IN h-acomp (INPUT "Grp-Sub.:" + 
                                      string(tt-aca.cd-grupo) + "-" +  string(tt-aca.ds-grupo)).
        disp tt-aca.cd-grupo   label "Cod.Grupo"
             tt-aca.ds-grupo   label "Descricao"
             tt-aca.cd-unid-com label "Cod.unid.Com."
             tt-aca.ds-unid-com label "Descricao Unid.Com."

             tt-aca.cd-seg-com label "Cod.Seg.Com."
             tt-aca.ds-seg-com label "Descricao Seg.Com."
             tt-aca.cd-fam-com label "Cod.Fam.Com."
             tt-aca.ds-fam-com label "Descricao fam.Com."

             tt-aca.qtde label "Qtde" format "->>>>>>>>,>>>,>>9.99"
             with width 364 stream-io.
    end.

    find first tt-mp no-lock no-error.
    if avail tt-mp then
       put " " skip(2) 
           "QUANTIDADE CONSUMIDA" skip(1).
   
    for each tt-mp,
        first familia no-lock where
              familia.fm-codigo = tt-mp.fm-codigo:
        disp tt-mp.cd-grupo
             tt-mp.ds-grupo
             familia.fm-codigo label "Familia"
             familia.descricao label "Descricao"               
             tt-mp.qtde label "Qtde" format "->>>>>>>>>>>,>>>,>>9.99"
             tt-mp.qt-faturada label "Faturado" format "->>>>>>>>>>>,>>>,>>9.99"
             with width 132 stream-io.
             
    end.

END PROCEDURE.
