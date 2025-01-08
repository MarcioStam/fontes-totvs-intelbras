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

{utp/ut-glob.i}

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

&IF DEFINED(EXCLUDE-piBloqueiaRequis) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBloqueiaRequis Procedure 
PROCEDURE piBloqueiaRequis :
/*------------------------------------------------------------------------------
  Purpose: Verifica se ‚ permitido a requisi‡Æo de estique     
  Notes:   Carlos Daniel - 04/01/2016
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER lbloqueia AS LOGICAL NO-UNDO.

DEFINE VARIABLE lexcecao AS LOGICAL NO-UNDO.
DEFINE VARIABLE cont     AS INTEGER NO-UNDO.

ASSIGN lexcecao = NO.

FOR EACH esp-bloqueio-requis
    WHERE esp-bloqueio-requis.lbloqueia NO-LOCK:
    
    IF DATE(esp-bloqueio-requis.data-hora) = TODAY AND NOW >= esp-bloqueio-requis.data-hora THEN DO:
        REPEAT cont = 1 TO NUM-ENTRIES(esp-bloqueio-requis.perfil-excecao):
            IF LOOKUP(ENTRY(cont,esp-bloqueio-requis.perfil-excecao),v_cod_grp_usuar_lst) > 0 THEN DO:
                ASSIGN lexcecao = YES.                    
            END.
        END.

        IF NOT lexcecao THEN DO:
            ASSIGN lbloqueia = YES.
        END.
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

