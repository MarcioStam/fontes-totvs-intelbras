/***********************************************************************
**  Programa..: upc\en0105-upc.p
**  Autor.....: Marcio Chaves - Gestech
**  Data......: OUTUBRO/2004 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
************************************************************************/

{utp/ut-glob.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE h-frame                     AS HANDLE        NO-UNDO.
DEFINE VARIABLE adm-current-page            AS INTEGER       NO-UNDO.

DEFINE NEW GLOBAL SHARED VAR vRowEstrutura  AS ROWID         NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wgh-folder     AS WIDGET-HANDLE NO-UNDO.


DEFINE VARIABLE c-folder AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-objeto AS CHARACTER  NO-UNDO.
ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/").

DEF NEW GLOBAL SHARED VAR wh-local-montag AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-montag    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR adm-broker-hdl  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-fator-perda-en0105a AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-proporcao-en0105a   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-qtd-item-en0105a    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-log-quant-fix-en0105a AS WIDGET-HANDLE NO-UNDO.
define new global shared var wh-componente-en0105a    as widget-handle no-undo.
/*efine new global shared var wh-log-quant-fix-en0105a as widget-handle no-undo.*/

DEF VAR p-ativo AS LOGICAL NO-UNDO.
DEF VAR p-itemob AS CHAR NO-UNDO.

def temp-table tt-pos
    field letra    as char format "X(15)"     
    field ord      as dec
    field pos      as char format "x(15)"  
    index tt-pos is primary unique 
          letra 
          ord
    index ordem 
          letra
          pos.

/*
OUTPUT TO 'c:\temp\teste.txt' APPEND.
/*
p-ind-event          p-ind-object    p-cod-table          c-objeto
-------------------- --------------- -------------------- ---------------
*/
DISP p-ind-event          FORMAT 'x(20)'
     p-ind-object         FORMAT 'x(15)'
     p-cod-table          FORMAT 'x(20)'
     c-objeto             FORMAT 'x(15)'
     string(p-row-table)  FORMAT 'x(05)'
     string(p-wgh-object) <> ""
     string(p-wgh-frame)  <> ""
     WITH WIDTH 400 STREAM-IO NO-BOX DOWN NO-LABEL.
*/
/*
MESSAGE 'p-ind-event  ' p-ind-event  SKIP
        'p-ind-object ' p-ind-object SKIP
        'p-cod-table  ' p-cod-table  SKIP
        'p-row-table  ' string(p-row-table) SKIP
        'c-objeto     ' c-objeto
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/

IF  p-ind-object = "VIEWER"     
AND c-objeto     = "v02in111.w" THEN DO:

    /*
    IF p-ind-event  = "add" THEN DO:
        IF VALID-HANDLE(wh-log-quant-fix-en0105a) THEN DO:
            ASSIGN wh-log-quant-fix-en0105a:CHECKED = YES.
            APPLY 'VALUE-CHANGED' TO wh-log-quant-fix-en0105a.

        END.
    END.
    */
    IF p-ind-event  = "INITIALIZE" THEN DO:
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "TOGGLE-BOX",      /*** Type ***/
                      INPUT "log-quant-fix",    /*** Name ***/
                      INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-log-quant-fix-en0105a).

        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "FILL-IN",      /*** Type ***/
                      INPUT "fator-perda",  /*** Name ***/
                      INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-fator-perda-en0105a).

        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "FILL-IN",      /*** Type ***/
                      INPUT "proporcao",    /*** Name ***/
                      INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-proporcao-en0105a).

        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "FILL-IN",      /*** Type ***/
                      INPUT "qtd-item",    /*** Name ***/
                      INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-qtd-item-en0105a).

    END.

    IF  p-ind-event = "AFTER-DISPLAY" AND VALID-HANDLE(wh-log-quant-fix-en0105a) THEN
        ASSIGN wh-log-quant-fix-en0105a:SENSITIVE = NO
               wh-fator-perda-en0105a:SENSITIVE = NO
               wh-proporcao-en0105a:SENSITIVE = NO
               wh-qtd-item-en0105a:SENSITIVE = NO.
    IF  (p-ind-event = "AFTER-ENABLE" OR p-ind-event = "ADD") AND VALID-HANDLE(wh-log-quant-fix-en0105a) THEN
        ASSIGN wh-log-quant-fix-en0105a:SENSITIVE = NO
               wh-fator-perda-en0105a:SENSITIVE = NO
               wh-proporcao-en0105a:SENSITIVE = NO
               wh-qtd-item-en0105a:SENSITIVE = NO
               wh-qtd-item-en0105a:READ-ONLY = YES.

