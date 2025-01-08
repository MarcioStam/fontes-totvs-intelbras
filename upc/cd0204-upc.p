/***********************************************************************
**  Programa..: upc\im0100-upc.p
**  Autor.....: Anderson Silvano  - Gestech
**  Data......: JUNHO/2005 - Desenvolvimento
**  Descricao.: 
**  Vers∆o....: 001 - 00/00/2002
**                  Desenvolvimento Programa
compile \\tsclient\c\fontes\upc\cd0204-upc.p save into c:\temp\upc.
**  Vers∆o....: 002 - 30/09/2022
**                  Cat†logo Ariba
**  Vers∆o....: 003 - 24/02/2023
**                  Dt Atualiza
************************************************************************/

{utp/ut-glob.i}
{upc/btb910za-upc.i}

/* Definiá∆o da temp-table "tt-prog-ponto" */
{esp/es0018.i}

def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

DEFINE VARIABLE h-object           AS HANDLE        NO-UNDO.
DEFINE VARIABLE h-campo            AS HANDLE        NO-UNDO.

DEFINE new global shared VARIABLE wgh-objeto           AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR tx-peso-bruto         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-peso-liquido       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-comprim            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-largura            AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-altura             AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-class-fiscal       AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-dt-atualiza        AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR tx-peso-bruto-label   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-peso-liquido-label AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-comprim-label      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-largura-label      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-altura-label       AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-peso-bruto      AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-peso-liquido    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-comprim         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-largura         AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-altura          AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-class-fiscal    AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-narrativa-cd0204     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-rect-narrat-cd0204   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-narrativa2-cd0204    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tx-narrativa1        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tx-narrativa2        AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-necessita-li-cd0204  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cb-motivo-sit-cd0204 AS WIDGET-HANDLE NO-UNDO.


DEF NEW GLOBAL SHARED VAR wh-ge-codigo-cd0204    AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-log-antidump-esp    AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-tx-obs-antidump     AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-obs-antidumping     AS WIDGET-HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR wh-lei-info-cd0204-upc AS WIDGET-HANDLE NO-UNDO.

define new global shared variable h-programa         as handle        no-undo.
define new global shared variable wgh-window         as widget-handle no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE wh-bt-ok-cd0204     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-new-bt-ok-cd0204 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE h-upc-cd0204        AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-container-cd0204 AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE wh-bt-exporta-cd0204   AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-cd-folh-item-cd0204 AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-c-folh-desc-cd0204  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-cb-idi-classif-item-cd0204 AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE wh-lote-economi-cd0204 AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-codigo-refer-cd0204 AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-inform-compl-cd0204 AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wh-cod-imagem-cd0204   AS WIDGET-HANDLE NO-UNDO.
define variable wh-catalogo-cd0204     as widget-handle no-undo.
define variable wh-dt-atualiza-cd0204  as widget-handle no-undo.

DEFINE NEW GLOBAL SHARED VARIABLE wh-button       AS WIDGET-HANDLE    NO-UNDO.

DEF NEW GLOBAL SHARED VARIABLE r-row-id-item AS ROWID NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE wh-it-codigo-cd0204       AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE wh-cb-cod-obsoleto-cd0204 AS WIDGET-HANDLE NO-UNDO.

define new global shared temp-table tt-cd0204-upc no-undo
    field wh-container   as handle
    field wh-frame       as widget-handle
    field wh-catalogo    as widget-handle
    field wh-dt-atualiza as widget-handle
    field wh-item        as widget-handle.

DEFINE VARIABLE c-char AS   CHAR.

DEFINE BUFFER bf-item FOR item.
assign c-char = entry(num-entries(p-wgh-object:file-name,"~/"), p-wgh-object:file-name,"~/").

/* MESSAGE "Evento " p-ind-event  SKIP    */
/*         "Objeto " p-ind-object SKIP    */
/*         "Nome   " c-char SKIP          */
/*         "Tabela " p-cod-table  SKIP    */
/*         "Rowid  " STRING(p-row-table)  */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK. */

IF  p-ind-object = "CONTAINER":U
AND p-ind-event  = "BEFORE-INITIALIZE":U
THEN ASSIGN wh-container-cd0204 = p-wgh-object.

IF p-ind-object = "VIEWER":U     AND
   c-char       = "v34in172.w":U THEN DO:
    IF p-ind-event = "BEFORE-INITIALIZE":U THEN DO:
        ASSIGN h-object = p-wgh-frame:FIRST-CHILD
               h-object = h-object:FIRST-CHILD.

        DO WHILE h-object <> ?:
            IF h-object:TYPE <> "FIELD-GROUP":U THEN DO:
                CASE h-object:NAME:
                    WHEN "it-codigo":U THEN
                        ASSIGN wh-it-codigo-cd0204 = h-object.
                END CASE.

                ASSIGN h-object = h-object:NEXT-SIBLING.
            END.
            ELSE
                ASSIGN h-object = h-object:FIRST-CHILD.
        END.
    END.
END.

IF p-ind-object = "VIEWER":U     AND
   c-char       = "v35in172.w":U THEN DO:
    IF p-ind-event = "BEFORE-INITIALIZE":U THEN DO:
        ASSIGN h-object = p-wgh-frame:FIRST-CHILD
               h-object = h-object:FIRST-CHILD.

        DO WHILE h-object <> ?:
            IF h-object:TYPE <> "FIELD-GROUP":U THEN DO:
                CASE h-object:NAME:
                    WHEN "CB-COD-OBSOLETO":U THEN
                        ASSIGN wh-cb-cod-obsoleto-cd0204 = h-object.
                END CASE.

                ASSIGN h-object = h-object:NEXT-SIBLING.
            END.
            ELSE
                ASSIGN h-object = h-object:FIRST-CHILD.
        END.
        IF VALID-HANDLE (wh-cb-cod-obsoleto-cd0204) THEN DO:
            IF NOT VALID-HANDLE (h-upc-cd0204) THEN
                RUN upc/cd0204-upc.p PERSISTENT SET h-upc-cd0204 (INPUT "",
                                                                  INPUT "",
                                                                  INPUT p-wgh-object,
                                                                  INPUT p-wgh-frame,
                                                                  INPUT "",
                                                                  INPUT p-row-table).

            ON "VALUE-CHANGED":U OF wh-cb-cod-obsoleto-cd0204 PERSISTENT RUN pi-value-change-cod-obsoleto IN h-upc-cd0204.
        END.
    END.

    IF p-ind-event = "AFTER-ENABLE":U THEN DO:
        IF VALID-HANDLE(wh-it-codigo-cd0204)       AND
           VALID-HANDLE(wh-cb-cod-obsoleto-cd0204) THEN DO:
            RUN esp/es0018p.p (INPUT "cd0204":U,
                               INPUT 1,
                               INPUT 0,
                               INPUT "":U,
                               OUTPUT TABLE tt-prog-ponto).

            IF NOT CAN-FIND(FIRST tt-prog-ponto
                            WHERE tt-prog-ponto.conteudo = c-seg-usuario) AND
               NOT wh-it-codigo-cd0204:SENSITIVE                          THEN
                ASSIGN wh-cb-cod-obsoleto-cd0204:SENSITIVE = NO.
        END.
    END.
