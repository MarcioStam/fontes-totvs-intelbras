/* ----------------------------------------------------------------------------
   Programa..: upc/cd0704-upcc.p
   Data......: 07/06/2010.
   Autor.....: Gustavo Eduardo Tamanini - SQL WORKS.
   Objetivo..: Chamada de zoom do bot∆o CEP criado dinamicamente.
---------------------------------------------------------------------------- */

def var wh-pesquisa as widget-handle.
def new global shared var l-implanta      as logical init no. 
def new global shared var wh-window       as handle           no-undo.
def new global shared var adm-broker-hdl  as handle           no-undo.
def new global shared var h-programa      as handle           no-undo.

define new global shared var whEstado       as widget-handle no-undo.
define new global shared var whEndereco     as widget-handle no-undo.
define new global shared var whCep          as widget-handle no-undo.
define new global shared var whBairro       as widget-handle no-undo.
define new global shared var whCidade       as widget-handle no-undo.
define new global shared var whEstadoLocal  as widget-handle no-undo.

assign l-implanta = NO.
{include/zoomvar.i &prog-zoom="eszoom/z01es539.w"
                   &proghandle=h-programa
                   &campohandle=whCep
                   &campozoom=cep
                   &campohandle2=whBairro
                   &campozoom2=bairro-ini
                   &campohandle3=whCidade
                   &campozoom3=localidade
                   &campohandle4=whEstadoLocal
                   &campozoom4=uf
                   &campohandle5=whEndereco
                   &campozoom5=end-somatoria}
                  