END.

IF p-ind-object = "VIEWER"     AND 
   c-objeto     = "v03in111.w" THEN  /* Aba Complementar */
DO:

    CASE p-ind-event:

        WHEN "ENABLE" THEN DO:
            ASSIGN vRowEstrutura = p-row-table.
        END.

        WHEN "AFTER-ENABLE" THEN DO:

             IF VALID-HANDLE(wh-local-montag) THEN
                ASSIGN wh-local-montag:SENSITIVE = FALSE.

        END.

        WHEN "BEFORE-INITIALIZE" THEN
        DO:
            ASSIGN h-frame = p-wgh-frame:FIRST-CHILD.
            ASSIGN h-frame = h-frame:FIRST-CHILD.
            DO  WHILE VALID-HANDLE(h-frame):
                IF  h-frame:TYPE <> "field-group" THEN DO:
                    CASE h-frame:NAME:
                        WHEN "local-montag" THEN ASSIGN wh-local-montag = h-frame.
                    END.
                    ASSIGN h-frame = h-frame:NEXT-SIBLING.
                END.
                ELSE LEAVE.
            END.
            IF VALID-HANDLE(wh-local-montag) THEN
            DO:
                CREATE BUTTON wh-bt-montag
                ASSIGN FRAME     = wh-local-montag:FRAME
                       WIDTH     = 4
                       HEIGHT    = 1
                       ROW       = 2.17
                       LABEL     = ""
                       COL       = 80
                       SENSITIVE = NO
                       VISIBLE   = NO
                TRIGGERS:
                      ON CHOOSE PERSISTENT RUN esp\enp\esenp001.w.
                END TRIGGERS.
                wh-bt-montag:LOAD-IMAGE-UP('image/im-abc.bmp').
                wh-bt-montag:LOAD-IMAGE-INSENSITIVE('image/ii-abc.bmp').
            END.
        END.
    END CASE.
END.

IF p-ind-object = "CONTAINER"         AND 
   p-ind-event  = "AFTER-CHANGE-PAGE" THEN
DO:
    RUN GET-ATTRIBUTE IN wgh-folder ('Current-Page':U).
    ASSIGN adm-current-page       = INTEGER(RETURN-VALUE) 
           wh-bt-montag:VISIBLE   = adm-current-page = 2 WHEN VALID-HANDLE(wh-bt-montag)
           wh-bt-montag:SENSITIVE = adm-current-page = 2 WHEN VALID-HANDLE(wh-bt-montag).
END.


IF p-ind-event = "INITIALIZE" and p-ind-object = "CONTAINER" THEN 
DO:
    RUN get-link-handle IN adm-broker-hdl (INPUT p-wgh-object,
                                           INPUT "PAGE-SOURCE":U,
                                           OUTPUT c-folder).
    RUN GET-ATTRIBUTE IN p-wgh-object ('Current-Page':U).
    ASSIGN wgh-folder             = p-wgh-object
           adm-current-page       = INTEGER(RETURN-VALUE)
           wh-bt-montag:VISIBLE   = adm-current-page = 2 WHEN VALID-HANDLE(wh-bt-montag)
           wh-bt-montag:SENSITIVE = adm-current-page = 2 WHEN VALID-HANDLE(wh-bt-montag).
END.

/* Emerson - Verifica se o componente esta ativo */


/*IF c-objeto = "v07in111.w" THEN DO:

    MESSAGE p-ind-event
        VIEW-AS ALERT-BOX INFO BUTTONS OK.


END.*/


/*
IF p-ind-event  = "END-UPDATE"  AND
   p-ind-object = "VIEWER"      AND
   c-objeto     = "v07in111.w"  THEN DO:  /* Viewer Principal */

    IF VALID-HANDLE(wh-local-montag) THEN DO:

        FOR FIRST estrutura NO-LOCK
            WHERE ROWID(estrutura) = p-row-table:

            FOR EACH int-local-montag EXCLUSIVE-LOCK
                WHERE int-local-montag.it-codigo = estrutura.it-codigo
                AND   int-local-montag.sequencia = estrutura.sequencia
                AND   int-local-montag.es-codigo = estrutura.es-codigo:

                DELETE int-local-montag.

            END.

            RUN pi-carrega-tts.

            FOR EACH tt-pos
                WHERE tt-pos.letra <> "":

                CREATE int-local-montag.
                ASSIGN int-local-montag.it-codigo    = estrutura.it-codigo
                       int-local-montag.sequencia    = estrutura.sequencia
                       int-local-montag.es-codigo    = estrutura.es-codigo
                       int-local-montag.local-montag = tt-pos.letra + tt-pos.pos
                       int-local-montag.letra        = tt-pos.letra
                       int-local-montag.numero       = tt-pos.pos.

            END.

        END.

    END.

