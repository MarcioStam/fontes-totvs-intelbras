/* include de controle de vers∆o */
{include/i-prgvrs.i escep039rp 1.00.00.000}

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field estini           as char
    field estfim           as char
    field operini          as char
    field operfim          as char
    field dtini            as date
    field dtfim            as date
    field cod-estabel      as char format "x(3)"
    field modelo           AS char format "x(35)":U
    field l-habilitaRtf    as LOG
    FIELD cod-estabel-ini  AS CHAR
    FIELD cod-estabel-fim  AS CHAR.
    

DEFINE TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita	   AS RAW.
    
def temp-table tt-nf
    field estado                 like nota-fiscal.estado
    field serie                  like nota-fiscal.serie
    field nr-nota-fis            like nota-fiscal.nr-nota-fis
    field dt-emis-nota           like nota-fiscal.dt-emis-nota
    field vl-tot-nota            like nota-fiscal.vl-tot-nota
    field cod-emitente           like nota-fiscal.cod-emitente
    field nome-abrev             like nota-fiscal.nome-ab-cli
    field it-codigo              like it-nota-fisc.it-codigo
    field aliquota-icm           like it-nota-fisc.aliquota-icm
    field vl-icms-it             like it-nota-fisc.vl-icms-it
    field aliquota-ipi           like it-nota-fisc.aliquota-ipi
    field vl-ipi-it              like it-nota-fisc.vl-ipi-it
    field class-fiscal           like it-nota-fisc.class-fiscal
    field nat-operacao           like nota-fiscal.nat-operacao
    field nome-transp            like nota-fiscal.nome-transp
    index tt-nf is primary estado.

/* recebimento de parÉmetros */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/* include padr∆o para vari†veis de relat¢rio  */
{include/i-rpvar.i}

/* definiá∆o de vari†veis  */
DEFINE VARIABLE h-acomp   AS HANDLE     NO-UNDO.

def var dt-data    as date.

form 
   tt-nf.estado
   tt-nf.serie
   tt-nf.nr-nota-fis
   tt-nf.dt-emis-nota
   tt-nf.vl-tot-nota
   tt-nf.cod-emitente
   tt-nf.nome-abrev
   tt-nf.it-codigo
   tt-nf.aliquota-icm
   tt-nf.vl-icms-it
   tt-nf.aliquota-ipi
   tt-nf.vl-ipi-it
   tt-nf.class-fiscal
   tt-nf.nat-operacao
   tt-nf.nome-transp
   with frame frel width 250 DOWN STREAM-IO.



/* include padr∆o para output de relat¢rios */
{include/i-rpout.i &STREAM="stream str-rp"}

/* include com a definiá∆o da frame de cabeáalho e rodapÇ */
{include/i-rpcab.i &STREAM="str-rp"}


/* bloco principal do programa */
ASSIGN  c-programa 	    = "escep039"
	    c-versao	    = "1.00"
	    c-revisao	    = ".00.000"
	    c-sistema	    = "Especificos"
	    c-titulo-relat  = "Relatorio de Faturamento por Estado".

if tt-param.cod-estabel = '102' then
    assign c-empresa    = "NOVA".
if tt-param.cod-estabel = '101' then
    assign c-empresa = "INTELBRAS".

/* para n∆o visualizar cabeáalho/rodapÇ em sa°da RTF */
IF tt-param.destino <> 4 THEN DO:
    VIEW STREAM str-rp FRAME f-cabec.
    VIEW STREAM str-rp FRAME f-rodape.
END.

/* executando de forma persistente o utilit†rio de acompanhamento */
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Imprimindo *}
RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).

/* corpo do relat¢rio */

for each tt-nf.
    delete tt-nf.
end.

