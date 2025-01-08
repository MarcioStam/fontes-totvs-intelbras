def var h-bcapi010  as handle.

/*** Esta tabela pertence ao bancos :mgcld    ***/ 
Define temp-table tt-bc-trans NO-UNDO
        field cod-versao-integracao             as  inte            format "999"
        field cd-trans                          as  character       format "x(8)"
        field data                              as  date            format "99/99/9999"
        field data-atualizacao                  as  date            format "99/99/9999"
        field detalhe                           as  character       format "x(60)"
        field ep-codigo                         LIKE mgcad.empresa.ep-codigo
        field estado-trans                      as  integer         format ">9"
        field etiq-impressa                     as  logical         format "Sim/N’o"
        field hora-atualizacao                  as  character       format "x(08)"
        field horario                           as  character       format "x(08)"
        field nr-trans                          as  decimal         format "zzzzzzzzz9"
        field usuario                           as  character       format "x(12)".

/*** Esta tabela pertence ao bancos :mgcld    ***/ 

Define temp-table tt-bc-tipo-trans NO-UNDO
        field cod-versao-integracao             as  inte            format "999"
        field api-atualizacao                   as  character       format "x(256)"
        field atualiz-etiq                      as  logical         format "sim/n’o"
        field atualiza-on-line                  as  logical         format "Sim/N’o"
        field cd-trans                          as  character       format "x(8)"
        field char-1                            as  character       format "x(100)"
        field char-2                            as  character       format "x(100)"
        field check-sum                         as  character       format "x(20)"
        field data-1                            as  date            format "99/99/9999"
        field data-2                            as  date            format "99/99/9999"
        field dec-1                             as  decimal         format "->>>>>>>>>>>9.99999999"
        field dec-2                             as  decimal         format "->>>>>>>>>>>9.99999999"
        field descricao                         as  character       format "x(30)"
        field erros-on-line                     as  logical         format "Sim/N’o"
        field gera-etiq-total                   as  logical         format "sim/n’o"
        field imp-apos-trans                    as  logical         format "Sim/N’o"
        field int-1                             as  integer         format "->>>>>>>>>9"
        field int-2                             as  integer         format "->>>>>>>>>9"
        field log-1                             as  logical         format "Sim/N’o"
        field log-2                             as  logical         format "Sim/N’o"
        field prog-altera                       as  character       format "x(256)"
        field prog-criacao                      as  character       format "x(256)"
        field prog-etiq                         as  character       format "x(256)"
        field prog-import                       as  character       format "x(256)"
        field prog-leitura                      as  character       format "x(256)"
        field tipo-etiq                         as  integer         format "9999"
        field tipo-etiq-total                   as  integer         format "9999".