END.
*/

IF p-ind-event  = "VALIDATE"  AND
   p-ind-object = "VIEWER"    AND
   p-row-table  = ?           AND
   c-objeto     = "v07in111.w" THEN DO:  /* Viewer Principal */
    
    RUN tela-upc (INPUT p-wgh-frame,
                  INPUT p-ind-Event,
                  INPUT "fill-in",      /*** Type ***/
                  INPUT "es-codigo",    /*** Name ***/
                  INPUT NO,             /*** Apresenta Mensagem dos Objetos ***/
                  INPUT 1,              /*** Quando existir mais de um objeto com o mesmo nome ***/
                  OUTPUT wh-componente-en0105a).

    FIND FIRST estrutura WHERE estrutura.it-codigo = wh-componente-en0105a:SCREEN-VALUE NO-LOCK NO-ERROR.
    IF NOT AVAIL estrutura THEN DO:
        FIND FIRST ITEM WHERE ITEM.it-codigo = wh-componente-en0105a:SCREEN-VALUE
                NO-LOCK NO-ERROR.
        IF AVAIL ITEM AND item.cod-obsoleto <> 1 THEN DO:
            MESSAGE "Componente Obsoleto. N∆o pode ser usado."
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                
            RETURN "NOK".
        END.
    END.
    ELSE DO:
        RUN esp/verifica-estrutura.p (INPUT wh-componente-en0105a:SCREEN-VALUE,
                                      OUTPUT p-ativo,
                                      OUTPUT p-itemob).
    
        IF p-ativo = NO THEN DO:
            MESSAGE "Item " p-itemob " esta Obsoleto. N∆o pode ser usado."
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        
            RETURN "NOK".
        END.
    END.
END.


PROCEDURE tela-upc:
    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE INPUT  PARAMETER  pAux         AS INTEGER       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.

    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE i-aux   AS INTEGER       NO-UNDO.

    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD
           i-aux   = 0.

    DO WHILE VALID-HANDLE(wgh-obj):                                

        IF pApresMsg = YES THEN                                    
            MESSAGE "Nome do Objeto" wgh-obj:NAME SKIP             
                    "Type do Objeto" wgh-obj:TYPE SKIP             
                    "P-Ind-Event"    pIndEvent VIEW-AS ALERT-BOX.  

        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE
                   i-aux = i-aux + 1.

            IF i-aux = pAux THEN
                LEAVE.
        END.
        IF wgh-obj:TYPE = "field-group" THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.
END PROCEDURE.



/*
PROCEDURE pi-carrega-tts:

    DEFINE VARIABLE l-erro AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cLocalMontagem AS CHARACTER  NO-UNDO.
    
    DEFINE VARIABLE i AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-local AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-letra AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-parte AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-ind AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-parte1 AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-pos-ini AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-pos-fim AS CHARACTER   NO-UNDO.
    
    
    ASSIGN cLocalMontagem = wh-local-montag:SCREEN-VALUE
           cLocalMontagem = REPLACE(cLocalMontagem,"),",");")
           cLocalMontagem = REPLACE(cLocalMontagem,") ,",");")
           cLocalMontagem = REPLACE(cLocalMontagem," ","").

    EMPTY TEMP-TABLE tt-pos.
    
    IF INDEX(cLocalMontagem /*estrutura.local-montag*/ ,";") = 0 AND 
       INDEX(cLocalMontagem /*estrutura.local-montag*/ ,"(") = 0 THEN DO:

        RUN piCriaSegmento(INPUT cLocalMontagem /*estrutura.local-montag*/ ,
                           INPUT "",
                           INPUT "", 
                           INPUT YES).
    END.
    ELSE DO i = 1 TO NUM-ENTRIES(cLocalMontagem /*estrutura.local-montag*/ ,";"):

        ASSIGN c-local = ENTRY(i,cLocalMontagem /*estrutura.local-montag*/ ,";").
        IF INDEX(c-local,"(") = 0 THEN DO:

            ASSIGN c-letra = c-local
                   c-parte = "".
            RUN piCriaSegmento(INPUT c-letra,
                               INPUT "",
                               INPUT "",
                               INPUT yes).

        END.
        ELSE DO:

            ASSIGN c-letra = substr(c-local,1,index(c-local,"(") - 1)
                    c-parte = substr(c-local,
                                     index(c-local,"(") + 1, 
                                     index(c-local,")") - (index(c-local,"(") + 1)).

            DO i-ind = 1 TO NUM-ENTRIES(c-parte,","):

                ASSIGN c-parte1 = ENTRY(i-ind,c-parte,",") NO-ERROR.
                IF index(c-parte1,"-") <> 0 THEN DO:

                    ASSIGN c-pos-ini = ENTRY(1,c-parte1,"-")
                           c-pos-fim = ENTRY(2,c-parte1,"-").

                    IF ASC(CAPS(c-pos-ini)) >= 65 THEN DO:
                        RUN piCriaSegmento(INPUT c-letra, 
                                           INPUT c-pos-ini, 
                                           INPUT c-pos-fim, 
                                           INPUT YES).
                    END.
                    ELSE DO:
                        RUN piCriaSegmento(INPUT c-letra, 
                                           INPUT c-pos-ini, 
                                           INPUT c-pos-fim, 
                                           INPUT NO).
                    END.
                END.
                ELSE DO:
                    RUN piCriaSegmento(INPUT c-letra, 
                                       INPUT c-parte1, 
                                       INPUT c-parte1, 
                                       INPUT YES).
                END.
            END.
        END.
    END. /* ELSE DO i = 1 TO NUM-ENTRIES(estrutura.local-montag,";"): */   

