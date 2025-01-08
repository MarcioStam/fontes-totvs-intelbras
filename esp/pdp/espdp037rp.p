/*----------------------------------------------------------------------
**  Programa..: esp/pdp/espdp037rp.p
**  Autor.....: Felipe Braun Azambuja
**  Data......: Janeiro/2008 - Desenvolvimento
**  Descricao.: Relat¢rio de pedidos em carteira
-----------------------------------------------------------------------*/

/*---------------------------  Variaveis    ---------------------------*/
/************************************************************************
**
**  i-prgvrs.i - Programa para criacao do log de todos os programas 
**               e objetos do EMS 2.0 para objetos
**  {1} = objeto   provido pelo Roundtable
**  {2} = versao   provido pelo Roundtable
************************************************************************/

/*Altera‡Æo - 08/09/2006 - tech1007 - Alterado para possuir a defini‡Æo dos pr‚processadores logo no in¡cio do programa*/
/**** Altera‡Æo efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
{include/i_dbvers.i}
/*Fim altera‡Æo 08/09/2006*/

def new global shared var c-arquivo-log    as char  format "x(60)" no-undo.
def var c-prg-vrs as char init "[[[{2}[[[" no-undo.
def var c-prg-obj as char no-undo.
assign c-prg-vrs = "{2}"
       c-prg-obj = "{1}".

/* Alteracao - 02/10/2006 - Nakamura - Incluida chamada a include que verifica a integridade dos programas do registro de produto */


/*Altera‡Æo - 08/09/2006 - tech1007 - Altera‡Æo para exibir o nome do programa que executou o programa que ser  exibido no extrato de versÆo
                                      Solicita‡Æo realizada na FO 1239827*/
&IF "{&mguni_version}" >= "2.07" AND INTEGER(ENTRY(1,PROVERSION,".")) > 9 &THEN
def var c-prg-obj-pai as char no-undo.

IF VALID-HANDLE(THIS-PROCEDURE:INSTANTIATING-PROCEDURE) THEN DO:
    ASSIGN c-prg-obj-pai = THIS-PROCEDURE:INSTANTIATING-PROCEDURE:FILE-NAME.
END.
ELSE DO:
    ASSIGN c-prg-obj-pai = "".
END.

IF NUM-ENTRIES(c-prg-obj-pai, "~/") > 1 THEN DO:
    ASSIGN c-prg-obj-pai = ENTRY(NUM-ENTRIES(c-prg-obj-pai, "~/"),c-prg-obj-pai, "~/").
END.
IF NUM-ENTRIES(c-prg-obj-pai, ".") > 1 THEN DO:
    ASSIGN c-prg-obj-pai = ENTRY(1,c-prg-obj-pai, ".").
END.
&ENDIF
/*Fim altera‡Æo 08/09/2006*/


if  c-arquivo-log <> "" and c-arquivo-log <> ? then do:
    find prog_dtsul
        where prog_dtsul.cod_prog_dtsul = "{1}"
        no-lock no-error.
        
   if not avail prog_dtsul then do:
          if  c-prg-obj begins "btb":U then
              assign c-prg-obj = "btb~/":U + c-prg-obj.
          else if c-prg-obj begins "men":U then
                  assign c-prg-obj = "men~/":U + c-prg-obj.
          else if c-prg-obj begins "sec":U then
                  assign c-prg-obj = "sec~/":U + c-prg-obj.
          else if c-prg-obj begins "utb":U then
                  assign c-prg-obj = "utb~/":U + c-prg-obj.
          find prog_dtsul where
               prog_dtsul.nom_prog_ext begins c-prg-obj no-lock no-error.
   end .            /*if*/
    
    output to value(c-arquivo-log) append.

    /*Altera‡Æo - 08/09/2006 - tech1007 - Altera‡Æo para exibir o nome do programa que executou o programa que ser  exibido no extrato de versÆo
                                      Solicita‡Æo realizada na FO 1239827*/
    &IF "{&mguni_version}" >= "2.07" AND INTEGER(ENTRY(1,PROVERSION,".")) > 9 &THEN
        PUT "{1}" AT 1 "{2}" AT 39 c-prg-obj-pai AT 54 STRING(TODAY,'99/99/99') AT 84 STRING(TIME,'HH:MM:SS':U) AT 94 SKIP.
    &ELSE
        /*FO 1329.898 - tech1139 - 01/08/2006 */
        PUT "{1}" AT 1 "{2}" AT 69 STRING(TODAY,'99/99/99') AT 84 STRING(TIME,'HH:MM:SS':U) AT 94 SKIP.
        /*FO 1329.898 - tech1139 - 01/08/2006 */
    &ENDIF
    /*Fim altera‡Æo 08/09/2006*/
                                                  
    if  avail prog_dtsul then do:
        if  prog_dtsul.nom_prog_dpc <> "" then
            put "DPC : ":U at 5 prog_dtsul.nom_prog_dpc  at 12 skip.
        if  prog_dtsul.nom_prog_appc <> "" then
            put "APPC: ":U at 5 prog_dtsul.nom_prog_appc at 12 skip.
        if  prog_dtsul.nom_prog_upc <> "" then
            put "UPC : ":U at 5 prog_dtsul.nom_prog_upc  at 12 skip.
    end.
    output close.        
end.  
error-status:error = no.
{include/i_dbtype.i}

/*alteracao Anderson(tech540) em 04/02/2003 Include com a definicao 
da temp table utilizada nas includes btb008za.i1 e btb008za.i2 para 
execucao de programas via rpc*/
{btb/btb923za.i}
/*fim alteracao Anderson 04/02/2003*/

/* altera‡Æo feita para atender ao WebEnabler - Marcilene Oliveira - 18/12/2003 */

{include/i-wendef.i}

/* fim da alatera‡Æo */

/* Altera‡Æo realizada por tech38629 - 19/07/2006 - Defini‡Æo do pre-processador para o facelift */
{include/i_fclpreproc.i}
/* Fim da altera‡Æo */


/*****************************************************************************
**
**  I-RPVAR.I - Variaveis para Impress’o do Cabecalho Padr’o (ex-CD9500.I)
**
*****************************************************************************/

{include/i_dbvers.i}

