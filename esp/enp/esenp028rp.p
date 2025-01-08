/******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esenp028rp 1.00.00.000}
/******************************************************************************
** Programa: esp/enp/esenp028rp.p
** Autor...: SENSUS Tecnologia
** Objetivo: Relat¢rio Itens (Demanda).
*******************************************************************************/

{include/i-rpvar.i}    
{utp/ut-glob.i}

DEFINE VARIABLE log-primeiro   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE ccusto-aux     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cta_ctbl-aux   AS CHARACTER NO-UNDO.
DEFINE VARIABLE ddat-integ-aux AS DATE      NO-UNDO.
DEFINE VARIABLE chra-integ-aux AS CHARACTER NO-UNDO.
DEFINE VARIABLE h-acomp        AS HANDLE    NO-UNDO.
DEFINE VARIABLE v-dat-tmp      AS DATE      NO-UNDO.

DEFINE STREAM st-csv.
DEFINE VARIABLE c-arquivo AS CHARACTER NO-UNDO.

DEFINE BUFFER bf-estrutura FOR estrutura.
DEFINE BUFFER bf-item      FOR ITEM.

{esp/enp/esenp028tt.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

def temp-table tt-raw-digita
    field raw-digita as raw.

def input parameter  raw-param as raw no-undo.
def input parameter  table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

find emscad.empresa no-lock where
     empresa.cod_empresa = V_Cod_Empres_Usuar no-error.

assign c-empresa      = empresa.nom_razao_social
       c-sistema      = "ESP":U
       c-titulo-relat = "Relat¢rio Itens (Demanda)":U.

{include/i-rpcab.i}
{include/i-rpout.i &pagesize="80"}

view frame f-cabec.
ASSIGN c-arquivo = c-dir-arquivo-session + "esenp028.csv".

OUTPUT STREAM st-csv TO VALUE(c-arquivo) NO-CONVERT.

put STREAM st-csv UNFORMATTED "ITEM;DESCRICAO;DEMANDA;SITUACAO":U SKIP.

DO ON ERROR UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar IN h-acomp (INPUT "Obtendo informa‡äes...").

    item_block:
    FOR EACH  ITEM NO-LOCK
        WHERE ITEM.it-codigo >= tt-param.item-ini
        AND   ITEM.it-codigo <= tt-param.item-fim:

        RUN pi-acompanhar IN h-acomp (INPUT "Item: " + STRING(ITEM.it-codigo)).

        IF tt-param.ativos /* Somente Itens Ativos */ 
        AND ITEM.cod-obsoleto > 1 THEN NEXT item_block.

        put STREAM st-csv UNFORMATTED 
            ITEM.it-codigo                                FORMAT "x(16)":U ";"
            ITEM.desc-item                                FORMAT "X(60)":U ";"
            CAPS({ininc/i02in122.i 04 ITEM.demanda})      FORMAT "X(12)":U ";" 
            CAPS({ininc/i17in172.i 04 item.cod-obsoleto}) FORMAT "x(30)":U SKIP.
    END. /* FOR EACH  ITEM NO-LOCK ... */
    
END. /* DO ON ERROR UNDO, LEAVE: */

OUTPUT STREAM st-csv CLOSE.

/*---[ P gina de Parƒmetros ]------------------------------------------------------------------------*/
FOR FIRST tt-param:
    PUT UNFORMATTED
    "Item: "                          AT 13
    tt-param.item-ini FORMAT "X(7)":U TO 27
    "|< >|"                           AT 31
    tt-param.item-fim FORMAT "X(7)":U TO 44 SKIP.

    IF tt-param.ativos 
    THEN PUT "[ X ]" AT 13.
    ELSE PUT "[   ]" AT 13.  
    
    PUT " Somente Itens Ativos":U TO 19.
    
    PUT UNFORMATTED SKIP(1) "Planilha gerada no caminho: " + c-arquivo AT 08 SKIP.
END. /* FOR FIRST tt-param: */

run pi-finalizar in h-acomp.

view frame f-rodape.

{include/i-rpclo.i}
RETURN "OK".
