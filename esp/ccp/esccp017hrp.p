/***********************************************************************
**  Programa..: ESP\CCP\esccp017HRP.P
**  Autor.....: Evandro Pezzi
**  Data......: FEVEREIRO/2008 - Desenvolvimento
**  Descricao.: Relat¢rio de Homologa‡äes
**                      (es0634) - Fl vio
**  VersÆo....: 001 11/02/2008
**                  Desenvolvimento Programa
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i esccp017 2.04.00.001}

/****************************  Definitions  ****************************/
{include/i-rpvar.i}

/****************************  Temp-Tables  ****************************/
def new global shared temp-table tt-situacao2      no-undo
    like situacao
    field lg-usa        as log. 
    
DEFINE TEMP-TABLE tt-raw-digita
       FIELD raw-digita AS RAW.


def temp-table tt-param2            no-undo
    field nr-processo-ini           like homologacao.nr-processo
    field nr-processo-fim           like homologacao.nr-processo
    field dt-inicio-ini             as date
    field dt-inicio-fim             as date
    field dt-termino-ini            as date
    field dt-termino-fim            as date
    field it-codigo-ini             like item.it-codigo
    field it-codigo-fim             like item.it-codigo
    field fm-codigo-ini             like item.fm-codigo
    field fm-codigo-fim             like item.fm-codigo
    field cod-emitente-ini          like emitente.cod-emitente
    field cod-emitente-fim          like emitente.cod-emitente.
    
define temp-table tt-param no-undo
    like tt-param2
    field rw-homologacao   as rowid
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)":U
    field modelo           AS char format "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo l¢gico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf    as LOG.
    /*Fim alteracao 15/02/2005*/


def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/*
for each tt-raw-digita:
    create tt-digita.
    raw-transfer 
    tt-raw-digita.raw-digita to tt-digita.
end. 
*/


def var h-acomp      as handle no-undo.

/* ------------------------------------------------ */

form homologacao.nr-processo                        column-label "Proc"
     homologacao.data-inicio                        column-label "Data"
     item.it-codigo                                 column-label "Item"
     item.desc-item             format "x(36)"      column-label "Descri‡Æo"
     item.un                                        column-label "UN"
     fabricante.nome                                column-label "Fabricante"
     tt-situacao2.descricao     format "x(23)"      column-label "Situa‡Æo"
     homologacao.data-ult-sit                       column-label "Dt Situa‡Æo"
     with width 132 no-box down frame f-homolog stream-io.

/* ------------------------------------------------ */
FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Relatorio de Homologa‡äes"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "esccp017"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i}
    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

   run utp/ut-acomp.p persistent set h-acomp.

   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.

   run pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
end.

/* **********************  Internal Procedures  *********************** */
PROCEDURE piImprimeRelat:     
   
   if tt-param.rw-homologacao = ?
   then do:
       FOR EACH homologacao no-lock
          where homologacao.nr-processo    >= tt-param.nr-processo-ini
            and homologacao.nr-processo    <= tt-param.nr-processo-fim
            and homologacao.data-inicio    >= tt-param.dt-inicio-ini
            and homologacao.data-inicio    <= tt-param.dt-inicio-fim
            and ((homologacao.data-termino >= tt-param.dt-termino-ini
            and   homologacao.data-termino <= tt-param.dt-termino-fim)
             or   homologacao.data-termino = ?),
           each item no-lock
          where item.it-codigo  = homologacao.it-codigo
            and item.it-codigo >= tt-param.it-codigo-ini
            and item.it-codigo <= tt-param.it-codigo-fim
            and item.fm-codigo >= tt-param.fm-codigo-ini
            and item.fm-codigo <= tt-param.fm-codigo-fim,
           each fabricante no-lock
          where fabricante.cod-fabric  = homologacao.cod-fabric
            and fabricante.cod-fabric >= tt-param.cod-emitente-ini
            and fabricante.cod-fabric <= tt-param.cod-emitente-fim,
           each tt-situacao2
          where tt-situacao2.cod-situacao = homologacao.situacao
            and tt-situacao2.lg-usa
                NO-LOCK:
         
            RUN pi-acompanhar IN h-acomp (INPUT "Item.: " + item.it-codigo).
             
            disp homologacao.nr-processo
                 homologacao.data-inicio
                 item.it-codigo
                 item.desc-item
                 item.un
                 fabricante.nome
                 tt-situacao2.descricao
                 homologacao.data-ult-sit
                 with frame f-homolog.
            down with frame f-homolog.
             
        end.
    end.
    else do:
        for first homologacao no-lock
            where rowid(homologacao) = tt-param.rw-homologacao,
             each item no-lock
            where item.it-codigo  = homologacao.it-codigo,
             each fabricante no-lock
            where fabricante.cod-fabric  = homologacao.cod-fabric,           
             each tt-situacao2
            where tt-situacao2.cod-situacao = homologacao.situacao
              and tt-situacao2.lg-usa
                NO-LOCK:
                
            RUN pi-acompanhar IN h-acomp (INPUT "Item.: " + item.it-codigo).
             
            disp homologacao.nr-processo
                 homologacao.data-inicio
                 item.it-codigo
                 item.desc-item
                 item.un
                 fabricante.nome
                 tt-situacao2.descricao
                 homologacao.data-ult-sit
                 with frame f-homolog.
            down with frame f-homolog.
             
        end.
    end.  

            
      
END PROCEDURE.
