/**************************************************************************************************
** PROGRAMA...: upc-ft4004.p - UPC inclusao de nota fiscal manual
** DATA.......: 01/09/2010
** ATUALIZACAO: 06/01/2011
**************************************************************************************************/

def input param p-ind-event      as char          no-undo.
def input param p-ind-object     as char          no-undo.
def input param p-wgh-object     as handle        no-undo.
def input param p-wgh-frame      as widget-handle no-undo.
def input param p-cod-table      as char          no-undo.
def input param p-row-table      as rowid         no-undo.

DEF NEW GLOBAL SHARED VAR wh-button AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-cidade-ser   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-uf-ser   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR wh-pais-ser   AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-label  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-label1  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-label2  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR tx-label3  AS WIDGET-HANDLE NO-UNDO.
DEF NEW GLOBAL SHARED VAR rct-1      AS WIDGET-HANDLE NO-UNDO.
    
DEF VAR wh-it-codigo          AS widget-handle no-undo.      
DEF VAR wh-nr-sequencia       AS widget-handle no-undo.     
DEF VAR wh-cod-refer          AS widget-handle no-undo.
DEF VAR wh-aliquota-iss       AS widget-handle no-undo.
DEF VAR wh-rect               AS widget-handle no-undo. 
def var wh-grupo              as widget-handle no-undo.
def var wh-child              as widget-handle no-undo.
DEF VAR wh-fr1                as widget-handle no-undo.
DEF VAR wh-descricao-inss     as widget-handle no-undo.

/* define new global shared temp-table esp-ext-wt-it-docto like wt-it-docto */
/*     field cidade like cidade.cidade                                      */
/*     field estado like cidade.estado                                      */
/*     field pais   like cidade.pais.                                       */

{include/i_fclpreproc.i} /* Include que define o processador do Facelift ativado ou n∆o. */
DEFINE VARIABLE h-objeto  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-objeto2 AS WIDGET-HANDLE NO-UNDO.

&IF "{&aplica_facelift}" = "YES" &THEN
	{include/i_fcldef.i}
&endif   

/*      MANGELS - DIEGO           */
/* RUN ftp/ft4004-upc.p (INPUT p-ind-event ,
                      INPUT p-ind-object,
                      INPUT p-wgh-object,
                      INPUT p-wgh-frame ,
                      INPUT p-cod-table ,
                      INPUT p-row-table ).     */

