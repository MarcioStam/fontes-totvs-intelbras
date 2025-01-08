/***********************************************************************
**  Programa..: 
**  Autor.....: 
**  Data......: 
**  Descricao.: 
**  Vers∆o....: 
**                  Desenvolvimento Programa
************************************************************************/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

{utp/ut-glob.i}
{upc/btb910za-upc.i}
{esp/eslib.i}

/* Definiá∆o da temp-table "tt-prog-ponto" */
{esp/es0018.i}

/*
MESSAGE "p-ind-event : " p-ind-event   SKIP
        "p-ind-object: " p-ind-object  SKIP
        "p-wgh-object: " p-wgh-object  SKIP
        "p-cod-table : " p-cod-table   SKIP
        "p-wgh-frame : " p-wgh-frame   SKIP
        "p-row-table : " STRING(p-row-table)
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/
           
DEF VAR c-objeto  AS CHAR            NO-UNDO.
DEF VAR l-ok      AS LOGICAL         NO-UNDO.
DEF VAR h-frame   AS HANDLE          NO-UNDO.
DEF VAR h-frame-1 AS HANDLE          NO-UNDO.
DEF VAR cReturn   AS CHAR            NO-UNDO.
DEF VAR h-buffer  AS HANDLE          NO-UNDO.
DEF VAR ponteiro  AS WIDGET-HANDLE   NO-UNDO.
DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.
DEF VAR c-programa AS CHAR NO-UNDO.
DEF VAR c-ct-codigo       LIKE conta-contab.ct-codigo.
DEF VAR c-sc-codigo       LIKE conta-contab.sc-codigo.
DEF VAR c-it-codigo       LIKE ITEM.it-codigo.
DEF VAR i-nr-requisicao LIKE it-requisicao.nr-requisicao.
DEFINE VARIABLE c-mensagem AS CHARACTER   NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-nr-requisicao-cd1406a1-upc AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-unid-negoc-cd1406a1-upc AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-sc-codigo-cd1406a1-upc AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-ct-codigo-cd1406a1-upc AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-it-codigo-cd1406a1-upc AS WIDGET-HANDLE NO-UNDO.

DEFINE BUFFER b-it-requis   FOR it-requisicao.
DEFINE BUFFER b-int-item-cc FOR int-item-cc.

IF p-wgh-object <> ? THEN DO:
    ASSIGN c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"),
                            p-wgh-object:file-name,"~/").
END.

IF  p-ind-event  = "initialize" AND 
    p-ind-object = "VIEWER"   THEN DO:

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "nr-requisicao",
                     OUTPUT wh-nr-requisicao-cd1406a1-upc).

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "sc-codigo",
                     OUTPUT wh-sc-codigo-cd1406a1-upc).

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "ct-codigo",
                     OUTPUT wh-ct-codigo-cd1406a1-upc).

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "c-cod-unid-negoc",
                     OUTPUT wh-cod-unid-negoc-cd1406a1-upc).

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "it-codigo",
                     OUTPUT wh-it-codigo-cd1406a1-upc).

END.

IF p-ind-event  = "leave-it-codigo" AND
   p-ind-object = "it-codigo" 
THEN DO:
    FIND FIRST requisicao NO-LOCK
         WHERE requisicao.nr-requisicao = INT(wh-nr-requisicao-cd1406a1-upc:SCREEN-VALUE) NO-ERROR.
    IF AVAIL requisicao
         AND requisicao.tp-requis = 1 /* Tipo Requisiá∆o = Estoque */
    THEN DO:
       RUN esp/es0018p.p (INPUT "CD1406A1":U,
                          INPUT 1,
                          INPUT 0,
                          INPUT "":U,
                          OUTPUT TABLE tt-prog-ponto).

       IF CAN-FIND(FIRST tt-prog-ponto
                   WHERE tt-prog-ponto.conteudo = requisicao.cod-estabel)
       THEN ASSIGN wh-ct-codigo-cd1406a1-upc:SCREEN-VALUE = ""
                   wh-sc-codigo-cd1406a1-upc:SCREEN-VALUE = "".
    END.
