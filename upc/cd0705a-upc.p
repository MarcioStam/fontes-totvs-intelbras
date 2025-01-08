/***********************************************************************
**  Programa..: upc\cd0705-upc.p
**  Autor.....: Clayton Antunes
**  Data......: Novembro/2006 - Desenvolvimento
**  Descricao.: 
**  Versão....: 001 - 00/00/2006
**                  Desenvolvimento Programa
************************************************************************/
    {esp/crm/escrm001.i} /* Definicaode temp-table */
    {esp/crm/escrm001a.i1} /* Definicaode temp-table */

    DEF input param p-ind-event        as char          no-undo.
    DEF input param p-ind-object       as char          no-undo.
    DEF input param p-wgh-object       as handle        no-undo.
    DEF input param p-wgh-frame        as widget-handle no-undo.
    DEF input param p-cod-table        as char          no-undo.
    DEF input param p-row-table        as rowid         no-undo.

    DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
    DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.

    DEF NEW GLOBAL SHARED VAR tx-cc      AS WIDGET-HANDLE NO-UNDO.
    DEF NEW GLOBAL SHARED VAR wh-cc      AS WIDGET-HANDLE NO-UNDO.

    DEF NEW GLOBAL SHARED VAR wh-cod-imagem      AS WIDGET-HANDLE NO-UNDO.

    DEFINE NEW GLOBAL SHARED VARIABLE wh-button       AS WIDGET-HANDLE    NO-UNDO.

    define new global shared var wh-endereco-cd0705a as widget-handle no-undo.
    DEF NEW GLOBAL SHARED VAR whTextendereco-completo              AS WIDGET-HANDLE NO-UNDO.
    DEF NEW GLOBAL SHARED VAR whendereco-completo                  AS WIDGET-HANDLE NO-UNDO.

    DEFINE VARIABLE c-char AS   CHAR.

    DEF VAR cc AS CHAR.

    DEFINE VARIABLE h-cdapi704 AS HANDLE      NO-UNDO.

    DEFINE VARIABLE c-rua AS CHARACTER FORMAT "x(70)" NO-UNDO.
    DEFINE VARIABLE c-nro  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-comp AS CHARACTER FORMAT "x(80)" NO-UNDO.

    DEF NEW GLOBAL SHARED VAR cod-upc   LIKE cont-emit.cod-emitente NO-UNDO.
    DEF NEW GLOBAL SHARED VAR seq-upc   LIKE cont-emit.sequencia    NO-UNDO.


    ASSIGN c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").

    IF p-ind-object = "VIEWER"         AND
       c-char     = "v01di102.w"  THEN DO:
              
      IF p-ind-event = "BEFORE-INITIALIZE" THEN DO:
          RUN tela-upc (INPUT p-wgh-frame,
                        INPUT p-ind-Event,
                        INPUT "fill-in",     /*** Type ***/
                        INPUT "endereco",         /*** Name ***/
                        INPUT no,            /*** Apresenta Mensagem dos Objetos ***/
                        INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                        OUTPUT wh-endereco-cd0705a).


          IF VALID-HANDLE(wh-endereco-cd0705a) THEN DO:

              ASSIGN p-wgh-frame:HEIGHT-CHARS =  10.5
                     p-wgh-frame:ROW = 2.5
                     p-wgh-frame:WIDTH-CHARS = 90
                     p-wgh-frame:COL = 1.

                CREATE TEXT whTextendereco-completo
                    ASSIGN FRAME     = wh-endereco-cd0705a:FRAME
                           WIDTH     = 18
                           ROW       = 10.2
                           COL       = 12.8
                           FORMAT    = "x(18)"
                           SCREEN-VALUE = "Endereco Completo:"
                           VISIBLE   = YES.
    
                CREATE FILL-IN whendereco-completo
                ASSIGN FRAME     = whTextendereco-completo:FRAME
                       WIDTH     = 60
                       FORMAT    = "x(80)"
                       HEIGHT    = 0.88
                       ROW       = whTextendereco-completo:ROW 
                       COL       = whTextendereco-completo:COL + 14
                       SENSITIVE = NO
                       VISIBLE   = YES
                       SIDE-LABEL-HANDLE = whTextendereco-completo:HANDLE.
          END.

      END.
      IF VALID-HANDLE(wh-endereco-cd0705a) THEN
      DO:
          IF p-ind-event = "ENABLE" THEN
             ASSIGN whendereco-completo:SENSITIVE = YES .

          IF p-ind-event = "DISABLE" THEN
             ASSIGN whendereco-completo:SENSITIVE = NO.

          IF p-ind-event = "VALIDATE"  THEN DO:
              
              RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
              RUN pi-trata-endereco IN h-cdapi704 (INPUT  wh-endereco-cd0705a:SCREEN-VALUE,
                                                   OUTPUT c-rua, 
                                                   OUTPUT c-nro, 
                                                   OUTPUT c-comp).
              IF length(c-rua) > 60 THEN DO:
                  MESSAGE "Nro de caracteres da rua do endereco completo ‚ superior a 60, maximo permitido pela SEFAZ, Abrevie o endere‡o!!"
                      VIEW-AS ALERT-BOX INFO BUTTONS OK.
                  DELETE PROCEDURE h-cdapi704.
                  RETURN "NOK":U.
              END.
              IF c-nro = "" THEN DO:
                  MESSAGE "Cliente com endere‡o sem numero, favor informar o numero no endere‡o do cliente"
                      VIEW-AS ALERT-BOX.
                  DELETE PROCEDURE h-cdapi704.
                  RETURN "NOK":U.
              END.
              IF length(trim(c-comp)) = 1 THEN DO:
                  MESSAGE "Complemento do Endereco apenas com uma posi‡Æo, SEFAZ exige que tenha mais de uma posi‡Æo"
                      VIEW-AS ALERT-BOX.
                  DELETE PROCEDURE h-cdapi704.
                  RETURN "NOK":U.
              END.

              IF whendereco-completo:SCREEN-VALUE <> "" THEN DO:
                  RUN pi-trata-endereco IN h-cdapi704 (INPUT  whendereco-completo:SCREEN-VALUE,
                                                       OUTPUT c-rua, 
                                                       OUTPUT c-nro, 
                                                       OUTPUT c-comp).
                  IF length(c-rua) > 60 THEN DO:
                      MESSAGE "Nro de caracteres da rua do endereco completo ‚ superior a 60, maximo permitido pela SEFAZ, Abrevie o endere‡o!!"
                          VIEW-AS ALERT-BOX INFO BUTTONS OK.
                      DELETE PROCEDURE h-cdapi704.
                      RETURN "NOK":U.
                  END.
                  IF c-nro = "" THEN DO:
                      MESSAGE "Cliente com endere‡o completo sem numero, favor informar o numero no endere‡o do cliente"
                          VIEW-AS ALERT-BOX.
                      DELETE PROCEDURE h-cdapi704.
                      RETURN "NOK":U.
                  END.
                  IF length(trim(c-comp)) = 1 THEN DO:
                      MESSAGE "Complemento do Endereco completo apenas com uma posi‡Æo, SEFAZ exige que tenha mais de uma posi‡Æo"
                          VIEW-AS ALERT-BOX.
                      DELETE PROCEDURE h-cdapi704.
                      RETURN "NOK":U.
                  END.
              END.
              DELETE PROCEDURE h-cdapi704.

          END.

          IF p-ind-event = "DISPLAY" THEN DO:
              FIND FIRST loc-entr
                   WHERE ROWID(loc-entr) = p-row-table NO-LOCK NO-ERROR.
              IF AVAIL loc-entr THEN DO:
                  FIND int-loc-entr
                      WHERE int-loc-entr.nome-abrev  = loc-entr.nome-abrev
                        AND int-loc-entr.cod-entrega = loc-entr.cod-entrega
                      EXCLUSIVE-LOCK NO-ERROR.
                  IF NOT AVAIL int-loc-entr  THEN DO:
                     CREATE int-loc-entr.
                     ASSIGN int-loc-entr.nome-abrev  = loc-entr.nome-abrev
                            int-loc-entr.cod-entrega = loc-entr.cod-entrega.
                  END.
                  ASSIGN whendereco-completo:SCREEN-VALUE = int-loc-entr.endereco-completo.
              END.
          END.
          ELSE IF p-ind-event = "AFTER-END-UPDATE" THEN DO:
              FIND FIRST loc-entr
                   WHERE ROWID(loc-entr) = p-row-table NO-LOCK NO-ERROR.

                  FIND int-loc-entr
                      WHERE int-loc-entr.nome-abrev  = loc-entr.nome-abrev
                        AND int-loc-entr.cod-entrega = loc-entr.cod-entrega
                      EXCLUSIVE-LOCK NO-ERROR.
                  IF NOT AVAIL int-loc-entr  THEN DO:
                     CREATE int-loc-entr.
                     ASSIGN int-loc-entr.nome-abrev  = loc-entr.nome-abrev
                            int-loc-entr.cod-entrega = loc-entr.cod-entrega.
                  END.
                                                       
                  ASSIGN int-loc-entr.endereco-completo  = whendereco-completo:SCREEN-VALUE.

                  /* Enviar mensagem */
                  {esp/esb/esesb000.i}

                  DEF VAR raw-param AS RAW NO-UNDO.

                  DEFINE TEMP-TABLE b-tt-loc-entr LIKE loc-entr
                       FIELD situacao AS INTEGER.

                  CREATE b-tt-loc-entr.
                  BUFFER-COPY loc-entr TO b-tt-loc-entr.
                  ASSIGN b-tt-loc-entr.situacao  = 0. /* Manuten‡Æo */

                  RAW-TRANSFER b-tt-loc-entr TO raw-param.

                  RUN esp/esb/esesb003.p (INPUT        "msg0191-out", /* Nome Mensagem */  
                                          INPUT        raw-param, /* Tupla do registro */
                                          OUTPUT TABLE resultado  /* Retorno do barramento */) NO-ERROR.



                       
/*                   find first emitente no-lock where                                  */
/*                              emitente.nome-abrev = int-loc-entr.nome-abrev no-error. */
/*                   if avail emitente and                                              */
/*                            emitente.identific <> 2                                   */
/*                   then do:                                                           */
/*                                                                                      */
/*                        /******* Integra‡Æo com o CRM ******************/             */
/*                                                                                      */
/*                        RUN esp/crm/escrm001a.p (input "Loc-entr",                    */
/*                                                input "W" ,                           */
/*                                                input rowid(loc-entr),                */
/*                                                input table tt-raw-transfer).         */
/*                                                                                      */
/*                        /*************************************************/           */
/*                                                                                      */
/*                   end.                                                               */
/*                                                                                      */
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
