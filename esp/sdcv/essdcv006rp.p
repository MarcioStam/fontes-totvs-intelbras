/******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i essdcv006rp 1.00.00.000}
/******************************************************************************
** Programa: esp/sdcv/essdcv006rp.p
** Data....: Abril/2014.
** Autor...: SENSUS Tecnologia
** Objetivo: Listagem Controladoria - Tabelas Centro Custo, Conta e 
**           Plano Contas integrados ao OBC.
*******************************************************************************/

{include/i-rpvar.i}    
{utp/ut-glob.i}

define variable log-primeiro   as logical   no-undo.
define variable ccusto-aux     as character no-undo.
define variable cta_ctbl-aux   as character no-undo.
define variable ddat-integ-aux as date      no-undo.
define variable chra-integ-aux as character no-undo.
define variable h-acomp        as handle    no-undo.

DEFINE STREAM st-csv.
DEFINE VARIABLE c-arquivo AS CHARACTER NO-UNDO.

run utp/ut-acomp.p persistent set h-acomp.                            

{esp/sdcv/essdcv006tt.i}

define buffer bfint-integrado-obc for int-integrado-obc.

def temp-table tt-raw-digita
    field raw-digita as raw.

def input parameter  raw-param as raw no-undo.
def input parameter  table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

find emscad.empresa no-lock where
     empresa.cod_empresa = V_Cod_Empres_Usuar no-error.

assign c-empresa      = empresa.nom_razao_social
       c-sistema      = "ESP":U
       c-titulo-relat = "Tabelas Integradas com SDCV":U.

{include/i-rpcab.i}
/*{include/i-rpout.i}*/
{include/i-rpout.i &pagesize="80"}
view frame f-cabec.

run pi-inicializar in h-acomp (input c-sistema).

ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "essdcv006.csv".

