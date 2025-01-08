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
{include/i-prgvrs.i esftp066 2.00.00.001}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esftp066
&GLOBAL-DEFINE Version        2.00.00.001
&GLOBAL-DEFINE VersionLayout  

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Sele‡Æo,Parƒmetro,ImpressÆo

&GLOBAL-DEFINE PGLAY          
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          
&GLOBAL-DEFINE PGPAR          YES
&GLOBAL-DEFINE PGDIG          
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          

&GLOBAL-DEFINE page0Widgets   btOk btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   
&GLOBAL-DEFINE page5Widgets    
&GLOBAL-DEFINE page6Widgets   rsDestiny btConfigImpr btFile rsExecution
&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    iNr-embarque
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    rsTpFuncao rsTpVolume
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino             AS INTEGER
    FIELD arquivo             AS CHARACTER FORMAT "x(35)":U
    FIELD usuario             AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec           AS DATE
    FIELD hora-exec           AS INTEGER
    FIELD nr-embarque         LIKE pre-fatur.cdd-embarq
    FIELD tipo-volume         AS INTEGER
    FIELD cod-estabel         AS CHAR
    FIELD tipo-funcao         AS INTEGER.

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.


def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.
DEF VAR c-lista            AS CHAR    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
def stream s-imp.
{upc/btb910za-upc.i}

{utp/ut-glob.i}

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
     SIZE 90 BY 1.43
     BGCOLOR 7 .

DEFINE VARIABLE c-transportadora AS CHARACTER FORMAT "X(256)":U 
     LABEL "Transportadora" 
     VIEW-AS FILL-IN 
     SIZE 28 BY .86 NO-UNDO.

DEFINE VARIABLE iNr-embarque AS INTEGER FORMAT ">>>>,>>9" INITIAL 0 
     LABEL "Embarque":R10 
     VIEW-AS FILL-IN 
     SIZE 8 BY .86.

DEFINE VARIABLE l-separaUf AS LOGICAL INITIAL no 
     LABEL "Separa UF" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.6 BY 1 NO-UNDO.

DEFINE VARIABLE rsTpFuncao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Integra‡Æo", 1,
"Relat¢rio", 2
     SIZE 21.4 BY .86 NO-UNDO.

DEFINE VARIABLE rsTpVolume AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Padrao", 1,
"Fracionada", 2,
"Ambos", 3
     SIZE 36.4 BY .86 NO-UNDO.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .86
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.2 BY .62
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 10.8 BY .62
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsDestiny AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.1
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsExecution AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.8 BY .91
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.2 BY 2.91.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.2 BY 1.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.76 COL 2
     btCancel AT ROW 16.76 COL 13
     btHelp2 AT ROW 16.76 COL 80
     rtToolBar AT ROW 16.52 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.25
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.2 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     btFile AT ROW 3.57 COL 43.2 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.57 COL 43.2 HELP
          "Configura‡Æo da impressora"
     cFile AT ROW 3.62 COL 3.2 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 5.76 COL 3 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.62 COL 1.8 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.2 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.91 COL 2.2
     RECT-9 AT ROW 5.29 COL 2.2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.86 ROW 2.83
         SIZE 84 BY 13.17
         FONT 1.

DEFINE FRAME fPage4
     rsTpFuncao AT ROW 2.14 COL 12.6 NO-LABEL WIDGET-ID 8
     rsTpVolume AT ROW 3.43 COL 12.6 NO-LABEL WIDGET-ID 2
     "Fun‡Æo:" VIEW-AS TEXT
          SIZE 6.2 BY .52 AT ROW 2.29 COL 6 WIDGET-ID 12
     "Volumes:" VIEW-AS TEXT
          SIZE 6.6 BY .52 AT ROW 3.52 COL 5.8 WIDGET-ID 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.86 ROW 2.83
         SIZE 84 BY 13.17
         FONT 1.

