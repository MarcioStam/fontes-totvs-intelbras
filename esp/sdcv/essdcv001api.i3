&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : ESSDCV001API.I3
    Purpose     : Integra‡Æo do ERP TOTVS/Datasul EMS 2 com o OutBuyCenter
                  (Grava‡Æo registro tabelas integradas).
    Syntax      : <none>
    Description : <none>

    Author(s)   : Heron Borba (SENSUS)
    Created     : Abril de 2014
    Notes       : <none>
----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-criaRegistros Include 
PROCEDURE pi-criaRegistros :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcod-tabela   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pchave-tabela AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p-situacao    AS INTEGER   NO-UNDO.

/* IF  NOT CAN-FIND(FIRST int-integrado-obc                                        */
/*                  WHERE int-integrado-obc.cod-tabela   = pcod-tabela             */
/*                  AND   int-integrado-obc.chave-tabela = pchave-tabela) THEN DO: */
                 
    CREATE int-integrado-obc.
    ASSIGN int-integrado-obc.cod-tabela    = pcod-tabela
           int-integrado-obc.chave-tabela  = pchave-tabela
           int-integrado-obc.cod-usuario   = c-seg-usuario
           int-integrado-obc.dat-integrado = TODAY
           int-integrado-obc.hra-integrado = STRING(TIME, "HH:MM:SS":U)
           int-integrado-obc.idi-situacao  = p-situacao.
           
/* END. /* IF  NOT CAN-FIND(FIRST int-integrado-obc */ */

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