END.

if p-ind-event  = "INITIALIZE" and 
   p-ind-object = "CONTAINER" then do:
    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:
            IF h-object:NAME = "bt-exporta":U THEN DO:
                ASSIGN wh-bt-exporta-cd0204 = h-object.
                LEAVE.
            END.
            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.

    assign h-programa = p-wgh-object
           wgh-window = p-wgh-object.

    create button wh-button  
    assign flat-button   = YES
           frame         = p-wgh-frame 
           width         = wh-bt-exporta-cd0204:WIDTH
           height        = wh-bt-exporta-cd0204:HEIGHT
           row           = wh-bt-exporta-cd0204:ROW
           col           = wh-bt-exporta-cd0204:COLUMN + wh-bt-exporta-cd0204:WIDTH
           visible       = yes
           sensitive     = yes
           tooltip       = "UPC"
           triggers:
                on choose persistent run upc/cd0204a-upc.w  .
           end triggers.

    if wh-button:load-image("image/gr-lay.bmp") then.
    if wh-button:load-image-down("image/gr-lay.bmp") then.

    RUN busca-handle(INPUT p-wgh-frame,
                     INPUT "bt-sav",
                     OUTPUT wh-bt-ok-cd0204).

    IF VALID-HANDLE(wh-bt-ok-cd0204) THEN DO:

        IF NOT VALID-HANDLE (h-upc-cd0204) THEN
            RUN upc/cd0204-upc.p PERSISTENT SET h-upc-cd0204 (INPUT "",
                                                              INPUT "",
                                                              INPUT p-wgh-object,
                                                              INPUT p-wgh-frame,
                                                              INPUT "",
                                                              INPUT p-row-table).

        CREATE BUTTON wh-new-bt-ok-cd0204
        ASSIGN FRAME       = wh-bt-ok-cd0204:FRAME
               WIDTH       = wh-bt-ok-cd0204:WIDTH
               HEIGHT      = wh-bt-ok-cd0204:HEIGHT
               LABEL       = wh-bt-ok-cd0204:LABEL
               ROW         = wh-bt-ok-cd0204:ROW
               COL         = wh-bt-ok-cd0204:COL 
               TOOLTIP     = wh-bt-ok-cd0204:TOOLTIP
               FLAT-BUTTON = wh-bt-ok-cd0204:FLAT-BUTTON
               VISIBLE     = wh-bt-ok-cd0204:VISIBLE
               SENSITIVE   = wh-bt-ok-cd0204:SENSITIVE.
        ON "CHOOSE" OF wh-new-bt-ok-cd0204 PERSISTENT RUN pi-bt-ok IN h-upc-cd0204.

        wh-new-bt-ok-cd0204:LOAD-IMAGE(wh-bt-ok-cd0204:IMAGE).
        wh-new-bt-ok-cd0204:LOAD-IMAGE-INSENSITIVE(wh-bt-ok-cd0204:IMAGE-INSENSITIVE).
        wh-new-bt-ok-cd0204:MOVE-TO-TOP().
        wh-bt-ok-cd0204:VISIBLE = NO.
    END.
END.

IF  p-ind-event = "AFTER-ENABLE" AND c-char = "v35in172.w":U AND
    VALID-HANDLE(wh-new-bt-ok-cd0204) THEN DO:
    ASSIGN wh-new-bt-ok-cd0204:SENSITIVE = wh-ge-codigo-cd0204:SENSITIVE.
END.

IF  p-ind-event = "DISPLAY" AND c-char = "v34in172.w":U AND
    VALID-HANDLE(wh-new-bt-ok-cd0204) THEN DO:
    ASSIGN wh-new-bt-ok-cd0204:SENSITIVE = wh-ge-codigo-cd0204:SENSITIVE.
END.

IF  p-ind-event = "DISABLE" AND c-char = "v34in172.w":U AND
    VALID-HANDLE(wh-new-bt-ok-cd0204) THEN DO:
    ASSIGN wh-new-bt-ok-cd0204:SENSITIVE = NO.
END.

IF p-ind-event  = "INITIALIZE":U AND
   p-ind-object = "VIEWER":U     AND
   c-char       = "v35in172.w":U THEN DO:

    CREATE COMBO-BOX wh-cb-motivo-sit-cd0204
    ASSIGN FRAME           = p-wgh-frame
           FORMAT          = "x(18)":U
           WIDTH           = 19
           ROW             = 6.17
           COL             = 10
           FONT            = 1
           LIST-ITEM-PAIRS = ",0,Alteraá∆o de estrutura,1,Phase out produto,2,Item EOL,3,Bloqueado para compra,4"
           VISIBLE         = YES.
       /*TRIGGERS:
            ON VALUE-CHANGED PERSISTENT RUN pi-habilita-campo IN h-im0045-upc.
       END TRIGGERS.*/

    CREATE TOGGLE-BOX wh-lei-info-cd0204-upc
    ASSIGN FRAME     = p-wgh-frame
           COLUMN    = 71.57
           ROW       = 6.17
           WIDTH     = 13.00
           HEIGHT    = 0.88
           LABEL     = "Lei Inform†tica":U
           SENSITIVE = NO
           VISIBLE   = YES.

    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:
            CASE h-object:NAME:
                WHEN "ge-codigo":U THEN DO:
                    ASSIGN wh-ge-codigo-cd0204 = h-object.
                END.
            END CASE.

            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.


END.

IF  p-ind-event  = "INITIALIZE"
AND c-char       = "v36in172.w" THEN DO:

    ASSIGN h-object = p-wgh-frame:FIRST-CHILD.
    ASSIGN h-object = h-object:FIRST-CHILD.

    DO WHILE VALID-HANDLE(h-object):
        IF h-object:TYPE <> "field-group" THEN DO:
            CASE h-object:NAME:
                WHEN "cd-folh-item":U THEN
                    ASSIGN wh-cd-folh-item-cd0204 = h-object.

                WHEN "c-folh-desc":U THEN
                    ASSIGN wh-c-folh-desc-cd0204 = h-object.

                WHEN "lote-economi":U THEN
                    ASSIGN wh-lote-economi-cd0204 = h-object.

                WHEN "codigo-refer":U THEN
                    ASSIGN wh-codigo-refer-cd0204 = h-object.

                WHEN "inform-compl":U THEN
                    ASSIGN wh-inform-compl-cd0204 = h-object.

                WHEN "cod-imagem":U THEN
                    ASSIGN wh-cod-imagem-cd0204   = h-object.

                WHEN "cb-idi-classif-item":U THEN
                    ASSIGN wh-cb-idi-classif-item-cd0204 = h-object.

                
            END CASE.

            ASSIGN h-object = h-object:NEXT-SIBLING NO-ERROR.
        END.
        ELSE LEAVE.
    END.


    ASSIGN wh-cd-folh-item-cd0204:ROW = wh-cd-folh-item-cd0204:ROW - 1
           wh-c-folh-desc-cd0204:ROW  = wh-c-folh-desc-cd0204:ROW  - 1
           wh-lote-economi-cd0204:ROW = wh-lote-economi-cd0204:ROW - 1
           wh-codigo-refer-cd0204:ROW = wh-codigo-refer-cd0204:ROW - 1
           wh-inform-compl-cd0204:ROW = wh-inform-compl-cd0204:ROW - 1
           wh-cod-imagem-cd0204:ROW   = wh-cod-imagem-cd0204:ROW   - 1
           wh-cb-idi-classif-item-cd0204:ROW = wh-cb-idi-classif-item-cd0204:ROW - 1.

    ASSIGN wh-cd-folh-item-cd0204:COLUMN = wh-cd-folh-item-cd0204:COLUMN - 5
           wh-c-folh-desc-cd0204:COLUMN  = wh-c-folh-desc-cd0204:COLUMN  - 5
           wh-lote-economi-cd0204:COLUMN = wh-lote-economi-cd0204:COLUMN - 5
           wh-codigo-refer-cd0204:COLUMN = wh-codigo-refer-cd0204:COLUMN - 5
           wh-inform-compl-cd0204:COLUMN = wh-inform-compl-cd0204:COLUMN - 5
           wh-cod-imagem-cd0204:COLUMN   = wh-cod-imagem-cd0204:COLUMN   - 5
           wh-cb-idi-classif-item-cd0204:COLUMN = wh-cb-idi-classif-item-cd0204:COLUMN - 5.

    ASSIGN wh-cd-folh-item-cd0204:SIDE-LABEL-HANDLE:ROW = wh-cd-folh-item-cd0204:SIDE-LABEL-HANDLE:ROW - 1
           wh-lote-economi-cd0204:SIDE-LABEL-HANDLE:ROW = wh-lote-economi-cd0204:SIDE-LABEL-HANDLE:ROW - 1
           wh-codigo-refer-cd0204:SIDE-LABEL-HANDLE:ROW = wh-codigo-refer-cd0204:SIDE-LABEL-HANDLE:ROW - 1
           wh-inform-compl-cd0204:SIDE-LABEL-HANDLE:ROW = wh-inform-compl-cd0204:SIDE-LABEL-HANDLE:ROW - 1
           wh-cod-imagem-cd0204:SIDE-LABEL-HANDLE:ROW   = wh-cod-imagem-cd0204:SIDE-LABEL-HANDLE:ROW   - 1
           wh-cb-idi-classif-item-cd0204:SIDE-LABEL-HANDLE:ROW = wh-cb-idi-classif-item-cd0204:SIDE-LABEL-HANDLE:ROW - 1.

    ASSIGN wh-cd-folh-item-cd0204:SIDE-LABEL-HANDLE:COLUMN = wh-cd-folh-item-cd0204:SIDE-LABEL-HANDLE:COLUMN - 5
           wh-lote-economi-cd0204:SIDE-LABEL-HANDLE:COLUMN = wh-lote-economi-cd0204:SIDE-LABEL-HANDLE:COLUMN - 5
           wh-codigo-refer-cd0204:SIDE-LABEL-HANDLE:COLUMN = wh-codigo-refer-cd0204:SIDE-LABEL-HANDLE:COLUMN - 5
           wh-inform-compl-cd0204:SIDE-LABEL-HANDLE:COLUMN = wh-inform-compl-cd0204:SIDE-LABEL-HANDLE:COLUMN - 5
           wh-cod-imagem-cd0204:SIDE-LABEL-HANDLE:COLUMN   = wh-cod-imagem-cd0204:SIDE-LABEL-HANDLE:COLUMN   - 5
           wh-cb-idi-classif-item-cd0204:SIDE-LABEL-HANDLE:COLUMN = wh-cb-idi-classif-item-cd0204:SIDE-LABEL-HANDLE:COLUMN - 5.

    CREATE TEXT tx-class-fiscal
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(21)"
           WIDTH        = 21
           SCREEN-VALUE = "Classificaá∆o Fiscal:"
           ROW          = wh-cb-idi-classif-item-cd0204:SIDE-LABEL-HANDLE:ROW + 1.15
           COL          = 8.9
           VISIBLE      = YES.

    CREATE FILL-IN wh-class-fiscal
    ASSIGN FRAME             = p-wgh-frame
           DATA-TYPE         = "character"
           FORMAT            = "9999.99.99" 
           WIDTH             = 13.72
           HEIGHT            = 0.88
           ROW               = wh-cb-idi-classif-item-cd0204:ROW + 1
           COL               = wh-cb-idi-classif-item-cd0204:COLUMN
           VISIBLE           = YES
           SENSITIVE         = NO.

    IF VALID-HANDLE(wh-class-fiscal) AND
       VALID-HANDLE(tx-class-fiscal) THEN
        ASSIGN wh-class-fiscal:SCREEN-VALUE = "0000.00.00":U.

    CREATE TEXT tx-peso-liquido
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(16)"
           WIDTH        = 20
           SCREEN-VALUE = "Peso Liquido:"
           ROW          = wh-lote-economi-cd0204:SIDE-LABEL-HANDLE:ROW + 0.15
           COL          = 54.75
           VISIBLE      = YES.

    CREATE FILL-IN wh-peso-liquido
    ASSIGN FRAME             = p-wgh-frame
           DATA-TYPE         = "decimal"
           FORMAT            = ">>>,>>9.99999" 
           WIDTH             = 13.72
           HEIGHT            = 0.88
           ROW               = tx-peso-liquido:ROW - 0.15
           COL               = 64.2
           VISIBLE           = YES
           SENSITIVE         = NO.


    CREATE TEXT tx-peso-liquido-label
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(02)"
           WIDTH        = 3
           SCREEN-VALUE = "kg"
           ROW          = tx-peso-liquido:ROW
           COL          = 78.2
           VISIBLE      = YES.

    IF  VALID-HANDLE(wh-peso-liquido) AND VALID-HANDLE(tx-peso-liquido) THEN 
        ASSIGN wh-peso-liquido:SCREEN-VALUE  = "0,00000". 

    CREATE TEXT tx-peso-bruto
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(17)"
           WIDTH        = 20
           SCREEN-VALUE = "Peso Bruto:"
           ROW          = wh-codigo-refer-cd0204:SIDE-LABEL-HANDLE:ROW + 0.15
           COL          = 55.95
           VISIBLE      = YES.

    CREATE FILL-IN wh-peso-bruto
    ASSIGN FRAME             = p-wgh-frame
           DATA-TYPE         = "decimal"
           FORMAT            = ">>>,>>9.99999" 
           WIDTH             = 13.72
           HEIGHT            = 0.88
           ROW               = tx-peso-bruto:ROW - 0.15
           COL               = 64.2
           VISIBLE           = YES
           SENSITIVE         = NO.

    CREATE TEXT tx-peso-bruto-label  
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(2)"
           WIDTH        = 3
           SCREEN-VALUE = "kg"
           ROW          = tx-peso-bruto:ROW
           COL          = 78.2
           VISIBLE      = YES.
     

    IF  VALID-HANDLE(wh-peso-bruto) AND VALID-HANDLE(tx-peso-bruto) THEN 
        ASSIGN wh-peso-bruto:SCREEN-VALUE  = "0,00000". 

    CREATE TEXT tx-comprim
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(15)"
           WIDTH        = 15
           SCREEN-VALUE = "Comprimento:"
           ROW          = wh-inform-compl-cd0204:SIDE-LABEL-HANDLE:ROW + 0.15
           COL          = 54.7
           VISIBLE      = YES.

    CREATE FILL-IN wh-comprim
    ASSIGN FRAME             = p-wgh-frame
           DATA-TYPE         = "decimal"
           FORMAT            = ">>>,>>9.99999" 
           WIDTH             = 13.72
           HEIGHT            = 0.88
           ROW               = tx-comprim:ROW - 0.15
           COL               = 64.2
           VISIBLE           = YES
           SENSITIVE         = NO.

    CREATE TEXT tx-comprim-label
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(2)"
           WIDTH        = 3
           SCREEN-VALUE = "mm"
           ROW          = tx-comprim:ROW
           COL          = 78.2
           VISIBLE      = YES.

    IF  VALID-HANDLE(wh-comprim)   AND VALID-HANDLE(tx-comprim) THEN 
        ASSIGN wh-comprim:SCREEN-VALUE  = "0,00000". 

    CREATE TEXT tx-largura
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(10)"
           WIDTH        = 15
           SCREEN-VALUE = "Largura:"
           ROW          = wh-cod-imagem-cd0204:SIDE-LABEL-HANDLE:ROW + 0.15
           COL          = 58.25
           VISIBLE      = YES.

    CREATE FILL-IN wh-largura
    ASSIGN FRAME             = p-wgh-frame
           DATA-TYPE         = "decimal"
           FORMAT            = ">>>,>>9.99999" 
           WIDTH             = 13.72
           HEIGHT            = 0.88
           ROW               = tx-largura:ROW - 0.15
           COL               = 64.2
           VISIBLE           = YES
           SENSITIVE         = NO.
    
    CREATE TEXT tx-largura-label
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(2)"
           WIDTH        = 3
           SCREEN-VALUE = "mm"
           ROW          = tx-largura:ROW
           COL          = 78.2
           VISIBLE      = YES.
    
    IF  VALID-HANDLE(wh-largura)   AND VALID-HANDLE(tx-largura) THEN
        ASSIGN wh-largura:SCREEN-VALUE  = "0,00000". 

    CREATE TEXT tx-altura
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(13)"
           WIDTH        = 15
           SCREEN-VALUE = "Altura:"
           ROW          = wh-cb-idi-classif-item-cd0204:ROW
           COL          = 59.6
           VISIBLE      = YES.

    CREATE FILL-IN wh-altura
    ASSIGN FRAME             = p-wgh-frame
           DATA-TYPE         = "decimal"
           FORMAT            = ">>>,>>9.99999" 
           WIDTH             = 13.72
           HEIGHT            = 0.88
           ROW               = tx-altura:ROW - 0.15
           COL               = 64.2
           VISIBLE           = YES
           SENSITIVE         = NO.

    CREATE TEXT tx-altura-label
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(2)"
           WIDTH        = 3
           SCREEN-VALUE = "mm"
           ROW          = tx-altura:ROW
           COL          = 78.2
           VISIBLE      = YES.

    CREATE toggle-box wh-catalogo-cd0204
    ASSIGN FRAME             = p-wgh-frame
           ROW               = wh-class-fiscal:row
           COL               = wh-altura:column - 23.5
           VISIBLE           = YES
           SENSITIVE         = NO
           WIDTH             = 15
           HEIGHT            = 0.88
           LABEL             = "Cat†logo Ariba".

    CREATE TEXT tx-dt-atualiza
    ASSIGN FRAME        = p-wgh-frame
           FORMAT       = "x(12)"
           WIDTH        = 11
           SCREEN-VALUE = "Dt Atualiza:"
           ROW          = wh-class-fiscal:row + 0.125
           COL          = wh-altura:column - 8
           VISIBLE      = YES.

    CREATE FILL-IN wh-dt-atualiza-cd0204
    ASSIGN FRAME             = p-wgh-frame
           DATA-TYPE         = "date"
           FORMAT            = "99/99/9999" 
           WIDTH             = 10
           HEIGHT            = 0.88
           ROW               = wh-class-fiscal:row
           COL               = wh-altura:column
           VISIBLE           = YES
           SENSITIVE         = NO.

    IF  VALID-HANDLE(wh-altura)   AND VALID-HANDLE(tx-altura) THEN 
        ASSIGN wh-altura:SCREEN-VALUE  = "0,00000". 
        
    IF VALID-HANDLE(wh-cod-imagem-cd0204) THEN
        wh-peso-liquido:MOVE-AFTER-TAB-ITEM(wh-cod-imagem-cd0204).

    IF VALID-HANDLE(wh-peso-liquido) THEN
        wh-peso-bruto:MOVE-AFTER-TAB-ITEM(wh-peso-liquido).

    IF VALID-HANDLE(wh-peso-bruto) THEN
        wh-comprim:MOVE-AFTER-TAB-ITEM(wh-peso-bruto).

    IF VALID-HANDLE(wh-comprim) THEN
        wh-largura:MOVE-AFTER-TAB-ITEM(wh-comprim).

    IF VALID-HANDLE(wh-largura) THEN
        wh-altura:MOVE-AFTER-TAB-ITEM(wh-largura).

    FIND FIRST ITEM 
        WHERE ROWID(ITEM) = p-row-table NO-ERROR.
    IF AVAIL ITEM 
    AND VALID-HANDLE(wh-peso-liquido) THEN
        ASSIGN wh-class-fiscal:screen-value = string(item.class-fiscal)
               wh-peso-liquido:SCREEN-VALUE = STRING(ITEM.peso-liquido,">>>,>>9.99999") 
               wh-peso-bruto:SCREEN-VALUE   = STRING(ITEM.peso-bruto,">>>,>>9.99999")   
               wh-comprim:SCREEN-VALUE      = STRING(ITEM.comprim,">>>,>>9.99999")  
               wh-altura:SCREEN-VALUE       = STRING(ITEM.altura,">>>,>>9.99999")       
               wh-largura:SCREEN-VALUE      = STRING(ITEM.largura,">>>,>>9.99999")
               r-row-id-item = p-row-table.

    FOR FIRST ITEM fields(it-codigo) NO-LOCK
        WHERE ROWID(ITEM) = p-row-table,
        FIRST int-item fields(it-codigo catalogo-ariba dt-atualiza) NO-LOCK
        WHERE int-item.it-codigo = ITEM.it-codigo:
        ASSIGN wh-catalogo-cd0204:CHECKED         = int-item.catalogo-ariba
               wh-dt-atualiza-cd0204:SCREEN-VALUE = STRING(int-item.dt-atualiza).
    END. /* for first item */

    create tt-cd0204-upc.
    assign tt-cd0204-upc.wh-container   = wh-container-cd0204
           tt-cd0204-upc.wh-frame       = p-wgh-frame:handle
           tt-cd0204-upc.wh-catalogo    = wh-catalogo-cd0204:handle
           tt-cd0204-upc.wh-dt-atualiza = wh-dt-atualiza-cd0204:handle
           tt-cd0204-upc.wh-item        = wh-it-codigo-cd0204:handle.
    find current tt-cd0204-upc no-error.
END.

IF p-ind-event  = "ADD":U        AND
   p-ind-object = "VIEWER":U     AND
   c-char       = "v35in172.w":U THEN DO:
    IF VALID-HANDLE(wh-lei-info-cd0204-upc) THEN
        ASSIGN wh-lei-info-cd0204-upc:CHECKED = NO.
END.

IF  p-ind-event  = "ADD"
AND c-char       = "v36in172.w" THEN DO:

    IF VALID-HANDLE(tx-peso-liquido) THEN
        ASSIGN tx-peso-liquido:SCREEN-VALUE = "Peso Liquido:":U.

    IF VALID-HANDLE(tx-peso-liquido-label) THEN
        ASSIGN tx-peso-liquido-label:SCREEN-VALUE = "kg":U.

    IF VALID-HANDLE(tx-peso-bruto) THEN
        ASSIGN tx-peso-bruto:SCREEN-VALUE = "Peso Bruto:":U.

    IF VALID-HANDLE(tx-peso-bruto-label) THEN
        ASSIGN tx-peso-bruto-label:SCREEN-VALUE = "kg":U.

    IF VALID-HANDLE(tx-comprim) THEN
        ASSIGN tx-comprim:SCREEN-VALUE = "Comprimento:":U.

    IF VALID-HANDLE(tx-comprim-label) THEN
        ASSIGN tx-comprim-label:SCREEN-VALUE = "mm":U.

    IF VALID-HANDLE(tx-largura) THEN
        ASSIGN tx-largura:SCREEN-VALUE = "Largura:":U.

    IF VALID-HANDLE(tx-largura-label) THEN
        ASSIGN tx-largura-label:SCREEN-VALUE = "mm":U.

    IF VALID-HANDLE(tx-altura) THEN
        ASSIGN tx-altura:SCREEN-VALUE = "Altura:":U.

    IF VALID-HANDLE(tx-altura-label) THEN
        ASSIGN tx-altura-label:SCREEN-VALUE = "mm":U.

    for first tt-cd0204-upc
        where tt-cd0204-upc.wh-frame = p-wgh-frame:
        if valid-handle(tt-cd0204-upc.wh-catalogo)
        then assign tt-cd0204-upc.wh-catalogo:checked = no.

        if valid-handle(tt-cd0204-upc.wh-dt-atualiza)
        then assign tt-cd0204-upc.wh-dt-atualiza:screen-value = "".
    end.
