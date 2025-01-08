/*************************************************************************
    Programa.:  UPC-FT0114
    Objetivo.:  UPC do programa ft0114 - Serie X Estabelecimento
    Data.....:  Julho de 2010
*************************************************************************/

/*********************** Defini‡Æo de Parƒmetros *************************/
DEFINE INPUT PARAMETER p-ind-event                  AS CHARACTER      NO-UNDO.
DEFINE INPUT PARAMETER p-ind-object                 AS CHARACTER      NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-object                 AS HANDLE         NO-UNDO.
DEFINE INPUT PARAMETER p-wgh-frame                  AS WIDGET-HANDLE  NO-UNDO.
DEFINE INPUT PARAMETER p-cod-table                  AS CHARACTER      NO-UNDO.
DEFINE INPUT PARAMETER p-row-table                  AS ROWID          NO-UNDO.

/******************** Defini‡Æo de Vari veis Globais **********************/
DEFINE NEW GLOBAL SHARED VAR wgh-log-processo-manual     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wgh-rs-tipo-emissao         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-tg-log-nf-eletro         AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wgh-handle-container-cd0403 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-tx-tp-emissao            AS WIDGET        NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR h-programa                  AS WIDGET        NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wgh-window                  AS WIDGET        NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-button-upc-cd0403        AS WIDGET        NO-UNDO.
/**************************************************************************/
DEFINE VARIABLE wh-f-main                            AS WIDGET        NO-UNDO.
DEFINE VARIABLE wh-ret-1                             AS WIDGET        NO-UNDO.
DEFINE VARIABLE wh-ret-7                             AS WIDGET        NO-UNDO.

/******************** Defini‡Æo de Vari veis Locais **********************/
DEFINE VARIABLE c-char                              AS CHARACTER      NO-UNDO.
DEFINE VARIABLE wh-objeto                           AS WIDGET-HANDLE  NO-UNDO.
DEFINE VARIABLE l-funcao-nfe                        AS LOGICAL        NO-UNDO INITIAL NO.

/************************** In¡cio do Programa ***************************/
ASSIGN c-char = ENTRY(NUM-ENTRIES(p-wgh-object:FILE-NAME,"~/"), p-wgh-object:FILE-NAME, "~/") NO-ERROR.

/*OUTPUT TO C:\Projetos\Liasa\NF-e\upc\cd0403.txt APPEND.

PUT "p-ind-event:"   p-ind-event  FORMAT "X(25)"
    "p-ind-object: " p-ind-object FORMAT "X(25)"
    "c-char: "       c-char       FORMAT "X(25)" SKIP.

OUTPUT CLOSE.  */

IF  SEARCH("gtupc/upc-cd0403.p") <> ? OR
    SEARCH("gtupc/upc-cd0403.r") <> ?
THEN
    RUN gtupc/upc-cd0403.p (input p-ind-event,
                            input p-ind-object,
                            input p-wgh-object,
                            input p-wgh-frame,
                            input p-cod-table,
                            input p-row-table).

ASSIGN l-funcao-nfe = CAN-FIND(funcao WHERE funcao.cd-funcao = "SPP-NFE":U).
if  p-ind-event  = "INITIALIZE" and 
    p-ind-object = "CONTAINER" then do:
    assign h-programa = p-wgh-object
           wgh-window = p-wgh-object.
    create button wh-button-upc-cd0403  
    assign frame     = p-wgh-frame 
           width     = 4.00        
           height    = 1.25        
           row       = 1.32
           col       = 70.32       
           visible   = yes
           sensitive = yes
           tooltip   = "UPC"
           triggers:
             on choose persistent run upc/cd0403a-upc.w  .
           end triggers.
  if wh-button-upc-cd0403:load-image("image/gr-lay.bmp") then.
end.

/*Soh cria os objetos na tela se a funcao spp-nfe estiver ativa*/
IF l-funcao-nfe THEN DO:

