import 'package:flutter/material.dart';
import '../components/botao_principal.dart';
import '../components/campo_email.dart';
import '../components/campo_senha.dart';
import '../components/cartao_branco.dart';
import '../components/dialogo_confirmacao.dart';
import '../components/linha_preferencia.dart';
import '../components/mensagens.dart';
import '../components/titulo_secao.dart';
import '../models/moeda.dart';
import '../models/preferencias.dart';
import '../models/usuario.dart';
import '../theme/app_colors.dart';
import 'login.dart';

// Marcus Vinicius

class TelaPerfil extends StatefulWidget {
  final Usuario usuario;

  const TelaPerfil({super.key, required this.usuario});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  final formDados = GlobalKey<FormState>();
  final formSenha = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaAtualController = TextEditingController();
  final novaSenhaController = TextEditingController();
  final confirmaSenhaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // começa com os dados atuais do usuário
    nomeController.text = widget.usuario.nome;
    emailController.text = widget.usuario.email;
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaAtualController.dispose();
    novaSenhaController.dispose();
    confirmaSenhaController.dispose();
    super.dispose();
  }

  // Pega as iniciais do nome. Ex: "Maria Silva" -> "MS"
  String pegarIniciais(String nome) {
    List<String> partes = nome.trim().split(' ');
    String iniciais = partes[0][0];
    if (partes.length > 1 && partes[partes.length - 1].isNotEmpty) {
      iniciais = iniciais + partes[partes.length - 1][0];
    }
    return iniciais.toUpperCase();
  }

  // Verifica se OUTRO usuário já usa esse e-mail
  bool emailEmUsoPorOutro(String email) {
    for (Usuario u in usuariosCadastrados) {
      if (u != widget.usuario && u.email.toLowerCase() == email.toLowerCase()) {
        return true;
      }
    }
    return false;
  }

  void salvarDados() {
    if (!formDados.currentState!.validate()) {
      return;
    }

    String email = emailController.text.trim();
    if (emailEmUsoPorOutro(email)) {
      mostrarMensagemErro(context, 'Este e-mail já está sendo usado.');
      return;
    }

    setState(() {
      widget.usuario.nome = nomeController.text.trim();
      widget.usuario.email = email;
    });

    // esconde o teclado
    FocusScope.of(context).unfocus();
    mostrarMensagemSucesso(context, 'Dados atualizados!');
  }

  void alterarSenha() {
    if (!formSenha.currentState!.validate()) {
      return;
    }

    widget.usuario.senha = novaSenhaController.text;

    // limpa os campos
    senhaAtualController.clear();
    novaSenhaController.clear();
    confirmaSenhaController.clear();

    FocusScope.of(context).unfocus();
    mostrarMensagemSucesso(context, 'Senha alterada com sucesso!');
  }

  void sair() {
    mostrarDialogoConfirmacao(
      context: context,
      titulo: 'Sair do MYNJO Cash?',
      mensagem: 'Você precisará entrar com seu e-mail e senha novamente.',
      textoBotao: 'Sair',
      aoConfirmar: () {
        // volta para o login e apaga as telas anteriores
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const TelaLogin()),
          (rota) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Meu Perfil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            cartaoDoUsuario(),
            const SizedBox(height: 24),

            // ===== Dados pessoais =====
            const TituloSecao(titulo: 'Dados pessoais'),
            const SizedBox(height: 12),
            CartaoBranco(
              arredondamento: 20,
              padding: const EdgeInsets.all(18),
              child: Form(
                key: formDados,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome completo',
                        prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().length < 2) {
                          return 'Nome deve ter pelo menos 2 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CampoEmail(controller: emailController),
                    const SizedBox(height: 20),
                    BotaoPrincipal(texto: 'Salvar dados', onPressed: salvarDados),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ===== Senha =====
            const TituloSecao(titulo: 'Alterar senha'),
            const SizedBox(height: 12),
            CartaoBranco(
              arredondamento: 20,
              padding: const EdgeInsets.all(18),
              child: Form(
                key: formSenha,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CampoSenha(
                      controller: senhaAtualController,
                      label: 'Senha atual',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite sua senha atual';
                        }
                        if (value != widget.usuario.senha) {
                          return 'Senha atual incorreta';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CampoSenha(
                      controller: novaSenhaController,
                      label: 'Nova senha',
                      icone: Icons.lock_rounded,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Mínimo de 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CampoSenha(
                      controller: confirmaSenhaController,
                      label: 'Confirmar nova senha',
                      icone: Icons.lock_reset_rounded,
                      validator: (value) {
                        if (value != novaSenhaController.text) {
                          return 'As senhas não coincidem';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    BotaoPrincipal(texto: 'Alterar senha', onPressed: alterarSenha),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ===== Preferências =====
            const TituloSecao(titulo: 'Preferências'),
            const SizedBox(height: 12),
            CartaoBranco(
              arredondamento: 20,
              padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
              child: Column(
                children: [
                  LinhaPreferencia(
                    icone: Icons.visibility_off_outlined,
                    titulo: 'Ocultar saldo ao entrar',
                    descricao: 'O saldo começa escondido na tela inicial',
                    valor: preferencias.ocultarSaldoAoEntrar,
                    onChanged: (novoValor) {
                      setState(() {
                        preferencias.ocultarSaldoAoEntrar = novoValor;
                      });
                    },
                  ),
                  const Divider(color: AppColors.border),
                  LinhaPreferencia(
                    icone: Icons.star_outline_rounded,
                    titulo: 'Só moedas favoritas',
                    descricao: 'Mostrar apenas as favoritas na tela inicial',
                    valor: preferencias.mostrarSomenteFavoritas,
                    onChanged: (novoValor) {
                      setState(() {
                        preferencias.mostrarSomenteFavoritas = novoValor;
                      });
                    },
                  ),
                  const Divider(color: AppColors.border),
                  LinhaPreferencia(
                    icone: Icons.delete_outline_rounded,
                    titulo: 'Confirmar exclusão',
                    descricao: 'Perguntar antes de excluir um lançamento',
                    valor: preferencias.confirmarAntesDeExcluir,
                    onChanged: (novoValor) {
                      setState(() {
                        preferencias.confirmarAntesDeExcluir = novoValor;
                      });
                    },
                  ),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Row(
                      children: [
                        Expanded(child: campoMoedaPadrao()),
                        const SizedBox(width: 12),
                        Expanded(child: campoPeriodoPadrao()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ===== Sair =====
            OutlinedButton.icon(
              onPressed: sair,
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Sair da conta'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.expense,
                side: const BorderSide(color: AppColors.expense, width: 1.2),
                minimumSize: const Size(64, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Cartão roxo com a foto (iniciais), nome e e-mail
  Widget cartaoDoUsuario() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.fabShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
            ),
            child: Text(
              pegarIniciais(widget.usuario.nome),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.usuario.nome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.usuario.email,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget campoMoedaPadrao() {
    List<DropdownMenuItem<String>> opcoes = [];
    for (MoedaCotacao m in moedasPadrao) {
      opcoes.add(
        DropdownMenuItem(value: m.codigo, child: Text('${m.bandeira} ${m.codigo}')),
      );
    }

    return DropdownButtonFormField<String>(
      initialValue: preferencias.moedaPadrao,
      decoration: const InputDecoration(labelText: 'Moeda padrão'),
      items: opcoes,
      onChanged: (novo) {
        if (novo != null) {
          setState(() {
            preferencias.moedaPadrao = novo;
          });
        }
      },
    );
  }

  Widget campoPeriodoPadrao() {
    return DropdownButtonFormField<int>(
      initialValue: preferencias.periodoPadrao,
      decoration: const InputDecoration(labelText: 'Período padrão'),
      items: const [
        DropdownMenuItem(value: 7, child: Text('7 dias')),
        DropdownMenuItem(value: 15, child: Text('15 dias')),
        DropdownMenuItem(value: 30, child: Text('30 dias')),
      ],
      onChanged: (novo) {
        if (novo != null) {
          setState(() {
            preferencias.periodoPadrao = novo;
          });
        }
      },
    );
  }
}
