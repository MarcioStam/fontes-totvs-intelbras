&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*****************************************************************************
**     Programa.........: esp/esacr023
**     Descricao .......: ImpressÆo de etiquetas
**     Versao...........: 1.00.000
**     Autor............: Clayton Antunes
**     Criado...........: 19/04/2006
*******************************************************************************/

CREATE WIDGET-POOL.

DEF STREAM STREAM_1.
DEF VAR c-ant                 AS CHAR.
DEF VAR v_num_ped_exec_rpw    AS INTE.
DEF VAR v_log_det             AS logi INIT NO.
DEF VAR v_cod_exessao         AS CHAR.
DEF VAR c-impressora          AS CHAR.
DEF VAR c-layout              AS CHAR.
DEF VAR wh-exessao            as HANDLE.


def var c-text      as char format "X(40)" init "A/C: Departamento Financeiro".

def var i-sequencia as int.
def var i-nr-docto  like tit_acr.cod_tit_acr    extent 14.
def var c-cod-esp   as char format "X(02)"      extent 14.
def var c-cod-ser   as char format "X(02)"      extent 14.
def var i-parcela   like tit_acr.cod_parcela    EXTENT 14.
def var l-hist      as logical format "Sim/Nao" extent 14.
def var i-cli       like emitente.cod-emitente  extent 14.



def var ind         as int.
def var c-nome-emit AS CHAR FORMAT "x(40)" extent 2.
def var c-endereco  like emitente.endereco extent 2.
def var c-bairro    like emitente.bairro extent 2.
def var i-cep       LIKE emitente.cep-cob extent 2.
def var c-cidade    like emitente.cidade extent 2.
def var c-estado    like emitente.estado extent 2.


 DEF STREAM Stream_1.


{esp\acr\esacr023tt.i}



 /* Vari veis utilizadas na integra‡Æo com o EMS5 */
def new global shared var v_cod_empres_usuar
    as character
    format "x(3)":U
    label "Empresa"
    column-label "Empresa"
    no-undo.
def new global shared var v_cod_estab_usuar
    as character
    format "x(3)":U
    label "Estabelecimento"
    column-label "Estab"
    no-undo.
def new global shared var v_cod_grp_usuar_lst
    as character
    format "x(3)":U
    label "Grupo Usu rios"
    column-label "Grupo"
    no-undo.
def new global shared var v_cod_idiom_usuar
    as character
    format "x(8)":U
    label "Idioma"
    column-label "Idioma"
    no-undo.
def new global shared var v_cod_pais_empres_usuar
    as character
    format "x(3)":U
    label "Pa¡s Empresa Usu rio"
    column-label "Pa¡s"
    no-undo.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.
def new global shared var v_cod_usuar_corren_criptog
    as character
    format "x(16)":U
    no-undo.

def new global shared var v5_cod_empres_usuar
    as character
    format 'x(3)'
    label 'Empresa'
    column-label 'Empresa'
    no-undo.
def new global shared var v5_cod_estab_usuar
    as character
    format 'x(3)'
    label 'Estabelecimento'
    column-label 'Estab'
    no-undo.
def new global shared var v5_cod_grp_usuar_lst 
    as character 
    label 'Grupo Usu rios' 
    column-label 'Grupo' 
    no-undo.
def new global shared var v5_cod_idiom_usuar
    as character
    format 'x(8)'
    label 'Idioma'
    column-label 'Idioma'
    no-undo.
def new global shared var v5_cod_pais_empres_usuar
    as character
    format 'x(3)'
    label 'Pa¡s Empresa Usu rio'
    column-label 'Pa¡s'
    no-undo.
def new global shared var v5_cod_usuar_corren
    as character
    format 'x(12)'
    label 'Usu rio Corrente'
    column-label 'Usu rio Corrente'
    no-undo.
def new global shared var v5_cod_usuar_corren_criptog
    as character
    format 'x(16)'
    no-undo.




def new global shared var cod-cli as character.
def new global shared var v_cod_usuar_corren
    as character
    format "x(12)":U
    label "Usu rio Corrente"
    column-label "Usu rio Corrente"
    no-undo.




DEF NEW SHARED VAR V_Rpt_Stream_1_Lines      AS INTE INIT 60.
         DEF NEW SHARED VAR V_Rpt_Stream_1_Columns    AS INTE INIT 132.
         DEF NEW SHARED VAR V_Rpt_Stream_1_Bottom     AS INTE INIT 60.
         DEF NEW SHARED VAR V_Rpt_Stream_1_Page       AS INTE.
         DEF NEW SHARED VAR V_Rpt_Stream_1_Name       AS CHAR.


         DEF VAR V_Cod_Dwb_File          LIKE Dwb_Set_List_Param.Cod_Dwb_File     NO-UNDO.
              DEF VAR V_Cod_Dwb_Output        LIKE Dwb_Set_List_Param.Cod_Dwb_Output   NO-UNDO.

              DEF VAR l-pula AS LOG.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-relat

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-cod-titulo-1 fi-cod-esp-docto-1 ~
fi-cod-parcela-1 fi-cod-titulo-2 fi-cod-esp-docto-2 fi-cod-parcela-2 ~
fi-cod-titulo-3 fi-cod-esp-docto-3 fi-cod-parcela-3 fi-cod-titulo-4 ~
fi-cod-esp-docto-4 fi-cod-parcela-4 fi-cod-titulo-5 fi-cod-esp-docto-5 ~
fi-cod-parcela-5 fi-cod-titulo-6 fi-cod-esp-docto-6 fi-cod-parcela-6 ~
fi-cod-titulo-7 fi-cod-esp-docto-7 fi-cod-parcela-7 fi-cod-titulo-8 ~
fi-cod-esp-docto-8 fi-cod-parcela-8 fi-cod-titulo-9 fi-cod-esp-docto-9 ~
fi-cod-parcela-9 fi-cod-titulo-10 fi-cod-esp-docto-10 fi-cod-parcela-10 ~
fi-cod-titulo-11 fi-cod-esp-docto-11 fi-cod-parcela-11 fi-cod-titulo-12 ~
fi-cod-esp-docto-12 fi-cod-parcela-12 fi-cod-titulo-13 fi-cod-esp-docto-13 ~
fi-cod-parcela-13 fi-cod-titulo-14 fi-cod-esp-docto-14 fi-cod-parcela-14 ~
rs-mostra c-arquivo bt-salva bt-cfimp fi-txt-etiq fi-Cod-Cli-1 fi-Cod-Cli-2 ~
fi-Cod-Cli-3 fi-Cod-Cli-4 fi-Cod-Cli-5 fi-Cod-Cli-6 fi-Cod-Cli-7 ~
fi-Cod-Cli-8 fi-Cod-Cli-9 fi-Cod-Cli-10 fi-Cod-Cli-11 fi-Cod-Cli-12 ~
fi-Cod-Cli-13 fi-Cod-Cli-14 bt-imprime-2 RECT-2 RECT-7 RECT-11 RECT-12 
&Scoped-Define DISPLAYED-OBJECTS fi-cod-titulo-1 fi-cod-esp-docto-1 ~
fi-cod-parcela-1 fi-cod-titulo-2 fi-cod-esp-docto-2 fi-cod-parcela-2 ~
fi-cod-titulo-3 fi-cod-esp-docto-3 fi-cod-parcela-3 fi-cod-titulo-4 ~
fi-cod-esp-docto-4 fi-cod-parcela-4 fi-cod-titulo-5 fi-cod-esp-docto-5 ~
fi-cod-parcela-5 fi-cod-titulo-6 fi-cod-esp-docto-6 fi-cod-parcela-6 ~
fi-cod-titulo-7 fi-cod-esp-docto-7 fi-cod-parcela-7 fi-cod-titulo-8 ~
fi-cod-esp-docto-8 fi-cod-parcela-8 fi-cod-titulo-9 fi-cod-esp-docto-9 ~
fi-cod-parcela-9 fi-cod-titulo-10 fi-cod-esp-docto-10 fi-cod-parcela-10 ~
fi-cod-titulo-11 fi-cod-esp-docto-11 fi-cod-parcela-11 fi-cod-titulo-12 ~
fi-cod-esp-docto-12 fi-cod-parcela-12 fi-cod-titulo-13 fi-cod-esp-docto-13 ~
fi-cod-parcela-13 fi-cod-titulo-14 fi-cod-esp-docto-14 fi-cod-parcela-14 ~
rs-mostra c-arquivo fi-txt-etiq fi-Cod-Cli-1 fi-Cod-Cli-2 fi-Cod-Cli-3 ~
fi-Cod-Cli-4 fi-Cod-Cli-5 fi-Cod-Cli-6 fi-Cod-Cli-7 fi-Cod-Cli-8 ~
fi-Cod-Cli-9 fi-Cod-Cli-10 fi-Cod-Cli-11 fi-Cod-Cli-12 fi-Cod-Cli-13 ~
fi-Cod-Cli-14 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cfimp 
     IMAGE-UP FILE "image/im-pri.bmp":U
     LABEL "" 
     SIZE 3.86 BY 1.08 TOOLTIP "Layout ImpressÆo".

DEFINE BUTTON bt-imprime-2 
     LABEL "Imprimir" 
     SIZE 11.14 BY 1 TOOLTIP "Imprimir"
     FONT 1.

DEFINE BUTTON bt-salva 
     LABEL "Fechar" 
     SIZE 11.14 BY 1 TOOLTIP "Fechar/Salvar"
     FONT 1.

DEFINE VARIABLE c-arquivo AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 73 BY .88 TOOLTIP "Destino"
     BGCOLOR 15 FONT 1 NO-UNDO.

DEFINE VARIABLE fi-Cod-Cli-1 AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Cod-Cli-10 AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Cod-Cli-11 AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Cod-Cli-12 AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Cod-Cli-13 AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Cod-Cli-14 AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Cod-Cli-2 AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Cod-Cli-3 AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Cod-Cli-4 AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Cod-Cli-5 AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Cod-Cli-6 AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Cod-Cli-7 AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Cod-Cli-8 AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE fi-Cod-Cli-9 AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Cliente" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-esp-docto-1 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Esp‚cie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-esp-docto-10 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Esp‚cie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-esp-docto-11 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Esp‚cie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-esp-docto-12 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Esp‚cie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-esp-docto-13 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Esp‚cie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-esp-docto-14 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Esp‚cie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-esp-docto-2 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Esp‚cie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-esp-docto-3 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Esp‚cie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-esp-docto-4 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Esp‚cie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-esp-docto-5 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Esp‚cie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-esp-docto-6 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Esp‚cie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-esp-docto-7 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Esp‚cie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-esp-docto-8 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Esp‚cie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-esp-docto-9 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Esp‚cie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-ser-docto-1 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-ser-docto-10 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-ser-docto-11 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-ser-docto-12 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-ser-docto-13 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-ser-docto-14 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-ser-docto-2 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-ser-docto-3 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-ser-docto-4 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-ser-docto-5 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-ser-docto-6 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-ser-docto-7 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-ser-docto-8 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-ser-docto-9 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. S‚rie" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-parcela-1 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Parcela" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-parcela-10 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Parcela" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-parcela-11 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Parcela" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-parcela-12 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Parcela" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-parcela-13 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Parcela" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-parcela-14 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Parcela" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-parcela-2 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Parcela" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-parcela-3 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Parcela" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-parcela-4 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Parcela" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-parcela-5 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Parcela" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-parcela-6 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Parcela" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-parcela-7 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Parcela" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-parcela-8 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Parcela" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-parcela-9 AS CHARACTER FORMAT "X(3)":U 
     LABEL "C¢d. Parcela" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-titulo-1 AS CHARACTER FORMAT "X(10)":U 
     LABEL "1-E     C¢d. Titulo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-titulo-10 AS CHARACTER FORMAT "X(10)":U 
     LABEL "5-D     C¢d. Titulo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-titulo-11 AS CHARACTER FORMAT "X(10)":U 
     LABEL "6-E     C¢d. Titulo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-titulo-12 AS CHARACTER FORMAT "X(10)":U 
     LABEL "6-D     C¢d. Titulo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-titulo-13 AS CHARACTER FORMAT "X(10)":U 
     LABEL "7-E     C¢d. Titulo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-titulo-14 AS CHARACTER FORMAT "X(10)":U 
     LABEL "7-D     C¢d. Titulo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-titulo-2 AS CHARACTER FORMAT "X(10)":U 
     LABEL "1-D     C¢d. Titulo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-titulo-3 AS CHARACTER FORMAT "X(10)":U 
     LABEL "2-E     C¢d. Titulo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-titulo-4 AS CHARACTER FORMAT "X(10)":U 
     LABEL "2-D     C¢d. Titulo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-titulo-5 AS CHARACTER FORMAT "X(10)":U 
     LABEL "3-E     C¢d. Titulo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-titulo-6 AS CHARACTER FORMAT "X(10)":U 
     LABEL "3-D     C¢d. Titulo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-titulo-7 AS CHARACTER FORMAT "X(10)":U 
     LABEL "4-E     C¢d. Titulo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-titulo-8 AS CHARACTER FORMAT "X(10)":U 
     LABEL "4-D     C¢d. Titulo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-cod-titulo-9 AS CHARACTER FORMAT "X(10)":U 
     LABEL "5-E     C¢d. Titulo" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .79 NO-UNDO.

