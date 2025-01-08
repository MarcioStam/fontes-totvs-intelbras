&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*:T *******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
DEFINE BUFFER empresa FOR mgcad.empresa.

{include/i-prgvrs.i ESCEP071RP 1.00.00.000}

/* ***************************  Definitions  ************************** */
&global-define programa ESCEP071RP

def var c-liter-par                  as character format "x(13)":U.
def var c-liter-sel                  as character format "x(10)":U.
def var c-liter-imp                  as character format "x(12)":U.    
def var c-destino                    as character format "x(15)":U.
def var c-obsoleto-ini               as char format "x(30)" no-undo.
def var c-obsoleto-fim               as char format "x(30)" no-undo.
def var c-tipo                       as char format "x(30)" no-undo.
def var c-imprimir                   as char format "x(30)" no-undo.
def var c-imprime-local              as char format "x(30)" no-undo.
DEFINE VARIABLE c-localiz AS CHARACTER   NO-UNDO COLUMN-LABEL "Localiz".
DEFINE VARIABLE l-achou-baixa        AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-ok AS CHARACTER   NO-UNDO.
DEFINE VARIABLE d-data AS DATE        NO-UNDO.
DEFINE VARIABLE c-item-ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-item-fim AS CHARACTER   NO-UNDO.
{esp/cep/escep071.i}

DEF TEMP-TABLE tt-deposito NO-UNDO
    FIELD cod-estabel       LIKE wm-local.cod-estabel
    FIELD cod-local         LIKE wm-local.cod-local
    FIELD cod-deposito      LIKE wm-local.cod-deposito.

def temp-table tt-raw-digita
    field raw-digita as raw.
 
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

def var h-acomp         as handle no-undo.    

form
/*form-selecao-ini*/
    skip(1)
    c-liter-sel         no-label
    skip(1)
    /*form-selecao-usuario*/
    tt-param.cod-estabel format "X(05)" label "Estabel" colon 40 skip
    tt-param.dt-ini format "99/99/9999" label "Data" colon 40
    " <| |> " at 60
    tt-param.dt-fim format "99/99/9999" no-label skip
    tt-param.cod-depos-ini format "x(03)" label "Item" colon 40 
    " <| |> " at 60
    tt-param.cod-depos-fim format "x(03)" no-label
    skip(1)
/*form-selecao-fim*/
/*form-parametro-ini*/
    
    /*skip(1)
    c-liter-par         no-label
    skip(1)
    /*form-parametro-usuario*/
    tt-param.cod-depos format "x(3)" label "Dep½sito" colon 40 skip
    tt-param.cod-estabel label "Estabelecimento" colon 40 skip
    c-tipo colon 40 label "Tipo" skip
    c-imprimir colon 40 label "Imprimir" skip
    c-imprime-local colon 40 label "Imprimir Local"
    skip(1)*/

/*form-parametro-fim*/
/*form-impressao-ini*/
    skip(1)
    c-liter-imp         no-label
    skip(1)
    c-destino           colon 40 "-"
    tt-param.arquivo    no-label
    tt-param.usuario    colon 40
    skip(1)
/*form-impressao-fim*/
    with stream-io side-labels no-attr-space no-box width 132 frame f-impressao.

form
    /*campos-do-relatorio*/
     with no-box width 132 down stream-io frame f-relat.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

/*inicio-traducao*/
/*traducao-default*/
{utp/ut-liter.i PARôMETROS * r}
assign c-liter-par = return-value.
{utp/ut-liter.i SELE°€O * r}
assign c-liter-sel = return-value.
{utp/ut-liter.i IMPRESS€O * r}
assign c-liter-imp = return-value.
{utp/ut-liter.i Destino * l}
assign c-destino:label in frame f-impressao = return-value.
{utp/ut-liter.i Usuÿrio * l}
assign tt-param.usuario:label in frame f-impressao = return-value.   
/*fim-traducao*/

{include/i-rpvar.i}
{utp/ut-glob.i}

find empresa
    where empresa.ep-codigo = v_cdn_empres_usuar
    no-lock no-error.
find first param-global no-lock no-error.

{utp/ut-liter.i Espec­ficos_Intelbras * }
assign c-sistema = return-value.
{utp/ut-liter.i Relat½rio_de_Saldos_por_Localiza»’o * }
assign c-titulo-relat = return-value.
assign c-empresa     = param-global.grupo
       c-programa    = "{&programa}":U
       c-versao      = "1.00":U
       c-revisao     = "000"
       c-destino     = {varinc/var00002.i 04 tt-param.destino}
       /*c-obsoleto-ini = {ininc/i17in172.i 04 tt-param.cod-obsoleto-ini}
       c-obsoleto-fim = {ininc/i17in172.i 04 tt-param.cod-obsoleto-fim}*/
       /*c-tipo         = entry(tt-param.ind-tipo, "Resumido,Detalhado")
       c-imprimir     = entry(tt-param.ind-imprimir, "Sem Quantidade,Com Quantidade")
       c-imprime-local = entry(tt-param.ind-imprime-local, "Dispon­vel,Ocupada")*/
       .