do dt-data = tt-param.dtini to tt-param.dtfim:
    for each nota-fiscal no-lock use-index ch-distancia
        where nota-fiscal.cod-estabel >= tt-param.cod-estabel-ini
          AND nota-fiscal.cod-estabel <= tt-param.cod-estabel-fim
          and nota-fiscal.dt-cancela = ? 
          and nota-fiscal.dt-emis-nota = dt-data
          and nota-fiscal.nat-operacao >= tt-param.operini
          and nota-fiscal.nat-operacao <= tt-param.operfim
          and nota-fiscal.nat-operacao >= "500000"
          and nota-fiscal.nat-operacao <> "694930"
          and nota-fiscal.nat-operacao <> "69999m" 
          and nota-fiscal.nat-operacao <> "59999m" 
          and nota-fiscal.nat-operacao <> "69999v" 
          and nota-fiscal.nat-operacao <> "59999v" 
          and nota-fiscal.nat-operacao <> "611034" 
          and nota-fiscal.nat-operacao <> "511034" 
          and nota-fiscal.nat-operacao <> "611038" 
          and nota-fiscal.nat-operacao <> "511038" 
          and nota-fiscal.nat-operacao <> "611039" 
          and nota-fiscal.nat-operacao <> "511039" 
          and nota-fiscal.cidade-cif <> "" 
          and nota-fiscal.estado       >= tt-param.estini
          and nota-fiscal.estado       <= tt-param.estfim
          and nota-fiscal.nome-transp <> "malote"
          and nota-fiscal.nome-transp <> "sedex"
          and nota-fiscal.nome-transp <> "retira",
        each it-nota-fisc no-lock of nota-fiscal:
             
        create tt-nf.
        assign tt-nf.estado       =  nota-fiscal.estado
               tt-nf.serie        =  nota-fiscal.serie
               tt-nf.nr-nota-fis  =  nota-fiscal.nr-nota-fis
               tt-nf.dt-emis-nota =  nota-fiscal.dt-emis-nota
               tt-nf.vl-tot-nota  =  it-nota-fisc.vl-tot-item
               tt-nf.cod-emitente =  nota-fiscal.cod-emitente
               tt-nf.nome-abrev   =  nota-fiscal.nome-ab-cli
               tt-nf.it-codigo    =  it-nota-fisc.it-codigo
               tt-nf.aliquota-icm =  it-nota-fisc.aliquota-icm
               tt-nf.vl-icms-it   =  it-nota-fisc.vl-icms-it
               tt-nf.aliquota-ipi =  it-nota-fisc.aliquota-ipi
               tt-nf.vl-ipi-it    =  it-nota-fisc.vl-ipi-it
               tt-nf.class-fiscal =  it-nota-fisc.class-fiscal
               tt-nf.nat-operacao =  it-nota-fisc.nat-operacao
               tt-nf.nome-transp  =  nota-fiscal.nome-transp.
    end.
end.

/* do dt-data = tt-param.dtini to tt-param.dtfim:                */
/*     for each nota-fiscal no-lock use-index ch-distancia       */
/*         where nota-fiscal.cod-estabel = tt-param.cod-estabel  */
/*             and nota-fiscal.cod-emitente = 18963              */
/*             and nota-fiscal.dt-cancela = ?                    */
/*             and nota-fiscal.dt-emis-nota = dt-data            */
/*             and nota-fiscal.nat-operacao = "590100",          */
/*         each it-nota-fisc no-lock of nota-fiscal:              */
/*                                                               */
/*         create tt-nf.                                         */
/*         assign tt-nf.estado       =  nota-fiscal.estado       */
/*                tt-nf.serie        =  nota-fiscal.serie        */
/*                tt-nf.nr-nota-fis  =  nota-fiscal.nr-nota-fis  */
/*                tt-nf.dt-emis-nota =  nota-fiscal.dt-emis-nota */
/*                tt-nf.vl-tot-nota  =  it-nota-fisc.vl-tot-item  */
/*                tt-nf.cod-emitente =  nota-fiscal.cod-emitente */
/*                tt-nf.nome-abrev   =  nota-fiscal.nome-ab-cli  */
/*                tt-nf.it-codigo    =  it-nota-fisc.it-codigo    */
/*                tt-nf.aliquota-icm =  it-nota-fisc.aliquota-icm */
/*                tt-nf.vl-icms-it   =  it-nota-fisc.vl-icms-it   */
/*                tt-nf.aliquota-ipi =  it-nota-fisc.aliquota-ipi */
/*                tt-nf.vl-ipi-it    =  it-nota-fisc.vl-ipi-it    */
/*                tt-nf.class-fiscal =  it-nota-fisc.class-fiscal */
/*                tt-nf.nat-operacao =  it-nota-fisc.nat-operacao */
/*                tt-nf.nome-transp  =  nota-fiscal.nome-transp. */
/*    end.                                                       */
/* end.                                                          */
for each tt-nf break by tt-nf.estado:
    DISPLAY STREAM str-rp tt-nf WITH FRAME frel.
    DOWN STREAM str-rp WITH FRAME frel.
end.
      
  

/*fechamento do output do relat¢rio*/
{include/i-rpclo.i &STREAM="stream str-rp"}
RUN pi-finalizar IN h-acomp.
RETURN "OK":U.
