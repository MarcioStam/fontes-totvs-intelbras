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
DEF VAR h-frame   AS HANDLE          NO-UNDO.
DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.
DEFINE VARIABLE c-mensagem AS CHARACTER   NO-UNDO.

/* Minhas variaveis */
def var c-cod-estabel like estabelec.cod-estabel no-undo.
def var l-tipo    as log      no-undo.
def var l-perm    as logical  no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-estabel-ce0205-upc AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cod-unid-negoc-ce0205-upc AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-sc-codigo-ce0205-upc AS WIDGET-HANDLE NO-UNDO.



assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").



IF  p-ind-event  = "initialize" AND 
    p-ind-object = "VIEWER"   THEN DO:

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "c-cod-estabel-movto",
                     OUTPUT wh-cod-estabel-ce0205-upc).

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "c-ccusto",
                     OUTPUT wh-sc-codigo-ce0205-upc).

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "cod-unid-negoc",
                     OUTPUT wh-cod-unid-negoc-ce0205-upc).

END.


IF  p-ind-event  = "VALIDATE" AND 
    p-ind-object = "VIEWER"   THEN DO:

   ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
   ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */      

   DO WHILE h-frame <> ?:
      IF h-frame:TYPE <> "field-group" THEN DO:
         CASE h-frame:NAME:
             when "c-cod-estabel-movto" then do:
                 assign c-cod-estabel = h-frame:SCREEN-VALUE.
             end.
             when "cod-depos" then do:
                 if c-cod-estabel = "101" or
                    c-cod-estabel = "102" then do:
                     if program-name(2) matches "*v11in218*" then /* viewer do ce0205a.w */
                        assign l-tipo = yes.                        
                     else assign l-tipo = no.
                     
                     run esp/es0590a.r (input "ce0205",
                                        INPUT h-frame:SCREEN-VALUE,
                                        INPUT l-tipo, /* yes=entrada, no=saida */
                                        INPUT c-seg-usuario,
                                        OUTPUT l-perm).
                                       
                     IF NOT l-perm THEN DO:
                         RETURN "NOK".                  
                     END.                  
                 end.
             end.
         END CASE.         
         ASSIGN h-frame = h-frame:NEXT-SIBLING.
      END.
      ELSE DO:
          ASSIGN h-frame = h-frame:FIRST-CHILD.
      END.
   END.


    /**/


    IF wh-sc-codigo-ce0205-upc:SCREEN-VALUE <> "" THEN DO:
    
        FOR FIRST cc_uni_estab NO-LOCK
            WHERE cc_uni_estab.cod_estab  = wh-cod-estabel-ce0205-upc:SCREEN-VALUE
            AND   cc_uni_estab.cod_ccusto = wh-sc-codigo-ce0205-upc:SCREEN-VALUE:
        
            if wh-cod-unid-negoc-ce0205-upc:SCREEN-VALUE <> cc_uni_estab.cod_unid_negoc THEN DO:
        
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Unidade de Neg¢cio inv†lida para CC: " + wh-sc-codigo-ce0205-upc:SCREEN-VALUE + " - Estab: " + wh-cod-estabel-ce0205-upc:SCREEN-VALUE + ". Informe a Unidade do CC: " + cc_uni_estab.cod_unid_negoc + ". ~~ Para este Centro de Custo, utilizar unidade " + cc_uni_estab.cod_unid_negoc + ", conforme Planilha de Centros de Custo dispon°vel na INTRANET.").
        
                RETURN "NOK":U.
        
            END.
        
        END.
        
        IF NOT AVAIL cc_uni_estab THEN DO:
        
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "CC: " + wh-sc-codigo-ce0205-upc:SCREEN-VALUE + " - Estab: " + wh-cod-estabel-ce0205-upc:SCREEN-VALUE + " n∆o possui Unidade de Neg¢cio relacionada (ESFGL001). Solicitar o cadastro Ö Controladoria.").
        
            RETURN "NOK":U.
        
        END.

    END.

END.


