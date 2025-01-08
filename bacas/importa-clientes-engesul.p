DEF VAR c-sequencia AS CHAR NO-UNDO.
DEF VAR c-nome LIKE emitente.nome-emit NO-UNDO.
DEF VAR c-cgc LIKE emitente.cgc NO-UNDO.
DEF VAR c-ie LIKE emitente.ins-estadual NO-UNDO.
DEF VAR c-cep LIKE emitente.cep NO-UNDO.
DEF VAR c-cidade LIKE emitente.cidade NO-UNDO.
DEF VAR c-uf LIKE emitente.estado NO-UNDO.
DEF VAR c-identific AS CHAR FORMAT "x(15)" NO-UNDO.
DEFINE VARIABLE c-tipo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-mercado AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cli-contribuinte AS CHARACTER   NO-UNDO.
DEF VAR c-ins-estadual AS CHAR no-undo.
DEFINE VARIABLE c-insc-municipal AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-suframa AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-endereco AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nro-end AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-fone-1 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-fone-2 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-comple-endereco AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-bairro AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-email AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-pais AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-ativo AS CHARACTER   NO-UNDO.

     

DEF STREAM s-import.
DEF STREAM s-export.

&scop PORTADOR 
&scop MODALIDADE 

&scop STRIP-ACCENT 1
{include/i-freeac.i}    

function get_cgc returns char:
    def var i as int no-undo.
    def var c-aux as char no-undo.
    def var c-result as char no-undo.
    c-aux = c-cgc.
    do i = 1 to length(c-cgc):
        if substring(c-cgc, i, 1) >= "0" and substring(c-cgc, i, 1) <= "9" then
            c-result = c-result + substring(c-cgc, i, 1).
    end.

    return c-result.
end function.   


input stream s-import from value("C:\temp\clientes_faltantes.csv") CONVERT SOURCE SESSION:CHARSET.

OUTPUT STREAM s-export TO c:\temp\clientes_faltantes.lst. /*CONVERT TARGET "iso8859-1".*/

repeat on error undo, leave
       on stop undo, leave transaction:
    assign c-sequencia = "" 
           c-nome = ""
           c-cgc  = ""
           c-ie = ""
           c-cidade = ""
           c-uf = "".

    import stream s-import delimiter ";" 
        c-sequencia c-nome c-tipo c-mercado c-cli-contribuinte c-ins-estadual c-insc-municipal c-cgc c-suframa c-endereco c-nro-end c-fone-1 c-fone-2 
        c-comple-endereco c-cep c-bairro c-cidade c-uf c-pais c-ativo c-email.

    ASSIGN c-cgc = get_cgc()
           c-identific = "".

    &if "{&STRIP-ACCENT}" = "1" &then    
    ASSIGN c-nome = fn-free-accent(c-nome).
           c-cidade = fn-free-accent(c-cidade).
    &endif

/*    DISPLAY STREAM s-export c-sequencia c-nome c-cgc c-ie c-cidade c-uf WITH WIDTH 200.*/

    FIND emitente WHERE
         emitente.cgc = c-cgc NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN DO:
        CASE emitente.identific:
            WHEN 1 THEN
                ASSIGN c-identific = "Cliente".
            WHEN 2 THEN
                ASSIGN c-identific = "Fornecedor".
            WHEN 3 THEN
                ASSIGN c-identific = "Ambos".
        END CASE.
    END.
    ELSE DO:
        ASSIGN c-identific = "".
    END.

/*     IF c-identific <> "" THEN NEXT.  */
/*
    PUT STREAM s-export
        c-sequencia ";"
        c-nome ";" 
        c-cgc FORMAT "99999999999999" ";"
        c-ie ";" 
        c-cidade ";" 
        c-uf ";"
        c-identific SKIP.*/

