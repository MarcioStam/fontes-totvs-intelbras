/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ES5502RP 2.00.00.000}  /*** 010000 ***/
{include/i_fnctrad.i}
/*******************************************************************************
**
**  Programa: ES5000RP.P
**
**  Autor...: DATASUL S.A.
**
**  Objetivo: Contabiliza‡Æo do Contas a Pagar
**
*******************************************************************************/
/* y2kready */


{utp/ut-glob.i}
{include/i-rpvar.i}

/* MINIFLEXIBILIZA€¶O */
{include/i_dbvers.i}
{include/i_dbtype.i}

{esp/es550200.i}

DEF VAR v_cont AS INT.

DEF VAR c-caminho  AS CHAR.
DEF VAR x-c-tabela AS CHAR.

DEF TEMP-TABLE tt-consulta-res
    FIELD cod_empresa        LIKE movto_real_orcto.cod_emp
    field cod_estab          like movto_real_orcto.cod_estab          
    field cod_cta_ctbl       like movto_real_orcto.cod_cta_ctbl       
    FIELD cod_exerc_ctbl     LIKE movto_real_orcto.cod_exerc_ctbl  
    FIELD num_period_ctbl    LIKE movto_real_orcto.num_period_ctbl
    field cod_ccusto         like movto_real_orcto.cod_ccusto         
    field cod_unid_negoc     like movto_real_orcto.cod_unid_negoc     
    field cod_proj_financ    like movto_real_orcto.cod_proj_financ
    FIELD valor_orc          LIKE movto_real_orcto.val_orcado_per
    FIELD valor_real         LIKE movto_real_orcto.val_realiz_per.

DEF TEMP-TABLE tt-usuar-cc
    FIELD cod_empresa     LIKE movto_real_orcto.cod_empresa
    FIELD cod_estab       LIKE movto_real_orcto.cod_estab
    FIELD cod_ccusto      AS CHAR COLUMN-LABEL "Centro Custos"
    FIELD cod_unid_negoc  AS CHAR COLUMN-LABEL "UN"
    FIELD des_ccusto      AS CHAR COLUMN-LABEL "Descri‡Æo" FORMAT "X(60)"
    INDEX cc IS PRIMARY  cod_ccusto.

DEF VAR vc-letras AS CHAR FORMAT "X(2)" EXTENT 260 INITIAL
["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
 "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
 "AA", "AB", "AC", "AD", "AE", "AF", "AG", "AH", "AI", "AJ", "AK", "AL", "AM",
 "AN", "AO", "AP", "AQ", "AR", "AS", "AT", "AU", "AV", "AW", "AX", "AY", "AZ",     
 "BA", "BB", "BC", "BD", "BE", "BF", "BG", "BH", "BI", "BJ", "BK", "BL", "BM",
 "BN", "BO", "BP", "BQ", "BR", "BS", "BT", "BU", "BV", "BW", "BX", "BY", "BZ",
 "CA", "CB", "CC", "CD", "CE", "CF", "CG", "CH", "CI", "CJ", "CK", "CL", "CM",
 "CN", "CO", "CP", "CQ", "CR", "CS", "CT", "CU", "CV", "CW", "CX", "CY", "CZ",
 "DA", "DB", "DC", "DD", "DE", "DF", "DG", "DH", "DI", "DJ", "DK", "DL", "DM",
 "DN", "DO", "DP", "DQ", "DR", "DS", "DT", "DU", "DV", "DW", "DX", "DY", "DZ",
 "EA", "EB", "EC", "ED", "EE", "EF", "EG", "EH", "EI", "EJ", "EK", "EL", "EM",
 "EN", "EO", "EP", "EQ", "ER", "ES", "ET", "EU", "EV", "EW", "EX", "EY", "EZ",
 "FA", "FB", "FC", "FD", "FE", "FF", "FG", "FH", "FI", "FJ", "FK", "FL", "FM",
 "FN", "FO", "FP", "FQ", "FR", "FS", "FT", "FU", "FV", "FW", "FX", "FY", "FZ",
 "GA", "GB", "GC", "GD", "GE", "GF", "GG", "GH", "GI", "GJ", "GK", "GL", "GM",
 "GN", "GO", "GP", "GQ", "GR", "GS", "GT", "GU", "GV", "GW", "GX", "GY", "GZ",
 "HA", "HB", "HC", "HD", "HE", "HF", "HG", "HH", "HI", "HJ", "HK", "HL", "HM",
 "HN", "HO", "HP", "HQ", "HR", "HS", "HT", "HU", "HV", "HW", "HX", "HY", "HZ",
 "IA", "IB", "IC", "ID", "IE", "IF", "IG", "IH", "II", "IJ", "IK", "IL", "IM",
 "IN", "IO", "IP", "IQ", "IR", "IS", "IT", "IU", "IV" ] NO-UNDO.