END.

IF p-ind-event  = "DISPLAY":U    AND
   p-ind-object = "VIEWER":U     AND
   c-char       = "v35in172.w":U THEN DO:
    IF p-cod-table = "item":U THEN DO:
        FIND FIRST item
             WHERE ROWID(item) = p-row-table NO-LOCK NO-ERROR.
        IF AVAILABLE item THEN DO:
            FIND FIRST int-portaria-movto NO-LOCK
                 WHERE int-portaria-movto.it-codigo = item.it-codigo
                   AND int-portaria-movto.dt-fim = ?
                   AND int-portaria-movto.classificacao <> "BEM" NO-ERROR.
            IF VALID-HANDLE(wh-lei-info-cd0204-upc) THEN
                ASSIGN wh-lei-info-cd0204-upc:CHECKED = AVAIL int-portaria-movto.
        END.
    END.
END.

IF  p-ind-event = "DISPLAY"
AND c-char      = "v36in172.w" THEN DO:
    FIND FIRST ITEM 
        WHERE ROWID(ITEM) = p-row-table NO-ERROR.
    IF AVAIL ITEM
    then do:
         if VALID-HANDLE(wh-peso-liquido) THEN
              ASSIGN wh-class-fiscal:screen-value = string(item.class-fiscal)
                     wh-peso-liquido:SCREEN-VALUE = STRING(ITEM.peso-liquido,">>>,>>9.99999") 
                     wh-peso-bruto:SCREEN-VALUE   = STRING(ITEM.peso-bruto,">>>,>>9.99999")   
                     wh-comprim:SCREEN-VALUE      = STRING(ITEM.comprim,">>>,>>9.99999")  
                     wh-altura:SCREEN-VALUE       = STRING(ITEM.altura,">>>,>>9.99999")       
                     wh-largura:SCREEN-VALUE      = STRING(ITEM.largura,">>>,>>9.99999")
                     r-row-id-item = p-row-table.

         for first tt-cd0204-upc
             where tt-cd0204-upc.wh-frame = p-wgh-frame:
             if  valid-handle(tt-cd0204-upc.wh-catalogo)
             and valid-handle(tt-cd0204-upc.wh-dt-atualiza)
             then do:
                  assign tt-cd0204-upc.wh-catalogo:checked         = no
                         tt-cd0204-upc.wh-dt-atualiza:screen-value = "".

                  for first int-item no-lock 
                      where int-item.it-codigo = item.it-codigo:
                      assign tt-cd0204-upc.wh-catalogo:checked         = int-item.catalogo-ariba
                             tt-cd0204-upc.wh-dt-atualiza:screen-value = string(int-item.dt-atualiza).
                  end. /* for first int-item */
             end. /* if valid-handle(tt-cd0204-upc.wh-catalogo) */
         end. /* for first tt-cd0204-upc */
    end. /* IF AVAIL ITEM */
END.

IF  p-ind-event  = "ENABLE"
AND c-char       = "v36in172.w" THEN do:

  /*  assign wh-peso-liquido:SENSITIVE = YES
           wh-peso-bruto:SENSITIVE   = YES
           wh-comprim:SENSITIVE      = YES 
           wh-largura:SENSITIVE      = YES
           wh-altura:SENSITIVE       = YES
           wh-cb-motivo-sit-cd0204:SENSITIVE   = YES.*/
           
    if v_cod_estab_usuar = "102" then do:

       IF VALID-HANDLE(wh-class-fiscal) THEN
          assign wh-class-fiscal:sensitive = yes.
    end.

    for first tt-cd0204-upc
        where tt-cd0204-upc.wh-frame = p-wgh-frame:
        if valid-handle(tt-cd0204-upc.wh-catalogo)
        then assign tt-cd0204-upc.wh-catalogo:sensitive = yes.
    end. /* for first tt-cd0204-upc */
end.
        
           

IF  p-ind-event  = "DISABLE"
AND c-char       = "v36in172.w" THEN do:

    ASSIGN wh-peso-liquido:SENSITIVE = NO
           wh-peso-bruto:SENSITIVE   = NO
           wh-comprim:SENSITIVE      = NO 
           wh-largura:SENSITIVE      = NO
           wh-altura:SENSITIVE       = NO
           wh-cb-motivo-sit-cd0204:SENSITIVE   = NO.
           
    if v_cod_estab_usuar = "102" then do:
       IF VALID-HANDLE(wh-class-fiscal) THEN
       ASSIGN wh-class-fiscal:sensitive = no.

    end.

    for first tt-cd0204-upc
        where tt-cd0204-upc.wh-frame = p-wgh-frame:
        if valid-handle(tt-cd0204-upc.wh-catalogo)
        then assign tt-cd0204-upc.wh-catalogo:sensitive = no.
    end. /* for first tt-cd0204-upc */