DEFINE VARIABLE fi-txt-etiq AS CHARACTER FORMAT "X(40)":U 
     LABEL "Texto etiqueta" 
     VIEW-AS FILL-IN 
     SIZE 45 BY .79 NO-UNDO.

DEFINE VARIABLE rs-mostra AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Cliente", 1,
"T¡tulo", 2
     SIZE 21 BY .75 NO-UNDO.

DEFINE VARIABLE rs-end AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Cobran‡a", 1,
          "Cliente", 2
     SIZE 21 BY .75 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 82 BY 2.5.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 82 BY 14.25.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 82 BY 1.54
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 82 BY 1.83.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-relat
     fi-cod-titulo-1 AT ROW 4 COL 16 COLON-ALIGNED
     fi-cod-esp-docto-1 AT ROW 4 COL 40 COLON-ALIGNED
     fi-cod-ser-docto-1 AT ROW 4 COL 55 COLON-ALIGNED
     fi-cod-parcela-1 AT ROW 4 COL 73 COLON-ALIGNED
     fi-cod-titulo-2 AT ROW 5 COL 16 COLON-ALIGNED
     fi-cod-esp-docto-2 AT ROW 5 COL 40 COLON-ALIGNED
     fi-cod-ser-docto-2 AT ROW 5 COL 55 COLON-ALIGNED
     fi-cod-parcela-2 AT ROW 5 COL 73 COLON-ALIGNED
     fi-cod-titulo-3 AT ROW 6 COL 16 COLON-ALIGNED
     fi-cod-esp-docto-3 AT ROW 6 COL 40 COLON-ALIGNED
     fi-cod-ser-docto-3 AT ROW 6 COL 55 COLON-ALIGNED
     fi-cod-parcela-3 AT ROW 6 COL 73 COLON-ALIGNED
     fi-cod-titulo-4 AT ROW 7 COL 16 COLON-ALIGNED
     fi-cod-esp-docto-4 AT ROW 7 COL 40 COLON-ALIGNED
     fi-cod-ser-docto-4 AT ROW 7 COL 55 COLON-ALIGNED
     fi-cod-parcela-4 AT ROW 7 COL 73 COLON-ALIGNED
     fi-cod-titulo-5 AT ROW 8 COL 16 COLON-ALIGNED
     fi-cod-esp-docto-5 AT ROW 8 COL 40 COLON-ALIGNED
     fi-cod-ser-docto-5 AT ROW 8 COL 55 COLON-ALIGNED
     fi-cod-parcela-5 AT ROW 8 COL 73 COLON-ALIGNED
     fi-cod-titulo-6 AT ROW 9 COL 16 COLON-ALIGNED
     fi-cod-esp-docto-6 AT ROW 9 COL 40 COLON-ALIGNED
     fi-cod-ser-docto-6 AT ROW 9 COL 55 COLON-ALIGNED
     fi-cod-parcela-6 AT ROW 9 COL 73 COLON-ALIGNED
     fi-cod-titulo-7 AT ROW 10 COL 16 COLON-ALIGNED
     fi-cod-esp-docto-7 AT ROW 10 COL 40 COLON-ALIGNED
     fi-cod-ser-docto-7 AT ROW 10 COL 55 COLON-ALIGNED
     fi-cod-parcela-7 AT ROW 10 COL 73 COLON-ALIGNED
     fi-cod-titulo-8 AT ROW 11 COL 16 COLON-ALIGNED
     fi-cod-esp-docto-8 AT ROW 11 COL 40 COLON-ALIGNED
     fi-cod-ser-docto-8 AT ROW 11 COL 55 COLON-ALIGNED
     fi-cod-parcela-8 AT ROW 11 COL 73 COLON-ALIGNED
     fi-cod-titulo-9 AT ROW 12 COL 16 COLON-ALIGNED
     fi-cod-esp-docto-9 AT ROW 12 COL 40 COLON-ALIGNED
     fi-cod-ser-docto-9 AT ROW 12 COL 55 COLON-ALIGNED
     fi-cod-parcela-9 AT ROW 12 COL 73 COLON-ALIGNED
     fi-cod-titulo-10 AT ROW 13 COL 16 COLON-ALIGNED
     fi-cod-esp-docto-10 AT ROW 13 COL 40 COLON-ALIGNED
     fi-cod-ser-docto-10 AT ROW 13 COL 55 COLON-ALIGNED
     fi-cod-parcela-10 AT ROW 13 COL 73 COLON-ALIGNED
     fi-cod-titulo-11 AT ROW 14 COL 16 COLON-ALIGNED
     fi-cod-esp-docto-11 AT ROW 14 COL 40 COLON-ALIGNED
     fi-cod-ser-docto-11 AT ROW 14 COL 55 COLON-ALIGNED
     fi-cod-parcela-11 AT ROW 14 COL 73 COLON-ALIGNED
     fi-cod-titulo-12 AT ROW 15 COL 16 COLON-ALIGNED
     fi-cod-esp-docto-12 AT ROW 15 COL 40 COLON-ALIGNED
     fi-cod-ser-docto-12 AT ROW 15 COL 55 COLON-ALIGNED
     fi-cod-parcela-12 AT ROW 15 COL 73 COLON-ALIGNED
     fi-cod-titulo-13 AT ROW 16 COL 16 COLON-ALIGNED
     fi-cod-esp-docto-13 AT ROW 16 COL 40 COLON-ALIGNED
     fi-cod-ser-docto-13 AT ROW 16 COL 55 COLON-ALIGNED
     fi-cod-parcela-13 AT ROW 16 COL 73 COLON-ALIGNED
     fi-cod-titulo-14 AT ROW 17 COL 16 COLON-ALIGNED
     fi-cod-esp-docto-14 AT ROW 17 COL 40 COLON-ALIGNED
     fi-cod-ser-docto-14 AT ROW 17 COL 55 COLON-ALIGNED
     fi-cod-parcela-14 AT ROW 17 COL 73 COLON-ALIGNED
     rs-mostra AT ROW 1.5 COL 3 NO-LABEL
     rs-end AT ROW 2.5 COL 3 LABEL "Endere‡o"
     c-arquivo AT ROW 19.08 COL 3 HELP
          "Destino" NO-LABEL
     bt-salva AT ROW 20.75 COL 70
     bt-cfimp AT ROW 19 COL 77 HELP
          "Layout ImpressÆo"
     fi-txt-etiq AT ROW 1.5 COL 35 COLON-ALIGNED
     fi-Cod-Cli-1 AT ROW 4.5 COL 23 COLON-ALIGNED
     fi-Cod-Cli-2 AT ROW 4.5 COL 51 COLON-ALIGNED
     fi-Cod-Cli-3 AT ROW 5.75 COL 23 COLON-ALIGNED
     fi-Cod-Cli-4 AT ROW 5.75 COL 51 COLON-ALIGNED
     fi-Cod-Cli-5 AT ROW 7 COL 23 COLON-ALIGNED
     fi-Cod-Cli-6 AT ROW 7 COL 51 COLON-ALIGNED
     fi-Cod-Cli-7 AT ROW 8.25 COL 23 COLON-ALIGNED
     fi-Cod-Cli-8 AT ROW 8.25 COL 51 COLON-ALIGNED
     fi-Cod-Cli-9 AT ROW 9.5 COL 23 COLON-ALIGNED
     fi-Cod-Cli-10 AT ROW 9.5 COL 51 COLON-ALIGNED
     fi-Cod-Cli-11 AT ROW 10.75 COL 23 COLON-ALIGNED
     fi-Cod-Cli-12 AT ROW 10.75 COL 51 COLON-ALIGNED
     fi-Cod-Cli-13 AT ROW 12 COL 23 COLON-ALIGNED
     fi-Cod-Cli-14 AT ROW 12 COL 51 COLON-ALIGNED
     bt-imprime-2 AT ROW 20.75 COL 58
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 82.86 BY 21.46
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-relat
     "  ImpressÆo" VIEW-AS TEXT
          SIZE 10.57 BY .54 AT ROW 18.25 COL 2
          FONT 6
     RECT-2 AT ROW 20.5 COL 1
     RECT-7 AT ROW 18.42 COL 1
     RECT-11 AT ROW 1 COL 1
     RECT-12 AT ROW 3.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 82.86 BY 21.46
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ImpressÆo de Etiquetas - ESACR023"
         COLUMN             = 34.29
         ROW                = 7.67
         HEIGHT             = 21.33
         WIDTH              = 82.29
         MAX-HEIGHT         = 39.79
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 39.79
         VIRTUAL-WIDTH      = 182.86
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 1
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-relat
   Custom                                                               */
/* SETTINGS FOR FILL-IN c-arquivo IN FRAME f-relat
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-relat
/* Query rebuild information for FRAME f-relat
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME f-relat */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* ImpressÆo de Etiquetas - ESACR023 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* ImpressÆo de Etiquetas - ESACR023 */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cfimp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cfimp C-Win
ON CHOOSE OF bt-cfimp IN FRAME f-relat
DO:
    assign c-ant = c-arquivo:screen-value in frame f-relat.
  
    run prgtec/btb/btb036nb.p (output c-impressora, output c-layout).
    
    if c-arquivo <> ":" then
      assign c-arquivo = c-impressora + ":" + c-layout.
    else
      assign c-arquivo = c-ant.
      
    disp c-arquivo with frame f-relat.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-imprime-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-imprime-2 C-Win
ON CHOOSE OF bt-imprime-2 IN FRAME f-relat /* Imprimir */
DO:
    IF int(rs-mostra:SCREEN-VALUE IN FRAME f-relat) = 1 THEN DO:
       RUN pi-configura.
       RUN pi-Imprime-Cliente1.
       OUTPUT STREAM STREAM_1 CLOSE.
    END.
    ELSE DO:
        RUN pi-configura.
        RUN pi-Imprime-Titulo.      
        OUTPUT STREAM STREAM_1 CLOSE.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-salva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-salva C-Win
ON CHOOSE OF bt-salva IN FRAME f-relat /* Fechar */
DO:  
  APPLY "close" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Cod-Cli-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-1 C-Win
ON LEAVE OF fi-Cod-Cli-1 IN FRAME f-relat /* Cliente */
DO:



    IF INT(fi-cod-cli-1:SCREEN-VALUE) <> 0 THEN DO:
      IF NOT CAN-FIND(FIRST emitente NO-LOCK WHERE 
         emitente.cod-emitente = int(fi-cod-cli-1:SCREEN-VALUE)) THEN DO:
         RUN pi-Mensagem.
         RETURN NO-APPLY. 
      END.
   END.


   ASSIGN i-cli[1] = int(fi-cod-cli-1:SCREEN-VALUE).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Cod-Cli-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-10 C-Win
