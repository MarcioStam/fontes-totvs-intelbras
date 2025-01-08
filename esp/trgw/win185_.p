/********************************************************************************
 ** UPC........: win185.p - UPC WRITE item-tab
 ** Data.......: abril / 2008
 ** Objetivo...: envio de e-mail na alteraá∆o do item da tabela
 ********************************************************************************/

/*{utp/utapi019.i}*/
{upc/btb910za-upc.i}
{utp/ut-glob.i}
{esp/es0006a.i} 
{esp/eslib.i}
{esp/es0018.i}

DEF PARAM BUFFER b-item-tab  FOR mgind.ITEM-tab.
DEF PARAM BUFFER b-old-item-tab  FOR mgind.ITEM-tab.

DEF BUFFER bf-item-tab FOR item-tab.
DEF BUFFER bf-tb-pr-cc FOR tb-pr-cc.    

def new global shared var gr-tb-pr-cc as rowid no-undo.


def var c-remetente like usuar_mestre.cod_e_mail_local no-undo.
def var c-titulo as char no-undo.
DEF VAR de-pr-item-old LIKE item-tab.pr-item NO-UNDO.
DEF VAR de-pr-item-emit-old LIKE item-tab.pr-item NO-UNDO.
DEF VAR c-nr-tab-old LIKE item-tab.nr-tab NO-UNDO.
DEF VAR c-cond-pag-old LIKE item-tab.cod-cond-pag NO-UNDO.
DEF VAR c-nr-tab-emit-old LIKE item-tab.nr-tab NO-UNDO.
DEF VAR dt-aux AS DATE INIT ? NO-UNDO.
DEF VAR i-cod-emit-old LIKE ITEM-tab.cod-emitente NO-UNDO.
DEF VAR c-nome-emit-old LIKE emitente.nome-emit NO-UNDO.
DEF VAR r-rowid AS ROWID NO-UNDO.
DEF VAR c-destino AS CHAR LABEL "Email Destino" FORMAT "x(100)" NO-UNDO.
DEFINE VARIABLE c-cod-estabel AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-moeda AS INT  NO-UNDO.
DEFINE VARIABLE c-desc-moeda AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-moeda-old AS INT  NO-UNDO.
DEFINE VARIABLE c-desc-moeda-old AS CHARACTER   NO-UNDO.
def var lErro as logical no-undo.
DEFINE VARIABLE c-justificativa AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-copia         AS LOGICAL   NO-UNDO.

    
ASSIGN c-justificativa = ""
       l-copia         = NO.
IF NEW b-item-tab   AND 
   gr-tb-pr-cc <> ? AND
   (INDEX(PROGRAM-NAME(1),"cc0312a") <> 0 OR
    INDEX(PROGRAM-NAME(2),"cc0312a") <> 0 OR
    INDEX(PROGRAM-NAME(3),"cc0312a") <> 0 OR  
    INDEX(PROGRAM-NAME(4),"cc0312a") <> 0 OR  
    INDEX(PROGRAM-NAME(5),"cc0312a") <> 0 OR  
    INDEX(PROGRAM-NAME(6),"cc0312a") <> 0 OR  
    INDEX(PROGRAM-NAME(7),"cc0312a") <> 0 OR  
    INDEX(PROGRAM-NAME(8),"cc0312a") <> 0 OR  
    INDEX(PROGRAM-NAME(9),"cc0312a") <> 0 OR  
    INDEX(PROGRAM-NAME(10),"cc0312a") <> 0) THEN DO:

    ASSIGN l-copia = YES.
    FIND FIRST bf-tb-pr-cc
         WHERE ROWID(bf-tb-pr-cc) = gr-tb-pr-cc NO-LOCK NO-ERROR.
    IF AVAIL bf-tb-pr-cc THEN DO:
        ASSIGN i-moeda-old = bf-tb-pr-cc.mo-codigo.

        FOR FIRST bf-item-tab OF bf-tb-pr-cc NO-LOCK 
            WHERE bf-item-tab.it-codigo = b-item-tab.it-codigo
              AND bf-item-tab.quant-min = b-item-tab.quant-min:
            ASSIGN de-pr-item-old = bf-item-tab.pr-item  
                   i-cod-emit-old = bf-item-tab.cod-emitente 
                   c-nr-tab-old   = bf-item-tab.nr-tab
                   c-cond-pag-old = bf-item-tab.cod-cond-pag.

            ASSIGN c-justificativa = "C¢pia de tabela efetuada pelo programa CC0312A".

            RUN pi-principal.
        END.
    END.