END.

IF  p-ind-event  = "AFTER-VALIDATE" AND 
    p-ind-object = "VIEWER"   THEN DO:

    ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
    ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */      

    DO WHILE h-frame <> ?:
       IF h-frame:TYPE <> "field-group" THEN DO:
          CASE h-frame:NAME:
              WHEN "sc-codigo" THEN DO:
                    ASSIGN c-sc-codigo = h-frame:SCREEN-VALUE.
              end.
              WHEN "ct-codigo" THEN DO:
                    ASSIGN c-ct-codigo = h-frame:SCREEN-VALUE.
              end.
              WHEN "nr-requisicao" THEN DO:
                    ASSIGN i-nr-requisicao = INT(h-frame:SCREEN-VALUE).
              end.
              WHEN "it-codigo" THEN DO:
                    ASSIGN c-it-codigo = h-frame:SCREEN-VALUE.
              end.
          END CASE.         
          ASSIGN h-frame = h-frame:NEXT-SIBLING.
       END.
       ELSE DO:
           ASSIGN h-frame = h-frame:FIRST-CHILD.
       END.
    END.

    FIND FIRST requisicao NO-LOCK
         WHERE requisicao.nr-requisicao = i-nr-requisicao NO-ERROR.

    IF AVAIL requisicao THEN DO:

        FIND FIRST usuar_mestre NO-LOCK
             WHERE usuar_mestre.cod_usuario = requisicao.nome-abrev NO-ERROR.

        IF requisicao.cod-estabel = "101" AND c-ct-codigo BEGINS "4" THEN DO:

            FIND FIRST int-centro-custo NO-LOCK
                WHERE int-centro-custo.cod-estabel = requisicao.cod-estabel
                AND int-centro-custo.cc-codigo   = c-sc-codigo NO-ERROR.

            IF AVAIL int-centro-custo THEN DO:

                FIND FIRST usuar_mestre NO-LOCK
                    WHERE usuar_mestre.cod_usuario = int-centro-custo.cod_usuario NO-ERROR.

                IF NOT AVAIL usuar_mestre OR usuar_mestre.cod_e_mail_local = "" THEN DO:
                    
                    RUN enviaMail (INPUT "ems@intelbras.com.br",
                                   INPUT "grupo.contabil@intelbras.com.br;grupo.custos@intelbras.com.br",
                                   INPUT "CD1406-Requisiá∆o/Solicitaá∆o Compras",
                                   INPUT "O usu†rio " + requisicao.nome-abrev + "-" + (IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "") + " est† tentando fazer requisiá∆o de material e n∆o existe e-mail cadastrado para usu†rio de matr°cula: " + STRING(int-centro-custo.cod_usuario) + " sendo que est† cadastrado como supervisor do Centro de custo " + c-sc-codigo + ". Favor verificar!", 
                                   INPUT "").
                    MESSAGE "N∆o Ç poss°vel fazer requisiá∆o, n∆o existe e-mail cadastrado para usu†rio de matr°cula: " + STRING(int-centro-custo.cod_usuario) + " sendo que est† cadastrado como supervisor do Centro de custo " + c-sc-codigo + ". Favor entrar em contato com Setor Controladoria!"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.

                    RETURN "NOK".

                END.

            END.
            ELSE DO:
                RUN enviaMail (INPUT "ems@intelbras.com.br",
                               INPUT "grupo.contabil@intelbras.com.br;grupo.custos@intelbras.com.br",
                               INPUT "CD1406-Requisiá∆o/Solicitaá∆o Compras",
                               INPUT "O usu†rio " + requisicao.nome-abrev + "-" + (IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "") + " est† tentando fazer requisiá∆o de material e n∆o existe supervisor cadastrado para Centro de custo " + c-sc-codigo + ". Favor verificar!",
                               INPUT "").

                MESSAGE "N∆o Ç poss°vel fazer requisiá∆o, n∆o existe supervisor cadastrado para Centro de custo " + c-sc-codigo + ". Favor entrar em contato com a †rea cont†bil atravÇs do e-mail grupo.contabil@intelbras.com.br"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.

                RETURN "NOK".

            END.

        END.

        /**/

        IF wh-sc-codigo-cd1406a1-upc:SCREEN-VALUE <> "" THEN DO:

            FOR FIRST b-it-requis NO-LOCK
                WHERE ROWID(b-it-requis) = p-row-table:
    
                FOR FIRST requisicao NO-LOCK
                    WHERE requisicao.nr-requisicao = int(wh-nr-requisicao-cd1406a1-upc:SCREEN-VALUE):
    
                    FOR FIRST cc_uni_estab NO-LOCK
                        WHERE cc_uni_estab.cod_estab  = requisicao.cod-estabel
                        AND   cc_uni_estab.cod_ccusto = wh-sc-codigo-cd1406a1-upc:SCREEN-VALUE:
    
                        if wh-cod-unid-negoc-cd1406a1-upc:SCREEN-VALUE <> cc_uni_estab.cod_unid_negoc THEN DO:
    
                            RUN utp/ut-msgs.p (INPUT "show",
                                               INPUT 17006,
                                               INPUT "Unidade de Neg¢cio inv†lida para CC: " + wh-sc-codigo-cd1406a1-upc:SCREEN-VALUE + " - Estab: " + requisicao.cod-estabel + ". Informe a Unidade do CC: " + cc_uni_estab.cod_unid_negoc + ". ~~ Para este Centro de Custo, utilizar unidade " + cc_uni_estab.cod_unid_negoc + ", conforme Planilha de Centros de Custo dispon°vel na INTRANET.").
    
                            RETURN "NOK":U.
    
                        END.
    
                    END.
    
                    IF NOT AVAIL cc_uni_estab THEN DO:
    
                        RUN utp/ut-msgs.p (INPUT "show",
                                           INPUT 17006,
                                           INPUT "CC: " + wh-sc-codigo-cd1406a1-upc:SCREEN-VALUE + " - Estab: " + requisicao.cod-estabel + " n∆o possui Unidade de Neg¢cio relacionada (ESFGL001). Solicitar o cadastro Ö Controladoria.").
    
                        RETURN "NOK":U.
    
                    END.
    
                END.
    
            END.

        END.
        /**/

        FIND FIRST int-item-bloq-requis WHERE
                   int-item-bloq-requis.cod-estabel = requisicao.cod-estabel AND
                   int-item-bloq-requis.it-codigo   = wh-it-codigo-cd1406a1-upc:SCREEN-VALUE
                   NO-LOCK NO-ERROR.

        IF AVAIL int-item-bloq-requis 
        THEN DO:
            FIND FIRST int-bloq-requis WHERE
                       int-bloq-requis.codigo      = int-item-bloq-requis.codigo      AND
                       int-bloq-requis.cod-estabel = int-item-bloq-requis.cod-estabel AND
                       int-bloq-requis.ativo       = YES
                       NO-LOCK NO-ERROR.

            IF AVAIL int-bloq-requis 
            THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Item: " + wh-it-codigo-cd1406a1-upc:SCREEN-VALUE + " com bloqueio de requisiá∆o"
                                         + "~~" +
                                         STRING(int-bloq-requis.aviso)).
               
                RETURN "NOK":U.
            END.
        END.

    END. /* Requisiá∆o */

    FIND FIRST int-item-cc WHERE
               int-item-cc.it-codigo = wh-it-codigo-cd1406a1-upc:SCREEN-VALUE 
          // AND int-item-cc.cc-codigo = wh-sc-codigo-cd1406a1-upc:SCREEN-VALUE
               NO-LOCK NO-ERROR.

    IF AVAIL int-item-cc 
    THEN DO:
        FIND FIRST b-int-item-cc WHERE
                   b-int-item-cc.it-codigo = wh-it-codigo-cd1406a1-upc:SCREEN-VALUE 
               AND b-int-item-cc.cc-codigo = wh-sc-codigo-cd1406a1-upc:SCREEN-VALUE
                   NO-LOCK NO-ERROR.

        IF NOT AVAIL b-int-item-cc 
        THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "Item: " + wh-it-codigo-cd1406a1-upc:SCREEN-VALUE + " tem restriá∆o por Centro de Custo"
                                     + "~~" +
                                     "Item: " + wh-it-codigo-cd1406a1-upc:SCREEN-VALUE + " tem restriá∆o de Centro de Custo por Item (ESCDP086). Solicitar o cadastro do CC " + wh-sc-codigo-cd1406a1-upc:SCREEN-VALUE + " ao Almoxarifado.").

            RETURN "NOK":U.
        END.
    END.

