
/***********************************************************************
**  Programa..: esp/wmp/eswmp021rp.p
**  Autor.....: Nicolas Martinez
**  Data......: Agosto/2020 - Desenvolvimento
**  Descricao.: Relatorio historicos de bloqueio
**  Versao....: 001 12/08/2020
**                  Desenvolvimento Programa
************************************************************************/
{include/i-prgvrs.i ESWMP021RP 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ESWMP021RP MWM}
&ENDIF

{include/tt-edit.i}
{include/i_fnctrad.i}
{esp/es0043.i} /* <--- c-dir-arquivo-session  */

/* Parameters Definitions ---                                           */
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD usuario              AS CHAR FORMAT "X(12)"
    FIELD destino              AS INTEGER
    FIELD data-exec            AS DATE
    FIELD hora-exec            AS INTEGER
    FIELD arquivo              AS CHAR FORMAT "X(35)"
    FIELD cod-bloco-ini        LIKE wm-box.cod-bloco
    FIELD cod-bloco-fim        LIKE wm-box.cod-bloco
    FIELD cod-rua-ini          LIKE wm-box.cod-rua
    FIELD cod-rua-fim          LIKE wm-box.cod-rua
    FIELD cod-nivel-ini        LIKE wm-box.cod-nivel
    FIELD cod-nivel-fim        LIKE wm-box.cod-nivel
    FIELD cod-coluna-ini       LIKE wm-box.cod-coluna
    FIELD cod-coluna-fim       LIKE wm-box.cod-coluna  
    FIELD cod-item-ini         LIKE wm-item.cod-item
    FIELD cod-item-fim         LIKE wm-item.cod-item
    FIELD classifica           AS INTEGER
    FIELD desc-classifica      AS CHARACTER FORMAT "X(40)"
    FIELD cod-estabel          LIKE wm-saldo-estoque.cod-estabel
    FIELD nom-estabel          LIKE wm-estabel.nom-estabel
    FIELD cod-local            LIKE wm-saldo-estoque.cod-local
    FIELD nom-local            LIKE wm-local.nom-local
    FIELD bloqueio             AS INTEGER
    FIELD end-com-saldo        AS LOGICAL
    field tipo-rel             AS INTE
    field l-preventivo         AS LOG
    field l-estoque            AS LOG
    field l-lote               AS LOG
    field l-lancamento         AS LOG
    field l-inspecao           AS LOG
    field l-previsto           AS LOG.

DEF TEMP-TABLE ttResumo NO-UNDO
    FIELD cod-estabel        LIKE wm-box-saldo.cod-estabel
    FIELD cod-local          LIKE wm-box-saldo.cod-local
    FIELD cod-item           LIKE wm-box-saldo.cod-item
    FIELD id-box             LIKE wm-box-saldo.id-box
    FIELD cod-embalagem      LIKE wm-box-saldo.cod-embalagem
    FIELD qtd-item-bloq      LIKE wm-box-saldo.qtd-item
    FIELD desc-item            AS CHAR FORMAT "X(20)" LABEL "Descricao"
    FIELD cod-bloco          LIKE wm-box.cod-bloco
    FIELD cod-rua            LIKE wm-box.cod-rua
    FIELD cod-nivel          LIKE wm-box.cod-nivel
    FIELD cod-coluna         LIKE wm-box.cod-coluna
    FIELD ind-posicao-box      AS CHAR FORMAT "X(01)"
    FIELD id-saldo           LIKE wm-box-saldo.id-saldo
    FIELD cod-usuar-bloq-box LIKE wms-histor-bloq-box.cod-usuar-bloq-box     
    FIELD dat-bloq-box       LIKE wms-histor-bloq-box.dat-bloq-box           
    FIELD num-hora-bloq-box  LIKE wms-histor-bloq-box.num-hora-bloq-box   
    FIELD motivo             LIKE wms-histor-bloq-box.dsl-motiv-bloq-box
    FIELD tipo-bloq          AS CHAR
    FIELD obs-cartao         AS CHAR
    FIELD obs-solicitante    AS CHAR
    FIELD obs-responsavel    AS CHAR
    FIELD obs-pedido         AS CHAR
    FIELD obs-geral          AS CHAR
    INDEX idx-01            cod-estabel cod-local 
    INDEX idx-02 IS PRIMARY cod-estabel cod-local id-box cod-item.