def var i-ind as int no-undo.
def var l-primeiro as logical no-undo.
def var i-nr-ae      like ae-item.nr-ae format ">>>>>>9" extent 7 no-undo.
def var i-sequencia  like ae-item.sequencia format ">>9" extent 7 no-undo.
def var i-quantidade like ae-item.quantidade extent 7 format ">>>>>" no-undo.
def var l-tem-saldo  as logical no-undo.

DEF VAR d-qtd-final  LIKE inventario.valor-final NO-UNDO.

/*{include/tt-edit.i}
{include/pi-edit.i}*/

/*def temp-table tt-relat no-undo
    field localizacao  like local.localizacao
    field it-codigo    like item.it-codigo
    field cod-depos    like local.cod-depos
    field desc-item    like tt-editor.conteudo
    field cod-obsoleto like item.cod-obsoleto
    field qtidade-atu  like saldo-estoq.qtidade-atu
    index relat cod-depos localizacao it-codigo.*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure Template
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{include/i-rpcab.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

for first param-estoq fields ( ) no-lock: end.
FOR FIRST tt-param: END.

{include/i-rpout.i}
view frame f-cabec.
view frame f-rodape.    
run utp/ut-acomp.p persistent set h-acomp.  

run pi-inicializar in h-acomp (input "Imprimindo":U). 

for each inventario no-lock 
   where inventario.dt-saldo >= tt-param.dt-ini
     and inventario.dt-saldo <= tt-param.dt-fim   
     and inventario.cod-estabel = tt-param.cod-estab
     and inventario.cod-depos >= tt-param.cod-depos-ini
     and inventario.cod-depos <= tt-param.cod-depos-fim:

    c-ok = "".
    
    IF inventario.situacao = 1 THEN c-ok = "OK".

    if  val-apurado[3] <> ? then c-ok = "OK".
    else
    if  val-apurado[2] <> ? then do:
        if  val-apurado[2] = val-apurado[1]
        or (val-apurado[2] = qtidade-atu
        and param-estoq.cons-invent = 1) then c-ok = "OK".
    end.
    else
    if  val-apurado[1] <> ? then do:
        if (val-apurado[1] = qtidade-atu
           and param-estoq.cons-invent = 1) then c-ok = "OK".
    end.

    if c-ok = "" then next.

    RUN pi-acompanhar IN h-acomp (INPUT "Deposito: " + inventario.cod-depos).

   disp inventario.dt-saldo
        inventario.it-codigo
        inventario.cod-depos
        inventario.cod-localiz
        inventario.qtidade-atu     FORMAT ">>>,>>>,>>9.9999"
        inventario.val-apurado[1]  FORMAT ">,>>>,>>>,>>9.9999"
        inventario.val-apurado[2]  FORMAT ">,>>>,>>>,>>9.9999"
        inventario.val-apurado[3]  FORMAT ">,>>>,>>>,>>9.9999"
        IF inventario.valor-final = ? THEN 0 ELSE inventario.valor-final FORMAT ">,>>>,>>>,>>9.9999" COLUMN-LABEL "Qtde Fim"
        string(inventario.situacao)
        with width 300 .
end.

FOR EACH wm-local 
   WHERE wm-local.cod-estabel   =  tt-param.cod-estabel 
     AND wm-local.cod-local     >= tt-param.cod-depos-ini 
     AND wm-local.cod-local     <= tt-param.cod-depos-fim NO-LOCK:

    CREATE tt-deposito.
    ASSIGN tt-deposito.cod-estabel  = wm-local.cod-estabel 
           tt-deposito.cod-local    = wm-local.cod-local 
           tt-deposito.cod-deposito = wm-local.cod-deposito. 
END.


/*proxySaldoEstoque chamada dentro do for each causa problemas de perfomance*/
ASSIGN c-item-ini = "ZZZZZZZZZZZZZZZZ"
       c-item-fim = "".

DO d-data = tt-param.dt-ini TO tt-param.dt-fim:
    FOR EACH wm-inventario NO-LOCK
       WHERE wm-inventario.cod-estabel    = tt-param.cod-estabel    
         AND wm-inventario.cod-local     >= tt-param.cod-depos-ini
         AND wm-inventario.cod-local     <= tt-param.cod-depos-fim
         AND wm-inventario.dt-inventario  = d-data
         /*AND wm-inventario.log-acerto-ce = YES*/ ,
        EACH wm-inventario-item NO-LOCK
       WHERE wm-inventario-item.cod-estabel    = wm-inventario.cod-estabel    
         AND wm-inventario-item.cod-local      = wm-inventario.cod-local      
         AND wm-inventario-item.dt-inventario  = wm-inventario.dt-inventario  
         AND wm-inventario-item.num-seq-invent = wm-inventario.num-seq-invent,
        FIRST wm-item NO-LOCK 
        WHERE wm-item.cod-item     = wm-inventario-item.cod-item:

        IF  wm-inventario-item.cod-item > c-item-fim THEN
            ASSIGN c-item-fim = wm-inventario-item.cod-item.

        IF  wm-inventario-item.cod-item < c-item-ini THEN
            ASSIGN c-item-ini = wm-inventario-item.cod-item.
    END.
