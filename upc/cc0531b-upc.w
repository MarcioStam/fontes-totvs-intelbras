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
{include/i-prgvrs.i cc0531b-upc 2.04.000.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        cc0531b-upc
&GLOBAL-DEFINE Version        2.04.000.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   fi-item-do-forn fi-unid-med-for ~
                              fi-fator-conver fi-num-casa-dec btOK btCancel

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER r-rowid-item-fornec-estab AS ROWID NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE BUFFER b-item-fornec-estab FOR item-fornec-estab.

DEFINE VARIABLE h-boin417na   AS HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR L-Implanta              AS   LOG    INIT NO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar fi-item-do-forn fi-unid-med-for ~
fi-fator-conver fi-num-casa-dec btOK btCancel 
&Scoped-Define DISPLAYED-OBJECTS fi-cod-emitente fi-item-do-forn ~
fi-unid-med-for fi-desc-unid fi-fator-conver fi-num-casa-dec 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Fornecedor":R18 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-desc-unid AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-fator-conver AS DECIMAL FORMAT ">>>>>>>>>9" INITIAL 1 
     LABEL "Fator Convers∆o":R18 
     VIEW-AS FILL-IN 
     SIZE 8.14 BY .88.

DEFINE VARIABLE fi-item-do-forn AS INTEGER FORMAT ">>>>>>9" INITIAL 0 
     LABEL "Fabricante":R18 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-num-casa-dec AS INTEGER FORMAT "9" INITIAL 0 
     LABEL "Casas Decimais":R17 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .88.

DEFINE VARIABLE fi-unid-med-for AS CHARACTER FORMAT "xx" 
     LABEL "Unid Medid":R12 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 65 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-cod-emitente AT ROW 2.25 COL 15 COLON-ALIGNED WIDGET-ID 12
     fi-item-do-forn AT ROW 3.25 COL 15 COLON-ALIGNED WIDGET-ID 6
     fi-unid-med-for AT ROW 4.25 COL 15 COLON-ALIGNED WIDGET-ID 10
     fi-desc-unid AT ROW 4.25 COL 21.29 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     fi-fator-conver AT ROW 5.25 COL 15 COLON-ALIGNED WIDGET-ID 4
     fi-num-casa-dec AT ROW 6.25 COL 15 COLON-ALIGNED WIDGET-ID 8
     btOK AT ROW 8.96 COL 2
     btCancel AT ROW 8.96 COL 13
     rtToolBar AT ROW 8.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 65 BY 9.17
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
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
         HEIGHT             = 9.17
         WIDTH              = 65
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
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

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fi-cod-emitente IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-unid IN FRAME fpage0
   NO-ENABLE                                                            */
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
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    ASSIGN INPUT FRAME {&frame-name} fi-item-do-forn fi-unid-med-for fi-fator-conver fi-num-casa-dec.


    IF NOT CAN-FIND(FIRST tab-unidade 
                    WHERE tab-unidade.un = fi-unid-med-for) THEN DO:

        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 846, INPUT "":U).
        APPLY "entry" TO fi-unid-med-for IN FRAME {&frame-name}.
        RETURN NO-APPLY.
    END.

    IF  int(fi-item-do-forn) <> 0 
    AND NOT CAN-FIND(FIRST fabricante
                        WHERE fabricante.cod-fabric = int(fi-item-do-forn)) THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U, INPUT 56, INPUT "Fabricante":U).
        APPLY "entry" TO fi-item-do-forn IN FRAME {&frame-name}.
        RETURN NO-APPLY.
    END.

    DO TRANS:
        FIND FIRST b-item-fornec-estab EXCLUSIVE-LOCK
             WHERE ROWID(b-item-fornec-estab) = r-rowid-item-fornec-estab NO-ERROR.
    
        IF  AVAIL b-item-fornec-estab 
        AND int(fi-item-do-forn) <> 0
        AND NOT CAN-FIND(item-fabric
                      WHERE item-fabric.cod-fabric = int(fi-item-do-forn)
                        AND item-fabric.it-codigo  = b-item-fornec-estab.it-codigo) THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 17006, INPUT "Relacionamento entre Fabricante e Item n∆o encontrado~~Verifique o cadastro ES0007 - Fabricante":U).
            APPLY "entry" TO fi-item-do-forn IN FRAME {&frame-name}.
            RETURN NO-APPLY.
    
        END.
    
        IF NOT AVAIL b-item-fornec-estab THEN DO:
            MESSAGE "Registro j† pode ter sido eliminado por outro usu†rio!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            APPLY "close" TO THIS-PROCEDURE.
        END.
        ELSE DO:
            FIND int-item-for-PN EXCLUSIVE-LOCK
                 WHERE int-item-for-PN.cod-emitente = b-item-fornec-estab.cod-emitente
                   AND int-item-for-PN.it-codigo    = b-item-fornec-estab.it-codigo NO-ERROR.
            IF  AVAIL int-item-for-PN THEN
                ASSIGN int-item-for-PN.item-do-forn = string(fi-item-do-forn).

            FIND FIRST item-fornec EXCLUSIVE-LOCK
                 WHERE item-fornec.it-codigo    = b-item-fornec-estab.it-codigo 
                   AND item-fornec.cod-emitente = b-item-fornec-estab.cod-emitente NO-ERROR.
            IF AVAIL item-fornec THEN DO:
                ASSIGN /*item-fornec.item-do-forn = string(fi-item-do-forn)*/
                       item-fornec.unid-med-for = fi-unid-med-for
                       item-fornec.fator-conver = fi-fator-conver
                       item-fornec.num-casa-dec = fi-num-casa-dec.
    
                FOR EACH item-fornec-estab EXCLUSIVE-LOCK
                   WHERE item-fornec-estab.it-codigo    = item-fornec.it-codigo
                     AND item-fornec-estab.cod-emitente = item-fornec.cod-emitente:
    
                    ASSIGN item-fornec-estab.unid-med-for = item-fornec.unid-med-for
                           item-fornec-estab.num-casa-dec = item-fornec.num-casa-dec
                           item-fornec-estab.item-do-forn = string(fi-item-do-forn)
                           item-fornec-estab.fator-conver = item-fornec.fator-conver.
                END.
    
                APPLY "close" TO THIS-PROCEDURE.
            END.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-item-do-forn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-item-do-forn wWindow
