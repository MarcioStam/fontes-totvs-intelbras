/********************************************************************************
** Copyright Intelbras S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da Intelbras, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*{include/i-prgvrs.i <Nome do Programa> 2.00.00.000}  /*** 010000 ***/*/
/*******************************************************************************
**  Programa: ADEEDIT\(C).P
**  Objetivo: <comment>
**  Autor...: Intelbras - USER    
**  Data....: 19.05.2008 16:11
*******************************************************************************/
def var h-acomp      as handle no-undo.
DEFINE VARIABLE c-dir-saida AS CHARACTER   NO-UNDO.

run utp/ut-acomp.p persistent set h-acomp.  

RUN pi-inicializar in h-acomp (input "Imprimindo...").

{esp/es0018.i}


EMPTY TEMP-TABLE tt-prog-ponto.

RUN esp/es0018p.p (INPUT "SPOOL-WIN":U,
                   INPUT 1,
                   INPUT 0,
                   INPUT "":U,
                   OUTPUT TABLE tt-prog-ponto).

FOR FIRST tt-prog-ponto:

    ASSIGN c-dir-saida = replace(tt-prog-ponto.conteudo, "/", "~\").

    IF SUBSTRING(c-dir-saida, LENGTH(c-dir-saida), 1) <> "~\" THEN
        ASSIGN c-dir-saida = c-dir-saida + "~\".

END.


/*
OUTPUT TO \\intel200\spool\an046325\crm\repres.csv.

FOR EACH repres
    WHERE repres.ind-situacao = 1 NO-LOCK:

    RUN pi-acompanhar in h-acomp (input "Representante"  + string(repres.cod-rep)).

    PUT repres.cod-rep             ";"
        repres.nome                ";"
        repres.endereco            ";"
        repres.bairro              ";"
        repres.cidade              ";"
        repres.estado              ";"
        repres.pais                ";"
        repres.cep                 ";"
        repres.caixa-postal        ";"
        repres.Complemento         ";"
        repres.telefone[1]         ";"
        repres.telefone[2]         ";"
        repres.telefax             ";"
        repres.e-mail              ";"
        repres.natureza            ";"
        repres.cgc                 ";"
        repres.inscr-est           ";"
        repres.ins-municipal SKIP.

END.
OUTPUT CLOSE.

OUTPUT TO \\intel200\spool\an046325\crm\cliente.csv.
OUTPUT CLOSE.
OUTPUT TO \\intel200\spool\an046325\crm\cont-cliente.csv.
OUTPUT CLOSE.

FOR EACH emitente NO-LOCK
    WHERE emitente.identific <> 2,
    FIRST int-emitente NO-LOCK
    WHERE int-emitente.cod-emitente = emitente.cod-emitente
      AND int-emitente.id-ativo     = YES:

    RUN pi-acompanhar in h-acomp (input "Cliente"  + string(emitente.cod-emitente)).

    OUTPUT TO \\intel200\spool\an046325\crm\cliente.csv APPEND.
    PUT emitente.cod-emitente   ";"
        emitente.nome-abrev     ";"
        emitente.nome-emit      ";"
        emitente.nome-matriz    ";"
        emitente.cod-gr-cli     ";"
        emitente.cod-rep        ";"
        emitente.data-implant   ";"
        emitente.endereco       ";"
        emitente.bairro         ";"
        emitente.cidade         ";"
        emitente.estado         ";"
        emitente.pais           ";"
        emitente.cep            ";"
        emitente.telefone[1]    ";"
        emitente.telefone[2]    ";"
        emitente.telefax        ";"
        emitente.e-mail         ";"
        emitente.natureza       ";" /* Pessoa Fisica, Juridica, Estrangeiro, Trading */
        emitente.cgc            ";"
        emitente.ins-estadual   ";"
        emitente.ins-municipal SKIP.
    OUTPUT CLOSE.
    OUTPUT TO \\intel200\spool\an046325\crm\cont-cliente.csv APPEND.
    FOR EACH cont-emit
        WHERE cont-emit.cod-emitente = emitente.cod-emitente
           AND NOT cont-emit.nome BEGINS "Nfe" NO-LOCK:
        PUT cont-emit.nome ";"
            cont-emit.cargo ";"
            cont-emit.area ";"
            cont-emit.identific ";"
            cont-emit.e-mail ";"
            cont-emit.telefone ";"
            cont-emit.ramal ";"
            cont-emit.telefax SKIP.
    END.
    OUTPUT CLOSE.
END.
OUTPUT CLOSE.

def variable c-unidade like unid-neg-fam.cod_unid_negoc.

OUTPUT TO \\intel200\spool\an046325\crm\itens.csv.
FOR EACH item
    WHERE ITEM.it-codigo BEGINS "4" NO-LOCK:
    RUN pi-acompanhar in h-acomp (input "Item "  + ITEM.it-codigo).

     find first unid-neg-item no-lock
        where unid-neg-item.it-codigo = item.it-codigo no-error.
     if available unid-neg-item then
        assign c-unidade = unid-neg-item.cod_unid_negoc.
  
     if c-unidade = '' and available fam-comerc then do:
        find first unid-neg-fam-com no-lock
           where unid-neg-fam-com.fm-codigo = fam-comerc.fm-cod-com no-error.
        if available unid-neg-fam-com then
           assign c-unidade = unid-neg-fam-com.cod_unid_negoc.
     end.
  
     if c-unidade = '' and available item then do:
        find first unid-neg-fam no-lock
           where unid-neg-fam.fm-codigo = item.fm-codigo no-error.
        if available unid-neg-fam then
           assign c-unidade = unid-neg-fam.cod_unid_negoc.
     end.    
     
    PUT ITEM.it-codigo   ";"
        ITEM.desc-item   ";"
        ITEM.fm-cod-com  ";"
        c-unidade        ";"
        ITEM.un          ";"
        ITEM.data-implant SKIP.
END.
OUTPUT CLOSE.

OUTPUT TO \\intel200\spool\an046325\crm\familia-comercial.csv.
FOR EACH fam-comerc NO-LOCK:
    RUN pi-acompanhar in h-acomp (input "Familia Comercial "  + fam-comerc.fm-cod-com).
    PUT fam-comerc.fm-cod-com    ";"
        fam-comerc.descricao SKIP.
END.
OUTPUT CLOSE.

*/
OUTPUT TO VALUE(c-dir-saida + "spool~\an046325~\crm~\Grupo-clientes.csv").
    PUT "Cod-gr-cli ; Descricao" SKIP.

FOR EACH  gr-cli NO-LOCK:
    RUN pi-acompanhar in h-acomp (input "Grupo de Clientes "  + STRING(gr-cli.cod-gr-cli)).
    PUT gr-cli.cod-gr-cli ";"
        gr-cli.descricao SKIP.
END.
OUTPUT CLOSE.


/*    */
/* OUTPUT TO \\intel200\spool\an046325\crm\familia-materiais.csv. */
/* FOR EACH familia NO-LOCK: */
/*     RUN pi-acompanhar in h-acomp (input "Familia "  + familia.fm-codigo). */
/*     PUT familia.fm-codigo ";" */
/*         familia.descricao SKIP. */
/* END. */
/* OUTPUT CLOSE. */
    RUN pi-finalizar in h-acomp.
