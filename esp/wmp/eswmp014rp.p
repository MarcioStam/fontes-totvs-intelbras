/***********************************************************************
**  Programa..: ESP\CSP\eswmp014RP.P
************************************************************************/
{include/i-prgvrs.i eswmp014RP 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/wmp/eswmp014tt.i}
{esp/es0018.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

{include/i-rpvar.i}

def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

def var h-acomp      as handle no-undo.

DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.

DEFINE VARIABLE c-arquivo-item AS CHAR NO-UNDO.
DEFINE VARIABLE c-arquivo-nota AS CHAR NO-UNDO.
DEFINE VARIABLE c-destino AS CHAR FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE c-tipo    AS CHAR FORMAT "x(60)" NO-UNDO.
DEFINE VARIABLE de-tot-nota LIKE item-doc-est.preco-total[1] NO-UNDO.
                                          
DEFINE STREAM s1.
DEFINE STREAM s2.

find mgcad.empresa
    where empresa.ep-codigo = "1" no-lock no-error.

find first param-global no-lock no-error.

{utp/ut-liter.i Espec¡ficos Intelbras * }
assign c-sistema = return-value.
{utp/ut-liter.i Relat¢rio de Compras - Condi‡Æo de pagamento * }

assign c-titulo-relat = RETURN-VALUE.
assign c-empresa     = param-global.grupo
       c-programa    = "eswmp014":U
       c-versao      = "1.00":U
       c-revisao     = "000"
       c-destino     = {varinc/var00002.i 04 tt-param.destino}.

form
/*form-selecao-ini*/
    skip(1)
    "                                                    SELE€ÇO"         
    skip(1) 
    /*form-selecao-usuario*/
    tt-param.cod-estabel-ini COLON 44 label "Estab" 
    "<|   |>" at 53 tt-param.cod-estabel-fim no-label skip
    tt-param.item-ini FORMAT "x(16)" colon 34 label "Item" 
    "<|   |>" at 53 tt-param.item-fim FORMAT "x(16)" no-label skip
    skip(1)
    "                                                    ARQUIVO"         
    skip(1)
    "Caminho arquivo Itens '.CSV' em: " at 26  c-arquivo-item NO-LABEL FORMAT "x(80)" SKIP
    skip(1) 
    "                                                   IMPRESSÇO"
    skip(1) 
    c-destino           label "Destino" colon 41 "-"
    tt-param.arquivo    no-label
    tt-param.usuario    label "Usu rio" colon 41
    skip(1)
/*form-impressao-fim*/
    with stream-io side-labels no-attr-space no-box width 200 frame f-impressao.

/* ***************************  Main Block  *************************** */
{include/i-rpcab.i}
{include/i-rpout.i} 

view frame f-cabec.
view frame f-rodape.    
run utp/ut-acomp.p persistent set h-acomp.  

run pi-inicializar in h-acomp (input "Imprimindo":U). 

IF  OPSYS = "UNIX" THEN 
    ASSIGN c-arquivo-item = c-dir-arquivo-session + c-seg-usuario + "/" + "eswmp014_ITEM_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
ELSE                                                                                   
    ASSIGN c-arquivo-item = SESSION:TEMP-DIRECTORY + "eswmp014_ITEM_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".

RUN piImprimeRelat-ITEM.

disp tt-param.cod-estabel-ini
     tt-param.cod-estabel-fim
     tt-param.item-ini
     tt-param.item-fim 
     c-arquivo-item
     c-destino           
     tt-param.arquivo    
     tt-param.usuario 
         with frame f-impressao.   

run pi-finalizar in h-acomp.
{include/i-rpclo.i}

RETURN "OK".

/*****************************************************************************************
**
** PROCEDURES INTERNAS
**
*****************************************************************************************/
PROCEDURE piImprimeRelat-ITEM:
    DEF VAR c-status AS CHAR FORMAT "x(20)" NO-UNDO.

    OUTPUT STREAM s1 TO VALUE(c-arquivo-item) CONVERT TARGET "iso8859-1".

    PUT stream s1 "Emissao;Baixa Estoque;Data Sa¡da;Estab;Serie;Nota;Item;Dep¢sito;Qtd;Transportador;Status;" SKIP.

    FOR EACH int-wms-nf-atualiz NO-LOCK
        WHERE int-wms-nf-atualiz.cod-estabel >= tt-param.cod-estabel-ini
          AND int-wms-nf-atualiz.cod-estabel <= tt-param.cod-estabel-fim
          AND int-wms-nf-atualiz.it-codigo   >= tt-param.item-ini
          AND int-wms-nf-atualiz.it-codigo   <= tt-param.item-fim
          ,FIRST nota-fiscal NO-LOCK
              WHERE nota-fiscal.cod-estabel = int-wms-nf-atualiz.cod-estabel
                AND nota-fiscal.serie       = int-wms-nf-atualiz.serie
                AND nota-fiscal.nr-nota-fis = int-wms-nf-atualiz.nr-nota-fis:

          ASSIGN c-status = "".
          CASE nota-fiscal.idi-sit-nf-eletro:
              WHEN 1 THEN ASSIGN c-status = "Nao Gerada".
              WHEN 2 THEN ASSIGN c-status = "Em Processamento".
              WHEN 3 THEN ASSIGN c-status = "Uso Autorizado".
              WHEN 4 THEN ASSIGN c-status = "Uso Denegado".
              WHEN 5 THEN ASSIGN c-status = "Rejeitado".
              WHEN 6 THEN ASSIGN c-status = "Cancelada".
              WHEN 7 THEN ASSIGN c-status = "Inutilizada".
              WHEN 8 THEN ASSIGN c-status = "Em Proc. Transmissao".
              WHEN 9 THEN ASSIGN c-status = "Em Processamento SEFAZ".
          END CASE.

          PUT STREAM s1  nota-fiscal.dt-emis-nota      ";"
                        nota-fiscal.dt-confirma        ";"
                        nota-fiscal.dt-saida           ";"
                        nota-fiscal.cod-estabel        ";"
                        nota-fiscal.serie              ";"
                        nota-fiscal.nr-nota-fis        ";"
                        int-wms-nf-atualiz.it-codigo   ";"
                        int-wms-nf-atualiz.cod-depos   ";"
                        int-wms-nf-atualiz.qt-baixada  ";"
                        nota-fiscal.nome-transp        ";"
                        c-status SKIP.

    END.

    OUTPUT STREAM s1 CLOSE.

END PROCEDURE.


