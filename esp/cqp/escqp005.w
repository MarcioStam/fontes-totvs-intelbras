&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESCQP005 2.04.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        ESCQP005
&GLOBAL-DEFINE Version        1
&GLOBAL-DEFINE VersionLayout  1

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Parƒmetros,ImpressÆo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          NO
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   
                              
&GLOBAL-DEFINE Page4Widgets   fi-nr-ficha  
&GLOBAL-DEFINE page3Widgets  
                              
&GLOBAL-DEFINE page5Widgets   
                              
                              
                              
                              
                              
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              cmodel ~
                              rsExecution
&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE Page4Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo text-modelo
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE Page4Fields    fi-nr-ficha  
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile cmodel
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */

{esp/cqp/escqp005tt.i}
{upc/btb910za-upc.i} /* Defini‡Æo do estabelecimento do usu rio */
{esp/es0018.i}

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-rtf              as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.

def stream s-imp.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR gs-nr-ficha LIKE ficha-cq.nr-ficha NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fi-nr-ficha AS INTEGER FORMAT ">>>>,>>9" INITIAL 0 
     LABEL "Roteiro" 
     VIEW-AS FILL-IN 
     SIZE 10.29 BY .88 NO-UNDO.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btmodel 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U NO-FOCUS
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modelo AS CHARACTER FORMAT "X(256)":U INITIAL "Parƒmetros de ImpressÆo" 
      VIEW-AS TEXT 
     SIZE 20 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsDestiny AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3,
"E-Mail", 4
     SIZE 58 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsExecution AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 1.71.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 1.71.

DEFINE VARIABLE cmodel AS LOGICAL INITIAL no 
     LABEL "Imprimir p gina de parƒmetros" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage4
     fi-nr-ficha AT ROW 2 COL 10.14 COLON-ALIGNED HELP
          "N£mero do Roteiro de Inspe‡Æo"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.79
         SIZE 84.43 BY 11.96
         FONT 1.

DEFINE FRAME fPage6
     btmodel AT ROW 7.75 COL 43 HELP
          "Escolha do nome do arquivo" NO-TAB-STOP 
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     btFile AT ROW 3.5 COL 43 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.5 COL 43 HELP
          "Configura‡Æo da impressora"
     cFile AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 5.75 COL 2.86 HELP
          "Modo de Execu‡Æo" NO-LABEL
     cmodel AT ROW 8 COL 2.86
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.14 COLON-ALIGNED NO-LABEL
     text-modelo AT ROW 7.25 COL 1.14 COLON-ALIGNED NO-LABEL AUTO-RETURN 
     RECT-9 AT ROW 7.54 COL 2
     RECT-13 AT ROW 5.29 COL 2
     RECT-7 AT ROW 1.92 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
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
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 114.29
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wReport 
/* ************************* Included-Libraries *********************** */

