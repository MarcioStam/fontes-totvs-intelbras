/********************************************************************************
** Copyright SCM (2016)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da SCM, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ESWMP009RP 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i ESWMP009RP MWM}
&ENDIF

{include/tt-edit.i}
{include/i_fnctrad.i}

/* Defini‡Æo das Temp-Tables para Recebimento de Parƒmetros */
DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD usuario            AS CHAR FORMAT "X(12)"
    FIELD destino            AS INTEGER
    FIELD data-exec          AS DATE
    FIELD hora-exec          AS INTEGER 
    FIELD arquivo            AS CHAR FORMAT "X(35)"
    FIELD cod-bloco-ini      LIKE wm-box.cod-bloco
    FIELD cod-bloco-fim      LIKE wm-box.cod-bloco
    FIELD cod-rua-ini        LIKE wm-box.cod-rua
    FIELD cod-rua-fim        LIKE wm-box.cod-rua
    FIELD cod-nivel-ini      LIKE wm-box.cod-nivel
    FIELD cod-nivel-fim      LIKE wm-box.cod-nivel
    FIELD cod-coluna-ini     LIKE wm-box.cod-coluna
    FIELD cod-coluna-fim     LIKE wm-box.cod-coluna
    FIELD cod-item-ini       LIKE wm-item.cod-item
    FIELD cod-item-fim       LIKE wm-item.cod-item
    FIELD classifica         AS INTEGER LABEL "Classifica‡Æo"
    FIELD desc-classifica    AS CHARACTER FORMAT "X(40)"
    FIELD cod-estabel        LIKE wm-saldo-estoque.cod-estabel
    FIELD nom-estabel        LIKE wm-estabel.nom-estabel
    FIELD cod-local          LIKE wm-saldo-estoque.cod-local
    FIELD nom-local          LIKE wm-local.nom-local
    FIELD bloqueio           AS INTEGER
    FIELD end-com-saldo      AS LOGICAL.

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
    INDEX idx-03            cod-estabel cod-local id-box    cod-item   cod-embalagem qtd-item-bloq
    INDEX idx-04 IS PRIMARY cod-item    cod-bloco cod-rua   cod-nivel  cod-coluna
    INDEX idx-05            cod-bloco   cod-rua   cod-nivel cod-coluna cod-item      cod-embalagem.

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

ASSIGN c-programa     = "ESWMP009RP":U
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

    IF tt-param.bloqueio = 1 AND NOT wm-box.log-bloq-armaz THEN
            NEXT.
    
    IF tt-param.bloqueio = 2 AND NOT wm-box.log-bloq-retir THEN
        NEXT.

    {utp/ut-liter.i "Id Endere‡o" *}
    ASSIGN c-acomp = TRIM(RETURN-VALUE) + ": " + STRING(wm-box.id-box).
    {utp/ut-liter.i ___Id_Endere‡o:_ *}

    IF tt-param.end-com-saldo = YES AND
       NOT CAN-FIND(FIRST wm-box-saldo OF wm-box WHERE
                    wm-box-saldo.cod-item   >= tt-param.cod-item-ini  AND 
                    wm-box-saldo.cod-item   <= tt-param.cod-item-fim  NO-LOCK) THEN
        NEXT.

    FOR EACH  wm-box-saldo 
        WHERE wm-box-saldo.cod-estabel = wm-box.cod-estabel     AND 
              wm-box-saldo.cod-local   = wm-box.cod-local       AND 
              wm-box-saldo.id-box      = wm-box.id-box          AND
              wm-box-saldo.cod-item   >= tt-param.cod-item-ini  AND 
              wm-box-saldo.cod-item   <= tt-param.cod-item-fim  NO-LOCK:

        /* Inicio -- Projeto Internacional */
        ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
        {utp/ut-liter.i "Item" *}
        ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
        RUN pi-acompanhar IN h-acomp (INPUT c-lbl-liter  + STRING(wm-box.id-box)).
    
        IF NOT CAN-FIND(FIRST ttResumo
                        WHERE ttResumo.cod-estabel = wm-box-saldo.cod-estabel AND
                              ttResumo.cod-local   = wm-box-saldo.cod-local   AND
                              ttResumo.id-saldo    = wm-box-saldo.id-saldo    NO-LOCK) THEN DO:

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
                      wms-histor-bloq-box.idi-tip-bloq-box = tt-param.bloqueio  NO-LOCK BY wms-histor-bloq-box.dat-bloq-box DESC BY wms-histor-bloq-box.num-hora-bloq-box DESC:
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


    IF NOT CAN-FIND(FIRST ttResumo
                    WHERE ttResumo.cod-estabel = wm-box.cod-estabel AND
                          ttResumo.cod-local   = wm-box.cod-local   AND
                          ttResumo.id-box      = wm-box.id-box      NO-LOCK) THEN DO:

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
                  wms-histor-bloq-box.idi-tip-bloq-box = tt-param.bloqueio  NO-LOCK BY wms-histor-bloq-box.dat-bloq-box DESC BY wms-histor-bloq-box.num-hora-bloq-box DESC:
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

{utp/ut-liter.i "Totalizando Informa‡äes" *}
RUN pi-acompanhar IN h-acomp (INPUT trim(RETURN-VALUE)).

