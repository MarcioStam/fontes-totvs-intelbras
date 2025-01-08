
&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : esapi/esapi017.p
    Purpose     : Atualização do campo Necessita Inspeção na Origem

    Syntax      :

    Description : 

    Author(s)   : Maicon Roberto Correa (Sensus)
    Created     : 218/01/2013
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/*{cdp/cd0666.i}
{esapi/esapi016.i}
{upc/btb910za-upc.i}
{esp/es0018.i}

DEFINE BUFFER b-tt-erro FOR tt-erro.

DEFINE NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE v_nom_disposit_so AS CHARACTER   NO-UNDO.
*/

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
         HEIGHT             = 8.38
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */


IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:

    RETURN "NOK":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-atualiza) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza Procedure 
PROCEDURE pi-atualiza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE h-acomp   AS HANDLE             NO-UNDO.
    DEFINE VARIABLE c-fam-aux AS CHAR FORMAT 'X(3)' NO-UNDO.

    RUN utp/ut-acomp PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp (INPUT "Atualizando Dados").

    /* Foi desabilitado o botÆo porque estava eliminando e nÆo refazia a tabela int-item-fornec-estab */
    RUN pi-desabilita-cancela IN h-acomp.

    FOR EACH int-item-fornec-estab EXCLUSIVE-LOCK:
        DELETE int-item-fornec-estab.
    END.

    FOR EACH item-insp USE-INDEX dt-fim NO-LOCK
        WHERE item-insp.dt-fim-val > NOW
        BY item-insp.it-fam
        BY item-insp.sequen:
        
        /*Valido para as familias dos itens que come‡am com 4 apenas*/
        IF LENGTH(item-insp.it-fam) = 3 AND
           SUBSTR(item-insp.it-fam,2,1) = '*' THEN
            ASSIGN c-fam-aux = SUBSTR(item-insp.it-fam,1,1).
        ELSE
            ASSIGN c-fam-aux = item-insp.it-fam.
            
        
        FOR EACH item-fornec-estab USE-INDEX item-emit-est NO-LOCK
            WHERE (item-fornec-estab.it-codigo    = item-insp.it-codigo       OR (item-insp.it-codigo   = "*" AND item-fornec-estab.it-codigo BEGINS TRIM(c-fam-aux)))
            AND   (item-fornec-estab.item-do-forn = item-insp.cod-fabric      OR item-insp.cod-fabric  = "*")
            AND   (item-fornec-estab.cod-estabel  = item-insp.cod-estabel     OR item-insp.cod-estabel = "*"):

            RUN pi-acompanhar IN h-acomp (INPUT "Item: " + item-fornec-estab.it-codigo + " - Fabric: " + item-fornec-estab.item-do-forn + " - Estab: " + item-fornec-estab.cod-estabel).

            FOR FIRST int-item-fornec-estab EXCLUSIVE-LOCK
                WHERE int-item-fornec-estab.it-codigo    = item-fornec-estab.it-codigo
                AND   int-item-fornec-estab.cod-emitente = item-fornec-estab.cod-emitente
                AND   int-item-fornec-estab.cod-estabel  = item-fornec-estab.cod-estabel:
            END.

            IF NOT AVAIL int-item-fornec-estab THEN DO:

                CREATE int-item-fornec-estab.
                ASSIGN int-item-fornec-estab.it-codigo    = item-fornec-estab.it-codigo   
                       int-item-fornec-estab.cod-emitente = item-fornec-estab.cod-emitente
                       int-item-fornec-estab.cod-estabel  = item-fornec-estab.cod-estabel.

            END.

            ASSIGN int-item-fornec-estab.log-nec-inspec = item-insp.log-nec-inspec.

        END.
        
        /*
        FOR EACH int-item-for-PN  NO-LOCK
            WHERE (int-item-for-PN.it-codigo      = item-insp.it-codigo       OR (item-insp.it-codigo   = "*" AND int-item-for-PN.it-codigo BEGINS TRIM(c-fam-aux)))
            AND   (int-item-for-PN.item-do-forn   = item-insp.cod-fabric      OR item-insp.cod-fabric  = "*"):
        
            FOR EACH item-fornec-estab NO-LOCK
                WHERE item-fornec-estab.it-codigo     = int-item-for-PN.it-codigo
                  AND (item-fornec-estab.cod-estabel  = item-insp.cod-estabel     OR item-insp.cod-estabel = "*")
                  AND item-fornec-estab.cod-emitente  = int-item-for-PN.cod-emitente:
        
                RUN pi-acompanhar IN h-acomp (INPUT "Item: " + item-fornec-estab.it-codigo + " - Fabric: " + int-item-for-PN.item-do-forn + " - Estab: " + item-fornec-estab.cod-estabel).
        
                FOR FIRST int-item-fornec-estab EXCLUSIVE-LOCK
                    WHERE int-item-fornec-estab.it-codigo    = item-fornec-estab.it-codigo
                    AND   int-item-fornec-estab.cod-emitente = item-fornec-estab.cod-emitente
                    AND   int-item-fornec-estab.cod-estabel  = item-fornec-estab.cod-estabel:
                END.
        
                IF NOT AVAIL int-item-fornec-estab THEN DO:
        
                    CREATE int-item-fornec-estab.
                    ASSIGN int-item-fornec-estab.it-codigo    = item-fornec-estab.it-codigo   
                           int-item-fornec-estab.cod-emitente = item-fornec-estab.cod-emitente
                           int-item-fornec-estab.cod-estabel  = item-fornec-estab.cod-estabel.
        
                END.
        
                ASSIGN int-item-fornec-estab.log-nec-inspec = item-insp.log-nec-inspec.
            END.
        END.
        */

    END.

    RUN pi-finalizar IN h-acomp.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF



