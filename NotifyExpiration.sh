#!/bin/bash
 ##########################################################################
# Escrito por : Rubem de Lima Savordelli E-mail: rsavordelli@gmail.com     #
# Este script tem a seguinte estrutura:                                    #
# Lista as contas, pega as informações e atributos do ldap das contas, faz #
# As verificações de dias restantes para expirar a senha da conta.         #
# O LDAP do zimbra nos dá várias informações, menos os dias restantes. Ele #
# Fornece : Ultima Alteração e Idade máxima (dias que a senha será válida).#
# Sendo assim, um algoritimo básico de verificação foi criado. O algoritimo#
# pega a ultima alteração, tira a diferença dos dias corridos, e mostra os #
# dias que faltam. E depois faz as verificações e testes para enviar as    #
# mensagens de aviso que a conta vai expirar, com 15,10,5 e 1 dia restante.#
# Este script só serve para quem tem a case local no zimbra, quando auten- #
# ticado no Active Directory ou Ldap externo não serve.                    #
 ##########################################################################
 ##########################################################################
#                 The Pancake Public License v.1.0                         #
#                                                                          #
#                        WARRANTY CLAUSE                                   #
# * This program is free software. It comes without any warranty, to       #
# * the extent permitted by applicable law. You can redistribute it        #
# * and/or modify it under the terms of the Pancake Public License         #
# * v.1.0 as published by Dayid Alan and available in full at              #
# * http://code.dayid.org/ppl/ppl.txt.                                     #
#                                                                          #
# The Pancake Public License as instituted in v.1.0 on this 5th day        #
# of March, 2003 allows all forms of copy, distribution, and               #
# modification of the software included provided the following terms:      #
#                                                                          #
#                            TERMS                                         #
# 0: Code under the PPL is open to the public to do whatever they will     #
#   with it.                                                               #
#                                                                          #
# 1: PPL code may be incorporated into any project without any mention     #
#   of the original project or the PPL.                                    #
#                          END TERMS                                       #
 ##########################################################################
 ##########################################################################
# [ GLOBAL - Alterarar apenas o Global ]
##########################################################################
## Diretório da  Lista de contas temporária                                #
TMP="/etc/scripts/NotifyExpiration/tmp"                                    #
## Diretório Temporário das informações da contas                          #
OUTPUT="/etc/scripts/NotifyExpiration/output"                              #
## Caminho absoluto Zmprov.                                                #
ZMPROV="/opt/zimbra/bin/zmprov"                                            #
## Conta que será o "from" da mensagem.                                    #
ADMIN="conta@dominio.com"                                                  #
########################################################################### 
 
# Não alterar daqui para baixo.
##########################################################################
## Limpa Arquivos Antigos
echo "Apagando Temporários"
    rm -rf $OUTPUT/*
 
# Gerando Listas
 
/opt/zimbra/bin/zmprov -l gaa > $TMP/contas.txt
 
for Accounts in $(cat $TMP/contas.txt) ; do
 
    $ZMPROV GetAccount $Accounts >> $OUTPUT/$Accounts.txt
 
done
 
# Pega informação das contas exportadas pelo Zmprov GA
 
for files in $(ls $OUTPUT/ | grep txt) ; do
 
        lastChanged=$(cat output/$files | grep Modi | awk '{print $2}' | cut -b1-8)
        contaEmail=$(cat output/$files | grep "mail:" | awk '{print $2}'| grep @)
        maxAge=$(cat output/$files | grep MaxAge | awk '{print $2}')
        diff=$(echo $(($(($(date -d "`date +%Y%m%d`" "+%s") - $(date -d "$lastChanged" "+%s"))) / 86400)))
 
   echo "Conta: $contaEmail"
   echo "Ultima Alteração $lastChanged"
   echo "Idade maxima: $maxAge"
   echo "Dias Passados: $diff"
   echo ""
 
# Contador de dias. l
Limite1=`expr $diff + 1`
Limite5=`expr $diff + 5`
Limite10=`expr $diff + 10`
Limite15=`expr $diff + 15`
 
# Testa e envia mensagem caso falte 1d
 if [ $Limite1 -eq $maxAge ] ; then
     echo "Subject: [Aviso] - Senhas" "
Prezado(a) $contaEmail,
Sua senha de email expira em 1 dia. 
Acesse webmail.yourdomain.com e troque sua senha.
 
Qualquer duvida entre em contato com Suporte
 
Suporte TI" | /opt/zimbra/postfix/sbin/sendmail -t -F Admin -f $ADMIN $contaEmail
 else 
        echo "Conta $contaEmail OK de 1d"
 fi
 
# Testa e envia mensagem caso falte 5d
 if [ $Limite5 -eq $maxAge ] ; then
      echo "Subject: [Aviso] - Senhas" "
Prezado(a) $contaEmail,
Sua senha de email expira em 5 dias. 
Acesse webmail.yourdomain.com e troque sua senha.
 
Qualquer duvida entre em contato com Suporte
 
Suporte TI" | /opt/zimbra/postfix/sbin/sendmail -t -F Admin -f $ADMIN $contaEmail
 
 else 
        echo "Conta $contaEmail OK para 5 dias"
 fi
 
# Testa e envia mensagem caso falte 10d
 if [ $Limite10 -eq $maxAge ] ; then
      echo "Subject: [Aviso] - Senhas" "
Prezado(a) $contaEmail,
Sua senha de email expira em 10 dias. 
Acesse webmail.yourdomain.com e troque sua senha.
 
Qualquer duvida entre em contato com Suporte
 
Suporte TI" | /opt/zimbra/postfix/sbin/sendmail -t -F ADS -f $ADMIN $contaEmail
 
 else 
        echo "Conta $contaEmail OK para 10 dias"
 fi
 
# Testa e envia mensagem caso falte 15d
 if [ $Limite15 -eq $maxAge ] ; then
      echo "Subject: [Aviso] - Senhas" "
Prezado(a) $contaEmail,
Sua senha de email expira em 15 dias. 
Acesse webmail.yourdomain.com e troque sua senha.
 
Qualquer duvida entre em contato com Suporte
 
Suporte TI" | /opt/zimbra/postfix/sbin/sendmail -t -F Admin -f $ADMIN $contaEmail
 
 else 
        echo "Conta $contaEmail OK para 15 dias"
 fi
 
done
