{esp/esb/esesb000.i}

define temp-table msg0073 no-undo xml-node-name 'MSG0073'
   field idm as int xml-node-type 'hidden'
   field CodigoConta AS CHAR.

define temp-table msg0073r no-undo xml-node-name 'MSG0073R'
   field idm as int xml-node-type 'hidden'.
   
   
DEFINE TEMP-TABLE tt-erro           NO-UNDO
    FIELD mensagem AS CHARACTER FORMAT "x(250)".

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
    FIELD ttv_num_cod_erro AS integer INITIAL ?
    FIELD ttv_des_msg_ajuda AS character INITIAL ?
    FIELD ttv_des_msg_erro AS character INITIAL ?.


/*Defini‡Æo das temp-tables de valida‡Æo - cdp/cdapi329.p*/
DEFINE TEMP-TABLE tt-versao-integr NO-UNDO
    FIELD cod-versao-integracao AS INTEGER FORMAT "999":U
    FIELD ind-origem-msg        AS INTEGER FORMAT "99":U.

DEFINE TEMP-TABLE tt-erros-geral NO-UNDO
    FIELD identif-msg        AS CHARACTER FORMAT "x(60)":U
    FIELD num-sequencia-erro AS INTEGER   FORMAT "999":U
    FIELD cod-erro           AS INTEGER   FORMAT "99999":U
    FIELD des-erro           AS CHARACTER FORMAT "x(60)":U
    FIELD cod-maq-origem     AS INTEGER   FORMAT "999":U
    FIELD num-processo       AS INTEGER   FORMAT "999999999":U.

DEFINE TEMP-TABLE tt-cliente-valid NO-UNDO LIKE emitente
    FIELD cod-maq-origem AS INTEGER   FORMAT "9999":U
    FIELD num-processo   AS INTEGER   FORMAT ">>>>>>>>9":U INITIAL 0
    FIELD num-sequencia  AS INTEGER   FORMAT ">>>>>9":U    INITIAL 0
    FIELD ind-tipo-movto AS INTEGER   FORMAT "99":U        INITIAL 1
    INDEX ch-codigo IS PRIMARY
        cod-maq-origem
        num-processo
        num-sequencia.
        
def temp-table tt-loc-entr-valid like loc-entr
    field cod-maq-origem   as   integer format "9999"
    field num-processo     as   integer format ">>>>>>>>9" initial 0
    field num-sequencia    as   integer format ">>>>>9"    initial 0
    field ind-tipo-movto   as   integer format "99"        initial 1
    INDEX ch-codigo IS PRIMARY  cod-maq-origem
                                num-processo
                                num-sequencia.  

DEFINE TEMP-TABLE tt-dist-emit-valid NO-UNDO LIKE dist-emitente
    FIELD cod-maq-origem AS INTEGER   FORMAT "9999":U
    FIELD num-processo   AS INTEGER   FORMAT ">>>>>>>>9":U INITIAL 0
    FIELD num-sequencia  AS INTEGER   FORMAT ">>>>>9":U    INITIAL 0
    FIELD ind-tipo-movto AS INTEGER   FORMAT "99":U        INITIAL 1
    INDEX ch-codigo IS PRIMARY
        cod-maq-origem
        num-processo
        num-sequencia.