def var c-empresa        as character format "x(40)"      no-undo.
def var c-titulo-relat   as character format "x(50)"      no-undo.
def var c-sistema        as character format "x(25)"      no-undo.
def var i-numper-x       as integer   format "ZZ"         no-undo.
def var da-iniper-x      as date      format "99/99/9999" no-undo.
def var da-fimper-x      as date      format "99/99/9999" no-undo.
def var c-rodape         as character                     no-undo.
def var v_num_count      as integer                       no-undo.
def var c-arq-control    as character                     no-undo.
def var i-page-size-rel  as integer                       no-undo.
def var c-programa       as character format "x(08)"      no-undo.
def var c-versao         as character format "x(04)"      no-undo.
def var c-revisao        as character format "999"        no-undo.
def var c-impressora     as character                     no-undo.
def var c-layout         as character                     no-undo.
DEF VAR i-cod-emitente   like emitente.cod-emitente       NO-UNDO.
DEF VAR c-nome-emit      like emitente.nome-emit          NO-UNDO.
DEF VAR c-cgc            like emitente.cgc                NO-UNDO.
DEF VAR i-cod-rep        like repres.cod-rep              NO-UNDO.
DEF VAR c-nome           like repres.nome                 NO-UNDO.
DEF VAR da-dt-emis-nota  LIKE nota-fiscal.dt-emis-nota    NO-UNDO.
DEF VAR de-vl-tot-nota   LIKE nota-fiscal.vl-tot-nota     NO-UNDO.
DEF VAR de-lim-credito   LIKE emitente.lim-credito        NO-UNDO.
DEF VAR de-lim-adicional LIKE emitente.lim-adicional      NO-UNDO.
DEF VAR c-ind-cre-cli    AS CHAR                          NO-UNDO.

DEF BUFFER b-emitente FOR emitente.
/*Defini‡äes inclu¡das para corrigir problema de vari veis j  definidas pois */
/*as vari veis e temp-tables eram definidas na include --rpout.i que pode ser*/
/*executada mais de uma vez dentro do mesmo programa (FO 1.120.458) */
/*11/02/2005 - Ed‚sio <tech14207>*/
/*-------------------------------------------------------------------------------------------*/
DEF VAR h-procextimpr                               AS HANDLE   NO-UNDO. 
DEF VAR i-num_lin_pag                               AS INT      NO-UNDO.    
DEF VAR c_process-impress                           AS CHAR     NO-UNDO.   
DEF VAR c-cod_pag_carac_conver                      AS CHAR     NO-UNDO.   

/*tech14207
FO 1663218
Inclu¡das as defini‡äes das vari veis e fun‡äes
*/
&IF "{&mguni_version}" >= "2.04" &THEN
    &IF "{&PDF-RP}" <> "YES" &THEN /*tech868*/
             
    DEFINE VARIABLE h_pdf_controller     AS HANDLE NO-UNDO.
    DEFINE VARIABLE v_cod_temp_file_pdf  AS CHAR   NO-UNDO.
    
    DEFINE VARIABLE v_cod_relat          AS CHAR   NO-UNDO.
    DEFINE VARIABLE v_cod_file_config    AS CHAR   NO-UNDO.

    FUNCTION allowPrint RETURNS LOGICAL IN h_pdf_controller.
    
    FUNCTION allowSelect RETURNS LOGICAL IN h_pdf_controller.
    
    FUNCTION useStyle RETURNS LOGICAL IN h_pdf_controller.
    
    FUNCTION usePDF RETURNS LOGICAL IN h_pdf_controller.
    
    FUNCTION getPrintFileName RETURNS CHARACTER IN h_pdf_controller.
    
    RUN btb/btb920aa.p PERSISTENT SET h_pdf_controller.

    &ENDIF /*tech868*/
&endif
/*tech14207*/
/*tech30713 - fo:1262674 - Defini‡Æo de no-undo na temp-table*/
DEFINE TEMP-TABLE tt-configur_layout_impres_inicio NO-UNDO
    FIELD num_ord_funcao_imprsor    LIKE configur_layout_impres.num_ord_funcao_imprsor
    FIELD cod_funcao_imprsor        LIKE configur_layout_impres.cod_funcao_imprsor
    FIELD cod_opc_funcao_imprsor    LIKE configur_layout_impres.cod_opc_funcao_imprsor
    FIELD num_carac_configur        LIKE configur_tip_imprsor.num_carac_configur
    INDEX ordem num_ord_funcao_imprsor .

/*tech30713 - fo:1262674 - Defini‡Æo de no-undo na temp-table*/
DEFINE TEMP-TABLE tt-configur_layout_impres_fim NO-UNDO
    FIELD num_ord_funcao_imprsor    LIKE configur_layout_impres.num_ord_funcao_imprsor
    FIELD cod_funcao_imprsor        LIKE configur_layout_impres.cod_funcao_imprsor
    FIELD cod_opc_funcao_imprsor    LIKE configur_layout_impres.cod_opc_funcao_imprsor
    FIELD num_carac_configur        LIKE configur_tip_imprsor.num_carac_configur
    INDEX ordem num_ord_funcao_imprsor .
/*-------------------------------------------------------------------------------------------*/

define buffer b_ped_exec_style for ped_exec.
define buffer b_servid_exec_style for servid_exec.
&IF "{&SHARED}" = "YES":U &THEN
    define shared stream str-rp.
&ELSE
    define new shared stream str-rp.
&ENDIF
{include/i-lgcode.i}
/* i-rpvar.i */
/*Altera‡Æo 20/07/2007 - tech1007 - Defini‡Æo da vari vel utilizada para impressÆo em PDF*/
DEFINE VARIABLE v_output_file        AS CHAR   NO-UNDO.

/***************************************************************************
**  Programa : UT-GLOB.I
**  Include padrão para definição de variaveis globais.
***************************************************************************/ 
/* altera»’o feita para atender ao WebEnabler - Marcilene Oliveira - 18/12/2003 */

&IF DEFINED(WEN-CONTROLLER) &THEN /* est  verifica‡Æo se faz necess ria devido aos programas */
   {include/i-wenreg.i}           /* criados pelos DataViewer nÆo utilizarem a include i-prgvrs */ 
&ENDIF                            /* e dessa forma nÆo chamarem a include i-wendef.i que define essa veri vel. */ 

/* fim da alatera‡Æo */

/* Alterado por tech38629 - Facelift */
&IF defined(aplica_facelift) = 0 &THEN
    {include/i_fclpreproc.i}
&ENDIF
/* Fim da altera‡Æo */
&if  defined(GLOBALS) &then 

&else
     &glob GLOBALS ok 

     def new global shared var i-ep-codigo-usuario  like mgcad.empresa.ep-codigo no-undo.
     def new Global shared var l-implanta           as logical    init no.
     def new Global shared var c-seg-usuario        as char format "x(12)" no-undo.
     def new global shared var i-num-ped-exec-rpw   as integer no-undo.   
     def var rw-log-exec                            as rowid no-undo.
     def new global shared var i-pais-impto-usuario as integer format ">>9" no-undo.
     def new global shared var l-rpc as logical no-undo.
     def var c-erro-rpc as character format "x(60)" initial " " no-undo.
     def var c-erro-aux as character format "x(60)" initial " " no-undo.
     def var c-ret-temp as char no-undo.
     def var h-servid-rpc as handle no-undo.     
     def new global shared var r-registro-atual as rowid no-undo.
     def new global shared var c-arquivo-log    as char  format "x(60)"no-undo.
     def new global shared var h-rsocial as handle no-undo.
     def new global shared var l-achou-prog as logical no-undo.

      /* Variáveis Padrão DWB / Datasul HR */
     def new global shared var i-num-ped as integer no-undo.         
     def new global shared var v_cdn_empres_usuar   like mgcad.empresa.ep-codigo        no-undo.
     def new global shared var v_cod_usuar_corren   like usuar_mestre.cod_usuario no-undo.
     def new global shared var h_prog_segur_estab     as handle                   no-undo.
     def new global shared var v_cod_grp_usuar_lst    as char                     no-undo.
     def new global shared var v_num_tip_aces_usuar   as int                      no-undo.

     /*Alteracao 02/11/2006 - tech1007 - FO 1407866 - Criacao de nova vari vel global*/