CASE tt-param.tp-imprime:
    WHEN 1 /* Centro Custo*/ THEN DO:
        OUTPUT STREAM st-csv TO VALUE(c-arquivo) NO-CONVERT.

        put STREAM st-csv UNFORMATTED "CENTRO CUSTO;DESCRI€ÇO;DATA;HORA;USUµRIO;NOME;":U.
        
        IF  tt-param.plano-conta
        THEN put STREAM st-csv UNFORMATTED "UN.NEG.;ESTAB.;CONTA CONTµBIL;DESCRI€ÇO CONTA":U SKIP.
        ELSE PUT STREAM st-csv SKIP.
        
        blk_one:
        for each  int-integrado-obc no-lock
            where int-integrado-obc.cod-tabela                   = "CENTRO_CUSTO":U
            and   entry(2, int-integrado-obc.chave-tabela, ";") >= tt-param.ccusto-inicial
            and   entry(2, int-integrado-obc.chave-tabela, ";") <= tt-param.ccusto-final,
            first emscad.ccusto no-lock
            where emscad.ccusto.cod_ccusto = entry(2, int-integrado-obc.chave-tabela, ";"),
            first usuar_mestre no-lock
            where usuar_mestre.cod_usuario = int-integrado-obc.cod-usuario
            BREAK BY entry(2, int-integrado-obc.chave-tabela, ";")
                  BY int-integrado-obc.dat-integrado
                  BY int-integrado-obc.hra-integrado:

            run pi-acompanhar in h-acomp (input "Centro Custo Integrados: " + STRING(int-integrado-obc.chave-tabela)).

            IF NOT tt-param.mostra-inativos AND int-integrado-obc.idi-situacao = 2 /* Inativo */ THEN NEXT blk_one.
            
            if  ccusto-aux     <> entry(2, int-integrado-obc.chave-tabela, ";")
            or  ddat-integ-aux <> int-integrado-obc.dat-integrado              
            or  chra-integ-aux <> int-integrado-obc.hra-integrado then do:     
            
                put STREAM st-csv unformatted 
                    entry(2, int-integrado-obc.chave-tabela, ";") FORMAT "x(05)":U      ";"
                    emscad.ccusto.des_tit_ctbl                      FORMAT "x(40)":U      ";"
                    int-integrado-obc.dat-integrado               FORMAT "99/99/9999":U ";"
                    int-integrado-obc.hra-integrado                                     ";"
                    int-integrado-obc.cod-usuario                 FORMAT "x(20)":U      ";"
                    usuar_mestre.nom_usuario                      FORMAT "x(38)":U      ";".
                
                IF  tt-param.plano-conta THEN DO:
                    blk_two:
                    FOR EACH  bfint-integrado-obc 
                        WHERE bfint-integrado-obc.cod-tabela = "PLANO_CONTA":U
                        AND   ENTRY(2, bfint-integrado-obc.chave-tabela, ";") = emscad.ccusto.cod_ccusto,
                        FIRST cta_ctbl NO-LOCK
                        WHERE cta_ctbl.cod_cta_ctbl = ENTRY(4, bfint-integrado-obc.chave-tabela, ";")
                        BREAK BY ENTRY(2, bfint-integrado-obc.chave-tabela, ";"):
                
                        run pi-acompanhar in h-acomp (input "Planos Conta Integrados: " + STRING(int-integrado-obc.chave-tabela)).
                
                        IF NOT tt-param.mostra-inativos AND bfint-integrado-obc.idi-situacao = 2 /* Inativo */ THEN NEXT blk_two.
                
                        if  not log-primeiro 
                        then assign log-primeiro = true.
                        else PUT STREAM st-csv UNFORMATTED ";;;;;;":U.
                        
                        put STREAM st-csv unformatted
                            ENTRY(1, bfint-integrado-obc.chave-tabela, ";") FORMAT "X(03)":U ";"
                            ENTRY(3, bfint-integrado-obc.chave-tabela, ";") FORMAT "X(03)":U ";"
                            ENTRY(4, bfint-integrado-obc.chave-tabela, ";") FORMAT "X(08)":U ";"
                            cta_ctbl.des_tit_ctbl                      FORMAT "X(40)":U ";" SKIP.
                    
                    END. /* FOR EACH  bfint-integrado-obc */
                END. /* IF  tt-param.plano-conta THEN DO: */
                ELSE PUT STREAM st-csv SKIP.
                
                ASSIGN ccusto-aux     = entry(2, int-integrado-obc.chave-tabela, ";")
                       ddat-integ-aux = int-integrado-obc.dat-integrado      
                       chra-integ-aux = int-integrado-obc.hra-integrado
                       log-primeiro   = false.
                
            END. /* IF  FIRST-OF */
        end. /* for each int-integrado-obc no-lock: */
        
        OUTPUT STREAM st-csv CLOSE.
    END.
    WHEN 2 /* Conta Cont bil*/ THEN DO:
        OUTPUT STREAM st-csv TO VALUE(c-arquivo) NO-CONVERT.
        
        put STREAM st-csv UNFORMATTED "CONTA CONTµBIL;DESCRI€ÇO;DATA;HORA;USUµRIO;NOME;":U.

        IF  tt-param.plano-conta 
        THEN PUT STREAM st-csv UNFORMATTED "UN.NEG.;ESTAB.;CENTRO CUSTO;DESCRI€ÇO CCUSTO":U SKIP.
        ELSE PUT STREAM st-csv SKIP.

        blk_one:
        for each  int-integrado-obc no-lock
            where int-integrado-obc.cod-tabela    = "CONTA_CONTABIL":U
            and   int-integrado-obc.chave-tabela >= tt-param.ctactbl-inicial
            and   int-integrado-obc.chave-tabela <= tt-param.ctactbl-final,
            first cta_ctbl no-lock
            where cta_ctbl.cod_cta_ctbl = int-integrado-obc.chave-tabela,
            first usuar_mestre no-lock
            where usuar_mestre.cod_usuario = int-integrado-obc.cod-usuario
            BREAK BY int-integrado-obc.chave-tabela
                  BY int-integrado-obc.dat-integrado
                  BY int-integrado-obc.hra-integrado:

            run pi-acompanhar in h-acomp (input "Ctas Cont beis Integradas: " + STRING(int-integrado-obc.chave-tabela)).

            IF NOT tt-param.mostra-inativos AND int-integrado-obc.idi-situacao = 2 /* Inativo */ THEN NEXT blk_one.
            
            if  cta_ctbl-aux   <> int-integrado-obc.chave-tabela
            or  ddat-integ-aux <> int-integrado-obc.dat-integrado              
            or  chra-integ-aux <> int-integrado-obc.hra-integrado then do:     

                put STREAM st-csv unformatted 
                    int-integrado-obc.chave-tabela  FORMAT "x(08)":U      ";"
                    cta_ctbl.des_tit_ctbl      FORMAT "x(40)":U      ";"
                    int-integrado-obc.dat-integrado FORMAT "99/99/9999":U ";"
                    int-integrado-obc.hra-integrado                       ";"
                    int-integrado-obc.cod-usuario   FORMAT "x(20)":U      ";"
                    usuar_mestre.nom_usuario        FORMAT "x(30)":U      ";".
    
                IF  tt-param.plano-conta THEN DO:
                    blk_two:
                    FOR EACH  bfint-integrado-obc 
                        WHERE bfint-integrado-obc.cod-tabela = "PLANO_CONTA":U
                        AND   ENTRY(4, bfint-integrado-obc.chave-tabela, ";") = cta_ctbl.cod_cta_ctbl,
                        FIRST emscad.ccusto NO-LOCK
                        WHERE emscad.ccusto.cod_ccusto = ENTRY(2, bfint-integrado-obc.chave-tabela, ";")
                        BREAK BY ENTRY(4, bfint-integrado-obc.chave-tabela, ";"):
    
                        run pi-acompanhar in h-acomp (input "Planos Conta Integrados: " + STRING(int-integrado-obc.chave-tabela)).
    
                        IF NOT tt-param.mostra-inativos AND bfint-integrado-obc.idi-situacao = 2 /* Inativo */ THEN NEXT blk_two.
    
                        if  not log-primeiro 
                        then ASSIGN log-primeiro = TRUE.
                        ELSE PUT STREAM st-csv UNFORMATTED ";;;;;;":U.
                        
                        put STREAM st-csv unformatted
                            ENTRY(1, bfint-integrado-obc.chave-tabela, ";") FORMAT "X(03)":U ";"
                            ENTRY(3, bfint-integrado-obc.chave-tabela, ";") FORMAT "X(03)":U ";"
                            ENTRY(2, bfint-integrado-obc.chave-tabela, ";") FORMAT "X(08)":U ";"
                            cta_ctbl.des_tit_ctbl                      FORMAT "X(40)":U ";" SKIP.
                    END. /* FOR EACH  bfint-integrado-obc */
                END. /* IF  tt-param.plano-conta THEN DO: */
                ELSE PUT STREAM st-csv SKIP.

                ASSIGN cta_ctbl-aux   = int-integrado-obc.chave-tabela
                       ddat-integ-aux = int-integrado-obc.dat-integrado      
                       chra-integ-aux = int-integrado-obc.hra-integrado
                       log-primeiro   = false.

            END. /* IF  FIRST-OF */
        end. /* for each int-integrado-obc no-lock: */
        
        OUTPUT STREAM st-csv CLOSE.
    END.
