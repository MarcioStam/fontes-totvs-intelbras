&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*------------------------------------------------------------------------
    File        : ESAPI001.I
    Purpose     : Defini‡Æo da tabela de parƒmetros para o ESAPI001.P

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF TEMP-TABLE tt-transferencia NO-UNDO
    FIELD it-codigo LIKE ITEM.it-codigo
    FIELD nr-ficha LIKE ficha-cq.nr-ficha
    FIELD cod-depos-sai LIKE deposito.cod-depos
    FIELD cod-localiz-sai LIKE mgcad.localizacao.cod-localiz
    FIELD nr-ae LIKE ae-item.nr-ae
    FIELD sequencia LIKE ae-item.sequencia
    FIELD codigo-rejei LIKE cod-rejeicao.codigo-rejei
    FIELD cod-depos-ent LIKE deposito.cod-depos
    FIELD observacao AS CHAR
    FIELD cod-localiz-ent LIKE mgcad.localizacao.cod-localiz
    FIELD retira-de AS LOGICAL FORMAT "Aprovada/Condicional"
    FIELD quantidade LIKE ficha-cq.qt-original
    FIELD qt-aprovada LIKE ficha-cq.qt-aprovada
    FIELD qt-rejeitada LIKE ficha-cq.qt-rejeitada
    FIELD qt-apr-cond LIKE ficha-cq.qt-apr-cond
    FIELD dt-validade AS DATE
    FIELD contenedor AS DECIMAL
    FIELD narrativa LIKE ficha-cq.narrativa
    FIELD destino AS INTEGER
    FIELD impressora AS CHAR.

def temp-table tt-ae NO-UNDO
    field c-selecionado as logical format "X/ " label "S" initial no
    field nr-ae like ae-item.nr-ae format ">>>>>>9"
    field sequencia like ae-item.sequencia format ">>9"
    field localizacao like ae-item.localizacao
    field quantidade like ficha-cq.qt-original
    field tipo as logical format "total/parcial" initial yes
    field qtd-par like ae-item.quantidade
    field roteiro like ae-item.roteiro
    field nf like ae-item.nf
    field data like ae-item.data
    field cod-emitente like emitente.cod-emitente.

DEF TEMP-TABLE tt-ae-raw NO-UNDO
    FIELD ae-raw AS RAW.

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