DEFINE TEMP-TABLE ttImpressao NO-UNDO 
    FIELD cod-estabel        LIKE wm-box-saldo.cod-estabel
    FIELD cod-local          LIKE wm-box-saldo.cod-local
    FIELD cod-item           LIKE wm-box-saldo.cod-item
    FIELD id-box             LIKE wm-box-saldo.id-box
    FIELD cod-embalagem      LIKE wm-box-saldo.cod-embalagem
    FIELD qtd-item-bloq      LIKE wm-box-saldo.qtd-item
    FIELD desc-item            AS CHAR FORMAT "X(20)" LABEL "Descricao"
    FIELD cod-bloco          LIKE wm-box.cod-bloco
    FIELD cod-rua            LIKE wm-box.cod-rua
    FIELD cod-nivel          LIKE wm-box.cod-nivel
    FIELD cod-coluna         LIKE wm-box.cod-coluna
    FIELD ind-posicao-box    AS CHAR FORMAT "X(01)"
    FIELD cod-usuario        AS CHAR FORMAT "X(20)"
    FIELD dt-acao            AS DATE FORMAT "99/99/9999" LABEL "Data"
    FIELD hr-acao            AS CHAR FORMAT "X(8)"       LABEL "Hora"
    FIELD motivo             LIKE wms-histor-bloq-box.dsl-motiv-bloq-box
    FIELD tipo-bloq          AS CHAR
    FIELD obs-cartao         AS CHAR
    FIELD obs-solicitante    AS CHAR
    FIELD obs-responsavel    AS CHAR
    FIELD obs-pedido         AS CHAR
    FIELD obs-geral          AS CHAR
    INDEX idx-03            cod-estabel cod-local id-box    cod-item   cod-embalagem qtd-item-bloq
    INDEX idx-04 IS PRIMARY cod-item    cod-bloco cod-rua   cod-nivel  cod-coluna
    INDEX idx-05            cod-bloco   cod-rua   cod-nivel cod-coluna cod-item      cod-embalagem.

FUNCTION replaceEspecialChars RETURN CHARACTER (INPUT pcTexto AS CHAR):

    IF INDEX(pcTexto,CHR(10)) > 0 THEN ASSIGN pcTexto = REPLACE(pcTexto,CHR(10)," ").

    RETURN pcTexto.

END FUNCTION.

DEF TEMP-TABLE tt-raw-digita NO-UNDO
FIELD raw-digita AS RAW.

/* recebimento de parƒmetros */
DEF INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEF INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

/* include padrÆo para vari veis de relat¢rio  */
{include/i-rpvar.i}

/* defini‡Æo de vari veis  */
DEFINE VARIABLE h-acomp           AS HANDLE                                  NO-UNDO.
DEFINE VARIABLE c-motivo          AS CHAR FORMAT "X(80)" LABEL "Motivo"      NO-UNDO.
DEFINE VARIABLE c-selecao         AS CHAR FORMAT "X(15)"                     NO-UNDO.
DEFINE VARIABLE c-classificacao   AS CHAR FORMAT "X(15)"                     NO-UNDO.
DEFINE VARIABLE c-parametros      AS CHAR FORMAT "X(15)"                     NO-UNDO.
DEFINE VARIABLE c-destino         AS CHAR FORMAT "X(20)"                     NO-UNDO.
DEFINE VARIABLE c-arquivo         AS CHAR FORMAT "X(35)"                     NO-UNDO.
DEFINE VARIABLE c-descricao       AS CHAR FORMAT "X(20)"   LABEL "Descricao" NO-UNDO.
DEFINE VARIABLE i-qtd-embal-aux   AS INTEGER FORMAT ">>>9" LABEL "Qtde"      NO-UNDO.
DEFINE VARIABLE i-cont            AS INT                                     NO-UNDO.
DEFINE VARIABLE c-acomp           AS CHARACTER                               NO-UNDO.
DEFINE VARIABLE c-tot-enderecos   AS CHARACTER                               NO-UNDO.
DEFINE VARIABLE c-impressao-label AS CHARACTER                               NO-UNDO.
DEFINE VARIABLE c-arquivo-label   AS CHARACTER                               NO-UNDO.
DEFINE VARIABLE c-usuario-label   AS CHARACTER                               NO-UNDO.
DEFINE VARIABLE c-ind-pos-box     AS CHARACTER FORMAT "X(01)"                NO-UNDO.
DEFINE VARIABLE d-qtd-bloq      LIKE wm-saldo-estoque.qtd-atual              NO-UNDO.
DEFINE VARIABLE c-lbl-liter      AS CHARACTER                                NO-UNDO.
DEFINE VARIABLE c-lbl-liter-item AS CHARACTER                                NO-UNDO.