/*    DISPLAY STREAM s-export c-sequencia c-nome c-cgc c-ie c-cidade c-uf c-identific  NO-LABEL WITH WIDTH 200.*/

    put STREAM s-export
        fill(" ", 6) format "x(6)"                                  /* 1 - 6 brancos*/
        substring(c-nome,1,12) FORMAT "X(12)"                       /* 2 - Nome abreviado do Cliente/Fornecedor */
        c-cgc FORMAT "X(19)"                                        /* 3 - C.G.C.M.F./C.I.C. */
        (if avail emitente then "3" else "1") format "x(01)".       /* 4 - Identificaá∆o */

    case length(trim(c-cgc)):                                       /* 5 - Natureza */
         when 14 then put STREAM s-export "2".
         when 11 then put STREAM s-export "1".
         when 0 then put STREAM s-export "3".
         otherwise put STREAM s-export "1".
    end case.    
        
    put STREAM s-export
        fill(" ", 40) format "x(40)"                                /* 6 - 40 brancos */
        c-endereco + "," + c-nro-end + "-" + c-comple-endereco  FORMAT "X(40)"                                          /* 7 - Endereáo */
        c-bairro format "x(30)"                                /* 8 - Bairro */
        c-cidade  FORMAT "X(25)"                                    /* 9 - Cidade */
        c-uf      FORMAT "X(4)"                                     /* 10- Estado */
        c-cep     FORMAT "X(12)"                                    /* 11 - C¢digo Endereáamento Postal (C.E.P.) */
        fill(" ", 10) format "x(10)"                                /* 12 - Caixa Postal */
        (if length(c-cgc) > 0 then "Brasil" else "") FORMAT "x(20)" /* 13 - Pa°s */
        c-ins-estadual    FORMAT "X(19)"                                                    /* 14 - Inscriá∆o Estadual */
        fill(" ", 2) format "x(2)"                                  /* 15 - 2 brancos */
        fill(" ", 5) format "x(5)"                                  /* 16 - Taxa Financeira */
        fill(" ", 8) format "x(8)"                                  /* 17 - Data Taxa Financeira */
        fill("00000", 5) format "x(5)"                                  /* 18 - C¢digo Transportador Padr∆o */
        "00"                                                        /* 19 - C¢digo do Grupo do Fornecedor */
        fill(" ", 8) format "x(8)"                                  /* 20 - Linha de Produtos */
        fill(" ", 12) format "x(12)"                                /* 21 - Ramo de Atividade */
        fill(" ", 15) format "x(15)"                                /* 22 - Telefax */
        fill(" ", 5) format "x(5)"                                  /* 23 - Ramal do Telefax */
        fill(" ", 15) format "x(15)"                                /* 24 - Telex */
        string(today, "99999999") format "x(8)"                     /* 25 - Data Implantaá∆o */
        fill("00000000000000", 14) format "x(14)"                                /* 26 - Compras no Per°odo */
        (if c-cli-contribuinte = "S" then "1" else "2") format "x(1)"        /* 27 - Contribuinte ICMS */
        fill(" ", 2) format "x(2)"                                  /* 28 - 2 brancos */
        "ENG"                                                      /* 29 - Categoria */
        fill("04000", 5) format "x(5)"                                  /* 30 - C¢digo do Representante */
        fill(" ", 2) format "x(2)"                                  /* 31 - 2 brancos */
        fill(" ", 5) format "x(5)"                                  /* 32 - Bonificaá∆o (Desconto Padr∆o cliente) */
        "2" format "x(1)"                                           /* 33 - Abrangància da Avaliaá∆o de CrÇdito */
        "95"                                                        /* 34 - Grupo de cliente = 95 - A Definir */       
        fill("00000000000", 11) format "x(11)"                                /* 35 - Limite de CrÇdito */
        fill(" ", 8) format "x(8)"                                  /* 36 - Data Limite de CrÇdito */
        fill(" ", 3) format "x(3)"                                  /* 37 - Percentual M†ximo Faturado por Per°odo */
        "00999"        format "x(5)"                                  /* 38 - Portador */
        "01"         format "x(2)"                                  /* 39 - Modalidade */
        "1" format "x(1)"                                  /* 40 - Aceita Faturamento Parcial */
        "1" format "x(1)"                                  /* 41- Indicador de CrÇdito */
        fill(" ", 1) format "x(1)"                                  /* 42 - Avaliaá∆o de CrÇdito */
        fill(" ", 6) format "x(6)"                                  /* 43 - Natureza de Operaá∆o */
        fill(" ", 150) format "x(150)"                              /* 44 - Observaá∆o 1 */
        fill("0000 ", 4) format "x(4)"                                  /* 45 - Percentual Minimo Por Faturamento Parcial */
        "1"                                                         /* 46 - Meio Para Emiss∆o de Pedido de Compra */
        substring(c-nome,1,12) FORMAT "X(12)"                       /* 47 - Nome Fantasia da Matriz do Cliente */
        fill(" ", 15) format "x(15)"                                /* 48 - Telefone Modem */
        fill(" ", 5) format "x(5)"                                  /* 49 - Ramal do Modem */
        fill(" ", 15) format "x(15)"                                /* 50 - Telefax */
        fill(" ", 5) format "x(5)"                                  /* 51 - Ramal do Telefax */
        fill(" ", 7) format "x(7)"                                  /* 52 - Agància do Cliente/Fornecedor */
        fill(" ", 1) format "x(1)"                                  /* 53 - 1 branco */
        fill(" ", 8) format "x(8)"                                  /* 54 - N£mero de T°tulos */
        fill(" ", 8) format "x(8)"                                  /* 55 - N£mero de Dias */
        fill(" ", 4) format "x(4)"                                  /* 56 - Percentual M†ximo de cancelamento Quant. Aberto */
        "01011900" format "x(8)"                                  /* 57 - Data da Èltima Nota Fiscal Emitida */
        "2"                                                         /* 58 - Emite Bloquete Para T°tulo */
        "2"                                                         /* 59 - Emite Etiqueta Para Correspondància */
        "2"                                                         /* 60 - Valores de Recebimento */
        "2"                                                         /* 61 - Gera Aviso de DÇbito */
        "00999"           format "x(5)"                                 /* 62 - Portador Preferencial */
        "01"            format "x(2)"                               /* 63 - Modalidade Preferencial */
        fill(" ", 3) format "x(3)"                                  /* 64 - Baixa N∆o Acatada */
        fill("0000000000", 10) format "x(10)"                                /* 65 - Conta Corrente do Cliente/Fornecedor */
        fill("00", 2) format "x(2)"                                  /* 66 - D°gito da Conta Corrente do Cliente/Fornecedor */
        "0000"          format "x(4)"                                  /* 67 - Condiá∆o de pagamento */
        fill(" ", 4) format "x(4)"                                  /* 68 - 4 brancos */
        fill("00", 2) format "x(2)"                                  /* 69 - N£mero de C¢pias do Pedido de Compra */
        c-suframa format "x(20)"                                /* 70 - C¢digo Suframa */
        fill(" ", 20) format "x(20)"                                /* 71 - C¢digo Cacex */
        fill("0", 1) format "x(1)"                                  /* 72 - Gera Diferenáa de Preáo */
        fill(" ", 8) format "x(8)"                                  /* 73 - Tabela de Preáos */    
        fill("3", 1) format "x(1)"                                  /* 74 - Indicador de Avaliaá∆o */
        fill(" ", 12) format "x(12)"                                /* 75- Usu†rio libera CrÇdito */
        fill("3", 1) format "x(1)"                                  /* 76- Vencimento Domingo */
        fill("3", 1) format "x(1)"                                  /* 77 - Vencimento S†bado */
        c-cgc format "x(19)"                                /* 78 - C.G.C. Cobranáa */
        c-cep format "x(12)"                                /* 79 - C.E.P. Cobranáa */