/*     if  p-ind-event  = "initialize" and                           */
/*         p-ind-object = "container"  then do:                      */
/*         ASSIGN wgh-handle-container-cd0403 = p-wgh-object.        */
/*                                                                   */
/*         CREATE TEXT wh-tx-tp-emissao                              */
/*         ASSIGN FRAME         = p-wgh-frame                        */
/*                FORMAT        = "x(13)"                            */
/*                WIDTH         = 10                                 */
/*                SCREEN-VALUE  = "Tipo Emissao:"                    */
/*                ROW           = 3.25                               */
/*                COL           = 45                                 */
/*                FGCOLOR       = ?                                  */
/*                BGCOLOR       = ?                                  */
/*                VISIBLE       = YES.                               */
/*                                                                   */
/*                  /* Atualizar paginas */                          */
/*         RUN select-page IN wgh-handle-container-cd0403 (INPUT 5). */
/*         RUN select-page IN wgh-handle-container-cd0403 (INPUT 1). */
/*                                                                   */
/*     END.                                                          */

    IF p-ind-event  = "BEFORE-INITIALIZE" AND 
       p-ind-object = "VIEWER"            AND
       c-char       = "V01ad107.W"        THEN DO:
        
       /*  assign wh-objeto  = p-wgh-frame:FIRST-CHILD.
         do while valid-handle(wh-objeto):
            
             case wh-objeto:name:                    
                 
                 WHEN 'rs-transmissao' THEN DO:
                     ASSIGN wh-tg-log-nf-eletro = wh-objeto.
                 END.
                 WHEN 'rect-7' THEN DO:
                     ASSIGN wh-ret-7 = wh-objeto.
                 END.

             end case.
             if wh-objeto:TYPE = 'field-group'
                then assign wh-objeto = wh-objeto:FIRST-CHILD.
                else assign wh-objeto = wh-objeto:NEXT-SIBLING.
         end.*/
    
        RUN pi-cria-objeto.

    END.

/*     IF p-ind-event  = "enable" AND                  */
/*        p-ind-object = "viewer" AND                  */
/*        c-char       = "v01ad107.W" THEN DO:         */
/*         ASSIGN wgh-rs-tipo-emissao:SENSITIVE = YES. */
/*     END.                                            */
/*                                                     */
/*     IF p-ind-event  = "disable" AND                 */
/*        p-ind-object = "viewer"  AND                 */
/*        c-char       = "v01ad107.W" THEN DO:         */
/*         ASSIGN wgh-rs-tipo-emissao:SENSITIVE = NO.  */
/*     END.                                            */
/*                                                                                                          */
/*     IF p-ind-event  = "display" AND                                                                      */
/*        p-ind-object = "viewer"  AND                                                                      */
/*        c-char       = "v01ad107.W"  THEN DO:                                                             */
/*                                                                                                          */
/*        FIND FIRST ESTABELEC NO-LOCK                                                                      */
/*              WHERE ROWID(ESTABELEC) = p-row-table NO-ERROR.                                              */
/*        IF AVAIL ESTABELEC THEN DO:                                                                       */
/*            FIND FIRST param-nf-estab                                                                     */
/*                  WHERE param-nf-estab.cod-estabel = estabelec.cod-estabel                                */
/*                  EXCLUSIVE-LOCK NO-ERROR.                                                                */
/*             IF  AVAIL param-nf-estab THEN                                                                */
/*                 ASSIGN wgh-rs-tipo-emissao:SCREEN-VALUE = STRING(param-nf-estab.idi-tip-emis-nf-eletro). */
/*        END.                                                                                              */
/*     END.                                                                                                 */