END.
ELSE IF b-old-item-tab.pr-item <> b-item-tab.pr-item THEN DO:
    ASSIGN de-pr-item-old = b-old-item-tab.pr-item
           i-cod-emit-old = b-old-item-tab.cod-emitente
           c-nr-tab-old   = b-old-item-tab.nr-tab
           c-cond-pag-old = b-old-item-tab.cod-cond-pag.
    
    FIND FIRST bf-tb-pr-cc
         WHERE bf-tb-pr-cc.cod-emitente = b-old-item-tab.cod-emitente
           AND bf-tb-pr-cc.cod-cond-pag = b-old-item-tab.cod-cond-pag
           AND bf-tb-pr-cc.nr-tab = b-old-item-tab.nr-tab NO-LOCK NO-ERROR.
    IF AVAIL bf-tb-pr-cc THEN DO:
        ASSIGN i-moeda-old = bf-tb-pr-cc.mo-codigo.
    END.

    IF b-old-item-tab.pr-item = 0 THEN DO: /* se preªo antigo for igual a zero procura a tabela anterior que tem valor */ 
        FOR EACH  bf-item-tab
            WHERE bf-item-tab.it-codigo = b-item-tab.it-codigo
              AND bf-item-tab.pr-item > 0 
              AND ROWID(bf-item-tab) <> ROWID(b-item-tab) NO-LOCK:        
    
            FIND FIRST bf-tb-pr-cc
                 WHERE bf-tb-pr-cc.cod-emitente = bf-item-tab.cod-emitente
                   AND bf-tb-pr-cc.cod-cond-pag = bf-item-tab.cod-cond-pag
                   AND bf-tb-pr-cc.nr-tab = bf-item-tab.nr-tab NO-LOCK NO-ERROR.
            IF dt-aux = ? THEN DO:
                ASSIGN dt-aux = bf-tb-pr-cc.dt-termino
                       r-rowid = ROWID(bf-item-tab)
                       i-cod-emit-old = bf-item-tab.cod-emitente.
            END.
            IF dt-aux < bf-tb-pr-cc.dt-termino THEN DO:
                ASSIGN dt-aux = bf-tb-pr-cc.dt-termino
                       r-rowid = ROWID(bf-item-tab)
                       i-cod-emit-old = bf-item-tab.cod-emitente.
            END.
        END.
        FIND FIRST bf-item-tab
             WHERE ROWID(bf-item-tab) = r-rowid NO-LOCK NO-ERROR.
        IF AVAIL bf-item-tab THEN DO:
/*            IF bf-item-tab.cod-emitente = b-item-tab.cod-emitente THEN /* Se a tabela anterior Ç do mesmo emitente da tabela atual */*/
                ASSIGN de-pr-item-old = bf-item-tab.pr-item
                       c-nr-tab-old   = bf-item-tab.nr-tab
                       i-cod-emit-old = bf-item-tab.cod-emitente
                       c-cond-pag-old = bf-item-tab.cod-cond-pag.
/*            ELSE
                ASSIGN de-pr-item-emit-old = bf-item-tab.pr-item
                       c-nr-tab-emit-old   = bf-item-tab.nr-tab
                       i-cod-emit-old      = bf-item-tab.cod-emitente.
*/
            FIND FIRST bf-tb-pr-cc
                 WHERE bf-tb-pr-cc.cod-emitente = bf-item-tab.cod-emitente
                   AND bf-tb-pr-cc.cod-cond-pag = bf-item-tab.cod-cond-pag
                   AND bf-tb-pr-cc.nr-tab = bf-item-tab.nr-tab NO-LOCK NO-ERROR.
            IF AVAIL bf-tb-pr-cc THEN DO:
                ASSIGN i-moeda-old = bf-tb-pr-cc.mo-codigo.
            END.
        END.
    END.

    RUN pi-principal.
END.
    