/*        fill(" ", 4) format "x(4)"                                  /* 80 - Estado Cobranáa */*/
        c-uf      FORMAT "X(4)"                                     /* 80 - Estado Cobranáa */
        c-cidade  FORMAT "X(25)"                                    /* 81 - Cidade Cobranáa */ 
/*        fill(" ", 25) format "x(25)"                                /* 81 - Cidade Cobranáa */*/
        c-bairro format "x(30)"                                /* 82 - Bairro Cobranáa */
        c-endereco + "," + c-nro-end + "-" + c-comple-endereco  format "x(40)"                                /* 83 - Endereáo Cobranáa */
        fill(" ", 10) format "x(10)"                                /* 84 - Caixa Postal Cobranáa */
        c-ins-estadual format "x(19)"                                /* 85 - Inscriá∆o Estadual Cobranáa */               
        "999" format "x(3)"                                  /* 86 - Banco do Cliente/Fornecedor */
        fill("010101 ", 6) format "x(6)"                                  /* 87 - Pr¢ximo Aviso DÇbito */
        "1"         /* 88 - Tipo do Registro */
        fill("1", 1) format "x(1)"                                  /* 89 - Vencimento Feriado */
        fill("1", 2) format "x(2)"                                  /* 90 - Tipo de Pagamento */
        fill("1", 1) format "x(1)"                                  /* 91 - Tipo de Cobranáa das Despesas */
        c-insc-municipal format "x(19)"                                /* 92 - Inscriá∆o Municipal */
        fill("000", 3) format "x(3)"                                  /* 93 - Tipo de Despesa Padr∆o */
        fill("000", 3) format "x(3)"                                  /* 94 - Tipo de Receita Padr∆o */
        fill(" ", 12) format "x(12)"                                /* 95 - C¢digo de Endereáamento Postal Estrangeiro */
        fill(" ", 12) format "x(12)"                                /* 96 - Micro Regi∆o */
        fill(" ", 3) format "x(3)"                                  /* 97 - 3 Brancos */
        c-fone-1 format "x(15)"                                /* 98 - Telefone[1] */
        c-fone-2 format "x(15)"                                /* 99 - Telefone[2] */
        fill("0", 2) format "x(2)"                                  /* 100 - N£mero de Meses Inativos */
        fill(" ", 3) format "x(3)"                                  /* 101 - Instruá∆o Banc†ria(1) */
        fill(" ", 3) format "x(3)"                                  /* 102 - Instruá∆o Banc†ria(2) */
        fill(" ", 6) format "x(6)"                                  /* 103 - Natureza Interestadual */
        fill("000000000", 9) format "x(9)"                                  /* 104 - C¢digo do Cliente */
        fill("000000000", 9) format "x(9)"                                  /* 105 - C¢digo do Cliente de Cobranáa */
        fill(" ", 1) format "x(1)"                                  /* 106 - Utiliza verba publicidade*/
        fill(" ", 6) format "x(6)"                                  /* 107 - Percentual verba publicidade */
        c-email format "x(40)"                                /* 108 - E-mail */
        fill(" ", 1) format "x(1)"                                  /* 109 - Indicador de Avaliaá∆o de Embarque */
        fill("000", 3) format "x(3)"                                  /* 110 - Canal de Venda */
        fill(" ", 2000) format "x(2000)"                            /* 111 - Endereáo cobranáa completo */
        fill(" ", 2000) format "x(2000)"                            /* 112 - Endereáo cobranáa */
        (if length(c-cgc) > 0 then "Brasil" else "") FORMAT "x(20)" /* 113 - Pa°s */