/*     IF p-ind-event  = "add" AND                                                                       */
/*        p-ind-object = "viewer" AND                                                                    */
/*        c-char       = "v01ad107.W" THEN DO:                                                           */
/*         FIND FIRST ESTABELEC NO-LOCK                                                                  */
/*              WHERE ROWID(ESTABELEC) = p-row-table NO-ERROR.                                           */
/*         IF AVAIL ESTABELEC THEN DO:                                                                   */
/*                                                                                                       */
/*            FIND FIRST param-nf-estab                                                                  */
/*                  WHERE param-nf-estab.cod-estabel = ESTABELEC.cod-estabel                             */
/*                  EXCLUSIVE-LOCK NO-ERROR.                                                             */
/*             IF  NOT AVAIL param-nf-estab THEN DO:                                                     */
/*                 CREATE param-nf-estab.                                                                */
/*                 ASSIGN param-nf-estab.cod-estabel = ESTABELEC.cod-estabel                             */
/*                        param-nf-estab.ind-empresa = ESTABELEC.cod-estabel                             */
/*                        param-nf-estab.idi-tip-emis-nf-eletro = INT(wgh-rs-tipo-emissao:SCREEN-VALUE). */
/*             END.                                                                                      */
/*             ELSE                                                                                      */
/*                 ASSIGN param-nf-estab.idi-tip-emis-nf-eletro = INT(wgh-rs-tipo-emissao:SCREEN-VALUE). */
/*         END.                                                                                          */
/*     END.                                                                                              */

/*     IF p-ind-event  = "assign" AND                                                                    */
/*        p-ind-object = "viewer" AND                                                                    */
/*        c-char       = "v01ad107.W" THEN DO:                                                           */
/*         FIND FIRST ESTABELEC NO-LOCK                                                                  */
/*              WHERE ROWID(ESTABELEC) = p-row-table NO-ERROR.                                           */
/*         IF AVAIL ESTABELEC THEN DO:                                                                   */
/*                                                                                                       */
/*             FIND FIRST param-nf-estab                                                                 */
/*                  WHERE param-nf-estab.cod-estabel = ESTABELEC.cod-estabel                             */
/*                  EXCLUSIVE-LOCK NO-ERROR.                                                             */
/*             IF  NOT AVAIL param-nf-estab THEN DO:                                                     */
/*                 CREATE param-nf-estab.                                                                */
/*                 ASSIGN param-nf-estab.cod-estabel = ESTABELEC.cod-estabel                             */
/*                        param-nf-estab.ind-empresa = ESTABELEC.cod-estabel                             */
/*                        param-nf-estab.idi-tip-emis-nf-eletro = INT(wgh-rs-tipo-emissao:SCREEN-VALUE). */
/*             END.                                                                                      */
/*             ELSE                                                                                      */
/*                 ASSIGN param-nf-estab.idi-tip-emis-nf-eletro = INT(wgh-rs-tipo-emissao:SCREEN-VALUE). */
/*         END.                                                                                          */
/*     END.                                                                                              */
END.

PROCEDURE pi-cria-objeto:
/*
1 – Normal – emissão normal;
2 – Contingência FS – emissão em contingência com impressão do DANFE em Formulário de Segurança;
3 – Contingência SCAN – emissão em contingência no Sistema de Contingência do Ambiente Nacional – SCAN; 
4 – Contingência DPEC - emissão em contingência com envio da Declaração Prévia de Emissão em Contingência – DPEC;
5 – Contingência FS-DA - emissão em contingência com impressão do DANFE em Formulário de Segurança para Impressão de Documento 
Auxiliar de Documento Fiscal Eletrônico (FS-DA).
*/
/*     CREATE COMBO-BOX wgh-rs-tipo-emissao                                                                                         */
/*              ASSIGN WIDTH            = 16                                                                                        */
/*                     ROW              = 1.19                                                                                      */
/*                     COLUMN           = 54.57                                                                                     */
/*                     LIST-ITEM-PAIRS  = "Normal,1,Contingência FS,2,Contingência SCAN,3,Contingência DPEC,4,Contingência FS-DA,5" */
/*                     VISIBLE          = YES                                                                                       */
/*                     FRAME            = p-wgh-frame                                                                               */
/*                     HELP             = "Tipo Emissao NFe".                                                                       */

   /* CREATE RECTANGLE wh-ret-1
            ASSIGN ROW             = wh-ret-7:ROW 
                   COLUMN          = wh-ret-7:COL + 22
                   FRAME           = p-wgh-frame   
                   HEIGHT-CHARS    = wh-ret-7:HEIGHT-CHARS 
                   WIDTH-CHARS     = wh-ret-7:WIDTH-CHARS  + 5
                   EDGE-PIXELS     = wh-ret-7:edge-pixels
                   GRAPHIC-EDGE    = YES
                   FILLED          = NO.
    */

END PROCEDURE.