end.

/*
IF c-char = "v35in172.w" THEN
    MESSAGE p-ind-event
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
        */

IF  p-ind-event  = "ASSIGN"
AND c-char       = "v36in172.w" THEN DO:

    FIND FIRST ITEM 
        WHERE ROWID(ITEM) = p-row-table NO-ERROR.
    IF AVAIL ITEM THEN DO:
       /* IF SUBSTRING(ITEM.it-codigo,1,1) = "4" THEN DO:
            IF DEC(wh-peso-liquido:SCREEN-VALUE) = 0 THEN DO:
                MESSAGE "Peso Liquido deve ser diferente de zero"
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                RETURN "NOK".
            END.
            IF DEC(wh-peso-bruto:SCREEN-VALUE) = 0 THEN DO:
                MESSAGE "Peso Bruto deve ser diferente de zero"
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                RETURN "NOK".
            END. 
            IF DEC(wh-comprim:SCREEN-VALUE) = 0 THEN DO:
                MESSAGE "Comprimento deve ser diferente de zero"
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                RETURN "NOK".
            END.
            IF DEC(wh-altura:SCREEN-VALUE) = 0 THEN DO:
                MESSAGE "Altura deve ser diferente de zero"
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                RETURN "NOK".
            END.
            IF DEC(wh-largura:SCREEN-VALUE) = 0 THEN DO:
                MESSAGE "Largura deve ser diferente de zero"
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                RETURN "NOK".
            END.
        END.
        */
        if v_cod_estab_usuar = "102" then do:
        
            IF string(wh-class-fiscal:SCREEN-VALUE) = "0000.00.00" THEN DO:
                MESSAGE string(c-seg-usuario) + " , " +  "A Classificaá∆o Fiscal deve ser informada"
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                RETURN "NOK".
            END.
        
            IF string(int(wh-class-fiscal:screen-value)) <> "" THEN DO:
                FIND FIRST classif-fisc where 
                      classif-fisc.class-fiscal = string(int(wh-class-fiscal:screen-value)) no-lock no-error.
                if not avail classif-fisc then do:
                    MESSAGE "Classificacao Fiscal n∆o cadastrada !!, Favor cadastrar no programa - cd0603"
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                    RETURN "NOK".
                END.
            END.
        end.
        

        ASSIGN ITEM.peso-liquido = DEC(wh-peso-liquido:SCREEN-VALUE)
               ITEM.peso-bruto   = DEC(wh-peso-bruto:SCREEN-VALUE)
               ITEM.comprim      = DEC(wh-comprim:SCREEN-VALUE)
               ITEM.altura       = DEC(wh-altura:SCREEN-VALUE)
               ITEM.largura      = DEC(wh-largura:SCREEN-VALUE).
        if v_cod_estab_usuar = "102" then do:
           assign item.class-fiscal = string(int(wh-class-fiscal:screen-value)).
        end.

        for first tt-cd0204-upc
            where tt-cd0204-upc.wh-frame = p-wgh-frame:
            if not valid-handle(tt-cd0204-upc.wh-catalogo)
            then leave.

            for first int-item
                where int-item.it-codigo = item.it-codigo
                      exclusive-lock: end.

            if not avail int-item
            then do:
                 create int-item.
                 assign int-item.it-codigo = item.it-codigo.
            end.

            /* se alteraá∆o, salva; se inclus∆o, valor ser† definido pela trigger de write */
            IF NOT tt-cd0204-upc.wh-item:SENSITIVE 
            THEN assign int-item.catalogo-ariba = tt-cd0204-upc.wh-catalogo:checked.
            find current int-item no-lock no-error.
        end. /* for first tt-cd0204-upc */
        
    END.
END.

/* viewer FISCAIS */
IF  p-ind-object = "VIEWER"
AND c-char     = "v84in172.w" THEN DO:

    IF p-ind-event = "BEFORE-INITIALIZE" THEN DO:

        /*narrativa*/
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "editor",     /*** Type ***/
                      INPUT "narrativa",         /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-narrativa-cd0204).

        /*retangulo*/
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "rectangle",     /*** Type ***/
                      INPUT "rt-mold",         /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-rect-narrat-cd0204).

        ASSIGN p-wgh-frame:ROW = p-wgh-frame:ROW - 0.6
               p-wgh-frame:COL = p-wgh-frame:COL - 1.2
               p-wgh-frame:HEIGHT-CHARS = 10.9
               p-wgh-frame:WIDTH-CHARS  = 87.9.

        IF VALID-HANDLE(wh-rect-narrat-cd0204) THEN
            ASSIGN wh-narrativa-cd0204:HEIGHT-CHARS = 3
                   wh-narrativa-cd0204:WIDTH-CHARS  = 85
                   wh-rect-narrat-cd0204:ROW = 1
                   wh-rect-narrat-cd0204:COL = 1
                   wh-rect-narrat-cd0204:HEIGHT-CHARS = 9.9
                   wh-rect-narrat-cd0204:WIDTH-CHARS  = 87.4.

        CREATE TEXT wh-tx-narrativa1
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(15)"   
               WIDTH        = 20
               SCREEN-VALUE = "Narrativa:"
               ROW          = 1.1
               COL          = 2
               VISIBLE      = YES.

        CREATE TEXT wh-tx-narrativa2
        ASSIGN FRAME        = p-wgh-frame
               FORMAT       = "x(18)"   
               WIDTH        = 20
               SCREEN-VALUE = "Narrativa Manaus:"
               ROW          = 7
               COL          = 2
               VISIBLE      = YES.

        CREATE EDITOR wh-narrativa2-cd0204
        ASSIGN FRAME              = p-wgh-frame
               DATA-TYPE          = wh-narrativa-cd0204:DATA-TYPE
               FONT               = wh-narrativa-cd0204:FONT
               WIDTH              = wh-narrativa-cd0204:WIDTH
               HEIGHT             = wh-narrativa-cd0204:HEIGHT
               ROW                = wh-narrativa-cd0204:ROW + 6
               COL                = wh-narrativa-cd0204:COL
               SCROLLBAR-VERTICAL = YES
               MAX-CHARS          = 1999
               VISIBLE            = YES
               SENSITIVE          = YES
               READ-ONLY          = YES.

        /*esse comando esconde a tela no before-initialize pois ocorria problema de ficar na frente quando clicado em outro folder*/
        ASSIGN p-wgh-frame:HIDDEN = YES.
    END.
    ELSE IF p-ind-event = "after-enable" THEN DO:    
        ASSIGN wh-narrativa2-cd0204:SENSITIVE = wh-narrativa-cd0204:SENSITIVE
               wh-narrativa2-cd0204:READ-ONLY = wh-narrativa-cd0204:READ-ONLY.
    END.
    ELSE IF p-ind-event = "after-disable" THEN DO:    
        ASSIGN wh-narrativa2-cd0204:SENSITIVE = wh-narrativa-cd0204:SENSITIVE
               wh-narrativa2-cd0204:READ-ONLY = wh-narrativa-cd0204:READ-ONLY.
    END.
    ELSE IF p-ind-event = "display" THEN DO:    
        FIND FIRST ITEM 
            WHERE ROWID(ITEM) = p-row-table NO-ERROR.
        IF AVAIL ITEM THEN DO:
            IF INDEX(ITEM.narrativa,"#MANAUS#") <> 0 THEN DO:
                ASSIGN wh-narrativa-cd0204:SCREEN-VALUE  = TRIM(SUBSTRING(ITEM.narrativa,1,INDEX(ITEM.narrativa,"#MANAUS#") - 1))
                       wh-narrativa2-cd0204:SCREEN-VALUE = TRIM(SUBSTRING(ITEM.narrativa,INDEX(ITEM.narrativa,"#MANAUS#") + 8,LENGTH(ITEM.narrativa))).
            END.
            ELSE DO:
                ASSIGN wh-narrativa2-cd0204:SCREEN-VALUE = "".
            END.
        END.
    END.
    ELSE IF p-ind-event = "assign" THEN DO:    
        FIND FIRST ITEM 
            WHERE ROWID(ITEM) = p-row-table NO-ERROR.
        IF AVAIL ITEM THEN DO:
            ASSIGN ITEM.narrativa = TRIM(REPLACE(wh-narrativa-cd0204:SCREEN-VALUE,"#MANAUS#","")) +
                                    (IF TRIM(REPLACE(wh-narrativa2-cd0204:SCREEN-VALUE,"#MANAUS#","")) <> "" THEN 
                                        "#MANAUS#" + TRIM(REPLACE(wh-narrativa2-cd0204:SCREEN-VALUE,"#MANAUS#",""))
                                     ELSE "").
        END.
    END.
