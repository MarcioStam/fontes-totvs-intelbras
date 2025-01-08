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
{include/i-prgvrs.i ESCPP029RP 2.04.00.001}

/* ***************************  Definitions  ************************** */
&global-define programa ESCPP029RP

def var c-liter-par                  as character format "x(13)":U.
def var c-liter-sel                  as character format "x(10)":U.
def var c-liter-imp                  as character format "x(12)":U.    
def var c-destino                    as character format "x(15)":U.

{esp/cpp/escpp029tt.i}

def temp-table tt-raw-digita
    field raw-digita as raw.
 
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

def var h-acomp         as handle no-undo.    
def var c-obs-ini as char format "x(31)" no-undo. 
def var c-obs-fim as char format "x(31)" no-undo.

def var i-ind as int no-undo.

form
/*form-selecao-ini*/
    skip(1)
    "SELE€ÇO"         
    skip(1)
    /*form-selecao-usuario*/
    tt-param.item-ini colon 40 label "Item" 
    "<|   |>" at 75 tt-param.item-fim no-label skip
    tt-param.fabric-ini colon 40 label "Fabricante" 
    "<|   |>" at 75 tt-param.fabric-fim no-label skip
    c-obs-ini colon 40 label "Obsoleto" 
    "<|   |>" at 75 c-obs-fim no-label skip
    skip(1)
/*form-selecao-fim*/
/*form-parametro-ini*/
    skip(1)
    "CLASSIFICA€ÇO"
    skip(1)
    /*form-parametro-usuario*/
    tt-param.desc-classifica colon 40 no-label
    skip(1)
/*form-parametro-fim*/
/*form-impressao-ini*/
    skip(1)
    "IMPRESSÇO"
    skip(1)
    c-destino           label "Destino" colon 40 "-"
    tt-param.arquivo    no-label
    tt-param.usuario    label "Usu rio" colon 40
    skip(1)
/*form-impressao-fim*/
    with stream-io side-labels no-attr-space no-box width 132 frame f-impressao.

form 
   "Item    Descri‡Æo                           "
   " Fabric Nome                "
   "Item do Fabricante                   Referˆncia" skip
   "------- ------------------------------------"
   "------- --------------------"
   "------------------------------------ --------------------"
   with width 150 no-labels page-top frame f-cab-item stream-io no-box.

form 
   "Fabric  Nome                "
   "Item    Descri‡Æo                           "
   "Item do Fabricante                   Referˆncia" skip
   "------- --------------------"
   "------- ------------------------------------"
   "------------------------------------ --------------------"
    with width 150 no-labels page-top frame f-cab-fabr stream-io no-box.

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

{include/i-rpvar.i}

find mgcad.empresa
    where empresa.ep-codigo = "1"
    no-lock no-error.
find first param-global no-lock no-error.

