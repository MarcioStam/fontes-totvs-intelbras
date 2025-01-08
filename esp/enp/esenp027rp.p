
/***********************************************************************
**  Programa..: ESP/REP/ESREP033RP.P
**  Autor.....: Giovane Oliveira
**  Data......: FEVEREIRO/2006 - Desenvolvimento
**  Descricao.: Relatorio de Titulos por Referencia
**  Vers’o....: 001 06/02/2006
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESENP027 1.00.00.00}

/****************************  Definitions  ****************************/
{esp/enp/ESENP027tt.i}

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.

{utp/ut-glob.i}
{include/i-rpvar.i}
/****************************  Temp-Tables  ****************************/




/****************************  Frames       ****************************/

def input parameter raw-param as raw no-undo.
def input parameter  table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.
                            




def var h-acomp      as handle no-undo.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec­ficos Intelbras"
       c-titulo-relat = "Produto X Embalagens"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESENP027"
       c-versao       = "2.04"
       c-revisao      = "005".



DEFINE VAR it-filho LIKE item.it-codigo.
DEFINE VAR it-filho-desc LIKE ITEM.desc-item.
DEFINE BUFFER b-item FOR ITEM.

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i}

    run utp/ut-acomp.p persistent set h-acomp.  

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.
    VIEW FRAME fPageTop.
    

    FORM ITEM.it-codigo  FORMAT "x(7)"
         ITEM.desc-item  FORMAT "X(51)"
         it-filho      COLUMN-LABEL "Embalagem"  FORMAT "x(7)"
         it-filho-desc COLUMN-LABEL "Descricao"  FORMAT "X(42)"
         item-estab.val-unit-mat-m[1] COLUMN-LABEL "Custo" 
     WITH FRAME f-ns STREAM-IO DOWN WIDTH 132. 

                   

    RUN piMontaRelat.


    /*RUN pi-finalizar in h-acomp.*/
    {include/i-rpclo.i}
    RETURN "OK".
end.


PROCEDURE piMontaRelat:

    FOR FIRST tt-param:
        
        FOR EACH ITEM NO-LOCK 

            WHERE ITEM.it-codigo >= tt-param.item-ini
              AND ITEM.it-codigo <= tt-param.item-fim:
             
                
            IF tt-param.ativos = YES THEN
                IF ITEM.cod-obsoleto <> 1 THEN NEXT.
            
            ASSIGN it-filho = ""
                   it-filho-desc = "".
            RUN pi-est(INPUT ITEM.it-codigo).
            
            IF it-filho = "" THEN NEXT.

            FIND FIRST item-estab NO-LOCK
                WHERE item-estab.cod-estabel = ITEM.cod-estabel
                AND item-estab.it-codigo = it-filho NO-ERROR.

            DISP ITEM.it-codigo 
                 ITEM.desc-item
                 it-filho      
                 it-filho-desc
                 item-estab.val-unit-mat-m[1] WHEN AVAIL item-estab
                 WITH FRAME f-ns.
            DOWN WITH FRAME f-ns.
             
        END.
    END.
END.

PROCEDURE pi-est:
    DEF input parameter p-it-codigo like item.it-codigo NO-UNDO.
    
    FOR EACH estrutura NO-LOCK 
        WHERE estrutura.it-codigo = p-it-codigo AND
              estrutura.data-inicio <= TODAY AND
              estrutura.data-termino > today:

       FIND FIRST b-item NO-LOCK 
           WHERE b-item.it-codigo = estrutura.es-codigo NO-ERROR.
       IF AVAIL b-item AND 
           (b-item.fm-codigo = "11501000" OR 
            b-item.fm-codigo = "11501010") THEN DO:
           ASSIGN it-filho = estrutura.es-codigo
                  it-filho-desc = b-item.desc-item.
            

           RETURN "OK".
       END.

       RUN pi-est(input estrutura.es-codigo).
       IF RETURN-VALUE = "OK" THEN RETURN "OK".

    END.
       RETURN "".
END.








