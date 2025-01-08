
&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : esapi/ESAPI020.p
    Purpose     : Impress∆o das AE's
    Author(s)   : Heron Luis de Borba (Sensus)
    Created     : 24/06/2013
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE STREAM sZebra.

DEFINE VARIABLE i-ordem AS INTEGER NO-UNDO.


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

&IF DEFINED(EXCLUDE-pi-imprime-AE) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-imprime-AE Procedure 
PROCEDURE pi-imprime-AE :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p_imp AS CHARACTER NO-UNDO.       /* impressora selecionada */
    DEFINE INPUT PARAMETER p_cod-estabel AS CHAR NO-UNDO. /* Estabelecimento        */
    DEFINE INPUT PARAMETER p_nr-ae AS INTEGER NO-UNDO.       /* nr-AE                  */
    DEFINE INPUT PARAMETER p_seq AS INTEGER NO-UNDO.         /* sequencia              */
    DEFINE INPUT PARAMETER p_usuario AS CHARACTER NO-UNDO.   /* usuario                */

    DEF VAR v_nom_disposit_so AS CHAR NO-UNDO.
    DEFINE VARIABLE cPrinter AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cLayout AS CHARACTER   NO-UNDO.
    DEF VAR c-linha AS CHAR NO-UNDO.
    DEF VAR i-it-digito     AS INT FORMAT "9" NO-UNDO.

    /* busca dispositivo de impress∆o */
    ASSIGN v_nom_disposit_so = "".
    IF NUM-ENTRIES(p_imp, ":":U) = 2 THEN DO:
        
        ASSIGN cPrinter = SUBSTRING(p_imp, 1, INDEX(p_imp, ":":U) - 1)
               cLayout  = SUBSTRING(p_imp, INDEX(p_imp, ":":U) + 1, LENGTH(p_imp) - INDEX(p_imp, ":":U)).
    
        FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
             WHERE imprsor_usuar.nom_impressora = cPrinter
               AND imprsor_usuar.cod_usuario    = p_usuario NO-LOCK NO-ERROR.
        
        IF AVAIL imprsor_usuar THEN
            ASSIGN v_nom_disposit_so = imprsor_usuar.nom_disposit_so.
        ELSE ASSIGN v_nom_disposit_so = p_imp. /* Necess†rio para impress∆o em arquivo - RPC */

    END.
    ELSE ASSIGN v_nom_disposit_so = p_imp. /* Necess†rio para impress∆o em arquivo - RPC */

    FIND FIRST ae-item WHERE ae-item.cod-estabel = p_cod-estabel AND
                             ae-item.nr-ae = p_nr-ae AND
                             ae-item.sequencia = p_seq NO-LOCK NO-ERROR.
    IF  AVAIL ae-item THEN DO:
        FIND FIRST ITEM WHERE ITEM.it-codigo = ae-item.it-codigo NO-LOCK NO-ERROR.

        assign c-linha = ae-item.it-codigo   +
                         string(ae-item.quantidade,"99999") +
                         string(ae-item.nr-ae,"9999999") +
                         string(ae-item.sequencia,"999").
    
        /*Calcula digito verificador*/
                                                                         
        run esp/es0135(input c-linha,output i-it-digito).
                                                                           
        assign c-linha = c-linha + string(i-it-digito,"9").
    
    
        IF v_nom_disposit_so <> "" THEN DO:

            OUTPUT TO VALUE(v_nom_disposit_so).
            
            PUT "^XA"         SKIP. /* Inicio Label                    */
            PUT "^PW832"      SKIP. /* Width 832                       */
            PUT "^MNY"        SKIP. /* Papel de etiquetas n∆o continuo */
            PUT "^MTT"        SKIP. /* Papel Comum - usa ribon         */
            PUT "^BY2"        SKIP. /* Magnitude EAN                   */ 
            PUT "^PRA"        SKIP. /* Velocidade 50mm/seg             */
            PUT "^JUS"        SKIP. /* Grava Configuracao              */
            PUT "^XZ"         SKIP.
    
            PUT UNFORMATTED
                "^XA" SKIP
                "^FO30,36^A0N,40,40^FD"       ae-item.it-codigo   "^FS" format "x(70)" SKIP
                "^FO300,95^A0N,40,40^FD"      ae-item.localizacao "^FS" format "x(70)" SKIP  

                "^FO300,30^BY2^BCN,32,N,N,N,N^FD" ae-item.it-codigo "^FS" SKIP
                "^FO380,65^A0N,20,25^FD"       ae-item.it-codigo   "^FS" format "x(70)" SKIP
    
                "^FO30,85^A0N,25,25^FDAE:"   + string(ae-item.nr-ae,"9999999") + "^FS" SKIP                                 
                
                "^FO30,115^A0N,20,20^FDROT:" + STRING(ae-item.roteiro,">>>>>>9") + "^FS" SKIP
                "^FO150,115^A0N,20,20^FDNF:"     + STRING(ae-item.nf,"9999999") + "^FS" SKIP
                /* "^FO240,115^A0N,18,18^FDP/N:"    ae-item.it-fabric FORMAT "x(30)" "^FS" SKIP */

                "^FO30,140^A0N,22,22^FD" substring(ITEM.desc-item,01,46) format "x(46)" "^FS" SKIP
                "^FO30,163^A0N,22,22^FD" substring(ITEM.desc-item,47,46) format "x(46)" "^FS" SKIP
                
                "^FO30,190^A0N,25,25^FDSEQ:" + string(ae-item.sequencia,"999") + "^FS" SKIP
                "^FO30,220^A0N,25,25^FD"       ae-item.data FORMAT "99/99/9999" "^FS" SKIP

                "^FO240,195^A0N,60,40^FD" + string(ae-item.quantidade,">>>,>>9") + "^FS" SKIP

                "^FO400,225^A0N,20,20^FD"        p_usuario                        "^FS" SKIP 
                "^FO500,225^A0N,20,20^FD"        + string(TIME,"hh:mm")         + "^FS" SKIP.

            IF ae-item.situacao = NO THEN
                PUT UNFORMATTED
                    "^FO50,250^BAN,50,Y,N,N^BY2^FD" + c-linha + "^FS" SKIP.
             
            PUT UNFORMATTED 
                "^FO650,65,1^A0R,60,50^FD" STRING(TODAY,'99/99/9999') "^FS" SKIP
                "^FO730,30,1^A0R,60,60^FDOP: " + STRING(i-ordem) + "^FS"     SKIP.

                
            PUT UNFORMATTED 
                "^PQ" STRING(1, "99999") SKIP
                "^XZ" SKIP.
            
            OUTPUT CLOSE.
        END.
    END.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-imprime-AE Procedure 
PROCEDURE pi-grava-op :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-ordem AS INT NO-UNDO.

    ASSIGN i-ordem = p-ordem.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ENDIF



