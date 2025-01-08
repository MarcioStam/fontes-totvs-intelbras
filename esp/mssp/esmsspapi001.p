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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-piCriaRelac) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaRelac Procedure 
PROCEDURE piCriaRelac :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER i-tipo     AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER i-cest     AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER dt-valid   AS DATE      NO-UNDO.
DEFINE INPUT PARAMETER c-estab    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER c-uf       AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER c-nat-oper AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER c-ncm      AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER c-item     AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER i-emitente AS INTEGER   NO-UNDO.

CREATE sit-tribut-relacto.
ASSIGN sit-tribut-relacto.cdn-tribut               = 11
       sit-tribut-relacto.cdn-sit-tribut           = i-cest
       sit-tribut-relacto.dat-valid-inic           = dt-valid
       sit-tribut-relacto.idi-tip-docto            = i-tipo
       sit-tribut-relacto.cod-estab                = c-estab
       sit-tribut-relacto.cod-natur-operac         = c-nat-oper
       sit-tribut-relacto.cod-ncm                  = c-ncm
       sit-tribut-relacto.cod-item                 = c-item
       sit-tribut-relacto.cdn-emitente             = i-emitente
       OVERLAY(sit-tribut-relacto.cod-livre-1,1,2) = c-uf.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piGeraRelactoCest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraRelactoCest Procedure 
PROCEDURE piGeraRelactoCest :
/*------------------------------------------------------------------------------
  Purpose: CEST - C¢digo especificador da substitui‡Æo tribut ria    
  Notes:   Carlos Daniel - 04/03/2016
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER i-cdn-sit-tribut AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER dt-valid         AS DATE      NO-UNDO.
DEFINE INPUT  PARAMETER c-estab          AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER c-uf             AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER c-nat-oper       AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER c-ncm            AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER c-item           AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER i-emitente       AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER c-mensagem       AS CHARACTER NO-UNDO.

DEFINE VARIABLE lcriarelact AS LOGICAL INITIAL YES NO-UNDO.

IF i-cdn-sit-tribut <> ? AND i-cdn-sit-tribut <> 0 THEN DO:
    IF CAN-FIND(FIRST sit-tribut
                WHERE sit-tribut.cdn-sit-tribut  = i-cdn-sit-tribut
                AND   sit-tribut.cdn-tribut      = 11
                AND   sit-tribut.dat-valid-inic <= TODAY) THEN DO:

        FOR EACH sit-tribut-relacto
            WHERE sit-tribut-relacto.cdn-tribut       = 11
            AND   sit-tribut-relacto.cod-estab        = c-estab
            AND   sit-tribut-relacto.cod-natur-operac = c-nat-oper
            AND   sit-tribut-relacto.cod-ncm          = c-ncm
            AND   sit-tribut-relacto.cod-item         = c-item
            AND   sit-tribut-relacto.cdn-emitente     = i-emitente EXCLUSIVE-LOCK:
            
            IF SUBSTRING(sit-tribut-relacto.cod-livre-1,1,2) = c-uf THEN DO:
                IF sit-tribut-relacto.cdn-sit-tribut <> i-cdn-sit-tribut THEN DO:
                    DELETE sit-tribut-relacto.
                    ASSIGN lcriarelact = YES.
                END.
                ELSE DO:
                    ASSIGN sit-tribut-relacto.cod-estab        = c-estab   
                           sit-tribut-relacto.cod-natur-operac = c-nat-oper
                           sit-tribut-relacto.cod-ncm          = c-ncm     
                           sit-tribut-relacto.cod-item         = c-item    
                           sit-tribut-relacto.cdn-emitente     = i-emitente
                           lcriarelact                         = NO.
                END.
            END.
        END.

        IF lcriarelact THEN DO:
            RUN piCriaRelac(INPUT 1,
                            INPUT i-cdn-sit-tribut,
                            INPUT dt-valid,
                            INPUT c-estab,
                            INPUT c-uf,
                            INPUT c-nat-oper,
                            INPUT c-ncm,
                            INPUT c-item,
                            INPUT i-emitente).
            RUN piCriaRelac(INPUT 2,
                            INPUT i-cdn-sit-tribut,
                            INPUT dt-valid,
                            INPUT c-estab,
                            INPUT c-uf,
                            INPUT c-nat-oper,
                            INPUT c-ncm,
                            INPUT c-item,
                            INPUT i-emitente).
        END.
    END.
    ELSE DO:
        ASSIGN c-mensagem = "NÆo encontrado CEST para o c¢digo informado!".
        RETURN "NOK".
    END.
END.
ELSE DO:
    FOR EACH sit-tribut-relacto
        WHERE sit-tribut-relacto.cdn-tribut       = 11
        AND   sit-tribut-relacto.cod-estab        = c-uf
        AND   sit-tribut-relacto.cod-natur-operac = c-nat-oper
        AND   sit-tribut-relacto.cod-ncm          = c-ncm
        AND   sit-tribut-relacto.cod-item         = c-item
        AND   sit-tribut-relacto.cdn-emitente     = i-emitente EXCLUSIVE-LOCK:

         IF SUBSTRING(sit-tribut-relacto.cod-livre-1,1,2) = c-uf THEN
             DELETE sit-tribut-relacto.
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaCEST Procedure 
PROCEDURE piBuscaCEST:
/*------------------------------------------------------------------------------
  Purpose: CEST - C¢digo especificador da substitui‡Æo tribut ria    
  Notes:   Carlos Daniel - 04/03/2016
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER i-idi-tip-docto AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER dt-valid         AS DATE      NO-UNDO.
DEFINE INPUT  PARAMETER c-estab          AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER c-uf             AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER c-nat-oper       AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER c-ncm            AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER c-item           AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER i-emitente       AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER c-mensagem       AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER i-cest           AS INTEGER NO-UNDO.
FOR FIRST sit-tribut-relacto
    WHERE sit-tribut-relacto.cdn-tribut                = 11
      AND sit-tribut-relacto.idi-tip-docto             = i-idi-tip-docto
      AND sit-tribut-relacto.cod-estab                 = c-estab
      AND sit-tribut-relacto.cod-natur-operac          = c-nat-oper
      AND sit-tribut-relacto.cod-ncm                   = c-ncm
      AND sit-tribut-relacto.cod-item                  = c-item
      AND sit-tribut-relacto.cdn-emitente              = i-emitente
      AND sit-tribut-relacto.dat-valid-inic            <= dt-valid
      AND SUBSTRING(sit-tribut-relacto.cod-livre-1,1,2)  = c-uf:
    ASSIGN i-cest = sit-tribut-relacto.cdn-sit-tribut.
END.
IF NOT AVAIL sit-tribut-relacto THEN DO:
    FOR FIRST sit-tribut-relacto
        WHERE sit-tribut-relacto.cdn-tribut                = 11
          AND sit-tribut-relacto.idi-tip-docto             = i-idi-tip-docto
          AND sit-tribut-relacto.cod-estab                 = "*"
          AND sit-tribut-relacto.cod-natur-operac          = c-nat-oper
          AND sit-tribut-relacto.cod-ncm                   = c-ncm
          AND sit-tribut-relacto.cod-item                  = c-item
          AND sit-tribut-relacto.cdn-emitente              = i-emitente
          AND sit-tribut-relacto.dat-valid-inic            <= dt-valid
          AND SUBSTRING(sit-tribut-relacto.cod-livre-1,1,2)  = c-uf:
        ASSIGN i-cest = sit-tribut-relacto.cdn-sit-tribut.
    END.

END.
IF NOT AVAIL sit-tribut-relacto THEN DO:
    FOR FIRST sit-tribut-relacto
        WHERE sit-tribut-relacto.cdn-tribut                = 11
          AND sit-tribut-relacto.idi-tip-docto             = i-idi-tip-docto
          AND sit-tribut-relacto.cod-estab                 = "*"
          AND sit-tribut-relacto.cod-natur-operac          = "*"
          AND sit-tribut-relacto.cod-ncm                   = c-ncm
          AND sit-tribut-relacto.cod-item                  = c-item
          AND sit-tribut-relacto.cdn-emitente              = i-emitente
          AND sit-tribut-relacto.dat-valid-inic            <= dt-valid
          AND substring(sit-tribut-relacto.cod-livre-1,1,2)  = c-uf:
        ASSIGN i-cest = sit-tribut-relacto.cdn-sit-tribut.
    END.

END.
IF NOT AVAIL sit-tribut-relacto THEN DO:
    FOR FIRST sit-tribut-relacto
        WHERE sit-tribut-relacto.cdn-tribut                = 11
          AND sit-tribut-relacto.idi-tip-docto             = i-idi-tip-docto
          AND sit-tribut-relacto.cod-estab                 = "*"
          AND sit-tribut-relacto.cod-natur-operac          = "*"
          AND sit-tribut-relacto.cod-ncm                   = c-ncm
          AND sit-tribut-relacto.cod-item                  = c-item
          AND sit-tribut-relacto.cdn-emitente              = 0
          AND sit-tribut-relacto.dat-valid-inic            <= dt-valid
          AND substring(sit-tribut-relacto.cod-livre-1,1,2)  = c-uf:
        ASSIGN i-cest = sit-tribut-relacto.cdn-sit-tribut.
    END.

END.
IF NOT AVAIL sit-tribut-relacto THEN DO:
    FOR FIRST sit-tribut-relacto
        WHERE sit-tribut-relacto.cdn-tribut                = 11
          AND sit-tribut-relacto.idi-tip-docto             = i-idi-tip-docto
          AND sit-tribut-relacto.cod-estab                 = "*"
          AND sit-tribut-relacto.cod-natur-operac          = "*"
          AND sit-tribut-relacto.cod-ncm                   = c-ncm
          AND sit-tribut-relacto.cod-item                  = c-item
          AND sit-tribut-relacto.cdn-emitente              = 0
          AND sit-tribut-relacto.dat-valid-inic            <= dt-valid
          AND substring(sit-tribut-relacto.cod-livre-1,1,2)  = "*":
        ASSIGN i-cest = sit-tribut-relacto.cdn-sit-tribut.
    END.

END.
    
IF NOT AVAIL sit-tribut-relacto THEN DO:
    FOR FIRST sit-tribut-relacto
        WHERE sit-tribut-relacto.cdn-tribut                = 11
          AND sit-tribut-relacto.idi-tip-docto             = i-idi-tip-docto
          AND sit-tribut-relacto.cod-estab                 = "*"
          AND sit-tribut-relacto.cod-natur-operac          = "*"
          AND sit-tribut-relacto.cod-ncm                   = "*"
          AND sit-tribut-relacto.cod-item                  = c-item
          AND sit-tribut-relacto.cdn-emitente              = 0
          AND sit-tribut-relacto.dat-valid-inic            <= dt-valid
          AND substring(sit-tribut-relacto.cod-livre-1,1,2)  = "*":
        ASSIGN i-cest = sit-tribut-relacto.cdn-sit-tribut.
    END.

END.

IF NOT AVAIL sit-tribut-relacto THEN DO:
    ASSIGN c-mensagem = "Nao encontrado CEST para esta selecao".
END.
RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
