/*****************************************************************************
**     Programa.........: esp/ftp/ESFTP115rp.p
**     Descricao .......: Integra‡Æo tempo producao itens x centro custo com Planning
**     Versao...........: 1.00.000
**     Autor............: Hoepers
**     Criado...........: 28/01/2016
**     Desc. Atualiza‡Æo: 
**     Autor............: 
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESFTP115 2.04.00.001}

{esp/ftp/esftp115.i}
{utp/ut-glob.i}
{include/i-rpvar.i}

DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.
                                  
DEFINE VARIABLE h-acomp        AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-des-un-med   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-des-unid-neg AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-des-estabel  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-tipo-item    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-compr-fabric AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-des-ccusto   AS CHARACTER   NO-UNDO.

DEF TEMP-TABLE tt-esforco NO-UNDO
    FIELD cc-codigo LIKE gm-estab.cc-codigo
    FIELD de-tempo-homem    AS DEC DECIMALS 6
    FIELD de-tempo-maq      AS DEC DECIMALS 6.

DEF TEMP-TABLE tt-esforco-compras NO-UNDO LIKE tt-esforco.

DEF STREAM str-producao.
DEF STREAM str-compras.
DEF STREAM str-ficha.


CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

{include/i-rpcab.i}
{include/i-rpout.i &pagesize="0"}

FOR FIRST param-global NO-LOCK. END.
FOR FIRST empresa NO-LOCK
    WHERE empresa.ep-codigo = param-global.empresa-pri: END.

assign c-sistema      = "Espec¡ficos Intelbras"
       c-titulo-relat = "Integra‡Æo tempo producao itens x centro custo com Planning"
       c-empresa      = if avail empresa then empresa.razao-social else ''
       c-programa     = "ESFTP115"
       c-versao       = "2.04"
       c-revisao      = "001".

run utp/ut-acomp.p persistent set h-acomp.  
run pi-inicializar in h-acomp (input "Buscando valores...").
run pi-acompanhar in h-acomp (input "Buscando valores...").


RUN pi-gera-arquivos-integracao.

run pi-finalizar in h-acomp.

RETURN "OK".


PROCEDURE pi-gera-arquivos-integracao:

    DEFINE VARIABLE c-dir-origem     AS CHARACTER   NO-UNDO.

    ASSIGN c-dir-origem = "".

    RUN pi-seta-titulo IN h-acomp (INPUT "Validando Diret¢rio Destino...") NO-ERROR.
    run pi-acompanhar  in h-acomp (input "Aguarde...").

    FOR FIRST ponto-programa NO-LOCK
        WHERE ponto-programa.nome-programa = "esftp115"
          AND ponto-programa.ponto         = 1,
        EACH conteudo-programa NO-LOCK
        WHERE conteudo-programa.cod-programa = ponto-programa.cod-programa:

        IF conteudo-programa.conteudo                    <> "" AND
           NUM-ENTRIES(conteudo-programa.conteudo, ";") > 1    THEN DO:

            /* Diret¢rio no sistema operacional WIN32 */
            IF OPSYS = "WIN32" THEN DO:
                IF ENTRY(1, conteudo-programa.conteudo, ";") = "SAIDAGESPLANWIN32" 
                THEN
                    ASSIGN c-dir-origem = ENTRY(2, conteudo-programa.conteudo, ";").

            END.
            /* Diret¢rio no sistema operacional UNIX */
            ELSE DO:
                IF ENTRY(1, conteudo-programa.conteudo, ";") = "SAIDAGESPLANUNIX" 
                THEN
                    ASSIGN c-dir-origem = ENTRY(2, conteudo-programa.conteudo, ";").
            END.
        END.
    END.


    IF  i-num-ped-exec-rpw <> 0
    THEN DO:
        IF  c-dir-origem = ""
        THEN DO:
            PUT UNFORMATTED "Diret¢rio UNIX nÆo encontrado no Conte£do do Ponto do Programa! (Nome Programa: esftp115, Ponto: 1)" SKIP.
            RETURN "NOK".
        END.
    END.
    ELSE DO:
        IF  c-dir-origem = ""
        THEN DO:
            PUT UNFORMATTED "Diret¢rio WINDOWS nÆo encontrado no Conte£do do Ponto do Programa! (Nome Programa: esftp115, Ponto: 1)" SKIP.
            RETURN "NOK".
        END.
    END.

    FILE-INFO:FILE-NAME = c-dir-origem.

    IF FILE-INFO:FULL-PATHNAME           = "" OR
       FILE-INFO:FULL-PATHNAME           = ?  OR
       INDEX(FILE-INFO:FILE-TYPE, "D")   = 0
    THEN DO:
        PUT UNFORMATTED "Diret¢rio " + c-dir-origem + " inv lido!" SKIP.
        RETURN "NOK".
    END.

    RUN pi-seta-titulo IN h-acomp (INPUT "Gerando Arquivos") NO-ERROR.
    RUN pi-acompanhar  in h-acomp (INPUT "Aguarde...").

    OUTPUT STREAM str-producao TO VALUE(c-dir-origem + "producao.csv") CONVERT TARGET "iso8859-1".
    OUTPUT STREAM str-compras  TO VALUE(c-dir-origem + "compras.csv")  CONVERT TARGET "iso8859-1".
    OUTPUT STREAM str-ficha    TO VALUE(c-dir-origem + "ficha.csv")    CONVERT TARGET "iso8859-1".
        
        EMPTY TEMP-TABLE tt-esforco-compras.
        
        bloco-item-estab:
        FOR EACH  int_item_integra_gesplan NO-LOCK
            WHERE int_item_integra_gesplan.cod-estabel = tt-param.c-estab
               OR tt-param.c-estab           = "*",
            FIRST item-uni-estab NO-LOCK
            WHERE item-uni-estab.it-codigo   = int_item_integra_gesplan.it-codigo
              AND item-uni-estab.cod-estabel = int_item_integra_gesplan.cod-estabel
            BREAK BY int_item_integra_gesplan.cod-estabel:
        
            IF  FIRST-OF(int_item_integra_gesplan.cod-estabel)
            THEN DO:
                ASSIGN c-des-estabel = "".
                FOR FIRST estabelec NO-LOCK
                    WHERE estabelec.cod-estabel = item-uni-estab.cod-estabel:
                    ASSIGN c-des-estabel = CAPS(estabelec.nome).
                END.
            END.
        
            FOR FIRST ITEM NO-LOCK 
                WHERE ITEM.it-codigo = item-uni-estab.it-codigo:

                RUN pi-acompanhar  in h-acomp (INPUT "Processando item: " + item-uni-estab.it-codigo).
            
                ASSIGN c-des-un-med   = ""
                       c-des-unid-neg = ""
                       c-tipo-item    = ""
                       c-tipo-item    = "ACABADO".
            
                FOR FIRST tab-unidade OF ITEM NO-LOCK:
                    ASSIGN c-des-un-med = CAPS(tab-unidade.descricao).
                END.
            
                FOR FIRST unid_negoc NO-LOCK
                    WHERE unid_negoc.cod_unid_negoc = item-uni-estab.cod-unid-negoc:
                    ASSIGN c-des-unid-neg = CAPS(unid_negoc.des_unid_negoc).
                END.
        
                IF  c-des-unid-neg = ""
                THEN DO:
                    FOR FIRST unid_negoc NO-LOCK
                        WHERE unid_negoc.cod_unid_negoc = item.cod-unid-negoc:
                        ASSIGN c-des-unid-neg = CAPS(unid_negoc.des_unid_negoc).
                    END.
                END.
        
                IF  c-des-unid-neg = ""
                THEN
                    NEXT bloco-item-estab.
        
                EMPTY TEMP-TABLE tt-esforco.
        
                /* Gerar Horas e Centro Custo Produtivo */
                RUN pi-esforco (INPUT ITEM.it-codigo).
        
                /* Gerar Estrutura do Item */
                RUN pi-estrutura (INPUT ITEM.it-codigo,
                                  INPUT 1).
        
                PUT STREAM str-producao UNFORMATTED "Real"                     ";"
                                                    c-des-un-med               ";"
                                                    item-uni-estab.cod-estabel ";"
                                                    c-tipo-item                ";"
                                                    c-des-unid-neg             ";"
                                                    c-des-estabel              ";"
                                                    c-tipo-item                ";"
                                                    c-des-unid-neg             ";"
                                                    CAPS(ITEM.it-codigo)       ";"
                                                    CAPS(ITEM.desc-item)       ";"
                                                    ";;;;;;;;;;;;"
                                                    c-tipo-item                ";"
                                                    c-des-unid-neg             SKIP.
        
                FOR EACH tt-esforco:
                    IF  tt-esforco.de-tempo-homem > 0
                    THEN
                        PUT STREAM str-ficha UNFORMATTED "2"                         ";"
                                                         item-uni-estab.cod-estabel  ";"
                                                         c-tipo-item                 ";"
                                                         c-des-unid-neg              ";"
                                                         ITEM.it-codigo              ";"
                                                         "3"                         ";"
                                                         "FIXO"                      ";"
                                                         "FIXO"                      ";"
                                                         "MOD"                       ";"
                                                         tt-esforco.cc-codigo "_MOD" ";" 
                                                         tt-esforco.de-tempo-homem   SKIP.
        
                    IF  tt-esforco.de-tempo-maq > 0
                    THEN
                        PUT STREAM str-ficha UNFORMATTED "2"                         ";"
                                                         item-uni-estab.cod-estabel  ";"
                                                         c-tipo-item                 ";"
                                                         c-des-unid-neg              ";"
                                                         ITEM.it-codigo              ";"
                                                         "3"                         ";"
                                                         "FIXO"                      ";"
                                                         "FIXO"                      ";"
                                                         "GGF"                       ";"
                                                         tt-esforco.cc-codigo "_GGF" ";" 
                                                         tt-esforco.de-tempo-maq     SKIP.
                END.
            
            END. /* FOR FIRST ITEM OF item-uni-estab NO-LOCK: */
        END. /* FOR EACH item-uni-estab NO-LOCK */
        
        
        FOR EACH tt-esforco-compras,
            FIRST emscad.ccusto NO-LOCK
            WHERE emscad.ccusto.cod_empresa      = i-ep-codigo-usuario
              AND emscad.ccusto.cod_plano_ccusto = "Padrao"
              AND emscad.ccusto.cod_ccusto       = tt-esforco-compras.cc-codigo:

            RUN pi-acompanhar  in h-acomp (INPUT "Gerando CCusto compras: " + tt-esforco-compras.cc-codigo).
        
            IF  tt-esforco-compras.de-tempo-homem > 0
            THEN DO:
                ASSIGN c-des-ccusto = emscad.ccusto.cod_ccusto + " - " + CAPS(emscad.ccusto.des_tit_ctbl).
        
                PUT STREAM str-compras  UNFORMATTED "Real"                        ";"
                                                    "HR"                          ";"
                                                    "FIXO"                        ";"
                                                    "FIXO"                        ";"
                                                    "MOD"                         ";"
                                                    "FIXO"                        ";"
                                                    "FIXO"                        ";"
                                                    "MOD"                         ";"
                                                    emscad.ccusto.cod_ccusto "_MOD" ";"
                                                    "MOD_" c-des-ccusto           ";"
                                                    ";;;;;;;;;;;;"
                                                    ";;;;;;;;;;;;"
                                                    "FIXO"                        ";"
                                                    "FIXO"                        SKIP.
            END.
        
            IF  tt-esforco-compras.de-tempo-maq > 0
            THEN DO:
                ASSIGN c-des-ccusto = emscad.ccusto.cod_ccusto + " - " + CAPS(emscad.ccusto.des_tit_ctbl).
        
                PUT STREAM str-compras  UNFORMATTED "Real"                        ";"
                                                    "HR"                          ";"
                                                    "FIXO"                        ";"
                                                    "FIXO"                        ";"
                                                    "GGF"                         ";"
                                                    "FIXO"                        ";"
                                                    "FIXO"                        ";"
                                                    "GGF"                         ";"
                                                    emscad.ccusto.cod_ccusto "_GGF" ";"
                                                    "GGF_" c-des-ccusto           ";"
                                                    ";;;;;;;;;;;;"
                                                    ";;;;;;;;;;;;"
                                                    "FIXO"                        ";"
                                                    "FIXO"                        SKIP.
            END.
        END. /* FOR EACH tt-esforco-compras */
        
    OUTPUT STREAM str-ficha    CLOSE.
    OUTPUT STREAM str-compras  CLOSE.
    OUTPUT STREAM str-producao CLOSE.

