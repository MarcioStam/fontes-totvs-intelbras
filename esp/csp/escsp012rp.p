/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*:T*******************************************************************************
**
**  Objetivo.: Reporte GGF massivo 
**  Cria‡Æo..: Maicon Correa
**
*******************************************************************************/
{include/i-prgvrs.i ESCSP012RP 2.00.00.000}

/* Include Definitions ---                                              */
{esp/csp/escsp012.i} /* Defini‡Æo das Temp-Tables tt-param, tt-digita e tt-raw-digita */
{include/i-rpvar.i} 

{cpp/cpapi005.i}
{cdp/cd0666.i}
{cdp/cdcfgman.i}
{cdp/cdcfgmat.i}

&if "{&bf_mat_versao_ems}" >= "2.062" &then

    def temp-table tt-utiliza
        field cd-equipto      like equipto.cd-equipto
        field vl-contador     as dec format ">>>,>>>,>>>,>>9.9999" 
        field contador        like ut-equipto.contador         init 0 
        field vl-corrigido    as dec format ">>>,>>>,>>>,>>9.9999"  init 0 
        field de-utiliza      as dec format ">>>,>>>,>>>,>>9.9999"  init 0
        field da-utiliza      as date format 99/99/9999
        field cd-tecnico      like tecn-mi.cd-tecnico
        field l-propagou      as logical    
        field c-motivo        as char format "x(35)"
        index codigo is primary unique cd-equipto.
    
    def var l-pede-tecnico   as logical init yes.
    def var c-pede-tecnico   like tecn-mi.cd-tecnico.
    def var l-prod-mi        as log format "Producao/Manuten‡Æo Industrial" no-undo.
    
    {method/dbotterr.i} /* rowerrors */

&endif

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Número" column-label "Número"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistência".

def new global shared var h-bomn161 as handle no-undo.



/* Variable Definitions ---                                             */
DEFINE VARIABLE h-acomp         AS HANDLE                            NO-UNDO.
DEFINE VARIABLE c-linha         AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE da-iniper       AS DATE        FORMAT "99/99/9999"   NO-UNDO.
DEFINE VARIABLE da-fimper       AS DATE        FORMAT "99/99/9999"   NO-UNDO.
DEFINE VARIABLE i-per-corrente  AS INT         FORMAT "99"           NO-UNDO.
DEFINE VARIABLE i-ano-corrente  AS INT         FORMAT "9999"         NO-UNDO.
DEFINE VARIABLE da-iniper-fech  AS DATE        FORMAT "99/99/9999"   NO-UNDO.
DEFINE VARIABLE da-fimper-fech  AS DATE        FORMAT "99/99/9999"   NO-UNDO.
DEFINE VARIABLE c-per           LIKE ext-per-custo.periodo           NO-UNDO.
DEFINE VARIABLE h_api_ccusto    AS HANDLE      NO-UNDO.
DEFINE VARIABLE v_des_ccusto    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dt-trans        AS DATE        NO-UNDO.
def var p-cd-tecnico-ant as char init ""  no-undo.

def var i-empresa-prin as CHAR no-undo.
DEF VAR i-aux          AS INTEGER NO-UNDO.
DEFINE VARIABLE c-mensagem AS CHARACTER   FORMAT "X(100)" NO-UNDO.
DEFINE VARIABLE i-estado-anterior AS INTEGER     NO-UNDO.

DEFINE STREAM s-imp.

/* Temp-Table Definitions ---                                           */
DEFINE TEMP-TABLE tt-import
    FIELD nr-ord-produ  AS INT
    FIELD tempo         AS DEC
    FIELD gm-codigo     AS CHAR
    FIELD cc-codigo     AS CHAR.

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

/* Transfer Definitions ---                                             */
CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param NO-ERROR.

/* **********************       Main Block      *********************** */

/* Posicionando Tabelas ---                                             */
FIND FIRST tt-param NO-ERROR.
FIND FIRST param-cs     NO-LOCK NO-ERROR.
FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST mgcad.empresa
    WHERE mgcad.empresa.ep-codigo = param-global.empresa-pri NO-LOCK NO-ERROR.

assign i-empresa-prin = param-global.empresa-prin.

/* Inicializando Vari veis ---                                          */
ASSIGN c-programa     = "ESCSP012RP":U
       c-versao	      = "2.00":U
       c-revisao	  = ".00.000":U
       c-empresa	  = IF AVAILABLE mgcad.empresa THEN mgcad.empresa.razao-social ELSE "":U
       c-sistema	  = "Espec¡ficos Intelbras":U
       c-titulo-relat = "Reporte GGF Massivo":U.

