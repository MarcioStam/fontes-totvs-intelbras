/*******************************************************************************
** Programa: up-ft0502 (UPC do FT0502 - Manuten‡Æo Informa‡äes CW NFS-e)
** Autor...: Conceito W
** Data....: 23/11/2009
/**ATUALIZACAO: 20/03/2012**/
*******************************************************************************/

/*-> Definicao de Parametros <-*/
DEF INPUT PARAM p-ind-event  AS CHAR          NO-UNDO.
DEF INPUT PARAM p-ind-object AS CHAR          NO-UNDO.
DEF INPUT PARAM p-wgh-object AS HANDLE        NO-UNDO.
DEF INPUT PARAM p-wgh-frame  AS WIDGET-HANDLE NO-UNDO.
DEF INPUT PARAM p-cod-table  AS CHAR          NO-UNDO.
DEF INPUT PARAM p-row-table  AS ROWID         NO-UNDO.

/*-> Goblal Variable Definitions <-*/
DEF NEW GLOBAL SHARED VAR adm-broker-hdl        AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-folder              AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR h-viewer              AS HANDLE        NO-UNDO.
DEF NEW GLOBAL SHARED VAR r-nota-fiscal_ft0502  AS ROWID         NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-bt-url_ft0502      AS WIDGET-HANDLE NO-UNDO.

/*-> Variable Definitions <-*/
DEF VAR c-objeto      AS CHAR          NO-UNDO.
DEF VAR c-folder      AS CHAR          NO-UNDO.
DEF VAR c-objects     AS CHAR          NO-UNDO.
DEF VAR h-query       AS WIDGET-HANDLE NO-UNDO.
DEF VAR i-objects     AS INTEGER       NO-UNDO.
DEF VAR h-object      AS HANDLE        NO-UNDO.
DEF VAR h-viewer-prin AS WIDGET-HANDLE NO-UNDO.
def var h-cadsi2      as Widget-handle no-undo.
DEF VAR i-cont        AS INT           NO-UNDO.
DEF VAR i-new-page    AS INT           NO-UNDO.

ASSIGN c-objeto = ENTRY(NUM-ENTRIES(p-wgh-object:PRIVATE-DATA, "~/"), p-wgh-object:PRIVATE-DATA, "~/") no-error.

/*
message "EVENTO:" p-ind-event skip
        "OBJETO:" p-ind-object skip
        "NOME OBJ:" c-objeto skip
        "FRAME:" p-wgh-frame skip
        "TABELA:" p-cod-table skip
        "ROWID:" string(p-row-table) view-as alert-box.
*/


/*Funcao para recuperar handle dos objetos em tela*/
FUNCTION recuperarHandleObjeto RETURNS WIDGET-HANDLE (INPUT pc-campo   AS CHARACTER,
                                                      INPUT wh-pointer AS WIDGET-HANDLE):

    DEFINE VARIABLE wh-grupo AS WIDGET-HANDLE NO-UNDO.

    ASSIGN wh-grupo = wh-pointer:FIRST-CHILD.
    DO WHILE VALID-HANDLE(wh-grupo):

       IF wh-grupo:NAME = pc-campo THEN
          RETURN wh-grupo.

       IF wh-grupo:TYPE = "field-group" OR wh-grupo:TYPE = "frame" THEN
          wh-grupo      = wh-grupo:FIRST-CHILD.
       ELSE
          wh-grupo      = wh-grupo:NEXT-SIBLING.
    END.
END FUNCTION.


IF  p-ind-event  = "DISPLAY"    AND
    p-ind-object = "VIEWER"     AND
    c-objeto     = "v08di135.w" THEN DO:

    assign r-nota-fiscal_ft0502 = p-row-table.

    if  valid-handle(h-viewer) then
        run pi-atualiza-parent in h-viewer (input p-row-table).
END.

