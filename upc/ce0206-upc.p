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
&scope program ce0206-upc

{utp/ut-glob.i}
{esp/es0018.i}
{upc/btb910za-upc.i}
{esp/eslib.i}

/*MESSAGE p-ind-event 
        p-ind-object 
        p-wgh-object 
        p-cod-table 
        p-wgh-frame
        VIEW-AS ALERT-BOX INFO BUTTONS OK.*/

DEF VAR c-objeto  AS CHAR            NO-UNDO.
DEF VAR l-ok      AS LOGICAL         NO-UNDO.
DEF VAR h-frame   AS HANDLE          NO-UNDO.
DEF VAR h-frame-1 AS HANDLE          NO-UNDO.
DEF VAR cReturn   AS CHAR            NO-UNDO.
DEF VAR h-buffer  AS HANDLE          NO-UNDO.
DEF VAR ponteiro  AS WIDGET-HANDLE   NO-UNDO.
def var l-perm    as logical         no-undo.
def var c-cod-estabel like estabelec.cod-estabel no-undo.

DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.

DEF VAR c-programa AS CHAR NO-UNDO.

DEFINE BUFFER b-movto-estoq FOR movto-estoq.

DEF NEW GLOBAL SHARED VAR tx-observacao-ce0206      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-observacao-ce0206      AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE c-cod-estab  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-depos  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-email-dest AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-mensagem   AS CHARACTER   NO-UNDO.

/*
MESSAGE "p-ind-event : " p-ind-event   SKIP
        "p-ind-object: " p-ind-object  SKIP
        "p-wgh-object: " p-wgh-object  SKIP
        "p-cod-table : " p-cod-table   SKIP
        "p-wgh-frame : " p-wgh-frame   SKIP
        "p-row-table : " STRING(p-row-table)
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/

assign c-objeto = entry(num-entries(p-wgh-object:file-name,"~/"), 
                        p-wgh-object:file-name,"~/").

IF p-ind-event  = "VALIDATE" AND 
   p-ind-object = "VIEWER"   THEN DO:
    
   ASSIGN h-frame = p-wgh-frame:FIRST-CHILD. /* pegando o Field-Group */
   ASSIGN h-frame = h-frame:FIRST-CHILD.     /* pegando o 1o. Campo */
    
   DO WHILE h-frame <> ?:
      IF h-frame:TYPE <> "field-group" THEN DO: 
         CASE h-frame:NAME:
              when "cod-estabel" then do:
                  assign c-cod-estabel = h-frame:SCREEN-VALUE.              
              end.
              WHEN "c-cod-depos-ent" THEN DO:
                  
                  run esp/es0590a.r (input "ce0206",
                                     INPUT h-frame:SCREEN-VALUE,
                                     INPUT yes, /* entrada */
                                     INPUT c-seg-usuario,
                                     OUTPUT l-perm).
                                   
                  IF NOT l-perm THEN DO:
                      RETURN "NOK".                  
                  END.                  
                  
                  
                  IF h-frame:SCREEN-VALUE = "rej" THEN DO:
                        RUN esp/es0018p.p (INPUT "{&Program}", /* Nome do programa */
                                         INPUT 1,            /* Ponto do programa */
                                         INPUT 0,
                                         INPUT "",
                                         OUTPUT TABLE tt-prog-ponto).   
 
                        find first tt-prog-ponto
                            where tt-prog-ponto.nome-programa = "{&Program}"
                            and   tt-prog-ponto.ponto         = 1 
                            and   tt-prog-ponto.conteudo      = c-seg-usuario no-error.
                        
                        if not avail tt-prog-ponto then do:
                            MESSAGE "Usu†rio sem permiss∆o para incluir item(s) neste dep¢sito!"
                                 VIEW-AS ALERT-BOX INFO BUTTONS OK.
                            RETURN "NOK".
                            
                        end.
                                         
                  END.
              END.
              WHEN "cod-depos" THEN DO:
                  
                  run esp/es0590a.r (input "ce0206",
                                     INPUT h-frame:SCREEN-VALUE,
                                     INPUT no, /* saida */
                                     INPUT c-seg-usuario,
                                     OUTPUT l-perm).
                                       
                  IF NOT l-perm THEN DO:
                      RETURN "NOK".                  
                  END.
                  
                  IF h-frame:SCREEN-VALUE = "rej" THEN DO:
                     RUN esp/es0018p.p (INPUT "{&Program}", /* Nome do programa */
                                         INPUT 1,            /* Ponto do programa */
                                         INPUT 0,
                                         INPUT "",
                                         OUTPUT TABLE tt-prog-ponto).   
 
                     find first tt-prog-ponto
                         where tt-prog-ponto.nome-programa = "{&Program}"
                         and   tt-prog-ponto.ponto         = 1 
                         and   tt-prog-ponto.conteudo      = c-seg-usuario no-error.
                        
                     if not avail tt-prog-ponto then do:
                         MESSAGE "Usu†rio sem permiss∆o para incluir item(s) neste dep¢sito!"
                              VIEW-AS ALERT-BOX INFO BUTTONS OK.
                         RETURN "NOK".
                         
                     end.
                  END.
              END.

         END CASE.         
         ASSIGN h-frame = h-frame:NEXT-SIBLING.
      END.
      ELSE DO:
         ASSIGN h-frame = h-frame:FIRST-CHILD.
      END.
   END.
