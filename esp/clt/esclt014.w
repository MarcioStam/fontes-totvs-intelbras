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
{include/i-prgvrs.i esclt014 2.06.00.000}

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        esclt014
&GLOBAL-DEFINE Version        2.06.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   fi-serie-pai fi-qtd-filhos fi-serie-filho bt-sair

&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE pit-codigo           AS   CHARACTER         NO-UNDO.
DEFINE VARIABLE lcompleto            AS   LOGICAL           NO-UNDO.
DEFINE VARIABLE i-contador           AS   INTEGER           NO-UNDO.
DEFINE VARIABLE c-nr-serie-principal LIKE num-serie.n-serie NO-UNDO. 
DEFINE VARIABLE i-conta-serie        AS   INTEGER           NO-UNDO.
DEFINE VARIABLE c-tipo-aux           AS   CHARACTER         NO-UNDO.
{esp/es0018.i}
{upc/btb910za-upc.i}
DEFINE VARIABLE l-ok                 AS   LOGICAL FORMAT "SIM/N«O" INIT YES NO-UNDO.
DEFINE VARIABLE c-ns                 AS   CHAR              NO-UNDO.

/* Buffers Definitions ---                                              */
DEF BUFFER b-num-serie-fornec FOR num-serie-fornec.

/* Temp-tables Definitions ---                                          */
DEF TEMP-TABLE tt-num-serie-fornec NO-UNDO LIKE num-serie-fornec.

DEFINE VARIABL l-validou-pai-ja-existente AS LOGICAL NO-UNDO.

PROCEDURE Sleep EXTERNAL "KERNEL32":
    DEFINE INPUT PARAMETER piMilliseconds AS LONG NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-19 fi-serie-pai fi-qtd-filhos ~
fi-serie-filho bt-sair fi-descricao fi-resultado 
&Scoped-Define DISPLAYED-OBJECTS fi-serie-pai fi-qtd-filhos fi-serie-filho ~
fi-descricao fi-resultado 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-sair 
     LABEL "Sair" 
     SIZE-PIXELS 63 BY 24
     FONT 4.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 44.29 BY .67
     FONT 1 NO-UNDO.

DEFINE VARIABLE fi-qtd-filhos AS INTEGER FORMAT ">>9":U INITIAL 2 
     LABEL "Qtd Filhos" 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-resultado AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 30 BY .67
     FGCOLOR 9 FONT 0 NO-UNDO.

DEFINE VARIABLE fi-serie-filho AS CHARACTER FORMAT "X(20)":U 
     LABEL "Nr. SÇrie Filho" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 187 BY 21
     FONT 4 NO-UNDO.

DEFINE VARIABLE fi-serie-pai AS CHARACTER FORMAT "X(20)":U 
     LABEL "Nr. SÇrie Pai" 
     VIEW-AS FILL-IN 
     SIZE-PIXELS 156 BY 21
     FONT 4 NO-UNDO.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE-PIXELS 394 BY 116.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-serie-pai AT Y 18 X 68 COLON-ALIGNED WIDGET-ID 30
     fi-qtd-filhos AT ROW 3.71 COL 10.72 COLON-ALIGNED WIDGET-ID 56
     fi-serie-filho AT Y 90 X 68 COLON-ALIGNED WIDGET-ID 50
     bt-sair AT Y 122 X 331 WIDGET-ID 40
     fi-descricao AT ROW 2.75 COL 12.72 NO-LABEL WIDGET-ID 54
     fi-resultado AT ROW 6.25 COL 3 NO-LABEL WIDGET-ID 52
     RECT-19 AT Y 4 X 4 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4 WIDGET-ID 100.


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
         TITLE              = ""
         HEIGHT-P           = 150
         WIDTH-P            = 401
         MAX-HEIGHT-P       = 702
         MAX-WIDTH-P        = 1366
         VIRTUAL-HEIGHT-P   = 702
         VIRTUAL-WIDTH-P    = 1366
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 4
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
   FRAME-NAME Size-to-Fit                                               */
ASSIGN 
       FRAME fpage0:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN fi-descricao IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-resultado IN FRAME fpage0
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
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