IF p-ind-event = "After-Display" THEN DO:

    DEF VAR c-cidade-ser AS CHAR NO-UNDO.
    DEF VAR c-uf-ser     AS CHAR NO-UNDO.
    DEF VAR c-pais-ser   AS CHAR NO-UNDO.

    FIND FIRST WT-IT-DOCTO NO-LOCK
        WHERE ROWID(WT-IT-DOCTO) = p-row-table NO-ERROR.

    IF AVAIL wt-it-docto
        AND VALID-HANDLE(wh-cidade-ser)
        AND VALID-HANDLE(wh-uf-ser) 
        AND VALID-HANDLE(wh-pais-ser) THEN DO:

        FIND FIRST wt-docto NO-LOCK
            WHERE wt-docto.seq-wt-docto = WT-IT-DOCTO.seq-wt-docto NO-ERROR.

        RUN pi-cidade-prestacao-servico (INPUT wt-docto.nome-abrev,
                                         INPUT WT-IT-DOCTO.nr-pedcli,
                                         INPUT WT-IT-DOCTO.nr-seq-ped,
                                         INPUT WT-IT-DOCTO.it-codigo,
                                         INPUT WT-IT-DOCTO.cod-refer,
                                         OUTPUT c-cidade-ser,
                                         OUTPUT c-uf-ser,
                                         OUTPUT c-pais-ser).

        find first esp-ext-wt-it-docto
             where esp-ext-wt-it-docto.seq-wt-it-docto = WT-IT-DOCTO.seq-wt-it-docto
               and esp-ext-wt-it-docto.seq-wt-docto    = WT-IT-DOCTO.seq-wt-docto no-lock no-error.

        IF  NOT AVAIL esp-ext-wt-it-docto THEN DO:

            CREATE esp-ext-wt-it-docto.
            ASSIGN esp-ext-wt-it-docto.seq-wt-docto    = WT-IT-DOCTO.seq-wt-docto
                   esp-ext-wt-it-docto.seq-wt-it-docto = WT-IT-DOCTO.seq-wt-it-docto.


            IF  c-cidade-ser <> "" THEN DO:
                ASSIGN esp-ext-wt-it-docto.cidade = c-cidade-ser
                       esp-ext-wt-it-docto.estado = c-uf-ser
                       esp-ext-wt-it-docto.pais   = c-pais-ser.
            END.
            ELSE DO:
                FOR FIRST esp-ext-ser-estab NO-LOCK
                    WHERE esp-ext-ser-estab.cod-estabel = wt-docto.cod-estabel
                      AND esp-ext-ser-estab.serie       = wt-docto.serie:

                    /** RERGA: Local prestacao servico padrao Cliente **/
                    IF  esp-ext-ser-estab.local-padrao-prest-serv = 2 THEN DO:

                        FOR FIRST emitente NO-LOCK
                            WHERE emitente.cod-emitente = wt-docto.cod-emitente:

                            ASSIGN esp-ext-wt-it-docto.cidade = emitente.cidade
                                   esp-ext-wt-it-docto.estado = emitente.estado
                                   esp-ext-wt-it-docto.pais   = emitente.pais.
                        END.
                    END.
                    /** RERGA: Local prestacao servico padrao Estabelecimento **/
                    ELSE DO:

                        FOR FIRST estabelec NO-LOCK
                            WHERE estabelec.cod-estabel = wt-docto.cod-estabel:

                            ASSIGN esp-ext-wt-it-docto.cidade = estabelec.cidade
                                   esp-ext-wt-it-docto.estado = estabelec.estado
                                   esp-ext-wt-it-docto.pais   = estabelec.pais.
                        END.
                    END.
                END.
            END.

            FIND CURRENT esp-ext-wt-it-docto NO-LOCK NO-ERROR.
        
        END.

        IF  avail esp-ext-wt-it-docto then do:
            ASSIGN wh-cidade-ser:SCREEN-VALUE   = esp-ext-wt-it-docto.cidade  
                   wh-uf-ser:SCREEN-VALUE  = esp-ext-wt-it-docto.estado  
                   wh-pais-ser:SCREEN-VALUE  = esp-ext-wt-it-docto.pais.
        End.
        else
            ASSIGN wh-cidade-ser:SCREEN-VALUE   = ""
                   wh-uf-ser:SCREEN-VALUE  = ""
                   wh-pais-ser:SCREEN-VALUE  = "".

    END.
END.

IF p-ind-event = "After-Save-Fields" THEN DO:
    FIND FIRST WT-IT-DOCTO NO-LOCK
        WHERE ROWID(WT-IT-DOCTO) = p-row-table NO-ERROR.
    IF AVAIL wt-it-docto THEN DO:

        find first esp-ext-wt-it-docto
             where esp-ext-wt-it-docto.seq-wt-it-docto = WT-IT-DOCTO.seq-wt-it-docto
               and esp-ext-wt-it-docto.seq-wt-docto    = WT-IT-DOCTO.seq-wt-docto exclusive-lock no-error.
        if not avail esp-ext-wt-it-docto then do:
            create esp-ext-wt-it-docto.
            assign esp-ext-wt-it-docto.seq-wt-docto = WT-IT-DOCTO.seq-wt-docto
                   esp-ext-wt-it-docto.seq-wt-it-docto = WT-IT-DOCTO.seq-wt-it-docto.
        End.   
        assign  esp-ext-wt-it-docto.cidade = wh-cidade-ser:SCREEN-VALUE  
                esp-ext-wt-it-docto.estado = wh-uf-ser:SCREEN-VALUE 
                esp-ext-wt-it-docto.pais   = wh-pais-ser:SCREEN-VALUE .

    END.