ON F5 OF fi-item-do-forn IN FRAME fpage0 /* Fabricante */
DO:

    {method/ZoomFields.i &ProgramZoom="eszoom/z01es077.w"
                         &FieldZoom1="cod-fabric"
                         &FieldScreen1="fi-item-do-forn"
                         &Frame1="fPage0"
                         &EnableImplant="NO"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-item-do-forn wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-item-do-forn IN FRAME fpage0 /* Fabricante */
DO:

    APPLY "F5" TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-unid-med-for
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-unid-med-for wWindow
ON F5 OF fi-unid-med-for IN FRAME fpage0 /* Unid Medid */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in417.w
                        &campo=fi-unid-med-for
                        &campozoom=un
                        &frame={&frame-name}
                        &campo2=fi-desc-unid
                        &campozoom2=descricao
                        &frame2={&frame-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-unid-med-for wWindow
ON LEAVE OF fi-unid-med-for IN FRAME fpage0 /* Unid Medid */
DO:
    IF fi-unid-med-for:screen-value in frame {&frame-name} <> "" THEN DO:
        FIND FIRST tab-unidade NO-LOCK
             WHERE tab-unidade.un = fi-unid-med-for:screen-value in frame {&frame-name} NO-ERROR.
        IF AVAIL tab-unidade THEN DO:
            ASSIGN fi-desc-unid:SCREEN-VALUE IN FRAME {&frame-name} = tab-unidade.descricao.

        END.
        ELSE DO:
            ASSIGN fi-desc-unid:SCREEN-VALUE IN FRAME {&frame-name} = "".
        END.
    END.
    ELSE DO:
        ASSIGN fi-desc-unid:SCREEN-VALUE IN FRAME {&frame-name} = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-unid-med-for wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-unid-med-for IN FRAME fpage0 /* Unid Medid */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/

fi-unid-med-for:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME {&frame-name}.  
fi-item-do-forn:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME {&FRAME-NAME}.


{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST b-item-fornec-estab NO-LOCK
         WHERE ROWID(b-item-fornec-estab) = r-rowid-item-fornec-estab NO-ERROR.
    IF NOT AVAIL b-item-fornec-estab THEN DO:
        MESSAGE "Registro j† pode ter sido eliminado por outro usu†rio!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        APPLY "close" TO THIS-PROCEDURE.
    END.
    ELSE DO:
        FIND FIRST int-item-for-PN NO-LOCK
            WHERE int-item-for-PN.cod-emitente = b-item-fornec-estab.cod-emitente
              AND int-item-for-PN.it-codigo    = b-item-fornec-estab.it-codigo NO-ERROR.
        IF  AVAIL int-item-for-PN THEN
            ASSIGN fi-item-do-forn = int(int-item-for-PN.item-do-forn).


        ASSIGN fi-cod-emitente = b-item-fornec-estab.cod-emitente
               /*fi-item-do-forn = int(b-item-fornec-estab.item-do-forn)*/
               fi-unid-med-for = b-item-fornec-estab.unid-med-for
               fi-fator-conver = b-item-fornec-estab.fator-conver
               fi-num-casa-dec = b-item-fornec-estab.num-casa-dec.

        DISP fi-cod-emitente
             fi-item-do-forn 
             fi-unid-med-for
             fi-fator-conver
             fi-num-casa-dec WITH FRAME {&frame-name}.
    END.

    APPLY "leave" TO fi-unid-med-for IN FRAME {&frame-name}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-dados wWindow 
PROCEDURE pi-carrega-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