define temp-table tt-digita no-undo
    field cod-ccusto       as character format "x(5)"
    index id COD-CCUSTO.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def var h-acomp     as handle no-undo.
define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char format "x(35)"
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field classifica       as integer
    field desc-classifica  as char format "x(40)"
    field modelo-rtf       as char format "x(35)"
    field l-habilitaRtf    as LOG
    FIELD c-cod-estab-ini  AS CHAR
    FIELD c-cod-estab-fim  AS CHAR
    field c-exerc-ini    like movto_real_orcto.cod_exerc_ctbl 
    field c-exerc-fim    like movto_real_orcto.cod_exerc_ctbl 
    field nr-periodo-ini like movto_real_orcto.num_period_ctbl
    field nr-periodo-fim like movto_real_orcto.num_period_ctbl
    FIELD da-data-ini      AS DATE
    FIELD da-data-fim      AS DATE
    FIELD c-conta-ini      AS CHAR
    FIELD c-conta-fim      AS CHAR
    FIELD c-ccusto-ini     AS CHAR
    FIELD c-ccusto-fim     AS CHAR
    FIELD l-apb            AS LOG
    FIELD l-fgl            AS LOG
    FIELD l-acr            AS LOG
    FIELD l-cep            AS LOG
    FIELD l-ativo          AS LOG
    FIELD l-cmg            AS LOG.

define input parameter raw-param as raw no-undo.
define input parameter table for tt-raw-digita.

DEF VAR c-periodo AS CHAR.

DEFINE VARIABLE da-inicio AS DATE        NO-UNDO.
DEFINE VARIABLE da-fim    AS DATE        NO-UNDO.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

find first param-global no-lock no-error.
find mgcad.empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.

assign c-empresa  = empresa.razao-social
       c-programa = "ES/5502".

RUN utp\ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Imprimindo...").

RUN pi-carrega-cc.


DEF VAR c-FileName AS CHAR.

FIND LAST PARAM_orcto NO-LOCK NO-ERROR.

IF AVAIL PARAM_orcto 
THEN
    ASSIGN c-FileName = param_orcto.dir_planilha.

{esp/es550203.i "Abrir"} 

ASSIGN v_cont = 1.

        /***** Mudar Pasta de Trabalho *****/

{esp/es550203.i "MudarPasta" 01} 

ASSIGN   chExcel:Range('F' + string(v_cont)):Value =  "Dt Movto"                        
         chExcel:Range('A' + string(v_cont)):Value =  "Est"            
         chExcel:Range('H' + string(v_cont)):Value =  "Conta"          
         chExcel:Range('D' + string(v_cont)):Value =  "Cod Fornec"      
         chExcel:Range('E' + string(v_cont)):Value =  "Nome Fornec"           
         chExcel:Range('I' + string(v_cont)):Value =  "Ccusto"  
         chExcel:Range('P' + string(v_cont)):Value =  "Unid Negoc"     
         chExcel:Range('B' + string(v_cont)):Value =  "Origem"      
         chExcel:Range('G' + string(v_cont)):Value =  "Realizado"
         chExcel:Range('N' + string(v_cont)):VALUE =  "Per¡odo"
         chExcel:Range('C' + string(v_cont)):VALUE =  "DB/CR"
         chExcel:Range('J' + string(v_cont)):Value =  "Hist¢rico Movto"
         chExcel:Range('O' + string(v_cont)):Value =  "Hist¢rico"
         chExcel:Range('K' + string(v_cont)):VALUE =  "ITEM"
         chExcel:Range('L' + string(v_cont)):Value =  "Descri‡Æo ITEM"
         chExcel:Range('M' + string(v_cont)):Value =  "Quantidade".                           

