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
&GLOBAL-DEFINE EXEC-RPC YES
{esp/es0478-rpc.i}
{esp/es0478.i "new"}
{utp/ut-glob.i}

DEF TEMP-TABLE tt-transf NO-UNDO
    FIELD it-codigo AS CHAR
    FIELD depos AS CHAR
    FIELD localizacao AS CHAR
    FIELD quantidade AS DEC
    FIELD nr-ae AS INT
    FIELD sequencia AS INT
    FIELD loc-dest AS CHAR
    FIELD usuario AS CHAR
    INDEX codigo nr-ae sequencia.

def input param pCodEstabel as char no-undo.
DEF INPUT PARAM TABLE FOR tt-transf.
DEF OUTPUT PARAM p-msg-erro AS CHAR NO-UNDO.

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

DO TRANSACTION:

   for each tt-transf:

        run esp/es0478-n.p
            (input tt-transf.it-codigo,                /* item */
             input tt-transf.depos,                    /* deposito de saida */    
             input tt-transf.localizacao,        /* local de saida */
             input tt-transf.quantidade,           /* quantidade total */
             input tt-transf.depos,                    /* deposito de entrada */
             input tt-transf.nr-ae,                /* numero docto */
             input string(tt-transf.sequencia),    /* serie */
             input tt-transf.usuario + " - " + 
                   string(today) +  " - " +
                   string(time,"HH:MM:SS"),    /* historico */
             input tt-transf.nr-ae,                /* numero do AE */
             input tt-transf.sequencia,            /* sequencia do AE */
             input 0,                          /* roteiro */  
             input 0,                          /* nota */
             input no,                         /* baixa parcial */
             input no,                         /* devolucao ou transferencia */
             input 0,                          /* contenedor */
             input 0,                          /* fornecedor */
             input 1,                          /* sequencia inicial */
             input yes,                        /* usa local informado */
             input tt-transf.loc-dest,                 /* local destino */
             input today,                      /* data movto-estoq */
             input ?,                          /* Validade da AE */
             INPUT "escep015",
             input pCodEstabel,
             output table tt-etiqueta,
             OUTPUT p-msg-erro).   
    end.

    if l-deu-erro then do:
        RETURN "NOK".
    end.
end.

RETURN "".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


