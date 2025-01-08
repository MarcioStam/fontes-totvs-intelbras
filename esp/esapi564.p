&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{esp/esapi505.i}

DEF INPUT PARAM h-acomp     AS HANDLE NO-UNDO.    
DEF INPUT PARAM i-acao      AS i      NO-UNDO.
DEF INPUT PARAM rw-registro AS ROWID  NO-UNDO.


DEF VAR httCust      AS HANDLE   NO-UNDO.
DEF VAR lReturnValue AS LOGICAL  NO-UNDO.

DEF NEW GLOBAL SHARED VAR l-esapi561 AS l NO-UNDO.

DEF VAR cJson               AS LONGCHAR                             NO-UNDO.
DEF VAR cID                 AS c                                    NO-UNDO.

def buffer bff-embarque-imp for embarque-imp.

{esp/esapi505x.i &OPC="OPEN"}

IF i-acao = 0
THEN DO:
   l-esapi561 = NO.
   {esp/esapi505x.i &OPC="CLOSE"}
   RETURN "OK".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 11
         WIDTH              = 41.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
FOR FIRST es-api-log
    WHERE ROWID(es-api-log) = rw-registro,
    FIRST es-api-URI       NO-LOCK
       OF es-api-log,
    FIRST es-api-empresa   NO-LOCK
       OF es-api-log,
    FIRST es-api-aplicacao NO-LOCK
       OF es-api-log
       BY es-api-log.flg-processado
       BY es-api-log.dh-request:
    ASSIGN
       es-api-log.dh-envio       = NOW
       es-api-log.flg-processado = YES.

    FIND bff-embarque-imp WHERE 
         bff-embarque-imp.embarque = ENTRY(1,es-api-log.aux,"-")
         NO-LOCK NO-ERROR.

    IF AMBIGUOUS bff-embarque-imp
    THEN do:
         release es-api-log.
         next.
    END.

    if  avail bff-embarque-imp
    and can-find(first ext-embarque-imp WHERE 
                       ext-embarque-imp.cod-estabel     = bff-embarque-imp.cod-estabel
                   AND ext-embarque-imp.embarque        = bff-embarque-imp.embarque
                   AND ext-embarque-imp.log-envio-comex = yes
                       no-lock)
    and bff-embarque-imp.cod-via-transp > 1
    and bff-embarque-imp.cod-via-transp < 4
    then.
    else do:
         release es-api-log.
         next.
    end.

    MESSAGE ">> Chave - " es-api-log.aux.
    
    /*
    //MESSAGE 2 l-esapi505a VIEW-AS ALERT-BOX INFO BUTTONS YES-NO UPDATE l1 . IF l1 = NO THEN STOP.
    FOR FIRST embarque-imp NO-LOCK
        WHERE embarque-imp.cod-estabel = ENTRY(1,es-api-log.aux)
          AND embarque-imp.embarque    = ENTRY(2,es-api-log.aux),
        FIRST ordens-embarque NO-LOCK
           OF embarque-imp
        WHERE ordens-embarque.numero-ordem = INT(ENTRY(3,es-api-log.aux))
          AND ordens-embarque.parcela      = INT(ENTRY(4,es-api-log.aux)),
        FIRST ordem-compra NO-LOCK
           OF ordens-embarque,
        FIRST pedido-compr NO-LOCK
           OF ordem-compra /*,
        FIRST processo-imp NO-LOCK
           OF ordens-embarque, 
        FIRST ext-embarque-imp NO-LOCK
        WHERE ext-embarque-imp.cod-estabel       = embarque-imp.cod-estabel
          AND ext-embarque-imp.embarque          = embarque-imp.embarque
//          AND ext-embarque-imp.log-envio-comex   = NO*/
        :
    
       ASSIGN
          cID = embarque-imp.embarque
              + "-"
              + STRING(ordem-compra.num-pedido)
              + "-"
              + STRING(ordem-compra.numero-ordem)
              + "-"
              + STRING(ordens-embarque.parcela)
              + "-"
              + ordem-compra.it-codigo
              + "-"
              + STRING(pedido-compr.cod-emitente).
    END.
    */

    ASSIGN
       cID = es-api-log.aux.
       

    IF VALID-HANDLE(h-acomp)
    THEN RUN pi-acompanhar IN h-acomp ("Elimina‡Æo de Item de Pedido").

    IF es-api-aplicacao.Testes  = NO
    THEN ASSIGN
       c-endereco          = es-api-URI.ent-PRD.
    ELSE ASSIGN            
       c-endereco          = es-api-URI.end-TST.

    ASSIGN
       c-endereco = c-endereco + "/" + cID.
    CLIPBOARD:VALUE = cID.
    fc-chamada-1().

    RELEASE es-api-log.
END.

{esp/esapi505x.i &OPC="CLOSE"}

RETURN "OK".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

