
&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOTempTable 
/*--------------------------------------------------------------------------
    Library    : dbott.i
    Purpose    : Include que cont‚m defini‡Æo da temptable RowObject

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

&GLOBAL-DEFINE ROW-NUM-DEFINED YES

DEFINE TEMP-TABLE {1} NO-UNDO LIKE wm-box-saldo
&IF "{&ROW-NUM-DEFINED}":U = "YES":U &THEN
    FIELD RowNum AS INTEGER INIT 1
&ENDIF
    FIELD r-Rowid AS ROWID.

DEFINE VARIABLE c-cod-item  LIKE wm-box-saldo.cod-item  NO-UNDO.       
DEFINE VARIABLE d-qtd-item  LIKE wm-box-saldo.qtd-item  NO-UNDO. 
DEFINE VARIABLE c-cod-refer LIKE wm-box-saldo.cod-refer NO-UNDO.                           
DEFINE VARIABLE d-id-docto  LIKE wm-box-saldo.id-docto  NO-UNDO.

DEFINE TEMP-TABLE tt-saldo NO-UNDO
    FIELD cod-lote         LIKE  wm-box-saldo.cod-lote
    FIELD dt-validade-lote LIKE  wm-saldo-estoque.dt-validade-lote
    FIELD dt-transacao     LIKE  wm-box-saldo.dt-transacao
    FIELD id-box           LIKE  wm-box-saldo.id-box
    FIELD ind-status-saldo LIKE  wm-box-saldo.ind-status-saldo
    FIELD cod-embalagem    LIKE  wm-box-saldo.cod-embalagem
    FIELD qtd-original     LIKE  wm-box-saldo.qtd-original
    FIELD qtd-item         LIKE  wm-box-saldo.qtd-item
    FIELD qtd-embalagem    LIKE  wm-box-movto.qti-embalagem
    FIELD qtd-retirar      LIKE  wm-box-saldo.qtd-item.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOTempTable
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOTempTable ASSIGN
         HEIGHT             = 2.5
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOTempTable 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