FOR EACH  exerc_ctbl
    WHERE exerc_ctbl.cod_cenar_ctbl  = "Fiscal"
    AND   exerc_ctbl.cod_exerc_ctbl >= tt-param.c-exerc-ini
    AND   exerc_ctbl.cod_exerc_ctbl <= tt-param.c-exerc-fim NO-LOCK:

    FOR EACH  period_ctbl OF exerc_ctbl NO-LOCK
        WHERE period_ctbl.num_period_ctbl >= int(tt-param.nr-periodo-ini)
        AND   period_ctbl.num_period_ctbl  <= int(tt-param.nr-periodo-fim):


        ASSIGN da-inicio = DATE("01/" + string(period_ctbl.num_period_ctbl, "99") + "/" + string(exerc_ctbl.cod_exerc_ctbl, "9999"))
               da-fim    = ADD-INTERVAL(da-inicio,1 ,"MONTH") - DAY(da-inicio).
        
        FIND LAST PARAM_orcto NO-LOCK
            WHERE PARAM_orcto.dt_inicio <= da-inicio
            AND   PARAM_orcto.dt_final  >= da-fim NO-ERROR.

        IF  NOT AVAIL PARAM_orcto
        THEN
            NEXT.
        
        FOR EACH tt-usuar-cc
            WHERE tt-usuar-cc.cod_ccusto >= tt-param.c-ccusto-ini 
            AND   tt-usuar-cc.cod_ccusto <= tt-param.c-ccusto-fim:

            /* ** Caso seja informado algum cencto de custo na aba digita‡Æo aplicar o filtro na sele‡Æo ***/
            IF CAN-FIND(FIRST tt-digita) 
            AND NOT CAN-FIND(FIRST tt-digita
                             WHERE tt-digita.cod-ccusto = tt-usuar-cc.cod_ccusto)
                THEN NEXT.
            
            FOR EACH movto_real_orcto NO-LOCK
                WHERE movto_real_orcto.cod_empresa        = v_cdn_empres_usuar
                AND   movto_real_orcto.cod_estab          = tt-usuar-cc.cod_estab
                AND   movto_real_orcto.cod_cenar_ctbl     = "fiscal"
                AND   movto_real_orcto.cod_plano_cta_ctbl = "padrao"
                AND   movto_real_orcto.cod_plano_ccusto   = "padrao"
                AND   movto_real_orcto.cod_cta_ctbl      >= tt-param.c-conta-ini
                AND   movto_real_orcto.cod_cta_ctbl      <= tt-param.c-conta-fim
                AND   movto_real_orcto.cod_proj           = ""
                AND   movto_real_orcto.cod_exerc_ctbl     = period_ctbl.cod_exerc_ctbl
                AND   movto_real_orcto.num_period_ctbl    = string(period_ctbl.num_period_ctbl,"99")
                BREAK BY movto_real_orcto.cod_exerc_ctbl   
                      BY movto_real_orcto.num_period_ctbl
                      BY movto_real_orcto.cod_estab: 

                IF  tt-usuar-cc.cod_ccusto      <> "*" 
                AND movto_real_orcto.cod_ccusto <> tt-usuar-cc.cod_ccusto 
                    THEN NEXT.

                IF  tt-usuar-cc.cod_unid_negoc      <> "*"
                AND movto_real_orcto.cod_unid_negoc <> tt-usuar-cc.cod_unid_negoc
                    THEN NEXT.                

                ASSIGN c-periodo =  exerc_ctbl.cod_exerc_ctbl + "/" + STRING(period_ctbl.num_period_ctbl).

                RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo conta.: " + movto_real_orcto.cod_cta_ctbl + " Per¡odo.: "  + c-periodo).

                ASSIGN v_cont = v_cont + 1.

                FIND cta_ctbl
                    WHERE cta_ctbl.cod_plano_cta_ctbl = movto_real_orcto.cod_plano_cta_ctb
                      AND cta_ctbl.cod_cta_ctbl       = movto_real_orcto.cod_cta_ctbl     
                    NO-LOCK NO-ERROR.

                FIND emscad.ccusto
                    WHERE ccusto.cod_empres   = movto_real_orcto.cod_emp
                    AND   ccusto.cod_plano_cc = movto_real_orcto.cod_plano_ccusto
                    AND   ccusto.cod_ccusto   = movto_real_orcto.cod_ccusto
                    NO-LOCK NO-ERROR.
                                        
                FIND emscad.fornecedor
                    WHERE fornecedor.cod_empres = movto_real_orcto.cod_empr
                    AND   fornecedor.cdn_fornec = movto_real_orcto.cod_fornec
                    NO-LOCK NO-ERROR.                                          
                
                FIND unid_negoc
                    WHERE unid_negoc.cod_unid_negoc = movto_real_orcto.cod_unid_negoc 
                    NO-LOCK NO-ERROR.
                
                ASSIGN   chExcel:Range('F' + string(v_cont)):Value =  movto_real_orcto.dt_movto                        
                         chExcel:Range('A' + string(v_cont)):Value =  movto_real_orcto.cod_estab
                         chExcel:Range('H' + string(v_cont)):Value =  movto_real_orcto.cod_cta_ctbl  + " - " +  IF AVAIL cta_ctbl THEN cta_ctbl.des_tit_ctbl ELSE ""     
                         chExcel:Range('D' + string(v_cont)):Value =  movto_real_orcto.cod_fornec    
                         chExcel:Range('E' + string(v_cont)):Value =  IF  AVAIL fornecedor THEN fornecedor.nom_pessoa ELSE ""
                         chExcel:Range('I' + string(v_cont)):Value =  movto_real_orcto.cod_ccusto  + " - " + IF AVAIL ccusto THEN ccusto.des_tit_ctbl ELSE ""  
                         chExcel:Range('P' + string(v_cont)):Value =  movto_real_orcto.cod_unid_negoc + " - " + IF AVAIL unid_negoc THEN unid_negoc.des_unid_negoc ELSE ""
                         chExcel:Range('B' + string(v_cont)):Value =  movto_real_orcto.cod_origem     
                         chExcel:Range('G' + string(v_cont)):Value =  IF  movto_real_orcto.ind_natur_lancto_ctbl = "DB" THEN movto_real_orcto.val_realiz_per  ELSE movto_real_orcto.val_realiz_per * -1
                         chExcel:Range('N' + string(v_cont)):VALUE =  c-periodo
                         chExcel:Range('C' + string(v_cont)):VALUE =  movto_real_orcto.ind_natur_lancto_ctbl
                         chExcel:Range('J' + string(v_cont)):Value =  movto_real_orcto.des_histor_movto    
                         chExcel:Range('O' + string(v_cont)):Value =  movto_real_orcto.des_historicao.
                                       
                IF  movto_real_orcto.cod_origem = "CEP" THEN DO:
                    FIND movto-estoq
                        WHERE ROWID(movto-estoq) = TO-ROWID(movto_real_orcto.c-livre-1)
                        NO-LOCK NO-ERROR.
                    
                    IF AVAIL movto-estoq THEN DO:
                        FIND ITEM
                            WHERE ITEM.it-codigo = movto-estoq.it-codigo
                            NO-LOCK NO-ERROR.
                        ASSIGN chExcel:Range('K' + string(v_cont)):VALUE =  movto-estoq.it-codigo 
                               chExcel:Range('L' + string(v_cont)):Value =  IF AVAIL ITEM THEN ITEM.desc-item ELSE ""
                               chExcel:Range('M' + string(v_cont)):Value =  movto-estoq.quantidade.
                    END.
                END.               

                FIND FIRST tt-consulta-res
                   WHERE tt-consulta-res.cod_estab         = movto_real_orcto.cod_estab         
                     and tt-consulta-res.cod_cta_ctbl      = movto_real_orcto.cod_cta_ctbl      
                     and tt-consulta-res.cod_ccusto        = movto_real_orcto.cod_ccusto        
                     and tt-consulta-res.cod_unid_negoc    = movto_real_orcto.cod_unid_negoc    
                     and tt-consulta-res.cod_proj_financ   = movto_real_orcto.cod_proj_financ
                     AND tt-consulta-res.cod_exerc_ctbl    = movto_real_orcto.cod_exerc_ctbl  
                     AND tt-consulta-res.num_period_ctbl   = movto_real_orcto.num_period_ctbl 
                     NO-ERROR.
                     
                IF  NOT AVAIL tt-consulta-res THEN DO:
                    
                    CREATE tt-consulta-res.
                    ASSIGN tt-consulta-res.cod_emp           = movto_real_orcto.cod_empres
                           tt-consulta-res.cod_estab         = movto_real_orcto.cod_estab        
                           tt-consulta-res.cod_cta_ctbl      = movto_real_orcto.cod_cta_ctbl     
                           tt-consulta-res.cod_ccusto        = movto_real_orcto.cod_ccusto       
                           tt-consulta-res.cod_unid_negoc    = movto_real_orcto.cod_unid_negoc   
                           tt-consulta-res.cod_proj_financ   = movto_real_orcto.cod_proj_financ
                           tt-consulta-res.cod_exerc_ctbl    = movto_real_orcto.cod_exerc_ctbl  
                           tt-consulta-res.num_period_ctbl   = movto_real_orcto.num_period_ctbl.


                    FIND sdo_orcto_ctbl_bgc 
                        WHERE sdo_orcto_ctbl_bgc.cod_cenar_orctario  = PARAM_orcto.cod_cenar_orcto   
                          AND sdo_orcto_ctbl_bgc.cod_unid_orctaria   = PARAM_orcto.cod_unid_orcta    
                          AND sdo_orcto_ctbl_bgc.cod_cenar_ctbl      = "Fiscal"
                          AND sdo_orcto_ctbl.num_seq_orcto_ctbl      = param_orcto.num_seq_orcto_ctbl
                          AND sdo_orcto_ctbl_bgc.cod_plano_cta_ctbl  = "Padrao"
                          AND sdo_orcto_ctbl_bgc.cod_plano_ccusto    = "Padrao"
                          AND sdo_orcto_ctbl_bgc.cod_estab           = tt-consulta-res.cod_estab 
                          AND sdo_orcto_ctbl_bgc.cod_empresa         = tt-consulta-res.cod_empresa
                          AND sdo_orcto_ctbl_bgc.cod_exerc_ctbl      = tt-consulta-res.cod_exerc_ctbl
                          AND sdo_orcto_ctbl_bgc.num_period_ctbl     = INT(movto_real_orcto.num_period_ctbl)
                          AND sdo_orcto_ctbl_bgc.cod_vers_orcto_ctbl = PARAM_orcto.cod_vers_orcto_ctbl
                          AND sdo_orcto_ctbl.cod_cta_ctbl            = tt-consulta-res.cod_cta_ctbl
                          AND sdo_orcto_ctbl.cod_ccusto              = tt-consulta-res.cod_ccusto
                          AND sdo_orcto_ctbl.cod_unid_negoc          = tt-consulta-res.cod_unid_negoc
                          AND sdo_orcto_ctbl.cod_proj                = tt-consulta-res.cod_proj
                        NO-LOCK NO-ERROR.
                   

                     if avail sdo_orcto_ctbl_bgc then
                        ASSIGN tt-consulta-res.valor_orc         = sdo_orcto_ctbl_bgc.val_orcado.                      
                     ELSE
                        ASSIGN tt-consulta-res.valor_orc         = movto_real_orcto.val_orcado_per.
                END.
                ASSIGN tt-consulta-res.valor_rea = tt-consulta-res.valor_rea +
                                                 IF   movto_real_orcto.ind_natur_lancto_ctbl = "DB" THEN 
                                                      movto_real_orcto.val_realiz_per 
                                                 ELSE 
                                                      movto_real_orcto.val_realiz_per * -1.                       

            END.
        END.
    END.
