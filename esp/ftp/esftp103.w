&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i esftp103 2.00.00.000}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable wh-imprime as handle no-undo.

DEFINE VARIABLE h-escrm001api  AS HANDLE      NO-UNDO.
{method/dbotterr.i}

DEF TEMP-TABLE  tt-nf-astec NO-UNDO
    FIELD cgc             LIKE nota-fiscal.cgc
    FIELD nr-nota-fis     LIKE nota-fiscal.nr-nota-fis
    FIELD serie           LIKE nota-fiscal.serie
    FIELD it-codigo       LIKE it-nota-fisc.it-codigo                  
    FIELD nr-os           LIKE int-ped-item.nr-os
    FIELD guid-os         LIKE int-ped-item.vl-guid-os
    FIELD qt-faturada     AS DEC
    FIELD vl-preuni       LIKE it-nota-fisc.vl-preuni      
    FIELD aliquota-ipi    LIKE it-nota-fisc.aliquota-ipi   
    FIELD vl-ipi-it       LIKE it-nota-fisc.vl-ipi-it      
    FIELD vl-icms-it      LIKE it-nota-fisc.vl-icms-it     
    FIELD vl-bicms-it     LIKE it-nota-fisc.vl-bicms-it    
    FIELD it-substituto   LIKE it-nota-fisc.it-codigo
    FIELD qtd-substituida AS DEC
    FIELD cod-estabel     LIKE it-nota-fisc.cod-estabel 
    FIELD dt-emis-nota    LIKE nota-fiscal.dt-emis-nota
    FIELD nr-conhec       LIKE int-nota-conhec.nr-conhec.

DEFINE VARIABLE de-vl-acum-dup AS DECIMAL     NO-UNDO.
DEF VAR de-vl-total-parcelas AS DEC.

def var h-acomp      as handle no-undo.



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button IMAGE-1 IMAGE-2 RECT-10 RECT-11 ~
RECT-12 c-cod-estabel c-serie c-nr-nota-fis d-data-ini d-data-fim rs-faixa ~
bt-ok bt-cancela bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS c-cod-estabel c-serie c-nr-nota-fis ~
d-data-ini d-data-fim rs-faixa 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-bt-ajuda 
       MENU-ITEM mi-sobre       LABEL "Sobre..."      .


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-cod-estabel AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-nota-fis AS CHARACTER FORMAT "X(7)":U 
     LABEL "Nota" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie AS CHARACTER FORMAT "X(3)":U 
     LABEL "S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE d-data-fim AS DATE FORMAT "99/99/9999":U INITIAL ? 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE VARIABLE d-data-ini AS DATE FORMAT "99/99/9999":U INITIAL ? 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE VARIABLE rs-faixa AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Nota", 1,
"Data", 2
     SIZE 14 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 4.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 2.04.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 2.04.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 78 BY 1.38
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     c-cod-estabel AT ROW 1.75 COL 17 COLON-ALIGNED WIDGET-ID 6
     c-serie AT ROW 2.75 COL 17 COLON-ALIGNED WIDGET-ID 8
     c-nr-nota-fis AT ROW 3.75 COL 17 COLON-ALIGNED WIDGET-ID 10
     d-data-ini AT ROW 6 COL 17 COLON-ALIGNED WIDGET-ID 12
     d-data-fim AT ROW 6 COL 37 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     rs-faixa AT ROW 8.33 COL 19.43 NO-LABEL WIDGET-ID 2
     bt-ok AT ROW 10.13 COL 3
     bt-cancela AT ROW 10.13 COL 14
     bt-ajuda AT ROW 10.13 COL 69
     rt-button AT ROW 9.92 COL 2
     IMAGE-1 AT ROW 5.96 COL 27.86 WIDGET-ID 16
     IMAGE-2 AT ROW 5.96 COL 36.14 WIDGET-ID 18
     RECT-10 AT ROW 1.25 COL 2 WIDGET-ID 20
     RECT-11 AT ROW 5.46 COL 2 WIDGET-ID 22
     RECT-12 AT ROW 7.71 COL 2 WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 12.58
         FONT 7 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Manuten‡Æo <Insira o complemento>"
         HEIGHT             = 10.5
         WIDTH              = 80
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-cadsim 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-incsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-cadsim
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       bt-ajuda:POPUP-MENU IN FRAME f-cad       = MENU POPUP-MENU-bt-ajuda:HANDLE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartWindowCues" w-cadsim _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/*:T SmartWindow,uib,50050
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Manuten‡Æo <Insira o complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Manuten‡Æo <Insira o complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-cadsim
ON CHOOSE OF bt-ajuda IN FRAME f-cad /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancela w-cadsim
ON CHOOSE OF bt-cancela IN FRAME f-cad /* Cancelar */
DO:
  RUN notify ('cancel-record':U).
  APPLY "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-cadsim
