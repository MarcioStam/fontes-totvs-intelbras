{include/i-prgvrs.i ESENP015 2.04.00.001}

/***********************************************************************
**  Programa..: ESP\PDP\ESENP015RP.P
**  Autor.....: Gustavo Eduardo Tamanini
**              Desenvolvimento Programa
************************************************************************/

/****************************  Definitions  ****************************/
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)":U
    field usuario          as char format "x(12)":U
    field data-exec        as date
    field hora-exec        as integer
    field arquivo-csv      as char format "x(60)":U
    .

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

DEFINE TEMP-TABLE tt-importados NO-UNDO
    FIELD it-codigo LIKE estrutura.it-codigo
    INDEX id it-codigo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

define buffer b-tt-digita for tt-digita.

{include/i-rpvar.i}
{esp/es0018.i}

RUN esp/es0018p.p (INPUT "esenp015":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).
/****************************  Temp-Tables  ****************************/

/****************************  Variaveis    ****************************/
DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

DEF VAR h-acomp AS HANDLE NO-UNDO.

FOR FIRST param-global NO-LOCK. END.
FOR FIRST mgcad.empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

ASSIGN c-sistema      = "Espec°ficos Intelbras"
       c-titulo-relat = "Importaá∆o Estrutura"
       c-empresa      = if avail empresa then mgcad.empresa.razao-social else ''
       c-programa     = "ESENP015"
       c-versao       = "2.04"
       c-revisao      = "001".

/* ***************************  Main Block  *************************** */

{include/i-rpcab.i}
{include/i-rpout.i}

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.  
RUN pi-inicializar IN h-acomp (INPUT "Importando..").

RUN pi-importa.

RUN pi-finalizar IN h-acomp.

{include/i-rpclo.i}

RETURN "OK".

/* **********************  Internal Procedures  *********************** */
PROCEDURE pi-importa:
    DEF VAR c-arquivo AS CHAR FORMAT "x(60)" LABEL "Arquivo: " NO-UNDO.
    DEF VAR c-1       LIKE ITEM.it-codigo                      NO-UNDO.
    DEF VAR c-2       LIKE ITEM.it-codigo                      NO-UNDO.
    DEF VAR c-3       AS CHAR                                  NO-UNDO.
    DEF VAR i-seq     LIKE estrutura.sequencia                 NO-UNDO.                

    DEF VAR cArqConv  AS CHAR                                  NO-UNDO.
    DEF VAR l-ok      AS LOGICAL INITIAL NO                    NO-UNDO.
    DEF VAR l-erro    AS LOGICAL                               NO-UNDO.

    DO  ON ERROR UNDO, LEAVE
        ON STOP  UNDO, LEAVE
        TRANSACTION:

        INPUT FROM VALUE(tt-param.arquivo-csv).

        PUT "Item            Estrutura           Valor" SKIP.

        REPEAT:

            IMPORT DELIMITER ";" c-1 c-2 c-3.

            IF c-3 = "0" THEN NEXT.   

            RUN pi-acompanhar IN h-acomp (INPUT c-1 + " - " + c-2 + " - " + c-3).

            ASSIGN l-ok = NO.

            IF NOT CAN-FIND (FIRST tt-prog-ponto
                             WHERE tt-prog-ponto.conteudo = c-1) THEN DO:
                PUT "N∆o Ç permitida a inclus∆o da estrutura deste item." SKIP.
                ASSIGN l-erro = YES.
                STOP.
            END.

            FOR FIRST ITEM WHERE ITEM.it-codigo = c-1 NO-LOCK: END.            
            IF NOT AVAIL ITEM THEN DO:
                PUT "O item (" TRIM(c-1) ") deve ser criado antes de importar sua estrutura." SKIP.
                ASSIGN l-erro = YES.
                STOP.
            END.

            FOR ITEM WHERE ITEM.it-codigo = c-2 NO-LOCK: END.
            
            IF NOT AVAIL ITEM THEN NEXT.

            /*Validaá∆o para n∆o permitir importar itens que j† tenham estrutura*/
            IF  CAN-FIND (FIRST estrutura 
                          WHERE estrutura.it-codigo = c-1) /*Tem estrutura*/
            AND NOT CAN-FIND (FIRST tt-importados
                              WHERE tt-importados.it-codigo = c-1) /*N∆o foi importado agora*/  THEN DO:
                PUT "O item (" TRIM(c-1) ") j† possui estrutura, s¢ Ç poss°vel importar itens para estruturas vazias." SKIP.
                ASSIGN l-erro = YES.
                STOP.
            END.

            /*
            Comentado para atendimento de uma necessidade de usu†ria Karina de S† (em 01/04/2014)
            
            
            FOR FIRST estrutura 
                WHERE estrutura.it-codigo = c-1 
                  AND estrutura.es-codigo = c-2 NO-LOCK:
            END.
            IF AVAIL estrutura THEN DO:
                ASSIGN l-ok = YES.
                NEXT.
            END.
            */
            
            PUT c-1 
                c-2
                DEC(c-3)
                SKIP.

            FOR LAST estrutura
               WHERE estrutura.it-codigo = c-1 NO-LOCK: END.

            IF NOT AVAIL estrutura THEN
                ASSIGN i-seq = 10.
            ELSE
                ASSIGN i-seq = estrutura.sequencia + 10.

            IF c-1 <> "" AND c-2 <> "" THEN DO:

                CREATE estrutura.
                ASSIGN estrutura.it-codigo    = c-1
                       estrutura.es-codigo    = c-2
                       estrutura.qtd-item     = 1
                       estrutura.qtd-compon   = DEC(c-3)
                       estrutura.quant-liquid = DEC(c-3)
                       estrutura.quant-usada  = DEC(c-3)
                       estrutura.sequencia    = i-seq.

                CREATE tt-importados.
                ASSIGN tt-importados.it-codigo = c-1.

                FOR ITEM WHERE ITEM.it-codigo = c-1 EXCLUSIVE-LOCK: END.
                IF AVAIL ITEM THEN
                    ASSIGN ITEM.compr-fabr = 2.
            END.
    
            ASSIGN l-ok = YES.
        END.
    END.
    
    IF l-erro OR NOT l-ok THEN
        PUT "Importaá∆o Cancelada." SKIP.

    IF l-ok THEN
        PUT "Importaá∆o Conclu°da." SKIP.
END.