END.     

chExcel:Columns("G:G"):select.
chExcel:Selection:NumberFormat = '@'.

ASSIGN v_cont = 1.

{esp/es550203.i "MudarPasta" 02} 

ASSIGN chExcel:Range('A' + string(v_cont)):Value =  "Est"
       chExcel:Range('B' + string(v_cont)):Value =  "Conta"       
       chExcel:Range('C' + string(v_cont)):Value =  "C.Custo"
       chExcel:Range('D' + string(v_cont)):Value =  "UN"
       chExcel:Range('E' + string(v_cont)):Value =  "Periodo"
       chExcel:Range('F' + string(v_cont)):Value =  "Valor orcado"          
       chExcel:Range('G' + string(v_cont)):Value =  "Valor realizado".

FOR EACH tt-consulta-res
    BREAK BY tt-consulta-res.cod_estab:

    ASSIGN v_cont = v_cont + 1.

    ASSIGN c-periodo =  tt-consulta-res.cod_exerc_ctbl  + "/" + tt-consulta-res.num_period_ctbl.

    RUN pi-acompanhar IN h-acomp (INPUT "Imprimindo Resumo.: " + tt-consulta-res.cod_cta_ctbl + " Per¡odo.: "  + c-periodo).

    ASSIGN   chExcel:Range('A' + string(v_cont)):Value =  tt-consulta-res.cod_estab          
             chExcel:Range('B' + string(v_cont)):Value =  tt-consulta-res.cod_cta_ctbl       
             chExcel:Range('C' + string(v_cont)):Value =  tt-consulta-res.cod_ccusto         
             chExcel:Range('D' + string(v_cont)):Value =  tt-consulta-res.cod_unid_negoc     
             chExcel:Range('E' + string(v_cont)):Value =  c-periodo
             chExcel:Range('F' + string(v_cont)):Value =  tt-consulta-res.valor_orc          
             chExcel:Range('G' + string(v_cont)):Value =  tt-consulta-res.valor_real     .
