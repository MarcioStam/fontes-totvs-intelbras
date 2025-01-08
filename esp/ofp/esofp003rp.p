/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esofp003RP 2.00.00.006}  /*** 010006 ***/
/*******************************************************************************/
{cdp/cdcfgdis.i}                                
{cdp/cd0620.i1 "' '"}

def temp-table tt-ficha no-undo
    field mes         as integer
    field sequencia   as integer
    field mes-ano     as integer format ">>>9"
    field ano         as integer format "9" init 1
    field fator       as decimal format ">9.9999"
    field valor       as decimal format ">>>,>>>,>>9.99"
    field cod-estabel like mov-ciap.cod-estabel 
    index ch-sequencia sequencia
    index ch-mes       mes.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field estabelec        as char format "x(05)"
    field per-ini          as date format "99/99/9999"
    field per-fim          as date format "99/99/9999".

def temp-table tt-raw-digita
    field raw-digita as raw.

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

DEFINE VARIABLE i-total-apropriada  AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-total-ficha      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i-total-a-apropriar AS INTEGER     NO-UNDO.
DEFINE VARIABLE de-vlr-remanescente AS DECIMAL     NO-UNDO.

create tt-param.
raw-transfer raw-param to tt-param.

{include/i-rpvar.i}

def var h-acomp          as handle no-undo.
def var de-vl-credito    like it-doc-fisc.vl-icms-it no-undo.
def var de-total-saidas  like doc-fiscal.vl-cont-doc no-undo.
def var de-total-trib    like doc-fiscal.vl-icmsnt   no-undo.
def var de-coef-aprop    as integer                  no-undo.
def var de-accum         as decimal format ">,>>>,>>>,>>9.99" extent 10 no-undo.

form header
   "Periodo:"         at 1
   tt-param.per-ini   at 11  "A"     
   tt-param.per-fim   at 34 skip(1)
   "Data Ent.  Serie Nr.Documento  Fornec.   CFOP   Descricao do Bem                               Valor Aquisi‡Æo   Valor Credito  Parc.Apr.  Vlr Apr.  Parc.Rem. Vlr.Reman." at 1
   
   fill("-",169) format "x(170)" at 1 skip(1)
   with no-label no-box page-top frame f-cab width 232.

run utp/ut-trfrrp.p (input frame f-cab:handle).
{include/i-rpout.i}

{include/i-rpcab.i}

assign c-titulo-relat = "Relatorio Auxiliar Movimento CIAP". 

view frame f-cabec.
view frame f-rodape.
view frame f-cab.

run utp/ut-acomp.p persistent set h-acomp.

run pi-inicializar in h-acomp  (input "Gerando Informa‡äes").

for first param-of fields (data-1)
    where param-of.cod-estabel = tt-param.estabelec no-lock: end.

for each mov-ciap no-lock 
    where mov-ciap.cod-estabel  = tt-param.estabelec
    and   mov-ciap.dt-docto    >= tt-param.per-ini 
    and   mov-ciap.dt-docto    <= tt-param.per-fim 
    and   mov-ciap.ocorrencia  < 4
    and   mov-ciap.dt-docto    >= param-of.data-1
    AND   mov-ciap.data-2       = ?
    AND   mov-ciap.vl-icms-it   <> 0
    break by month(mov-ciap.dt-docto):

    run pi-acompanhar in h-acomp  (input "Gerando relat¢rio: Nr. Documento " + string(mov-ciap.nr-doc-fis)).

    for first doc-fiscal fields (cod-estabel ind-sit-doc tipo-nat vl-bicms vl-icmsou vl-icmsnt nat-operacao char-1
                                  &IF DEFINED (bf_dis_formato_CFOP) &THEN cod-cfop &ENDIF) of mov-ciap 

        where doc-fiscal.ind-sit-doc = 1 no-lock:

        if  doc-fiscal.tipo-nat = 2 then 
            run pi-acumula-total-saidas.

        for first it-doc-fisc fields (cd-trib-icm) of mov-ciap 
            where it-doc-fisc.cd-trib-icm = 3 no-lock:
            assign de-vl-credito = mov-ciap.vl-icms-it   +  /* valor do estorno */
                                   mov-ciap.vl-icmsco-it +     
                                   mov-ciap.vl-icms-desp +
                                   mov-ciap.vl-icmsco-desp.
            
            FOR EACH tt-ficha:
                DELETE tt-ficha.
            END.
            run ofp/of0804.p (input  mov-ciap.dt-docto, /* data do documento */
                              input  mov-ciap.data-2,   /* data de sa¡da do documento */
                              input  de-vl-credito,
                              input  mov-ciap.cod-estabel,
                              output table tt-ficha).

            ASSIGN i-total-apropriada  = 0
                   i-total-a-apropriar = 0
                   de-total-ficha      = 0.

            FOR EACH tt-ficha:
                IF tt-ficha.valor > 0 THEN 
                   ASSIGN de-total-ficha = de-total-ficha + tt-ficha.valor
                          i-total-apropriada = i-total-apropriada + 1.
                ELSE
                   ASSIGN  i-total-a-apropriar = i-total-a-apropriar + 1.
/*                    PUT i-total-apropriada i-total-a-apropriar de-total-ficha tt-ficha.valor SKIP. */
            END.
            ASSIGN de-vlr-remanescente = mov-ciap.vl-icms-it / 48 * i-total-a-apropriar.

            {cdp/cd0620.i1 doc-fiscal.cod-estabel}
            put mov-ciap.dt-docto               at 01        
                mov-ciap.serie                  at 12
                mov-ciap.nr-doc-fis     FORMAT "x(8)"        at 18
                mov-ciap.cod-emitente           AT 29
                mov-ciap.nat-operacao           AT 42
                replace(substr(mov-ciap.descricao,1,46),chr(10),"") AT 49
                format "x(46)"               
                mov-ciap.vl-tot-item         
                mov-ciap.vl-icms-it            
                i-total-apropriada
                de-total-ficha               FORMAT ">>>,>>>,>>9"
                i-total-a-apropriar
                de-vlr-remanescente          FORMAT ">>>,>>>,>>9" SKIP.


        end. /* for first it-doc-fisc */
    end. /* for first doc-fiscal */
end. /* for each mov-ciap */



{include/i-rpclo.i}

run pi-finalizar in h-acomp.

return "OK":U.


/* FIM esofp003RP.P */