{utp/ut-liter.i Espec¡ficos Intelbras * }
assign c-sistema = return-value.
{utp/ut-liter.i Relat¢rio_Item/Fabricante * }
assign c-titulo-relat = return-value.
assign c-empresa     = param-global.grupo
       c-programa    = "{&programa}":U
       c-versao      = "1.00":U
       c-revisao     = "000"
       c-destino     = {varinc/var00002.i 04 tt-param.destino}
       c-obs-ini     = string(tt-param.obs-ini) + " - " + {ininc/i17in172.i 04 tt-param.obs-ini}
       c-obs-fim     = string(tt-param.obs-fim) + " - " + {ininc/i17in172.i 04 tt-param.obs-fim}.

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
   Other Settings: CODE-ONLY COMPILE
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
find first tt-param no-error.
do on stop undo, leave:
    {include/i-rpout.i}
    view frame f-cabec.
    view frame f-rodape.    
    run utp/ut-acomp.p persistent set h-acomp.  
    
    run pi-inicializar in h-acomp (input "Imprimindo":U). 
    
    run piReport in this-procedure.
    
    if tt-param.imprime-par then do:
        page.
        disp tt-param.item-ini 
             tt-param.fabric-ini 
             c-obs-ini 
             tt-param.item-fim 
             tt-param.fabric-fim 
             c-obs-fim 
             tt-param.desc-classifica 
             c-destino           
             tt-param.arquivo    
             tt-param.usuario 
             with frame f-impressao.   
    end.
    
    run pi-finalizar in h-acomp.
    {include/i-rpclo.i}
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-piReport) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piReport Procedure 
PROCEDURE piReport :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        if tt-param.classifica = 2 then do:  /***** item *****/
                        
           view frame f-cab-item.
           
           for each item-fabric no-lock where
               item-fabric.it-codigo >= tt-param.item-ini and
               item-fabric.it-codigo <= tt-param.item-fim and
               item-fabric.cod-fabric >= tt-param.fabric-ini and
               item-fabric.cod-fabric <= tt-param.fabric-fim,
               each item no-lock where item.it-codigo = item-fabric.it-codigo
                and item.cod-obsoleto >= tt-param.obs-ini
                and item.cod-obsoleto <= tt-param.obs-fim
               break by item-fabric.it-codigo
                     by item-fabric.cod-fabric:
                     
                run pi-acompanhar in h-acomp (input "Item: " + item.it-codigo).
                                     

               if first-of(item-fabric.it-codigo) then do:
                  if avail item then 
                     put item-fabric.it-codigo format "X(07)" at  1
                         item.descricao-1      at  9
                         item.descricao-2      at 27.
                  else
                     put item-fabric.it-codigo format "X(07)" at  1
                         "Item nÆo cadastrado"                at  9.
               end.
           
               find first fabricante no-lock where
                    fabricante.cod-fabric = item-fabric.cod-fabric no-error.
                 
               if avail fabricante then
                  put item-fabric.cod-fabric at 46
                      fabricante.nome-abrev  at 54
                      item-fabric.it-fabric  at 75
                      " "
                      item-fabric.referencia.
               else
                  put item-fabric.cod-fabric      at 46
                      "Fabricante nao Cadastrado" at 54
                      item-fabric.it-fabric       at 75
                      " "
                      item-fabric.referencia.
                      
               if last-of(item-fabric.it-codigo) then 
                  put skip(1).
            end.
        end.
        else do:  /*****  Fabricante *****/.
           
           view frame f-cab-fabr.
           
           for each item-fabric no-lock where
               item-fabric.it-codigo >= tt-param.item-ini and
               item-fabric.it-codigo <= tt-param.item-fim and
               item-fabric.cod-fabric >= tt-param.fabric-ini and
               item-fabric.cod-fabric <= tt-param.fabric-fim,
               each item no-lock where item.it-codigo = item-fabric.it-codigo
                and item.cod-obsoleto >= tt-param.obs-ini
                and item.cod-obsoleto <= tt-param.obs-fim
               break by item-fabric.cod-fabric
                     by item-fabric.it-codigo:

                run pi-acompanhar in h-acomp (input "Item: " + item.it-codigo).

               if first-of(item-fabric.cod-fabric) then do:
                  find first fabricante no-lock where
                       fabricante.cod-fabric = item-fabric.cod-fabric no-error.
                  if avail fabricante then
                     put item-fabric.cod-fabric at  1
                         fabricante.nome-abrev  at  9.
                  else
                     put item-fabric.cod-fabric at  1
                         "Fabricante nÆo cadastrado"  at  9.
                end.
           
                 
               if avail item then
                  put item-fabric.it-codigo format "X(07)" at 30
                      item.descricao-1 at 38
                      item.descricao-2 at 56
                      item-fabric.it-fabric at 75
                      " "
                      item-fabric.referencia.
               else
                  put item-fabric.it-codigo format "X(07)" at 30
                      "Item nao cadastrado" at 38
                      item-fabric.it-fabric at 75
                      " "
                      item-fabric.referencia.
                      
               if last-of(item-fabric.cod-fabric) then
                  put skip(1).
            end.
        end.

        put "" skip.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