FORM SKIP(1)
    "PAR¶METRO":U TO 20 SKIP(1)
    tt-param.arq-entrada FORMAT "x(80)":U LABEL "Arquivo de Entrada":U COLON 37 SKIP(1)
    SKIP(1)
    "ARQUIVO":U       TO 20 SKIP(1)
    tt-param.arquivo FORMAT "x(80)":U LABEL "Destino":U            COLON 37 SKIP
    tt-param.usuario     FORMAT "x(12)":U LABEL "Usu rio":U            COLON 37 SKIP(1)
    WITH STREAM-IO SIDE-LABELS NO-ATTR-SPACE NO-BOX WIDTH 132 FRAME f-impressao.

FORM
    tt-import.nr-ord-produ  COLUMN-LABEL "Ordem"
    tt-import.tempo         COLUMN-LABEL "Tempo"
    tt-import.gm-codigo     COLUMN-LABEL "GM"
    c-mensagem              COLUMN-LABEL "Mensagem de Erro"
    WITH STREAM-IO NO-ATTR-SPACE NO-BOX WIDTH 132 DOWN FRAME f-erros.


FIND FIRST param-estoq NO-LOCK NO-ERROR.


{include/i-rpout.i &STREAM="stream str-rp" &TOFILE=tt-param.arquivo}
{include/i-rpcab.i &STREAM="str-rp"}

VIEW STREAM str-rp FRAME f-cabec.
VIEW STREAM str-rp FRAME f-rodape.


/* Iniciar mensagem de acompanhamento */
IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT "":U).

INPUT STREAM s-imp FROM VALUE(tt-param.arq-entrada).

REPEAT ON STOP UNDO, LEAVE:

    IMPORT STREAM s-imp UNFORMATTED c-linha.

    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT TRIM(ENTRY(1, c-linha, ";":U))).

    FOR FIRST ord-prod
        WHERE ord-prod.nr-ord-produ = int(TRIM(ENTRY(1, c-linha, ";":U))) NO-LOCK:

        CREATE tt-import.
        ASSIGN tt-import.nr-ord-produ = int(TRIM(ENTRY(1, c-linha, ";":U)))
               tt-import.tempo        = DEC(trim(ENTRY(2, c-linha, ";":U)))
               tt-import.gm-codigo    = TRIM(ENTRY(3, c-linha, ";":U))
               tt-import.cc-codigo    = "".

        /**/

        find first gm-estab
			where gm-estab.gm-codigo   = tt-import.gm-codigo
			and   gm-estab.cod-estabel = ord-prod.cod-estabel no-lock no-error.
			
		if not avail gm-estab then
			find first gm-estab
				where gm-estab.gm-codigo = tt-import.gm-codigo
				and   gm-estab.cod-estabel = "*" no-lock no-error.
				
		if avail gm-estab THEN
            ASSIGN tt-import.cc-codigo = gm-estab.cc-codigo.

    END.

END.

INPUT STREAM s-imp CLOSE.