/* defini‡Æo de FRAMEs do relat¢rio */
FORM 
wm-box.cod-bloco             COLUMN-LABEL "Blc"           SPACE(0) 
wm-box.cod-rua               COLUMN-LABEL "Rua"           SPACE(0)  
wm-box.cod-nivel             COLUMN-LABEL "Niv"           SPACE(0) 
wm-box.cod-coluna            COLUMN-LABEL "Col"           SPACE(0)  
c-ind-pos-box                COLUMN-LABEL "L"             SPACE(0)  
wm-box-saldo.cod-item                                     SPACE(0)
c-descricao                                               SPACE(0)
wm-box-saldo.cod-embalagem   COLUMN-LABEL "Embalagem"     SPACE(0) 
wm-box-saldo.qtd-item-bloq   COLUMN-LABEL "Qtd Item Bloq" SPACE(0) 
ttImpressao.cod-usuario      COLUMN-LABEL "Usu rio" FORMAT "X(20)"      SPACE(0)
ttImpressao.dt-acao          COLUMN-LABEL "Data"          SPACE(0)
ttImpressao.hr-acao          COLUMN-LABEL "Hora"          SPACE(0)
c-motivo                     COLUMN-LABEL "Motivo"        
WITH NO-BOX WIDTH 250 ATTR-SPACE 64 DOWN FRAME f-detalhe-item STREAM-IO.

{utp/ut-liter.i "Descricao" *}
c-descricao:LABEL IN FRAME f-detalhe-item = TRIM(RETURN-VALUE) .


FORM SKIP (2)
c-selecao NO-LABEL      AT  3 SKIP(1)
tt-param.cod-bloco-ini  AT 19 "|<  >|" AT 48 tt-param.cod-bloco-fim             NO-LABEL SKIP
tt-param.cod-rua-ini    AT 21 "|<  >|" AT 48 tt-param.cod-rua-fim               NO-LABEL SKIP
tt-param.cod-nivel-ini  AT 19 "|<  >|" AT 48 tt-param.cod-nivel-fim             NO-LABEL SKIP
tt-param.cod-coluna-ini AT 18 "|<  >|" AT 48 tt-param.cod-coluna-fim            NO-LABEL SKIP
tt-param.cod-item-ini   AT 20 "|<  >|" AT 48 tt-param.cod-item-fim              NO-LABEL SKIP
SKIP (2)
c-classificacao NO-LABEL  AT  3 SKIP(1)
tt-param.classifica LABEL "Classificacao"  AT 11 " - " tt-param.desc-classifica NO-LABEL SKIP
SKIP (2)
c-parametros NO-LABEL  AT  3 SKIP(1)
tt-param.cod-estabel   AT  9 " - " tt-param.nom-estabel                         NO-LABEL SKIP
tt-param.cod-local     AT 19 " - " tt-param.nom-local                           NO-LABEL SKIP
WITH NO-BOX SIDE-LABEL WIDTH 200 FRAME f-param-sel STREAM-IO.

/* include padrÆo para output de relat¢rios */
run utp/ut-trfrrp.p (input frame f-param-sel:handle).
run utp/ut-trfrrp.p (input frame f-detalhe-item:handle).
run utp/ut-trfrrp.p (input frame f-detalhe-item:handle).

{include/i-rpout.i &STREAM="stream str-rp"}

/* include com a defini‡Æo da FRAME de cabe‡alho e rodap‚ */
{include/i-rpcab.i &STREAM="str-rp"}

/* bloco principal do programa */

{utp/ut-liter.i "Situa‡Æo Endere‡os Bloqueados" *}

ASSIGN c-programa     = "ESWMP021RP":U
  c-versao       = "2.00"
  c-revisao      = ".00.001"
  c-sistema	  = "WMS":U
  c-titulo-relat = trim(RETURN-VALUE) .

FIND FIRST   wm-param NO-LOCK NO-ERROR.	
IF AVAILABLE wm-param THEN c-empresa = wm-param.nom-empresa. 

VIEW STREAM str-rp FRAME f-cabec.
VIEW STREAM str-rp FRAME f-rodape.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{ utp/ut-liter.i "Endere‡os Bloqueados" *}
RUN pi-inicializar IN h-acomp (INPUT trim(RETURN-VALUE)).
{ utp/ut-liter.i "Aguarde" *}
RUN pi-acompanhar  IN h-acomp (INPUT trim(RETURN-VALUE) + "...").

PUT STREAM str-rp SKIP(1).

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    EMPTY TEMP-TABLE ttResumo.
&ELSE
    FOR EACH ttResumo:
        DELETE ttResumo.
    END.
&ENDIF

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
    EMPTY TEMP-TABLE ttImpressao.
&ELSE
    FOR EACH ttImpressao:
        DELETE ttImpressao.
    END.
&ENDIF

