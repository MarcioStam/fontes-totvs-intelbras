/***********************************************************************
**  Programa..: upc\cd0401b-upc.p
**  Autor.....: Clayton Antunes
**  Data......: Novembro/2006 - Desenvolvimento
**  Descricao.: 
**  Versão....: 001 - 00/00/2006
**                  Desenvolvimento Programa
************************************************************************/

    {utp/ut-glob.i}  

    DEF input param p-ind-event        as char          no-undo.
    DEF input param p-ind-object       as char          no-undo.
    DEF input param p-wgh-object       as handle        no-undo.
    DEF input param p-wgh-frame        as widget-handle no-undo.
    DEF input param p-cod-table        as char          no-undo.
    DEF input param p-row-table        as rowid         no-undo.

    DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
    DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.

    DEF NEW GLOBAL SHARED VAR tx-cc           AS WIDGET-HANDLE NO-UNDO.
    DEF NEW GLOBAL SHARED VAR wh-cc           AS WIDGET-HANDLE NO-UNDO.
    DEF NEW GLOBAL SHARED VAR wh-tg-recebe-po AS WIDGET-HANDLE NO-UNDO.

    DEF NEW GLOBAL SHARED VAR wh-cod-imagem      AS WIDGET-HANDLE NO-UNDO.

    DEFINE NEW GLOBAL SHARED VARIABLE wh-button       AS WIDGET-HANDLE    NO-UNDO.

    define new global shared var wh-email-cd0401b as widget-handle no-undo.

    DEF NEW GLOBAL SHARED VAR h-upc-cd0401b           AS WIDGET-HANDLE NO-UNDO.

    DEFINE VARIABLE c-char AS   CHAR.

    DEF NEW GLOBAL SHARED VAR cod-upc   LIKE cont-emit.cod-emitente NO-UNDO.
    DEF NEW GLOBAL SHARED VAR seq-upc   LIKE cont-emit.sequencia    NO-UNDO.


    ASSIGN c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").


    
    /*MESSAGE "Evento " p-ind-event  SKIP
            "Objeto " p-ind-object SKIP
            "Nome   " c-char SKIP
            "Tabela " p-cod-table  SKIP
            "Rowid  " STRING(p-row-table)
        VIEW-AS ALERT-BOX INFO BUTTONS OK.*/
   

    IF  p-ind-object = "CONTAINER" AND 
        p-ind-event = "BEFORE-INITIALIZE" THEN DO:
        RUN upc/cd0401b-upc.p PERSISTENT SET h-upc-cd0401b(INPUT "",            
                                                           INPUT "",            
                                                           INPUT p-wgh-object,  
                                                           INPUT p-wgh-frame,   
                                                           INPUT "",            
                                                           INPUT p-row-table).  
    END.


    IF  p-ind-event = "destroy" THEN
        IF VALID-HANDLE(h-upc-cd0401b) THEN
            DELETE PROCEDURE h-upc-cd0401b.


    IF p-ind-event = "INITIALIZE" THEN DO:

       IF p-wgh-frame:NAME = "f-main"  THEN DO:
          /* Cria campo e texto para centro de custo */
          CREATE TEXT tx-cc
                ASSIGN FRAME        = p-wgh-frame
                       FORMAT       = "x(13)"
                       WIDTH        = 13
                       SCREEN-VALUE = "Centro custo:"
                       ROW          = 3.78
                       COL          = 62.50
                       VISIBLE      = YES.         
    
          CREATE FILL-IN wh-cc
          ASSIGN FRAME             = p-wgh-frame
                 FORMAT            = "x(8)"
                 WIDTH             = 10
                 HEIGHT            = 0.88
                 ROW               = 3.75
                 COL               = 72.09
                 VISIBLE           = YES
                 SENSITIVE         = YES
                 triggers:
                   ON LEAVE PERSISTENT RUN pi-cd0401b-upc IN h-upc-cd0401b.
                 end triggers.

          CREATE TOGGLE-BOX wh-tg-recebe-po
          ASSIGN FRAME             = p-wgh-frame
                 WIDTH             = 13
                 HEIGHT            = 0.88
                 ROW               = 4.75
                 COL               = 72.09
                 VISIBLE           = YES
                 SENSITIVE         = YES
                 LABEL             = "Recebe PO#".

          
          IF VALID-HANDLE(wh-cc) THEN
              wh-cc:MOVE-AFTER-TAB-ITEM(wh-cc).

       END.
       ASSIGN wh-cc:SENSITIVE           = FALSE
              wh-tg-recebe-po:SENSITIVE = FALSE.
    END.


    /*IF p-ind-event = "VALIDATE" THEN DO:
        FIND FIRST centro-custo WHERE
             centro-custo.cc-codigo = wh-cc:SCREEN-VALUE NO-ERROR.
        IF NOT AVAIL centro-custo THEN DO:
           MESSAGE "Centro de custo inexistente"
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
           ASSIGN wh-cc:SENSITIVE = YES.
           ASSIGN cc = "".
           /*RETURN "NOK".*/
           RETURN 'ADM-ERROR':U.
        END.
        ELSE
           ASSIGN cc = centro-custo.cc-codigo.
    END.*/


    IF p-ind-event = "add" THEN DO:
       FIND FIRST cont-emit NO-LOCK WHERE
            ROWID(cont-emit) = p-row-table NO-ERROR. 
        IF AVAIL cont-emit THEN DO:
            FIND FIRST int-cont-emit NO-LOCK
                 WHERE int-cont-emit.cod-emitente = cont-emit.cod-emitente 
                   AND int-cont-emit.sequencia    = cont-emit.sequencia    NO-ERROR.
            IF NOT AVAIL int-cont-emit THEN DO:
               CREATE int-cont-emit.
               ASSIGN int-cont-emit.cod-emitente  = cont-emit.cod-emitente
                      int-cont-emit.sequencia     = cont-emit.sequencia
                      int-cont-emit.cc-codigo     = wh-cc:SCREEN-VALUE
                      int-cont-emit.log-recebe-po = wh-tg-recebe-po:CHECKED.
            END.
        END.
        ASSIGN tx-cc:SCREEN-VALUE = "Centro custo: ".  
    END.


    IF p-ind-event = "AFTER-END-UPDATE" THEN DO:
       FIND FIRST cont-emit NO-LOCK WHERE
            ROWID(cont-emit) = p-row-table NO-ERROR.
       IF AVAIL cont-emit THEN DO:
           FIND int-cont-emit EXCLUSIVE-LOCK WHERE
                int-cont-emit.cod-emitente = cont-emit.cod-emitente AND
                int-cont-emit.sequencia    = cont-emit.sequencia    NO-ERROR.
           IF NOT AVAIL int-cont-emit THEN DO:
              CREATE int-cont-emit.
              ASSIGN int-cont-emit.cod-emitente = cont-emit.cod-emitente
                     int-cont-emit.sequencia    = cont-emit.sequencia
                     int-cont-emit.cc-codigo    = wh-cc:SCREEN-VALUE
                     int-cont-emit.log-recebe-po = wh-tg-recebe-po:CHECKED.
           END.
           ELSE DO:
               ASSIGN int-cont-emit.cc-codigo = wh-cc:SCREEN-VALUE
                      int-cont-emit.log-recebe-po = wh-tg-recebe-po:CHECKED.
           END.

           RELEASE int-cont-emit NO-ERROR.
        END.
    END.

    
    IF p-ind-event = "ENABLE" THEN DO:
       ASSIGN wh-cc:SENSITIVE           = YES
              wh-tg-recebe-po:SENSITIVE = YES.
    END.


    IF p-ind-event = "CANCEL" THEN DO:
       ASSIGN wh-cc:SENSITIVE           = NO
              tx-cc:VISIBLE             = YES
              wh-tg-recebe-po:SENSITIVE = NO
              wh-tg-recebe-po:VISIBLE   = YES.
    END.


    IF p-ind-event = "DISPLAY" THEN DO:
        IF VALID-HANDLE(wh-cc) AND  NOT wh-cc:SENSITIVE THEN DO:
            FIND FIRST cont-emit NO-LOCK WHERE
                 ROWID(cont-emit) = p-row-table NO-ERROR.
            IF AVAIL cont-emit THEN DO:
               FIND FIRST int-cont-emit NO-LOCK WHERE
                    int-cont-emit.cod-emitente = cont-emit.cod-emitente AND
                    int-cont-emit.sequencia    = cont-emit.sequencia    NO-ERROR.
               IF AVAIL int-cont-emit THEN DO:
                  ASSIGN wh-cc:SCREEN-VALUE      = STRING(int-cont-emit.cc-codigo)
                         wh-tg-recebe-po:CHECKED = int-cont-emit.log-recebe-po. 
               END.          
               ELSE DO:
                  ASSIGN wh-cc:SCREEN-VALUE      = ""
                         wh-tg-recebe-po:CHECKED = NO. 
               END.         
            END.
        END.
    END.

            
    IF p-ind-event = "DISABLE" THEN DO:  
        /*
       FIND FIRST centro-custo WHERE
            centro-custo.cc-codigo = wh-cc:SCREEN-VALUE NO-ERROR.
       IF NOT AVAIL centro-custo THEN DO:
          MESSAGE "Centro de custo inexistente"
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
          ASSIGN wh-cc:SENSITIVE = NO.
          RETURN "NOK".
       END.
       FIND FIRST cont-emit WHERE
            ROWID(cont-emit) = p-row-table NO-ERROR.
       IF AVAIL cont-emit THEN DO:
          FIND int-cont-emit WHERE
               int-cont-emit.cod-emitente = cont-emit.cod-emitente AND
               int-cont-emit.sequencia    = cont-emit.sequencia    NO-ERROR.
          IF NOT AVAIL int-cont-emit THEN DO:
             CREATE int-cont-emit.
                    ASSIGN int-cont-emit.cod-emitente = cont-emit.cod-emitente
                           int-cont-emit.sequencia    = cont-emit.sequencia
                           int-cont-emit.cc-codigo    = wh-cc:SCREEN-VALUE.
          END.
          ELSE DO:
              ASSIGN int-cont-emit.cc-codigo = wh-cc:SCREEN-VALUE.
          END.
       END.
       */
       ASSIGN wh-cc:SENSITIVE           = NO
              wh-tg-recebe-po:SENSITIVE = NO.
    END.
    
    
    IF p-ind-event = "DELETE" THEN DO:
       FIND FIRST cont-emit NO-LOCK WHERE
            ROWID(cont-emit) = p-row-table NO-ERROR.
       IF AVAIL cont-emit THEN DO:
          FIND FIRST int-cont-emit EXCLUSIVE-LOCK WHERE
               int-cont-emit.cod-emitente = cont-emit.cod-emitente AND
               int-cont-emit.sequencia    = cont-emit.sequencia    NO-ERROR.
          IF AVAIL int-cont-emit THEN DO:
             DELETE int-cont-emit.
          END.
       END.
    END.


    IF p-ind-object = "VIEWER"         AND
       c-char     = "cd0401b-v01.w"  THEN DO:

      IF p-ind-event = "BEFORE-INITIALIZE" THEN DO:
          RUN tela-upc (INPUT p-wgh-frame,
                        INPUT p-ind-Event,
                        INPUT "fill-in",     /*** Type ***/
                        INPUT "e-mail",         /*** Name ***/
                        INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                        INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                        OUTPUT wh-email-cd0401b).

          IF VALID-HANDLE(wh-email-cd0401b) THEN DO:
              ASSIGN wh-email-cd0401b:FORMAT = "x(80)"
                     wh-email-cd0401b:WIDTH  = 60.
          END.

      END.
    END.


    PROCEDURE pi-cd0401b-upc:

        IF wh-cc:SCREEN-VALUE <> "" THEN DO:
            FIND FIRST centro-custo NO-LOCK 
                 WHERE centro-custo.cc-codigo = wh-cc:SCREEN-VALUE NO-ERROR.
            IF NOT AVAIL centro-custo THEN DO:
               MESSAGE "Centro de custo inexistente"
                   VIEW-AS ALERT-BOX INFO BUTTONS OK.
               APPLY "entry" TO wh-cc.
               RETURN NO-APPLY.
            END.
        END.

    END PROCEDURE.


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