END. /* CASE tt-param.tp-imprime: */

view frame f-rodape.

/*---[ P gina de Parƒmetros ]------------------------------------------------------------------------*/
/*PAGE.*/
FOR FIRST tt-param:

    PUT SKIP(1) "[ PAR¶METROS ]" SKIP(1).

    IF  tt-param.tp-imprime = 1 /* Centro Custo */ 
    THEN PUT "[ X ] Centro Custo     Inicial: " AT 05.
    ELSE PUT "[   ] Centro Custo     Inicial: " AT 05.

    PUT UNFORMATTED
    tt-param.ccusto-inicial FORMAT "x(5)":U AT 37 
    "|< >|" AT 46
    tt-param.ccusto-final   FORMAT "x(5)":U AT 52 SKIP.

    IF  tt-param.tp-imprime = 2 /* Conta Cont bil */
    THEN PUT "[ X ] Conta Cont bil   Inicial: " AT 05.
    ELSE PUT "[   ] Conta Cont bil   Inicial: " AT 05.

    PUT UNFORMATTED
    tt-param.ctactbl-inicial FORMAT "X(8)":U AT 37 
    "|< >|" AT 46
    tt-param.ctactbl-final   FORMAT "x(8)":U AT 52 SKIP.
    
    PUT "-------------------------------------------------------" AT 05 SKIP.
    IF  tt-param.plano-conta
    THEN PUT "[ X ] Apresentar Plano Conta? " at 05 SKIP.
    ELSE PUT "[   ] Apresentar Plano Conta? " at 05 SKIP.

    IF  tt-param.mostra-inativos
    THEN PUT "[ X ] Mostrar Inativos?" at 05 SKIP.
    ELSE PUT "[   ] Mostrar Inativos?" at 05 SKIP.

    PUT UNFORMATTED SKIP(1) "Planilha gerada no caminho: " + c-arquivo AT 05 SKIP.
END. /* FOR FIRST tt-param: */

run pi-finalizar in h-acomp.

{include/i-rpclo.i}
RETURN "OK".
