&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad           PROGRESS
          mgesp           PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Global Shared Definitions ---                                        */

DEFINE NEW GLOBAL SHARED VARIABLE v_cod_usuar_corren AS CHARACTER   NO-UNDO.

/* Include Definitions ---                                              */

{upc/btb910za-upc.i}
{esp/ShowMsg.i}

/* Local Temp-Table Definitions ---                                     */

DEFINE TEMP-TABLE ttitem
    FIELD it-codigo LIKE item-ean.it-codigo
    FIELD desc-item AS CHARACTER FORMAT "x(60)":U
    INDEX item
        it-codigo.

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE lcompleto  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE lvarios    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE vean       AS INTEGER     NO-UNDO.
DEFINE VARIABLE pit-codigo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-caixa    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-ok       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-selec    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-pallet   AS CHARACTER   NO-UNDO.

/* Local Buffer Definitions ---                                         */

DEFINE BUFFER bvolume-nf        FOR volume-nf.
DEFINE BUFFER bbvolume-nf       FOR volume-nf.
DEFINE BUFFER bitem-mat         FOR item-mat.
DEFINE BUFFER bns-volume        FOR ns-volume.
DEFINE BUFFER bcaixa-ns-volume  FOR ns-volume.
DEFINE BUFFER bpallet-ns-volume FOR ns-volume.

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)" NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-volume

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES volume-nf ITEM

/* Definitions for BROWSE br-volume                                     */
&Scoped-define FIELDS-IN-QUERY-br-volume volume-nf.it-codigo ITEM.desc-item volume-nf.qtde volume-nf.qtde-col   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-volume   
&Scoped-define SELF-NAME br-volume
&Scoped-define QUERY-STRING-br-volume FOR EACH volume-nf WHERE volume-nf.cod-estabel = fi-cod-estabel AND                              volume-nf.serie = fi-serie AND                              volume-nf.nr-nota-fis = fi-nr-nota-fis AND                              volume-nf.nr-volume = fi-nr-volume NO-LOCK, ~
               EACH ITEM WHERE ITEM.it-codigo = volume-nf.it-codigo NO-LOCK
&Scoped-define OPEN-QUERY-br-volume OPEN QUERY {&SELF-NAME}     FOR EACH volume-nf WHERE volume-nf.cod-estabel = fi-cod-estabel AND                              volume-nf.serie = fi-serie AND                              volume-nf.nr-nota-fis = fi-nr-nota-fis AND                              volume-nf.nr-volume = fi-nr-volume NO-LOCK, ~
               EACH ITEM WHERE ITEM.it-codigo = volume-nf.it-codigo NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-volume volume-nf ITEM