END PROCEDURE.


PROCEDURE piCriaSegmento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param c-letra as char no-undo.
   def input param c-ini   as char no-undo.
   def input param c-fim   as char no-undo.
   def input param l-alfa  as logical no-undo.
   def var c-carac as char    no-undo.
   def var i       as integer no-undo.
   def var ini     as int     no-undo.
   def var fim     as int     no-undo.
   
   if l-alfa = no then do:
      assign ini = int(c-ini)
             fim = int(c-fim).
      do i = ini to fim:
         assign c-carac  = caps(string(i)).
         FOR first tt-pos where tt-pos.letra = c-letra 
                             and tt-pos.pos   = trim(c-carac):
         END.
         if not avail tt-pos then do:                  
            create tt-pos.
            assign tt-pos.letra   = caps(c-letra)
                   tt-pos.pos     = trim(c-carac). 
            if trim(tt-pos.pos) = "0" then 
               assign tt-pos.pos = "".
            run PiConverte(trim(c-carac), output tt-pos.ord).       
         end.          
      end.
   end.
   else do:
      if c-ini = c-fim then do:
         FOR first tt-pos where tt-pos.letra = c-letra 
                             and tt-pos.pos   = trim(c-ini):
         END.
                           
         if not avail tt-pos then do:                  
            create tt-pos.
            assign tt-pos.letra   = caps(c-letra)
                   tt-pos.pos     = caps(trim(c-ini)).
            if trim(tt-pos.pos) = "0" then 
               assign tt-pos.pos = "".
            run PiConverte(trim(c-ini), output tt-pos.ord).
         end.
      end.   
      else do:
         do i = asc(caps(c-ini)) to asc(caps(c-fim)):
            FOR first tt-pos where tt-pos.letra = c-letra
                                and tt-pos.pos   = chr(i):
            END.
                              
            if not avail tt-pos then do:                  
               create tt-pos.
               assign tt-pos.letra   = caps(c-letra)
                      tt-pos.pos     = chr(i).
               if trim(tt-pos.pos) = "0" then 
                  assign tt-pos.pos = "".
               run PiConverte(chr(i), output tt-pos.ord).
            end.
         end.
      end.          
   end.
END PROCEDURE.


PROCEDURE piConverte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param c-pos as char no-undo.
   def output param de-num as dec no-undo.

   def var c-carac as char    no-undo.
   def var c-mult  as char    no-undo.
   def var i-cont  as integer no-undo.
   def var l-alfa  as logical no-undo.
   
   def var de-mult as decimal no-undo.

   assign c-mult = "100000000000000000000000000000".
   do i-cont = 1 to length(trim(c-pos)):
      assign c-carac = c-carac 
                     + string(asc(caps(substring(c-pos,i-cont,1)))).
      if asc(caps(substring(c-pos,i-cont,1))) >= 65 then do: 
         l-alfa = yes.
      end.
   end.
   if l-alfa then do:
      assign de-mult = dec(substring(c-mult,1,((30 - length(c-carac)) + 1)))
             de-num = (dec(c-carac) * de-mult).
   end.
   else 
      assign de-num = dec(c-pos).

END PROCEDURE.
*/
