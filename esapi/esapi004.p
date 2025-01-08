&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : esapi004.p
    Purpose     : Busca informa‡äes iten de acordo com leitor de etiqueta

    Syntax      :

    Description :

    Author(s)   : Carlos Daniel
    Created     : 17/03/2016
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{esapi/esapi004tt.i}

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

&IF DEFINED(EXCLUDE-checa-ean) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checa-ean Procedure 
PROCEDURE checa-ean :
/*------------------------------------------------------------------------------
  Purpose: Copiado procedure do programa rpc/centraldeservicos.p     
  Notes:   Carlos Daniel - 17/03/2016
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-ean AS CHARACTER.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-ean.

DEFINE VARIABLE vcont AS INTEGER.

FIND FIRST item-mat
   WHERE item-mat.cod-ean = c-ean NO-LOCK NO-ERROR.

IF NOT AVAIL item-mat THEN DO:

    FIND FIRST num-serie WHERE num-serie.n-serie = c-ean NO-LOCK NO-ERROR.

    IF NOT AVAIL num-serie THEN DO:
        FIND FIRST item-mat NO-LOCK
            WHERE item-mat.it-codigo = c-ean NO-ERROR.

        IF AVAIL item-mat THEN
            ASSIGN c-ean = item-mat.cod-ean.
        ELSE DO:
            CREATE tt-ean.
            ASSIGN tt-ean.cod-ean13 = c-ean
                   tt-ean.it-codigo = ""
                   tt-ean.desc-item = "Item Inv lido"
                   tt-ean.cont      = 1.
        END.
    END.
    ELSE DO:
        FIND FIRST item-mat WHERE item-mat.it-codigo = num-serie.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL item-mat THEN DO:
            ASSIGN c-ean = item-mat.cod-ean.

            IF c-ean = "" THEN DO:
                FIND FIRST item
                    WHERE item.it-codigo = item-mat.it-codigo NO-LOCK NO-ERROR.

                CREATE tt-ean.
                ASSIGN tt-ean.cod-ean13 = ""
                       tt-ean.it-codigo = item-mat.it-codigo
                       tt-ean.desc-item = IF AVAIL item THEN item.desc-item ELSE "Item Inv lido"
                       tt-ean.cont      = 1.
            END.
        END.
    END.

    IF LENGTH(c-ean) = 14 THEN DO:
        FIND FIRST item-dun WHERE item-dun.cod-dun = c-ean NO-LOCK NO-ERROR.
        IF NOT AVAIL item-dun THEN DO:
            CREATE tt-ean.
            ASSIGN tt-ean.cod-ean13 = c-ean
                   tt-ean.it-codigo = ""
                   tt-ean.desc-item = "Item Inv lido"
                   tt-ean.cont      = 1.
        END.
        ELSE DO:
            FIND FIRST item-mat WHERE item-mat.it-codigo = item-dun.it-codigo NO-LOCK NO-ERROR.
            IF AVAIL item-mat THEN DO:
                ASSIGN c-ean = item-mat.cod-ean.

                IF c-ean = "" THEN DO:
                    FIND FIRST ITEM NO-LOCK
                        WHERE ITEM.it-codigo = item-mat.it-codigo NO-ERROR.

                    CREATE tt-ean.
                    ASSIGN tt-ean.cod-ean13 = ""
                           tt-ean.it-codigo = item-mat.it-codigo
                           tt-ean.desc-item = IF AVAIL ITEM THEN ITEM.desc-item ELSE ""
                           tt-ean.cont      = 1.
                END.
            END.
        END.
    END.
END.
              
ASSIGN vcont = 0.
IF c-ean <> "" THEN DO:
    FOR EACH item-mat NO-LOCK
       WHERE item-mat.cod-ean = c-ean:
    
        FIND FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = item-mat.it-codigo NO-ERROR.
    
        ASSIGN vcont = vcont + 1.
    
        CREATE tt-ean.
        ASSIGN tt-ean.cod-ean13 = item-mat.cod-ean
               tt-ean.it-codigo = item-mat.it-codigo
               tt-ean.desc-item = IF AVAIL ITEM THEN ITEM.desc-item ELSE ""
               tt-ean.cont      = vcont.
    END.
END.

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-unid-negoc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-unid-negoc Procedure 
PROCEDURE pi-unid-negoc :
/*------------------------------------------------------------------------------
  Purpose: Retorna unidade de neg¢cio e descri‡Æo    
  Notes:   Carlos Daniel - 17/03/2016
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p-it-codigo AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER p-cod-unid-negoc AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER p-des-unid-negoc AS CHAR NO-UNDO.

ASSIGN p-cod-unid-negoc = ""
       p-des-unid-negoc = "".

FOR FIRST ITEM NO-LOCK
    WHERE ITEM.it-codigo = p-it-codigo:

    FOR FIRST unid-negoc NO-LOCK
        WHERE unid-negoc.cod-unid-negoc = ITEM.cod-unid-negoc:

        ASSIGN p-cod-unid-negoc = unid-negoc.cod-unid-negoc
               p-des-unid-negoc = unid-negoc.des-unid-negoc.
    END.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