/*      def new global shared var v_cdn_empresa_evento like mgcad.empresa.ep-codigo.  */

&endif

/* Transformacao Window */
&IF DEFINED(TransformacaoWindow) <> 0 &THEN
&ELSE
    if session:window-system <> "TTY" then do:
      &global-define TransformacaoWindow OK
      {include/i-win.i}
      define var h-prog     as handle  no-undo.
      define var h-pai      as handle  no-undo.
      define var c-prog-tec as char    no-undo format "x(256)".
      define var i-template as integer no-undo.
    end.  
&ENDIF
/* Transformacao Window */
/* Retorno RPC */
&IF DEFINED(Retorno_RPC) <> 0 &THEN
&ELSE
  &global-define Retorno_RPC OK
  procedure pi-seta-return-value:
    def input param ret as char no-undo.
    return ret.
  end procedure.
&ENDIF

/* Retorno RPC */

/* ut-glob.i */


DEF TEMP-TABLE tt-limite
    FIELD lim-credito AS DECIMAL FORMAT ">>,>>>,>>9.99"
    FIELD quantidade  AS DECIMAL FORMAT ">>,>>9".
FIND FIRST param-global NO-LOCK.
FIND FIRST mgcad.empresa      NO-LOCK WHERE empresa.ep-codigo = param-global.empresa-pri.

ASSIGN c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Limite de Cr‚dito"
       c-empresa      = IF AVAILABLE empresa THEN empresa.razao-social ELSE ''
       c-programa     = "ESPDP037"
       c-versao       = "2.04"
       c-revisao      = "002".

{esp/pdp/espdp037tt.i}

DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.

/*---------------------------  Parƒmetros   ---------------------------*/

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.
DEFINE VARIABLE de-titulo-aberto  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-pedidos-aberto AS DECIMAL     NO-UNDO.
CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/* ***************************  Main Block  *************************** */
DO ON STOP UNDO, LEAVE:
   /****************************************************************************
**
**  I-RPCAB.I - Form do Cabe‡alho PadrÆo e Rodap‚ (ex-CD9500.F)
**                              
** {&STREAM} - indica o nome da stream (opcional)
****************************************************************************/

&IF "{&LANGUAGE-CODE}":U = "ING":U &THEN 
    &IF  "{&STREAM}" = "" &THEN
        form header
            fill("-", 222) format "x(222)" skip
            c-empresa c-titulo-relat at 50
            "Page:":U at 123 page-number  at 128 format ">>>>9" skip
            fill("-", 112) format "x(110)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 222 no-labels no-box page-top frame f-cabec.
        
        form header
            fill("-", 222) format "x(222)" skip
            c-empresa c-titulo-relat at 50
            "Page:":U at 123 page-number  at 128 format ">>>>9" skip
            "Period:":U i-numper-x at 09 "-"
            da-iniper-x at 14 "to" da-fimper-x
            fill("-", 74) format "x(72)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 222 no-labels no-box page-top frame f-cabper.
    &ELSE
        form header
            fill("-", 222) format "x(222)" skip
            c-empresa c-titulo-relat at 50
            "Page:":U at 123 page-number({&STREAM})  at 128 format ">>>>9" skip
            fill("-", 112) format "x(110)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 222 no-labels no-box page-top frame f-cabec.
        
        form header
            fill("-", 222) format "x(222)" skip
            c-empresa c-titulo-relat at 50
            "Page:":U at 123 page-number({&STREAM})  at 128 format ">>>>9" skip
            "Period:":U i-numper-x at 10 "-"
            da-iniper-x at 14 "to":U da-fimper-x
            fill("-", 74) format "x(72)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 222 no-labels no-box page-top frame f-cabper.
    &ENDIF
&ELSEIF "{&LANGUAGE-CODE}" = "ESP":U &THEN
    &IF  "{&STREAM}" = "" &THEN
        form header
            fill("-", 222) format "x(222)" skip
            c-empresa c-titulo-relat at 50
            "P gina:":U at 121 page-number  at 128 format ">>>>9" skip
            fill("-", 112) format "x(110)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 222 no-labels no-box page-top frame f-cabec.
        
        form header
            fill("-", 222) format "x(222)" skip
            c-empresa c-titulo-relat at 50
            "P gina:":U at 121 page-number  at 128 format ">>>>9" skip
            "Periodo:":U i-numper-x at 10 "-"
            da-iniper-x at 15 "hasta" da-fimper-x
            fill("-", 70) format "x(68)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 222 no-labels no-box page-top frame f-cabper.
    &ELSE
        form header
            fill("-", 222) format "x(222)" skip
            c-empresa c-titulo-relat at 50
            "P gina:":U at 121 page-number({&STREAM})  at 128 format ">>>>9" skip
            fill("-", 112) format "x(110)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 222 no-labels no-box page-top frame f-cabec.
        
        form header
            fill("-", 222) format "x(222)" skip
            c-empresa c-titulo-relat at 50
            "P gina:":U at 121 page-number({&STREAM})  at 128 format ">>>>9" skip
            "Periodo:":U i-numper-x at 10 "-"
            da-iniper-x at 15 "hasta":U da-fimper-x
            fill("-", 70) format "x(68)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 222 no-labels no-box page-top frame f-cabper.
    &ENDIF
