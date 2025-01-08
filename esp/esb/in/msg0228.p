CREATE WIDGET-POOL.

DEFINE INPUT  PARAMETER iXML AS LONGCHAR NO-UNDO.
DEFINE OUTPUT PARAMETER oXML AS LONGCHAR NO-UNDO.

/* DEF VAR  iXML AS LONGCHAR NO-UNDO.                                              */
/* DEF VAR  oXML AS LONGCHAR NO-UNDO.                                              */
/*                                                                                 */
/* ASSIGN iXML = "<?xml version='1.0' encoding='UTF-8'?>                           */
/* <MENSAGEM>                                                                      */
/*   <CABECALHO>                                                                   */
/*     <IdentidadeEmissor>AB3D47B8-C821-4281-ADC4-267785D821CD</IdentidadeEmissor> */
/*     <NumeroOperacao>MSG0228</NumeroOperacao>                                    */
/*     <CodigoMensagem>MSG0228</CodigoMensagem>                                    */
/*     <LoginUsuario>ToolSystems</LoginUsuario>                                    */
/*   </CABECALHO>                                                                  */
/*   <CONTEUDO>                                                                    */
/*     <MSG0228>                                                                   */
/*         <Identificadores>                                                       */
/*            <IdentificacaoCampo>1</IdentificacaoCampo>                           */
/*         </Identificadores>                                                      */
/*         <Identificadores>                                                       */
/*            <IdentificacaoCampo>2</IdentificacaoCampo>                           */
/*         </Identificadores>                                                      */
/*         <Identificadores>                                                       */
/*            <IdentificacaoCampo>3</IdentificacaoCampo>                           */
/*         </Identificadores>                                                      */
/*         <Identificadores>                                                       */
/*            <IdentificacaoCampo>4</IdentificacaoCampo>                           */
/*         </Identificadores>                                                      */
/*         <Identificadores>                                                       */
/*            <IdentificacaoCampo>5</IdentificacaoCampo>                           */
/*         </Identificadores>                                                      */
/*         <Identificadores>                                                       */
/*            <IdentificacaoCampo>6</IdentificacaoCampo>                           */
/*         </Identificadores>                                                      */
/*         <Identificadores>                                                       */
/*            <IdentificacaoCampo>7</IdentificacaoCampo>                           */
/*         </Identificadores>                                                      */
/*         <Identificadores>                                                       */
/*            <IdentificacaoCampo>8</IdentificacaoCampo>                           */
/*         </Identificadores>                                                      */
/*     </MSG0228>                                                                  */
/*   </CONTEUDO>                                                                   */
/* </MENSAGEM>" .                                                                  */

{esp/esb/in/msg0228.i}

DEFINE DATASET mensagem XML-NODE-NAME 'MENSAGEM' FOR cabecalho, conteudo, MSG0228, Identificadores
   DATA-RELATION FOR conteudo, MSG0228        RELATION-FIELDS (idm, idm) NESTED
   DATA-RELATION FOR MSG0228, Identificadores RELATION-FIELDS (idm, idm) NESTED.

DATASET mensagem:READ-XML('LONGCHAR', iXML, 'EMPTY', ?, ?).

DEFINE DATASET mensagemr XML-NODE-NAME 'MENSAGEM' FOR cabecalhor, conteudor, MSG0228R1, ListaRegistrosCampos, RegistroCampo, resultado
   DATA-RELATION FOR conteudor, MSG0228R1                RELATION-FIELDS (idm, idm)                               NESTED
   DATA-RELATION FOR MSG0228R1, ListaRegistrosCampos     RELATION-FIELDS (idm, idm)                               NESTED
   DATA-RELATION FOR ListaRegistrosCampos, RegistroCampo RELATION-FIELDS (IdentificacaoCampo, IdentificacaoCampo) NESTED
   DATA-RELATION FOR MSG0228R1, resultado                RELATION-FIELDS (idm, idm)                               NESTED.

CREATE cabecalhor.
FIND cabecalho NO-ERROR.

BUFFER-COPY cabecalho EXCEPT IdentidadeEmissor TO cabecalhor.

ASSIGN cabecalhor.CodigoMensagem    = 'MSG0228R1'
       cabecalhor.IdentidadeEmissor = "64546C2E-6DAB-4311-A74A-5ACA96134AFF".

FIND FIRST MSG0228 NO-ERROR.

CREATE conteudor.
CREATE MSG0228R1.
CREATE resultado.

RUN pi-gera-retorno.