END.


IF  p-ind-event  = "after-end-update" AND 
    p-ind-object = "VIEWER"   THEN DO:

    FIND FIRST it-requisicao NO-LOCK
         WHERE ROWID(it-requisicao) = p-row-table NO-ERROR.
    IF AVAIL it-requisicao THEN DO:
        FIND FIRST usuar_mestre NO-LOCK
             WHERE usuar_mestre.cod_usuario = it-requisicao.nome-abrev NO-ERROR.
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = it-requisicao.it-codigo NO-ERROR.

        IF it-requisicao.nr-requisicao = 1 THEN NEXT.

        ASSIGN c-mensagem = "Ol†," + "~n" +
                            "O usu†rio " + it-requisicao.nome-abrev + "-" + (IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "") + " fez uma requisiá∆o de material para: " + "~n" +
                            "Requisiá∆o: "      + string(it-requisicao.nr-requisicao)  + "~n" +
                            "Sequencia: "       + string(it-requisicao.sequencia) + "~n" +
                            "Item: "            + it-requisicao.it-codigo + "-" + (IF AVAIL ITEM THEN ITEM.desc-item ELSE "") + "~n" +
                            "Quantidade: "      + TRIM(STRING(it-requisicao.qt-requisitada,">>>,>>>,>>9.99999")) + "~n" +
                            "Data Entrega: "    + STRING(it-requisicao.dt-entrega,"99/99/9999") + "~n" +
                            "Conta: "           + it-requisicao.ct-codigo      + "~n" +
                            "Centro Custo: "    + it-requisicao.sc-codigo      + "~n" +
                            "Narrativa: "       + it-requisicao.narrativa      + "~n".

       IF it-requisicao.cod-estabel = "101" AND it-requisicao.ct-codigo BEGINS "4" THEN DO:
           FIND FIRST int-centro-custo NO-LOCK
                WHERE int-centro-custo.cod-estabel = it-requisicao.cod-estabel
                  AND int-centro-custo.cc-codigo   = it-requisicao.sc-codigo NO-ERROR.
           IF AVAIL int-centro-custo THEN DO:
               
               FIND FIRST usuar_mestre NO-LOCK
                    WHERE usuar_mestre.cod_usuario = int-centro-custo.cod_usuario NO-ERROR.
               IF AVAIL usuar_mestre AND usuar_mestre.cod_e_mail_local <> "" THEN DO:
                   RUN enviaMail (INPUT "ems@intelbras.com.br",
                                  INPUT usuar_mestre.cod_e_mail_local,
                                  INPUT "CD1406-Requisiá∆o/Solicitaá∆o Compras",
                                  INPUT c-mensagem,
                                  INPUT "").
               END.
           END.
       END.
    END.
END.




PROCEDURE busca-handle:

    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.

    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame.

    /* field-group */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    /* Primeiro componente da Frame */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:
        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.
            IF NOT VALID-HANDLE(h-aux) THEN DO:
                ASSIGN p-handl-obj = ?.
                LEAVE.
            END.
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.
    END.
END.




PROCEDURE busca-folder:

    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.


    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame.

    /* field-group */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    /* Primeiro componente da Frame */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:

        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.
            IF NOT VALID-HANDLE(h-aux) THEN DO:
                ASSIGN p-handl-obj = ?.
                LEAVE.
            END.
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.

    END.

END.