ON CHOOSE OF bt-ok IN FRAME f-cad /* OK */
DO:
    DEFINE VARIABLE d-data    AS DATE NO-UNDO.
    DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.

    ASSIGN INPUT FRAME f-cad c-cod-estabel
           INPUT FRAME f-cad c-serie
           INPUT FRAME f-cad c-nr-nota-fis
           INPUT FRAME f-cad d-data-ini
           INPUT FRAME f-cad d-data-fim.

    ASSIGN c-arquivo = "c:\temp\esftp103.txt".

    OUTPUT TO VALUE (c-arquivo).

    RUN esp/crm/escrm001api.p PERSISTENT SET h-escrm001api.       
    
    run utp/ut-acomp.p persistent set h-acomp.
    RUN pi-inicializar in h-acomp (input "Imprimindo...").

    
    IF c-cod-estabel = "" AND
       c-serie       = "" AND
       c-nr-nota-fis = "" THEN DO:
        
        DO d-data = d-data-ini TO d-data-fim:
            FOR EACH nota-fiscal NO-LOCK  
               WHERE nota-fiscal.dt-emis-nota = d-data
                 AND nota-fiscal.dt-cancel    = ? .
    
                RUN pi-acompanhar in h-acomp (input "Nota "  + nota-fiscal.nr-nota-fis + " Data " + STRING(nota-fiscal.dt-emis-nota)).
            
                FIND FIRST ped-venda NO-LOCK
                     WHERE ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli 
                       AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.
                
                IF AVAIL ped-venda 
                    AND (INDEX(ped-venda.observacoes,"Extrato:")        <> 0  
                     OR INDEX(ped-venda.cond-espec,"Extrato:")          <> 0  
                     OR INDEX(ped-venda.cond-espec,"pecas em garantia") <> 0) THEN DO:
                    RUN atualizaPortalAstec.
                END.
            END.
        END.
    END.
    ELSE DO:
        FOR EACH nota-fiscal NO-LOCK  
            WHERE nota-fiscal.cod-estabel = c-cod-estabel
              AND nota-fiscal.serie       = c-serie
              AND nota-fiscal.nr-nota-fis = c-nr-nota-fis:
            
            RUN pi-acompanhar in h-acomp (input "Nota "  + nota-fiscal.nr-nota-fis + " Data " + STRING(nota-fiscal.dt-emis-nota)).
            
            FIND FIRST ped-venda NO-LOCK
                 WHERE ped-venda.nr-pedcli  = nota-fiscal.nr-pedcli 
                   AND ped-venda.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.
            
            IF AVAIL ped-venda 
                AND (INDEX(ped-venda.observacoes,"Extrato:")        <> 0  
                 OR INDEX(ped-venda.cond-espec,"Extrato:")          <> 0  
                 OR INDEX(ped-venda.cond-espec,"pecas em garantia") <> 0) THEN DO:
                
                RUN atualizaPortalAstec.
            END.

        END.
    END.

    DELETE PROCEDURE h-escrm001api.   
    OUTPUT CLOSE.

    RUN WinExec (INPUT "Notepad.exe":U + CHR(32) + c-arquivo,
                 INPUT 1).
    
    RUN pi-finalizar in h-acomp.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-cadsim
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-faixa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-faixa w-cadsim
ON VALUE-CHANGED OF rs-faixa IN FRAME f-cad
DO:
  IF INPUT FRAME f-cad rs-faixa = 1 THEN DO:
      ASSIGN c-cod-estabel:SENSITIVE IN FRAME f-cad = YES
             c-serie      :SENSITIVE IN FRAME f-cad = YES
             c-nr-nota-fis:SENSITIVE IN FRAME f-cad = YES
             d-data-ini   :SENSITIVE IN FRAME f-cad = NO
             d-data-fim   :SENSITIVE IN FRAME f-cad = NO.

      ASSIGN d-data-ini:SCREEN-VALUE IN FRAME f-cad = ?
             d-data-fim:SCREEN-VALUE IN FRAME f-cad = ?.
  END.
  ELSE DO:
      ASSIGN c-cod-estabel:SENSITIVE IN FRAME f-cad = NO
             c-serie      :SENSITIVE IN FRAME f-cad = NO
             c-nr-nota-fis:SENSITIVE IN FRAME f-cad = NO
             d-data-ini   :SENSITIVE IN FRAME f-cad = YES
             d-data-fim   :SENSITIVE IN FRAME f-cad = YES.

      ASSIGN c-cod-estabel:SCREEN-VALUE IN FRAME f-cad = ""
             c-serie      :SCREEN-VALUE IN FRAME f-cad = ""
             c-nr-nota-fis:SCREEN-VALUE IN FRAME f-cad = "".
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadsim 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-cadsim  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-cadsim  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaPortalAstec w-cadsim 
PROCEDURE atualizaPortalAstec :
EMPTY TEMP-TABLE tt-nf-astec.
   
   FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
       
   
       IF NOT CAN-FIND(FIRST int-ped-item-astec
                   WHERE int-ped-item-astec.nome-abrev   = it-nota-fisc.nome-ab-cli
                     AND int-ped-item-astec.nr-pedcli    = it-nota-fisc.nr-pedcli  
                     AND int-ped-item-astec.nr-sequencia = it-nota-fisc.nr-seq-ped 
                     AND int-ped-item-astec.it-codigo    = it-nota-fisc.it-codigo) THEN NEXT.
   
       
       FOR EACH int-ped-item-astec NO-LOCK
           WHERE int-ped-item-astec.cod-estabel  = nota-fiscal.cod-estabel
             AND int-ped-item-astec.serie        = nota-fiscal.serie
             AND int-ped-item-astec.nr-nota-fis  = nota-fiscal.nr-nota-fis
             AND int-ped-item-astec.nr-sequencia = it-nota-fisc.nr-seq-ped
             AND int-ped-item-astec.it-codigo    = it-nota-fisc.it-codigo:        
       CREATE tt-nf-astec.
       ASSIGN tt-nf-astec.cgc               = nota-fiscal.cgc
              tt-nf-astec.nr-nota-fis       = nota-fiscal.nr-nota-fis
              tt-nf-astec.serie             = SUBSTRING(nota-fiscal.serie,1,1)       
              tt-nf-astec.it-codigo         = it-nota-fisc.it-codigo.                  
   
   
       assign tt-nf-astec.nr-os       = TRIM(int-ped-item-astec.nr-os)
              tt-nf-astec.guid-os     = TRIM(int-ped-item-astec.vl-guid-os).
       ASSIGN tt-nf-astec.qt-faturada       = int-ped-item-astec.qt-alocada
              tt-nf-astec.vl-preuni         = it-nota-fisc.vl-preuni      
              tt-nf-astec.aliquota-ipi      = it-nota-fisc.aliquota-ipi   
              tt-nf-astec.vl-ipi-it         = tt-nf-astec.qt-faturada * it-nota-fisc.vl-ipi-it / it-nota-fisc.qt-faturada[2]         
              tt-nf-astec.vl-icms-it        = tt-nf-astec.qt-faturada * it-nota-fisc.vl-icms-it / it-nota-fisc.qt-faturada[2]        
              tt-nf-astec.vl-bicms-it       = tt-nf-astec.qt-faturada * it-nota-fisc.vl-bicms-it  / it-nota-fisc.qt-faturada[2].  

                                           
       FIND FIRST ped-item                 
            WHERE ped-item.nome-abrev       = it-nota-fisc.nome-ab-cli
              AND ped-item.nr-pedcli        = it-nota-fisc.nr-pedcli
              AND ped-item.nr-sequencia     = it-nota-fisc.nr-seq-ped
              AND ped-item.it-codigo        = it-nota-fisc.it-codigo
              AND ped-item.cod-refer        = it-nota-fisc.cod-refer NO-LOCK NO-ERROR.
   
       IF AVAIL ped-item AND
          INDEX(ped-item.observacao,"Espdp054 - Substituicao do Item: ") <> 0 THEN
           ASSIGN tt-nf-astec.it-substituto = ENTRY(1, TRIM(SUBSTRING(ped-item.observacao,INDEX(ped-item.observacao,"Espdp054 - Substituicao do Item: ") + 33,LENGTH(ped-item.observacao))), ",":U) 
                  tt-nf-astec.qtd-substituida = DEC(ENTRY(2, TRIM(SUBSTRING(ped-item.observacao,INDEX(ped-item.observacao,"Espdp054 - Substituicao do Item: ") + 33,LENGTH(ped-item.observacao))), ",":U)).
                  
       ASSIGN tt-nf-astec.cod-estabel       = it-nota-fisc.cod-estabel 
              tt-nf-astec.dt-emis-nota      = nota-fiscal.dt-emis-nota.
   
       FIND FIRST int-nota-conhec
           WHERE int-nota-conhec.cod-estabel = nota-fiscal.cod-estabel
             AND int-nota-conhec.serie       = nota-fiscal.serie
             AND int-nota-conhec.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
   
       
       IF AVAILABLE int-nota-conhec THEN
          ASSIGN tt-nf-astec.nr-conhec       = int-nota-conhec.nr-conhec.

       end.
   END.
    
   IF CAN-FIND (FIRST tt-nf-astec) THEN DO:
       PUT "Integrando... " nota-fiscal.nr-nota-fis SKIP.
       RUN integraNFASTEC IN h-escrm001api (INPUT TABLE tt-nf-astec, 
                                            OUTPUT TABLE rowErrors).

   END.
     
    
    IF can-find(FIRST rowErrors) THEN DO:
        FOR EACH rowErrors:
            PUT "Erro : " rowErrors.errorDescription FORMAT "X(100)" SKIP
                " Nota : " nota-fiscal.nr-nota-fis " " nota-fiscal.serie " " nota-fiscal.cod-estabel SKIP.
   
        END.
        UNDO, LEAVE.
    END.
    ELSE PUT "Integra‡ao Efetuada " nota-fiscal.nr-nota-fis " " nota-fiscal.serie " " nota-fiscal.cod-estabel SKIP.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-cadsim  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
  THEN DELETE WIDGET w-cadsim.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-cadsim  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY c-cod-estabel c-serie c-nr-nota-fis d-data-ini d-data-fim rs-faixa 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  ENABLE rt-button IMAGE-1 IMAGE-2 RECT-10 RECT-11 RECT-12 c-cod-estabel 
         c-serie c-nr-nota-fis d-data-ini d-data-fim rs-faixa bt-ok bt-cancela 
         bt-ajuda 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-cadsim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-cadsim 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-cadsim 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-cadsim 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}

  {utp/ut9000.i "esftp103" "2.00.00.000"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN dispatch  IN this-procedure ('enable-fields':U).

  APPLY "VALUE-CHANGED" TO rs-faixa IN FRAME f-cad.
  {include/i-inifld.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-cadsim  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartWindow, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-cadsim 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



PROCEDURE WinExec EXTERNAL "kernel32.dll":U:
    DEF INPUT  PARAM prg_name   AS CHARACTER.
    DEF INPUT  PARAM prg_style  AS SHORT.
END PROCEDURE.
