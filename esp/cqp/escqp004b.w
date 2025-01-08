&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i escqp004b 2.04.000.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        escqp004b
&GLOBAL-DEFINE Version        2.04.000.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btCancela btOK fi-desc-item fi-it-codigo fi-quantidade ~
                              fi-nome-abrev fi-cod-fabric fi-etiquetas 

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAM p-rec-ficha-cq AS ROWID NO-UNDO.
DEFINE INPUT  PARAM p-nom-impressora AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER pcod-fabric AS CHARACTER NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */

def SHARED var i-quantidade-s   like ficha-cq.qt-original NO-UNDO.
def SHARED var i-cod-fabric-s   as int NO-UNDO.
def SHARED var c-localizacao-s like movto-estoq.cod-localiz NO-UNDO.

DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-20 fi-quantidade fi-etiquetas ~
fi-cod-fabric btOK btCancela 
&Scoped-Define DISPLAYED-OBJECTS fi-it-codigo fi-desc-item fi-quantidade ~
fi-nr-ficha fi-etiquetas fi-cod-fabric fi-nome-abrev 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancela 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-cod-fabric AS INTEGER FORMAT ">,>>>,>>9" INITIAL 0 
     LABEL "Fabricante" 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-item AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 52 BY .88 NO-UNDO.