ON LEAVE OF fi-Cod-Cli-10 IN FRAME f-relat /* Cliente */
DO:
    IF INT(fi-cod-cli-10:SCREEN-VALUE) <> 0 THEN DO:
      IF NOT CAN-FIND(FIRST emitente NO-LOCK WHERE 
         emitente.cod-emitente = int(fi-cod-cli-10:SCREEN-VALUE)) THEN DO:
         RUN pi-Mensagem.
         RETURN NO-APPLY.
      END.
   END.
      ASSIGN i-cli[10] = int(fi-cod-cli-10:SCREEN-VALUE).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-10 C-Win
ON MOUSE-SELECT-DBLCLICK OF fi-Cod-Cli-10 IN FRAME f-relat /* Cliente */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Cod-Cli-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-11 C-Win
ON LEAVE OF fi-Cod-Cli-11 IN FRAME f-relat /* Cliente */
DO:
    IF INT(fi-cod-cli-11:SCREEN-VALUE) <> 0 THEN DO:
      IF NOT CAN-FIND(FIRST emitente NO-LOCK WHERE 
         emitente.cod-emitente = int(fi-cod-cli-11:SCREEN-VALUE)) THEN DO:
         RUN pi-Mensagem.
         RETURN NO-APPLY.
      END.
   END.
      ASSIGN i-cli[11] = int(fi-cod-cli-11:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-11 C-Win
ON MOUSE-SELECT-DBLCLICK OF fi-Cod-Cli-11 IN FRAME f-relat /* Cliente */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Cod-Cli-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-12 C-Win
ON LEAVE OF fi-Cod-Cli-12 IN FRAME f-relat /* Cliente */
DO:
    IF INT(fi-cod-cli-12:SCREEN-VALUE) <> 0 THEN DO:
      IF NOT CAN-FIND(FIRST emitente NO-LOCK WHERE 
         emitente.cod-emitente = int(fi-cod-cli-12:SCREEN-VALUE)) THEN DO:
         RUN pi-Mensagem.
         RETURN NO-APPLY.
      END.
   END.
      ASSIGN i-cli[12] = int(fi-cod-cli-12:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-12 C-Win
ON MOUSE-SELECT-DBLCLICK OF fi-Cod-Cli-12 IN FRAME f-relat /* Cliente */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Cod-Cli-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-13 C-Win
ON LEAVE OF fi-Cod-Cli-13 IN FRAME f-relat /* Cliente */
DO:
    IF INT(fi-cod-cli-13:SCREEN-VALUE) <> 0 THEN DO:
      IF NOT CAN-FIND(FIRST emitente NO-LOCK WHERE 
         emitente.cod-emitente = int(fi-cod-cli-13:SCREEN-VALUE)) THEN DO:
         RUN pi-Mensagem.
         RETURN NO-APPLY.
      END.
   END.
      ASSIGN i-cli[13] = int(fi-cod-cli-13:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-13 C-Win
ON MOUSE-SELECT-DBLCLICK OF fi-Cod-Cli-13 IN FRAME f-relat /* Cliente */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Cod-Cli-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-14 C-Win
ON LEAVE OF fi-Cod-Cli-14 IN FRAME f-relat /* Cliente */
DO:
    IF INT(fi-cod-cli-14:SCREEN-VALUE) <> 0 THEN DO:
      IF NOT CAN-FIND(FIRST emitente NO-LOCK WHERE 
         emitente.cod-emitente = int(fi-cod-cli-14:SCREEN-VALUE)) THEN DO:
         RUN pi-Mensagem.
         RETURN NO-APPLY.
      END.
   END.
      ASSIGN i-cli[14] = int(fi-cod-cli-14:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-14 C-Win
ON MOUSE-SELECT-DBLCLICK OF fi-Cod-Cli-14 IN FRAME f-relat /* Cliente */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Cod-Cli-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-2 C-Win
ON LEAVE OF fi-Cod-Cli-2 IN FRAME f-relat /* Cliente */
DO:
    IF INT(fi-cod-cli-2:SCREEN-VALUE) <> 0 THEN DO:
      IF NOT CAN-FIND(FIRST emitente NO-LOCK WHERE 
         emitente.cod-emitente = int(fi-cod-cli-2:SCREEN-VALUE)) THEN DO:
         RUN pi-Mensagem.
         RETURN NO-APPLY. 
      END.
   END.
      ASSIGN i-cli[2] = int(fi-cod-cli-2:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Cod-Cli-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-3 C-Win
ON LEAVE OF fi-Cod-Cli-3 IN FRAME f-relat /* Cliente */
DO:
    IF INT(fi-cod-cli-3:SCREEN-VALUE) <> 0 THEN DO:
      IF NOT CAN-FIND(FIRST emitente NO-LOCK WHERE 
         emitente.cod-emitente = int(fi-cod-cli-3:SCREEN-VALUE)) THEN DO:
         RUN pi-Mensagem.
         RETURN NO-APPLY.
      END.
   END.
      ASSIGN i-cli[3] = int(fi-cod-cli-3:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-3 C-Win
ON MOUSE-SELECT-DBLCLICK OF fi-Cod-Cli-3 IN FRAME f-relat /* Cliente */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Cod-Cli-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-4 C-Win
ON LEAVE OF fi-Cod-Cli-4 IN FRAME f-relat /* Cliente */
DO:
    IF INT(fi-cod-cli-4:SCREEN-VALUE) <> 0 THEN DO:
      IF NOT CAN-FIND(FIRST emitente NO-LOCK WHERE 
         emitente.cod-emitente = int(fi-cod-cli-4:SCREEN-VALUE)) THEN DO:
         RUN pi-Mensagem.
         RETURN NO-APPLY.
      END.
   END.
      ASSIGN i-cli[4] = int(fi-cod-cli-4:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-4 C-Win
ON MOUSE-SELECT-DBLCLICK OF fi-Cod-Cli-4 IN FRAME f-relat /* Cliente */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Cod-Cli-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-5 C-Win
ON LEAVE OF fi-Cod-Cli-5 IN FRAME f-relat /* Cliente */
DO:
    IF INT(fi-cod-cli-5:SCREEN-VALUE) <> 0 THEN DO:
      IF NOT CAN-FIND(FIRST emitente NO-LOCK WHERE 
         emitente.cod-emitente = int(fi-cod-cli-5:SCREEN-VALUE)) THEN DO:
         RUN pi-Mensagem.
         RETURN NO-APPLY.
      END.
   END.
   ASSIGN i-cli[5] = int(fi-cod-cli-5:SCREEN-VALUE).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-5 C-Win
ON MOUSE-SELECT-DBLCLICK OF fi-Cod-Cli-5 IN FRAME f-relat /* Cliente */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Cod-Cli-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-6 C-Win
ON LEAVE OF fi-Cod-Cli-6 IN FRAME f-relat /* Cliente */
DO:
    IF INT(fi-cod-cli-6:SCREEN-VALUE) <> 0 THEN DO:
      IF NOT CAN-FIND(FIRST emitente NO-LOCK WHERE 
         emitente.cod-emitente = int(fi-cod-cli-6:SCREEN-VALUE)) THEN DO:
         RUN pi-Mensagem.
         RETURN NO-APPLY.
      END.
   END.
   ASSIGN i-cli[6] = int(fi-cod-cli-6:SCREEN-VALUE).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-6 C-Win
ON MOUSE-SELECT-DBLCLICK OF fi-Cod-Cli-6 IN FRAME f-relat /* Cliente */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Cod-Cli-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-7 C-Win
ON LEAVE OF fi-Cod-Cli-7 IN FRAME f-relat /* Cliente */
DO:
    IF INT(fi-cod-cli-7:SCREEN-VALUE) <> 0 THEN DO:
      IF NOT CAN-FIND(FIRST emitente NO-LOCK WHERE 
         emitente.cod-emitente = int(fi-cod-cli-7:SCREEN-VALUE)) THEN DO:
         RUN pi-Mensagem.
         RETURN NO-APPLY.
      END.
   END.
   ASSIGN i-cli[7] = int(fi-cod-cli-7:SCREEN-VALUE).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-7 C-Win
ON MOUSE-SELECT-DBLCLICK OF fi-Cod-Cli-7 IN FRAME f-relat /* Cliente */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Cod-Cli-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-8 C-Win
ON LEAVE OF fi-Cod-Cli-8 IN FRAME f-relat /* Cliente */
DO:
    IF INT(fi-cod-cli-8:SCREEN-VALUE) <> 0 THEN DO:
      IF NOT CAN-FIND(FIRST emitente NO-LOCK WHERE 
         emitente.cod-emitente = int(fi-cod-cli-8:SCREEN-VALUE)) THEN DO:
         RUN pi-Mensagem.
         RETURN NO-APPLY.
      END.
   END.
   ASSIGN i-cli[8] = int(fi-cod-cli-8:SCREEN-VALUE).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-8 C-Win
ON MOUSE-SELECT-DBLCLICK OF fi-Cod-Cli-8 IN FRAME f-relat /* Cliente */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-Cod-Cli-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-9 C-Win
ON LEAVE OF fi-Cod-Cli-9 IN FRAME f-relat /* Cliente */
DO:
    IF INT(fi-cod-cli-9:SCREEN-VALUE) <> 0 THEN DO:
      IF NOT CAN-FIND(FIRST emitente NO-LOCK WHERE 
         emitente.cod-emitente = int(fi-cod-cli-9:SCREEN-VALUE)) THEN DO:
         RUN pi-Mensagem.
         RETURN NO-APPLY.
      END.
   END.
   ASSIGN i-cli[9] = int(fi-cod-cli-9:SCREEN-VALUE).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-Cod-Cli-9 C-Win
ON MOUSE-SELECT-DBLCLICK OF fi-Cod-Cli-9 IN FRAME f-relat /* Cliente */
DO:

/*
    {include/zoomvar.i &prog-zoom="adzoom/z01in098.r"
                       &campo="fi-Cod-Emitente"
                      /* &campozoom="it-codigo" */ }.  
                       
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-parcela-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-parcela-1 C-Win
ON LEAVE OF fi-cod-parcela-1 IN FRAME f-relat /* C¢d. Parcela */
DO:
    IF fi-cod-titulo-1:SCREEN-VALUE <> "" THEN DO:
       IF NOT CAN-FIND(FIRST tit_acr NO-LOCK                                           
                       WHERE tit_acr.cod_estab       = v_cod_estab_usuar               
                         AND tit_acr.cod_espec_docto = fi-cod-esp-docto-1:SCREEN-VALUE
                         AND tit_acr.cod_ser         = fi-cod-ser-docto-1:SCREEN-VALUE
                         AND tit_acr.cod_tit_acr     = fi-cod-titulo-1:SCREEN-VALUE   
                         AND tit_acr.cod_parcela     = fi-cod-parcela-1:SCREEN-VALUE)  THEN DO:
            
          RUN pi-Mensagem2.
          fi-cod-titulo-1:SCREEN-VALUE    = "".
          fi-cod-esp-docto-1:SCREEN-VALUE = "".
          fi-cod-ser-docto-1:SCREEN-VALUE = "".
          fi-cod-parcela-1:SCREEN-VALUE   = "".  
          APPLY "entry" TO fi-cod-titulo-1 IN FRAME f-relat.
          RETURN NO-APPLY.
       END.
           
       ASSIGN i-nr-docto[1] = fi-cod-titulo-1:SCREEN-VALUE IN FRAME    f-relat.
       ASSIGN c-cod-esp[1]  = fi-cod-esp-docto-1:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN c-cod-ser[1]  = fi-cod-ser-docto-1:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN i-parcela[1]  = fi-cod-parcela-1:SCREEN-VALUE IN FRAME   f-relat.

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-parcela-10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-parcela-10 C-Win
ON LEAVE OF fi-cod-parcela-10 IN FRAME f-relat /* C¢d. Parcela */
DO:
    IF fi-cod-titulo-10:SCREEN-VALUE <> "" THEN DO:
       IF NOT CAN-FIND(FIRST tit_acr NO-LOCK                                           
                       WHERE tit_acr.cod_estab       = v_cod_estab_usuar               
                         AND tit_acr.cod_espec_docto = fi-cod-esp-docto-10:SCREEN-VALUE
                         AND tit_acr.cod_ser         = fi-cod-ser-docto-10:SCREEN-VALUE
                         AND tit_acr.cod_tit_acr     = fi-cod-titulo-10:SCREEN-VALUE   
                         AND tit_acr.cod_parcela     = fi-cod-parcela-10:SCREEN-VALUE)  THEN DO:
            
          RUN pi-Mensagem2.
          fi-cod-titulo-10:SCREEN-VALUE    = "".
          fi-cod-esp-docto-10:SCREEN-VALUE = "".
          fi-cod-ser-docto-10:SCREEN-VALUE = "".
          fi-cod-parcela-10:SCREEN-VALUE   = "".  
          APPLY "entry" TO fi-cod-titulo-10 IN FRAME f-relat.
          RETURN NO-APPLY.
       END.
           
       ASSIGN i-nr-docto[10] = fi-cod-titulo-10:SCREEN-VALUE IN FRAME    f-relat.
       ASSIGN c-cod-esp[10]  = fi-cod-esp-docto-10:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN c-cod-ser[10]  = fi-cod-ser-docto-10:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN i-parcela[10]  = fi-cod-parcela-10:SCREEN-VALUE IN FRAME   f-relat.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-parcela-11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-parcela-11 C-Win
ON LEAVE OF fi-cod-parcela-11 IN FRAME f-relat /* C¢d. Parcela */
DO:
    IF fi-cod-titulo-11:SCREEN-VALUE <> "" THEN DO:
       IF NOT CAN-FIND(FIRST tit_acr NO-LOCK                                           
                       WHERE tit_acr.cod_estab       = v_cod_estab_usuar               
                         AND tit_acr.cod_espec_docto = fi-cod-esp-docto-11:SCREEN-VALUE
                         AND tit_acr.cod_ser         = fi-cod-ser-docto-11:SCREEN-VALUE
                         AND tit_acr.cod_tit_acr     = fi-cod-titulo-11:SCREEN-VALUE   
                         AND tit_acr.cod_parcela     = fi-cod-parcela-11:SCREEN-VALUE)  THEN DO:
            
          RUN pi-Mensagem2.
          fi-cod-titulo-11:SCREEN-VALUE    = "".
          fi-cod-esp-docto-11:SCREEN-VALUE = "".
          fi-cod-ser-docto-11:SCREEN-VALUE = "".
          fi-cod-parcela-11:SCREEN-VALUE   = "".  
          APPLY "entry" TO fi-cod-titulo-11 IN FRAME f-relat.
          RETURN NO-APPLY.
       END.
           
       ASSIGN i-nr-docto[11] = fi-cod-titulo-11:SCREEN-VALUE IN FRAME    f-relat.
       ASSIGN c-cod-esp[11]  = fi-cod-esp-docto-11:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN c-cod-ser[11]  = fi-cod-ser-docto-11:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN i-parcela[11]  = fi-cod-parcela-11:SCREEN-VALUE IN FRAME   f-relat.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-parcela-12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-parcela-12 C-Win
ON LEAVE OF fi-cod-parcela-12 IN FRAME f-relat /* C¢d. Parcela */
DO:
    IF fi-cod-titulo-12:SCREEN-VALUE <> "" THEN DO:
       IF NOT CAN-FIND(FIRST tit_acr NO-LOCK                                           
                       WHERE tit_acr.cod_estab       = v_cod_estab_usuar               
                         AND tit_acr.cod_espec_docto = fi-cod-esp-docto-12:SCREEN-VALUE
                         AND tit_acr.cod_ser         = fi-cod-ser-docto-12:SCREEN-VALUE
                         AND tit_acr.cod_tit_acr     = fi-cod-titulo-12:SCREEN-VALUE   
                         AND tit_acr.cod_parcela     = fi-cod-parcela-12:SCREEN-VALUE)  THEN DO:
            
          RUN pi-Mensagem2.
          fi-cod-titulo-12:SCREEN-VALUE    = "".
          fi-cod-esp-docto-12:SCREEN-VALUE = "".
          fi-cod-ser-docto-12:SCREEN-VALUE = "".
          fi-cod-parcela-12:SCREEN-VALUE   = "".  
          APPLY "entry" TO fi-cod-titulo-12 IN FRAME f-relat.
          RETURN NO-APPLY.
       END.
           
       ASSIGN i-nr-docto[12] = fi-cod-titulo-12:SCREEN-VALUE IN FRAME    f-relat.
       ASSIGN c-cod-esp[12]  = fi-cod-esp-docto-12:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN c-cod-ser[12]  = fi-cod-ser-docto-12:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN i-parcela[12]  = fi-cod-parcela-12:SCREEN-VALUE IN FRAME   f-relat.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-parcela-13
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-parcela-13 C-Win
ON LEAVE OF fi-cod-parcela-13 IN FRAME f-relat /* C¢d. Parcela */
DO:
    IF fi-cod-titulo-13:SCREEN-VALUE <> "" THEN DO:
       IF NOT CAN-FIND(FIRST tit_acr NO-LOCK                                           
                       WHERE tit_acr.cod_estab       = v_cod_estab_usuar               
                         AND tit_acr.cod_espec_docto = fi-cod-esp-docto-13:SCREEN-VALUE
                         AND tit_acr.cod_ser         = fi-cod-ser-docto-13:SCREEN-VALUE
                         AND tit_acr.cod_tit_acr     = fi-cod-titulo-13:SCREEN-VALUE   
                         AND tit_acr.cod_parcela     = fi-cod-parcela-13:SCREEN-VALUE)  THEN DO:
            
          RUN pi-Mensagem2.
          fi-cod-titulo-13:SCREEN-VALUE    = "".
          fi-cod-esp-docto-13:SCREEN-VALUE = "".
          fi-cod-ser-docto-13:SCREEN-VALUE = "".
          fi-cod-parcela-13:SCREEN-VALUE   = "".  
          APPLY "entry" TO fi-cod-titulo-13 IN FRAME f-relat.
          RETURN NO-APPLY.
       END.
           
       ASSIGN i-nr-docto[13] = fi-cod-titulo-13:SCREEN-VALUE IN FRAME    f-relat.
       ASSIGN c-cod-esp[13]  = fi-cod-esp-docto-13:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN c-cod-ser[13]  = fi-cod-ser-docto-13:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN i-parcela[13]  = fi-cod-parcela-13:SCREEN-VALUE IN FRAME   f-relat.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-parcela-14
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-parcela-14 C-Win
ON LEAVE OF fi-cod-parcela-14 IN FRAME f-relat /* C¢d. Parcela */
DO:
    IF fi-cod-titulo-14:SCREEN-VALUE <> "" THEN DO:
       IF NOT CAN-FIND(FIRST tit_acr NO-LOCK                                           
                       WHERE tit_acr.cod_estab       = v_cod_estab_usuar               
                         AND tit_acr.cod_espec_docto = fi-cod-esp-docto-14:SCREEN-VALUE
                         AND tit_acr.cod_ser         = fi-cod-ser-docto-14:SCREEN-VALUE
                         AND tit_acr.cod_tit_acr     = fi-cod-titulo-14:SCREEN-VALUE   
                         AND tit_acr.cod_parcela     = fi-cod-parcela-14:SCREEN-VALUE)  THEN DO:
            
          RUN pi-Mensagem2.
          fi-cod-titulo-14:SCREEN-VALUE    = "".
          fi-cod-esp-docto-14:SCREEN-VALUE = "".
          fi-cod-ser-docto-14:SCREEN-VALUE = "".
          fi-cod-parcela-14:SCREEN-VALUE   = "".  
          APPLY "entry" TO fi-cod-titulo-14 IN FRAME f-relat.
          RETURN NO-APPLY.
       END.
           
       ASSIGN i-nr-docto[14] = fi-cod-titulo-1:SCREEN-VALUE IN FRAME    f-relat.
       ASSIGN c-cod-esp[14]  = fi-cod-esp-docto-14:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN c-cod-ser[14]  = fi-cod-ser-docto-14:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN i-parcela[14]  = fi-cod-parcela-14:SCREEN-VALUE IN FRAME   f-relat.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-parcela-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-parcela-2 C-Win
ON LEAVE OF fi-cod-parcela-2 IN FRAME f-relat /* C¢d. Parcela */
DO:
    IF fi-cod-titulo-2:SCREEN-VALUE <> "" THEN DO:
       IF NOT CAN-FIND(FIRST tit_acr NO-LOCK                                           
                       WHERE tit_acr.cod_estab       = v_cod_estab_usuar               
                         AND tit_acr.cod_espec_docto = fi-cod-esp-docto-2:SCREEN-VALUE
                         AND tit_acr.cod_ser         = fi-cod-ser-docto-2:SCREEN-VALUE
                         AND tit_acr.cod_tit_acr     = fi-cod-titulo-2:SCREEN-VALUE   
                         AND tit_acr.cod_parcela     = fi-cod-parcela-2:SCREEN-VALUE)  THEN DO:
            
          RUN pi-Mensagem2.
          fi-cod-titulo-2:SCREEN-VALUE    = "".
          fi-cod-esp-docto-2:SCREEN-VALUE = "".
          fi-cod-ser-docto-2:SCREEN-VALUE = "".
          fi-cod-parcela-2:SCREEN-VALUE   = "".  
          APPLY "entry" TO fi-cod-titulo-2 IN FRAME f-relat.
          RETURN NO-APPLY.
       END.
           
       ASSIGN i-nr-docto[2] = fi-cod-titulo-2:SCREEN-VALUE IN FRAME    f-relat.
       ASSIGN c-cod-esp[2]  = fi-cod-esp-docto-2:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN c-cod-ser[2]  = fi-cod-ser-docto-2:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN i-parcela[2]  = fi-cod-parcela-2:SCREEN-VALUE IN FRAME   f-relat.

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-parcela-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-parcela-3 C-Win
ON LEAVE OF fi-cod-parcela-3 IN FRAME f-relat /* C¢d. Parcela */
DO:
    IF fi-cod-titulo-3:SCREEN-VALUE <> "" THEN DO:
       IF NOT CAN-FIND(FIRST tit_acr NO-LOCK                                           
                       WHERE tit_acr.cod_estab       = v_cod_estab_usuar               
                         AND tit_acr.cod_espec_docto = fi-cod-esp-docto-3:SCREEN-VALUE
                         AND tit_acr.cod_ser         = fi-cod-ser-docto-3:SCREEN-VALUE
                         AND tit_acr.cod_tit_acr     = fi-cod-titulo-3:SCREEN-VALUE   
                         AND tit_acr.cod_parcela     = fi-cod-parcela-3:SCREEN-VALUE)  THEN DO:
            
          RUN pi-Mensagem2.
          fi-cod-titulo-3:SCREEN-VALUE    = "".
          fi-cod-esp-docto-3:SCREEN-VALUE = "".
          fi-cod-ser-docto-3:SCREEN-VALUE = "".
          fi-cod-parcela-3:SCREEN-VALUE   = "".  
          APPLY "entry" TO fi-cod-titulo-3 IN FRAME f-relat.
          RETURN NO-APPLY.
       END.
           
       ASSIGN i-nr-docto[3] = fi-cod-titulo-3:SCREEN-VALUE IN FRAME    f-relat.
       ASSIGN c-cod-esp[3]  = fi-cod-esp-docto-3:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN c-cod-ser[3]  = fi-cod-ser-docto-3:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN i-parcela[3]  = fi-cod-parcela-3:SCREEN-VALUE IN FRAME   f-relat.

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-parcela-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-parcela-4 C-Win
ON LEAVE OF fi-cod-parcela-4 IN FRAME f-relat /* C¢d. Parcela */
DO:
    IF fi-cod-titulo-4:SCREEN-VALUE <> "" THEN DO:
       IF NOT CAN-FIND(FIRST tit_acr NO-LOCK                                           
                       WHERE tit_acr.cod_estab       = v_cod_estab_usuar               
                         AND tit_acr.cod_espec_docto = fi-cod-esp-docto-4:SCREEN-VALUE
                         AND tit_acr.cod_ser         = fi-cod-ser-docto-4:SCREEN-VALUE
                         AND tit_acr.cod_tit_acr     = fi-cod-titulo-4:SCREEN-VALUE   
                         AND tit_acr.cod_parcela     = fi-cod-parcela-4:SCREEN-VALUE)  THEN DO:
            
          RUN pi-Mensagem2.
          fi-cod-titulo-4:SCREEN-VALUE    = "".
          fi-cod-esp-docto-4:SCREEN-VALUE = "".
          fi-cod-ser-docto-4:SCREEN-VALUE = "".
          fi-cod-parcela-4:SCREEN-VALUE   = "".  
          APPLY "entry" TO fi-cod-titulo-4 IN FRAME f-relat.
          RETURN NO-APPLY.
       END.
           
       ASSIGN i-nr-docto[4] = fi-cod-titulo-4:SCREEN-VALUE IN FRAME    f-relat.
       ASSIGN c-cod-esp[4]  = fi-cod-esp-docto-4:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN c-cod-ser[4]  = fi-cod-ser-docto-4:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN i-parcela[4]  = fi-cod-parcela-4:SCREEN-VALUE IN FRAME   f-relat.

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-parcela-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-parcela-5 C-Win
ON LEAVE OF fi-cod-parcela-5 IN FRAME f-relat /* C¢d. Parcela */
DO:
    IF fi-cod-titulo-5:SCREEN-VALUE <> "" THEN DO:
       IF NOT CAN-FIND(FIRST tit_acr NO-LOCK                                           
                       WHERE tit_acr.cod_estab       = v_cod_estab_usuar               
                         AND tit_acr.cod_espec_docto = fi-cod-esp-docto-5:SCREEN-VALUE
                         AND tit_acr.cod_ser         = fi-cod-ser-docto-5:SCREEN-VALUE
                         AND tit_acr.cod_tit_acr     = fi-cod-titulo-5:SCREEN-VALUE   
                         AND tit_acr.cod_parcela     = fi-cod-parcela-5:SCREEN-VALUE)  THEN DO:
            
          RUN pi-Mensagem2.
          fi-cod-titulo-5:SCREEN-VALUE    = "".
          fi-cod-esp-docto-5:SCREEN-VALUE = "".
          fi-cod-ser-docto-5:SCREEN-VALUE = "".
          fi-cod-parcela-5:SCREEN-VALUE   = "".  
          APPLY "entry" TO fi-cod-titulo-5 IN FRAME f-relat.
          RETURN NO-APPLY.
       END.
           
       ASSIGN i-nr-docto[5] = fi-cod-titulo-5:SCREEN-VALUE IN FRAME    f-relat.
       ASSIGN c-cod-esp[5]  = fi-cod-esp-docto-5:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN c-cod-ser[5]  = fi-cod-ser-docto-5:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN i-parcela[5]  = fi-cod-parcela-5:SCREEN-VALUE IN FRAME   f-relat.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-parcela-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-parcela-6 C-Win
ON LEAVE OF fi-cod-parcela-6 IN FRAME f-relat /* C¢d. Parcela */
DO:
    IF fi-cod-titulo-6:SCREEN-VALUE <> "" THEN DO:
       IF NOT CAN-FIND(FIRST tit_acr NO-LOCK                                           
                       WHERE tit_acr.cod_estab       = v_cod_estab_usuar               
                         AND tit_acr.cod_espec_docto = fi-cod-esp-docto-6:SCREEN-VALUE
                         AND tit_acr.cod_ser         = fi-cod-ser-docto-6:SCREEN-VALUE
                         AND tit_acr.cod_tit_acr     = fi-cod-titulo-6:SCREEN-VALUE   
                         AND tit_acr.cod_parcela     = fi-cod-parcela-6:SCREEN-VALUE)  THEN DO:
            
          RUN pi-Mensagem2.
          fi-cod-titulo-6:SCREEN-VALUE    = "".
          fi-cod-esp-docto-6:SCREEN-VALUE = "".
          fi-cod-ser-docto-6:SCREEN-VALUE = "".
          fi-cod-parcela-6:SCREEN-VALUE   = "".  
          APPLY "entry" TO fi-cod-titulo-6 IN FRAME f-relat.
          RETURN NO-APPLY.
       END.
           
       ASSIGN i-nr-docto[6] = fi-cod-titulo-6:SCREEN-VALUE IN FRAME    f-relat.
       ASSIGN c-cod-esp[6]  = fi-cod-esp-docto-6:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN c-cod-ser[6]  = fi-cod-ser-docto-6:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN i-parcela[6]  = fi-cod-parcela-6:SCREEN-VALUE IN FRAME   f-relat.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-parcela-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-parcela-7 C-Win
ON LEAVE OF fi-cod-parcela-7 IN FRAME f-relat /* C¢d. Parcela */
DO:
    IF fi-cod-titulo-7:SCREEN-VALUE <> "" THEN DO:
       IF NOT CAN-FIND(FIRST tit_acr NO-LOCK                                           
                       WHERE tit_acr.cod_estab       = v_cod_estab_usuar               
                         AND tit_acr.cod_espec_docto = fi-cod-esp-docto-7:SCREEN-VALUE
                         AND tit_acr.cod_ser         = fi-cod-ser-docto-7:SCREEN-VALUE
                         AND tit_acr.cod_tit_acr     = fi-cod-titulo-7:SCREEN-VALUE   
                         AND tit_acr.cod_parcela     = fi-cod-parcela-7:SCREEN-VALUE)  THEN DO:
            
          RUN pi-Mensagem2.
          fi-cod-titulo-7:SCREEN-VALUE    = "".
          fi-cod-esp-docto-7:SCREEN-VALUE = "".
          fi-cod-ser-docto-7:SCREEN-VALUE = "".
          fi-cod-parcela-7:SCREEN-VALUE   = "".  
          APPLY "entry" TO fi-cod-titulo-7 IN FRAME f-relat.
          RETURN NO-APPLY.
       END.
           
       ASSIGN i-nr-docto[7] = fi-cod-titulo-7:SCREEN-VALUE IN FRAME    f-relat.
       ASSIGN c-cod-esp[7]  = fi-cod-esp-docto-7:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN c-cod-ser[7]  = fi-cod-ser-docto-7:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN i-parcela[7]  = fi-cod-parcela-7:SCREEN-VALUE IN FRAME   f-relat.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-parcela-8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-parcela-8 C-Win
ON LEAVE OF fi-cod-parcela-8 IN FRAME f-relat /* C¢d. Parcela */
DO:
    IF fi-cod-titulo-8:SCREEN-VALUE <> "" THEN DO:
       IF NOT CAN-FIND(FIRST tit_acr NO-LOCK                                           
                       WHERE tit_acr.cod_estab       = v_cod_estab_usuar               
                         AND tit_acr.cod_espec_docto = fi-cod-esp-docto-8:SCREEN-VALUE
                         AND tit_acr.cod_ser         = fi-cod-ser-docto-8:SCREEN-VALUE
                         AND tit_acr.cod_tit_acr     = fi-cod-titulo-8:SCREEN-VALUE   
                         AND tit_acr.cod_parcela     = fi-cod-parcela-8:SCREEN-VALUE)  THEN DO:
            
          RUN pi-Mensagem2.
          fi-cod-titulo-8:SCREEN-VALUE    = "".
          fi-cod-esp-docto-8:SCREEN-VALUE = "".
          fi-cod-ser-docto-8:SCREEN-VALUE = "".
          fi-cod-parcela-8:SCREEN-VALUE   = "".  
          APPLY "entry" TO fi-cod-titulo-8 IN FRAME f-relat.
          RETURN NO-APPLY.
       END.
           
       ASSIGN i-nr-docto[8] = fi-cod-titulo-8:SCREEN-VALUE IN FRAME    f-relat.
       ASSIGN c-cod-esp[8]  = fi-cod-esp-docto-8:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN c-cod-ser[8]  = fi-cod-ser-docto-8:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN i-parcela[8]  = fi-cod-parcela-8:SCREEN-VALUE IN FRAME   f-relat.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-parcela-9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-parcela-9 C-Win
ON LEAVE OF fi-cod-parcela-9 IN FRAME f-relat /* C¢d. Parcela */
DO:
    IF fi-cod-titulo-9:SCREEN-VALUE <> "" THEN DO:
       IF NOT CAN-FIND(FIRST tit_acr NO-LOCK                                           
                       WHERE tit_acr.cod_estab       = v_cod_estab_usuar               
                         AND tit_acr.cod_espec_docto = fi-cod-esp-docto-9:SCREEN-VALUE
                         AND tit_acr.cod_ser         = fi-cod-ser-docto-9:SCREEN-VALUE
                         AND tit_acr.cod_tit_acr     = fi-cod-titulo-9:SCREEN-VALUE   
                         AND tit_acr.cod_parcela     = fi-cod-parcela-9:SCREEN-VALUE)  THEN DO:
            
          RUN pi-Mensagem2.
          fi-cod-titulo-9:SCREEN-VALUE    = "".
          fi-cod-esp-docto-9:SCREEN-VALUE = "".
          fi-cod-ser-docto-9:SCREEN-VALUE = "".
          fi-cod-parcela-9:SCREEN-VALUE   = "".  
          APPLY "entry" TO fi-cod-titulo-9 IN FRAME f-relat.
          RETURN NO-APPLY.
       END.
           
       ASSIGN i-nr-docto[9] = fi-cod-titulo-9:SCREEN-VALUE IN FRAME    f-relat.
       ASSIGN c-cod-esp[9]  = fi-cod-esp-docto-9:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN c-cod-ser[9]  = fi-cod-ser-docto-9:SCREEN-VALUE IN FRAME f-relat.
       ASSIGN i-parcela[9]  = fi-cod-parcela-9:SCREEN-VALUE IN FRAME   f-relat.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-mostra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-mostra C-Win
ON MOUSE-SELECT-CLICK OF rs-mostra IN FRAME f-relat
DO:
    RUN pi-Habilita.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  RUN enable_UI.
  RUN pi-Habilita.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN 
     WAIT-FOR CLOSE OF THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY fi-cod-titulo-1 fi-cod-esp-docto-1 fi-cod-ser-docto-1 fi-cod-parcela-1 fi-cod-titulo-2 
          fi-cod-esp-docto-2 fi-cod-ser-docto-2 fi-cod-parcela-2 fi-cod-titulo-3 fi-cod-esp-docto-3 
          fi-cod-ser-docto-3 fi-cod-parcela-3 fi-cod-titulo-4 fi-cod-esp-docto-4 fi-cod-ser-docto-4 fi-cod-parcela-4 
          fi-cod-titulo-5 fi-cod-esp-docto-5 fi-cod-ser-docto-5 fi-cod-parcela-5 fi-cod-titulo-6 
          fi-cod-esp-docto-6 fi-cod-ser-docto-6 fi-cod-parcela-6 fi-cod-titulo-7 fi-cod-esp-docto-7 fi-cod-ser-docto-7
          fi-cod-parcela-7 fi-cod-titulo-8 fi-cod-ser-docto-8 fi-cod-esp-docto-8 fi-cod-parcela-8 
          fi-cod-titulo-9 fi-cod-esp-docto-9 fi-cod-ser-docto-9 fi-cod-parcela-9 fi-cod-titulo-10 
          fi-cod-esp-docto-10 fi-cod-ser-docto-10 fi-cod-parcela-10 fi-cod-titulo-11 
          fi-cod-esp-docto-11 fi-cod-ser-docto-11 fi-cod-parcela-11 fi-cod-titulo-12 
          fi-cod-esp-docto-12 fi-cod-ser-docto-12 fi-cod-parcela-12 fi-cod-titulo-13 
          fi-cod-esp-docto-13 fi-cod-ser-docto-13 fi-cod-parcela-13 fi-cod-titulo-14 
          fi-cod-esp-docto-14 fi-cod-ser-docto-14 fi-cod-parcela-14 rs-mostra rs-end c-arquivo fi-txt-etiq 
          fi-Cod-Cli-1 fi-Cod-Cli-2 fi-Cod-Cli-3 fi-Cod-Cli-4 fi-Cod-Cli-5 
          fi-Cod-Cli-6 fi-Cod-Cli-7 fi-Cod-Cli-8 fi-Cod-Cli-9 fi-Cod-Cli-10 
          fi-Cod-Cli-11 fi-Cod-Cli-12 fi-Cod-Cli-13 fi-Cod-Cli-14 
      WITH FRAME f-relat IN WINDOW C-Win.
  ENABLE fi-cod-titulo-1 fi-cod-esp-docto-1 fi-cod-ser-docto-1 fi-cod-parcela-1 fi-cod-titulo-2 
          fi-cod-esp-docto-2 fi-cod-ser-docto-2 fi-cod-parcela-2 fi-cod-titulo-3 fi-cod-esp-docto-3 
          fi-cod-ser-docto-3 fi-cod-parcela-3 fi-cod-titulo-4 fi-cod-esp-docto-4 fi-cod-ser-docto-4 fi-cod-parcela-4 
          fi-cod-titulo-5 fi-cod-esp-docto-5 fi-cod-ser-docto-5 fi-cod-parcela-5 fi-cod-titulo-6 
          fi-cod-esp-docto-6 fi-cod-ser-docto-6 fi-cod-parcela-6 fi-cod-titulo-7 fi-cod-esp-docto-7 fi-cod-ser-docto-7
          fi-cod-parcela-7 fi-cod-titulo-8 fi-cod-ser-docto-8 fi-cod-esp-docto-8 fi-cod-parcela-8 
          fi-cod-titulo-9 fi-cod-esp-docto-9 fi-cod-ser-docto-9 fi-cod-parcela-9 fi-cod-titulo-10 
          fi-cod-esp-docto-10 fi-cod-ser-docto-10 fi-cod-parcela-10 fi-cod-titulo-11 
          fi-cod-esp-docto-11 fi-cod-ser-docto-11 fi-cod-parcela-11 fi-cod-titulo-12 
          fi-cod-esp-docto-12 fi-cod-ser-docto-12 fi-cod-parcela-12 fi-cod-titulo-13 
          fi-cod-esp-docto-13 fi-cod-ser-docto-13 fi-cod-parcela-13 fi-cod-titulo-14 
          fi-cod-esp-docto-14 fi-cod-ser-docto-14 fi-cod-parcela-14 rs-mostra rs-end c-arquivo bt-salva 
         bt-cfimp fi-txt-etiq fi-Cod-Cli-1 fi-Cod-Cli-2 fi-Cod-Cli-3 
         fi-Cod-Cli-4 fi-Cod-Cli-5 fi-Cod-Cli-6 fi-Cod-Cli-7 fi-Cod-Cli-8 
         fi-Cod-Cli-9 fi-Cod-Cli-10 fi-Cod-Cli-11 fi-Cod-Cli-12 fi-Cod-Cli-13 
         fi-Cod-Cli-14 bt-imprime-2 RECT-2 RECT-7 RECT-11 RECT-12 
      WITH FRAME f-relat IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-f-relat}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-configura C-Win 
PROCEDURE pi-configura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


        IF V_Cod_Dwb_User = "" 
        THEN ASSIGN V_Cod_Dwb_User = V_Cod_Usuar_Corren.
     
        ASSIGN v_cod_dwb_output = "Impressora" .


        DO.   /* seta a saida da impressao */
          CASE V_Cod_Dwb_Output:
            WHEN "Terminal" /*l_Terminal*/  THEN 
            DO.
              ASSIGN V_Cod_Dwb_File   = session:temp-directory + "esapb003.lst".
              OUTPUT STREAM Stream_1 TO VALUE(V_Cod_Dwb_File) PAGED PAGE-SIZE VALUE(V_Rpt_Stream_1_Lines) CONVERT TARGET 'iso8859-1'.
            END.
            WHEN "Impressora" /*l_Printer*/  THEN 
            DO.
              FIND Imprsor_Usuar NO-LOCK
                  WHERE Imprsor_Usuar.Nom_Impressora = C-Impressora
                    AND Imprsor_Usuar.Cod_Usuario    = V_Cod_Dwb_User
                  USE-INDEX imprsrsr_id NO-ERROR.
              
              FIND layout_impres NO-LOCK
                   WHERE Layout_Impres.Nom_Impressora    = C-Impressora
                     AND Layout_Impres.Cod_Layout_Impres = C-Layout
                   NO-ERROR.
              ASSIGN V_Rpt_Stream_1_Bottom = Layout_Impres.Num_Lin_Pag /* + V_Rpt_Stream_1_Bottom - V_Rpt_Stream_1_Lines */
                     V_Rpt_Stream_1_Lines  = Layout_Impres.Num_Lin_Pag.

              IF OPSYS = "UNIX" THEN 
              DO.
                IF V_Num_Ped_Exec_Corren <> 0 THEN 
                DO.
                  FIND Ped_Exec NO-LOCK
                      WHERE Ped_Exec.num_Ped_Exec = V_Num_Ped_Exec_Corren NO-ERROR.
                  IF AVAIL Ped_Exec THEN 
                  DO.
                    FIND Servid_Exec_Imprsor NO-LOCK
                         WHERE Servid_Exec_Imprsor.Cod_Servid_Exec = Ped_Exec.Cod_Servid_Exec
                           AND Servid_Exec_Imprsor.Nom_Impressora  = C-Impressora 
                         NO-ERROR.
                    IF AVAIL Servid_Exec_Imprsor 
                    THEN OUTPUT STREAM Stream_1 
                                THROUGH VALUE(Servid_Exec_Imprsor.Nom_Disposit_So)
                                        PAGED 
                                        PAGE-SIZE 
                                        VALUE(V_Rpt_Stream_1_Lines) 
                                        CONVERT TARGET 'iso8859-1'.
                    ELSE OUTPUT STREAM Stream_1 
                                THROUGH VALUE(Imprsor_Usuar.Nom_Disposit_So)
                                        PAGED 
                                        PAGE-SIZE 
                                        VALUE(V_Rpt_Stream_1_Lines) 
                                        CONVERT TARGET 'iso8859-1'.
                  END. /* End do - IF AVAIL ped_Exec */
                END. /* end do - IF V_Num_Ped_Exec_Corren <> 0 */
                ELSE OUTPUT STREAM Stream_1 
                            THROUGH VALUE(Imprsor_Usuar.Nom_Disposit_So)
                                    PAGED 
                                    PAGE-SIZE 
                                    VALUE(V_Rpt_Stream_1_Lines) 
                                    CONVERT TARGET 'iso8859-1'.
              END. /* End do - IF OPSYS = "UNIX" */
              ELSE OUTPUT STREAM Stream_1 TO VALUE(Imprsor_Usuar.Nom_Disposit_So)
                                                   PAGED 
                                                   PAGE-SIZE 82
                                                /*   VALUE(V_Rpt_Stream_1_Lines)  */
                                                   CONVERT TARGET 'iso8859-1'.
              FOR EACH Configur_Layout_Impres NO-LOCK
                  WHERE Configur_Layout_Impres.Num_Id_Layout_Impres = Layout_Impres.Num_Id_Layout_Impres
                     BY Configur_Layout_Impres.num_Ord_Funcao_imprsor.
                FIND Configur_Tip_imprsor NO-LOCK
                     WHERE Configur_Tip_Imprsor.Cod_Tip_Imprsor        = Layout_Impres.Cod_Tip_Imprsor
                       AND Configur_Tip_Imprsor.Cod_Funcao_Imprsor     = Configur_Layout_Impres.Cod_Funcao_Imprsor
                       AND Configur_Tip_Imprsor.Cod_Opc_Funcao_Imprsor = Configur_Layout_Impres.Cod_Opc_Funcao_Imprsor
                     NO-ERROR.
                PUT STREAM Stream_1 CONTROL Configur_Tip_Imprsor.Cod_Comando_Configur.
              END. /* End do - FOR EACH Configur_Layout_Impres NO-LOCK */
            END. /* End do - WHEN "Impressora" l_Printer */
            WHEN "Arquivo" /*l_File*/  THEN 
            DO.
              OUTPUT STREAM Stream_1 TO VALUE(V_Cod_Dwb_File)
                                                   PAGED 
                                                   PAGE-SIZE 
                                                   VALUE(V_Rpt_Stream_1_Lines)
                                                   CONVERT TARGET 'iso8859-1'.
            END. /* End do - WHEN "Arquivo" - l_File  */
          END. /* End do - CASE V_Cod_Dwb_Output */
        END. /* End do - DO. -- Que seta a saida da impressao */


  /* manda para bandeja Manual "*/
    put stream stream_1  chr(027) + chr(038) + chr(108) + chr(050) + chr(072).

    /* a4 */

    put stream stream_1  chr(027) + chr(038) + chr(108) + chr(050) + chr(054) + chr(065).

    /* densidade horizontal */


    put stream stream_1  chr(027) + chr(038) + chr(107) + chr(052) + chr(083).

    /* espacamento de linha */

    put stream stream_1  chr(027) + chr(038) + chr(108) + chr(056) + chr(068).
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Habilita C-Win 
PROCEDURE pi-Habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   IF int(rs-mostra:SCREEN-VALUE IN FRAME f-relat) = 1 THEN DO:
      fi-Cod-Cli-1:VISIBLE = TRUE.
      fi-Cod-Cli-2:VISIBLE = TRUE.
      fi-Cod-Cli-3:VISIBLE = TRUE.
      fi-Cod-Cli-4:VISIBLE = TRUE.
      fi-Cod-Cli-5:VISIBLE = TRUE.
      fi-Cod-Cli-6:VISIBLE = TRUE.
      fi-Cod-Cli-7:VISIBLE = TRUE.
      fi-Cod-Cli-8:VISIBLE = TRUE.
      fi-Cod-Cli-9:VISIBLE = TRUE.
      fi-Cod-Cli-10:VISIBLE = TRUE.
      fi-Cod-Cli-11:VISIBLE = TRUE.
      fi-Cod-Cli-12:VISIBLE = TRUE.
      fi-Cod-Cli-13:VISIBLE = TRUE.
      fi-Cod-Cli-14:VISIBLE = TRUE.

      fi-cod-titulo-1:VISIBLE = FALSE.
      fi-cod-titulo-2:VISIBLE = FALSE.
      fi-cod-titulo-3:VISIBLE = FALSE.
      fi-cod-titulo-4:VISIBLE = FALSE.
      fi-cod-titulo-5:VISIBLE = FALSE.
      fi-cod-titulo-6:VISIBLE = FALSE.
      fi-cod-titulo-7:VISIBLE = FALSE.
      fi-cod-titulo-8:VISIBLE = FALSE.
      fi-cod-titulo-9:VISIBLE = FALSE.
      fi-cod-titulo-10:VISIBLE = FALSE.
      fi-cod-titulo-11:VISIBLE = FALSE.
      fi-cod-titulo-12:VISIBLE = FALSE.
      fi-cod-titulo-13:VISIBLE = FALSE.
      fi-cod-titulo-14:VISIBLE = FALSE.

      fi-cod-esp-docto-1:VISIBLE = FALSE.
      fi-cod-esp-docto-2:VISIBLE = FALSE.
      fi-cod-esp-docto-3:VISIBLE = FALSE.
      fi-cod-esp-docto-4:VISIBLE = FALSE.
      fi-cod-esp-docto-5:VISIBLE = FALSE.
      fi-cod-esp-docto-6:VISIBLE = FALSE.
      fi-cod-esp-docto-7:VISIBLE = FALSE.
      fi-cod-esp-docto-8:VISIBLE = FALSE.
      fi-cod-esp-docto-9:VISIBLE = FALSE.
      fi-cod-esp-docto-10:VISIBLE = FALSE.
      fi-cod-esp-docto-11:VISIBLE = FALSE.
      fi-cod-esp-docto-12:VISIBLE = FALSE.
      fi-cod-esp-docto-13:VISIBLE = FALSE.
      fi-cod-esp-docto-14:VISIBLE = FALSE.

      fi-cod-ser-docto-1:VISIBLE = FALSE.
      fi-cod-ser-docto-2:VISIBLE = FALSE.
      fi-cod-ser-docto-3:VISIBLE = FALSE.
      fi-cod-ser-docto-4:VISIBLE = FALSE.
      fi-cod-ser-docto-5:VISIBLE = FALSE.
      fi-cod-ser-docto-6:VISIBLE = FALSE.
      fi-cod-ser-docto-7:VISIBLE = FALSE.
      fi-cod-ser-docto-8:VISIBLE = FALSE.
      fi-cod-ser-docto-9:VISIBLE = FALSE.
      fi-cod-ser-docto-10:VISIBLE = FALSE.
      fi-cod-ser-docto-11:VISIBLE = FALSE.
      fi-cod-ser-docto-12:VISIBLE = FALSE.
      fi-cod-ser-docto-13:VISIBLE = FALSE.
      fi-cod-ser-docto-14:VISIBLE = FALSE.

      fi-cod-parcela-1:VISIBLE = FALSE.
      fi-cod-parcela-2:VISIBLE = FALSE.
      fi-cod-parcela-3:VISIBLE = FALSE.
      fi-cod-parcela-4:VISIBLE = FALSE.
      fi-cod-parcela-5:VISIBLE = FALSE.
      fi-cod-parcela-6:VISIBLE = FALSE.
      fi-cod-parcela-7:VISIBLE = FALSE.
      fi-cod-parcela-8:VISIBLE = FALSE.
      fi-cod-parcela-9:VISIBLE = FALSE.
      fi-cod-parcela-10:VISIBLE = FALSE.
      fi-cod-parcela-11:VISIBLE = FALSE.
      fi-cod-parcela-12:VISIBLE = FALSE.
      fi-cod-parcela-13:VISIBLE = FALSE.
      fi-cod-parcela-14:VISIBLE = FALSE.

   END.
   ELSE DO:
       fi-Cod-Cli-1:VISIBLE = FALSE.
       fi-Cod-Cli-2:VISIBLE = FALSE.
       fi-Cod-Cli-3:VISIBLE = FALSE.
       fi-Cod-Cli-4:VISIBLE = FALSE.
       fi-Cod-Cli-5:VISIBLE = FALSE.
       fi-Cod-Cli-6:VISIBLE = FALSE.
       fi-Cod-Cli-7:VISIBLE = FALSE.
       fi-Cod-Cli-8:VISIBLE = FALSE.
       fi-Cod-Cli-9:VISIBLE = FALSE.
       fi-Cod-Cli-10:VISIBLE = FALSE.
       fi-Cod-Cli-11:VISIBLE = FALSE.
       fi-Cod-Cli-12:VISIBLE = FALSE.
       fi-Cod-Cli-13:VISIBLE = FALSE.
       fi-Cod-Cli-14:VISIBLE = FALSE.

       fi-cod-titulo-1:VISIBLE = TRUE.
       fi-cod-titulo-2:VISIBLE = TRUE.
       fi-cod-titulo-3:VISIBLE = TRUE.
       fi-cod-titulo-4:VISIBLE = TRUE.
       fi-cod-titulo-5:VISIBLE = TRUE.
       fi-cod-titulo-6:VISIBLE = TRUE.
       fi-cod-titulo-7:VISIBLE = TRUE.
       fi-cod-titulo-8:VISIBLE = TRUE.
       fi-cod-titulo-9:VISIBLE = TRUE.
       fi-cod-titulo-10:VISIBLE = TRUE.
       fi-cod-titulo-11:VISIBLE = TRUE.
       fi-cod-titulo-12:VISIBLE = TRUE.
       fi-cod-titulo-13:VISIBLE = TRUE.
       fi-cod-titulo-14:VISIBLE = TRUE.

       fi-cod-esp-docto-1:VISIBLE = TRUE.
       fi-cod-esp-docto-2:VISIBLE = TRUE.
       fi-cod-esp-docto-3:VISIBLE = TRUE.
       fi-cod-esp-docto-4:VISIBLE = TRUE.
       fi-cod-esp-docto-5:VISIBLE = TRUE.
       fi-cod-esp-docto-6:VISIBLE = TRUE.
       fi-cod-esp-docto-7:VISIBLE = TRUE.
       fi-cod-esp-docto-8:VISIBLE = TRUE.
       fi-cod-esp-docto-9:VISIBLE = TRUE.
       fi-cod-esp-docto-10:VISIBLE = TRUE.
       fi-cod-esp-docto-11:VISIBLE = TRUE.
       fi-cod-esp-docto-12:VISIBLE = TRUE.
       fi-cod-esp-docto-13:VISIBLE = TRUE.
       fi-cod-esp-docto-14:VISIBLE = TRUE.

      fi-cod-ser-docto-1:VISIBLE = TRUE.
      fi-cod-ser-docto-2:VISIBLE = TRUE.
      fi-cod-ser-docto-3:VISIBLE = TRUE.
      fi-cod-ser-docto-4:VISIBLE = TRUE.
      fi-cod-ser-docto-5:VISIBLE = TRUE.
      fi-cod-ser-docto-6:VISIBLE = TRUE.
      fi-cod-ser-docto-7:VISIBLE = TRUE.
      fi-cod-ser-docto-8:VISIBLE = TRUE.
      fi-cod-ser-docto-9:VISIBLE = TRUE.
      fi-cod-ser-docto-10:VISIBLE = TRUE.
      fi-cod-ser-docto-11:VISIBLE = TRUE.
      fi-cod-ser-docto-12:VISIBLE = TRUE.
      fi-cod-ser-docto-13:VISIBLE = TRUE.
      fi-cod-ser-docto-14:VISIBLE = TRUE.

       fi-cod-parcela-1:VISIBLE = TRUE.
       fi-cod-parcela-2:VISIBLE = TRUE.
       fi-cod-parcela-3:VISIBLE = TRUE.
       fi-cod-parcela-4:VISIBLE = TRUE.
       fi-cod-parcela-5:VISIBLE = TRUE.
       fi-cod-parcela-6:VISIBLE = TRUE.
       fi-cod-parcela-7:VISIBLE = TRUE.
       fi-cod-parcela-8:VISIBLE = TRUE.
       fi-cod-parcela-9:VISIBLE = TRUE.
       fi-cod-parcela-10:VISIBLE = TRUE.
       fi-cod-parcela-11:VISIBLE = TRUE.
       fi-cod-parcela-12:VISIBLE = TRUE.
       fi-cod-parcela-13:VISIBLE = TRUE.
       fi-cod-parcela-14:VISIBLE = TRUE.

   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-imprime-cliente1 C-Win 
PROCEDURE pi-imprime-cliente1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN l-pula = NO.

  
    IF fi-txt-etiq:SCREEN-VALUE IN FRAME f-relat = "" THEN 
        ASSIGN c-text = "A/C: Departamento Financeiro".
    ELSE
        ASSIGN c-text = fi-txt-etiq:SCREEN-VALUE IN FRAME f-relat.




    DO ind = 1 TO 14 BY 2:    
       ASSIGN c-nome-emit = ""
              c-endereco = ""
              c-cidade = ""
              c-bairro = ""
              c-estado = ""
              i-cep = "".
                  
       IF i-cli[ind] <> 0 THEN DO:
          FIND emitente NO-LOCK WHERE
               emitente.cod-emitente = i-cli[ind] NO-ERROR.
          ASSIGN c-nome-emit[1] = emitente.nome-emit.
          IF emitente.endereco-cob <> "" AND
             emitente.cidade-cob <> ""   AND
             emitente.estado-cob <> ""   AND
             emitente.cep-cob <> ""      AND 
             int(rs-end:SCREEN-VALUE IN FRAME f-relat) = 1 THEN DO:
             ASSIGN c-endereco[1] = emitente.endereco-cob
                    c-bairro[1]   = emitente.bairro-cob
                    i-cep[1]      = emitente.cep-cob
                    c-cidade[1]   = emitente.cidade-cob
                    c-estado[1]   = emitente.estado-cob.
          END.
          ELSE
             ASSIGN c-endereco[1] = emitente.endereco
                    c-bairro[1]   = emitente.bairro
                    i-cep[1]      = emitente.cep
                    c-cidade[1]   = emitente.cidade
                    c-estado[1]   = emitente.estado.
          END.
           
          IF i-cli[ind + 1] <> 0 THEN DO:
             FIND emitente NO-LOCK WHERE
                  emitente.cod-emitente = i-cli[ind + 1] NO-ERROR.
             ASSIGN c-nome-emit[2] = emitente.nome-emit.
             IF emitente.endereco-cob <> "" AND
                emitente.cidade-cob <> ""   AND
                emitente.estado-cob <> ""   AND
                emitente.cep-cob <> ""      AND 
                int(rs-end:SCREEN-VALUE IN FRAME f-relat) = 1 THEN DO:
                ASSIGN c-endereco[2] = emitente.endereco-cob
                       c-bairro[2]   = emitente.bairro-cob
                       i-cep[2]      = emitente.cep-cob
                       c-cidade[2]   = emitente.cidade-cob
                       c-estado[2]   = emitente.estado-cob.
             END.
             ELSE
                ASSIGN c-endereco[2] = emitente.endereco
                       c-bairro[2]   = emitente.bairro
                       i-cep[2]     = emitente.cep
                       c-cidade[2]   = emitente.cidade
                       c-estado[2]   = emitente.estado.
          END.
           
          
          put stream stream_1 skip(1).
          if i-cli[ind] = 0 and i-cli[ind + 1] = 0 then
             put stream stream_1 skip(9).
          else
          if i-cli[ind] = 0 and i-cli[ind + 1] <> 0 then do:
             put stream stream_1  chr(027) + chr(040) + chr(115) + chr(051) + chr(066).
         
             put stream stream_1 SKIP(1).

             put stream stream_1 space(51)
                 c-nome-emit[2].
             put stream stream_1  chr(027) + chr(040) + chr(115) + chr(048) + chr(066).
             put stream stream_1 skip 
                 space(51)
                 c-endereco[2] skip
                 space(51)
                 c-bairro[2] skip
                 space(51)
                 i-cep[2]
                 " - "
                trim(string(c-cidade[2],"x(20)")) format "X(20)"
                 " - "
                 c-estado[2]  skip(1)
                 space(51)
                 c-text skip(1).
          end.
          else 
          if i-cli[ind] <> 0 and i-cli[ind + 1] = 0 then do:
             put stream stream_1  chr(027) + chr(040) + chr(115) + chr(051) + chr(066).
           
             put stream stream_1 SKIP(1).

             put stream stream_1 c-nome-emit[1] at 1.
             put stream stream_1  chr(027) + chr(040) + chr(115) + chr(048) + chr(066).
             put stream stream_1 skip
                 c-endereco[1] skip
                 c-bairro[1] skip
                 i-cep[1]
                 " - "
                 trim(string(c-cidade[1],"x(20)")) format "X(20)"
                 " - "
                 c-estado[1]  skip(1)
                 c-text skip(1).
          end.
          else do:
             put stream stream_1  chr(027) + chr(040) + chr(115) + chr(051) + chr(066).
           
             put stream stream_1 SKIP(1).

             put stream stream_1 c-nome-emit[1]  at 1 space(11)
                 c-nome-emit[2].
             put stream stream_1   chr(027) + chr(040) + chr(115) + chr(048) + chr(066).
             put stream stream_1 c-endereco[1]   at 1 space(11)
                 c-endereco[2] skip
                 c-bairro[1]     at 1 space(21)
                 c-bairro[2] skip
                 i-cep[1]      /*  at 1  */ SPACE(1)
                 " - "
                 trim(string(c-cidade[1],"x(20)")) format "X(20)"
                 " - "
                 c-estado[1]          /* space(9)*/
                 i-cep[2] at 52
                 " - "
                 trim(string(c-cidade[2],"x(20)")) format "X(20)"
                 " - "
                 c-estado[2]  skip(1)
                 c-text at 1 space(11)
                 c-text skip(1).
          end.


          put stream stream_1 SKIP(2).

          /*
          IF l-pula THEN DO: 
                put stream stream_1 SKIP(1).
          END.*/
          ASSIGN l-pula = NOT l-pula.


    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Imprime-Titulo C-Win 
PROCEDURE pi-Imprime-Titulo :


    ASSIGN l-pula = NO.

    IF fi-txt-etiq:SCREEN-VALUE IN FRAME f-relat = "" THEN 
        ASSIGN c-text = "A/C: Departamento Financeiro".
    ELSE
        ASSIGN c-text = fi-txt-etiq:SCREEN-VALUE IN FRAME f-relat.




    DO ind = 1 to 14 BY 2:
       ASSIGN c-nome-emit = ""
              c-endereco = ""
              c-cidade = ""
              c-bairro = ""
              c-estado = ""
              i-cep = "".                  

       IF i-nr-docto[ind] <> "" THEN DO: 
          FIND tit_acr NO-LOCK                           
              WHERE tit_acr.cod_estab       = v_cod_estab_usuar
                AND tit_acr.cod_espec_docto = c-cod-esp[ind] 
                AND tit_acr.cod_ser_docto   = c-cod-ser[ind]
                AND tit_acr.cod_tit_acr     = i-nr-docto[ind]    
                AND tit_acr.cod_parcela     = i-parcela[ind] NO-ERROR. 

          FIND emitente NO-LOCK                                 WHERE
               emitente.cod-emitente = int(tit_acr.cdn_cliente) NO-ERROR.

          ASSIGN c-nome-emit[1] = emitente.nome-emit.
          IF emitente.endereco-cob <> "" AND
             emitente.cidade-cob   <> "" AND
             emitente.estado-cob   <> "" AND
             emitente.cep-cob      <> "" AND 
             int(rs-end:SCREEN-VALUE IN FRAME f-relat) = 1 THEN DO:
             ASSIGN c-endereco[1] = emitente.endereco-cob
                    c-bairro[1]   = emitente.bairro-cob
                    i-cep[1]      = emitente.cep-cob
                    c-cidade[1]   = emitente.cidade-cob
                    c-estado[1]   = emitente.estado-cob.
          END.
          ELSE
             ASSIGN c-endereco[1] = emitente.endereco
                    c-bairro[1]   = emitente.bairro
                    i-cep[1]      = emitente.cep
                    c-cidade[1]   = emitente.cidade
                    c-estado[1]   = emitente.estado.
        END.
          
        IF i-nr-docto[ind + 1] <> "" THEN DO:
           FIND tit_acr NO-LOCK                              
               WHERE tit_acr.cod_estab =     v_cod_estab_usuar
                 AND tit_acr.cod_espec_docto = c-cod-esp[ind + 1] 
                 AND tit_acr.cod_ser_docto   = c-cod-ser[ind + 1]
                 AND tit_acr.cod_tit_acr     = i-nr-docto[ind + 1]    
                 AND tit_acr.cod_parcela     = i-parcela[ind + 1]  NO-ERROR.
           FIND emitente NO-LOCK WHERE
                emitente.cod-emitente = int(tit_acr.cdn_cliente) NO-ERROR.
           
           ASSIGN c-nome-emit[2] = emitente.nome-emit.
           IF emitente.endereco-cob <> "" AND
              emitente.cidade-cob <> ""   AND
              emitente.estado-cob <> ""   AND
              emitente.cep-cob <> ""      AND 
             int(rs-end:SCREEN-VALUE IN FRAME f-relat) = 1 THEN DO:
              ASSIGN c-endereco[2] = emitente.endereco-cob
                     c-bairro[2]   = emitente.bairro-cob
                     i-cep[2]      = emitente.cep-cob
                     c-cidade[2]   = emitente.cidade-cob
                     c-estado[2]   = emitente.estado-cob.
           END.
           ELSE
              ASSIGN c-endereco[2] = emitente.endereco
                     c-bairro[2]   = emitente.bairro
                     i-cep[2]      = emitente.cep
                     c-cidade[2]   = emitente.cidade
                     c-estado[2]   = emitente.estado.
        END.
        

        put stream stream_1 skip(1).
        if i-nr-docto[ind] = "" and i-nr-docto[ind + 1] = "" then
           put stream stream_1 skip(9).
        else
        if i-nr-docto[ind] = "" and i-nr-docto[ind + 1] <> "" then do:
           put stream stream_1 chr(027) + chr(040) + chr(115) + chr(051) + chr(066).

           put stream stream_1 SKIP(1).

           put stream stream_1 space(51)
               c-nome-emit[2].
           put stream stream_1 chr(027) + chr(040) + chr(115) + chr(048) + chr(066).
           put stream stream_1 skip 
               space(51)
               c-endereco[2] skip
               space(51)
               c-bairro[2] skip
               space(51)
               i-cep[2]
               " - "
              trim(string(c-cidade[2],"x(20)")) format "X(20)"
               " - "
               c-estado[2]  skip(1)
               space(51)
               c-text skip(1).
        end.
        else 
        if i-nr-docto[ind] <> "" and i-nr-docto[ind + 1] = "" then do:
           put stream stream_1 chr(027) + chr(040) + chr(115) + chr(051) + chr(066).

           put stream stream_1 SKIP(1).

           put stream stream_1 c-nome-emit[1] at 1.
           put stream stream_1 chr(027) + chr(040) + chr(115) + chr(048) + chr(066).
           put stream stream_1 skip
               c-endereco[1] skip
               c-bairro[1] skip
               i-cep[1]
               " - "
               trim(string(c-cidade[1],"x(20)")) format "X(20)"
               " - "
               c-estado[1]  skip(1)
               c-text skip(1).
        end.
        else do:
           put stream stream_1 chr(027) + chr(040) + chr(115) + chr(051) + chr(066).

           put stream stream_1 SKIP(1).

           put stream stream_1 c-nome-emit[1]  at 1 space(11)
               c-nome-emit[2].
           put stream stream_1 chr(027) + chr(040) + chr(115) + chr(048) + chr(066).
           put stream stream_1 c-endereco[1]   at 1 space(11)
               c-endereco[2] skip
               c-bairro[1]     at 1 space(21)
               c-bairro[2] skip
               i-cep[1]       /* at 1 */  SPACE(1)
               " - "
               trim(string(c-cidade[1],"x(20)")) format "X(20)"
               " - "
               c-estado[1]          /* space(9)*/
               i-cep[2] at 52
               " - "
               trim(string(c-cidade[2],"x(20)")) format "X(20)"
               " - "
               c-estado[2]  skip(1)
               c-text at 1 space(11)
               c-text skip(1).
        end.


        IF l-pula THEN DO: 
              put stream stream_1 SKIP(1).
        END.
        ASSIGN l-pula = NOT l-pula.


  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Mensagem C-Win 
PROCEDURE pi-Mensagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    MESSAGE "Cliente nÆo cadastrado. Verifique ..."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Mensagem2 C-Win 
PROCEDURE pi-Mensagem2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    MESSAGE "Titulo nÆo cadastrado. Verifique ..."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recupera-param C-Win 
PROCEDURE pi-recupera-param :
FIND dwb_set_list_param EXCLUSIVE-LOCK                       WHERE
         dwb_set_list_param.cod_dwb_program = "esacr023"         AND
         dwb_set_list_param.cod_dwb_user    = v_cod_usuar_corren NO-ERROR.
  
    IF AVAIL dwb_set_list_param THEN 
       DO WITH FRAME f-relat:
          ASSIGN fi-Cod-Cli-1:SCREEN-VALUE IN FRAME f-relat = ENTRY(2,dwb_set_list_param.cod_dwb_parameters,chr(10)).
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_message C-Win 
PROCEDURE pi_message :
DEF INPUT PARAM c_action  AS CHAR    NO-UNDO.
DEF INPUT PARAM i_msg     AS INTEGER NO-UNDO.
DEF INPUT PARAM c_param   AS CHAR    NO-UNDO.

DEF VAR c_prg_msg         AS CHAR    NO-UNDO.

ASSIGN c_prg_msg = "messages/"
                    + string(trunc(i_msg / 1000,0),"99")
                    + "/msg"
                    + string(i_msg, "99999").

IF SEARCH(c_prg_msg + ".r") = ? AND 
   SEARCH(c_prg_msg + ".p") = ? THEN DO:
   MESSAGE "Mensagem nr. " i_msg "!!!" SKIP
           "Programa Mensagem" c_prg_msg "nÆo encontrado." VIEW-AS ALERT-BOX ERROR.
   RETURN ERROR.
END.

RUN VALUE(c_prg_msg + ".p") (INPUT c_action, INPUT c_param).
RETURN RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_salva_param C-Win 
PROCEDURE pi_salva_param :
ASSIGN INPUT FRAME f-relat c-arquivo.

    RUN prgtec/btb/btb906za.p.    

    /* Recuperar parƒmetros da £ltima execu‡Æo */
    FIND dwb_set_list_param EXCLUSIVE-LOCK                       WHERE
         dwb_set_list_param.Cod_dwb_program = "esacr023"         AND
         dwb_set_list_param.Cod_dwb_user    = v_Cod_usuar_corren NO-ERROR.
    IF NOT AVAIL dwb_set_list_param THEN
       CREATE dwb_set_list_param.
    
    ASSIGN dwb_set_list_param.Cod_dwb_program          = "esacr023"
           dwb_set_list_param.Cod_dwb_user             = v_Cod_usuar_corren
           dwb_set_list_param.Cod_dwb_file             = INPUT FRAME f-relat c-arquivo
           dwb_set_list_param.nom_dwb_printer          = c-impressora
           dwb_set_list_param.Cod_dwb_print_layout     = c-layout
           dwb_set_list_param.qtd_dwb_line             = 60
           /*
           dwb_set_list_param.Cod_dwb_parameters       = STRING(rs-execucao) + chr(10) + 
                                                              STRING(c-cod-estab) + CHR(10) +
                                                              string(c-cod-esp) + chr(10) +
                                                              STRING(c-cod-ser) + CHR(10) +
                                                              string(i-nr-docto) + chr(10) + 
                                                              string(i-parcela) + chr(10) +
                                                              string(c-corresp) + chr(10) +
                                                              string(l-prot) + chr(10) +
                                                              string(c-resp) + chr(10) +
                                                              string(l-impesp) + chr(10) +
                                                              (IF dt-vencimen <> ? THEN 
                                                                  string(dt-vencimen) 
                                                                  ELSE 
                                                                     "") + chr(10) +
                                                              string(de-valor) + chr(10) */

           dwb_set_list_param.Cod_dwb_output           = "Impressora".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