IF  p-ind-event  = "ASSIGN" AND 
    p-ind-object = "VIEWER"   THEN DO:

    FIND FIRST movto-estoq NO-LOCK
         WHERE ROWID(movto-estoq) = p-row-table NO-ERROR.
    IF AVAIL movto-estoq THEN DO:
        FIND FIRST usuar_mestre NO-LOCK
             WHERE usuar_mestre.cod_usuario = movto-estoq.usuario NO-ERROR.
        FIND FIRST ITEM NO-LOCK
             WHERE ITEM.it-codigo = movto-estoq.it-codigo NO-ERROR.

        ASSIGN c-mensagem = "Ol†," + "~n" +
                            "O usu†rio " + movto-estoq.usuario + "-" + (IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "") + " fez uma requisiá∆o de material para: " + "~n" +
                            "Estabelecimento: " + movto-estoq.cod-estabel    + "~n" +
                            "Dep¢sito: "        + movto-estoq.cod-depos      + "~n" +
                            "Item: "            + movto-estoq.it-codigo + "-" + (IF AVAIL ITEM THEN ITEM.desc-item ELSE "") + "~n" +
                            "Quantidade: "      + TRIM(STRING(movto-estoq.quantidade,">>>,>>>,>>9.99999")) + "~n" +
                            "Localizaá∆o: "     + movto-estoq.cod-localiz    + "~n" +
                            "Documento: "       + movto-estoq.nro-docto      + "~n" +
                            "Data: "            + STRING(movto-estoq.dt-trans,"99/99/9999") + "~n" +
                            "Hora: "            + movto-estoq.hr-trans       + "~n" +
                            "Conta: "           + movto-estoq.ct-codigo      + "~n" +
                            "Centro Custo: "    + movto-estoq.sc-codigo      + "~n".

       IF movto-estoq.cod-estabel = "101" AND movto-estoq.ct-codigo BEGINS "4" THEN DO:
           FIND FIRST int-centro-custo NO-LOCK
                WHERE int-centro-custo.cod-estabel = movto-estoq.cod-estabel
                  AND int-centro-custo.cc-codigo   = movto-estoq.sc-codigo 
                  AND int-centro-custo.cod-unid-negoc = movto-estoq.cod-unid-negoc NO-ERROR.
           IF AVAIL int-centro-custo THEN DO:
               FIND FIRST usuar_mestre NO-LOCK
                    WHERE usuar_mestre.cod_usuario = int-centro-custo.cod_usuario NO-ERROR.
               IF NOT AVAIL usuar_mestre OR usuar_mestre.cod_e_mail_local = "" THEN DO:
                   RUN enviaMail (INPUT "ems@intelbras.com.br",
                                  INPUT "grupo.contabil@intelbras.com.br;grupo.custos@intelbras.com.br",
                                  INPUT "CE0205-Requisiá∆o Materiais",
                                  INPUT "O usu†rio " + movto-estoq.usuario + "-" + (IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "") + " est† tentando fazer requisiá∆o de material e n∆o existe e-mail cadastrado para usu†rio de matr°cula: " + STRING(int-centro-custo.cod_usuario) + " sendo que est† cadastrado como supervisor do Centro de custo " + movto-estoq.sc-codigo + ". Favor verificar!", 
                                  INPUT "").
                   MESSAGE "N∆o Ç poss°vel fazer requisiá∆o, n∆o existe e-mail cadastrado para usu†rio de matr°cula: " + STRING(int-centro-custo.cod_usuario) + " sendo que est† cadastrado como supervisor do Centro de custo " + movto-estoq.sc-codigo + ". Favor entrar em contato com Setor Controladoria!"
                       VIEW-AS ALERT-BOX INFO BUTTONS OK.
                   RETURN "NOK".
               END.
               ELSE DO:
                   RUN enviaMail (INPUT "ems@intelbras.com.br",
                                  INPUT usuar_mestre.cod_e_mail_local,
                                  INPUT "CE0205-Requisiá∆o Materiais",
                                  INPUT c-mensagem,
                                  INPUT "").
               END.
           END.
           ELSE DO:
               RUN enviaMail (INPUT "ems@intelbras.com.br",
                              INPUT "grupo.contabil@intelbras.com.br;grupo.custos@intelbras.com.br",
                              INPUT "CE0205-Requisiá∆o Materiais",
                              INPUT "O usu†rio " + movto-estoq.usuario + "-" + (IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "") + " est† tentando fazer requisiá∆o de material e n∆o existe supervisor cadastrado para Centro de custo " + movto-estoq.sc-codigo + ". Favor verificar!",
                              INPUT "").
               MESSAGE "N∆o Ç poss°vel fazer requisiá∆o, n∆o existe supervisor cadastrado para Centro de custo " + movto-estoq.sc-codigo + ". Favor entrar em contato com a †rea cont†bil atravÇs do e-mail grupo.contabil@intelbras.com.br"
                   VIEW-AS ALERT-BOX INFO BUTTONS OK.
               RETURN "NOK".
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

                  
