/********************************************************************************
*      Programa .....: escdp114rp.p                                             *
*      Data .........: 05 de junho de 2022                                      *
*      Sistema ......: ESP                                                      *
*      Empresa ......: iDBA                                                     *
*      Cliente ......: Intelbras                                                *
*      Programador ..: Maur¡cio C.                                              *
*      Objetivo .....: Consistˆncia de Dados APS                                *
*********************************************************************************
*      VERSAO       DATA        RESPONSAVEL   MOTIVO                            *
*      1.00.00.000  05/06/2022  Mauricio C.   Desenv.(baseado em bacas enviados)*
*      1.00.00.009  30/06/2023  Mauricio C.   Relat. 23 e reestrutura‡Æo        *
********************************************************************************/
function fn-get-dir returns character (input p-file as character) forwards.
{include/i-prgvrs.i escdp114rp 1.00.00.010}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i escdp114rp ESP}
&ENDIF

define temp-table tt-param no-undo
    field destino         as integer
    field arquivo         as char format "x(35)"
    field usuario         as char format "x(12)"
    field data-exec       as date
    field hora-exec       as integer
    field classifica      as integer
    field desc-classifica as char format "x(40)"
    field modelo-rtf      as char format "x(35)"
    field l-habilitaRtf   as LOG
    field execucao        as inte
    field diretorio       as char
    field checks          as char.

define temp-table tt-digita no-undo
    field cod-estabel as character format "x(5)"
    field id-brw      as inte
    field nome        as character format "x(40)"
    index id cod-estabel
             id-brw
    index id2 id-brw
              cod-estabel.

/* Transfer Definitions */
define temp-table tt-raw-digita
   field raw-digita as raw.

/* recebimento de parƒmetros */
define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. /* for each tt-raw-digita */
find current tt-param  no-error.    
find current tt-digita no-error.

/* include padrÆo para vari veis de relat¢rio  */
{include/i-rpvar.i}

/* defini‡Æo de vari veis  */
def var h-acomp      as handle no-undo.
def var h-wprog      as handle no-undo.
def var i-cont       as inte   no-undo.
def var i-aux        as inte   no-undo.
def var i-procedure  as inte   no-undo.
def var c-procedure  as char   no-undo.
def var c-sit-imp    as char   no-undo.
def var c-observacao as char   no-undo.
def var c-arquivo    as char   no-undo.

def var c-rodape-80  as char no-undo.
def var c-rodape-132 as char no-undo.
def var c-rodape-172 as char no-undo.
def var c-rodape-215 as char no-undo.
def var c-rodape-250 as char no-undo.

def var c-obsol  as char extent init ['Ativo','Obsoleto Ordens Autom ticas','Obsoleto Todas as Ordens','Totalmente Obsoleto']           format "x(30)" no-undo.
def var c-unid   as char extent init ['Horas','Minutos','Segundos','Dias','Requisitada','Iniciada','Finalizada','Terminada']            format "x(12)" no-undo.
def var c-estado as char extent init ['NÆo iniciada','Liberada','Alocada','Separada','Requisitada','Iniciada','Finalizada','Terminada'] format "x(15)" no-undo.

def buffer b-item      for item.
def buffer b-ferr-prod for ferr-prod.
def buffer b-tt-digita for tt-digita.

def stream st-relat.

{esp/cdp/escdp114rp.i}
{include/i-rpout.i}

if tt-param.diretorio = ""
then do:
     assign file-info:file-name = tt-param.arquivo.
     assign tt-param.diretorio = file-info:full-pathname.
     assign tt-param.diretorio = fn-get-dir(input trim(tt-param.diretorio)).
end.

if tt-param.execucao = 1 /* Online */
then do:
     run utp/ut-acomp.p persistent set h-acomp.
     run pi-inicializar in h-acomp(input "Processando relat¢rios... Aguarde!").

     if tt-param.destino = 3 /* Terminal */
     then run utp/ut-utils.p persistent set h-wprog.
end. /* if tt-param.execucao = 1 */

do i-procedure = 1 to num-entries(tt-param.checks):
    if entry(i-procedure,tt-param.checks) <> "S"
    then next.

    assign c-procedure = "pi-procedimento-" + string(i-procedure,"99").

    run value(c-procedure) in this-procedure.