PROCEDURE pi-principal:

    IF de-pr-item-old <> b-item-tab.pr-item                OR
       (NOT l-copia AND c-nr-tab-old <> b-item-tab.nr-tab) OR
       i-cod-emit-old <> b-item-tab.cod-emitente           OR
       c-cond-pag-old <> b-item-tab.cod-cond-pag THEN DO:

        FIND moeda WHERE
             moeda.mo-codigo = i-moeda-old NO-LOCK NO-ERROR.
        IF AVAIL moeda THEN
            ASSIGN c-desc-moeda-old = moeda.descricao.

        FIND usuar_mestre NO-LOCK 
            WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.
        IF AVAILABLE usuar_mestre THEN
           ASSIGN c-remetente = usuar_mestre.cod_e_mail_local.

        IF c-remetente = '' THEN
           ASSIGN c-remetente = 'adm@intelbras.com.br'.

        FIND ITEM WHERE ITEM.it-codigo = b-item-tab.it-codigo NO-LOCK NO-ERROR.
        IF i-cod-emit-old <> b-item-tab.cod-emitente THEN DO:
            FIND emitente WHERE emitente.cod-emitente = i-cod-emit-old NO-LOCK NO-ERROR.
            ASSIGN c-nome-emit-old = string(emitente.cod-emitente) + " - " + emitente.nome-emit.
        END.

        FIND emitente WHERE emitente.cod-emitente = b-item-tab.cod-emitente NO-LOCK NO-ERROR.

        FIND FIRST tb-pr-cc
             WHERE tb-pr-cc.cod-emitente = b-item-tab.cod-emitente
               AND tb-pr-cc.cod-cond-pag = b-item-tab.cod-cond-pag
               AND tb-pr-cc.nr-tab = b-item-tab.nr-tab NO-LOCK NO-ERROR.
        IF AVAIL tb-pr-cc THEN DO:
            ASSIGN i-moeda = tb-pr-cc.mo-codigo.
            FIND moeda WHERE
                 moeda.mo-codigo = i-moeda NO-LOCK NO-ERROR.
            IF AVAIL moeda THEN
                ASSIGN c-desc-moeda = moeda.descricao.
        END.

        IF OPSYS <> "UNIX" AND 
           (INDEX(PROGRAM-NAME(1),"cc9014") <> 0 OR
            INDEX(PROGRAM-NAME(2),"cc9014") <> 0 OR
            INDEX(PROGRAM-NAME(3),"cc9014") <> 0 OR  
            INDEX(PROGRAM-NAME(4),"cc9014") <> 0 OR  
            INDEX(PROGRAM-NAME(5),"cc9014") <> 0 OR  
            INDEX(PROGRAM-NAME(6),"cc9014") <> 0 OR  
            INDEX(PROGRAM-NAME(7),"cc9014") <> 0 OR  
            INDEX(PROGRAM-NAME(8),"cc9014") <> 0 OR  
            INDEX(PROGRAM-NAME(9),"cc9014") <> 0 OR  
            INDEX(PROGRAM-NAME(10),"cc9014") <> 0) THEN DO:

            RUN pi-justificativa.
        END.

        IF NEW b-item-tab THEN DO:
            IF l-copia THEN DO:
                ASSIGN c-titulo = "C¢pia de preáo do item " + b-item-tab.it-codigo + " na tabela " + b-item-tab.nr-tab
                       c-texto-html[1] = "**************************************************" + CHR(13) +
                                         "               C¢pia Preáo do Item                " + CHR(13) +
                                         "**************************************************" + CHR(13).
            END.
            ELSE DO:
                ASSIGN c-titulo = "Inclus∆o de preáo do item " + b-item-tab.it-codigo + " na tabela " + b-item-tab.nr-tab
                       c-texto-html[1] = "**************************************************" + CHR(13) +
                                         "              Inclus∆o Preáo do Item              " + CHR(13) +
                                         "**************************************************" + CHR(13).
            END.
        END.
        ELSE DO:
            ASSIGN c-titulo = "Alterado preáo do item " + b-item-tab.it-codigo + " na tabela " + b-item-tab.nr-tab
                   c-texto-html[1] = "**************************************************" + CHR(13) +
                                     "             Alterado Preáo do Item               " + CHR(13) +
                                     "**************************************************" + CHR(13).
        END.

        assign c-texto-html[1] = c-texto-html[1]  +
               "Item: " + b-item-tab.it-codigo + " - " + ITEM.desc-item     + CHR(13) +
               "Emitente: " + string(b-item-tab.cod-emitente) + " - " + emitente.nome-emit + CHR(13) +
               "Alterado por: " + v_cod_usuar_corren                + CHR(13).

        IF i-cod-emit-old <> b-item-tab.cod-emitente THEN
            ASSIGN c-texto-html[1] = c-texto-html[1] +
                                  "Emitente antigo: " + c-nome-emit-old + CHR(13).
        ASSIGN c-texto-html[1] = c-texto-html[1] + 
                                 "Tabela antiga: " + c-nr-tab-old                     + CHR(13) +
                                 "ConPag antiga: " + STRING(c-cond-pag-old)           + CHR(13) +
                                 "Preáo antigo : " + string(de-pr-item-old)           + chr(13) +
                                 "Moeda antiga : " + STRING(i-moeda-old) + " - " + c-desc-moeda-old + CHR(13) +
                                 "Tabela nova  : " + b-item-tab.nr-tab                + CHR(13) +
                                 "ConPag nova  : " + STRING(b-item-tab.cod-cond-pag)  + CHR(13) +
                                 "Preáo novo   : " + string(b-item-tab.pr-item)       + chr(13) +
                                 "Moeda nova   : " + STRING(i-moeda) + " - " + c-desc-moeda + CHR(13)
                                 .
    /*
        IF i-cod-emit-old <> b-item-tab.cod-emitente THEN
            ASSIGN c-texto-html[1] = c-texto-html[1] +
                                  "Emitente antigo: " + c-nome-emit-old + CHR(13) +
                                  "Tabela antiga  : " + c-nr-tab-emit-old + CHR(13) +
                                  "Preáo antigo   : " + STRING(de-pr-item-emit-old) + CHR(13).
    */
        ASSIGN c-texto-html[1] = c-texto-html[1] + "**************************************************" + CHR(13) +
                                 "Justificativa: " + CHR(13) + 
                                 c-justificativa   + CHR(10). 

        RUN esp/es0018p.p (INPUT "cc0313", /* Nome do programa */
                           INPUT 1,        /* Ponto do programa */
                           INPUT 0,
                           INPUT "",
                           OUTPUT TABLE tt-prog-ponto).   
        ASSIGN c-destino     = ""
               c-cod-estabel = "".

        for each tt-prog-ponto:
            ASSIGN c-cod-estabel = ENTRY(1,tt-prog-ponto.conteudo).
            IF v_cod_estab_usuar = c-cod-estabel THEN DO:
                IF c-destino = "" THEN
                    ASSIGN c-destino = ENTRY(2,tt-prog-ponto.conteudo).
                ELSE
                    ASSIGN c-destino = c-destino + "," + ENTRY(2,tt-prog-ponto.conteudo).
            END.
        END.

        IF c-destino <> "" THEN DO:
            RUN enviaMail (INPUT c-remetente,
                       INPUT c-destino,
                       INPUT trim(c-titulo),
                       INPUT c-texto-html[1],
                       INPUT "").
        END.
    END.