&ELSE
    &IF "{&STREAM}" = "" &THEN
        form header
            fill("-", 222) format "x(222)" skip
            c-empresa c-titulo-relat at 50
            "P gina:":U at 120 page-number  at 128 format ">>>>9" skip
            fill("-", 112) format "x(110)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 222 no-labels no-box page-top frame f-cabec.
        
        form header
            fill("-", 222) format "x(222)" skip
            c-empresa c-titulo-relat at 50
            "P gina:":U at 120 page-number  at 128 format ">>>>9" skip
            "Periodo:":U i-numper-x at 10 "-"
            da-iniper-x at 15 "a":U da-fimper-x
            fill("-", 74) format "x(72)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 222 no-labels no-box page-top frame f-cabper.
    &ELSE
        form header
            fill("-", 222) format "x(222)" skip
            c-empresa c-titulo-relat at 50
            "P gina:":U at 120 page-number({&STREAM})  at 128 format ">>>>9" skip
            fill("-", 112) format "x(110)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 222 no-labels no-box page-top frame f-cabec.
        
        form header
            fill("-", 222) format "x(222)" skip
            c-empresa c-titulo-relat at 50
            "P gina:":U at 120 page-number({&STREAM})  at 128 format ">>>>9" skip
            "Periodo:":U i-numper-x at 10 "-"
            da-iniper-x at 15 "a":U da-fimper-x
            fill("-", 74) format "x(72)" today format "99/99/9999"
            "-" string(time, "HH:MM:SS":U) skip(1)
            with stream-io width 222 no-labels no-box page-top frame f-cabper.
    &ENDIF
&ENDIF

c-rodape = "DATASUL - ":U + c-sistema + " - " + c-prg-obj + " - V:":U + c-prg-vrs.
c-rodape = fill("-", 222 - length(c-rodape)) + c-rodape.

form header
    c-rodape format "x(222)"
    with stream-io width 222 no-labels no-box page-bottom frame f-rodape.

/* I-RPCAB.I */

   /**************************************************************************
**
** I-RPOUT - Define saída para impressão do relatório - ex. cd9520.i
** Parametros: {&stream} = nome do stream de saida no formato "stream nome"
**             {&append} = append    
**             {&tofile} = nome da variável ou campo com arquivo de destino
**             {&pagesize} = tamanho da pagina
***************************************************************************/

/*As defini‡äes foram transferidas para a include i-rpvar.i (FO 1.120.458) */
/*11/02/2005 - Ed‚sio <tech14207>*/

 def new global shared var c-dir-spool-servid-exec as char no-undo.                     
 def new global shared var i-num-ped-exec-rpw as int no-undo.                           
                                                                                   
/*variaveis processador externo impressÆo localiza‡Æo*/


 /* procedimento necess rio para permitir redirecionar saida para arquivo temporario no pdf sem aparecer na pagina de parametros */
&if "{&tofile}" = "" &then
    ASSIGN v_output_file = tt-param.arquivo.
&elseif "{&tofile}" <> "" &then
    ASSIGN v_output_file = {&tofile}.
&endif




/*tech14178 inicio defini‡äes PDF */
&IF "{&mguni_version}" >= "2.04" &THEN
    
    &GLOBAL-DEFINE PDF-RP YES /*tech868*/
    
    &if "{&tofile}" = "" &then  /*tech868*/
        IF NUM-ENTRIES(tt-param.arquivo,"|":U) > 1  THEN DO:
            ASSIGN v_cod_relat = ENTRY(2,tt-param.arquivo,"|":U).
            ASSIGN v_cod_file_config = ENTRY(3,tt-param.arquivo,"|":U).
            ASSIGN tt-param.arquivo = ENTRY(1,tt-param.arquivo,"|":U).
    
            RUN pi_prepare_permissions IN h_pdf_controller(INPUT v_cod_relat).
            RUN pi_set_format IN h_pdf_controller(INPUT IF v_cod_relat <> "":U THEN "PDF":U ELSE "Texto":U).
            RUN pi_set_file_config IN h_pdf_controller(INPUT  v_cod_file_config).
            
        END.
        
        IF usePDF() AND tt-param.destino = 2 THEN DO:
            IF entry(num-entries(tt-param.arquivo,".":U),tt-param.arquivo,".":U) <> "pdf" THEN
                assign tt-param.arquivo = replace(tt-param.arquivo,".":U + entry(num-entries(tt-param.arquivo,".":U),tt-param.arquivo,".":U),".pdf":U).

        END.

        IF usePDF() AND tt-param.destino <> 1 THEN /*tech14178 muda o nome do arquivo para salvar temporario quando nÆo ‚ impressora*/
            ASSIGN v_output_file = tt-param.arquivo + ".pdt".



        
        
    &elseif "{&tofile}" <> "" &then
        IF NUM-ENTRIES({&tofile},"|":U) > 1  THEN DO:
            ASSIGN v_cod_relat = ENTRY(2,{&tofile},"|":U).
            ASSIGN v_cod_file_config = ENTRY(3,{&tofile},"|":U).
            ASSIGN {&tofile} = ENTRY(1,{&tofile},"|":U).
    
            RUN pi_prepare_permissions IN h_pdf_controller(INPUT v_cod_relat).
            RUN pi_set_format IN h_pdf_controller(INPUT IF v_cod_relat <> "":U THEN "PDF":U ELSE "Texto":U).
            RUN pi_set_file_config IN h_pdf_controller(INPUT  v_cod_file_config).
            
        END.
        
        /*Altera‡Æo 12/07/2007 - tech1007 - FO 1561331 - Foi removida a chamada para o campo arquivo da tt-param e substitu¡do pela vari vel {&tofile}*/
        IF usePDF() AND tt-param.destino = 2 THEN DO:
            IF entry(num-entries({&tofile},".":U),{&tofile},".":U) <> "pdf" THEN
                assign {&tofile} = replace({&tofile},".":U + entry(num-entries({&tofile},".":U),{&tofile},".":U),".pdf":U).

        END.

        
        IF usePDF() AND tt-param.destino <> 1 THEN /*tech14178 muda o nome do arquivo para salvar temporario quando nÆo ‚ impressora*/
            ASSIGN v_output_file = {&tofile} + ".pdt".  
        
        &GLOBAL-DEFINE PDF-FILE {&tofile} /*tech868*/
        
    &endif
    





    IF usePDF() AND tt-param.destino = 1  THEN /*pega arquivo tempor rio randomico para ser usado como impressora */
        ASSIGN v_cod_temp_file_pdf = getPrintFileName().

&endif
/*tech14178 fim defini‡äes PDF */

 
    
/*29/12/2004 - tech1007 - Verfica se o arquivo informado tem extensao rtf, se tiver troca para .lst*/
&IF "{&RTF}":U = "YES":U &THEN
IF entry(num-entries(tt-param.arquivo,".":U),tt-param.arquivo,".":U) = "rtf" AND tt-param.l-habilitaRtf = YES THEN
    assign tt-param.arquivo = replace(tt-param.arquivo,".":U + entry(num-entries(tt-param.arquivo,".":U),tt-param.arquivo,".":U),".lst":U).
&ENDIF