end. /* do i-procedure = 1 to num-entries(tt-param.checks) */

if valid-handle(h-wprog)
then delete procedure h-wprog no-error.

if valid-handle(h-acomp)
then do:
     run pi-finalizar in h-acomp.
     if valid-handle(h-acomp)
     then delete procedure h-acomp no-error.
end.

{include/i-rpclo.i}

return "OK":U.  

/******************** Procedures e Fun‡äes ********************/
{esp/cdp/escdp114rp.i0}  
{esp/cdp/escdp114rp.i1}  /* Analisa Item CKD-SKD pendente de informa‡Æo                                */
{esp/cdp/escdp114rp.i2}  /* Grupos de M quinas ativos sem Centro de Trabalho ou desativados            */
{esp/cdp/escdp114rp.i3}  /* Itens ativos com Opera‡äes ativas em Grupos de M quina desativados         */
{esp/cdp/escdp114rp.i4}  /* Itens fantasma com Roteiro                                                 */
{esp/cdp/escdp114rp.i5}  /* Opera‡äes sem cadastro de Recurso Secund rio                               */
{esp/cdp/escdp114rp.i6}  /* Ordens de Produ‡Æo abertas sem Opera‡Æo-Roteiro de Fabrica‡Æo              */
{esp/cdp/escdp114rp.i7}  /* Ordens de Produ‡Æo sem Reservas                                            */
{esp/cdp/escdp114rp.i8}  /* Ordens de Compra anteriores … data de hoje                                 */
{esp/cdp/escdp114rp.i9}  /* Pedidos de Venda de Itens obsoletos                                        */
{esp/cdp/escdp114rp.i10} /* Opera‡äes com tempo zerado                                                 */
{esp/cdp/escdp114rp.i11} /* Itens obsoletos com dias de cobertura                                      */
{esp/cdp/escdp114rp.i12} /* Mesma Ferramenta em Grupos de M quina Diferentes                           */
{esp/cdp/escdp114rp.i13} /* Opera‡äes sem atributos no SMD/Injetoras                                   */
{esp/cdp/escdp114rp.i14} /* Ordens de Produ‡Æo abertas com saldo zerado                                */
{esp/cdp/escdp114rp.i15} /* Opera‡äes com Unidade diferente de 1 ou diferente de Minutos               */
{esp/cdp/escdp114rp.i16} /* Grupos de M quinas ativos sem relacionamento com µrea de Produ‡Æo          */
{esp/cdp/escdp114rp.i17} /* Itens ativos sem Opera‡Æo                                                  */
{esp/cdp/escdp114rp.i18} /* Cadastro de Homens APS zerados                                             */
{esp/cdp/escdp114rp.i19} /* Mais de um mesmo tipo de Recurso na mesma Opera‡Æo                         */
{esp/cdp/escdp114rp.i20} /* Ordens de Produ‡Æo de semiacabados sem relacionamento com estrutura ativa  */
{esp/cdp/escdp114rp.i21} /* Itens com apenas 1 Opera‡Æo em Grupos de M quinas infinitos                */
{esp/cdp/escdp114rp.i22} /* Opera‡äes com MÆo de Obra em Grupo de M quina incorreto                    */
{esp/cdp/escdp114rp.i23} /* Reservas de Ordens de Produ‡Æo abertas sem relacto com estrutura ativa     */
{esp/cdp/escdp114rp.i24} /* Divergˆncias Homens APS Roteiro x Ordem de Produ‡Æo                        */

function fn-get-dir returns character (input p-file as character):
    def var c-dir-aux as char no-undo.
    def var c-result  as char no-undo.

    if p-file begins "\\"
    then assign c-dir-aux = replace(p-file,"/","\")
                 c-result = substr(c-dir-aux,1,r-index(c-dir-aux,"\"))
                 c-result = replace(c-result,"/","\").
    else assign c-dir-aux = replace(p-file,"\","/")
                c-result  = substr(c-dir-aux,1,r-index(c-dir-aux,"/"))
                c-result  = replace(c-result,"\","/").

    if c-result = ""
    or c-result = ?
    then assign c-result = session:temp-directory.

    return c-result.
end function.

