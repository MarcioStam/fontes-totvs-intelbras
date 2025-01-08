/********************************************************************************
 ** UPC........: win425.p - UPC WRITE tb-pr-cc
 ** Data.......: junho / 2015
 ** Objetivo...: envio de e-mail na alteraá∆o da tabela de preáo
 ********************************************************************************/

{upc/btb910za-upc.i}
{utp/ut-glob.i}
{esp/es0006a.i} 
{esp/eslib.i}
{esp/es0018.i}

DEFINE VARIABLE l-copia         AS   LOGICAL                                    NO-UNDO.
DEFINE VARIABLE i-cod-emit-old  LIKE tb-pr-cc.cod-emitente                      NO-UNDO.
DEFINE VARIABLE c-cond-pag-old  LIKE tb-pr-cc.cod-cond-pag                      NO-UNDO.
DEFINE VARIABLE c-nr-tab-old    LIKE tb-pr-cc.nr-tab                            NO-UNDO.
DEFINE VARIABLE d-dt-inicio-old LIKE tb-pr-cc.dt-inicio                         NO-UNDO.
DEFINE VARIABLE c-justificativa AS   CHARACTER                                  NO-UNDO.
DEFINE VARIABLE c-titulo        AS   char                                       NO-UNDO.
DEFINE VARIABLE c-destino       AS   CHAR LABEL "Email Destino" FORMAT "x(100)" NO-UNDO.
DEFINE VARIABLE c-cod-estabel   AS   CHARACTER                                  NO-UNDO.
DEFINE VARIABLE c-remetente     LIKE usuar_mestre.cod_e_mail_local              NO-UNDO.

DEFINE PARAMETER BUFFER b-tb-pr-cc     FOR tb-pr-cc.
DEFINE PARAMETER BUFFER b-old-tb-pr-cc FOR tb-pr-cc.

DEFINE BUFFER bf-item-tab FOR item-tab.
DEFINE BUFFER bf-tb-pr-cc FOR tb-pr-cc.    

DEFINE NEW GLOBAL SHARED VARIABLE gr-tb-pr-cc AS ROWID NO-UNDO.

ASSIGN l-copia  = NO.

IF  NEW b-tb-pr-cc AND gr-tb-pr-cc <> ? AND
   (INDEX(PROGRAM-NAME(1), "cc0312a")  <> 0  OR
    INDEX(PROGRAM-NAME(2), "cc0312a")  <> 0  OR
    INDEX(PROGRAM-NAME(3), "cc0312a")  <> 0  OR  
    INDEX(PROGRAM-NAME(4), "cc0312a")  <> 0  OR  
    INDEX(PROGRAM-NAME(5), "cc0312a")  <> 0  OR  
    INDEX(PROGRAM-NAME(6), "cc0312a")  <> 0  OR  
    INDEX(PROGRAM-NAME(7), "cc0312a")  <> 0  OR  
    INDEX(PROGRAM-NAME(8), "cc0312a")  <> 0  OR  
    INDEX(PROGRAM-NAME(9), "cc0312a")  <> 0  OR  
    INDEX(PROGRAM-NAME(10),"cc0312a")  <> 0) THEN DO:

    ASSIGN l-copia = YES.
    FIND FIRST bf-tb-pr-cc WHERE ROWID(bf-tb-pr-cc) = gr-tb-pr-cc NO-LOCK NO-ERROR.
    IF  AVAIL  bf-tb-pr-cc THEN DO:
        ASSIGN i-cod-emit-old  = bf-tb-pr-cc.cod-emitente 
               c-cond-pag-old  = bf-tb-pr-cc.cod-cond-pag
               c-nr-tab-old    = bf-tb-pr-cc.nr-tab
               d-dt-inicio-old = bf-tb-pr-cc.dt-inicio
               c-justificativa = "C¢pia de tabela efetuada pelo programa CC0312A".

        RUN pi-principal.

    END. /* IF  AVAIL bf-tb-pr-cc ... */
END. /* IF  NEW b-tb-pr-cc AND gr-tb-pr-cc <> ? ... */
                                  
PROCEDURE pi-principal:           
    
    FIND usuar_mestre NO-LOCK 
        WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-ERROR.
    IF AVAILABLE usuar_mestre THEN ASSIGN c-remetente = usuar_mestre.cod_e_mail_local.
                              
    IF c-remetente = '' THEN ASSIGN c-remetente = 'adm@intelbras.com.br'.

    IF  NEW b-tb-pr-cc THEN DO:
        
        IF  l-copia 
        THEN ASSIGN c-titulo = "C¢pia tabela de preáo " + b-tb-pr-cc.nr-tab + " do Fornecedor " + string(b-tb-pr-cc.cod-emitente)
                    c-texto-html[1] = "**************************************************" + CHR(13) +
                                      "               C¢pia Tabela de Preáo              " + CHR(13) +
                                      "**************************************************" + CHR(13).
        ELSE ASSIGN c-titulo = "Inclus∆o tabela de preáo " + b-tb-pr-cc.nr-tab + " do Fornecedor " + string(b-tb-pr-cc.cod-emitente)
                    c-texto-html[1] = "**************************************************" + CHR(13) +
                                      "              Inclus∆o Tabela de Preáo            " + CHR(13) +
                                      "**************************************************" + CHR(13).
    END.                        
    ELSE ASSIGN c-titulo = "Alterada tabela de preáo " + b-tb-pr-cc.nr-tab + " do Fornecedor " + string(b-tb-pr-cc.cod-emitente)
                c-texto-html[1] = "**************************************************" + CHR(13) +
                                  "             Alterada Tabela de Preáo             " + CHR(13) +
                                  "**************************************************" + CHR(13).
    
    ASSIGN c-texto-html[1] = c-texto-html[1]  +
           "Alterado por: " + v_cod_usuar_corren  + CHR(13).
                             
    ASSIGN c-texto-html[1] = c-texto-html[1] + 
                             "Emitente antigo   : " + string(i-cod-emit-old)           + CHR(13) +
                             "ConPag antiga     : " + string(c-cond-pag-old)           + CHR(13) +
                             "Tabela antiga     : " + c-nr-tab-old                     + CHR(13) +
                             "Dt.Inicio antiga  : " + string(d-dt-inicio-old)          + CHR(13) +
                             "--------------------" + CHR(13) +
                             "Emitente novo     : " + string(b-tb-pr-cc.cod-emitente)  + CHR(13) +
                             "ConPag nova       : " + STRING(b-tb-pr-cc.cod-cond-pag)  + CHR(13) +
                             "Tabela nova       : " + b-tb-pr-cc.nr-tab                + CHR(13) +
                             "Dt.Inicio nova    : " + STRING(b-tb-pr-cc.dt-inicio)     + CHR(13).

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
        IF  v_cod_estab_usuar = c-cod-estabel THEN DO:
            
            IF c-destino = "" 
            THEN ASSIGN c-destino = ENTRY(2,tt-prog-ponto.conteudo).
            ELSE ASSIGN c-destino = c-destino + "," + ENTRY(2,tt-prog-ponto.conteudo).

        END.
    END.

    IF  c-destino <> "" THEN DO:

        RUN enviaMail (INPUT c-remetente,         /* premetente */
                       INPUT c-destino,           /* pDestino   */
                       INPUT trim(c-titulo),      /* pAssunto   */
                       INPUT c-texto-html[1],     /* pDescEmail */
                       INPUT "").                 /* pArquivo   */
    END. /* IF  c-destino <> "" THEN DO: */

    
END PROCEDURE.