&Scoped-define SELF-NAME bt-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-sair wWindow
ON CHOOSE OF bt-sair IN FRAME fpage0 /* Sair */
DO:
  APPLY 'CLOSE' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-qtd-filhos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-qtd-filhos wWindow
ON LEAVE OF fi-qtd-filhos IN FRAME fpage0 /* Qtd Filhos */
DO:
   APPLY "return" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-qtd-filhos wWindow
ON return OF fi-qtd-filhos IN FRAME fpage0 /* Qtd Filhos */
DO:
  APPLY "ENTRY" TO fi-serie-filho IN FRAME fPage0.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-qtd-filhos wWindow
ON TAB OF fi-qtd-filhos IN FRAME fpage0 /* Qtd Filhos */
DO:
   APPLY "return" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-serie-filho
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-serie-filho wWindow
ON RETURN OF fi-serie-filho IN FRAME fpage0 /* Nr. SÇrie Filho */
DO:
    DEF VAR l-resetar AS LOG  NO-UNDO.
    DEF VAR i-conta   AS INTE NO-UNDO.
//    DEF BUFFER b-num-serie-fornec FOR num-serie-fornec.

    IF INPUT FRAME fPage0 fi-qtd-filhos = 0
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Informe a quantidade de filhos que ser∆o vinculados ao PAI.").
        
        APPLY "ENTRY" TO fi-qtd-filhos IN FRAME fPage0.
        RETURN NO-APPLY.
    END.

    FIND FIRST num-serie NO-LOCK
         WHERE num-serie.n-serie = INPUT FRAME fPage0 fi-serie-filho NO-ERROR.

    /*verifica se nro de serie existe*/
    IF NOT AVAIL num-serie THEN DO:                    
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "N£mero de SÇrie n∆o localizado!").

        ASSIGN fi-serie-filho:SCREEN-VALUE IN FRAME fPage0 = "".
        APPLY "ENTRY" TO fi-serie-filho IN FRAME fPage0.
        RETURN NO-APPLY.
    END.

    FIND FIRST num-serie-fornec WHERE
               num-serie-fornec.n-serie     = INPUT FRAME fPage0 fi-serie-pai   AND
               num-serie-fornec.n-serie-sec = INPUT FRAME fPage0 fi-serie-filho
               NO-LOCK NO-ERROR.

    IF AVAIL num-serie-fornec 
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "N£mero de SÇrie filho j† vinculado ao PAI!").

        ASSIGN fi-serie-filho:SCREEN-VALUE IN FRAME fPage0 = "".
        APPLY "ENTRY" TO fi-serie-filho IN FRAME fPage0.
        RETURN NO-APPLY.
    END.

    FIND FIRST num-serie-fornec USE-INDEX fornec WHERE
               num-serie-fornec.n-serie-sec = INPUT FRAME fPage0 fi-serie-filho
               NO-LOCK NO-ERROR.

    IF AVAIL num-serie-fornec 
    THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "N£mero de SÇrie filho j† vinculado a outro PAI!~~"
                                 + "Numero de serie PAI " + num-serie-fornec.n-serie).

        ASSIGN fi-serie-filho:SCREEN-VALUE IN FRAME fPage0 = "".
        APPLY "ENTRY" TO fi-serie-filho IN FRAME fPage0.
        RETURN NO-APPLY.
    END.

    BLOCO:
    DO  TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO:

        /*verifica se nro de serie filho ja possui relacionamentos*/
        IF  NOT l-resetar THEN DO:
            /*
            IF LENGTH(INPUT FRAME fPage0 fi-serie-filho) <> 12 THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "N£mero de sÇrie filho informado n∆o possui 12 caracteres.").

                ASSIGN fi-serie-filho:SCREEN-VALUE IN FRAME fPage0 = "".
                APPLY "ENTRY" TO fi-serie-filho IN FRAME fPage0.
                RETURN NO-APPLY.
            END. */

            ASSIGN i-conta = 0.

            FOR EACH b-num-serie-fornec WHERE
                     b-num-serie-fornec.n-serie     = INPUT FRAME fPage0 fi-serie-pai  
                     NO-LOCK.

                ASSIGN i-conta = i-conta + 1.
                      
            END.

            IF i-conta >= INT(INPUT FRAME fPage0 fi-qtd-filhos) 
            THEN DO:
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Quantidade informada menor ou igual a Qtd de Itens Filhos.~~"
                                         + "J† foram cadastrados " + STRING(i-conta) + " filhos.").
                
                APPLY "ENTRY" TO fi-qtd-filhos IN FRAME fPage0.
                RETURN NO-APPLY.
            END.