if  tt-param.destino = 1 then do:
   &if "{&tofile}" = "" &then 
    if num-entries(tt-param.arquivo,":") = 2 then do:
   &elseif "{&tofile}" <> "" &then
    if num-entries({&tofile},":") = 2 then do:
   &endif.                            
    &if "{&tofile}" = "" &then 
        assign c-impressora = substring(tt-param.arquivo,1,index(tt-param.arquivo,":") - 1).
        assign c-layout     = substring(tt-param.arquivo,index(tt-param.arquivo,":") + 1,length(tt-param.arquivo) - index(tt-param.arquivo,":")). 
    &elseif "{&tofile}" <> "" &then
        assign c-impressora = substring({&tofile},1,index({&tofile},":") - 1).
        assign c-layout     = substring({&tofile},index({&tofile},":") + 1,length({&tofile}) - index({&tofile},":")). 
    &endif.                            

    find layout_impres no-lock
        where layout_impres.nom_impressora    = c-impressora
        and   layout_impres.cod_layout_impres = c-layout no-error.
    find imprsor_usuar no-lock
        where imprsor_usuar.nom_impressora = c-impressora
        and   imprsor_usuar.cod_usuario    = tt-param.usuario
        use-index imprsrsr_id no-error.
    find impressora  of imprsor_usuar no-lock no-error.
    find tip_imprsor of impressora    no-lock no-error.

    /*Alterado 26/04/2005 - tech1007 - Alterado para nÆo ocasionar problemas na conversÆo do mapa de caracteres*/
    IF AVAILABLE tip_imprsor THEN DO:
        ASSIGN c-cod_pag_carac_conver = tip_imprsor.cod_pag_carac_conver.
    END.
    IF AVAILABLE layout_impres THEN DO:
        ASSIGN i-num_lin_pag = layout_impres.num_lin_pag.
    END.
    /*Fim alteracao - tech1007*/

    &IF "{&mguni_version}" > "2.04" &THEN
        ASSIGN c_process-impress = impressora.cod_livre_1.
        IF c_process-impress <> "" THEN DO:
            IF SEARCH(c_process-impress) <> ? THEN DO:
                /*verifica se o programa j  est  sendo executado, 
                caso o encontre na mem¢ria usa o mesmo handle */
                h-procextimpr = SESSION:LAST-PROCEDURE.
                REPEAT:
                    IF VALID-HANDLE(h-procextimpr) AND 
                       h-procextimpr:TYPE = "PROCEDURE" AND 
                       h-procextimpr:FILE-NAME = c_process-impress 
                       THEN LEAVE.                       
                    h-procextimpr = h-procextimpr:PREV-SIBLING .                    
                    IF NOT VALID-HANDLE(h-procextimpr) THEN LEAVE.                
                END.
                IF NOT VALID-HANDLE(h-procextimpr) THEN
                    RUN VALUE(c_process-impress) PERSISTENT SET h-procextimpr.
            END.            
        END.
    &ENDIF
    if  i-num-ped-exec-rpw <> 0 then do:
        find b_ped_exec_style where b_ped_exec_style.num_ped_exec = i-num-ped-exec-rpw no-lock no-error. 
        find b_servid_exec_style of b_ped_exec_style no-lock no-error.
        find servid_exec_imprsor of b_servid_exec_style
          where servid_exec_imprsor.nom_impressora = imprsor_usuar.nom_impressora no-lock no-error.

        if  available b_servid_exec_style and b_servid_exec_style.ind_tip_fila_exec = 'UNIX'
        then do:
            &IF "{&mguni_version}" >= "2.04" &THEN /*tech14178 joga para arquivo a ser convertido para PDF */
                IF usePDF() THEN DO:
                    output {&stream} through value(v_cod_temp_file_pdf)
                            page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
                    RUN pi_set_print_device IN h_pdf_controller(INPUT servid_exec_imprsor.nom_disposit_so).
                END.
                ELSE
            &ENDIF
            output {&stream} through value(servid_exec_imprsor.nom_disposit_so)
                   page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
        end /* if */.
        else do:

            /*Alterado 26/04/2005 - tech1007 - As variaveis i-num_lin_pag e c-cod_pag_carac_conver estao sendo alteradas antes dos testes */
            ASSIGN 
                c-arq-control = servid_exec_imprsor.nom_disposit_so.
            /*Fim alteracao 26/04/2005*/

            IF VALID-HANDLE(h-procextimpr) AND h-procextimpr:FILE-NAME = c_process-impress THEN
                RUN pi_before_output IN h-procextimpr 
                    (INPUT c-impressora,
                     INPUT c-layout,
                     INPUT tt-param.usuario,
                     INPUT-OUTPUT c-arq-control,
                     INPUT-OUTPUT i-num_lin_pag,
                     INPUT-OUTPUT c-cod_pag_carac_conver).
            
            &IF "{&mguni_version}" >= "2.04" &THEN /*tech14178 joga para arquivo a ser convertido para PDF */
                IF usePDF() THEN DO:
                    output {&stream}  to value(v_cod_temp_file_pdf)
                            page-size value(i-num_lin_pag) convert target c-cod_pag_carac_conver.
                    RUN pi_set_print_device IN h_pdf_controller(INPUT servid_exec_imprsor.nom_disposit_so).
                END.
                ELSE
            &ENDIF
                    output {&stream}  to value(c-arq-control)
                           page-size value(i-num_lin_pag) convert target c-cod_pag_carac_conver.
        end /* else */.
    end.
    else do:

        /*Alterado 26/04/2005 - tech1007 - As variaveis i-num_lin_pag e c-cod_pag_carac_conver estao sendo alteradas antes dos testes */
        ASSIGN 
            c-arq-control = imprsor_usuar.nom_disposit_so.
        /*Fim alteracao 26/04/2005*/

        IF VALID-HANDLE(h-procextimpr) AND h-procextimpr:FILE-NAME = c_process-impress THEN
            RUN pi_before_output IN h-procextimpr 
                (INPUT c-impressora,
                 INPUT c-layout,
                 INPUT tt-param.usuario,
                 INPUT-OUTPUT c-arq-control,
                 INPUT-OUTPUT i-num_lin_pag,
                 INPUT-OUTPUT c-cod_pag_carac_conver).

        if i-num_lin_pag = 0 then do:
            &IF "{&mguni_version}" >= "2.04" &THEN /*tech14178 joga para arquivo a ser convertido para PDF */
                IF usePDF() THEN DO:
                /* sem salta pÿgina */
                    output  {&stream} 
                            to value(v_cod_temp_file_pdf)
                            page-size 0
                            convert target c-cod_pag_carac_conver . 
                    RUN pi_set_print_device IN h_pdf_controller(INPUT imprsor_usuar.nom_disposit_so).
                END.
                ELSE
            &ENDIF
                /* sem salta pÿgina */
                    output  {&stream} 
                            to value(c-arq-control)
                            page-size 0
                            convert target c-cod_pag_carac_conver . 
        end.
        else do:
            &IF "{&mguni_version}" >= "2.04" &THEN /*tech14178 joga para arquivo a ser convertido para PDF */
                IF usePDF() THEN DO:
                /* sem salta pÿgina */
                    output  {&stream} 
                            to value(v_cod_temp_file_pdf)
                            paged page-size value(i-num_lin_pag) 
                            convert target c-cod_pag_carac_conver .
                    RUN pi_set_print_device IN h_pdf_controller(INPUT imprsor_usuar.nom_disposit_so).
                END.
                ELSE
            &ENDIF
                    /* com salta página */
                    output {&stream} 
                            to value(c-arq-control)
                            paged page-size value(i-num_lin_pag) 
                            convert target c-cod_pag_carac_conver .
        end.
    end.

    for each configur_layout_impres NO-LOCK 
        where configur_layout_impres.num_id_layout_impres = layout_impres.num_id_layout_impres
        by configur_layout_impres.num_ord_funcao_imprsor:

        find configur_tip_imprsor no-lock
            where configur_tip_imprsor.cod_tip_imprsor        = layout_impres.cod_tip_imprsor
            and   configur_tip_imprsor.cod_funcao_imprsor     = configur_layout_impres.cod_funcao_imprsor
            and   configur_tip_imprsor.cod_opc_funcao_imprsor = configur_layout_impres.cod_opc_funcao_imprsor
            use-index cnfgrtpm_id no-error.
        CREATE tt-configur_layout_impres_inicio.    
        BUFFER-COPY configur_tip_imprsor TO tt-configur_layout_impres_inicio
            ASSIGN tt-configur_layout_impres_inicio.num_ord_funcao_imprsor = configur_layout_impres.num_ord_funcao_imprsor.
    end.

    IF VALID-HANDLE(h-procextimpr) AND h-procextimpr:FILE-NAME = c_process-impress THEN
        RUN pi_after_output IN h-procextimpr (INPUT-OUTPUT TABLE tt-configur_layout_impres_inicio).

    FOR EACH tt-configur_layout_impres_inicio EXCLUSIVE-LOCK
        BY tt-configur_layout_impres_inicio.num_ord_funcao_imprsor :
        do v_num_count = 1 to extent(tt-configur_layout_impres_inicio.num_carac_configur):            
          case tt-configur_layout_impres_inicio.num_carac_configur[v_num_count]:
            when 0 then put {&stream} control null.
            when ? then leave.
            otherwise   put {&stream} control CODEPAGE-CONVERT(chr(tt-configur_layout_impres_inicio.num_carac_configur[v_num_count]),
                                                               session:cpinternal, 
                                                               c-cod_pag_carac_conver).
          end case.
        end.
        DELETE tt-configur_layout_impres_inicio.
    END.
  end.
  else do:
    &if "{&tofile}" = "" &then 
        assign c-impressora  = entry(1,tt-param.arquivo,":").
        assign c-layout      = entry(2,tt-param.arquivo,":"). 
        if num-entries(tt-param.arquivo,":") = 4 then
          assign c-arq-control = entry(3,tt-param.arquivo,":") + ":" + entry(4,tt-param.arquivo,":").
        else 
          assign c-arq-control = entry(3,tt-param.arquivo,":").
    &elseif "{&tofile}" <> "" &then
        assign c-impressora  = entry(1,{&tofile},":").
        assign c-layout      = entry(2,{&tofile},":").
      &if "{&tofile}" = "" &then 
        if num-entries(tt-param.arquivo,":") = 4 then
      &elseif "{&tofile}" <> "" &then
        if num-entries({&tofile},":") = 4 then
      &endif
          assign c-arq-control = entry(3,{&tofile},":") + ":" + entry(4,{&tofile},":").
        else
          assign c-arq-control = entry(3,{&tofile},":").
    &endif.                            

    find layout_impres no-lock
        where layout_impres.nom_impressora    = c-impressora
        and   layout_impres.cod_layout_impres = c-layout no-error.
    find imprsor_usuar no-lock
        where imprsor_usuar.nom_impressora = c-impressora
        and   imprsor_usuar.cod_usuario    = tt-param.usuario
        use-index imprsrsr_id no-error.
    find impressora  of imprsor_usuar no-lock no-error.
    find tip_imprsor of impressora    no-lock no-error.

    /*Alterado 26/04/2005 - tech1007 - Alterado para nÆo ocasionar problemas na conversÆo do mapa de caracteres*/
    IF AVAILABLE tip_imprsor THEN DO:
        ASSIGN c-cod_pag_carac_conver = tip_imprsor.cod_pag_carac_conver.
    END.
    IF AVAILABLE layout_impres THEN DO:
        ASSIGN i-num_lin_pag = layout_impres.num_lin_pag.
    END.
    /*Fim alteracao - tech1007*/

    &IF "{&mguni_version}" > "2.04" &THEN
        ASSIGN c_process-impress = impressora.cod_livre_1.
        IF c_process-impress <> "" THEN DO:
            IF SEARCH(c_process-impress) <> ? THEN DO:
                /*verifica se o programa j  est  sendo executado, 
                caso o encontre na mem¢ria usa o mesmo handle */
                h-procextimpr = SESSION:LAST-PROCEDURE.
                REPEAT:
                    IF VALID-HANDLE(h-procextimpr) AND 
                       h-procextimpr:TYPE = "PROCEDURE" AND 
                       h-procextimpr:FILE-NAME = c_process-impress 
                       THEN LEAVE.                       
                    h-procextimpr = h-procextimpr:PREV-SIBLING .                    
                    IF NOT VALID-HANDLE(h-procextimpr) THEN LEAVE.                
                END.
                IF NOT VALID-HANDLE(h-procextimpr) THEN
                    RUN VALUE(c_process-impress) PERSISTENT SET h-procextimpr.
            END.            
        END.

    &ENDIF
    
    &IF "{&mguni_version}" >= "2.04" &THEN /*tech14178 adiciona extensÆo PDT para que o arquivo a ser convertido nÆo fique com o mesmo nome do arquivo final*/
        IF usePDF() THEN 
            ASSIGN c-arq-control = c-arq-control + ".pdt":U.
    &endif

    


    if  i-num-ped-exec-rpw <> 0 then do:
        find b_ped_exec_style where b_ped_exec_style.num_ped_exec = i-num-ped-exec-rpw no-lock no-error. 
        find b_servid_exec_style of b_ped_exec_style no-lock no-error.
        find servid_exec_imprsor of b_servid_exec_style 
          where servid_exec_imprsor.nom_impressora = imprsor_usuar.nom_impressora no-lock no-error.

        if  available b_servid_exec_style and b_servid_exec_style.ind_tip_fila_exec = 'UNIX'
        then do:
            output {&stream} to value(c-dir-spool-servid-exec + "~/" + c-arq-control)
                   page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
        end /* if */.
        else do:
            output {&stream}  to value(c-dir-spool-servid-exec + "~/" + c-arq-control)
                   page-size value(layout_impres.num_lin_pag) convert target tip_imprsor.cod_pag_carac_conver.
        end /* else */.
    end.
    else do:
        /*Alterado 26/04/2005 - tech1007 - Removido pois o assign est  sendo realizado antes dos testes
        ASSIGN 
            i-num_lin_pag = layout_impres.num_lin_pag
            c-cod_pag_carac_conver = tip_imprsor.cod_pag_carac_conver.
        Fim alteracao 26/04/2005*/    

        IF VALID-HANDLE(h-procextimpr) AND h-procextimpr:FILE-NAME = c_process-impress THEN
            RUN pi_before_output IN h-procextimpr 
                (INPUT c-impressora,
                 INPUT c-layout,
                 INPUT tt-param.usuario,
                 INPUT-OUTPUT c-arq-control,
                 INPUT-OUTPUT i-num_lin_pag,
                 INPUT-OUTPUT c-cod_pag_carac_conver).
        if i-num_lin_pag = 0 then do:
            /* sem salta pÿgina */
            output  {&stream} 
                    to value(c-arq-control)
                    page-size 0
                    convert target c-cod_pag_carac_conver . 
        end.
        else do:
            /* com salta página */
            output {&stream} 
                    to value(c-arq-control)
                    paged page-size value(layout_impres.num_lin_pag) 
                    convert target tip_imprsor.cod_pag_carac_conver.
        end.
    end.
    
    &IF "{&mguni_version}" >= "2.04" &THEN /*tech14178 guarda o nome do arquivo a ser convertido para pdf  */
            if  i-num-ped-exec-rpw <> 0 THEN
                RUN pi_set_print_filename IN h_pdf_controller (INPUT c-dir-spool-servid-exec + "~/" + c-arq-control).
            ELSE
                RUN pi_set_print_filename IN h_pdf_controller (INPUT c-arq-control).
    &ENDIF


    for each configur_layout_impres NO-LOCK 
        where configur_layout_impres.num_id_layout_impres = layout_impres.num_id_layout_impres
        by configur_layout_impres.num_ord_funcao_imprsor:

        find configur_tip_imprsor no-lock
            where configur_tip_imprsor.cod_tip_imprsor        = layout_impres.cod_tip_imprsor
            and   configur_tip_imprsor.cod_funcao_imprsor     = configur_layout_impres.cod_funcao_imprsor
            and   configur_tip_imprsor.cod_opc_funcao_imprsor = configur_layout_impres.cod_opc_funcao_imprsor
            use-index cnfgrtpm_id no-error.
        CREATE tt-configur_layout_impres_inicio.    
        BUFFER-COPY configur_tip_imprsor TO tt-configur_layout_impres_inicio
            ASSIGN tt-configur_layout_impres_inicio.num_ord_funcao_imprsor = configur_layout_impres.num_ord_funcao_imprsor.
    end.

    IF VALID-HANDLE(h-procextimpr) AND h-procextimpr:FILE-NAME = c_process-impress THEN                
        RUN pi_after_output IN h-procextimpr (INPUT-OUTPUT TABLE tt-configur_layout_impres_inicio).

    FOR EACH tt-configur_layout_impres_inicio EXCLUSIVE-LOCK
        BY tt-configur_layout_impres_inicio.num_ord_funcao_imprsor :
        do v_num_count = 1 to extent(tt-configur_layout_impres_inicio.num_carac_configur):
          case tt-configur_layout_impres_inicio.num_carac_configur[v_num_count]:
            when 0 then put {&stream} control null.
            when ? then leave.
            otherwise   put {&stream} control CODEPAGE-CONVERT(chr(tt-configur_layout_impres_inicio.num_carac_configur[v_num_count]),
                                                               session:cpinternal, 
                                                               c-cod_pag_carac_conver).
                            
          end case.
        end.
        DELETE tt-configur_layout_impres_inicio.
    END.
  end.  