DO ON ERROR UNDO, LEAVE
   ON STOP  UNDO, LEAVE:

    ASSIGN dt-trans = tt-param.data-movto /*DATE(MONTH(TODAY), 1, YEAR(TODAY)) - 1*/.

    blk-main:
    FOR EACH tt-import NO-LOCK:

        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT "Atualizando Ordem: " + string(tt-import.nr-ord-produ)).

        FIND FIRST ord-prod 
            WHERE ord-prod.nr-ord-produ = tt-import.nr-ord-produ NO-LOCK NO-ERROR.

        IF AVAIL ord-prod THEN DO:

            /***/
            /***/
            
            if tt-import.tempo <= 0 then do:

                run utp/ut-msgs.p (input "msg",
                                   input 4511,
                                   input "").

                ASSIGN c-mensagem = RETURN-VALUE.

                DISP STREAM str-rp 
                    tt-import.nr-ord-produ
                    tt-import.tempo
                    tt-import.gm-codigo
                    c-mensagem
                    WITH FRAME f-erros.
                DOWN WITH FRAME f-erros.

                NEXT blk-main.

            end.
        
            /*
            run get-attribute in this-procedure ('adm-new-record').
            if return-value = "no" then do:
               if date(fi-dt-trans:screen-value in frame {&FRAME-NAME})  < movto-ggf.dt-trans then do:
                  {include/i-vldprg.i}
                  run utp/ut-msgs.p (input "show",
                                     input 27328,
                                     input "").
                  apply "entry" to fi-dt-trans.
                  return "ADM-ERROR":U.
               end.
        
               assign de-horas = 0.
               for each b-movto-ggf
                   where b-movto-ggf.nr-ord-produ = movto-ggf.nr-ord-produ 
                   and   b-movto-ggf.op-codigo    = movto-ggf.op-codigo
                   and   b-movto-ggf.cod-roteiro  = movto-ggf.cod-roteiro
                   and   b-movto-ggf.cd-tecnico   = movto-ggf.cd-tecnico
                   and   b-movto-ggf.cd-tarefa    = movto-ggf.cd-tarefa
                   and   b-movto-ggf.gm-codigo    = movto-ggf.gm-codigo
                   and   b-movto-ggf.cc-codigo    = movto-ggf.cc-codigo no-lock:
                   if b-movto-ggf.tipo-trans = 1 then
                      assign de-horas = de-horas + b-movto-ggf.horas-report.
                   else
                      assign de-horas = de-horas - b-movto-ggf.horas-report.
               end.
        
               if input tt-import.tempo > de-horas then do:
                  {include/i-vldprg.i}
                  run utp/ut-msgs.p (input "show",
                                     input 4631,
                                     input "").
                  apply "entry" to i-cent-ini.
                  return "ADM-ERROR":U.
               end.
        
            end.   
            */

            /***/
            /***/

            find item 
                where item.it-codigo = ord-prod.it-codigo  no-lock no-error.

            if not avail(item) then do:

                {utp/ut-table.i mgind item 1}
                run utp/ut-msgs.p (input "msg" ,
                                   input 56 ,
                                   input return-value).
                
                ASSIGN c-mensagem = RETURN-VALUE.

                DISP STREAM str-rp
                     tt-import.nr-ord-produ
                     tt-import.tempo
                     tt-import.gm-codigo
                     c-mensagem
                    WITH FRAME f-erros.
                DOWN WITH FRAME f-erros.

                NEXT blk-main.

            end. 
         
            

            if tt-import.gm-codigo <> "" then do:   

                find grup-maquina where grup-maquina.gm-codigo = tt-import.gm-codigo no-lock no-error.

                if not avail(grup-maquina) then do:
                    /*{include/i-vldprg.i}*/
                    {utp/ut-table.i mgind grup-maquina 1}
                    run utp/ut-msgs.p (input "msg",
                                       input 56    ,   
                                       input return-value).

                    ASSIGN c-mensagem = RETURN-VALUE.

                    DISP STREAM str-rp
                         tt-import.nr-ord-produ
                         tt-import.tempo
                         tt-import.gm-codigo
                         c-mensagem
                        WITH FRAME f-erros.
                    DOWN WITH FRAME f-erros.
    
                    NEXT blk-main.

                end.
            end.
            
            if tt-import.cc-codigo <> "" then do:     

                if not valid-handle(h_api_ccusto) then 
                    run prgint/utb/utb742za.py persistent set h_api_ccusto.

                run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                           INPUT "",
                                                           INPUT tt-import.cc-codigo,
                                                           INPUT today,
                                                           OUTPUT v_des_ccusto,
                                                           OUTPUT TABLE tt_log_erro). 

                IF CAN-FIND(FIRST tt_log_erro NO-LOCK) THEN DO:

                    {utp/ut-table.i mgind centro-custo 1}
                    run utp/ut-msgs.p (input "msg"      ,
                                       input 56          ,   
                                       input return-value).

                    ASSIGN c-mensagem = RETURN-VALUE.

                    DISP STREAM str-rp
                         tt-import.nr-ord-produ
                         tt-import.tempo
                         tt-import.gm-codigo
                         c-mensagem
                        WITH FRAME f-erros.
                    DOWN WITH FRAME f-erros.
    
                    NEXT blk-main.

                end.   

            end.
            
            for each tt-movto-ggf:
                delete tt-movto-ggf.
            end.

            FOR EACH tt-erro:
                DELETE tt-erro.
            END.
         
            create tt-movto-ggf.
            
            /*run get-attribute ('adm-new-record').  */

            assign tt-movto-ggf.cod-versao-integracao = 1                                   
                   tt-movto-ggf.nr-ord-produ          = ord-prod.nr-ord-produ               
                   tt-movto-ggf.cod-estabel           = ord-prod.cod-estabel                
                   tt-movto-ggf.nro-docto             = ""                                  
                   tt-movto-ggf.serie-docto           = ""                                  
                   tt-movto-ggf.qt-reportada          = 0                                   
                   tt-movto-ggf.it-codigo             = ord-prod.it-codigo                  
                   tt-movto-ggf.op-codigo             = 0                                   
                   tt-movto-ggf.cc-codigo             = tt-import.cc-codigo                 
                   tt-movto-ggf.cod-roteiro           = ""                                  
                   tt-movto-ggf.gm-codigo             = tt-import.gm-codigo                 
                   tt-movto-ggf.tipo-trans            = 1 /* Reporte */                     
                   tt-movto-ggf.cd-tecnico            = ""                                  
                   tt-movto-ggf.cd-tarefa             = 0                                   
                   tt-movto-ggf.rw-mov-orig           = ?                                   
                   tt-movto-ggf.op-seq                = 0                                   
                   tt-movto-ggf.dt-retorno            = ?.                                  

            &IF DEFINED (bf_man_204) &THEN
                assign tt-movto-ggf.num-id-movto-ggf = next-value(seq-movto-ggf,mgind) .
            &ENDIF 
        
            assign tt-movto-ggf.dt-trans        = dt-trans
                   tt-movto-ggf.horas-report    = tt-import.tempo
                   tt-movto-ggf.referencia      = ""
                   tt-movto-ggf.matr-func       = int("")
                   tt-movto-ggf.cd-turno        = ""
                   tt-movto-ggf.lg-recalc-horas = yes.

            ASSIGN i-estado-anterior = 0.

            /* Terminada */
            IF ord-prod.estado = 8 THEN DO:
                
                FIND CURRENT ord-prod EXCLUSIVE-LOCK.

                ASSIGN ord-prod.estado = 7
                       i-estado-anterior = 8.

                FIND CURRENT ord-prod NO-LOCK.

            END.
         
            run cpp/cpapi005.p (input-output table tt-movto-ggf,
                                input-output table tt-erro,
                                input        yes).

            IF i-estado-anterior = 8 THEN DO:

                FIND CURRENT ord-prod EXCLUSIVE-LOCK.
                
                ASSIGN ord-prod.estado = 8.

                FIND CURRENT ord-prod NO-LOCK.

            END.
         
            find first tt-erro no-lock no-error.
            if avail tt-erro then do:

                /*run cdp/cd0666.w (input table tt-erro).
                undo, return "adm-error".*/

                FOR EACH tt-erro:

                    ASSIGN c-mensagem = "Retorno da API: " + tt-erro.mensagem.

                    DISP STREAM str-rp
                         tt-import.nr-ord-produ
                         tt-import.tempo
                         tt-import.gm-codigo
                         c-mensagem
                        WITH FRAME f-erros.
                    DOWN WITH FRAME f-erros.
    
                    NEXT blk-main.

                END.

            end.
        
            &if "{&bf_mat_versao_ems}" >= "2.062" &then
                run pi-utilizacao.

                IF RETURN-VALUE = "NOK" THEN
                    NEXT blk-main.
            &endif

            /***/
            /***/
            
        END.
    END.