END.

IF p-ind-event = "Before-Cancel" THEN DO:
    ASSIGN wh-cidade-ser:SCREEN-VALUE = "".
    ASSIGN wh-uf-ser:SCREEN-VALUE = "".
    ASSIGN wh-pais-ser:SCREEN-VALUE = "".
END.

IF p-ind-event = "After-Enable" THEN DO:
    ASSIGN wh-cidade-ser:SENSITIVE = YES.
    ASSIGN wh-uf-ser:SENSITIVE = YES.
    ASSIGN wh-pais-ser:SENSITIVE = YES.
END.

IF p-ind-event = "After-Disable" THEN DO:
    ASSIGN wh-cidade-ser:SENSITIVE = NO.
    ASSIGN wh-uf-ser:SENSITIVE = NO.
    ASSIGN wh-pais-ser:SENSITIVE = NO.
END.

IF  p-ind-event = "AFTER-INITIALIZE" THEN DO:  

    RUN pi-busca-frame("fpage3").
    RUN pi-busca-handle(INPUT "rect-28", 
                        OUTPUT wh-rect).

    RUN pi-busca-frame("fpage5").
    RUN pi-busca-handle(INPUT "aliquota-ISS", 
                        OUTPUT wh-aliquota-iss).

    
    RUN pi-busca-handle(INPUT "c-des-serv-inss", 
                        OUTPUT wh-descricao-inss).
    

    CREATE TEXT tx-label3
        ASSIGN FRAME        = wh-fr1
               FORMAT       = "x(40)"
               WIDTH        = 22
               SCREEN-VALUE = "Local de prestaá∆o de serviáo:"
               ROW          = wh-aliquota-iss:ROW + 1.3
               COL          = 59
               VISIBLE      = YES
               FGCOLOR      = 1
               FONT         = wh-aliquota-iss:FONT.

