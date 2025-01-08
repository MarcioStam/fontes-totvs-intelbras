/**************************************************************************
**
**   Include: BCAPI002.I - Definicao das temp-table 
**                                       tt-etiqueta
**
***************************************************************************/
/*
def temp-table tt-etiqueta no-undo
    field cod-versao-integracao as inte                             /* Obrigatorio     */
    field i-sequen              as inte                             /* Obrigatorio     */
    field nr-trans              as deci format "zzzzzzzzz9"         /* Nao Obrigatorio */
    field nr-trans-ant          as deci format "zzzzzzzzz9"         /* Nao Obrigatorio */
    field cd-trans              as char format "x(8)"               /* Obrigatorio     */
    field usuario               as char format "x(12)"              /* Nao Obrigatorio */
    field arquivo               as char format "x(100)"             /* Nao Obrigatorio */
    field cod-unico             as char format "x(16)"              /* Reservado       */
    field it-codigo             as char format "x(16)"              /* Obrigatorio     */
    field dt-impressao          as date format "99/99/9999"         /* Nao Obrigatorio */
    field dt-val-lote           as date format "99/99/9999"         /* Nao Obrigatorio */
    field cod-depos             as char format "x(3)"               /* Obrigatorio     */
    field desc-item             as char format "x(36)"              /* Nao Obrigatorio */
    field cod-estabel           LIKE estabelec.cod-estabel          /* Obrigatorio     */
    field hora-Impressao        as char format "x(8)"               /* Nao Obrigatorio */
    field cod-localiz           as char format "x(20)"              /* Obrigatorio     */
    field lote                  as char format "x(40)"              /* Obrigatorio     */
    field nr-docto              as char format "x(16)"              /* Obrigatorio     */
    field quantidade            as deci format "->>>>,>>>,>>9.9999" /* Obrigatorio     */
    field qt-etiqueta           as inte                             /* Nao Obrigatorio */
    field cod-referencia        as char format "x(8)"               /* Nao Obrigatorio */
    field tipo-etiq             as inte format "9999"               /* Reservado       */
    field desc-etiqueta         as char format "x(050)"             /* Nao Obrigatorio */
    field observacao            as char format "x(100)"             /* Nao Obrigatorio */
    field serie-docto           as char format "x(5)"               /* Nao Obrigatorio */
    field cod-emitente          as inte format ">>>>>>>>9"          /* Nao Obrigatorio */
    field nat-operacao          as char format "9.99-XXX"           /* Nao Obrigatorio */
    field auxiliar-01           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-02           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-03           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-04           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-05           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-06           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-07           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-08           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-09           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-10           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-11           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-12           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-13           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-14           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-15           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-16           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-17           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-18           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-19           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-20           as char format "x(001)"             /* Nao Obrigatorio */
    field data-movimento        as date format "99/99/9999"         /* Nao Obrigatorio */
    field nr-sequencia          as inte format ">>9"                /* Nao Obrigatorio */
    field it-codigo-ext-1       as char format "X(16)"              /* Nao Obrigatorio */
    field it-codigo-ext-2       as char format "X(16)"              /* Nao Obrigatorio */
    field it-codigo-ext-3       as char format "X(16)"              /* Nao Obrigatorio */
    field it-codigo-ext-4       as char format "X(16)"              /* Nao Obrigatorio */
    field peso-bruto            as dec  format ">>>>>>>>9.999"      /* Nao Obrigatorio */
    field peso-liquido          as dec  format ">>>>>>>>9.999"      /* Nao Obrigatorio */
    field nr-embalagem          as dec  format ">>>>>>>>9.999"      /* Nao Obrigatorio */
    field qt-item-cli           as dec  format ">>>>>>>>9.999"      /* Nao Obrigatorio */
    field unidade-med-cli       as char format "x(02)"              /* Nao Obrigatorio */
    field cod-complementar      as char format "x(40)"              /* Nao Obrigatorio */
    field tag-epc-rfid          as char format "x(24)"              /* Nao Obrigatorio */
    index ch-seq is unique primary i-sequen.
*/

