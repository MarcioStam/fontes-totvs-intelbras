/***********************************************************************
**  Programa..: ESP\CEP\ESCEP076RP.P
**  Autor.....: Maicon Correa - Sensus
**  Data......: SETEMBRO/2014 - Desenvolvimento
**  Descricao.: 
************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCEP075RP 1.00.00.001}

/****************************  Definitions  ****************************/
{esp/cep/escep075.i}
{include/i-rpvar.i}
{esp/es0018.i}
{utp/ut-glob.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

/****************************  Temp-Tables  ****************************/
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
     create tt-digita.
     raw-transfer tt-raw-digita.raw-digita to tt-digita.
end. 

DEF TEMP-TABLE tt-ordena
    FIELD int-it-codigo      LIKE int-item-uni-estab.it-codigo    
    FIELD ITEM-desc-item     LIKE ITEM.desc-item    
    FIELD int-item-uni-estab LIKE int-item-uni-estab.qtde-embalagem 
    FIELD d-saldo-estoq      AS DECIMAL
    FIELD d-diferenca        AS DECIMAL
    FIELD d-percentual       AS INTEGER. 

DEFINE VARIABLE d-saldo-estoq AS DECIMAL COLUMN-LABEL "Qtd Estoq" NO-UNDO.
DEFINE VARIABLE d-diferenca   AS DECIMAL COLUMN-LABEL "Qtd Enviar" NO-UNDO.
DEFINE VARIABLE d-percentual  AS DECIMAL NO-UNDO.
DEFINE VARIABLE d-calcula     AS DECIMAL NO-UNDO.
DEFINE VARIABLE c-apresenta   AS CHARACTER COLUMN-LABEL "%Estoque" NO-UNDO.
DEFINE NEW SHARED VARIABLE h-acomp AS HANDLE NO-UNDO.
FORM 
    "SALDO"                   AT 01 SKIP(1)                 
    tt-param.cod-estabel       LABEL "Estabelecimento" AT 01
     SKIP(1)
    WITH WIDTH 140 FRAME f-saldo SIDE-LABELS NO-BOX STREAM-IO.

FORM
    "SALDO TERC"                AT 01 SKIP(1)
    tt-param.cod-estab-orig      LABEL "Estab Origem" AT 04
    tt-param.cod-emitente       LABEL "Emiente Destino" AT 01
    WITH WIDTH 140 FRAME f-saldo-terc SIDE-LABELS NO-BOX STREAM-IO.

FORM
    tt-digita.cod-depos     COLUMN-LABEL "Dep¢sito"
    tt-digita.descricao     COLUMN-LABEL "Descri‡Æo "SKIP
    WITH WIDTH 140 FRAME f-digita NO-BOX STREAM-IO DOWN.

FORM
    tt-ordena.int-it-codigo      
    tt-ordena.ITEM-desc-item        FORMAT "X(50)"                                       
    tt-ordena.int-item-uni-estab    FORMAT ">>>,>>9.9999"     COLUMN-LABEL "Kanban Injetora" 
    tt-ordena.d-saldo-estoq         FORMAT ">>>,>>>,>>9.9999" COLUMN-LABEL "Qtd Estoq"                            
    tt-ordena.d-diferenca           FORMAT ">>>,>>9.9999"     COLUMN-LABEL "Qtd Enviar"                           
    tt-ordena.d-percentual          COLUMN-LABEL "%Estoque" SKIP
    WITH WIDTH 160 FRAME teste NO-BOX STREAM-IO DOWN.

/*
form 
    "Dep¢sito: " 
    tt-itens.cod-depos
    "-" 
    tt-itens.nome SKIP
    "Valor...: "
    tt-param.d-total-dep
    WITH WIDTH 100 CENTERED FRAME f-deposito NO-LABELS NO-BOX STREAM-IO.

FORM 
    tt-itens.it-codigo    COLUMN-LABEL "Item"
    tt-itens.descricao    COLUMN-LABEL "Descri‡Æo"
    tt-itens.quantidade   COLUMN-LABEL "Quantidade"
    tt-itens.unit-mat     LABEL "Vl.Unit Mat Mensal"
    tt-itens.unit-mob     LABEL "Vl.Unit Mob Mensal"
    tt-itens.unit-ggf     LABEL "Vl.Unit GGF Mensal"
    tt-itens.valor        COLUMN-LABEL "Valor"
    WITH WIDTH 140 FRAME f-dados STREAM-IO DOWN.
    */

FOR FIRST param-global NO-LOCK,
    FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-prin: END.
FOR FIRST param-estoq NO-LOCK: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Kanban Injetoras"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESCEP075"
       c-versao       = "1.00"
       c-revisao      = "000".

/* ***************************  Main Block  *************************** */
do on stop undo, leave:
    {include/i-rpcab.i}
    {include/i-rpout.i}
            
    FIND FIRST tt-param NO-LOCK NO-ERROR.

    VIEW FRAME f-cabec.
    VIEW FRAME f-rodape.

   run utp/ut-acomp.p persistent set h-acomp.  
   run pi-inicializar in h-acomp (input "Imprimindo...").
   run piImprimeRelat.

   IF tt-param.lemail AND CAN-FIND(FIRST tt-ordena) THEN
        RUN piEnviaEmail.

   RUN pi-finalizar in h-acomp.
   {include/i-rpclo.i}
   RETURN "OK".

end.

/* **********************  Internal Procedures  *********************** */

PROCEDURE piImprimeRelat:

    EMPTY TEMP-TABLE tt-ordena.

    FOR EACH int-item-uni-estab NO-LOCK
        WHERE int-item-uni-estab.cod-estabel = tt-param.cod-estabel
        AND   int-item-uni-estab.qtde-embalagem > 0:
        
        FOR FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = int-item-uni-estab.it-codigo:
        END.
        
        ASSIGN d-saldo-estoq = 0
               d-diferenca   = 0
               d-calcula     = 0
               d-percentual  = 0.

        FOR EACH tt-digita
            BREAK BY tt-digita.cod-depos:
            
            FOR EACH saldo-estoq NO-LOCK
                WHERE saldo-estoq.cod-estabel = int-item-uni-estab.cod-estabel
                AND   saldo-estoq.it-codigo   = int-item-uni-estab.it-codigo
                AND   saldo-estoq.cod-depos = tt-digita.cod-depos:

                ASSIGN  d-saldo-estoq = d-saldo-estoq + saldo-estoq.qtidade-atu.
                
            END.

        END.
        
        /* saldo terc 101 para 104 */
        FOR EACH saldo-terc NO-LOCK
            WHERE saldo-terc.cod-estabel = tt-param.cod-estab-orig
            AND   saldo-terc.it-codigo   = int-item-uni-estab.it-codigo
            AND   saldo-terc.emite-comp  = tt-param.cod-emitente:
        
            ASSIGN d-saldo-estoq = d-saldo-estoq + saldo-terc.quantidade.
        
        END.
        
        IF d-saldo-estoq < int-item-uni-estab.qtde-embalagem /* Kanban */ THEN DO:
            
            ASSIGN d-diferenca  = (d-saldo-estoq - int-item-uni-estab.qtde-embalagem) * (-1)
                   d-calcula = d-saldo-estoq / int-item-uni-estab.qtde-embalagem
                   d-percentual = d-calcula * 100.

            IF tt-param.lemail THEN DO:
                IF d-estoq-min < d-percentual THEN
                    NEXT.
            END.

            CREATE tt-ordena.
            ASSIGN tt-ordena.int-it-codigo       = int-item-uni-estab.it-codigo     
                   tt-ordena.ITEM-desc-item      = ITEM.desc-item                   
                   tt-ordena.int-item-uni-estab  = int-item-uni-estab.qtde-embalagem
                   tt-ordena.d-saldo-estoq       = d-saldo-estoq                    
                   tt-ordena.d-diferenca         = d-diferenca                      
                   tt-ordena.d-percentual        = d-percentual.
        END.
    
    END.

    FOR EACH tt-ordena
        BREAK BY tt-ordena.d-percentual:

        DISP tt-ordena.int-it-codigo     
             tt-ordena.ITEM-desc-item    
             tt-ordena.int-item-uni-estab
             tt-ordena.d-saldo-estoq     
             tt-ordena.d-diferenca       
             tt-ordena.d-percentual
            WITH FRAME teste.
        DOWN WITH FRAME teste.   
        
    END.
    
    PAGE.

    DISP tt-param.cod-estabel         
         WITH FRAME f-saldo.
    
    FOR EACH tt-digita:

        DISP tt-digita.cod-depos
             tt-digita.descricao
            WITH FRAME f-digita.
        DOWN WITH FRAME f-digita.

    END.

    DISP SKIP(3).

    DISP tt-param.cod-estab-orig
         tt-param.cod-emitente
        WITH FRAME f-saldo-terc.
END PROCEDURE.


PROCEDURE piEnviaEmail:
    DEFINE VARIABLE c-destino         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-caminho-arquivo AS CHARACTER FORMAT "X(50)" NO-UNDO.
    DEFINE VARIABLE h-api022 AS HANDLE NO-UNDO.
    
    EMPTY TEMP-TABLE tt-prog-ponto.

    RUN esp/es0018p.p (INPUT "ESCEP075":U,
                       INPUT 1,
                       INPUT 0,
                       INPUT "":U,
                       OUTPUT TABLE tt-prog-ponto).

    FOR EACH tt-prog-ponto:
        IF ENTRY(1,tt-prog-ponto.conteudo) = tt-param.cod-estabel AND
           ENTRY(2,tt-prog-ponto.conteudo) = tt-param.cod-estab-orig THEN
            ASSIGN c-destino = c-destino + (IF c-destino = "" THEN "" ELSE ";") + ENTRY(3,tt-prog-ponto.conteudo).
    END.

    IF OPSYS = "UNIX" THEN
        ASSIGN c-caminho-arquivo = c-dir-arquivo-session + c-seg-usuario
               c-caminho-arquivo = c-caminho-arquivo + "/" + tt-param.arquivo
               c-caminho-arquivo = REPLACE(c-caminho-arquivo, "~\":U, "/":U).
    ELSE
        ASSIGN c-caminho-arquivo = SESSION:TEMP-DIRECTORY + c-programa + ".tmp".

    RUN esapi/esapi022.p PERSISTENT SET h-api022.
    RUN piTrataEmail IN h-api022 (INPUT c-destino,
                                  INPUT "Relat¢rio Kanban Injetoras",
                                  INPUT "ATEN€ÇO!" + '~r~n' +
                                        "Itens cujo percentual ficou abaixo do indicado no campo Estoque M¡nimo(%).",
                                  INPUT c-caminho-arquivo,
                                  INPUT "").

    IF VALID-HANDLE(h-api022) THEN
        DELETE PROCEDURE h-api022.
    
    RETURN "OK".
END PROCEDURE.