END.

IF p-ind-event  = "INITIALIZE" AND 
   p-ind-object = "CONTAINER"  THEN DO:

   /* Cria campo e texto para centro de custo */
   CREATE TEXT tx-observacao-ce0206
   ASSIGN FRAME        = p-wgh-frame
          FORMAT       = "x(5)"
          WIDTH        = 5
          SCREEN-VALUE = "Obs:"
          ROW          = 11.73
          COL          = 40
          VISIBLE      = YES.         
    
   CREATE FILL-IN wh-observacao-ce0206
   ASSIGN FRAME             = p-wgh-frame
          FORMAT            = "x(100)"
          WIDTH             = 45
          HEIGHT            = 0.88
          ROW               = 11.62
          COL               = 43.5
          VISIBLE           = YES
          SENSITIVE         = NO.
END.

IF p-ind-object = "VIEWER"   AND
   p-ind-event = "after-enable" THEN DO:
    ASSIGN wh-observacao-ce0206:SENSITIVE = TRUE. 
END.

IF p-ind-object = "VIEWER"   AND
   p-ind-event = "after-disable" THEN DO:
    ASSIGN wh-observacao-ce0206:SENSITIVE = FALSE.
END.

IF p-ind-object = "VIEWER" AND
   p-ind-event = "display" THEN DO:

    IF VALID-HANDLE(wh-observacao-ce0206) THEN DO:
        ASSIGN wh-observacao-ce0206:SCREEN-VALUE = "".
    END.
END.


