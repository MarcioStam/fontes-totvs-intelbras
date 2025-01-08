&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&GLOBAL-DEFINE versao   205
define temp-table tt-import-rep-oper no-undo
    field   tipo-rep            as  integer 
    field   nr-ord-produ        as  integer     
    field   num-operac-sfc      as  integer 
    field   num-split-operac    as  integer
    field   cod-roteiro         as  character
    field   op-codigo           as  integer
    field   cod-ctrab           as  character
    field   it-codigo           as  character
    field   cod-refer           as  character
    field   lote-serie          as  character
    field   dat-valid-lote      as  date
    FIELD   per-ppm             LIKE ITEM.per-ppm /*** fator concentracao ppm   ***/
    field   qtd-produzida       as  DECIMAL     /*** quantidade aprovada    ***/
    FIELD   cod-motiv-refugo    AS  CHARACTER
    field   qtd-refugada        as  decimal
    field   qtd-refugada-un-ref  as  decimal
    FIELD   qtd-retrabalho      AS  DECIMAL
    FIELD   conta-refugo        like rep-prod.conta-refugo
    field   dat-inic-rep        as  date
    field   hr-inic-rep         as  decimal
    field   dat-fim-rep         as  date
    field   hr-fim-rep          as  decimal
    field   dat-inic-setup      as  date
    field   hr-inic-setup       as  decimal
    field   dat-fim-setup       as  date
    field   hr-fim-setup        as  decimal
    field   cod-equipe          as  character
    field   cod-operador        as  character   format  "99999-9"
    field   cod-ferramenta      as  character
    FIELD   num-contador-ini    AS  INTEGER
    FIELD   num-contador-fim    AS  INTEGER
    field   finaliza            as  logical
    field   linha               as  integer
    field   erro                as  logical
    index   split   is primary  tipo-rep it-codigo 
    index   num-linha linha.
    
Def temp-table tt-param-reporte
      Field cod-param         as char 
      field des-result-param  as char 
      field log-result-param  as log INIT ?
      field dat-result-param  as date format "99/99/9999" initial ?
      FIELD dec-result-param  AS DEC decimals 10 INIT ?
      field rw-result-param   as rowid 
      FIELD handle-result-param AS HANDLE
      index id                is primary unique
            cod-param.

/*** fim do include ***/

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
         HEIGHT             = 1
         WIDTH              = 38.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