&Scoped-define FIRST-TABLE-IN-QUERY-br-volume volume-nf
&Scoped-define SECOND-TABLE-IN-QUERY-br-volume ITEM


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-volume}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-etiq-volume fi-ean13 btCancel btExit ~
rtToolBar-2 rtToolBar RECT-17 RECT-18 rec-v 
&Scoped-Define DISPLAYED-OBJECTS fi-embalagem fi-etiq-volume fi-cod-estabel ~
fi-serie fi-nr-nota-fis fi-nr-volume fi-ean13 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-item-rastr wWindow 
FUNCTION f-item-rastr RETURNS LOGICAL
  ( INPUT p-it-codigo AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "x(3)" 
     LABEL "Estab." 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE fi-ean13 AS CHARACTER FORMAT "X(20)":U 
     LABEL "Item/Barra" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE fi-embalagem AS CHARACTER FORMAT "X(256)":U 
     LABEL "Embalagem" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE fi-etiq-volume AS CHARACTER FORMAT "X(18)":U 
     LABEL "Etiq.Volume" 
     VIEW-AS FILL-IN 
     SIZE 21.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nr-nota-fis AS CHARACTER FORMAT "X(16)" 
     LABEL "Nr Nota" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE fi-nr-volume AS INTEGER FORMAT ">>,>>9" INITIAL 0 
     LABEL "Volume" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE fi-serie AS CHARACTER FORMAT "x(3)" 
     LABEL "Serie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE RECTANGLE rec-v
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 9.86 BY 2.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.75.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 15.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-volume FOR 
      volume-nf, 
      ITEM SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-volume
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-volume wWindow _FREEFORM
  QUERY br-volume DISPLAY
      volume-nf.it-codigo    COLUMN-LABEL "Item"
 ITEM.desc-item         COLUMN-LABEL "Descricao" 
 volume-nf.qtde         COLUMN-LABEL "Qtd."
 volume-nf.qtde-col     COLUMN-LABEL "Qtd.Coletada"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 83 BY 13
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-embalagem AT ROW 3 COL 40 COLON-ALIGNED WIDGET-ID 28
     fi-etiq-volume AT ROW 3 COL 9 COLON-ALIGNED WIDGET-ID 4
     fi-cod-estabel AT ROW 4 COL 9 COLON-ALIGNED WIDGET-ID 6
     fi-serie AT ROW 4 COL 25 COLON-ALIGNED WIDGET-ID 12
     fi-nr-nota-fis AT ROW 4 COL 40 COLON-ALIGNED WIDGET-ID 8
     fi-nr-volume AT ROW 4 COL 62 COLON-ALIGNED WIDGET-ID 10
     fi-ean13 AT ROW 5.75 COL 9 COLON-ALIGNED WIDGET-ID 16
     br-volume AT ROW 7 COL 4 WIDGET-ID 200
     btCancel AT ROW 20.83 COL 2.29
     btExit AT ROW 1.13 COL 86.72 HELP
          "Sair"
     rtToolBar-2 AT ROW 1 COL 1
     rtToolBar AT ROW 20.63 COL 1
     RECT-17 AT ROW 2.5 COL 1 WIDGET-ID 2
     RECT-18 AT ROW 5.25 COL 1 WIDGET-ID 14
     rec-v AT ROW 3 COL 77 WIDGET-ID 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.29 BY 21.13
         FONT 1 WIDGET-ID 100.


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
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "esftp082.w"
         HEIGHT             = 21.13
         WIDTH              = 90.29
         MAX-HEIGHT         = 27.96
         MAX-WIDTH          = 142.29
         VIRTUAL-HEIGHT     = 27.96
         VIRTUAL-WIDTH      = 142.29
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-volume fi-ean13 fpage0 */
/* SETTINGS FOR BROWSE br-volume IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cod-estabel IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-embalagem IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nr-nota-fis IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-nr-volume IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-serie IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-volume
/* Query rebuild information for BROWSE br-volume
     _START_FREEFORM
OPEN QUERY {&SELF-NAME}
    FOR EACH volume-nf WHERE volume-nf.cod-estabel = fi-cod-estabel AND
                             volume-nf.serie = fi-serie AND
                             volume-nf.nr-nota-fis = fi-nr-nota-fis AND
                             volume-nf.nr-volume = fi-nr-volume NO-LOCK,
        EACH ITEM WHERE ITEM.it-codigo = volume-nf.it-codigo NO-LOCK.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-volume */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* esftp082.w */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* esftp082.w */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-volume
&Scoped-define SELF-NAME br-volume
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-volume wWindow
ON ROW-DISPLAY OF br-volume IN FRAME fpage0
DO:
    IF volume-nf.qtde <> volume-nf.qtde-col OR
       volume-nf.qtde = 0 THEN
        ASSIGN volume-nf.it-codigo:FGCOLOR IN BROWSE br-volume = 12
               ITEM.desc-item:FGCOLOR IN BROWSE br-volume = 12
               volume-nf.qtde:FGCOLOR IN BROWSE br-volume = 12
               volume-nf.qtde-col:FGCOLOR IN BROWSE br-volume = 12.
        
    ELSE
        ASSIGN volume-nf.it-codigo:FGCOLOR IN BROWSE br-volume = 9
               ITEM.desc-item:FGCOLOR IN BROWSE br-volume = 9     
               volume-nf.qtde:FGCOLOR IN BROWSE br-volume = 9     
               volume-nf.qtde-col:FGCOLOR IN BROWSE br-volume = 9.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    assign fi-etiq-volume:SENSITIVE IN FRAME {&FRAME-NAME} = YES
           fi-ean13:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

    RUN pi_limpa.
    
    APPLY "entry" TO fi-etiq-volume IN FRAME fPage0.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ean13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ean13 wWindow
ON RETURN OF fi-ean13 IN FRAME fpage0 /* Item/Barra */
DO:
    BLOCO:
    DO TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO:
        ASSIGN INPUT FRAME fPage0 fi-ean13.

        IF fi-ean13 = "":U THEN
            RETURN NO-APPLY.

        /**** Leitura do EAN13 ****/
        IF fi-ean13 BEGINS "789":U THEN DO:
            ASSIGN vean       = 0
                   pit-codigo = "":U.

            FOR EACH ttitem:
                DELETE ttitem.
            END.

            FOR EACH bitem-mat NO-LOCK
                WHERE bitem-mat.cod-ean = fi-ean13:

                FIND FIRST item
                    WHERE item.it-codigo = bitem-mat.it-codigo NO-LOCK NO-ERROR.

                CREATE ttitem.
                ASSIGN ttitem.it-codigo = item.it-codigo
                       ttitem.desc-item = item.desc-item
                       vean             = vean + 1.
            END.

            IF vean = 0 THEN DO:
                RUN ShowMessage (INPUT 1,
                                 INPUT "Item n∆o cadastrado.":U,
                                 INPUT "C¢digo EAN13 do item n∆o cadastrado. Procurar Engenharia Industrial.":U).

                ASSIGN fi-ean13 = "":U.

                DISPLAY fi-ean13
                    WITH FRAME fPage0.

                UNDO BLOCO, LEAVE BLOCO.
            END.

            IF vean > 1 THEN DO:
                RUN esp/ftp/esftp082a.w (INPUT TABLE ttitem,
                                         OUTPUT pit-codigo).

                IF pit-codigo = "":U THEN DO:
                    RUN ShowMessage (INPUT 1,
                                     INPUT "Item Inv†lido.":U,
                                     INPUT "Algum Item deve ser selecionado.":U).

                    ASSIGN fi-ean13 = "":U.

                    DISPLAY fi-ean13
                        WITH FRAME fPage0.

                    UNDO BLOCO, LEAVE BLOCO.
                END.
        
                FIND FIRST item-mat
                    WHERE item-mat.it-codigo = pit-codigo NO-LOCK NO-ERROR.
            END.

            IF vean = 1 THEN
                FIND FIRST item-mat
                    WHERE item-mat.cod-ean = fi-ean13 NO-LOCK NO-ERROR.

            IF f-item-rastr(item-mat.it-codigo) THEN DO:

                RUN ShowMessage (INPUT 1,
                                 INPUT "Item com rastreabilidade.":U,
                                 INPUT "Ler o n£mero de sÇrie para este item.":U).

                ASSIGN fi-ean13 = "":U.

                DISPLAY fi-ean13
                    WITH FRAME fPage0.

                UNDO BLOCO, LEAVE BLOCO.
            END.

            FIND FIRST volume-nf
                WHERE volume-nf.cod-estabel = fi-cod-estabel
                  AND volume-nf.serie       = fi-serie
                  AND volume-nf.nr-nota-fis = fi-nr-nota-fis
                  AND volume-nf.nr-volume   = fi-nr-volume
                  AND volume-nf.it-codigo   = item-mat.it-codigo EXCLUSIVE-LOCK NO-ERROR.

            IF NOT AVAILABLE volume-nf THEN DO:
                RUN ShowMessage (INPUT 1,
                                 INPUT "Item n∆o pode ser coletado.":U,
                                 INPUT "Item n∆o pertence a este Volume.":U).

                ASSIGN fi-ean13 = "":U.

                DISPLAY fi-ean13
                    WITH FRAME fPage0.

                UNDO BLOCO, LEAVE BLOCO.
            END.

            IF volume-nf.qtde-col >= volume-nf.qtde THEN DO:
                RUN ShowMessage (INPUT 1,
                                 INPUT "Item n∆o pode ser coletado":U,
                                 INPUT "Quantidade do item j† esta completa para este Volume.":U).

                ASSIGN fi-ean13 = "":U.

                DISPLAY fi-ean13
                    WITH FRAME fPage0.

                UNDO BLOCO, LEAVE BLOCO.
            END.

            IF lvarios THEN
                ASSIGN volume-nf.qtde-col = volume-nf.qtde-col + 1
                       volume-nf.tp-col   = 1.
            ELSE DO:
                FIND FIRST item-caixa
                    WHERE item-caixa.sigla-emb = volume-nf.sigla-emb
                      AND item-caixa.it-codigo = volume-nf.it-codigo NO-LOCK NO-ERROR.

                IF AVAILABLE item-caixa                AND
                   item-caixa.qt-item = volume-nf.qtde THEN
                    ASSIGN volume-nf.qtde-col = volume-nf.qtde
                           volume-nf.tp-col   = 2.
                ELSE
                    ASSIGN volume-nf.qtde-col = volume-nf.qtde-col + 1
                           volume-nf.tp-col   = 1.
            END.

            ASSIGN volume-nf.usuario-col = v_cod_usuar_corren
                   volume-nf.data-col    = TODAY.
        END.
        ELSE IF fi-ean13 BEGINS "ECO":U THEN DO:

            FIND FIRST bcaixa-ns-volume 
                 WHERE bcaixa-ns-volume.volume-filho = fi-ean13 NO-LOCK NO-ERROR.

             IF AVAIL bcaixa-ns-volume THEN DO:

                 RUN esp/ftp/esftp082b.w (OUTPUT c-selec).

                 IF c-selec = "" THEN DO:
                     
                     APPLY "entry" TO fi-ean13 IN FRAME {&FRAME-NAME}.

                     UNDO BLOCO, LEAVE BLOCO.

                 END.

                 IF c-selec = "uma" THEN DO:
                 
                     FOR EACH bcaixa-ns-volume 
                         WHERE bcaixa-ns-volume.volume-filho = fi-ean13:

                         DELETE bcaixa-ns-volume.

                     END.

                 END.

                 IF c-selec = "todas" THEN DO:

                     ASSIGN c-pallet = "".
                 
                     FOR EACH bcaixa-ns-volume 
                         WHERE bcaixa-ns-volume.volume-filho = fi-ean13:

                         ASSIGN c-pallet = bcaixa-ns-volume.volume-pai.

                     END.

                     IF c-pallet <> "" THEN DO:

                         FOR EACH bcaixa-ns-volume 
                             WHERE bcaixa-ns-volume.volume-pai = c-pallet:
    
                             DELETE bcaixa-ns-volume.
    
                         END.

                     END.

                 END.

             END.


             FIND FIRST bcaixa-ns-volume 
                WHERE bcaixa-ns-volume.volume-pai = fi-ean13 NO-LOCK NO-ERROR.

              IF NOT AVAIL bcaixa-ns-volume THEN DO:

                  MESSAGE "Etiqueta de caixa n∆o relacionada a produto algum, ou a pallet algum."
                      VIEW-AS ALERT-BOX INFO BUTTONS OK.

                  APPLY "entry" TO fi-ean13 IN FRAME {&FRAME-NAME}.

                  UNDO BLOCO, LEAVE BLOCO.

              END.


            FOR EACH bcaixa-ns-volume NO-LOCK
                WHERE bcaixa-ns-volume.volume-pai = fi-ean13:

                RUN pi_leitura_num_serie (INPUT bcaixa-ns-volume.volume-filho).

                IF RETURN-VALUE = "NOK":U THEN DO:
                    ASSIGN fi-ean13 = "":U.

                    DISPLAY fi-ean13
                        WITH FRAME fPage0.

                    UNDO BLOCO, LEAVE BLOCO.
                END.
            END.
        END.
        ELSE IF fi-ean13 BEGINS "EPA":U THEN DO:

            IF NOT CAN-FIND(FIRST bpallet-ns-volume
                            WHERE bpallet-ns-volume.volume-pai = fi-ean13) THEN DO:

                MESSAGE "Etiqueta de pallet n∆o relacionada a caixa alguma."
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.

                APPLY "entry" TO fi-ean13 IN FRAME {&FRAME-NAME}.
                
                UNDO BLOCO, LEAVE BLOCO.

            END.

            FOR EACH bpallet-ns-volume NO-LOCK
                WHERE bpallet-ns-volume.volume-pai = fi-ean13,
                EACH bcaixa-ns-volume NO-LOCK
                WHERE bcaixa-ns-volume.volume-pai = bpallet-ns-volume.volume-filho:

                RUN pi_leitura_num_serie (INPUT bcaixa-ns-volume.volume-filho).

                IF RETURN-VALUE = "NOK":U THEN DO:
                    ASSIGN fi-ean13 = "":U.

                    DISPLAY fi-ean13
                        WITH FRAME fPage0.

                    UNDO BLOCO, LEAVE BLOCO.
                END.
            END.

        END.
        ELSE DO:


            FIND FIRST ns-volume
                WHERE ns-volume.volume-filho = fi-ean13 NO-ERROR.

            IF AVAIL ns-volume AND
               ns-volume.volume-pai <> "ECO-INDEFINIDA" THEN DO:

                MESSAGE "Produto n∆o pode ser relacionado a NF: produto relacionado a Caixa." SKIP
                        "Deseja Desvincular?"
                    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-ok.

                IF NOT l-ok THEN DO:
                    APPLY "entry" TO fi-ean13 IN FRAME {&FRAME-NAME}.
                    UNDO BLOCO, LEAVE BLOCO.
                END.
               
                ASSIGN c-caixa = ns-volume.volume-pai.

                FOR EACH ns-volume WHERE ns-volume.volume-pai = c-caixa:
                    ASSIGN ns-volume.volume-pai = "ECO-INDEFINIDA".
                END.

                FOR EACH ns-volume WHERE ns-volume.volume-filho = c-caixa:
                    DELETE ns-volume.
                END.

            END.


            /**** Leitura do N£m. de SÇrie ****/
            RUN pi_leitura_num_serie (INPUT fi-ean13).

            IF RETURN-VALUE = "NOK":U THEN DO:
                ASSIGN fi-ean13 = "":U.

                DISPLAY fi-ean13
                    WITH FRAME fPage0.

                UNDO BLOCO, LEAVE BLOCO.
            END.
        END.
    END.

    /* -------------------------------------------------------------- */

    {&OPEN-QUERY-br-volume}

    br-volume:DESELECT-ROWS().

    ASSIGN lcompleto = YES.

    FOR EACH bbvolume-nf NO-LOCK
        WHERE bbvolume-nf.cod-estab = bvolume-nf.cod-estabel
          AND bbvolume-nf.serie = bvolume-nf.serie
          AND bbvolume-nf.nr-nota-fis = bvolume-nf.nr-nota-fis
          AND bbvolume-nf.nr-volume = bvolume-nf.nr-volume:
        IF bbvolume-nf.qtde <> bbvolume-nf.qtde-col OR
           bbvolume-nf.qtde = 0                     THEN DO:
            ASSIGN lcompleto = NO.

            LEAVE.
        END.
    END.

    ASSIGN fi-ean13 = "":U.

    DISPLAY fi-ean13
        WITH FRAME fpage0.

    IF lcompleto THEN DO:
        BELL.

        ASSIGN fi-etiq-volume:SENSITIVE IN FRAME fPage0 = YES
               fi-ean13:SENSITIVE IN FRAME fpage0       = NO
               rec-v:FGCOLOR                            = 2
               rec-v:BGCOLOR                            = 2.

        ASSIGN fi-etiq-volume = "":U.

        DISPLAY fi-etiq-volume
            WITH FRAME fPage0.

        APPLY "ENTRY":U TO fi-etiq-volume IN FRAME fPage0.
    END.
    ELSE DO:
        ASSIGN rec-v:FGCOLOR = 12
               rec-v:BGCOLOR = 12.

        APPLY "ENTRY":U TO fi-ean13 IN FRAME fPage0.
    END.

    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-etiq-volume
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-etiq-volume wWindow
ON RETURN OF fi-etiq-volume IN FRAME fpage0 /* Etiq.Volume */
DO:
    
    if input fi-etiq-volume = "" then return no-apply.
    
    ASSIGN fi-etiq-volume = input fi-etiq-volume.

    IF LENGTH(fi-etiq-volume) <> 18 THEN DO:
        RUN ShowMessage(1, "C¢digo de Barras inv†lido.", "C¢digo de Barras coletado n∆o Ç correspondente ao volume. Verifique.").
        ASSIGN fi-etiq-volume = "".
               
        disp fi-etiq-volume with frame fPage0.

        RUN pi_limpa.
        RETURN NO-APPLY.
    END.
    
    FIND FIRST bvolume-nf 
        WHERE bvolume-nf.cod-estabel = SUBSTRING(fi-etiq-volume,1,3) AND
              bvolume-nf.serie = STRING(INT(SUBSTRING(fi-etiq-volume,4,3))) AND
              bvolume-nf.nr-nota-fis = SUBSTRING(fi-etiq-volume,7,7) AND
              bvolume-nf.nr-volume = INT(SUBSTRING(fi-etiq-volume,14,5)) NO-LOCK NO-ERROR.
    IF NOT AVAIL bvolume-nf THEN DO:
        RUN ShowMessage(1, "Etiqueta inv†lida.", "Volume n∆o encontrado no sistema.").
        ASSIGN fi-etiq-volume = "".
               
        disp fi-etiq-volume with frame fPage0.

        RUN pi_limpa.
        RETURN NO-APPLY.
    END.

    ASSIGN fi-etiq-volume = ""
           fi-cod-estabel = bvolume-nf.cod-estabel
           fi-serie       = bvolume-nf.serie
           fi-nr-nota-fis = bvolume-nf.nr-nota-fis
           fi-nr-volume   = bvolume-nf.nr-volume
           lvarios        = bvolume-nf.varios-itens
           lcompleto      = YES.

    FIND FIRST embalag NO-LOCK
        WHERE  embalag.sigla-emb = bvolume-nf.sigla-emb NO-ERROR.
    IF  AVAIL  embalag THEN
        ASSIGN fi-embalagem = embalag.embalagem.
    ELSE
        ASSIGN fi-embalagem = "".


    FOR EACH bbvolume-nf WHERE bbvolume-nf.cod-estab = bvolume-nf.cod-estabel AND
                               bbvolume-nf.serie = bvolume-nf.serie AND    
                               bbvolume-nf.nr-nota-fis = bvolume-nf.nr-nota-fis AND 
                               bbvolume-nf.nr-volume = bvolume-nf.nr-volume NO-LOCK:
        IF bbvolume-nf.qtde <> bbvolume-nf.qtde-col OR
           bbvolume-nf.qtde = 0                     THEN DO:
            ASSIGN lcompleto = NO.
            LEAVE.
        END.
    END.

    DISP fi-etiq-volume 
         fi-cod-estabel
         fi-serie
         fi-nr-nota-fis
         fi-nr-volume
         fi-embalagem
         WITH FRAME fpage0.
    
    {&OPEN-QUERY-br-volume}

    br-volume:DESELECT-ROWS().

    IF lcompleto THEN DO:
        ASSIGN fi-etiq-volume = "".
        disp fi-etiq-volume with frame fPage0.
        assign fi-ean13:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               rec-v:FGCOLOR = 2
               rec-v:BGCOLOR = 2.
    END.
    ELSE DO:
        assign fi-etiq-volume:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               fi-ean13:SENSITIVE IN FRAME {&FRAME-NAME} = YES
               rec-v:FGCOLOR = 12
               rec-v:BGCOLOR = 12.
        APPLY "entry" TO fi-ean13 IN FRAME fPage0.
    END.

    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
    
  assign fi-ean13:SENSITIVE IN FRAME {&FRAME-NAME} = NO
         rec-v:FGCOLOR = 12
         rec-v:BGCOLOR = 12.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWindow 
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
  THEN DELETE WIDGET wWindow.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWindow 
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
  VIEW FRAME fPage0 IN WINDOW wWindow.

  ENABLE {&ENABLED-OBJECTS} WITH FRAME fPage0.

  DISP {&DISPLAYED-OBJECTS} WITH FRAME fPage0.

  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW wWindow.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_leitura_num_serie wWindow 
PROCEDURE pi_leitura_num_serie :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  INPUT p-etiqueta-nro-serie AS CHARACTER
  Notes:       <none>
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-etiqueta-nro-serie AS CHARACTER   NO-UNDO.


    FOR FIRST num-serie NO-LOCK
        WHERE num-serie.n-serie = p-etiqueta-nro-serie:
    END.

    IF NOT AVAILABLE num-serie THEN DO:
        RUN ShowMessage (INPUT 1,
                         INPUT "N£m. de SÇrie n∆o cadastrado.":U,
                         INPUT "N£m. de SÇrie ~"":U + p-etiqueta-nro-serie + "~" n∆o cadastrado.":U).

        RETURN "NOK":U.
    END.

    IF NOT f-item-rastr(num-serie.it-codigo) THEN DO:
        RUN ShowMessage (INPUT 1,
                         INPUT "Item n∆o Ç de rastreabilidade.":U,
                         INPUT "Ler o C¢d. EAN13 para este item (Nr. SÇrie: ":U + p-etiqueta-nro-serie + "). C¢d que comeáa com ~"789~".":U).

        RETURN "NOK":U.
    END.

    /*FIND FIRST wf-volume
        WHERE wf-volume.produto     = p-etiqueta-nro-serie
          AND wf-volume.nr-nota-fis = fi-nr-nota-fis
          AND wf-volume.serie       = fi-serie NO-LOCK NO-ERROR.

    IF AVAILABLE wf-volume THEN DO:
        RUN ShowMessage (INPUT 1,
                         INPUT "Item j† vinculado a Nota Fiscal.":U,
                         INPUT "Este N£mero de sÇrie (":U + p-etiqueta-nro-serie + ") j† foi vinculado a esta Nota Fiscal.":U).

        RETURN "NOK":U.
    END.*/

    /*FOR FIRST bnum-serie-rast NO-LOCK
        WHERE bnum-serie-rast.n-serie = p-etiqueta-nro-serie
        AND   bnum-serie-rast.nr-nota-fis <> "":U
        AND   bnum-serie-rast.serie <> "":U:
    END.
    
    IF AVAILABLE bnum-serie-rast THEN DO:

        FIND FIRST nota-fiscal
            WHERE nota-fiscal.cod-estabel = fi-cod-estabel
              AND nota-fiscal.serie       = bnum-serie-rast.serie
              AND nota-fiscal.nr-nota-fis = bnum-serie-rast.nr-nota-fis NO-LOCK NO-ERROR.

        FIND FIRST devol-cli
            WHERE devol-cli.cod-estabel = fi-cod-estabel
              AND devol-cli.serie       = bnum-serie-rast.serie
              AND devol-cli.nr-nota-fis = bnum-serie-rast.nr-nota-fis
              AND devol-cli.it-codigo   = num-serie.it-codigo NO-LOCK NO-ERROR.

        IF nota-fiscal.dt-cancela = ? AND /* Se a NF n∆o estiver cancelada, nem devolvida emitir mensagem */
           NOT AVAILABLE devol-cli    THEN DO:
            RUN ShowMessage (INPUT 1,
                             INPUT "Item j† vinculado a Nota Fiscal.":U,
                             INPUT "Este N£mero de sÇrie (":U + p-etiqueta-nro-serie + ") j† foi vinculado a uma Nota Fiscal. Consultar no programa ESCPP005.":U).

            RETURN "NOK":U.
        END.
    END.*/

    FIND FIRST volume-nf
        WHERE volume-nf.cod-estabel = fi-cod-estabel
          AND volume-nf.serie       = fi-serie
          AND volume-nf.nr-nota-fis = fi-nr-nota-fis
          AND volume-nf.nr-volume   = fi-nr-volume
          AND volume-nf.it-codigo   = num-serie.it-codigo EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAILABLE volume-nf THEN DO:
        RUN ShowMessage (INPUT 1,
                         INPUT "Item n∆o pode ser coletado.":U,
                         INPUT "Item (Nr. SÇrie: ":U + p-etiqueta-nro-serie + ") n∆o pertence a este Volume.":U).

        RETURN "NOK":U.
    END.

    IF volume-nf.qtde-col >= volume-nf.qtde THEN DO:
        RUN ShowMessage (INPUT 1,
                         INPUT "Item n∆o pode ser coletado":U,
                         INPUT "Quantidade do item (Nr. SÇrie: ":U + p-etiqueta-nro-serie + ") n∆o confere com a quantidade do Volume.":U).

        RETURN "NOK":U.
    END.

    FOR FIRST num-serie-rast NO-LOCK
        WHERE num-serie-rast.cod-estabel = fi-cod-estabel
        AND   num-serie-rast.serie = fi-serie
        AND   num-serie-rast.nr-nota-fis = fi-nr-nota-fis
        AND   num-serie-rast.n-serie = p-etiqueta-nro-serie:
    END.

    IF AVAIL num-serie-rast THEN DO:

        RUN ShowMessage (INPUT 1,
                         INPUT "N£mero de SÇrie j† vinculado ao volume: ":U + string(num-serie-rast.nr-volume) + " desta Nota Fiscal.":U,
                         INPUT "Utilize outro N£mero de SÇrie.":U).

        RETURN "NOK":U.

    END.

    ASSIGN volume-nf.qtde-col    = volume-nf.qtde-col + 1
           volume-nf.tp-col      = 1
           volume-nf.usuario-col = v_cod_usuar_corren
           volume-nf.data-col    = TODAY.

    FOR FIRST num-serie-rast NO-LOCK
        WHERE num-serie-rast.cod-estabel = fi-cod-estabel
        AND   num-serie-rast.serie = fi-serie
        AND   num-serie-rast.nr-nota-fis = fi-nr-nota-fis
        AND   num-serie-rast.n-serie = p-etiqueta-nro-serie:
    END.

    IF NOT AVAIL num-serie-rast THEN DO:

        CREATE num-serie-rast.
        ASSIGN num-serie-rast.cod-estabel   = fi-cod-estabel    
               num-serie-rast.serie         = fi-serie                
               num-serie-rast.nr-nota-fis   = fi-nr-nota-fis    
               num-serie-rast.nr-volume     = fi-nr-volume        
               num-serie-rast.n-serie       = p-etiqueta-nro-serie
               num-serie-rast.it-codigo     = num-serie.it-codigo
               num-serie-rast.data          = NOW
               num-serie-rast.usuario       = c-seg-usuario.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_limpa wWindow 
PROCEDURE pi_limpa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN fi-cod-estabel = ""
           fi-serie       = ""
           fi-nr-nota-fis = ""
           fi-nr-volume   = 0
           rec-v:FGCOLOR IN FRAME fpage0 = 12
           rec-v:BGCOLOR IN FRAME fpage0 = 12.

    DISP fi-cod-estabel  
         fi-serie       
         fi-nr-nota-fis 
         fi-nr-volume WITH FRAME fpage0.

    {&OPEN-QUERY-br-volume}

    APPLY "entry" TO fi-etiq-volume IN FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-item-rastr wWindow 
FUNCTION f-item-rastr RETURNS LOGICAL
  ( INPUT p-it-codigo AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    FOR FIRST item-rast FIELDS(it-codigo data-ini data-fim) NO-LOCK 
        WHERE item-rast.it-codigo  = p-it-codigo
        AND   item-rast.data-ini  <= TODAY
        AND   item-rast.data-fim   > TODAY:

        RETURN TRUE.

    END.


    RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

