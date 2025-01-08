/* ----------------------------------------------------------------------------
   Programa..: upc/cd0401-upca.p
   Data......: 07/06/2010.
   Autor.....: Gustavo Eduardo Tamanini - SQL WORKS.
   Objetivo..: Chamada de zoom do bot∆o CEP criado dinamicamente.
---------------------------------------------------------------------------- */

def var wh-pesquisa as widget-handle.
def new global shared var l-implanta     as logical init no. 
def new global shared var wh-window      as handle       no-undo.
def new global shared var adm-broker-hdl as handle       no-undo.
def new global shared var wgh-folder     as handle       no-undo.

DEFINE NEW GLOBAL SHARED VAR wh-end-cd0401    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-uf-cd0401     AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-cidade-cd0401 AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-cep-cd0401    AS WIDGET-HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR wh-bairro-cd0401 AS WIDGET-HANDLE NO-UNDO.

assign l-implanta = NO.
{include/zoomvar.i &prog-zoom="eszoom/z01es539.w"
                   &proghandle=wgh-folder
                   &campohandle=wh-cep-cd0401
                   &campozoom=cep
                   &campohandle2=wh-bairro-cd0401
                   &campozoom2=bairro-ini
                   &campohandle3=wh-cidade-cd0401
                   &campozoom3=localidade
                   &campohandle4=wh-uf-cd0401
                   &campozoom4=uf
                   &campohandle5=wh-end-cd0401
                   &campozoom5=end-somatoria}
                  