/*
            FIND FIRST num-serie-fornec NO-LOCK
                 WHERE num-serie-fornec.n-serie-sec = INPUT FRAME fPage0 fi-serie-filho NO-ERROR.
    
            IF  AVAIL num-serie-fornec THEN DO:
    
                /* Se o registro for ele mesmo, n∆o tentar desvicular, apenas dar mensagem que j† existe na base */
                IF  num-serie-fornec.n-serie = INPUT FRAME fPage0 fi-serie-pai  THEN DO:
    
                    /*n∆o validar caso j† tenha sido validada no RETURN do item pai*/
                    IF  NOT l-validou-pai-ja-existente THEN DO:
                        RUN utp/ut-msgs.p (INPUT "show",
                                           INPUT 17006,
                                           INPUT "N£mero de n£mero de sÇrie pai e filho j† existente~~J† existe um relacionamento entre os n£meros de sÇrie " + num-serie-fornec.n-serie + 
                                                 " e " + num-serie-fornec.n-serie-sec  ).
                        ASSIGN l-resetar = YES.
                    END.
                END.
                ELSE DO:
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 27100,
                                       INPUT "N£mero de sÇrie j† possui relacionamentos~~Deseja desvincular o relacionamento existente?").
        
                    IF RETURN-VALUE = "YES" THEN DO:
                        FOR EACH num-serie-fornec EXCLUSIVE-LOCK
                           WHERE num-serie-fornec.n-serie-sec = INPUT FRAME fPage0 fi-serie-filho:
                            DELETE num-serie-fornec.
                        END.
                    END.
                    ELSE ASSIGN l-resetar = YES.
                END.
            END. */
        END.

        IF  l-resetar THEN DO:
            ASSIGN fi-serie-pai:SCREEN-VALUE IN FRAME fPage0 = "".
            ASSIGN fi-serie-filho:SCREEN-VALUE IN FRAME fPage0 = "".
            APPLY "ENTRY" TO fi-serie-pai IN FRAME fPage0.
            ASSIGN fi-descricao:SCREEN-VALUE IN FRAME fPage0 = "".
            RETURN NO-APPLY.
        END.

        /*Cria relacionamento*/
        CREATE num-serie-fornec.
        ASSIGN num-serie-fornec.n-serie     = INPUT FRAME fPage0 fi-serie-pai
               num-serie-fornec.n-serie-sec = INPUT FRAME fPage0 fi-serie-filho.

        ASSIGN fi-resultado:SCREEN-VALUE IN FRAME fPage0= "Relacionamento criado com Sucesso!".
        ASSIGN INPUT FRAME fPage0 fi-resultado.
        DISP fi-resultado WITH FRAME fPage0.
        
        RUN sleep ( 1000 ).

        ASSIGN i-conta = 0.

        FOR EACH b-num-serie-fornec WHERE
                 b-num-serie-fornec.n-serie     = INPUT FRAME fPage0 fi-serie-pai  
                 NO-LOCK.

            ASSIGN i-conta = i-conta + 1.
                  
        END.

        IF i-conta = INT(INPUT FRAME fPage0 fi-qtd-filhos)  
        THEN DO:
            ASSIGN fi-resultado:SCREEN-VALUE IN FRAME fPage0 = "".
            ASSIGN INPUT FRAME fPage0 fi-resultado.
            DISP fi-resultado WITH FRAME fPage0.
            
            ASSIGN fi-serie-pai:SCREEN-VALUE   IN FRAME fPage0 = ""
                   fi-serie-filho:SCREEN-VALUE IN FRAME fPage0 = ""
                   fi-qtd-filhos:SCREEN-VALUE  IN FRAME fPage0 = "2".
            
            ASSIGN fi-descricao:SCREEN-VALUE IN FRAME fPage0 = "".
            APPLY "ENTRY" TO fi-serie-pai IN FRAME fPage0.
        END.
        ELSE DO:
            fi-serie-filho:SCREEN-VALUE IN FRAME fPage0 = "".
            APPLY "ENTRY" TO fi-serie-filho IN FRAME fPage0.
        END.
        
    END. /* DO  TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO: */

    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-serie-pai
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-serie-pai wWindow
ON LEAVE OF fi-serie-pai IN FRAME fpage0 /* Nr. SÇrie Pai */
DO:
  APPLY "return" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-serie-pai wWindow