IF  RETURN-VALUE <> "OK" THEN DO:
    ASSIGN resultado.sucesso    = no
           resultado.CodigoErro = 17006
           resultado.Mensagem   = "".

    FOR EACH tt-erro
        BREAK BY tt-erro.Mensagem:
        ASSIGN resultado.Mensagem =  resultado.Mensagem + tt-erro.mensagem + IF  NOT FIRST-OF (tt-erro.mensagem) THEN ";" ELSE "".
    END.
END.

DATASET mensagemr:WRITE-XML('longchar', oXML, NO).

/* define variable hDoc    as handle   no-undo.                                                 */
/* create x-document hDoc.                                                                      */
/* hDoc:LOAD("longchar", oXML, NO).                                                             */
/* hDoc:SAVE("file","C:/temp/xml-saida" + replace(STRING(TIME, "HH:MM:SS"), ":", "") + ".xml"). */

RETURN.

PROCEDURE pi-gera-retorno:

    FOR EACH Identificadores:

        IF NOT CAN-FIND (FIRST ListaRegistrosCampos
                         WHERE ListaRegistrosCampos.IdentificacaoCampo = Identificadores.IdentificacaoCampo) THEN DO:

            CREATE ListaRegistrosCampos.
            ASSIGN ListaRegistrosCampos.IdentificacaoCampo = Identificadores.IdentificacaoCampo.

        END.

        /*Incoterm*/
        IF Identificadores.IdentificacaoCampo = 1 THEN DO:
            
            FOR EACH inco-cx NO-LOCK:
                
                CREATE RegistroCampo.
                ASSIGN RegistroCampo.IdentificacaoCampo = Identificadores.IdentificacaoCampo
                       RegistroCampo.CodigoRegistro     = inco-cx.cod-incoterm
                       RegistroCampo.DescricaoRegistro  = inco-cx.descricao.
            END.
        END.

        /*Itinerario*/
        ELSE IF Identificadores.IdentificacaoCampo = 2 THEN DO:
            FOR EACH itinerario NO-LOCK:
                CREATE RegistroCampo.
                ASSIGN RegistroCampo.IdentificacaoCampo = Identificadores.IdentificacaoCampo
                       RegistroCampo.CodigoRegistro     = STRING(itinerario.cod-itiner)
                       RegistroCampo.DescricaoRegistro  = itinerario.descricao.
            END.
        END.

        /*Despesa*/
        ELSE IF Identificadores.IdentificacaoCampo = 3 THEN DO:
            FOR EACH desp-imp NO-LOCK:

                IF CAN-FIND (FIRST int-desp-imp
                             WHERE int-desp-imp.cod-desp = desp-imp.cod-desp
                               AND NOT int-desp-imp.log-ativo-portal)  THEN
                    NEXT.

                CREATE RegistroCampo.
                ASSIGN RegistroCampo.IdentificacaoCampo = Identificadores.IdentificacaoCampo
                       RegistroCampo.CodigoRegistro     = string(desp-imp.cod-desp)
                       RegistroCampo.DescricaoRegistro  = desp-imp.descricao.
            END.
        END.

        /*Dep¢sito*/
        ELSE IF Identificadores.IdentificacaoCampo = 4 THEN DO:
             FOR EACH deposito NO-LOCK:
                CREATE RegistroCampo.
                ASSIGN RegistroCampo.IdentificacaoCampo = Identificadores.IdentificacaoCampo
                       RegistroCampo.CodigoRegistro     = deposito.cod-depos
                       RegistroCampo.DescricaoRegistro  = deposito.nome.
            END.
        END.    

        /*TipoDespesa*/
        ELSE IF Identificadores.IdentificacaoCampo = 5 THEN DO:
            FOR EACH tipo-rec-desp
               WHERE tipo-rec-desp.tipo = 2 NO-LOCK:
                CREATE RegistroCampo.
                ASSIGN RegistroCampo.IdentificacaoCampo = Identificadores.IdentificacaoCampo
                       RegistroCampo.CodigoRegistro     = STRING(tipo-rec-desp.tp-codigo)
                       RegistroCampo.DescricaoRegistro  = tipo-rec-desp.descricao.
            END.
        END.

        /*TipoReceita*/
        ELSE IF Identificadores.IdentificacaoCampo = 6 THEN DO:
            FOR EACH tipo-rec-desp
               WHERE tipo-rec-desp.tipo = 1 NO-LOCK:
                CREATE RegistroCampo.
                ASSIGN RegistroCampo.IdentificacaoCampo = Identificadores.IdentificacaoCampo
                       RegistroCampo.CodigoRegistro     = STRING(tipo-rec-desp.tp-codigo)
                       RegistroCampo.DescricaoRegistro  = tipo-rec-desp.descricao.
            END.
        END.

        /*GrupoFornecedores*/
        ELSE IF Identificadores.IdentificacaoCampo = 7 THEN DO:
            FOR EACH grupo-fornec NO-LOCK:
                CREATE RegistroCampo.
                ASSIGN RegistroCampo.IdentificacaoCampo = Identificadores.IdentificacaoCampo
                       RegistroCampo.CodigoRegistro     = STRING(grupo-fornec.cod-gr-forn)
                       RegistroCampo.DescricaoRegistro  = grupo-fornec.descricao.
            END.
        END.

        /*Comprador*/
        ELSE IF Identificadores.IdentificacaoCampo = 8 THEN DO:
            FOR EACH usuar-mater NO-LOCK
               WHERE usuar-mater.usuar-comprado:

                 FIND FIRST usuar_mestre
                      WHERE usuar_mestre.cod_usuario = usuar-mater.cod-usuario
                            NO-LOCK NO-ERROR.

                 CREATE RegistroCampo.
                 ASSIGN RegistroCampo.IdentificacaoCampo = Identificadores.IdentificacaoCampo
                        RegistroCampo.CodigoRegistro     = usuar-mater.cod-usuario
                        RegistroCampo.DescricaoRegistro  = IF usuar-mater.nome-usuar <> "" THEN usuar-mater.nome-usuar ELSE usuar_mestre.nom_usuario WHEN AVAIL usuar_mestre.
            END.
        END.

        /*Banco*/
        ELSE IF Identificadores.IdentificacaoCampo = 9 THEN DO:
            FOR EACH mgcad.banco NO-LOCK:

                 CREATE RegistroCampo.
                 ASSIGN RegistroCampo.IdentificacaoCampo = Identificadores.IdentificacaoCampo
                        RegistroCampo.CodigoRegistro     = string(banco.cod-banco)
                        RegistroCampo.DescricaoRegistro  = banco.nome-banco.
            END.
        END.

        /*Banco*/
        ELSE IF Identificadores.IdentificacaoCampo = 10 THEN DO:
            FOR EACH pto-contr NO-LOCK:

                 CREATE RegistroCampo.
                 ASSIGN RegistroCampo.IdentificacaoCampo = Identificadores.IdentificacaoCampo
                        RegistroCampo.CodigoRegistro     = string(pto-contr.cod-pto-contr)
                        RegistroCampo.DescricaoRegistro  = pto-contr.descricao.
            END.
        END.

        /*Comprador*/
        ELSE IF Identificadores.IdentificacaoCampo = 11 THEN DO:
            FOR EACH usuar-mater NO-LOCK
               WHERE usuar-mater.usuar-requis,
           FIRST usuar_mestre NO-LOCK
               WHERE usuar_mestre.cod_usuario = usuar-mater.cod-usuario
                 AND usuar_mestre.dat_fim_valid >= TODAY:

                 CREATE RegistroCampo.
                 ASSIGN RegistroCampo.IdentificacaoCampo = Identificadores.IdentificacaoCampo
                        RegistroCampo.CodigoRegistro     = usuar-mater.cod-usuario
                        RegistroCampo.DescricaoRegistro  = IF usuar-mater.nome-usuar <> "" THEN usuar-mater.nome-usuar ELSE usuar_mestre.nom_usuario.
            END.
        END.
        /*Comprador Ativo*/
        ELSE IF Identificadores.IdentificacaoCampo = 12 THEN DO:
            FOR EACH usuar-mater NO-LOCK
               WHERE usuar-mater.usuar-comprado,
           FIRST usuar_mestre NO-LOCK
               WHERE usuar_mestre.cod_usuario = usuar-mater.cod-usuario
                 AND usuar_mestre.dat_fim_valid >= TODAY:

                 CREATE RegistroCampo.
                 ASSIGN RegistroCampo.IdentificacaoCampo = Identificadores.IdentificacaoCampo
                        RegistroCampo.CodigoRegistro     = usuar-mater.cod-usuario
                        RegistroCampo.DescricaoRegistro  = IF usuar-mater.nome-usuar <> "" THEN usuar-mater.nome-usuar ELSE usuar_mestre.nom_usuario.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-erro:
    DEFINE INPUT PARAM c-erro AS CHAR.
    
    CREATE tt-erro.
    ASSIGN tt-erro.mensagem = c-erro.

    RETURN "OK".
END PROCEDURE.