END.


/* viewer FISCAIS */
/** criaá∆o flag e campo Observaá∆o **/
IF  p-ind-object = "VIEWER"
AND c-char     = "vb2in172.w" THEN DO:

    IF p-ind-event = "BEFORE-INITIALIZE" THEN DO:

        /*narrativa*/
        RUN tela-upc (INPUT p-wgh-frame,
                      INPUT p-ind-Event,
                      INPUT "toggle-box",     /*** Type ***/
                      INPUT "log-necessita-li",         /*** Name ***/
                      INPUT NO,            /*** Apresenta Mensagem dos Objetos ***/
                      INPUT 1,             /*** Quando existir mais de um objeto com o mesmo nome ***/
                      OUTPUT wh-necessita-li-cd0204).
        IF VALID-HANDLE(wh-necessita-li-cd0204) THEN DO:
            ASSIGN wh-necessita-li-cd0204:ROW = 1.5
                   wh-necessita-li-cd0204:COL = wh-necessita-li-cd0204:COL - 22.
            create toggle-box wh-log-antidump-esp
            ASSIGN FRAME      = p-wgh-frame
                   WIDTH      = wh-necessita-li-cd0204:WIDTH
                   HEIGHT     = 0.88
                   ROW        = wh-necessita-li-cd0204:ROW + 0.7
                   HELP       = "Tem antidumping?"
                   LABEL      = "Tem Antidumping"
                   COL        = wh-necessita-li-cd0204:COL
                   NAME       = "v_log_antidumping_esp"
                   FORMAT     = "YES/NO"
                   sensitive  = FALSE
                   triggers:
                       on value-changed persistent run upc/cd0204-upc-a.p (input "VALUE-CHANGED").
                   end triggers.
            
            CREATE TEXT wh-tx-obs-antidump
            ASSIGN FRAME        = p-wgh-frame
                   FORMAT       = "x(25)"   
                   WIDTH        = 30
                   SCREEN-VALUE = "Observaá∆o Antidumping:"
                   ROW          = wh-necessita-li-cd0204:ROW + 1.7
                   COL          = wh-necessita-li-cd0204:COL + 0.5
                   VISIBLE      = YES.
            
            CREATE EDITOR wh-obs-antidumping
            ASSIGN FRAME              = p-wgh-frame
                   DATA-TYPE          = "character"
                   INNER-CHARS        = 110
                   INNER-LINES        = 3.5
                   ROW                = wh-necessita-li-cd0204:ROW + 2.3
                   COL                = wh-necessita-li-cd0204:COL
                   SCROLLBAR-VERTICAL = YES
                   MAX-CHARS          = 1999
                   VISIBLE            = YES
                   SENSITIVE          = NO.
        END.
    END.
    ELSE IF p-ind-event = "after-enable" THEN DO:  
        APPLY "VALUE-CHANGED":U TO wh-cb-cod-obsoleto-cd0204.
        ASSIGN wh-log-antidump-esp:SENSITIVE = yes.
        IF wh-log-antidump-esp:CHECKED THEN
            ASSIGN wh-obs-antidumping:sensitive = YES
                   /*wh-obs-antidumping:SCREEN-VALUE = ""*/.
        ELSE
            ASSIGN wh-obs-antidumping:sensitive = no
                   wh-obs-antidumping:SCREEN-VALUE = "".
    END.
    ELSE IF p-ind-event = "after-disable" THEN DO:    
        ASSIGN wh-log-antidump-esp:SENSITIVE = no
               wh-obs-antidumping:sensitive = no.
    END.
    ELSE IF p-ind-event = "display" THEN DO:    
        FIND FIRST ITEM 
            WHERE ROWID(ITEM) = p-row-table NO-LOCK NO-ERROR.
        IF AVAIL ITEM THEN DO:
            FIND FIRST int-item OF ITEM NO-LOCK NO-ERROR.
            IF AVAIL int-item THEN
                ASSIGN wh-log-antidump-esp:CHECKED     = int-item.log-antidumping
                       wh-obs-antidumping:SCREEN-VALUE = int-item.obs-antidumping
                       wh-cb-motivo-sit-cd0204:SCREEN-VALUE = string(int-item.motivo-situacao).
            ELSE
                ASSIGN wh-log-antidump-esp:CHECKED     = NO
                       wh-obs-antidumping:SCREEN-VALUE = ""
                       wh-cb-motivo-sit-cd0204:SCREEN-VALUE = "0".

        END.
    END.
    ELSE IF p-ind-event = "assign" THEN DO:    
        FIND FIRST ITEM 
            WHERE ROWID(ITEM) = p-row-table NO-ERROR.
        IF AVAIL ITEM THEN DO:
            FIND FIRST int-item OF ITEM exclusive-lock NO-ERROR.
            IF NOT AVAIL int-item THEN DO:
                CREATE int-item.
                ASSIGN int-item.it-codigo = ITEM.it-codigo.
            END.

            ASSIGN int-item.log-antidumping = wh-log-antidump-esp:CHECKED     
                   int-item.obs-antidumping = wh-obs-antidumping:SCREEN-VALUE
                   int-item.motivo-situacao = int(wh-cb-motivo-sit-cd0204:SCREEN-VALUE). 
            
        END.
    END.
    ELSE IF p-ind-event = "ADD" THEN DO:    
        ASSIGN wh-log-antidump-esp:CHECKED     = NO 
               wh-obs-antidumping:SCREEN-VALUE = "".
    END.
