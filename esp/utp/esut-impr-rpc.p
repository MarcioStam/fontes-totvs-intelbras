&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
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

DEF TEMP-TABLE ttimprsor_usuar NO-UNDO LIKE imprsor_usuar. 
DEF TEMP-TABLE ttimpressora NO-UNDO LIKE impressora. 
DEF TEMP-TABLE ttlayout_impres NO-UNDO LIKE layout_impres. 

DEF INPUT PARAM p_cod_usuario AS CHAR NO-UNDO.
DEF OUTPUT PARAM TABLE FOR ttimprsor_usuar.
DEF OUTPUT PARAM TABLE FOR ttimpressora.
DEF OUTPUT PARAM TABLE FOR ttlayout_impres.

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

    FOR EACH imprsor_usuar NO-LOCK
        WHERE imprsor_usuar.cod_usuario = p_cod_usuario:
        CREATE ttimprsor_usuar.
        BUFFER-COPY imprsor_usuar TO ttimprsor_usuar.
        IF NOT CAN-FIND(FIRST ttimpressora OF ttimprsor_usuar) THEN DO:
            FOR FIRST impressora OF ttimprsor_usuar NO-LOCK:
                CREATE ttimpressora.
                BUFFER-COPY impressora TO ttimpressora.
                FOR EACH layout_impres OF ttimpressora NO-LOCK:
                    CREATE ttlayout_impres.
                    BUFFER-COPY layout_impres TO ttlayout_impres.
                END.
            END.
        END.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