{esp/ShowMsg.i}
{Report\Report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FRAME fPage6
                                                                        */
/* SETTINGS FOR BUTTON btmodel IN FRAME fPage6
   NO-ENABLE                                                            */
ASSIGN 
       btmodel:HIDDEN IN FRAME fPage6           = TRUE.

/* SETTINGS FOR TOGGLE-BOX cmodel IN FRAME fPage6
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR RECTANGLE RECT-9 IN FRAME fPage6
   NO-ENABLE                                                            */
ASSIGN 
       RECT-9:HIDDEN IN FRAME fPage6           = TRUE.

ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

/* SETTINGS FOR FILL-IN text-modelo IN FRAME fPage6
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execu‡Æo".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage6
/* Query rebuild information for FRAME fPage6
     _Query            is NOT OPENED
*/  /* FRAME fPage6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wReport
ON CHOOSE OF btConfigImpr IN FRAME fPage6
DO:
   {report/rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wReport
ON CHOOSE OF btFile IN FRAME fPage6
DO:
    {report/rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wReport
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btmodel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btmodel wReport
ON CHOOSE OF btmodel IN FRAME fPage6
DO:
    {report/rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wReport
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
   do  on error undo, return no-apply:
       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME fi-nr-ficha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-ficha wReport
ON F5 OF fi-nr-ficha IN FRAME fPage4 /* Roteiro */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z02in124.w"
                       &campo="fi-nr-ficha"
                       &campozoom="nr-ficha"
                       &frame="fpage4"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-ficha wReport
ON MOUSE-SELECT-DBLCLICK OF fi-nr-ficha IN FRAME fPage4 /* Roteiro */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage6
DO:
do  with frame fPage6:
    case self:screen-value:
        when "1":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes.
        end.
        when "2":U then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no.
        end.
        when "3":U OR when "4":U then do:
            assign cFile:visible         = no
                   cFile:sensitive       = no
                   btFile:visible        = no
                   btConfigImpr:visible  = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsExecution
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsExecution wReport
ON VALUE-CHANGED OF rsExecution IN FRAME fPage6
DO:
   {report/rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


fi-nr-ficha:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage4.

/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{report/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterinitializeInterface wReport 
PROCEDURE AfterinitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    APPLY "value-changed" TO rsDestiny IN FRAME fpage6.
    HIDE btmodel cmodel text-modelo IN FRAME fpage6.
    
    DISP gs-nr-ficha @ fi-nr-ficha WITH FRAME fpage4.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEmail wReport 
PROCEDURE piEmail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM p-enderecos AS CHAR NO-UNDO.
    DEFINE VARIABLE c-lista-es0018 AS CHARACTER   NO-UNDO.

    DEFINE BUTTON btCancela 
         LABEL "&Cancelar" 
         SIZE 10 BY 1.
    
    DEFINE BUTTON btOK 
         LABEL "OK" 
         SIZE 10 BY 1.
    
    DEFINE VARIABLE c-email AS CHARACTER 
         VIEW-AS EDITOR MAX-CHARS 200 SCROLLBAR-VERTICAL
         SIZE 56 BY 7
         BGCOLOR 15  NO-UNDO.
    
    DEFINE RECTANGLE RECT-17
         EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
         SIZE 60 BY 8.5.
    
    DEFINE RECTANGLE RECT-18
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 60 BY 1.5
         BGCOLOR 7 .
    
    
    /* ************************  Frame Definitions  *********************** */
    
    DEFINE FRAME fEmail
         c-email AT ROW 1.5 COL 3 NO-LABEL
         btOK AT ROW 9.79 COL 2
         btCancela AT ROW 9.79 COL 12
         RECT-17 AT ROW 1 COL 1
         RECT-18 AT ROW 9.5 COL 1
         "Digite os endere‡os separados por Ponto e V¡rgula (;), quando mais de um" VIEW-AS TEXT
              SIZE 57 BY .54 AT ROW 8.75 COL 3
         SPACE(1.00) SKIP(1.71)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
             SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
             FONT 1
             TITLE "E-Mails"
             DEFAULT-BUTTON btOK CANCEL-BUTTON btCancela.

    ON 'choose':U OF btOK IN FRAME fEmail
    DO:
        ASSIGN p-enderecos = INPUT FRAME fEmail c-email.
        APPLY "END-ERROR":U TO FRAME fEmail.
        RETURN.
    END.

    ON 'choose':U OF btCancela IN FRAME fEmail
    DO:
        APPLY "END-ERROR":U TO FRAME fEmail.
        RETURN.
    END.

    /*
    IF v_cod_estab_usuar <> "101" THEN DO:
        FOR FIRST ficha-cq FIELDS (it-codigo cod-emitente) NO-LOCK
            WHERE ficha-cq.nr-ficha = INPUT FRAME fpage4 fi-nr-ficha:
            FOR FIRST ITEM FIELDS () NO-LOCK
                WHERE ITEM.it-codigo = ficha-cq.it-codigo,
                FIRST usuar-mater FIELDS (e-mail) NO-LOCK
                WHERE usuar-mater.cod-usuario = ITEM.cod-comprado
                AND   usuar-mater.usuar-comprador:
                c-email = usuar-mater.e-mail.
            END.
            FOR FIRST cont-emit FIELDS (e-mail) NO-LOCK
                WHERE cont-emit.cod-emitente = ficha-cq.cod-emitente:
                IF c-email = "" THEN
                    c-email = cont-emit.e-mail.
                ELSE
                    c-email = c-email + ";" + cont-emit.e-mail.
    
            END.
        END.
    END.



        

    IF v_cod_estab_usuar = "101" THEN DO:

        RUN esp/es0018p.p (INPUT "escqp005", /* Nome do programa */
                           INPUT 1,            /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto).   

        ASSIGN c-lista-es0018 = "".
                           
        FOR EACH tt-prog-ponto:
            ASSIGN c-lista-es0018 = c-lista-es0018 + tt-prog-ponto.conteudo + ";".
        END.

        IF c-lista-es0018 <> "" THEN DO:
         
            IF SUBSTRING(c-lista-es0018, LENGTH(c-lista-es0018), 1) = ";" THEN
                ASSIGN c-lista-es0018 = SUBSTRING(c-lista-es0018, 1, LENGTH(c-lista-es0018) - 1).
    
            IF c-email = "" THEN
                ASSIGN c-email = c-lista-es0018.
            ELSE 
                ASSIGN c-email = c-email + ";" + c-lista-es0018.

        END.

    END.
    */


    FOR FIRST ficha-cq FIELDS (it-codigo cod-emitente cod-estabel) NO-LOCK
        WHERE ficha-cq.nr-ficha = INPUT FRAME fpage4 fi-nr-ficha:
    END.

    IF  AVAIL ficha-cq THEN DO:

        RUN esp/es0018p.p (INPUT "escqp005", /* Nome do programa */
                           INPUT 1,            /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto).   

        ASSIGN c-lista-es0018 = "".

        FOR EACH tt-prog-ponto:

            IF  ENTRY(1,tt-prog-ponto.conteudo,";") <> ficha-cq.cod-estabel  THEN
                NEXT.

            ASSIGN c-lista-es0018 = c-lista-es0018 + ENTRY(2,tt-prog-ponto.conteudo,";") + ";".
        END.

        IF c-lista-es0018 <> "" THEN DO:

            IF SUBSTRING(c-lista-es0018, LENGTH(c-lista-es0018), 1) = ";" THEN
                ASSIGN c-lista-es0018 = SUBSTRING(c-lista-es0018, 1, LENGTH(c-lista-es0018) - 1).

            IF c-email = "" THEN
                ASSIGN c-email = c-lista-es0018.
            ELSE 
                ASSIGN c-email = c-email + ";" + c-lista-es0018.

        END.

    END.

    DISP c-email WITH FRAME fEmail.
    ENABLE c-email btOK btCancela WITH FRAME fEmail.
    VIEW FRAME fEmail.
    WAIT-FOR WINDOW-CLOSE OF FRAME fEmail.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

define var r-tt-digita as rowid no-undo.
DEF VAR i AS INTEGER NO-UNDO.

&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
/*:T** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}

    /*29/12/2004 - tech1007 - Teste alterado para validar o arquivo informado quando for RTF*/
    if ( input frame fPage6 rsDestiny = 2) and
         input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.
    /*
    /*29/12/2004 - tech1007 - Teste criado para validar o modelo informado quando for RTF*/
    IF input frame fPage6 cModel = "" AND
       input frame fPage6 rsDestiny = 4 THEN DO:
        run utp/ut-msgs.p (input "show":U, input 73, input "":U).
        /*30/12/2004 - tech1007 - Evento removido pois causa problemas no WebEnabler*/
        /*apply "CHOOSE":U to btModel in frame fPage6.*/
        return error.
    END.
    */
    /*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
       problemas e colocar o focus no campo com problemas */

    FIND FIRST ficha-cq NO-LOCK
        WHERE ficha-cq.nr-ficha = INPUT FRAME fpage4 fi-nr-ficha NO-ERROR.

    IF NOT AVAIL ficha-cq THEN DO:
        RUN ShowMessage (1, "AE nÆo encontrado", "Verifique o n£mero do roteiro informado").
        APPLY "entry" TO fi-nr-ficha IN FRAME fpage4.
        RETURN ERROR.
    END.

    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.nr-ficha        = INPUT FRAME fPage4 fi-nr-ficha
           tt-param.imprime-param   = INPUT FRAME fPage6 cmodel.
    
    IF tt-param.destino = 4 THEN
        RUN piEmail (OUTPUT tt-param.enderecos).

    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
        then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    
    
    
    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i esp/cqp/escqp005rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