/*Inserindo Novo Folder*/
IF  p-ind-event  = "INITIALIZE" AND
    p-ind-object = "CONTAINER"  THEN DO:

    /*Botao Consulta URL*/
    CREATE BUTTON wh-bt-url_ft0502
    ASSIGN FRAME     = p-wgh-frame
           NAME      = "wh-bt-url_ft0502"
           WIDTH     = 4
           HEIGHT    = 1.2
           TOOLTIP   = "Link NFS-e"
           ROW       = 1.3
           COL       = 50
           VISIBLE   = YES
           SENSITIVE = YES.

    wh-bt-url_ft0502:LOAD-IMAGE-UP("image\bt-ie.png").
    wh-bt-url_ft0502:LOAD-IMAGE-INSENSITIVE("image\bt-cw.png").
    wh-bt-url_ft0502:MOVE-TO-TOP().

    ON 'choose':U OF wh-bt-url_ft0502 PERSISTENT RUN rpp/espnfse2060b.p.


    /*Folder Especifico*/
    RUN get-link-handle IN adm-broker-hdl (INPUT p-wgh-object,
                                           INPUT "PAGE-SOURCE":U,
                                           OUTPUT c-folder).

    ASSIGN h-folder = WIDGET-HANDLE(c-folder) NO-ERROR.

    IF  VALID-HANDLE(h-folder) THEN DO:
        
        ASSIGN i-cont = 1.
        DO  WHILE i-new-page = 0 OR i-cont >= 10:

            RUN pi-state-folder IN h-folder (INPUT i-cont).
            
            IF  RETURN-VALUE = "NO":U THEN
                ASSIGN i-new-page = i-cont.

            ASSIGN i-cont = i-cont + 1.
        END.

        RUN create-folder-page  IN h-folder (INPUT i-new-page,
                                             INPUT "NFS-e":U).

        RUN create-folder-label IN h-folder (INPUT i-new-page,
                                             INPUT "NFS-e":U).

        RUN select-page         IN p-wgh-object (INPUT i-new-page).

        
        RUN init-object IN p-wgh-object (INPUT "upc/ft0502v01-upc.w",
                                         INPUT p-wgh-frame,
                                         INPUT "Layout = ":U,
                                         OUTPUT h-viewer).

        RUN set-position IN h-viewer (8,4).

        RUN get-link-handle IN adm-broker-hdl (INPUT p-wgh-object,
                                               INPUT "CONTAINER-TARGET":U,
                                               OUTPUT c-objects).

        RUN dispatch IN h-viewer ("initialize":U).

        
        DO  i-objects = 1 TO NUM-ENTRIES(c-objects):
            ASSIGN h-object = WIDGET-HANDLE(ENTRY(i-objects, c-objects)).

            IF  h-object:FILE-NAME = "diqry/q01di135.w" THEN
                ASSIGN h-query = h-object.
            IF  h-object:FILE-NAME = "ftp/ft0502-v02.w" THEN
                ASSIGN h-viewer-prin = h-object.
            IF  h-object:FILE-NAME = "panel/p-cadsi2.w" THEN
                ASSIGN h-cadsi2 = h-object.
        END.
        
        RUN add-link IN adm-broker-hdl (INPUT h-query,
                                        INPUT 'RECORD':U,
                                        INPUT h-viewer).
        
        RUN add-link IN adm-broker-hdl (INPUT h-viewer-prin,
                                        INPUT 'GROUP-ASSIGN':U,
                                        INPUT h-viewer).
        
        RUN add-link IN adm-broker-hdl (INPUT h-cadsi2,
                                        INPUT 'State':U,
                                        INPUT h-viewer).
        
        RUN dispatch           IN h-viewer     ("initialize":U).
        RUN pi-atualiza-parent IN h-viewer     (input r-nota-fiscal_ft0502).
        RUN dispatch           IN h-viewer     (INPUT 'display-fields':U ) .
        RUN select-page        IN p-wgh-object (INPUT 1).
    END.
END.