DEFINE VARIABLE fi-etiquetas AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Etiquetas" 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Item":R5 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-abrev AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 24 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-ficha AS INTEGER FORMAT ">>>>,>>9" INITIAL 0 
     LABEL "Roteiro" 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-quantidade AS DECIMAL FORMAT ">>>>>,>>9.9999" INITIAL 0 
     LABEL "Quantidade":R22 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-it-codigo AT ROW 1.17 COL 17 COLON-ALIGNED HELP
          "C¢digo do Item" NO-TAB-STOP 
     fi-desc-item AT ROW 1.17 COL 35.57 NO-LABEL NO-TAB-STOP 
     fi-quantidade AT ROW 2.17 COL 17 COLON-ALIGNED
     fi-nr-ficha AT ROW 3.17 COL 17 COLON-ALIGNED HELP
          "N£mero do Roteiro de Inspeá∆o" NO-TAB-STOP 
     fi-etiquetas AT ROW 4.17 COL 17 COLON-ALIGNED
     fi-cod-fabric AT ROW 5.17 COL 17 COLON-ALIGNED HELP
          "Informe o codigo do fabricante"
     fi-nome-abrev AT ROW 5.17 COL 26.43 COLON-ALIGNED HELP
          "Informe o nome do fabricante" NO-LABEL NO-TAB-STOP 
     btOK AT ROW 6.54 COL 2
     btCancela AT ROW 6.54 COL 12
     RECT-20 AT ROW 6.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 6.83
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window Template
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 6.92
         WIDTH              = 90
         MAX-HEIGHT         = 19.88
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 19.88
         VIRTUAL-WIDTH      = 90
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{utp/utapi019.i}
{esp/ShowMsg.i}
{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fi-desc-item IN FRAME fpage0
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       fi-desc-item:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN fi-it-codigo IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       fi-it-codigo:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN fi-nome-abrev IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       fi-nome-abrev:READ-ONLY IN FRAME fpage0        = TRUE.

/* SETTINGS FOR FILL-IN fi-nr-ficha IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       fi-nr-ficha:READ-ONLY IN FRAME fpage0        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "choose":U TO btCancela IN FRAME fpage0.
  RETURN "NOK".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancela wWindow
ON CHOOSE OF btCancela IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN "NOK".
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
  IF INPUT FRAME fpage0 fi-etiquetas > 0 THEN RUN imprime-hml.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-fabric
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-fabric wWindow
ON F5 OF fi-cod-fabric IN FRAME fpage0 /* Fabricante */
DO:
    {include/zoomvar.i &prog-zoom="eszoom/z01es110.w"
                       &campo="fi-cod-fabric"
                       &campozoom="cod-fabric"
                       &frame="fpage0"
                       &parametros="run setInitials in wh-pesquisa (input ficha-cq.it-codigo, input ficha-cq.it-codigo)."}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-fabric wWindow
ON LEAVE OF fi-cod-fabric IN FRAME fpage0 /* Fabricante */
DO:
    {include/leave.i &tabela=mgesp.fabricante
                     &atributo-ref=nome-abrev
                     &variavel-ref=fi-nome-abrev
                     &where="mgesp.fabricante.cod-fabric = input frame fpage0 fi-cod-fabric"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-fabric wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-fabric IN FRAME fpage0 /* Fabricante */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo wWindow
ON LEAVE OF fi-it-codigo IN FRAME fpage0 /* Item */
DO:
    {include/leave.i &tabela=item
                     &atributo-ref=desc-item
                     &variavel-ref=fi-desc-item
                     &where="item.it-codigo = fi-it-codigo:screen-value in frame fpage0"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterinitializeInterface wWindow 
PROCEDURE AfterinitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR FIRST ficha-cq NO-LOCK
        WHERE ROWID(ficha-cq) = p-rec-ficha-cq:
    END.
    DISP i-quantidade-s @ fi-quantidade 
         i-cod-fabric-s @ fi-cod-fabric 
         ficha-cq.nr-ficha @ fi-nr-ficha
         ficha-cq.it-codigo @ fi-it-codigo
         WITH FRAME fpage0.
    APPLY "leave" TO fi-cod-fabric IN FRAME fpage0.
    APPLY "leave" TO fi-it-codigo IN FRAME fpage0.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE imprime-hml wWindow 
PROCEDURE imprime-hml :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR i-it-digito       AS   INT NO-UNDO.
    DEF VAR c-linha           AS   CHAR NO-UNDO.
    DEF VAR v_nom_disposit_so LIKE imprsor_usuar.nom_disposit_so NO-UNDO.
    DEF VAR cPrinter          AS   CHAR NO-UNDO.
    DEF VAR cLayout           AS   CHAR NO-UNDO.

    /* busca dispositivo de impress∆o */
    ASSIGN v_nom_disposit_so = "".
    IF NUM-ENTRIES(p-nom-impressora, ":":U) = 2 THEN DO:
    
        ASSIGN cPrinter = SUBSTRING(p-nom-impressora, 1, INDEX(p-nom-impressora, ":":U) - 1)
               cLayout  = SUBSTRING(p-nom-impressora, INDEX(p-nom-impressora, ":":U) + 1, LENGTH(p-nom-impressora) - INDEX(p-nom-impressora, ":":U)).
    
        FIND FIRST imprsor_usuar USE-INDEX imprsrsr_id
             WHERE imprsor_usuar.nom_impressora = cPrinter
               AND imprsor_usuar.cod_usuario    = c-seg-usuario NO-LOCK NO-ERROR.
        
        IF AVAIL imprsor_usuar THEN ASSIGN v_nom_disposit_so = imprsor_usuar.nom_disposit_so.

    END.
    ELSE ASSIGN v_nom_disposit_so = "".

    IF  v_nom_disposit_so <> "" THEN DO:
        
        FOR FIRST ficha-cq NO-LOCK
            WHERE ROWID(ficha-cq) = p-rec-ficha-cq:
        END.
        FOR FIRST ITEM OF ficha-cq NO-LOCK:
        END.

        ASSIGN INPUT FRAME fpage0 fi-cod-fabric fi-etiquetas fi-nome-abrev fi-quantidade.

        ASSIGN pcod-fabric = string(fi-cod-fabric).

        output to value(v_nom_disposit_so) page-size 0 convert target SESSION:CHARSET. 

        DISP
 
        "^XA" skip

        "^PW832"      SKIP   /* Novo comando para zebra 600 */
        "^JUS"        SKIP   /* Novo comando para zebra 600 */
        
        "^FO20,20^CF0^A0N,40,40^FDHOMOLOGACAO^FS" skip
 
        "^FO20,100^CF0^A0N,19,17^FDItem: " + 
        substring(item.it-codigo,1,6) + "-" +
        substring(item.it-codigo,7,1) +
        "^FS" format "x(70)" skip
        "^FO20,140^CF0^A0N,15,10^FD" +
         item.descricao-1 + item.descricao-2 + 
         "^FS" format "x(120)" skip
        
        "^FO20,180^CF0^A0N,19,17^FDQuantidade: "  +
        string(fi-quantidade / fi-etiquetas,">>,>>>,>>9.99") + "^FS" 
        format "x(70)" skip
        "^FO20,220^CF0^A0N,19,17^FDFabricante: "  +
        fi-nome-abrev + "^FS" format "x(70)" skip
        
        "^FO20,250^A0N,19,17^FDLocalizacao: " + c-localizacao-s + "^FS" format "x(70)" skip        
        "^FO20,300^A0N,19,17^FDROT: " +
        string(ficha-cq.nr-ficha,">>>>>9") + "^FS" 
        format "x(70)"                                 skip
        
        "^FO500,100^A0B,25,12,^FR^FD"
           today format "99/99/9999"
        "^FS" skip               
        
        "^PQ" + string(fi-etiquetas,"999") + "^FS"    
        
        " ^XZ"  with width 132 STREAM-IO NO-BOX.

    END. /* IF  v_nom_disposit_so <> "" THEN DO: */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