def temp-table tt-etiqueta no-undo
    field cod-versao-integracao as inte                             /* Obrigatorio     */
    field i-sequen              as inte                             /* Obrigatorio     */
    field nr-trans              as deci format "zzzzzzzzz9"         /* Nao Obrigatorio */
    field nr-trans-ant          as deci format "zzzzzzzzz9"         /* Nao Obrigatorio */
    field cd-trans              as char format "x(8)"               /* Obrigatorio     */
    field usuario               as char format "x(12)"              /* Nao Obrigatorio */
    field arquivo               as char format "x(100)"             /* Nao Obrigatorio */
    field cod-unico             as char format "x(16)"              /* Reservado       */
    field it-codigo             as char format "x(16)"              /* Obrigatorio     */
    field dt-impressao          as date format "99/99/9999"         /* Nao Obrigatorio */
    field dt-val-lote           as date format "99/99/9999"         /* Nao Obrigatorio */
    field cod-depos             as char format "x(3)"               /* Obrigatorio     */
    field desc-item             as char format "x(36)"              /* Nao Obrigatorio */
    field cod-estabel           LIKE estabelec.cod-estabel          /* Obrigatorio     */
    field hora-Impressao        as char format "x(8)"               /* Nao Obrigatorio */
    field cod-localiz           as char format "x(20)"              /* Obrigatorio     */
    field lote                  as char format "x(40)"              /* Obrigatorio     */
    field nr-docto              as char format "x(16)"              /* Obrigatorio     */
    field quantidade            as deci format "->>>>,>>>,>>9.9999" /* Obrigatorio     */
    field qt-etiqueta           as inte                             /* Nao Obrigatorio */
    field cod-referencia        as char format "x(8)"               /* Nao Obrigatorio */
    field tipo-etiq             as inte format "9999"               /* Reservado       */
    field desc-etiqueta         as char format "x(050)"             /* Nao Obrigatorio */
    field observacao            as char format "x(100)"             /* Nao Obrigatorio */
    field serie-docto           as char format "x(5)"               /* Nao Obrigatorio */
    field cod-emitente          as inte format ">>>>>>>>9"          /* Nao Obrigatorio */
    field nat-operacao          as char format "9.99-XXX"           /* Nao Obrigatorio */
    field auxiliar-01           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-02           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-03           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-04           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-05           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-06           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-07           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-08           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-09           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-10           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-11           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-12           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-13           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-14           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-15           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-16           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-17           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-18           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-19           as char format "x(001)"             /* Nao Obrigatorio */
    field auxiliar-20           as char format "x(001)"             /* Nao Obrigatorio */
    field data-movimento        as date format "99/99/9999"         /* Nao Obrigatorio */
    field nr-sequencia          as inte format ">>9"                /* Nao Obrigatorio */
    field it-codigo-ext-1       as char format "X(16)"              /* Nao Obrigatorio */
    field it-codigo-ext-2       as char format "X(16)"              /* Nao Obrigatorio */
    field it-codigo-ext-3       as char format "X(16)"              /* Nao Obrigatorio */
    field it-codigo-ext-4       as char format "X(16)"              /* Nao Obrigatorio */
    field peso-bruto            as dec  format ">>>>>>>>9.999"      /* Nao Obrigatorio */
    field peso-liquido          as dec  format ">>>>>>>>9.999"      /* Nao Obrigatorio */
    field nr-embalagem          as dec  format ">>>>>>>>9.999"      /* Nao Obrigatorio */
    field qt-item-cli           as dec  format ">>>>>>>>9.999"      /* Nao Obrigatorio */
    field unidade-med-cli       as char format "x(02)"              /* Nao Obrigatorio */
    field cod-complementar      as char format "x(40)"              /* Nao Obrigatorio */
    field rfid-epc-totvs        as char format "x(24)"              /* Nao Obrigatorio  - o campo anterior era chamado de tag-epc-rfid*/ 
    field rfid-epc-gs1          as char format "x(24)"              /* Nao Obrigatorio */
    field rfid-cod-gtin         as char format "x(20)"              /* Nao Obrigatorio */
    field rfid-sequencial       as dec  format ">>>>>>>>>>>>>>>>>>>9" /* Nao Obrigatorio */
    index ch-seq is unique primary i-sequen.