ON RETURN OF fi-serie-pai IN FRAME fpage0 /* Nr. SÇrie Pai */
DO:
    BLOCO:
    DO  TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO:

        FIND FIRST num-serie NO-LOCK
             WHERE num-serie.n-serie = INPUT FRAME fPage0 fi-serie-pai NO-ERROR.

        /*verifica se nro de serie existe*/
        IF NOT AVAIL num-serie THEN DO:                    
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT "N£mero de SÇrie n∆o localizado!").

            ASSIGN fi-serie-pai:SCREEN-VALUE IN FRAME fPage0 = "".
            APPLY "ENTRY" TO fi-serie-pai IN FRAME fPage0.
            RETURN NO-APPLY.
        END.

        FIND FIRST ITEM NO-LOCK
            WHERE ITEM.it-codigo = num-serie.it-codigo NO-ERROR.

        ASSIGN fi-descricao:SCREEN-VALUE IN FRAME fPage0 = num-serie.it-codigo + " - " + ITEM.desc-item.

        /*verifica se nro de serie pai ja possui relacionamentos*/
        FIND FIRST num-serie-fornec NO-LOCK
             WHERE num-serie-fornec.n-serie = INPUT FRAME fPage0 fi-serie-pai NO-ERROR.

        IF AVAIL num-serie-fornec THEN DO:

            ASSIGN fi-serie-filho:SCREEN-VALUE IN FRAME fPage0 = num-serie-fornec.n-serie-sec.

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 27100,
                               INPUT "N£mero de sÇrie j† possui relacionamentos~~Deseja desvincular o relacionamento existente?").


            IF RETURN-VALUE = "YES" THEN DO:
                FOR EACH num-serie-fornec EXCLUSIVE-LOCK
                   WHERE num-serie-fornec.n-serie = INPUT FRAME fPage0 fi-serie-pai:
                    DELETE num-serie-fornec.
                END.
                ASSIGN l-validou-pai-ja-existente = YES.
                APPLY "ENTRY" TO fi-serie-filho IN FRAME fPage0.
            END.
            ELSE DO:

                ASSIGN c-ns = "".

                FOR EACH b-num-serie-fornec WHERE
                         b-num-serie-fornec.n-serie = INPUT FRAME fPage0 fi-serie-pai
                         NO-LOCK.

                    ASSIGN c-ns = c-ns + b-num-serie-fornec.n-serie-sec + CHR(13).

                END.

                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 27100,
                                   INPUT "Deseja vincular mais numeros de Serie ao PAI?~~NS j† vinculados:" 
                                         + CHR(13)
                                         + c-ns).

                IF RETURN-VALUE = "NO" 
                THEN DO:
                    ASSIGN fi-serie-pai  :SCREEN-VALUE IN FRAME fPage0 = "".
                    ASSIGN fi-serie-filho:SCREEN-VALUE IN FRAME fPage0 = "".
                    ASSIGN fi-qtd-filhos:SCREEN-VALUE  IN FRAME fPage0 = "2".
                    APPLY "ENTRY" TO fi-serie-pai IN FRAME fPage0.
                    ASSIGN fi-descricao:SCREEN-VALUE IN FRAME fPage0 = "".
                    RETURN. /*NO-APPLY.*/
                END.
                ELSE DO:
                    APPLY "ENTRY" TO fi-qtd-filhos IN FRAME fPage0.
                    RETURN NO-APPLY.
                END.
            END.
            ASSIGN fi-serie-filho:SCREEN-VALUE IN FRAME fPage0 = "".
        END.
        ELSE 
            APPLY "ENTRY" TO fi-qtd-filhos IN FRAME fPage0.

    END. /* DO  TRANSACTION ON ERROR UNDO BLOCO, LEAVE BLOCO: */

    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-serie-pai wWindow
ON TAB OF fi-serie-pai IN FRAME fpage0 /* Nr. SÇrie Pai */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


