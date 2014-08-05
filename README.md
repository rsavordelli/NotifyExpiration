NotifyExpiration
================

Zimbra Password Notify Expiration
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


Use com sh NotifyExpiration.sh