IF tt-param.tipo-rel = 1
THEN DO:
    FOR EACH wm-box 
        WHERE wm-box.cod-estabel = tt-param.cod-estabel     AND 
              wm-box.cod-local   = tt-param.cod-local       AND 
              wm-box.cod-bloco  >= tt-param.cod-bloco-ini   AND 
              wm-box.cod-bloco  <= tt-param.cod-bloco-fim   AND 
              wm-box.cod-rua    >= tt-param.cod-rua-ini     AND 
              wm-box.cod-rua    <= tt-param.cod-rua-fim     AND 
              wm-box.cod-coluna >= tt-param.cod-coluna-ini  AND 
              wm-box.cod-coluna <= tt-param.cod-coluna-fim  AND 
              wm-box.cod-nivel  >= tt-param.cod-nivel-ini   AND 
              wm-box.cod-nivel  <= tt-param.cod-nivel-fim   NO-LOCK:

        RUN pi-acompanhar  IN h-acomp (INPUT STRING(wm-box.id-box)).

        IF tt-param.bloqueio = 1 AND NOT(wm-box.log-bloq-retir = YES OR CAN-FIND(FIRST wm-box-saldo OF wm-box WHERE wm-box-saldo.ind-status-saldo > 3 NO-LOCK)) THEN
            NEXT. 

        {utp/ut-liter.i "Id Endere‡o" *}
        ASSIGN c-acomp = TRIM(RETURN-VALUE) + ": " + STRING(wm-box.id-box).
        {utp/ut-liter.i ___Id_Endere‡o:_ *}

        IF tt-param.end-com-saldo = YES AND
        NOT CAN-FIND(FIRST wm-box-saldo OF wm-box WHERE
                           wm-box-saldo.cod-item   >= tt-param.cod-item-ini  AND 
                           wm-box-saldo.cod-item   <= tt-param.cod-item-fim  NO-LOCK) THEN NEXT.

        FOR EACH  wm-box-saldo 
            WHERE wm-box-saldo.cod-estabel = wm-box.cod-estabel     AND 
                  wm-box-saldo.cod-local   = wm-box.cod-local       AND 
                  wm-box-saldo.id-box      = wm-box.id-box          AND
                  wm-box-saldo.cod-item   >= tt-param.cod-item-ini  AND 
                  wm-box-saldo.cod-item   <= tt-param.cod-item-fim  NO-LOCK:

            IF CAN-FIND(FIRST wm-box-saldo OF wm-box WHERE wm-box-saldo.ind-status-saldo = 6 NO-LOCK) THEN  
                NEXT. 
            IF CAN-FIND(FIRST wm-box-saldo OF wm-box WHERE wm-box-saldo.ind-status-saldo = 7 NO-LOCK) THEN
                NEXT. 

            /* Inicio -- Projeto Internacional */
            ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "Item" *}
            ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
            RUN pi-acompanhar IN h-acomp (INPUT c-lbl-liter  + STRING(wm-box.id-box)).

            IF NOT CAN-FIND(FIRST ttResumo
                            WHERE ttResumo.cod-estabel = wm-box-saldo.cod-estabel AND
                                  ttResumo.cod-local   = wm-box-saldo.cod-local   AND
                                  ttResumo.id-saldo    = wm-box-saldo.id-saldo    NO-LOCK) 
            THEN DO:

                CREATE ttResumo.
                ASSIGN ttResumo.cod-estabel    = wm-box.cod-estabel
                       ttResumo.cod-local      = wm-box.cod-local
                       ttResumo.id-box         = wm-box.id-box
                       ttResumo.cod-bloco      = wm-box.cod-bloco
                       ttResumo.cod-rua        = wm-box.cod-rua
                       ttResumo.cod-nivel      = wm-box.cod-nivel
                       ttResumo.cod-coluna     = wm-box.cod-coluna
                       ttResumo.cod-item       = wm-box-saldo.cod-item
                       ttResumo.cod-embalagem  = wm-box-saldo.cod-embalagem
                       ttResumo.qtd-item-bloq  = wm-box-saldo.qtd-item - wm-box-saldo.qtd-item-bloq + wm-box-saldo.qtd-pendente.

                IF wm-box.ind-posicao-box = 1 THEN
                    ASSIGN ttResumo.ind-posicao-box = "E".
                ELSE
                    ASSIGN ttResumo.ind-posicao-box = "D".

                FOR EACH wms-histor-bloq-box 
                   WHERE wms-histor-bloq-box.cod-estabel      = wm-box.cod-estabel AND 
                         wms-histor-bloq-box.cod-local        = wm-box.cod-local   AND 
                         wms-histor-bloq-box.id-box           = wm-box.id-box      AND 
                         //wms-histor-bloq-box.idi-tip-bloq-box = tt-param.bloqueio  
                         wms-histor-bloq-box.idi-tip-bloq-box = 2
                         NO-LOCK 
                      BY wms-histor-bloq-box.dat-bloq-box DESC BY wms-histor-bloq-box.num-hora-bloq-box DESC:
                    FOR EACH tt-editor: DELETE tt-editor. END.
                    RUN pi-print-editor(wms-histor-bloq-box.dsl-motiv-bloq-box,80).
                    
                    FOR EACH tt-editor:        
                        ASSIGN ttResumo.motivo = ttREsumo.motivo + tt-editor.conteudo.
                        
                    END.

                    ASSIGN ttResumo.cod-usuar-bloq-box = wms-histor-bloq-box.cod-usuar-bloq-box
                           ttResumo.dat-bloq-box       = wms-histor-bloq-box.dat-bloq-box      
                           ttResumo.num-hora-bloq-box  = wms-histor-bloq-box.num-hora-bloq-box.

                    IF wm-box-saldo.ind-status-saldo > 3
                    THEN DO:
                        IF wm-box-saldo.ind-status-saldo = 5 THEN DO:
                            ASSIGN ttResumo.tipo-bloq = "Lote Recusado".
                            FIND FIRST wm-roteiro-docto-itens WHERE
                                wm-roteiro-docto-itens.cod-estabel  = wm-box-saldo.cod-estabel  AND
                                wm-roteiro-docto-itens.cod-local    = wm-box-saldo.cod-local    AND
                                wm-roteiro-docto-itens.id-docto     = wm-box-saldo.id-docto     AND
                                wm-roteiro-docto-itens.num-seq-item = wm-box-saldo.num-seq-item NO-LOCK NO-ERROR.
                            IF AVAIL wm-roteiro-docto-itens THEN DO:
                                FIND FIRST ficha-cq OF wm-roteiro-docto-itens NO-LOCK NO-ERROR.
                                //ASSIGN ttResumo.motivo = IF AVAIL ficha-cq THEN ficha-cq.narrativa ELSE "Sem Motivo".
                                ASSIGN ttResumo.motivo = IF AVAIL ficha-cq THEN REPLACE(REPLACE(ficha-cq.narrativa, CHR(10), " "), CHR(13), " ") ELSE "Sem Motivo"
                                       ttResumo.cod-usuar-bloq-box = IF AVAIL ficha-cq THEN ficha-cq.cod-resp ELSE ""
                                       ttResumo.dat-bloq-box       = IF AVAIL ficha-cq THEN ficha-cq.dt-analise ELSE ?
                                       ttResumo.num-hora-bloq-box  = IF AVAIL ficha-cq THEN ficha-cq.int-1 ELSE 0.
                            END.
                            ELSE DO:
                                ASSIGN ttResumo.motivo = "Sem Motivo".
                            END.
                        END.
                        ELSE
                            ASSIGN ttResumo.tipo-bloq = "Inspe‡Æo".
                    END.
                    ELSE DO:

                        FIND LAST int-wms-histor-bloq-box WHERE
                                  int-wms-histor-bloq-box.cod-estabel       = wms-histor-bloq-box.cod-estabel
                              AND int-wms-histor-bloq-box.cod-local         = wms-histor-bloq-box.cod-local
                              AND int-wms-histor-bloq-box.id-box            = wms-histor-bloq-box.id-box
                              AND int-wms-histor-bloq-box.dat-bloq-box      = wms-histor-bloq-box.dat-bloq-box
                              AND int-wms-histor-bloq-box.num-hora-bloq-box = wms-histor-bloq-box.num-hora-bloq-box
                              AND int-wms-histor-bloq-box.idi-tip-bloq-box  = wms-histor-bloq-box.idi-tip-bloq-box
                                  NO-LOCK NO-ERROR.
                                                         
                        IF AVAIL int-wms-histor-bloq-box 
                        THEN DO:
    
                            ASSIGN ttResumo.obs-cartao      = replaceEspecialChars(int-wms-histor-bloq-box.obs-cartao)
                                   ttResumo.obs-solicitante = replaceEspecialChars(int-wms-histor-bloq-box.obs-solicitante) 
                                   ttResumo.obs-responsavel = replaceEspecialChars(int-wms-histor-bloq-box.obs-responsavel)  
                                   ttResumo.obs-pedido      = replaceEspecialChars(int-wms-histor-bloq-box.obs-pedido)  
                                   ttResumo.obs-geral       = replaceEspecialChars(int-wms-histor-bloq-box.obs-geral).
                        
                            CASE int-wms-histor-bloq-box.tipo-bloq:
                                WHEN 1 THEN ASSIGN ttResumo.tipo-bloq = "Preventivo".
                                WHEN 2 THEN ASSIGN ttResumo.tipo-bloq = "Estoque".
                                WHEN 3 THEN ASSIGN ttResumo.tipo-bloq = "Lote Recusado".
                                WHEN 4 THEN ASSIGN ttResumo.tipo-bloq = "Aguardando lan‡amento".
                                WHEN 5 THEN ASSIGN ttResumo.tipo-bloq = "Inspe‡Æo".
                                WHEN 6 THEN ASSIGN ttResumo.tipo-bloq = "Previsto".
                            END CASE.
                        END.
                        ELSE DO:
                            ASSIGN ttResumo.obs-cartao      = ""
                                   ttResumo.obs-solicitante = ""
                                   ttResumo.obs-responsavel = ""
                                   ttResumo.obs-pedido      = ""
                                   ttResumo.obs-geral       = ""
                                   ttResumo.tipo-bloq       = "".
                        END.
                        LEAVE.
                    END.
                END.
            END.        
        END.    
        IF NOT CAN-FIND(FIRST ttResumo
                        WHERE ttResumo.cod-estabel = wm-box.cod-estabel AND
                              ttResumo.cod-local   = wm-box.cod-local   AND
                              ttResumo.id-box      = wm-box.id-box      NO-LOCK) 
        THEN DO:

            CREATE ttResumo.
            ASSIGN ttResumo.cod-estabel    = wm-box.cod-estabel
                   ttResumo.cod-local      = wm-box.cod-local
                   ttResumo.id-box         = wm-box.id-box
                   ttResumo.cod-bloco      = wm-box.cod-bloco
                   ttResumo.cod-rua        = wm-box.cod-rua
                   ttResumo.cod-nivel      = wm-box.cod-nivel
                   ttResumo.cod-coluna     = wm-box.cod-coluna
                   ttResumo.cod-item       = ""
                   ttResumo.cod-embalagem  = ""
                   ttResumo.qtd-item-bloq  = 0.

            IF wm-box.ind-posicao-box = 1 THEN
                ASSIGN ttResumo.ind-posicao-box = "E".
            ELSE
                ASSIGN ttResumo.ind-posicao-box = "D".

            FOR EACH wms-histor-bloq-box 
                WHERE wms-histor-bloq-box.cod-estabel      = wm-box.cod-estabel AND 
                      wms-histor-bloq-box.cod-local        = wm-box.cod-local   AND 
                      wms-histor-bloq-box.id-box           = wm-box.id-box      AND 
                      //wms-histor-bloq-box.idi-tip-bloq-box = tt-param.bloqueio  
                      wms-histor-bloq-box.idi-tip-bloq-box = 2
                      NO-LOCK BY wms-histor-bloq-box.dat-bloq-box DESC BY wms-histor-bloq-box.num-hora-bloq-box DESC:
                FOR EACH tt-editor: DELETE tt-editor. END.
                RUN pi-print-editor(wms-histor-bloq-box.dsl-motiv-bloq-box,80).
                FOR EACH tt-editor:                     
                    ASSIGN ttResumo.motivo = ttREsumo.motivo + tt-editor.conteudo.
                
                END.
                ASSIGN ttResumo.cod-usuar-bloq-box = wms-histor-bloq-box.cod-usuar-bloq-box
                       ttResumo.dat-bloq-box       = wms-histor-bloq-box.dat-bloq-box      
                       ttResumo.num-hora-bloq-box  = wms-histor-bloq-box.num-hora-bloq-box.
                LEAVE.
            END.
        END.
    END.
