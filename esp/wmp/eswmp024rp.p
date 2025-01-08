/***********************************************************************
**  Programa..: ESP\WMP\eswmp024RP.P
**  Autor.....: Nicolas Martinez
**  Data......: 19/08/2021
************************************************************************/
{include/i-prgvrs.i eswmp024RP 2.04.00.000}

/****************************  Definitions  ****************************/
{esp/wmp/eswmp024tt.i}
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
DEFINE VARIABLE c-destino AS CHAR FORMAT "x(10)" NO-UNDO.

DEFINE STREAM s1.

find mgcad.empresa
    where empresa.ep-codigo = "1" no-lock no-error.

find first param-global no-lock no-error.

{utp/ut-liter.i Espec¡ficos Intelbras * }
assign c-sistema = return-value.
{utp/ut-liter.i Relat¢rio de Saldos de Itens controlados por Data de Entrada * }

assign c-titulo-relat = RETURN-VALUE.
assign c-empresa     = param-global.grupo
       c-programa    = "eswmp020":U
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

    tt-param.cod-local-ini FORMAT "x(5)" colon 34 label "Local" 
    "<|   |>" at 53 tt-param.cod-local-fim FORMAT "x(5)" no-label SKIP

    tt-param.item-ini FORMAT "x(16)" colon 34 label "Item" 
    "<|   |>" at 53 tt-param.item-fim FORMAT "x(16)" no-label skip
    tt-param.lg-vencidos FORMAT "Sim/NÆo" LABEL "Somente Vencidos no estoque" COLON 34 SKIP
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

