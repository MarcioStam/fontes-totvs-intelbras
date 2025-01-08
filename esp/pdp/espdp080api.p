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

{esp/pdp/espdp080tt.i}
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

&IF DEFINED(EXCLUDE-piBuscaHist¢rico) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaHist¢rico Procedure 
PROCEDURE piBuscaHist¢rico :
/*------------------------------------------------------------------------------
  Purpose: Retorna hist¢rico da reserva informada
  Notes:   Carlos Daniel - 14/17/2016
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-item-ini  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-item-fim  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-estab-ini AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-estab-fim AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-depos-ini AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-depos-fim AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-usuar-ini AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-usuar-fim AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-hist-reservas-ast.

FOR EACH hist-reservas-ast
    WHERE hist-reservas-ast.it-codigo   >= p-item-ini
    AND   hist-reservas-ast.it-codigo   <= p-item-fim
    AND   hist-reservas-ast.cod-estabel >= p-estab-ini
    AND   hist-reservas-ast.cod-estabel <= p-estab-fim
    AND   hist-reservas-ast.cod-depos   >= p-depos-ini
    AND   hist-reservas-ast.cod-depos   <= p-depos-fim
    AND   hist-reservas-ast.cd-usuario  >= p-usuar-ini
    AND   hist-reservas-ast.cd-usuario  <= p-usuar-fim NO-LOCK:

    CREATE tt-hist-reservas-ast.
    BUFFER-COPY hist-reservas-ast TO tt-hist-reservas-ast.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piBuscaReservas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaReservas Procedure 
PROCEDURE piBuscaReservas :
/*------------------------------------------------------------------------------
  Purpose: Retorna reservas do usu rio logado    
  Notes:   Carlos Daniel - 06/07/2016
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER TABLE FOR tt-reservas-ast.

FOR EACH reservas-ast
    WHERE reservas-ast.cd-usuario = c-seg-usuario NO-LOCK:

    CREATE tt-reservas-ast.
    BUFFER-COPY reservas-ast TO tt-reservas-ast.

    FOR FIRST item FIELDS(desc-item)
        WHERE item.it-codigo = tt-reservas-ast.it-codigo NO-LOCK:

        ASSIGN tt-reservas-ast.desc-item = item.desc-item.
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piEliminaReservas) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEliminaReservas Procedure 
PROCEDURE piEliminaReservas :
/*------------------------------------------------------------------------------
  Purpose: Elimina as reservas selecionadas pelo usu rio    
  Notes:   Carlos Daniel - 06/07/2016
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR tt-reservas-ast.
DEFINE OUTPUT PARAMETER lerro AS LOGICAL NO-UNDO.

ASSIGN lerro = YES.

FOR EACH tt-reservas-ast
    WHERE tt-reservas-ast.lselecionado:

    FOR FIRST reservas-ast
        OF tt-reservas-ast EXCLUSIVE-LOCK:

        DELETE reservas-ast.
    END.
END.

RELEASE reservas-ast.

ASSIGN lerro = NO.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