END.

DO d-data = tt-param.dt-ini TO tt-param.dt-fim:
    FOR EACH wm-inventario NO-LOCK
       WHERE wm-inventario.cod-estabel    = tt-param.cod-estabel    
         AND wm-inventario.cod-local     >= tt-param.cod-depos-ini
         AND wm-inventario.cod-local     <= tt-param.cod-depos-fim
         AND wm-inventario.dt-inventario  = d-data
         /*AND wm-inventario.log-acerto-ce = YES*/ ,
        EACH wm-inventario-item NO-LOCK
       WHERE wm-inventario-item.cod-estabel    = wm-inventario.cod-estabel    
         AND wm-inventario-item.cod-local      = wm-inventario.cod-local      
         AND wm-inventario-item.dt-inventario  = wm-inventario.dt-inventario  
         AND wm-inventario-item.num-seq-invent = wm-inventario.num-seq-invent,
        FIRST wm-item NO-LOCK 
        WHERE wm-item.cod-item     = wm-inventario-item.cod-item:
    
        RUN pi-acompanhar IN h-acomp (INPUT "Deposito: " + wm-inventario.cod-local).

        FIND FIRST wm-box NO-LOCK
             WHERE wm-box.cod-estabel = wm-inventario-item.cod-estabel
               AND wm-box.cod-local   = wm-inventario-item.cod-local
               AND wm-box.id-box      = wm-inventario-item.id-box NO-ERROR.

        ASSIGN c-localiz = "".

        IF AVAIL wm-box THEN 
            ASSIGN c-localiz = wm-box.cod-bloco + "/" + wm-box.cod-rua + "/" + wm-box.cod-nivel + "/" + wm-box.cod-coluna.
    
        //Valida qtd final
        ASSIGN d-qtd-final = 0.

        IF wm-inventario-item.qtd-final = ? 
        THEN DO:

            ASSIGN d-qtd-final = wm-inventario-item.qtd-apurada[1].

            IF wm-inventario-item.qtd-apurada[2] <> ? 
            THEN ASSIGN d-qtd-final = wm-inventario-item.qtd-apurada[2]. 

            IF wm-inventario-item.qtd-apurada[3] <> ? 
            THEN ASSIGN d-qtd-final = wm-inventario-item.qtd-apurada[3].
        END.
        ELSE ASSIGN d-qtd-final = wm-inventario-item.qtd-final.
        //fim qtd final

        disp wm-inventario.dt-inventario COLUMN-LABEL "Saldo Invent"
             wm-inventario-item.cod-item
             wm-inventario.cod-local COLUMN-LABEL "Dep"
             c-localiz FORMAT "x(20)"
             wm-inventario-item.qtd-saldo COLUMN-LABEL "Qtde Atual"
             wm-inventario-item.qtd-apurada[1] FORMAT ">,>>>,>>>,>>9.9999" COLUMN-LABEL "vlr Apurado"
             wm-inventario-item.qtd-apurada[2] FORMAT ">,>>>,>>>,>>9.9999" COLUMN-LABEL "vlr Apurado"
             wm-inventario-item.qtd-apurada[3] FORMAT ">,>>>,>>>,>>9.9999" COLUMN-LABEL "vlr Apurado"
            // IF wm-inventario-item.qtd-final = ? THEN 0 ELSE wm-inventario-item.qtd-final FORMAT ">,>>>,>>>,>>9.9999" COLUMN-LABEL "Qtde Fim"
             d-qtd-final FORMAT ">,>>>,>>>,>>9.9999" COLUMN-LABEL "Qtde Fim"
             string(wm-inventario.ind-sit-invent)
            with width 300 .

    END.
END.

RUN pi-finalizar IN h-acomp.

{include/i-rpclo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-put-ae) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE put-ae Procedure 
PROCEDURE put-ae PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    put  i-nr-ae[1] " "
         i-sequencia[1] " "
         i-quantidade[1] " |"

         i-nr-ae[2] " "
         i-sequencia[2] " "
         i-quantidade[2] " |"

         i-nr-ae[3] " "
         i-sequencia[3] " "
         i-quantidade[3] " |"
         
         i-nr-ae[4] " "
         i-sequencia[4] " "
         i-quantidade[4] " |"

         i-nr-ae[5] " "
         i-sequencia[5] " "
         i-quantidade[5] " |"

         i-nr-ae[6] " "
         i-sequencia[6] " "
         i-quantidade[6] " |"

         i-nr-ae[7] " "
         i-sequencia[7] " "
         i-quantidade[7] skip(1).

    assign i-ind = 0
           i-nr-ae = 0
           i-sequencia = 0
           i-quantidade = 0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