/*     CREATE RECT rct-1                                    */
/*         ASSIGN FRAME        = wh-fr1                     */
/*                ROW          = wh-aliquota-iss:ROW + 1.5  */
/*                COL          = 52                         */
/*                WIDTH        = 32                         */
/*                HEIGHT       = 3.0                        */
/*                PFCOLOR       = wh-rect:PFCOLOR           */
/*                FGCOLOR       = wh-rect:FGCOLOR           */
/*                EDGE-CHARS    = wh-rect:EDGE-CHARS        */
/*                VISIBLE      = YES                        */
/*                .                                         */

    CREATE TEXT tx-label
        ASSIGN FRAME        = wh-fr1
               FORMAT       = "x(25)"
               WIDTH        = 25
               SCREEN-VALUE = "Cidade:"
               ROW          = wh-aliquota-iss:ROW + 1.95
               COL          = 53.4
               VISIBLE      = YES
               FONT         = wh-aliquota-iss:FONT.

    CREATE FILL-IN wh-cidade-ser
        ASSIGN FRAME             = wh-fr1
               SIDE-LABEL-HANDLE = tx-label:HANDLE
               FORMAT            = "x(25)"
               NAME              = "cidade"
               WIDTH             = 25.7
               HEIGHT            = 0.88
               ROW               = wh-aliquota-iss:ROW + 1.85
               COL               = 59
               LABEL             = "Cidade:"
               VISIBLE           = YES
               SENSITIVE         = NO
               FONT              = wh-aliquota-iss:FONT
               TRIGGERS:
                   ON "F5":U PERSISTENT RUN upc/epczoom.p. 
                   ON "MOUSE-SELECT-DBLCLICK":U PERSISTENT RUN upc/epczoom.p.
               END TRIGGERS.

        wh-cidade-ser:LOAD-MOUSE-POINTER("image/lupa.cur":U).

    CREATE TEXT tx-label1
        ASSIGN FRAME        = wh-fr1
               FORMAT       = "x(40)"
               WIDTH        = 3
               SCREEN-VALUE = "UF:"
               ROW          = wh-aliquota-iss:ROW + 2.95
               COL          = 56
               VISIBLE      = YES
               FONT         = wh-aliquota-iss:FONT.

    CREATE FILL-IN wh-uf-ser
        ASSIGN FRAME             = wh-fr1
               SIDE-LABEL-HANDLE = tx-label1:HANDLE
               FORMAT            = "x(20)"
               WIDTH             = 3
               HEIGHT            = 0.88
               ROW               = wh-aliquota-iss:ROW + 2.85
               COL               = 59
               LABEL             = "UF:"
               VISIBLE           = YES
               SENSITIVE         = NO
               FONT              = wh-aliquota-iss:FONT.


    CREATE TEXT tx-label2
        ASSIGN FRAME        = wh-fr1
               FORMAT       = "x(40)"
               WIDTH        = 5
               SCREEN-VALUE = "Pa°s:"
               ROW          = wh-aliquota-iss:ROW + 3.95
               COL          = 55
               VISIBLE      = YES
               FONT         = wh-aliquota-iss:FONT.

    CREATE FILL-IN wh-pais-ser
        ASSIGN FRAME             = wh-fr1
               SIDE-LABEL-HANDLE = tx-label2:HANDLE
               FORMAT            = "x(20)"
               WIDTH             = 15
               HEIGHT            = 0.88
               ROW               = wh-aliquota-iss:ROW + 3.85
               COL               = 59
               LABEL             = "Pa°s:"
               VISIBLE           = YES
               SENSITIVE         = NO
               FONT              = wh-aliquota-iss:FONT.

    IF  valid-handle(wh-descricao-inss) THEN 
        wh-descricao-inss:WIDTH = 21.

    &IF "{&aplica_facelift}" = "YES" &THEN
    {include/i_fcldin.i wh-cidade-ser}
    &endif

END.

/****/
PROCEDURE pi-busca-frame:

    DEF INPUT PARAM c-frame-name AS CHAR.

    assign wh-grupo = p-wgh-frame:FIRST-CHILD.

    do  while valid-handle (wh-grupo):
        assign wh-child = wh-grupo:first-child.
        do  while valid-handle(wh-child):
            case wh-child:type:
                when "frame" then do:
                    if  wh-child:name = c-frame-name THEN DO: 
                        assign wh-fr1 = wh-child:handle. /*Handle Pagina 1*/
                        LEAVE.
                    END.
                end.
            end.
            assign wh-child = wh-child:next-sibling no-error.
        end.
        leave.
    end.

    RETURN "ok":u.

END PROCEDURE.

PROCEDURE pi-busca-handle:

    DEF INPUT  PARAM p-campo      AS CHAR          NO-UNDO.
    DEF OUTPUT PARAM p-wh-campo   AS WIDGET-HANDLE NO-UNDO.
    
    def var wh-grupo              as widget-handle no-undo.
    def var wh-child              as widget-handle no-undo.

    IF NOT VALID-HANDLE(wh-fr1) THEN RUN pi-busca-frame("fPage0").
    
    do:
        assign wh-grupo = wh-fr1:first-child.
    
        do  while valid-handle(wh-grupo):
            if  wh-grupo:type <> "field-group" then do:
                if  wh-grupo:name = p-campo then do:
                    assign p-wh-campo = wh-grupo.
                    leave.
                end.
                assign wh-grupo = wh-grupo:next-sibling.
            end.
            else do:
                assign wh-grupo = wh-grupo:first-child.
            end.
        end.
    end.

    RETURN "ok":u.

END PROCEDURE.

{upc/upc-ft4004nfse.i}
