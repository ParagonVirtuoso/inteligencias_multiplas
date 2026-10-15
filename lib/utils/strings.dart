class Strings {
  //navigate
  static const loginNavigate = '/';
  static const homeNavigate = '/home';
  static const questionsNavigate = '/questions';
  static const finishTestNavigate = '/finishTest';
  static const resultNavigate = '/result';
  static const developersNavigate = '/developers';
  static const aboutNavigate = '/about';
  static const termsNavigate = '/terms';

  //textos
  static const teoriaInteligenciaTelaLogin =
      "A teoria das inteligências múltiplas foi criada pelo psicólogo Howard Gardner na década de 1990, Ele criou essa tese, que se tornou mundialmente conhecida.";
  static const diferentesTiposInteligenciaTelaLogin =
      "Indivíduos possuem diferentes tipos de mentes e faculdades mentais, apresentando diferentes inteligências, surgindo a teoria das inteligências múltiplas.";
  static const entrarTelaLogin = "Entrar";
  static const auxAcesseSalvarProgresso =
      "Acesse para salvar seu histórico e progresso";
  static const continuarComGoogleTelaLogin = "Continuar com o Google";
  static const continuarComFacebookTelaLogin = "Continuar com o Facebook";
  static const continuarComoVisitanteTelaLogin = "ou continue como visitante";
  static const termosPoliticaRodapeTelaLogin =
      "Ao continuar, você concorda com nossos\nTermos e Política de Privacidade";
  static const subtituloHeroLogin = "Descubra seus talentos e vocação";
  static const bemVindoTelaHome = 'Bem Vindo,';
  static const visitante = 'Visitante';
  static const visitantePonto = 'Visitante.';
  static const comoFunciona = 'Como funciona o teste?';
  static const avalieCadaQuestao =
      'Dê uma nota de 1 a 9 para cada pergunta, de acordo com o que mais combina com você.';
  static const naoExisteRespostaCerta =
      'Lembre-se: não existe resposta certa ou errada, cada um de nós possui seus próprios talentos e escolhas.';
  static const voce = 'Você ';
  static const naoRepetirRespesta = 'não poderá repetir ';
  static const naoRepetirRespestaDescricao =
      'a mesma nota em diferentes perguntas da mesma etapa.';
  static const tutorialFichasTitulo = 'Notas de 1 a 9';
  static const tutorialFichasDescricao =
      'Cada etapa tem 9 perguntas. Escolha uma nota de 1 a 9 para cada uma, sem repetir notas na mesma etapa.';
  static const tutorialSwapTitulo = 'Troca Rápida de Notas';
  static const tutorialSwapDescricao =
      'Quer usar uma nota que já escolheu antes? É só tocar nela e o aplicativo troca as notas automaticamente para você.';
  static const tutorialNavTitulo = 'Avance e Volte Livremente';
  static const tutorialNavDescricao =
      'Você pode navegar entre as perguntas a qualquer momento para rever ou mudar suas respostas antes de terminar.';
  static const toqueParaTestar = 'Toque para testar';
  static const legendaSuaNota = 'Sua nota';
  static const legendaDisponivel = 'Livre';
  static const legendaAtribuida = 'Outra pergunta';
  static const legendaBadgePerguntaExemplo = 'P#';
  static const iniciarTeste = 'Iniciar Teste';

  static String tutorialNotaSelecionada(int nota) => 'Nota $nota selecionada';
  static String tutorialNotasTrocadas(int pergunta) =>
      'Notas trocadas com a Pergunta $pergunta!';
  static String tooltipNotaSelecionada(int nota) =>
      'Nota $nota ($legendaSuaNota)';
  static String tooltipNotaAtribuida(int nota, int pergunta) =>
      'Nota $nota (Atribuída à P$pergunta)';
  static String tooltipNotaDisponivel(int nota) =>
      'Nota $nota ($legendaDisponivel)';
  static String rotuloPerguntaAbreviada(int numero) => 'P$numero';
  static const refazer = 'Refazer';
  static const proximo = 'Próximo';
  static const voltar = 'Voltar';
  static const sair = 'Sair';
  static const sim = 'Sim';
  static const nao = 'Não';
  static const desejaSair = 'Deseja realmente sair?';
  static const sairConta = 'Sair da conta';
  static const desejaSairConta =
      'Tem certeza que deseja sair da sua conta? Você precisará fazer login novamente para acessar seus testes salvos.';
  static const confirmarSairConta = 'Sair';
  static const sairDoTeste = 'Sair do teste?';
  static const desejaSairDoTeste =
      'Tem certeza que deseja sair? O progresso não salvo nesta etapa será perdido.';
  static const confirmarSairDoTeste = 'Sair do teste';
  static const continuarTeste = 'Continuar teste';
  static const sobreApp = 'Sobre o App';
  static const sobreAppDescricao =
      'Este é um trabalho de conclusão de curso, para universidade Instituto Federal do Tocantins campus Porto Nacional.\nDa turma de Licenciatura em computação do ano de 2016.\nIdealizado e realizado por Denys Fernandes.';
  static const termosUso = 'Termos de Uso';
  static const desenvolvedores = 'Desenvolvedores';
  static const avaliarApp = 'Avaliar o aplicativo';
  static const salvarProgresso = 'Salvar progresso';
  static const salvarConta = 'Salvar conta';
  static const salvarResultado = 'Salvar resultado';
  static const salvarResultadoDescricao =
      'Conecte com Google ou Facebook para não perder seu histórico.';
  static const vinculeParaSalvar =
      'Vincule uma conta para salvar seus testes e acessá-los em qualquer aparelho.';
  static const contaVinculadaSucesso =
      'Conta vinculada com sucesso! Seu progresso está salvo.';
  static const erroVincularConta = 'Erro ao vincular conta. Tente novamente.';
  static const agoraNao = 'Agora não';
  static const modoVisitante = 'Modo Visitante';
  static const salvarGoogleOuFacebook = 'Salvar no Google ou Facebook';
  static const contaConectada = 'Conta conectada';
  static const progressoSalvoNuvem = 'Progresso salvo na nuvem';
  static const emailCopiado = 'E-mail copiado para a área de transferência!';
  static const copiarEmail = 'Copiar e-mail';
  static const teste = 'Teste';
  static const etapa = 'Etapa';
  static const selecioneEstrela =
      'Selecione uma nota de acordo com sua afinidade';
  static const quantEstrelaGosta =
      'Avalie, a nota de 1 a 9 significa o seu grau de afinidade.';
  static const avalieComFichas =
      'Classifique com notas de 1 a 9 (sem repetir na etapa):';
  static const selecioneUmaNota =
      'Selecione uma nota de 1 a 9 de acordo com sua afinidade';
  static const trocarNota = 'Trocar nota';
  static const trocarNotas = 'Trocar notas';
  static const confirmarTroca = 'Confirmar troca';
  static const cancelar = 'Cancelar';
  static const notaJaAtribuida =
      'Esta nota já está atribuída a outra pergunta.';
  static const desejaTrocarNotas = 'Deseja trocar as notas entre as perguntas?';
  static const perguntaAtual = 'Pergunta atual';
  static const semNota = 'Sem nota';
  static const pendente = 'Pendente';
  static const suaNota = 'Sua nota';
  static const disponivel = 'Livre';
  static const voceUsouSelecao = 'Você já usou essa seleção';
  static const editar = 'Editar';
  static const atencaoPerguntaAvaliada =
      'Atenção, outra pergunta já foi avaliada com essa nota.';
  static const seVoce = 'Se você';
  static const continuarError = ' continuar';
  static const escolherOutraClassifica =
      ' deverá escolher outra classificação para a pergunta atual. Ou você pode ';
  static const editarError = ' editar ';
  static const classifiAnterior = ' a classificação da pergunta anterior.';
  static const continuar = 'Continuar';
  static const fechar = 'Fechar';
  static const entendido = 'Entendido';
  static const verResultados = 'Ver resultados';
  static const questionarioConcluido = 'Parabéns, questionário concluído!';
  static const deslizeResultados =
      'Deslize para cima e veja cada um dos seus resultados!';
  static const objetivo = 'Objetivo';
  static const objetivoDescricao =
      'Com objetivo de realizar um teste para descobrir quais conhecimentos predominam no ser humano.\nA teoria das inteligências múltiplas foi criada pelo psicólogo Howard Gardner na década de 1990, Ele criou essa tese, que se tornou mundialmente conhecida.';
  static const termosDescricao =
      'Concordo em fornecer o resultado dos meus testes para fins de levantamentos de dados, para trabalho de conclusão de curso (TCC).';
  static const linguistica = 'Linguística';
  static const logico = 'Lógico';
  static const musical = 'Musical';
  static const cinestesica = 'Cinestésica';
  static const interpessoal = 'Interpessoal';
  static const intrapessoal = 'Intrapessoal';
  static const espacial = 'Espacial';
  static const naturalista = 'Naturalista';
  static const existencial = 'Existencial';
  static const verMais = 'Ver mais';
  static const pontos = 'Pontos';
  static const erroApagarDados = 'Erro ao apagar dados do teste';
  static const dadosTesteVazio = 'O teste não possui progresso para apagar';
  static const dadosTesteApagado = 'Dados do teste apagados com sucesso';
  static const salveEdicaoAtualAntes =
      'Por favor, salve a edição atual antes de editar outra resposta.';
  static const linguisticaDescricao =
      'A inteligência linguística está relacionada com a capacidade de se comunicar, aprender novas línguas e utilizar a linguagem de forma excepcional, seja na forma escrita ou oral.\nEscritores, jornalistas, linguistas, além de pessoas que têm facilidade para falar idiomas diferentes – os poliglotas – apresentam altos níveis de inteligência linguística.';
  static const logicoDescricao =
      'A inteligência lógico-matemática é a capacidade de resolver problemas matemáticos e lógicos, além de identificar padrões e relações entre objetos e ideias.\nEngenheiros, matemáticos, cientistas e programadores são exemplos de profissionais que possuem alta inteligência lógico-matemática.';
  static const musicalDescricao =
      'A inteligência musical está relacionada com a capacidade de compreender, criar e reproduzir sons, ritmos e melodias.\nMúsicos, compositores, cantores e maestros são exemplos de profissionais que possuem alta inteligência musical.';
  static const cinestesicaDescricao =
      'A inteligência cinestésica está relacionada com a capacidade de controlar os movimentos do corpo, além de perceber e interpretar sensações táteis.\nAtletas, dançarinos, cirurgiões e artistas plásticos são exemplos de profissionais que possuem alta inteligência cinestésica.';
  static const interpessoalDescricao =
      'A inteligência interpessoal está relacionada com a capacidade de compreender e se relacionar com outras pessoas, além de perceber e interpretar emoções e sentimentos.\nPsicólogos, terapeutas, professores e líderes são exemplos de profissionais que possuem alta inteligência interpessoal.';
  static const intrapessoalDescricao =
      'A inteligência intrapessoal está relacionada com a capacidade de compreender e se relacionar consigo mesmo, além de perceber e interpretar emoções e sentimentos.\nFilósofos, psicólogos, terapeutas e líderes espirituais são exemplos de profissionais que possuem alta inteligência intrapessoal.';
  static const espacialDescricao =
      'A inteligência espacial está relacionada com a capacidade de perceber e interpretar imagens, formas e cores, além de compreender o espaço tridimensional.\nArquitetos, designers, artistas plásticos e pilotos são exemplos de profissionais que possuem alta inteligência espacial.';
  static const naturalistaDescricao =
      'A inteligência naturalista está relacionada com a capacidade de reconhecer, classificar e compreender os diferentes elementos do meio ambiente, como animais, plantas e fenômenos naturais.\nBiólogos, ecologistas, botânicos, veterinários e agrônomos são exemplos de profissionais que possuem alta inteligência naturalista.';
  static const existencialDescricao =
      'A inteligência existencial é a capacidade de refletir e questionar temas profundos da existência humana, como a origem da vida, o universo, a finitude, o propósito e o sentido das coisas.\nFilósofos, pensadores, teólogos, cosmólogos e líderes espirituais apresentam altos níveis dessa inteligência.';
  // Compartilhamento e Relatório PDF
  static const compartilharResultadoPdf = 'Compartilhar resultado em PDF';
  static const baixarResultadoPdf = 'Baixar resultado em PDF';
  static const nenhumResultadoCompartilhar =
      'Nenhum resultado disponível para compartilhar.';
  static const erroCompartilharPdf =
      'Não foi possível compartilhar o relatório em PDF.';
  static const erroBaixarPdf = 'Não foi possível baixar o relatório em PDF.';
  static const pdfTituloRelatorio = 'TESTE DE MÚLTIPLAS INTELIGÊNCIAS';
  static const pdfSubtituloRelatorio = 'Relatório Oficial de Resultados';
  static const pdfParticipante = 'Participante:';
  static const pdfData = 'Data:';
  static const pdfRodapeHowardGardner =
      'Teste de Múltiplas Inteligências (Baseado na Teoria de Howard Gardner)';
  static const pdfInteligenciaPredominante =
      'INTELIGÊNCIA PREDOMINANTE (1º LUGAR)';
  static const pdfClassificacaoGeral = 'CLASSIFICAÇÃO GERAL DAS INTELIGÊNCIAS';
  static const pdfSobreTeoria = 'Sobre a Teoria das Inteligências Múltiplas:';
  static const pdfSobreTeoriaDescricao =
      'Criada pelo psicólogo Howard Gardner em 1983 na Universidade de Harvard, a teoria propõe que a inteligência humana não se resume ao raciocínio lógico-matemático e linguístico tradicional. Todas as pessoas possuem potenciais em diferentes áreas cognitivas, que podem ser desenvolvidos ao longo da vida.';
  static const pdfDetalhamentoQuestionario =
      'DETALHAMENTO DO QUESTIONÁRIO POR INTELIGÊNCIA';
  static const pdfDetalhamentoSubtitulo =
      'Todas as 90 afirmações avaliadas, agrupadas pelas 9 inteligências em ordem de pontuação.';
  static const pdfTotalQuestoesBadge = '90 QUESTÕES';
  static const pdfComoInterpretarNotas = 'Como Interpretar as Notas:';
  static const pdfGuiaNotaAlta =
      '• 7 a 9 pts (Destaque Azul): Afirmações onde você mais se identifica no dia a dia.';
  static const pdfGuiaNotaMedia =
      '• 4 a 6 pts: Habilidades praticadas de modo equilibrado ou sob necessidade.';
  static const pdfGuiaNotaBaixa =
      '• 1 a 3 pts: Características menos espontâneas ou raramente priorizadas.';
  static const pdfMetodologiaIpsativa = 'Metodologia Ipsativa:';
  static const pdfMetodologiaIpsativaDescricao =
      'Em cada uma das 10 etapas, você atribuiu notas de 1 a 9 sem repetição. A somatória revela os padrões reais das suas forças cognitivas.';
  static const pdfShareSubject =
      'Resultado do Teste de Inteligências Múltiplas';
  static const pdfShareText =
      'Confira meu relatório do Teste de Inteligências Múltiplas!';

  static const List<String> pdfPrefixosEtapas = [
    'Lazer',
    'Habilidade',
    'Preferência',
    'Pergunta-chave',
    'No trabalho',
    'Ao aprender',
    'No dia a dia',
    'Autoimagem',
    'Ao estudar',
    'Ponto forte',
  ];

  static const Map<String, String> pdfPerguntasChaveEtapa4 = {
    'Cinestesica': "'Onde?' (espaço físico)",
    'Espacial': "'Como?' (processo e forma)",
    'Interpessoal': "'Quem?' (pessoas)",
    'Intrapessoal': "'Para que?' (propósito interior)",
    'Linguistica': "'Por que?' (argumentação)",
    'Logico': "'O que?' (fatos e dados)",
    'Musical': "'Quando?' (tempo e ritmo)",
    'Naturalista': "'De qual categoria/grupo?' (natureza e seres vivos)",
    'Existencial': "'Qual o sentido maior?' (propósito e existência)",
  };
  //assets
  static const logoAsset = 'assets/icons/logo.png';
  static const logoMarcaAsset = 'assets/icons/logoFull.png';
  static const fundoBrainAsset = 'assets/icons/brain_login.png';
  static const googleIconAsset = 'assets/icons/google_icon.png';
  static const facebookIconAsset = 'assets/icons/facebook_icon.png';
  static const playIconAsset = 'assets/icons/play.png';
  static const starIconAsset = 'assets/icons/star.png';
  static const starFullIconAsset = 'assets/icons/starFull.png';
  static const desenvolvedoresIconAsset = 'assets/icons/desenvolvedores.png';
  static const sobreAppIconAsset = 'assets/icons/sobreApp.png';
  static const termosUsoAppIconAsset = 'assets/icons/termosUso.png';
  static const sairAppIconAsset = 'assets/icons/sair.png';
  static const refazerIconAsset = 'assets/icons/refazer.png';
  static const editIconAsset = 'assets/icons/edit.png';
  static const pergunta1Asset = 'assets/etapas/etapa-1/pergunta-1.png';
  static const proximoIconAsset = 'assets/icons/proximo.png';
  static const concluidoAsset = 'assets/resultado/concluido.png';
  static const cinestesicaAsset = 'assets/resultado/cinestesica.png';
  static const espacialAsset = 'assets/resultado/espacial.png';
  static const interpessoalAsset = 'assets/resultado/interpessoal.png';
  static const intrapessoalAsset = 'assets/resultado/intrapessoal.png';
  static const linguisticoAsset = 'assets/resultado/linguistico.png';
  static const logicoAsset = 'assets/resultado/logico.png';
  static const musicalAsset = 'assets/resultado/musical.png';
  static const naturalistaAsset = 'assets/resultado/naturalista.png';
  static const existencialAsset = 'assets/resultado/existencial.png';
  static const List<String> ilustracoesPerguntas = [
    cinestesicaAsset,
    espacialAsset,
    interpessoalAsset,
    intrapessoalAsset,
    linguisticoAsset,
    logicoAsset,
    musicalAsset,
    naturalistaAsset,
    existencialAsset,
  ];
  static const githubIconAsset = 'assets/icons/github.png';
  static const linkedinIconAsset = 'assets/icons/linkedin.png';
  static const instagramIconAsset = 'assets/icons/instagram.png';
  static const arrowdetailresult = 'assets/icons/arrowdetailresult.png';
  static const devDenysAsset = 'assets/devs/dev.png';
  static const devEliasAsset = 'assets/devs/ux.png';
}
