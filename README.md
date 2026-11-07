# MYNJO Cash 💰

Aplicativo de controle financeiro pessoal e acompanhamento de câmbio desenvolvido em Flutter para a disciplina de **Desenvolvimento para Ambientes Móveis (Faculdade COTEMIG 2026.2)**.

---

## 1. Identificação

- **Aplicativo:** MYNJO Cash
- **Squad:** Squad MYNJO
- **Integrantes:**
  - **Marcus Vinicius Calegar** — Matrícula: `72500549` | E-mail: `72500549@aluno.faculdadecotemig.br`
  - **Yuri Stiwart Faria Filho** — Matrícula: `72500581` | E-mail: `72500581@aluno.faculdadecotemig.br`
  - **Natan Mendes Silva** — Matrícula: `72400102` | E-mail: `72400102@aluno.faculdadecotemig.br`
  - **João Félix** — Matrícula: `72500344` | E-mail: `72500344@aluno.faculdadecotemig.br`
  - **Otávio Tadeu Magalhães Ferreira** — Matrícula: `72500964` | E-mail: `72500964@aluno.faculdadecotemig.br`

---

## 2. Sobre o Projeto

O **MYNJO Cash** é um aplicativo voltado para o público geral, especialmente jovens e estudantes que desejam organizar suas finanças pessoais de forma prática, moderna e sem complexidade. O app permite o controle centralizado de entradas (receitas), saídas (despesas) e gastos fixos, além de monitorar moedas estrangeiras com cotações e histórico atualizados em tempo real. O fluxo se inicia na tela de **Login** (ou **Cadastro** de novos usuários); após autenticado, o usuário navega para o painel de **Início**, onde visualiza seu saldo consolidado, atalhos rápidos e moedas favoritas. A partir dele, acessa as telas de **Lançamento** (para registrar movimentações), **Extrato** (com filtros dinâmicos e exclusão), **Relatório** (com gráficos de categorias e histórico de câmbio) e **Perfil** (para gerenciar preferências de visualização e segurança).

---

## 3. Requisitos Atendidos

| # | Requisito | Descrição | Onde está implementado no App |
|---|---|---|---|
| **1** | **Pelo menos 4 telas com `Navigator.push` e `pop`** | Navegação fluida entre telas com empilhamento e retorno | Presente em [`login.dart`](lib/screens/login.dart), [`cadastro.dart`](lib/screens/cadastro.dart), [`inicio.dart`](lib/screens/inicio.dart), [`lancamento.dart`](lib/screens/lancamento.dart), [`extrato_lancamento.dart`](lib/screens/extrato_lancamento.dart), [`relatorio.dart`](lib/screens/relatorio.dart) e [`perfil.dart`](lib/screens/perfil.dart). |
| **2** | **API REST com `http` e `async/await`** | Dados dinâmicos consumidos de API REST externa | Implementado em [`servico_cotacoes.dart`](lib/dados/servico_cotacoes.dart) consumindo a **AwesomeAPI** (`/last/...` e `/json/daily/...`) com `http.get` e `async/await`. |
| **3** | **Loading e erro visíveis na UI** | Feedback de carregamento e mensagens de falha com opção de tentar novamente | Exibido no carrossel de cotações em [`inicio.dart`](lib/screens/inicio.dart) e no histórico de cotações em [`relatorio.dart`](lib/screens/relatorio.dart) via `CircularProgressIndicator` e cards de erro com retry. |
| **4** | **Formulário com `Form` e `validator`** | Validação estruturada de entradas do usuário | [`login.dart`](lib/screens/login.dart) (e-mail e senha), [`cadastro.dart`](lib/screens/cadastro.dart) (nome, e-mail e confirmação de senha), [`lancamento.dart`](lib/screens/lancamento.dart) (descrição e valor numérico > 0) e [`perfil.dart`](lib/screens/perfil.dart). |
| **5** | **Lista dinâmica com `ListView.builder`** | Construção eficiente de listagens dinâmicas | Implementado no extrato em [`extrato_lancamento.dart`](lib/screens/extrato_lancamento.dart), na lista de moedas e últimos lançamentos em [`inicio.dart`](lib/screens/inicio.dart), e no histórico de câmbio em [`relatorio.dart`](lib/screens/relatorio.dart). |
| **6** | **`SharedPreferences` persiste ao reabrir o app** | Armazenamento local de configurações e dados do usuário | Gerenciado em [`servico_preferencias.dart`](lib/dados/servico_preferencias.dart) e [`banco_dados_local.dart`](lib/dados/banco_dados_local.dart), persistindo usuários cadastrados, sessão de login, histórico completo de transações/lançamentos, moedas favoritas e preferências visuais. |
| **7** | **Provider: telas, HTTP e prefs separados** | Separação de responsabilidades e gestão de estado desacoplada | Camada de dados estruturada em `lib/dados/`: <br>• **HTTP:** [`servico_cotacoes.dart`](lib/dados/servico_cotacoes.dart) <br>• **Prefs:** [`servico_preferencias.dart`](lib/dados/servico_preferencias.dart) <br>• **Banco Local:** [`banco_dados_local.dart`](lib/dados/banco_dados_local.dart) <br>• **Provider:** [`app_dados.dart`](lib/dados/app_dados.dart) (`ChangeNotifier`) provido via `ChangeNotifierProvider` na raiz. Telas consomem via `context.watch`/`read`. |
| **8** | **App abre e percorre o fluxo sem crashar** | Estabilidade em todo o ciclo de vida e navegação | Validado com `flutter analyze` (**0 erros**), testes automatizados (`flutter test`) com 100% de sucesso e execução homologada no Chrome e mobile. |

