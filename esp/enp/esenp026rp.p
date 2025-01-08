/******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esenp026rp 1.00.00.000}
/******************************************************************************
** Programa: esp/enp/esenp026rp.p
** Data....: Maio/2014.
** Autor...: SENSUS Tecnologia
** Objetivo: Relat¢rio Pinho - Itens .
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

{esp/enp/esenp026tt.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

def temp-table tt-raw-digita
    field raw-digita as raw.

def input parameter  raw-param as raw no-undo.
def input parameter  table for tt-raw-digita.

DEFINE TEMP-TABLE tt-relat NO-UNDO
    FIELD produto      LIKE ITEM.it-codigo
    FIELD componente   LIKE estrutura.es-codigo
    FIELD quantidade   LIKE movto-estoq.quantidade
    FIELD data-movto   LIKE movto-estoq.dt-trans.

DEFINE VARIABLE i-qtde-auxiliar LIKE estrutura.qtd-item NO-UNDO.

create tt-param.
raw-transfer raw-param to tt-param.

find emscad.empresa no-lock where
     empresa.cod_empresa = V_Cod_Empres_Usuar no-error.

assign c-empresa      = empresa.nom_razao_social
       c-sistema      = "ESP":U
       c-titulo-relat = "Relat¢rio Pinho":U.

{include/i-rpcab.i}
{include/i-rpout.i &pagesize="80"}

view frame f-cabec.
ASSIGN c-arquivo = c-dir-arquivo-session + "esenp026.csv".

OUTPUT STREAM st-csv TO VALUE(c-arquivo) NO-CONVERT.

put STREAM st-csv UNFORMATTED "PRODUTO;ITEM;QUANTIDADE;DATA":U SKIP.

DO ON ERROR UNDO, LEAVE:
    
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
    RUN pi-inicializar IN h-acomp (INPUT "Obtendo informa‡äes...").

    RUN pi-le-movto-estoq.

    FOR EACH tt-relat:
        RUN pi-acompanhar IN h-acomp (INPUT "Item: " + STRING(tt-relat.produto) + " Componente: " + STRING(tt-relat.componente)).

        put STREAM st-csv UNFORMATTED 
            tt-relat.produto      FORMAT "x(16)":U ";"
            tt-relat.componente   FORMAT "x(16)":U ";"
            trim(string(tt-relat.quantidade))   FORMAT "x(20)":U /*FORMAT "->>>>,>>>,>>9.9999":U*/ ";"    
            tt-relat.data-movto   FORMAT "99/99/9999":U SKIP.
    END. /* IF  NOT AVAIL tt-relat */
    
END. /* DO ON ERROR UNDO, LEAVE: */

OUTPUT STREAM st-csv CLOSE.

/*---[ P gina de Parƒmetros ]------------------------------------------------------------------------*/
FOR FIRST tt-param:
    PUT UNFORMATTED
    " Estabelecimento: "                      AT 16
    tt-param.cod-estabel                      AT 35 SKIP
    "         Per¡odo: "                      AT 16 
    tt-param.dt-inicial FORMAT "99/99/9999":U TO 44 
    "|< >|"                                   AT 46
    tt-param.dt-final   FORMAT "99/99/9999":U AT 52 SKIP.
    
    PUT UNFORMATTED SKIP(1) "Planilha gerada no caminho: " + c-arquivo AT 08 SKIP.
END. /* FOR FIRST tt-param: */

run pi-finalizar in h-acomp.

view frame f-rodape.

{include/i-rpclo.i}
RETURN "OK".

/*---[ PROCEDURES INTERNAS ]-------------------------------------------------------------------------*/
PROCEDURE pi-le-movto-estoq:

    EMPTY TEMP-TABLE tt-relat NO-ERROR.

    DO  v-dat-tmp = tt-param.dt-inicial TO tt-param.dt-final:

        RUN pi-acompanhar IN h-acomp (INPUT "Data: " + STRING(v-dat-tmp, "99/99/9999")).
        
        FOR EACH  movto-estoq NO-LOCK
            WHERE movto-estoq.cod-estabel = tt-param.cod-estabel
            AND   movto-estoq.esp-docto   = 1 /* ACA */
            AND   movto-estoq.dt-trans    = v-dat-tmp,
            EACH  estrutura NO-LOCK 
            WHERE estrutura.it-codigo     = movto-estoq.it-codigo
            AND  (estrutura.data-inicio  <= movto-estoq.dt-trans
            OR    estrutura.data-termino >= movto-estoq.dt-trans):
            
            RUN pi-acompanhar IN h-acomp (INPUT "Item: " + STRING(movto-estoq.it-codigo) + " Componente: " + STRING(estrutura.es-codigo)).

            FOR EACH  bf-estrutura NO-LOCK 
                WHERE bf-estrutura.it-codigo     = estrutura.es-codigo
                AND  (bf-estrutura.data-inicio  <= movto-estoq.dt-trans
                OR    bf-estrutura.data-termino >= movto-estoq.dt-trans), 
                FIRST bf-item NO-LOCK
                WHERE bf-item.it-codigo         = bf-estrutura.es-codigo
                AND   bf-item.compr-fabric      = 1 /* Comprado */ :
        
                FIND FIRST tt-relat
                    WHERE  tt-relat.produto    = movto-estoq.it-codigo 
                    AND    tt-relat.componente = bf-estrutura.es-codigo
                    AND    tt-relat.data-movto = movto-estoq.dt-trans NO-ERROR.
                IF  NOT AVAIL tt-relat THEN DO:
                    CREATE tt-relat.
                    ASSIGN tt-relat.produto      = movto-estoq.it-codigo
                           tt-relat.componente   = bf-estrutura.es-codigo
                           tt-relat.data-movto   = movto-estoq.dt-trans
                           tt-relat.quantidade   = (movto-estoq.quantidade * bf-estrutura.qtd-compon).
                END.
                ELSE ASSIGN tt-relat.quantidade = tt-relat.quantidade + (movto-estoq.quantidade * bf-estrutura.qtd-compon).

            END. /* FOR EACH  bf-estrutura NO-LOCK  */
        END. /* FOR EACH  movto-estoq NO-LOCK */
    END. /* DO  v-dat-tmp = tt-param.dat-inicial TO tt-param.dat-final: */

END PROCEDURE. /* PROCEDURE pi-le-movto-estoq: */