END.


/***/


PAGE STREAM str-rp.

DISPLAY STREAM str-rp
    tt-param.arq-entrada
    tt-param.arquivo
    tt-param.usuario
    WITH FRAME f-impressao.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-finalizar IN h-acomp.

{include/i-rpclo.i &STREAM="stream str-rp"}

IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp.

RETURN "OK":U.



PROCEDURE pi-utilizacao:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     
    if valid-handle(h-bomn161) then do:

        run emptyRowErrors in h-bomn161.
        run getTTUtiliza in h-bomn161(output table tt-utiliza).

        if can-find(first tt-utiliza) then do:

            for each tt-utiliza no-lock:
                if p-cd-tecnico-ant <> tt-utiliza.cd-tecnico then do:

                    run verificaTecnicoMI in h-bomn161 (input tt-utiliza.cd-tecnico).

                    assign p-cd-tecnico-ant = tt-utiliza.cd-tecnico.

                end.
            end.

            run getRowErrors in h-bomn161 (output table RowErrors).

            find first rowErrors no-error.
            if avail rowErrors THEN DO:

                run utp/ut-msgs.p (input "show":u,
                                   input 30132,
                                   input "").

                ASSIGN c-mensagem = RETURN-VALUE.

                DISP STREAM str-rp
                     tt-import.nr-ord-produ
                     tt-import.tempo
                     tt-import.gm-codigo
                     c-mensagem
                    WITH FRAME f-erros.
                DOWN WITH FRAME f-erros.

                RETURN "NOK":U.

            END.
            else
                run PropagaUtilizacaoEquipto in h-bomn161 (input table tt-utiliza, 
                                                           input 1).

        end.

        if valid-handle(h-bomn161) then
            delete procedure h-bomn161.

    end.

    RETURN "OK":U.

END PROCEDURE.