---

## 4. API e Dados Remotos

- **URL Base:** `https://economia.awesomeapi.com.br`
- **Endpoints Utilizados:**
  - `GET /last/USD-BRL,EUR-BRL,GBP-BRL,ARS-BRL,CAD-BRL,JPY-BRL,CHF-BRL`: Cotações atuais de compra (`bid`), venda (`ask`) e variação percentual (`pctChange`) em relação ao Real brasileiro (BRL).
  - `GET /json/daily/{MOEDA}-BRL/{DIAS}`: Histórico diário das cotações dos últimos 7, 15 ou 30 dias para a moeda especificada.
- **Tipo de API:** Pública (sem necessidade de chaves privadas ou tokens pagos).
- **Usuário e Senha de Teste para o App:**
  - **E-mail:** `admin@mynjo.com`
  - **Senha:** `admin`
  - *(Também é possível cadastrar novos usuários livremente pela tela de Cadastro)*.

---

## 5. Como Rodar o Projeto

### Pré-requisitos
- **Flutter SDK:** versão `>= 3.6.0` (testado e homologado no Flutter `3.27.x stable`).
- **Dart SDK:** versão `>= 3.6.0`.
- Navegador Google Chrome, Emulador Android ou dispositivo móvel conectado.

### Passo a Passo

1. **Clonar o repositório:**
   ```bash
   git clone https://github.com/otaviotadeu/mynjo.git
   cd mynjo
   ```

2. **Instalar as dependências:**
   ```bash
   flutter pub get
   ```

3. **Executar os testes automatizados (opcional):**
   ```bash
   flutter test
   ```

4. **Rodar a aplicação:**
   - No Google Chrome:
     ```bash
     flutter run -d chrome
     ```
   - No emulador ou celular conectado:
     ```bash
     flutter run
     ```

- **Plataformas Homologadas:** Web (Google Chrome), Android e Windows Desktop.

---

## 6. Backend Local e Persistência

**Não há backend remoto.** O aplicativo consome diretamente a API pública em nuvem da **AwesomeAPI** para dados econômicos e cotações cambiais em tempo real, dispensando a necessidade de iniciar servidores locais (Node.js, Python, etc.). Toda a persistência de contas de login cadastradas, sessão do usuário, histórico de lançamentos e preferências é gerenciada localmente pelo **BancoDadosLocal** e **ServicoPreferencias** através do **SharedPreferences**, garantindo que nenhum dado seja perdido ao reiniciar a aplicação por completo.

---

## 7. Estrutura do Código

A arquitetura do projeto segue a separação de responsabilidades recomendada pelo Flutter e ensinada no curso:

```
lib/
├── components/          # Componentes visuais reutilizáveis (cartões, botões, chips, linhas de preferência)
├── dados/               # Camada de Dados e Estado
│   ├── app_dados.dart            # ChangeNotifier (Provider global gerenciando o estado da aplicação)
│   ├── banco_dados_local.dart    # Banco de dados local simples persistindo usuários, login e lançamentos
│   ├── servico_cotacoes.dart     # Serviço isolado para chamadas HTTP REST (AwesomeAPI)
│   └── servico_preferencias.dart # Serviço isolado para persistência com SharedPreferences
├── models/              # Modelos de dados puros (Moeda, Transação, Preferências, Usuário)
├── screens/             # Telas da interface (Login, Cadastro, Início, Lançamento, Extrato, Relatório, Perfil)
├── theme/               # Identidade visual, cores (AppColors) e temas Material 3 (AppTheme)
├── utils/               # Formatadores de moeda/data e dimensões responsivas
└── main.dart            # Ponto de entrada com injeção do ChangeNotifierProvider
```

---

## 8. Observações

- **Limitações:** Em caso de perda de conexão com a internet, o aplicativo exibe mensagens claras de erro na UI com botão de recarregar e mantém em cache os valores padrão das moedas para não interromper a usabilidade do usuário.
- **Bônus Implementados:**
  - Banco de dados local simples (`banco_dados_local.dart`) com suporte a múltiplos usuários cadastrados, sessão ativa e transações persistidas.
  - Alternância de visibilidade do saldo com persistência nas preferências.
  - Suporte completo a moedas favoritas na tela inicial sincronizadas com o SharedPreferences.
  - Testes unitários e de widgets automatizados em [`test/`](test/) cobrindo persistência completa, autenticação, deduplicação de lançamentos e cálculos de saldo.
  - Interface adaptável e responsiva com centralização em telas maiores (Web e Desktop).
- **O que não deu tempo:** Sincronização em nuvem multi-dispositivo via banco de dados remoto (como Firebase Firestore ou Supabase); atualmente, todos os dados são salvos de forma resiliente e persistente no armazenamento local do dispositivo/navegador.