END.
ELSE DO:
    FOR EACH wm-box 
        WHERE wm-box.cod-estabel = tt-param.cod-estabel     AND 
              wm-box.cod-local   = tt-param.cod-local       AND 
              wm-box.cod-bloco  >= tt-param.cod-bloco-ini   AND 
              wm-box.cod-bloco  <= tt-param.cod-bloco-fim   AND 
              wm-box.cod-rua    >= tt-param.cod-rua-ini     AND 
              wm-box.cod-rua    <= tt-param.cod-rua-fim     AND 
              wm-box.cod-coluna >= tt-param.cod-coluna-ini  AND 
              wm-box.cod-coluna <= tt-param.cod-coluna-fim  AND 
              wm-box.cod-nivel  >= tt-param.cod-nivel-ini   AND 
              wm-box.cod-nivel  <= tt-param.cod-nivel-fim   NO-LOCK:

        RUN pi-acompanhar IN h-acomp (INPUT "Id Box: "  + STRING(wm-box.id-box)).

        FOR EACH wms-histor-bloq-box 
           WHERE wms-histor-bloq-box.cod-estabel      = wm-box.cod-estabel AND 
                 wms-histor-bloq-box.cod-local        = wm-box.cod-local   AND 
                 wms-histor-bloq-box.id-box           = wm-box.id-box      AND 
                 //wms-histor-bloq-box.idi-tip-bloq-box = tt-param.bloqueio  
                 wms-histor-bloq-box.idi-tip-bloq-box = 2
                 NO-LOCK.

            CREATE ttResumo.
            ASSIGN ttResumo.cod-estabel        = wm-box.cod-estabel
                   ttResumo.cod-local          = wm-box.cod-local
                   ttResumo.id-box             = wm-box.id-box
                   ttResumo.cod-bloco          = wm-box.cod-bloco
                   ttResumo.cod-rua            = wm-box.cod-rua
                   ttResumo.cod-nivel          = wm-box.cod-nivel
                   ttResumo.cod-coluna         = wm-box.cod-coluna
                   ttResumo.cod-item           = ""
                   ttResumo.cod-embalagem      = ""
                   ttResumo.cod-usuar-bloq-box = wms-histor-bloq-box.cod-usuar-bloq-box
                   ttResumo.dat-bloq-box       = wms-histor-bloq-box.dat-bloq-box      
                   ttResumo.num-hora-bloq-box  = wms-histor-bloq-box.num-hora-bloq-box.

            FOR EACH tt-editor: DELETE tt-editor. END.
            RUN pi-print-editor(wms-histor-bloq-box.dsl-motiv-bloq-box,80).
            FOR EACH tt-editor:                     
                ASSIGN ttResumo.motivo = ttREsumo.motivo + tt-editor.conteudo.
            END.

                FIND LAST int-wms-histor-bloq-box WHERE
                          int-wms-histor-bloq-box.cod-estabel       = wms-histor-bloq-box.cod-estabel
                      AND int-wms-histor-bloq-box.cod-local         = wms-histor-bloq-box.cod-local
                      AND int-wms-histor-bloq-box.id-box            = wms-histor-bloq-box.id-box
                      AND int-wms-histor-bloq-box.dat-bloq-box      = wms-histor-bloq-box.dat-bloq-box
                      AND int-wms-histor-bloq-box.num-hora-bloq-box = wms-histor-bloq-box.num-hora-bloq-box
                      AND int-wms-histor-bloq-box.idi-tip-bloq-box  = wms-histor-bloq-box.idi-tip-bloq-box
                          NO-LOCK NO-ERROR.
                                                 
                IF AVAIL int-wms-histor-bloq-box 
                THEN DO:
    
                    ASSIGN ttResumo.obs-cartao      = replaceEspecialChars(int-wms-histor-bloq-box.obs-cartao)      
                           ttResumo.obs-solicitante = replaceEspecialChars(int-wms-histor-bloq-box.obs-solicitante) 
                           ttResumo.obs-responsavel = replaceEspecialChars(int-wms-histor-bloq-box.obs-responsavel) 
                           ttResumo.obs-pedido      = replaceEspecialChars(int-wms-histor-bloq-box.obs-pedido)      
                           ttResumo.obs-geral       = replaceEspecialChars(int-wms-histor-bloq-box.obs-geral)
                           ttResumo.cod-item        = int-wms-histor-bloq-box.it-codigo.    
                
                    CASE int-wms-histor-bloq-box.tipo-bloq:
                        WHEN 1 THEN ASSIGN ttResumo.tipo-bloq = "Preventivo".
                        WHEN 2 THEN ASSIGN ttResumo.tipo-bloq = "Estoque".
                        WHEN 3 THEN ASSIGN ttResumo.tipo-bloq = "Lote Recusado".
                        WHEN 4 THEN ASSIGN ttResumo.tipo-bloq = "Aguardando lan‡amento".
                        WHEN 5 THEN ASSIGN ttResumo.tipo-bloq = "Inspe‡Æo".
                        WHEN 6 THEN ASSIGN ttResumo.tipo-bloq = "Previsto".
                    END CASE.
                END.
                ELSE DO:
                    ASSIGN ttResumo.obs-cartao      = ""
                           ttResumo.obs-solicitante = ""
                           ttResumo.obs-responsavel = ""
                           ttResumo.obs-pedido      = ""
                           ttResumo.obs-geral       = ""
                           ttResumo.tipo-bloq       = "".
                END.
        END.
    END.