end.
else do:
    &if "{&tofile}" = "" &then
        if  i-num-ped-exec-rpw <> 0 then do:
            &if "{&pagesize}" = "" &then
              /*Alterado 14/02/2005 - tech1007 - Alterado para que quando for gerar RTF em batch
                o tamanho da p gina seja 42*/
              &IF "{&RTF}":U = "YES":U &THEN
                  IF tt-param.l-habilitaRTF = YES THEN DO:
                      output {&stream} 
                             to value(c-dir-spool-servid-exec + "~/" + v_output_file) 
                             paged page-size 43 /* tech1139 - 11/07/2005 - alterado pra imprimir 43 linhas por p gina - FO 1179.660 */
                             convert target "iso8859-1" {&append}.
                  END.
                  ELSE DO:
              &endif
                      output {&stream} 
                             to value(c-dir-spool-servid-exec + "~/" + v_output_file) 
                             paged page-size 64
                             convert target "iso8859-1" {&append}.
              &IF "{&RTF}":U = "YES":U &THEN
                  END.
              &endif
              /*Fim alteracao 14/02/2005*/
            &else         
              assign i-page-size-rel = integer("{&pagesize}").
              output {&stream} 
                     to value(c-dir-spool-servid-exec + "~/" + v_output_file) 
                     paged page-size value(i-page-size-rel)
                     convert target "iso8859-1" {&append}.
            &endif              
        end.                             
        else do:
            /* Sa¡da para RTF - tech981 20/10/2004 */
            &if "{&pagesize}" = "" &then
                &IF "{&RTF}":U = "YES":U &THEN
                    if  tt-param.l-habilitaRTF = YES then do:
                        output {&stream}
                            to value(v_output_file)
                            paged page-size 43 /* tech1139 - 11/07/2005 - alterado pra imprimir 43 linhas por p gina - FO 1179.660 */
                            convert target "iso8859-1" {&append}.
                    END.
                    ELSE DO:
                &endif
                        output {&stream} 
                               to value(v_output_file) 
                               paged page-size 64 
                               convert target "iso8859-1" {&append}.                
                &IF "{&RTF}":U = "YES":U &THEN
                    END.
                &endif
            &else 
                    assign i-page-size-rel = integer("{&pagesize}").
                    output {&stream}
                        to value(v_output_file)
                        paged page-size value(i-page-size-rel)
                        convert target "iso8859-1" {&append}.
            &endif
        end.    
    &else    
        if  i-num-ped-exec-rpw <> 0 then do:
          &if "{&pagesize}" = "" &then
            output {&stream} 
                   to value(c-dir-spool-servid-exec + "~/" + v_output_file) 
                   paged page-size 64
                   convert target "iso8859-1" {&append}.         
          &else         
            assign i-page-size-rel = integer("{&pagesize}").
            output {&stream} 
                   to value(c-dir-spool-servid-exec + "~/" + v_output_file) 
                   paged page-size value(i-page-size-rel)
                   convert target "iso8859-1" {&append}.         
          &endif         
        end.        
        else do:
          &if "{&pagesize}" = "" &then
            output {&stream} 
                   to value(v_output_file) 
                   paged page-size 64 
                   convert target "iso8859-1" {&append}.         
          &else         
            assign i-page-size-rel = integer("{&pagesize}").
            output {&stream} 
                   to value(v_output_file) 
                   paged page-size value(i-page-size-rel)
                   convert target "iso8859-1" {&append}.         
          &endif         
        end.  
    &endif