END.

chExcel:Columns("F:G"):select.
chExcel:Selection:NumberFormat = '@'.


RUN pi-finalizar IN h-acomp.

ChExcel:ActiveWorkbook:RefreshAll.

/***** Fecha a planilha Excel *****/
{esp/es550203.i "Fechar"} 

PROCEDURE pi-carrega-cc:
    DEF VAR i-cont-cc AS INT.

    FOR EACH estabelecimento NO-LOCK
        WHERE estabelecimento.cod_estab >= tt-param.c-cod-estab-ini
          AND estabelecimento.cod_estab <= tt-param.c-cod-estab-fim:

        FOR EACH usu-cc-un-orc NO-LOCK
            WHERE usu-cc-un-orc.cod-usuario = c-seg-usuario
              AND usu-cc-un-orc.cod-estab   = estabelecimento.cod_estab:

            IF usu-cc-un-orc.cod-ccusto = "*" 
               THEN NEXT.
    
            IF usu-cc-un-orc.cod-unid-negoc = "*" 
               THEN NEXT.

            IF NOT CAN-FIND(FIRST tt-usuar-cc
                            WHERE tt-usuar-cc.cod_estab      = usu-cc-un-orc.cod-estab
                              AND tt-usuar-cc.cod_ccusto     = usu-cc-un-orc.cod-ccusto
                              AND tt-usuar-cc.cod_unid_negoc = usu-cc-un-orc.cod-unid-neg) 
            THEN DO:
        
                 FIND emscad.ccusto
                    WHERE ccusto.cod_empresa  = usu-cc-un-orc.cod-empresa
                      AND ccusto.cod_plano_cc = "Padrao"
                      AND ccusto.cod_ccusto   = usu-cc-un-orc.cod-ccusto NO-LOCK NO-ERROR.
        
                 IF NOT AVAIL emscad.ccusto 
                    THEN NEXT.

                IF emscad.ccusto.dat_inic_valid > TODAY
                OR emscad.ccusto.dat_fim_valid  < TODAY 
                   THEN NEXT. 
                
                 CREATE tt-usuar-cc.
                 ASSIGN tt-usuar-cc.cod_estab      = usu-cc-un-orc.cod-estab
                        tt-usuar-cc.cod_ccusto     = usu-cc-un-orc.cod-ccusto
                        tt-usuar-cc.cod_unid_negoc = usu-cc-un-orc.cod-unid-neg
                        tt-usuar-cc.des_ccusto     = emscad.ccusto.des_tit_ctbl.

            END.
        END.

        FOR EACH usu-cc-un-orc NO-LOCK
            WHERE usu-cc-un-orc.cod-ccusto  = "*"
              AND usu-cc-un-orc.cod-usuario = c-seg-usuario
              AND usu-cc-un-orc.cod-estab   = estabelecimento.cod_estab:
            
            FOR EACH emscad.ccusto NO-LOCK
                WHERE ccusto.cod_empresa  = usu-cc-un-orc.cod-empresa
                  AND ccusto.cod_plano_cc = "Padrao":
    
                IF  emscad.ccusto.dat_inic_valid < TODAY
                AND emscad.ccusto.dat_fim_valid  > TODAY 
                    THEN.
                    ELSE NEXT.              
                
                IF NOT CAN-FIND(FIRST tt-usuar-cc
                                WHERE tt-usuar-cc.cod_estab      = usu-cc-un-orc.cod-estab
                                  AND tt-usuar-cc.cod_ccusto     = emscad.ccusto.cod_ccusto
                                  AND tt-usuar-cc.cod_unid_negoc = usu-cc-un-orc.cod-unid-neg) 
                THEN DO:
                     CREATE tt-usuar-cc.
                     ASSIGN tt-usuar-cc.cod_estab      = usu-cc-un-orc.cod-estab
                            tt-usuar-cc.cod_ccusto     = emscad.ccusto.cod_ccusto
                            tt-usuar-cc.cod_unid_negoc = usu-cc-un-orc.cod-unid-neg
                            tt-usuar-cc.des_ccusto     = emscad.ccusto.des_tit_ctbl.
                END.
            END.
        END.
    
        FOR EACH usu-cc-un-orc NO-LOCK
            WHERE usu-cc-un-orc.cod-unid-negoc = "*"
              AND usu-cc-un-orc.cod-usuario    = c-seg-usuario
              AND usu-cc-un-orc.cod-estab      = estabelecimento.cod_estab:
    
            FOR EACH unid_negoc NO-LOCK:
    
                IF NOT CAN-FIND(FIRST tt-usuar-cc
                                WHERE tt-usuar-cc.cod_estab      = usu-cc-un-orc.cod-estab
                                  AND tt-usuar-cc.cod_ccusto     = usu-cc-un-orc.cod-ccusto
                                  AND tt-usuar-cc.cod_unid_negoc = unid_negoc.cod_unid_negoc) 
                THEN DO:
                                                                                        
                     FIND emscad.ccusto NO-LOCK
                        WHERE ccusto.cod_empresa  = usu-cc-un-orc.cod-empresa
                          AND ccusto.cod_plano_cc = "Padrao"
                          AND ccusto.cod_ccusto   = usu-cc-un-orc.cod-ccusto NO-ERROR.
            
                     CREATE tt-usuar-cc.
                     ASSIGN tt-usuar-cc.cod_estab      = usu-cc-un-orc.cod-estab
                            tt-usuar-cc.cod_ccusto     = usu-cc-un-orc.cod-ccusto
                            tt-usuar-cc.cod_unid_negoc = unid_negoc.cod_unid_negoc
                            tt-usuar-cc.des_ccusto = IF  AVAIL emscad.ccusto THEN emscad.ccusto.des_tit_ctbl ELSE "".              
    
                END.
            END.
        END.
    END.        
END.

