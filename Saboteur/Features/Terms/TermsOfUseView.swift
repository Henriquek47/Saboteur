//
//  TermsOfUseView.swift
//  Saboteur
//
//  Created by Henrique Lima on 22/05/26.
//

import SwiftUI

struct TermsOfUseView: View {
  @Environment(AppRouter.self) private var router

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 32) {

        // MARK: – Header
        VStack(alignment: .leading, spacing: 8) {
          Text("Termos de Uso e Políticas de Privacidade")
            .font(.grandstander(fontStyle: .title2, fontWeight: .bold))

          Text("Última atualização: maio de 2026")
            .font(.grandstander(fontStyle: .footnote, fontWeight: .regular))
            .foregroundColor(.secondary)
        }

        Divider()

        // MARK: – Seções
        Group {
          TermsSection(
            number: "1",
            title: "Aceitação dos Termos",
            content:
              "Ao criar uma conta e utilizar o Saboteur, você concorda integralmente com estes Termos de Uso e com nossa Política de Privacidade. Caso não concorde com qualquer parte destes termos, pedimos que não utilize o aplicativo."
          )

          TermsSection(
            number: "2",
            title: "Uso do Aplicativo",
            content:
              "O Saboteur é uma plataforma de jogos colaborativos. Você concorda em usar o aplicativo apenas para fins lícitos e de acordo com estes termos. É proibido utilizar o aplicativo para assediar, ameaçar ou prejudicar outros usuários."
          )

          TermsSection(
            number: "3",
            title: "Contas de Usuário",
            content:
              "Você é responsável por manter a confidencialidade das suas credenciais de acesso. Qualquer atividade realizada com sua conta é de sua responsabilidade. Notifique-nos imediatamente em caso de uso não autorizado."
          )

          TermsSection(
            number: "4",
            title: "Coleta de Dados",
            content:
              "Coletamos informações como nome, e-mail, foto de perfil e dados de uso para personalizar sua experiência. Não vendemos seus dados pessoais a terceiros. Os dados são utilizados exclusivamente para operar e melhorar o serviço."
          )

          TermsSection(
            number: "5",
            title: "Privacidade e Segurança",
            content:
              "Utilizamos criptografia e boas práticas de segurança para proteger suas informações. Seus dados são armazenados em servidores seguros. Você pode solicitar a exclusão da sua conta e de todos os dados associados a qualquer momento."
          )

          TermsSection(
            number: "6",
            title: "Conteúdo do Usuário",
            content:
              "Ao interagir com outros usuários, você concorda em manter uma conduta respeitosa. Reservamo-nos o direito de remover conteúdo inapropriado e suspender contas que violem estas políticas sem aviso prévio."
          )

          TermsSection(
            number: "7",
            title: "Alterações nos Termos",
            content:
              "Podemos atualizar estes termos periodicamente. Notificaremos sobre mudanças significativas dentro do aplicativo. O uso continuado após as alterações constitui aceitação dos novos termos."
          )

          TermsSection(
            number: "8",
            title: "Contato",
            content:
              "Em caso de dúvidas sobre estes Termos de Uso ou Política de Privacidade, entre em contato conosco pelo e-mail: suporte@saboteur.app"
          )
        }
      }
      .padding(24)
    }
    .navigationTitle("Termos e Políticas")
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button {
          router.pop()
        } label: {
          HStack(spacing: 4) {
            Image(systemName: "chevron.left")
              .font(.system(size: 16, weight: .semibold))
            Text("Voltar")
              .font(.grandstander(fontStyle: .body, fontWeight: .regular))
          }
          .foregroundColor(.primary)
        }
      }
    }
  }
}

// MARK: – TermsSection

private struct TermsSection: View {
  let number: String
  let title: String
  let content: String

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack(alignment: .center, spacing: 12) {
        ZStack {
          Circle()
            .fill(Color(uiColor: .primaryTheme))
            .frame(width: 32, height: 32)
          Text(number)
            .font(.grandstander(fontStyle: .subheadline, fontWeight: .bold))
            .foregroundColor(.black)
        }

        Text(title)
          .font(.grandstander(fontStyle: .headline, fontWeight: .semibold))
      }

      Text(content)
        .font(.grandstander(fontStyle: .body, fontWeight: .regular))
        .foregroundColor(.secondary)
        .fixedSize(horizontal: false, vertical: true)
    }
  }
}