end.

/* i-rpout */

                               
   RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
   RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").

   RUN piImprimeRelat.

   RUN pi-finalizar IN h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".
END.



PROCEDURE piImprimeRelat:
    PUT  "Codigo" ";"
         "Nome"    ";"
         "CNPJ"          ";"
         "Grupo Cliente ;"
         "Cod.Rep"      ";"
         "Nome Representante"         ";"
         "Data Limite" ";"
         "Limite Credito"  ";"      
         "Limite Adicional" ";"
         "Titulo Aberto"         ";"
         "Pedidos em Aberto"     ";"
         "Data Ultima Nota"   ";"
         "Valor Ultima Nota" ";"
         "Situa‡Æo Cr‚dito" ";"
         "Situa‡Æo Cliente" SKIP.

    FOR EACH emitente  NO-LOCK
        WHERE emitente.identific   <> 2
        AND   emitente.cod-gr-cli  <> 6
        AND   emitente.dt-lim-cred >= tt-param.dt-venc-lim-ini
        AND   emitente.dt-lim-cred <= tt-param.dt-venc-lim-fin,
        FIRST int-emitente NO-LOCK
        WHERE int-emitente.cod-emitente = emitente.cod-emitente
        BREAK BY emitente.nome-matriz:                                                              

        IF  tt-param.id-situacao <> 6 /* todos */
        AND emitente.ind-cre-cli <> tt-param.id-situacao THEN NEXT.

        IF  tt-param.id-ativo <> 3 THEN DO: /* todos */
            IF  tt-param.id-ativo     = 1 /* se nÆo estiver ativo ignora */
            AND int-emitente.id-ativo = NO THEN NEXT.

            IF  tt-param.id-ativo     = 2 /* se nao estiver inativo ignora */
            AND int-emitente.id-ativo = YES THEN NEXT.
        END.

        RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo Cliente : " + STRING(emitente.cod-emitente)).

        IF FIRST-OF(emitente.nome-matriz) THEN DO:
            ASSIGN de-titulo-aberto  = 0
                   de-pedidos-aberto = 0
                   de-lim-credito    = 0
                   de-lim-adicional  = 0
                   da-dt-emis-nota = ?
                   de-vl-tot-nota  = 0.
            FIND b-emitente
                 WHERE b-emitente.nome-abrev = emitente.nome-matriz NO-LOCK NO-ERROR.
            FIND repres
                 WHERE repres.cod-rep = b-emitente.cod-rep
                 NO-LOCK NO-ERROR.

           ASSIGN i-cod-emitente  = b-emitente.cod-emitente
                  c-nome-emit     = b-emitente.nome-emit
                  c-cgc           = b-emitente.cgc
                  i-cod-rep       = repres.cod-rep
                  c-nome          = repres.nome.
        END.

        FIND LAST nota-fiscal
            WHERE nota-fiscal.nome-ab-cli = emitente.nome-abrev 
              AND nota-fiscal.dt-emis-nota <= TODAY
             NO-LOCK NO-ERROR.

        IF AVAIL nota-fiscal and
           (da-dt-emis-nota = ? OR
            nota-fiscal.dt-emis-nota > da-dt-emis-nota) THEN
            ASSIGN da-dt-emis-nota = nota-fiscal.dt-emis-nota
                   de-vl-tot-nota  = nota-fiscal.vl-tot-nota.

        for each estabelecimento no-lock:
                   /* T¡tulos transferidos para o 102 */
              if estabelecimento.cod_estab = '201'
                 then next.
              if estabelecimento.cod_estab = '301'
                 then next.
             
             FOR EACH tit_acr NO-LOCK
                 WHERE tit_acr.cod_estab           = estabelecimento.cod_estab
                 AND   tit_acr.cdn_cliente         = emitente.cod-emitente
                 AND   (tit_acr.ind_tip_espec_docto = "Normal"
                  OR    tit_acr.ind_tip_espec_docto BEGINS "Vendor")
                 AND   tit_acr.log_sdo_tit_acr     = YES
                 AND   tit_acr.log_tit_acr_estordo = NO USE-INDEX titacr_cliente:
                 ASSIGN de-titulo-aberto = de-titulo-aberto + tit_acr.val_sdo_tit_acr.
             END.
        end.
        
        FOR EACH ped-venda NO-LOCK
            WHERE ped-venda.nome-abrev = emitente.nome-abrev
              AND ped-venda.cod-sit-ped < 3
              AND ped-venda.cod-sit-aval <> 5
              AND ped-venda.completo     = YES:
            ASSIGN de-pedidos-aberto = de-pedidos-aberto + ped-venda.vl-liq-abe.

        END.
        
        IF  emitente.nome-matriz = emitente.nome-abrev THEN
            ASSIGN de-lim-credito   = emitente.lim-credito
                   de-lim-adicional = emitente.lim-adicional.

        IF  LAST-OF(emitente.nome-matriz) THEN DO:
            ASSIGN c-ind-cre-cli = {adinc/i10ad098.i 4 emitente.ind-cre-cli}.

            PUT  i-cod-emitente                                 ";"
                 c-nome-emit                                    ";"
                 c-cgc                                          ";"
                 b-emitente.cod-gr-cli                          ";"
                 i-cod-rep                                      ";"
                 c-nome                                         ";"
                 b-emitente.dt-lim-cred                         ";"
                 de-lim-credito                                 ";"      
                 de-lim-adicional                               ";"
                 de-titulo-aberto       FORMAT ">>>,>>>,>>9.99" ";"
                 de-pedidos-aberto      FORMAT ">>>,>>>,>>9.99" ";"
                 da-dt-emis-nota                                ";"
                 de-vl-tot-nota                                 ";"
                 c-ind-cre-cli                                  ";"
                 int-emitente.id-ativo FORMAT "SIM/NÇO" SKIP.

            FIND tt-limite
                 WHERE tt-limite.lim-credito = de-lim-credito
                NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-limite THEN DO:
                CREATE tt-limite.
                ASSIGN tt-limite.lim-credito = de-lim-credito.
            END.
            ASSIGN tt-limite.quantidade = tt-limite.quantidade + 1.

        END.

    END.                                       

    PUT SKIP(2)
        "  Resumo por Limite" SKIP(2)
        "        Limite Qtde" SKIP.
    FOR EACH tt-limite
        BREAK BY tt-limite.lim-credito:
        PUT tt-limite.lim-credito FORMAT ">>>,>>>,>>9.99"
            tt-limite.quantidade  FORMAT ">>>>9" SKIP.
    END.

END.