FOR EACH ttResumo USE-INDEX idx-02:

    FIND FIRST ttImpressao 
         WHERE ttImpressao.cod-estabel      = ttResumo.cod-estabel      AND
               ttImpressao.cod-local        = ttResumo.cod-local        AND
               ttImpressao.id-box           = ttResumo.id-box           AND
               ttImpressao.cod-item         = ttResumo.cod-item         AND              
               ttImpressao.cod-embalagem    = ttResumo.cod-embalagem    AND
               ttImpressao.qtd-item-bloq    = ttResumo.qtd-item-bloq    NO-ERROR.

    IF NOT AVAIL ttImpressao THEN DO:
        CREATE ttImpressao.
        ASSIGN ttImpressao.cod-estabel        = ttResumo.cod-estabel
               ttImpressao.cod-local          = ttResumo.cod-local
               ttImpressao.id-box             = ttResumo.id-box
               ttImpressao.cod-item           = ttResumo.cod-item
               ttImpressao.cod-embalagem      = ttResumo.cod-embalagem
               ttImpressao.qtd-item-bloq      = ttResumo.qtd-item-bloq
               ttImpressao.cod-bloco          = ttResumo.cod-bloco
               ttImpressao.cod-rua            = ttResumo.cod-rua
               ttImpressao.cod-nivel          = ttResumo.cod-nivel
               ttImpressao.cod-coluna         = ttResumo.cod-coluna
               ttImpressao.ind-posicao-box    = ttResumo.ind-posicao-box
               ttImpressao.motivo             = ttResumo.motivo
               ttImpressao.cod-usuario        = ttResumo.cod-usuar-bloq-box
               ttImpressao.dt-acao            = ttResumo.dat-bloq-box      
               ttImpressao.hr-acao            = STRING(ttResumo.num-hora-bloq-box,"HH:MM:SS").
    END.  
END.                                                                 

CASE tt-param.classifica:

    WHEN 1 THEN DO:   /* Classifica‡Æo por Item */

        ASSIGN i-cont = 0.

        FOR EACH ttImpressao USE-INDEX idx-04
              BY ttImpressao.cod-item
              BY ttImpressao.cod-bloco
              BY ttImpressao.cod-rua  
              BY ttImpressao.cod-nivel
              BY ttImpressao.cod-coluna:

            IF ttImpressao.cod-item <> "" THEN DO:
                FIND FIRST wm-item
                     WHERE wm-item.cod-item = ttImpressao.cod-item NO-LOCK NO-ERROR.
                IF AVAIL wm-item THEN
                    ASSIGN ttImpressao.desc-item = wm-item.des-item.
            END.

            ASSIGN i-cont   = i-cont + 1.
            
            DISP STREAM str-rp
                ttImpressao.cod-item           @ wm-box-saldo.cod-item
                ttImpressao.desc-item          @ c-descricao
                ttImpressao.cod-bloco          @ wm-box.cod-bloco
                ttImpressao.cod-rua            @ wm-box.cod-rua
                ttImpressao.cod-nivel          @ wm-box.cod-nivel
                ttImpressao.cod-coluna         @ wm-box.cod-coluna
                ttImpressao.ind-posicao-box    @ c-ind-pos-box
                ttImpressao.cod-embalagem      @ wm-box-saldo.cod-embalagem
                ttImpressao.qtd-item-bloq      @ wm-box-saldo.qtd-item-bloq
                ttImpressao.cod-usuario
                ttImpressao.dt-acao    
                ttImpressao.hr-acao    
                ttImpressao.motivo             @ c-motivo
                WITH FRAME f-detalhe-item.
            DOWN STREAM str-rp WITH FRAME f-detalhe-item.
        END.                              
    END.

    WHEN 2 THEN DO: /* Classifica‡Æo por Endere‡o */

        ASSIGN i-cont = 0.

        FOR EACH ttImpressao USE-INDEX idx-05
              BY ttImpressao.cod-bloco
              BY ttImpressao.cod-rua
              BY ttImpressao.cod-nivel
              BY ttImpressao.cod-coluna
              BY ttImpressao.cod-item
              BY ttImpressao.cod-embalagem:

            IF ttImpressao.cod-item <> "" THEN DO:
                FIND FIRST wm-item
                     WHERE wm-item.cod-item = ttImpressao.cod-item NO-LOCK NO-ERROR.
    
                IF AVAIL wm-item THEN
                    ASSIGN ttImpressao.desc-item = wm-item.des-item.
            END.

            ASSIGN i-cont   = i-cont + 1.

            DISP STREAM str-rp
                ttImpressao.cod-bloco          @ wm-box.cod-bloco
                ttImpressao.cod-rua            @ wm-box.cod-rua
                ttImpressao.cod-nivel          @ wm-box.cod-nivel
                ttImpressao.cod-coluna         @ wm-box.cod-coluna
                ttImpressao.ind-posicao-box    @ c-ind-pos-box
                ttImpressao.cod-item           @ wm-box-saldo.cod-item
                ttImpressao.desc-item          @ c-descricao
                ttImpressao.cod-embalagem      @ wm-box-saldo.cod-embalagem
                ttImpressao.qtd-item-bloq      @ wm-box-saldo.qtd-item-bloq
                ttImpressao.cod-usuario
                ttImpressao.dt-acao    
                ttImpressao.hr-acao    
                ttImpressao.motivo             @ c-motivo
                WITH FRAME f-detalhe-item.
            DOWN STREAM str-rp WITH FRAME f-detalhe-item.            
        END.                              
    END.
END CASE.

{ utp/ut-liter.i "Total_de_Endere‡os" * }

ASSIGN c-tot-enderecos = TRIM(RETURN-VALUE) +  ": " .

PUT STREAM str-rp SKIP(1)
    c-tot-enderecos FORMAT "x(20)" 
    i-cont. 

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
