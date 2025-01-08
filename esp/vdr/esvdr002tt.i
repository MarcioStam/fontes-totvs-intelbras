/*************************************************
**
** Descri‡Æo..: Temp-table do programa esvdr002
** Autor......: Anderson Silvano
** Data.......: 12/05/2005 
**
**************************************************/

def temp-table tt-plan
    field num_planilha_vendor  like planilha_vendor.num_planilha_vendor
    field cdn_cliente          like planilha_vendor.cdn_cliente
    field cod_portador         like planilha_vendor.cod_portador
    field cod_estab            like planilha_vendor.cod_estab
    index planilha is primary unique num_planilha_vendor.
    
def temp-table tt-nao-env
    field cdn_repres           like planilha_vendor.cdn_repres  
    field cdn_cliente          like planilha_vendor.cdn_cliente
    field num_planilha_vendor  like planilha_vendor.num_planilha_vendor
    index codigo is primary num_planilha_vendor.

def temp-table tt-enviado
    field cdn_repres           like planilha_vendor.cdn_repres  
    field cdn_cliente          like planilha_vendor.cdn_cliente
    field num_planilha_vendor  like planilha_vendor.num_planilha_vendor
    FIELD e-mail               LIKE cont-emit.e-mail
    index codigo is primary num_planilha_vendor.