END PROCEDURE.


PROCEDURE pi-estrutura:

    DEF INPUT PARAM p-it-codigo AS CHAR NO-UNDO.
    DEF INPUT PARAM p-qtd       AS DEC  NO-UNDO.

    FOR EACH  estrutura NO-LOCK
        WHERE estrutura.it-codigo     = p-it-codigo
          AND estrutura.data-inicio  <= TODAY
          AND estrutura.data-termino >= TODAY:


        /* Gerar Horas e Centro Custo Produtivo */
        RUN pi-esforco (INPUT estrutura.es-codigo).

        RUN pi-estrutura (INPUT estrutura.es-codigo,
                          INPUT 1).
    END.
END PROCEDURE.


PROCEDURE pi-esforco:

    DEF INPUT PARAM p-it-codigo-esforco AS CHAR NO-UNDO.

    FOR EACH  operacao NO-LOCK
        WHERE operacao.it-codigo     = p-it-codigo-esforco
          AND operacao.data-inicio  <= TODAY
          AND operacao.data-termino >= TODAY,
        FIRST grup-maquina OF operacao,
        FIRST gm-estab     OF grup-maquina:

        FIND FIRST tt-esforco
            WHERE  tt-esforco.cc-codigo = gm-estab.cc-codigo NO-ERROR.

        IF  NOT AVAIL tt-esforco
        THEN DO:
            CREATE tt-esforco.
            ASSIGN tt-esforco.cc-codigo = gm-estab.cc-codigo.
        END.

        FIND FIRST tt-esforco-compras
            WHERE  tt-esforco-compras.cc-codigo = gm-estab.cc-codigo NO-ERROR.

        IF  NOT AVAIL tt-esforco-compras
        THEN DO:
            CREATE tt-esforco-compras.
            ASSIGN tt-esforco-compras.cc-codigo = gm-estab.cc-codigo.
        END.
        
        CASE operacao.un-med-tempo:
            WHEN(1)
                THEN ASSIGN tt-esforco.de-tempo-homem = tt-esforco.de-tempo-homem +  (operacao.tempo-homem  / operacao.nr-unidades)
                            tt-esforco.de-tempo-maq   = tt-esforco.de-tempo-maq   +  (operacao.tempo-maquin / operacao.nr-unidades).
            WHEN(2)
                THEN ASSIGN tt-esforco.de-tempo-homem = tt-esforco.de-tempo-homem + ((operacao.tempo-homem  / operacao.nr-unidades) / 60)
                            tt-esforco.de-tempo-maq   = tt-esforco.de-tempo-maq   + ((operacao.tempo-maquin / operacao.nr-unidades) / 60).
            WHEN(3)
                THEN ASSIGN tt-esforco.de-tempo-homem = tt-esforco.de-tempo-homem + ((operacao.tempo-homem  / operacao.nr-unidades) / 3600)
                            tt-esforco.de-tempo-maq   = tt-esforco.de-tempo-maq   + ((operacao.tempo-maquin / operacao.nr-unidades) / 3600).
            WHEN(4)
                THEN ASSIGN tt-esforco.de-tempo-homem = tt-esforco.de-tempo-homem + ((operacao.tempo-homem  / operacao.nr-unidades) * 24)
                            tt-esforco.de-tempo-maq   = tt-esforco.de-tempo-maq   + ((operacao.tempo-maquin / operacao.nr-unidades) * 24).
        END CASE.

        ASSIGN tt-esforco-compras.de-tempo-homem = tt-esforco-compras.de-tempo-homem + tt-esforco.de-tempo-homem
               tt-esforco-compras.de-tempo-maq   = tt-esforco-compras.de-tempo-maq   + tt-esforco.de-tempo-maq.
    END.

END PROCEDURE.