END PROCEDURE.

/*comentar a procedure justificativa para compilar em unix*/
PROCEDURE pi-justificativa:
    DEFINE VARIABLE fidescricao AS CHAR 
        VIEW-AS EDITOR SCROLLBAR-VERTICAL  SIZE 65 BY 3 NO-UNDO FONT 1
        LABEL "Justificativa".

    DEFINE BUTTON btOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.

    DEFINE BUTTON btCancelar
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.

    DEFINE RECTANGLE rtButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 80 BY 1.42
         BGCOLOR 7.

    DEFINE FRAME fJustificativa
        fidescricao  AT ROW 1.14 COL 11 COLON-ALIGNED
        btOK             AT ROW 4.63 COL 2.14
        btCancelar       AT ROW 4.63 COL 13
        rtButton         AT ROW 4.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "Justificativa da Alteraá∆o Tabela de Preáo" FONT 1
             DEFAULT-BUTTON btOK CANCEL-BUTTON btCancelar.

    ASSIGN fidescricao:RETURN-INSERTED IN FRAME fJustificativa = TRUE.

    ON "CHOOSE":U OF btOK IN FRAME fJustificativa DO:
        ASSIGN INPUT FRAME fJustificativa fidescricao.

        IF fidescricao = "" THEN DO:
            MESSAGE "Justificativa deve ser informado!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            APPLY "entry" TO fidescricao IN FRAME fJustificativa.
            RETURN NO-APPLY.
        END.
        ELSE APPLY "GO":U TO FRAME fJustificativa.
    END.

    ON "CHOOSE":U OF btCancelar IN FRAME fJustificativa DO:

        APPLY "GO":U TO FRAME fJustificativa.
    END.

    ENABLE fidescricao btOK btCancelar
        WITH FRAME fJustificativa. 

    WAIT-FOR "GO":U OF FRAME fJustificativa.
    ASSIGN c-justificativa = fidescricao.

END PROCEDURE.