FUNCTION fnEnderecoBox RETURNS CHARACTER
  ( INPUT pCodEstabel AS CHAR,
    INPUT pCodLocal AS CHAR,
    INPUT pIdBox   AS DEC ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VAR c-cod-endereco AS CHARACTER               NO-UNDO.
    DEFINE VAR c-lado         AS CHARACTER FORMAT "X(3)" NO-UNDO.

    FIND FIRST Wm-box
         WHERE Wm-box.cod-estabel = pCodEstabel AND
               Wm-box.cod-local   = pCodLocal   AND
               Wm-box.id-box      = pIdBox      NO-LOCK NO-ERROR.
    
    FIND FIRST wm-param NO-LOCK NO-ERROR.

   
    IF AVAIL Wm-box THEN DO:
        ASSIGN c-cod-endereco  = Wm-box.cod-bloco + '/' + Wm-box.cod-rua + '/' + Wm-box.cod-nivel + '/'+ Wm-box.cod-coluna              
               c-lado = SUBSTRING({scinc/i02sc030.i 04 Wm-box.ind-posicao-box},1,3).

        IF wm-param.log-controla-posicao = TRUE THEN
            ASSIGN c-cod-endereco  = c-cod-endereco + '/' + c-lado.
    END.

    RETURN c-cod-endereco.   /* Function return value. */

END FUNCTION.

/* ***************************  Main Block  *************************** */
{include/i-rpcab.i}
{include/i-rpout.i} 

view frame f-cabec.
view frame f-rodape.    
run utp/ut-acomp.p persistent set h-acomp.  

run pi-inicializar in h-acomp (input "Imprimindo":U). 

IF  OPSYS = "UNIX" THEN 
    ASSIGN c-arquivo-item = c-dir-arquivo-session + c-seg-usuario + "/" + "eswmp024_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
ELSE DO:
    IF tt-param.destino <> 3 //Se for Terminal gera no Temp da maquina e nÆo na rede, assim no momento de abrir o excel abre mais rapido 
    THEN ASSIGN c-arquivo-item = c-dir-arquivo-session + c-seg-usuario + "\" + "eswmp024_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
    ELSE ASSIGN c-arquivo-item = SESSION:TEMP-DIRECTORY + "eswmp024_" + STRING(TODAY,"99-99-9999") + "_" + STRING(TIME) + ".csv".
END.    

RUN piImprimeRelat.

disp tt-param.cod-estabel-ini
     tt-param.cod-estabel-fim
     tt-param.cod-local-ini
     tt-param.cod-local-fim
     tt-param.item-ini
     tt-param.item-fim 
     c-arquivo-item
     c-destino           
     tt-param.arquivo    
     tt-param.usuario 
     tt-param.lg-vencidos    
     with frame f-impressao.   

run pi-finalizar in h-acomp.
{include/i-rpclo.i}

IF tt-param.destino = 3 
THEN DO:
    //Se for terminal abre o excel para o usu rio em tela
    OS-COMMAND SILENT(START value(c-arquivo-item)).
END.

RETURN "OK".

/*****************************************************************************************
**
** PROCEDURES INTERNAS
**
*****************************************************************************************/
PROCEDURE piImprimeRelat:
    DEF VAR c-status AS CHAR FORMAT "x(20)" NO-UNDO.

    OUTPUT STREAM s1 TO VALUE(c-arquivo-item) CONVERT TARGET "iso8859-1".

    PUT stream s1 "Estab;Local;Cod Item;Descri‡Æo;Id Endere‡o;Endere‡o;Bloq.Retirada;Dt Trans;Data Atual;Dias Parado;Dias Cadastro;Embalagem;Qtd Item Atual;Status Saldo" SKIP.

    FOR EACH int-wms-item-estab-local WHERE
             int-wms-item-estab-local.cod-estab >= tt-param.cod-estabel-ini AND
             int-wms-item-estab-local.cod-estab <= tt-param.cod-estabel-fim AND
             int-wms-item-estab-local.cod-local >= tt-param.cod-local-ini   AND
             int-wms-item-estab-local.cod-local <= tt-param.cod-local-fim   AND
             int-wms-item-estab-local.cod-item  >= tt-param.item-ini        AND
             int-wms-item-estab-local.cod-item  <= tt-param.item-fim
             NO-LOCK.

        FOR EACH wm-box-saldo
             where wm-box-saldo.cod-estabel       = int-wms-item-estab-local.cod-estab
               and wm-box-saldo.cod-local         = int-wms-item-estab-local.cod-local
               and wm-box-saldo.cod-item          = int-wms-item-estab-local.cod-item
               and wm-box-saldo.cod-refer         = ""
               and wm-box-saldo.qtd-item          > wm-box-saldo.qtd-item-bloq
               and wm-box-saldo.ind-status-saldo  = 3 /* liberado */ no-lock,
             first wm-box
             where wm-box.cod-estabel       = wm-box-saldo.cod-estabel
               and wm-box.cod-local         = wm-box-saldo.cod-local
               and wm-box.id-box            = wm-box-saldo.id-box no-lock,
             first wm-tipo-box /* normal */ where 
                   (wm-tipo-box.ind-status-box  = 1 or
                    wm-tipo-box.ind-status-box  = 2) and 
                    wm-tipo-box.cdn-tipo-box    = wm-box.cdn-tipo-box no-lock,                    
             FIRST wm-item-embalagem-local
             WHERE wm-item-embalagem-local.cod-estabel   = wm-box-saldo.cod-estabel
               AND wm-item-embalagem-local.cod-local     = wm-box-saldo.cod-local 
               AND wm-item-embalagem-local.cod-item      = wm-box-saldo.cod-item
               AND wm-item-embalagem-local.cod-embalagem = wm-box-saldo.cod-embalagem NO-LOCK
                 by wm-box-saldo.dt-transacao    
                 by wm-box-saldo.cod-cliente
                 by wm-box-saldo.cod-estabel
                 by wm-box-saldo.cod-local
                 by wm-box-saldo.cod-item
                 by wm-box-saldo.cod-refer
                 by wm-box-saldo.cod-lote
                 by wm-box-saldo.ind-status-saldo
                 by wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq
                 by wm-box.cod-bloco            
                 by wm-box.cod-rua              
                 by wm-box.cod-coluna           
                 by wm-box.cod-nivel   
                 BY wm-item-embalagem-local.qtd-volume.

            run pi-acompanhar in h-acomp (input 'Est: '    + STRING(wm-box-saldo.cod-estabel) 
                                              + ' Local: ' + STRING(wm-box-saldo.cod-local)
                                              + ' Item: '  + STRING(wm-box-saldo.cod-item)).

            IF tt-param.lg-vencidos = YES THEN DO:
               IF int-wms-item-estab-local.log-cont-dt-entr = NO THEN NEXT.
               IF wm-box-saldo.dt-transacao >= DATE(TODAY - int-wms-item-estab-local.dias-vld-est) THEN NEXT.
            END.
               
            FIND FIRST ITEM WHERE
                       ITEM.it-codigo = int-wms-item-estab-local.cod-item
                       NO-LOCK NO-ERROR.

            PUT stream s1 
                wm-box-saldo.cod-estabel ";" //Estab
                wm-box-saldo.cod-local   ";" //Local
                wm-box-saldo.cod-item ";" //Cod Item
                IF AVAIL ITEM THEN string(item.desc-item,"x(50)") ELSE "" FORMAT "x(50)" ";" //Descri‡Æo
                wm-box-saldo.id-box ";" //Id Endere‡o
                string(fnEnderecoBox(wm-box-saldo.cod-estabel, wm-box-saldo.cod-local, wm-box-saldo.id-box),"x(50)") FORMAT "x(20)" ";" //Endere‡o
                IF wm-box.log-bloq-retir THEN "Sim" ELSE "NÆo" ";" // Bloq.Retirada
                wm-box-saldo.dt-transacao ";" //Dt Trans
                TODAY ";"                     // Data Atual
                TODAY - wm-box-saldo.dt-transacao ";" // Dias Parado
                int-wms-item-estab-local.dias-vld-est ";" //Dias Cadastro
                wm-box-saldo.cod-embalagem ";" //Embalagem
                wm-box-saldo.qtd-item ";" //Qtd Item Atual
               // wm-box-saldo.qtd-item-alocad ";" //Qtd Alocada
               // wm-box-saldo.qtd-item-liberado ";" //Atd Item Liberada
                {scinc/i01sc035.i 04 wm-box-saldo.ind-status-saldo} ";" //Status Saldo
                SKIP.
        END.        
    END.

    OUTPUT STREAM s1 CLOSE.

END PROCEDURE.


