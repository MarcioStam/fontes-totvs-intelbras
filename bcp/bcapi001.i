/**************************************************************************
**
**   Include: BCAPI001.I - Definicao da temp-table de transacoes de coleta
**                         de dados
**   Obs: verificar os programas ft0513cl.p e bc0110.w para ver o novo uso
**        do bcapi001.p para gera‡Æo de etiquetas 2D. O comportamento antigo
**        para etiqueta 1D foi mantido.
**
***************************************************************************/

/* 2D - Defini‡Æo do C¢digo da transa‡Æo 2D */
&global-define CODTRANS2D       "Codigo2D":U

/* 2D - Campos para tt-trans-ext. Veja comentarios abaixo */
&GLOBAL-DEFINE EXT-Quantidade   "Quantity":U

/* tt-trans - dados principais da transa‡Æo */
def temp-table tt-trans no-undo
    field cod-versao-integracao as int
    field i-sequen              as int
    field cd-trans              as char format "x(8)"
    field conteudo-trans        as raw
    field detalhe               as char format "x(256)"
    field nr-trans              as deci format "zzzzzzzzz9"
    field usuario               as char format "x(12)"
    field atualizada            as logical
    field etiqueta              as logical  /*  No - Gera Transa‡Æo de Movimento
                                               Yes - Gera Transa‡Æo de Etiqueta*/
    index ch-seq is unique primary i-sequen.

/* tt-trans-ext: Temp-table para passagem de novos campos para a transa‡Æo.
   Com esta temp-table evita-se alterar a tt-trans e a recompila‡Æo de todos
   os programas que a usam. Esta temp-table ‚ usada na nova procedure 
   atualizaTransacao na BCAPI001.P (C¢digo 2D). Usa-se os preprocessadores
   no inicio deste include para definir os campos usados */
DEF TEMP-TABLE tt-trans-ext NO-UNDO
    FIELD i-sequen              AS INTEGER
    FIELD campo                 AS CHARACTER
    FIELD valor                 AS CHARACTER
    INDEX ch-codigo IS UNIQUE PRIMARY i-sequen campo.

/* tt-trans-filho: conteudo das novas transa‡äes (C¢digo 2D),
   substituindo o campo tt-trans.conteudo-trans */
DEF TEMP-TABLE tt-trans-filho NO-UNDO
    FIELD cod-versao-integracao AS INTEGER
    FIELD i-sequen-pai          AS INTEGER
    FIELD i-sequen              AS INTEGER
    FIELD tipo-etiq             AS INTEGER
    FIELD num-versao            AS INTEGER
    FIELD segmento              AS INTEGER
    FIELD registro              AS INTEGER
    FIELD conteudo-xml          AS CHARACTER
    INDEX ch-seq IS UNIQUE PRIMARY i-sequen-pai i-sequen.

/* fim */