DEFINE FRAME fPage2
     iNr-embarque AT ROW 2 COL 26.6 HELP
          "Embarque"
     c-transportadora AT ROW 3 COL 33.2 COLON-ALIGNED WIDGET-ID 2
     l-separaUf AT ROW 4 COL 35.2 WIDGET-ID 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.86 ROW 2.83
         SIZE 84 BY 13.17
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17.24
         WIDTH              = 90
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 195.2
         VIRTUAL-HEIGHT     = 29
         VIRTUAL-WIDTH      = 195.2
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

{Report\Report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN c-transportadora IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN iNr-embarque IN FRAME fPage2
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* SETTINGS FOR FRAME fPage6
                                                                        */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
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


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME iNr-embarque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL iNr-embarque wReport
ON LEAVE OF iNr-embarque IN FRAME fPage2 /* Embarque */
DO:
    FIND FIRST nota-fiscal
        WHERE nota-fiscal.cdd-embarq = integer(iNr-embarque:SCREEN-VALUE IN FRAME fPage2) NO-LOCK NO-ERROR.

    IF AVAIL nota-fiscal THEN DO:
        FIND FIRST transporte
            WHERE transporte.nome-abrev = nota-fiscal.nome-transp NO-LOCK NO-ERROR.

        IF AVAIL transporte THEN DO:
            ASSIGN c-transportadora:SCREEN-VALUE IN FRAME fPage2 = transporte.nome-abrev.

            FIND FIRST int-transporte WHERE int-transporte.cod-transp = transporte.cod-transp NO-LOCK NO-ERROR.

            IF AVAIL int-transporte THEN
                ASSIGN l-separaUf:SCREEN-VALUE IN FRAME fPage2 = string(int-transporte.separa-uf).
            ELSE
                ASSIGN l-separaUf:SCREEN-VALUE IN FRAME fPage2 = STRING(NO).
        END.
        ELSE DO:
            RUN utp/ut-msgs.p (INPUT "SHOW",
                               INPUT 17006,
                               INPUT "Embarque inv lido~~Transportador inv lido para o embquerque informado.").

            ASSIGN c-transportadora:SCREEN-VALUE IN FRAME fPage2 = ""
                   l-separaUf      :SCREEN-VALUE IN FRAME fPage2 = STRING(NO).

            RETURN "NOK".
        END.
    END.
    ELSE DO:
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 17006,
                           INPUT "Embarque inv lido~~NÆo existe nota fiscal para o embarque informado.").

        ASSIGN c-transportadora:SCREEN-VALUE IN FRAME fPage2 = ""
               l-separaUf      :SCREEN-VALUE IN FRAME fPage2 = STRING(NO).

        RETURN "NOK".
    END.
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
        when "3":U then do:
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


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME rsTpFuncao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsTpFuncao wReport
ON VALUE-CHANGED OF rsTpFuncao IN FRAME fPage4
DO:
    IF INTEGER(rsTpFuncao:SCREEN-VALUE) = 1 THEN
        ASSIGN rsTpVolume:SENSITIVE    = NO
               rsTpVolume:SCREEN-VALUE = "3".
    ELSE
        ASSIGN rsTpVolume:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