IF p-ind-event  = "AFTER-END-UPDATE" AND 
   p-ind-object = "VIEWER"           THEN DO:
    
    FIND FIRST movto-estoq EXCLUSIVE-LOCK
         WHERE ROWID(movto-estoq) = p-row-table NO-ERROR.
    IF AVAIL movto-estoq THEN DO:
        FIND LAST b-movto-estoq EXCLUSIVE-LOCK USE-INDEX esp-data
            WHERE b-movto-estoq.dt-trans      = movto-estoq.dt-trans
              AND b-movto-estoq.esp-docto     = movto-estoq.esp-docto    
              AND b-movto-estoq.it-codigo     = movto-estoq.it-codigo    
              AND b-movto-estoq.tipo-trans    = 1
              AND b-movto-estoq.cod-estabel   = movto-estoq.cod-estabel
              AND b-movto-estoq.serie-docto   = movto-estoq.serie-docto
              AND b-movto-estoq.nro-docto     = movto-estoq.nro-docto
              AND b-movto-estoq.cod-prog-orig = movto-estoq.cod-prog-orig
              AND b-movto-estoq.quantidade    = movto-estoq.quantidade
              AND b-movto-estoq.usuario       = movto-estoq.usuario 
              AND b-movto-estoq.nr-trans      < movto-estoq.nr-trans NO-ERROR.
        IF AVAIL b-movto-estoq THEN DO:
            
            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo = b-movto-estoq.it-codigo NO-ERROR.

            RUN esp/es0018p.p (INPUT "{&Program}", /* Nome do programa */
                             INPUT 2,            /* Ponto do programa */
                             INPUT 0,
                             INPUT "",
                             OUTPUT TABLE tt-prog-ponto).   

            FOR EACH tt-prog-ponto
               WHERE tt-prog-ponto.nome-programa = "{&Program}"
                 AND tt-prog-ponto.ponto         = 2:

                /*estab,depos,email*/
                ASSIGN c-cod-estab  = ENTRY(1,tt-prog-ponto.conteudo,",")
                       c-cod-depos  = ENTRY(2,tt-prog-ponto.conteudo,",")
                       c-email-dest = ENTRY(3,tt-prog-ponto.conteudo,",").

                IF b-movto-estoq.cod-estabel = c-cod-estab AND
                   b-movto-estoq.cod-depos   = c-cod-depos AND
                   c-email-dest <> ""  THEN DO:

                    ASSIGN c-mensagem = "Ol†," + "~n" +
                                        "Foi efetuada entrada no dep¢sito: " + b-movto-estoq.cod-depos + "~n" +
                                        "Estabelecimento: " + b-movto-estoq.cod-estabel    + "~n" +
                                        "Item: "            + b-movto-estoq.it-codigo + "-" + (IF AVAIL ITEM THEN ITEM.desc-item ELSE "") + "~n" +
                                        "Quantidade: "      + TRIM(STRING(b-movto-estoq.quantidade,">>>,>>>,>>9.99999")) + "~n" +
                                        "Localizaá∆o: "     + b-movto-estoq.cod-localiz    + "~n" +
                                        "Documento: "       + b-movto-estoq.nro-docto      + "~n" +
                                        "Usu†rio "          + b-movto-estoq.usuario        + "~n" + 
                                        "Data: "            + STRING(b-movto-estoq.dt-trans,"99/99/9999") + "~n" +
                                        "Hora: "            + b-movto-estoq.hr-trans       + "~n".

                    RUN enviaMail (INPUT "ems@intelbras.com.br",
                                   INPUT c-email-dest,
                                   INPUT "CE0206-Transferencia Materiais - Deposito: " + c-cod-depos,
                                   INPUT c-mensagem,
                                   INPUT "").

                END.
            END.
        END.
    END.

END.


IF p-ind-event  = "END-UPDATE" AND 
   p-ind-object = "VIEWER"   THEN DO:

    FIND FIRST movto-estoq EXCLUSIVE-LOCK
         WHERE ROWID(movto-estoq) = p-row-table NO-ERROR.
    IF AVAIL movto-estoq THEN DO:
        ASSIGN movto-estoq.descricao-db = wh-observacao-ce0206:SCREEN-VALUE.
        FIND LAST b-movto-estoq EXCLUSIVE-LOCK USE-INDEX esp-data
            WHERE b-movto-estoq.dt-trans      = movto-estoq.dt-trans
              AND b-movto-estoq.esp-docto     = movto-estoq.esp-docto    
              AND b-movto-estoq.it-codigo     = movto-estoq.it-codigo    
              AND b-movto-estoq.tipo-trans    = 1
              AND b-movto-estoq.cod-estabel   = movto-estoq.cod-estabel
              AND b-movto-estoq.serie-docto   = movto-estoq.serie-docto
              AND b-movto-estoq.nro-docto     = movto-estoq.nro-docto
              AND b-movto-estoq.cod-prog-orig = movto-estoq.cod-prog-orig
              AND b-movto-estoq.quantidade    = movto-estoq.quantidade
              AND b-movto-estoq.usuario       = movto-estoq.usuario 
              AND b-movto-estoq.nr-trans      < movto-estoq.nr-trans NO-ERROR.
        IF AVAIL b-movto-estoq THEN DO:
            ASSIGN b-movto-estoq.descricao-db = wh-observacao-ce0206:SCREEN-VALUE.
        END. 
    END.
END.