END.

IF p-ind-event  = "DESTROY":U   AND
   p-ind-object = "CONTAINER":U AND
   c-char       = "cd0204.w":U  THEN DO:

    IF VALID-HANDLE(wh-lei-info-cd0204-upc) THEN
        DELETE WIDGET wh-lei-info-cd0204-upc.

    ASSIGN wh-it-codigo-cd0204       = ?
           wh-cb-cod-obsoleto-cd0204 = ?.

    IF VALID-HANDLE(h-upc-cd0204) THEN
        DELETE WIDGET h-upc-cd0204.

    FOR FIRST tt-cd0204-upc
        WHERE tt-cd0204-upc.wh-container = p-wgh-object:
        DELETE tt-cd0204-upc.
    END.

    ASSIGN h-upc-cd0204 = ?.
END.

PROCEDURE tela-upc:
    DEFINE INPUT  PARAMETER  pWghFrame    AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT  PARAMETER  pIndEvent    AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjType     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pObjName     AS CHARACTER     NO-UNDO.
    DEFINE INPUT  PARAMETER  pApresMsg    AS LOGICAL       NO-UNDO.
    DEFINE INPUT  PARAMETER  pAux         AS INTEGER       NO-UNDO.
    DEFINE OUTPUT PARAMETER  phObj        AS HANDLE        NO-UNDO.

    DEFINE VARIABLE wgh-obj AS WIDGET-HANDLE NO-UNDO.
    DEFINE VARIABLE i-aux   AS INTEGER       NO-UNDO.

    ASSIGN wgh-obj = pWghFrame:FIRST-CHILD
           i-aux   = 0.

    DO WHILE VALID-HANDLE(wgh-obj):                                

        IF pApresMsg = YES THEN                                    
            MESSAGE "Nome do Objeto" wgh-obj:NAME SKIP             
                    "Type do Objeto" wgh-obj:TYPE SKIP             
                    "P-Ind-Event"    pIndEvent VIEW-AS ALERT-BOX.  

        IF wgh-obj:TYPE = pObjType AND
           wgh-obj:NAME = pObjName THEN DO:
            ASSIGN phObj = wgh-obj:HANDLE
                   i-aux = i-aux + 1.

            IF i-aux = pAux THEN
                LEAVE.
        END.
        IF wgh-obj:TYPE = "field-group" THEN
            ASSIGN wgh-obj = wgh-obj:FIRST-CHILD.
        ELSE
            ASSIGN wgh-obj = wgh-obj:NEXT-SIBLING.
    END.
END PROCEDURE.

PROCEDURE pi-bt-ok:

    IF  wh-cb-cod-obsoleto-cd0204:SCREEN-VALUE = "Obsoleto Ordens Autom†ticas" 
    AND wh-cb-motivo-sit-cd0204:SCREEN-VALUE   = "0" THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 17006,
                           INPUT "Informe o motivo da situaá∆o Obsoleto Ordens Autom†ticas.").
        RETURN "NOK".
    END.

    IF VALID-HANDLE(wh-it-codigo-cd0204) AND
        NOT CAN-FIND(FIRST bf-item
                     WHERE bf-item.it-codigo = wh-it-codigo-cd0204:SCREEN-VALUE) THEN DO:

        IF VALID-HANDLE(wh-ge-codigo-cd0204) THEN DO: 
            IF wh-ge-codigo-cd0204:SCREEN-VALUE = "10" OR
               wh-ge-codigo-cd0204:SCREEN-VALUE = "12" OR
               wh-ge-codigo-cd0204:SCREEN-VALUE = "15" THEN DO:
            
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT "Cadastro N∆o Permitido.~~O Cadastro de matÇria-prima deve ser realizado via SharePoint.").
            
            END.
            ELSE
                APPLY "CHOOSE" to wh-bt-ok-cd0204.
        END.
        ELSE
            APPLY "CHOOSE" to wh-bt-ok-cd0204.
    END.
    ELSE
        APPLY "CHOOSE" to wh-bt-ok-cd0204.
END PROCEDURE.

PROCEDURE busca-handle:

    DEFINE INPUT  PARAMETER p-wgh-frame  AS WIDGET-HANDLE    NO-UNDO.  /* Handle da Frame Principal do programa */
    DEFINE INPUT  PARAMETER p-nome-obj   AS CHARACTER        NO-UNDO.  /* Nome do objeto que se dejesa achar o handle */
    DEFINE OUTPUT PARAMETER p-handl-obj  AS WIDGET-HANDLE    NO-UNDO.  /* Handle do Componente */

    DEFINE VARIABLE h-aux   AS WIDGET-HANDLE    NO-UNDO.
    DEFINE VARIABLE h-prox AS HANDLE     NO-UNDO.


    /* Frame Principal */
    ASSIGN h-aux = p-wgh-frame
           h-prox = ?.

    /* field-group */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    /* Primeiro componente da Frame */
    ASSIGN h-aux = h-aux:FIRST-CHILD.

    REPEAT:
        IF NOT valid-handle(h-aux) AND
           NOT VALID-HANDLE(h-prox) THEN DO:

            ASSIGN h-aux = ?.
            LEAVE.
        END.

        IF NOT valid-handle(h-aux) THEN DO:
            ASSIGN h-aux = h-prox.
            ASSIGN h-prox = ?.
            NEXT.
        END.

        IF h-aux:NAME = "panel-frame" THEN DO:

            ASSIGN h-prox = h-aux:NEXT-SIBLING.
            ASSIGN h-aux = h-aux:FIRST-CHILD.
            ASSIGN h-aux = h-aux:FIRST-CHILD.

            NEXT.
        END.

        IF h-aux:NAME <> p-nome-obj THEN DO:
            ASSIGN h-aux = h-aux:NEXT-SIBLING.
            
            IF NOT VALID-HANDLE(h-aux) THEN
                NEXT.
        END.
        ELSE DO:
            ASSIGN p-handl-obj = h-aux.
            LEAVE.
        END.
    END.
END.

PROCEDURE pi-value-change-cod-obsoleto:

    /*S¢ habilita o motivo situaá∆o para quem tem o situaá∆o ativo*/
    IF wh-cb-cod-obsoleto-cd0204:SENSITIVE THEN DO:

        IF wh-cb-cod-obsoleto-cd0204:SCREEN-VALUE = "Obsoleto Ordens Autom†ticas" THEN DO:
            ASSIGN wh-cb-motivo-sit-cd0204:SENSITIVE = YES.
        END.
        ELSE DO:
            ASSIGN wh-cb-motivo-sit-cd0204:SENSITIVE    = NO
                   wh-cb-motivo-sit-cd0204:SCREEN-VALUE = "0".
        END.
    END.
    ELSE 
        ASSIGN wh-cb-motivo-sit-cd0204:SENSITIVE = NO.
END.