END.

IF OPSYS = 'unix' 
THEN ASSIGN c-arquivo = c-dir-arquivo-session + tt-param.usuario + "/" + "eswmp021.csv".
ELSE ASSIGN c-arquivo = c-dir-arquivo-session + tt-param.usuario + "\" + "eswmp021.csv".

DISP STREAM str-rp "Arquivo gerado: " c-arquivo NO-LABEL FORMAT "x(60)" .

OUTPUT TO VALUE(c-arquivo) CONVERT TARGET "iso8859-1".

PUT UNFORMATTED 
    "Estab;Local;Id Box;Bloco;Rua;Nivel;Coluna;Item;Desc;Unid Neg;Tipo Bloq;Qtd;Motivo;Num CartÆo;Solicitante AQ;Responsavel;PO;Obs;Usuario;Data Bloq;Hora" SKIP.

FOR EACH ttResumo WHERE
         ttResumo.cod-item >= tt-param.cod-item-ini  AND    
         ttResumo.cod-item <= tt-param.cod-item-fim
         NO-LOCK
    BREAK BY ttResumo.cod-item
          BY ttResumo.id-box.

    IF ttResumo.tipo-bloq = "" THEN NEXT.

    IF tt-param.bloqueio = 1 
    THEN DO:
        IF tt-param.l-preventivo = NO AND ttResumo.tipo-bloq = "Preventivo" THEN NEXT.           
        IF tt-param.l-estoque    = NO AND ttResumo.tipo-bloq = "Estoque"    THEN NEXT.              
        IF tt-param.l-lote       = NO AND ttResumo.tipo-bloq = "Lote Recusado" THEN NEXT.        
        IF tt-param.l-lancamento = NO AND ttResumo.tipo-bloq = "Aguardando lan‡amento" THEN NEXT.
        IF tt-param.l-inspecao   = NO AND ttResumo.tipo-bloq = "Inspe‡Æo" THEN NEXT.             
        IF tt-param.l-previsto   = NO AND ttResumo.tipo-bloq = "Previsto" THEN NEXT.             
    END. 

    FIND FIRST ITEM WHERE
               ITEM.it-codigo = ttResumo.cod-item
               NO-LOCK NO-ERROR.

    PUT UNFORMATTED
         ttResumo.cod-estabel       ";"
         ttResumo.cod-local         ";"
         ttResumo.id-box            ";"
         ttResumo.cod-bloco         ";"
         ttResumo.cod-rua           ";"
         ttResumo.cod-nivel         ";"
         ttResumo.cod-coluna        ";"
         ttResumo.cod-item          ";"
         IF AVAIL ITEM 
         THEN ITEM.desc-item
         ELSE ""                    ";" 
         IF AVAIL ITEM 
         THEN ITEM.cod-unid-negoc
         ELSE ""                    ";"
         ttResumo.tipo-bloq         ";"
         ttResumo.qtd-item-bloq     ";"
         ttResumo.motivo            ";"
         ttResumo.obs-cartao        ";"
         ttResumo.obs-solicitante   ";"
         ttResumo.obs-responsavel   ";"
         ttResumo.obs-pedido        ";"
         ttResumo.obs-geral         ";"
         ttResumo.cod-usuar-bloq-box ";"
         ttResumo.dat-bloq-box      ";"
         STRING(ttResumo.num-hora-bloq-box,"HH:MM:SS") ";" SKIP.