/*        fill(" ", 20) format "x(20)"                                /* 113 - Pa°s de Cobranáa */*/
        "1"                                                         /* 114 - Situaá∆o do fornecedor */
        fill(" ", 8) format "x(8)"                                  /* 115 - Data vigància inicial */    
        fill(" ", 8) format "x(8)"                                  /* 116 - Data vigància final */    
        fill(" ", 20) format "x(20)"                                /* 117 - Incris∆o INSS */
        fill("1", 1) format "x(1)"                                  /* 118 - Tributa COFINS */
        fill("1", 1) format "x(1)"                                  /* 119 - Tributa PIS */    
        fill("1", 1) format "x(1)"                                  /* 120 - Controla Valor M†ximo INSS */
        fill("1", 1) format "x(1)"                                  /* 121 - Calcula PIS/COFINS por Unidade */ 
        fill(" ", 1) format "x(1)"                                  /* 122 - Retem Pagto */   
        "00999"        format "x(5)"                                  /* 123 - Portador Fornecedor */
        "1"          format "x(2)"                                  /* 124 - Modalidade Fornecedor */
        fill(" ", 1) format "x(1)"                                  /* 125 - Contribuinte Substituto Intermedi†rio */
        c-nome                                                      /* 126 - */.

    put STREAM s-export skip.                

END.

OUTPUT STREAM s-export CLOSE.

INPUT STREAM s-import CLOSE.