{report/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterEnableFields wReport 
PROCEDURE AfterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

APPLY "VALUE-CHANGED" TO rsTpFuncao IN FRAME fPage4.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wReport 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN rsTpVolume = 1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-notas-transp-diferentes wReport 
PROCEDURE pi-valida-notas-transp-diferentes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-embarque AS INTEGER NO-UNDO.

    DEF VAR c-transp AS CHAR NO-UNDO.

    FOR EACH nota-fiscal NO-LOCK
        WHERE nota-fiscal.cdd-embarq = p-embarque:
        IF  c-transp = "" THEN
            ASSIGN c-transp = nota-fiscal.nome-transp.

        IF  c-transp <> nota-fiscal.nome-transp THEN
            RETURN "NOK".
    END.

    /*
    /*Via Pedido*/
    FOR EACH  pre-fatur NO-LOCK     
        WHERE pre-fatur.cdd-embarq = p-embarque
        , EACH it-pre-fat NO-LOCK OF pre-fatur:

        FIND FIRST ped-ent NO-LOCK
            WHERE ped-ent.nome-abrev   = it-pre-fat.nome-abrev
              AND ped-ent.nr-pedcli    = it-pre-fat.nr-pedcli
              AND ped-ent.nr-sequencia = it-pre-fat.nr-sequencia
              AND ped-ent.it-codigo    = it-pre-fat.it-codigo
              AND ped-ent.cod-refer    = it-pre-fat.cod-refer
              AND ped-ent.nr-entrega   = it-pre-fat.nr-entrega NO-ERROR.
    
        IF  AVAIL ped-ent THEN DO:

            FIND it-nota-fisc NO-LOCK
                WHERE it-nota-fisc.nome-ab-cli = ped-ent.nome-abrev
                  AND it-nota-fisc.nr-pedcli   = ped-ent.nr-pedcli
                  AND it-nota-fisc.nr-seq-ped  = ped-ent.nr-sequencia
                  AND it-nota-fisc.it-codigo   = ped-ent.it-codigo
                  AND it-nota-fisc.cod-refer   = ped-ent.cod-refer NO-ERROR.

            FIND nota-fiscal NO-LOCK OF it-nota-fisc 
                WHERE nota-fiscal.cdd-embarq = p-embarque NO-ERROR.

            IF  AVAIL nota-fiscal THEN DO:
                 IF  trim(c-transp) = "" THEN 
                     ASSIGN c-transp = nota-fiscal.nome-transp.
                
                 IF c-transp <> nota-fiscal.nome-transp THEN
                     RETURN "NOK".
            END.
        END.
     END.
     */
    RETURN "OK".

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

/*:T** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}
    
    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.

    /*IF  INPUT FRAME fPage4 rsTpFuncao = 1 THEN DO:*/
        RUN pi-valida-notas-transp-diferentes (INPUT FRAME fPage2 iNr-embarque).
        IF  RETURN-VALUE <> "OK" THEN DO:
            RUN utp/ut-msgs.p (input "show":U, 
                               input 17006, 
                               input "Este Embarque possui notas de transportadoras diferentes~~NÆo ‚ poss¡vel integr -lo com WMS" ).
            RETURN ERROR.
        END.
    /*END.*/

/*:T Coloque aqui as valida‡äes das outras p ginas, lembrando que elas devem 
       apresentar uma mensagem de erro cadastrada, posicionar na p gina com 
       problemas e colocar o focus no campo com problemas */    
    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    

    FIND embarque NO-LOCK 
        WHERE embarque.cdd-embarq = INPUT FRAME fPage2 iNr-embarque NO-ERROR.
    IF  NOT AVAIL embarque THEN DO:
        RUN utp/ut-msgs.p (input "show":U, 
                           input 17006, 
                           input "C¢digo de embarque inexistente.~~Deve ser informado um n£mero de embarque v lido" ).
        RETURN ERROR.
    END.
    
    /*FIND FIRST usuar_univ
        WHERE usuar_univ.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR. */
            
    IF  embarque.cod-estabel <> v_cod_estab_usuar THEN DO:
        RUN utp/ut-msgs.p (input "show":U, 
                           input 17006, 
                           input "Embarque nÆo pode ser integrado.~~O estabelecimento do embarque informado ‚ diferente do seu estabelecimento.").
        RETURN ERROR.
    END.

    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.data-exec       = today
           tt-param.hora-exec       = time.     

    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
         then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
    
    ASSIGN tt-param.cod-estabel         = v_cod_estab_usuar
           tt-param.nr-embarque         = INPUT FRAME fPage2 iNr-embarque
           tt-param.tipo-volume         = INPUT FRAME fPage4 rsTpVolume
           tt-param.tipo-funcao         = INPUT FRAME fPage4 rsTpFuncao.
           

    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i esp/ftp/esftp066rp.p} 
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

