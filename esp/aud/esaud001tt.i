&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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

define temp-table ttAuditEvent no-undo
   field banco as character format 'x(8)'
   field tabela as character format 'x(30)'
   field pk as character format 'x(40)'
   field usuario as character format 'x(10)'
   field data as datetime-tz
   field evento as character format 'x(4)'
   field campo as character format 'x(20)'
   field tipo as character format 'x(10)'
   field antigo as character
   field novo as character
   index ch-det is primary data tabela campo.

define temp-table ttBanco no-undo
   field banco as character
   index ch is primary unique banco.

define temp-table ttTabela no-undo
   field banco  as character
   field tabela as character
   index ch is primary unique banco tabela.

define temp-table ttTabelaCampo no-undo
   field banco as character
   field tabela as character
   field campo as character
   index ch is primary unique banco tabela campo.

define temp-table ttEvento no-undo
   field evento as character
   index ch is primary unique evento.

define temp-table ttUsuario no-undo
   field usuario as character
   index ch is primary unique usuario.

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