END.

OUTPUT CLOSE.

IF tt-param.destino = 3 THEN
DOS SILENT START excel value(c-arquivo).

/*{ utp/ut-liter.i "Total_de_Endere‡os" * }

ASSIGN c-tot-enderecos = TRIM(RETURN-VALUE) +  ": " .

PUT STREAM str-rp SKIP(1)
    c-tot-enderecos FORMAT "x(20)" 
    i-cont. */

PAGE STREAM str-rp.

{ utp/ut-liter.i "SELE€ÇO" *}
ASSIGN c-selecao       = TRIM(RETURN-VALUE) .
{ utp/ut-liter.i "PAR¶METROS" *}
ASSIGN c-parametros    = TRIM(RETURN-VALUE) .
{ utp/ut-liter.i "CLASSIFICA€¶O" *}
ASSIGN c-classificacao = TRIM(RETURN-VALUE).

/* final do arquivo */
DISPLAY STREAM str-rp
     c-selecao
     tt-param.cod-bloco-ini
     tt-param.cod-bloco-fim
     tt-param.cod-rua-ini
     tt-param.cod-rua-fim
     tt-param.cod-nivel-ini
     tt-param.cod-nivel-fim
     tt-param.cod-coluna-ini
     tt-param.cod-coluna-fim 
     tt-param.cod-item-ini
     tt-param.cod-item-fim
     c-classificacao
     tt-param.classifica
     tt-param.desc-classifica
     c-parametros
     tt-param.cod-estabel
     tt-param.nom-estabel
     tt-param.cod-local
     tt-param.nom-local
     WITH  FRAME f-param-sel.

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
ASSIGN cAuxTraducao003 = {varinc/var00002.i 04 tt-param.destino}.
run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao003)," ","_"),
                    INPUT "",
                    INPUT "").
ASSIGN c-destino = RETURN-VALUE.
&else
ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}.
&endif
ASSIGN c-arquivo = tt-param.arquivo.

{ utp/ut-liter.i "IMPRESSÇO" *}
ASSIGN c-impressao-label = TRIM(RETURN-VALUE) .
{ utp/ut-liter.i "Arquivo" *}
ASSIGN c-arquivo-label = TRIM(RETURN-VALUE) . 
{ utp/ut-liter.i "Usu rio" *}
ASSIGN c-usuario-label = TRIM(RETURN-VALUE) . 

PUT STREAM str-rp UNFORMATTED SKIP (2)       
    c-impressao-label  AT  3 SKIP(1)
    c-arquivo-label    AT 17 ": " c-destino " - " c-arquivo
    c-usuario-label    AT 17 ": " tt-param.usuario.

{include/pi-edit.i}

/* fechamento do output do relat¢rio  */
{include/i-rpclo.i &STREAM="stream str-rp"}

RUN pi-finalizar IN h-acomp.
RETURN "OK":U.

