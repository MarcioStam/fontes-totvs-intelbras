/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i escdp068rp 2.00.00.000}  /*** 010000 ***/
/*******************************************************************************
**  Programa: ESCDP068
**  Objetivo: <comment>
**  Autor...: Francisco Almeida Fran‡a    
**  Data....: 05/2014
*******************************************************************************/
{include/i-rpvar.i}
{include/i-freeac.i}
{esp/cdp/escdp068tt.i}

DEF input parameter raw-param as raw no-undo.
DEF input parameter table for tt-raw-digita.

FIND LAST param-global NO-LOCK NO-ERROR.


create tt-param.
raw-transfer raw-param to tt-param.

/*CREATE tt-digita.
RAW-TRANSFER tt-raw-digita TO tt-digita.*/

assign c-programa     = "ESCDP068"
       c-sistema      = "Relat¢rio Itens"
       c-titulo-relat = "Relat¢rio Itens"
       c-versao       = "2.00.00"
       c-revisao      = "001"
       c-empresa      = "Intelbras".

{include/i-rpout.i}
/*{include/i-rpcab.i}*/

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

/*Impressao do relat¢rio*/
/*OUTPUT TO c:\temp\itens.csv CONVERT TARGET "iso8859-1".*/

PUT "Produto ; Descricao;Familia Comercial ;Peso Liquido;Peso Bruto;Altura;Largura;Comprimento;Preco Base" SKIP.

IF NOT avail tt-digita THEN DO:
    FOR EACH ITEM
       WHERE ITEM.fm-cod-com >= tt-param.c-fam-com-ini AND
             ITEM.fm-cod-com <= tt-param.c-fam-com-fim AND 
             item.it-codigo  >= tt-param.c-item-ini    AND
             item.it-codigo  <= tt-param.c-item-fim    NO-LOCK:     
                  
         PUT UNFORMATTED 
             ITEM.it-codigo    ";"
             ITEM.desc-item    ";"    
             ITEM.fm-cod-com   ";"   
             ITEM.peso-liquido ";" 
             ITEM.peso-bruto   ";"   
             ITEM.altura       ";"       
             ITEM.largura      ";"      
             ITEM.comprim      ";"
             ITEM.preco-base   SKIP.
    END.
END.
ELSE DO:
    FOR EACH tt-digita NO-LOCK:
        FOR EACH ITEM
           WHERE ITEM.fm-cod-com = string(tt-digita.familia) NO-LOCK:
           PUT UNFORMATTED 
             ITEM.it-codigo    ";"
             ITEM.desc-item    ";"    
             ITEM.fm-cod-com   ";"   
             ITEM.peso-liquido ";" 
             ITEM.peso-bruto   ";"   
             ITEM.altura       ";"       
             ITEM.largura      ";"      
             ITEM.comprim      ";"
             ITEM.preco-base   SKIP.
        END.
    END.
END.

{include/i-rpclo.i}

RETURN "OK".
