import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../utils/perguntas.dart';
import '../../utils/strings.dart';

class ResultController {
  static const Map<String, int> _indiceInteligencias = {
    'Cinestesica': 0,
    'Espacial': 1,
    'Interpessoal': 2,
    'Intrapessoal': 3,
    'Linguistica': 4,
    'Logico': 5,
    'Musical': 6,
    'Naturalista': 7,
    'Existencial': 8,
  };

  static pw.Widget _buildCardInteligenciaAgrupada({
    required int posicao,
    required String nome,
    required int totalPontos,
    required int porcentagem,
    required List<String> perguntasTextos,
    required List<int> notas,
    required PdfColor corAzul,
    required PdfColor corAzulClaro,
    required PdfColor corCinzaFundo,
    required PdfColor corBorda,
    required PdfColor corTextoEscuro,
    required PdfColor corTextoSuave,
    int totalEstrelas = 9,
  }) {
    final isPrimeiro = posicao == 1;
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 3.5),
      padding: const pw.EdgeInsets.symmetric(horizontal: 4.5, vertical: 2.8),
      decoration: pw.BoxDecoration(
        color: isPrimeiro ? corAzulClaro : corCinzaFundo,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        border: pw.Border.all(
          color: isPrimeiro ? corAzul : corBorda,
          width: isPrimeiro ? 0.8 : 0.5,
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Row(
                children: [
                  pw.Container(
                    width: 13,
                    height: 13,
                    alignment: pw.Alignment.center,
                    decoration: pw.BoxDecoration(
                      color: isPrimeiro ? corAzul : PdfColors.grey400,
                      shape: pw.BoxShape.circle,
                    ),
                    child: pw.Text(
                      '$posicaoº',
                      style: pw.TextStyle(
                        fontSize: 6.5,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 3.5),
                  pw.Text(
                    nome,
                    style: pw.TextStyle(
                      fontSize: 8.0,
                      fontWeight: pw.FontWeight.bold,
                      color: isPrimeiro ? corAzul : corTextoEscuro,
                    ),
                  ),
                ],
              ),
              pw.Text(
                '$totalPontos pts ($porcentagem%)',
                style: pw.TextStyle(
                  fontSize: 7.5,
                  fontWeight: pw.FontWeight.bold,
                  color: isPrimeiro ? corAzul : corTextoSuave,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 2),
          pw.Container(height: 0.5, color: isPrimeiro ? corAzul : corBorda),
          pw.SizedBox(height: 2),
          ...List.generate(perguntasTextos.length, (i) {
            final texto = perguntasTextos[i];
            final prefixo =
                i < Strings.pdfPrefixosEtapas.length
                    ? Strings.pdfPrefixosEtapas[i]
                    : 'Item';
            final nota = i < notas.length ? notas[i] : 0;
            final isAlta = totalEstrelas >= 9 ? nota >= 7 : nota >= 6;
            final isBaixa = totalEstrelas >= 9
                ? (nota > 0 && nota <= 3)
                : (nota > 0 && nota <= 2);
            final isPar = i % 2 == 0;

            return pw.Container(
              padding:
                  const pw.EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
              decoration: isPar
                  ? const pw.BoxDecoration(
                      color: PdfColors.white,
                      borderRadius:
                          pw.BorderRadius.all(pw.Radius.circular(2)),
                    )
                  : null,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Expanded(
                    child: pw.Row(
                      children: [
                        pw.Text(
                          '${i + 1}. $prefixo: ',
                          style: pw.TextStyle(
                            fontSize: 5.5,
                            fontWeight: pw.FontWeight.bold,
                            color: isAlta ? corAzul : corTextoEscuro,
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            texto,
                            maxLines: 1,
                            overflow: pw.TextOverflow.clip,
                            style: pw.TextStyle(
                              fontSize: 5.5,
                              color: isAlta ? corTextoEscuro : corTextoSuave,
                              fontWeight: isAlta
                                  ? pw.FontWeight.bold
                                  : pw.FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 2.5),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 3.0, vertical: 0.6),
                    decoration: pw.BoxDecoration(
                      color: isAlta
                          ? corAzul
                          : (isBaixa ? PdfColors.grey200 : PdfColors.grey300),
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(2)),
                    ),
                    child: pw.Text(
                      nota > 0 ? '$nota pts' : '-',
                      style: pw.TextStyle(
                        fontSize: 5.8,
                        fontWeight: pw.FontWeight.bold,
                        color: isAlta ? PdfColors.white : corTextoEscuro,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<Uint8List> gerarRelatorioPdf({
    required List<MapEntry<String, int>> itensOrdenados,
    required Map<String, Map<String, String>> infoInteligencias,
    List<List<int>>? respostas,
    String? nomeUsuario,
    String? emailUsuario,
    DateTime? dataRealizacao,
  }) async {
    final pdf = pw.Document();

    pw.Font regularFont;
    pw.Font boldFont;
    try {
      final regularData =
          await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
      final boldData = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');
      regularFont = pw.Font.ttf(regularData);
      boldFont = pw.Font.ttf(boldData);
    } catch (_) {
      regularFont = pw.Font.helvetica();
      boldFont = pw.Font.helveticaBold();
    }

    pw.MemoryImage? logoImage;
    try {
      final logoData = await rootBundle.load('assets/icons/logo.png');
      logoImage = pw.MemoryImage(logoData.buffer.asUint8List());
    } catch (_) {
      logoImage = null;
    }

    final agora = dataRealizacao ?? DateTime.now();
    final dia = agora.day.toString().padLeft(2, '0');
    final mes = agora.month.toString().padLeft(2, '0');
    final ano = agora.year.toString();
    final hora = agora.hour.toString().padLeft(2, '0');
    final minuto = agora.minute.toString().padLeft(2, '0');
    final dataFormatada = '$dia/$mes/$ano às $hora:$minuto';

    final nomeFormatado = (nomeUsuario != null && nomeUsuario.trim().isNotEmpty)
        ? nomeUsuario.trim()
        : 'Visitante';

    final tema = pw.ThemeData.withFont(
      base: regularFont,
      bold: boldFont,
    );

    const corAzul = PdfColor.fromInt(0xFF0053BE);
    const corAzulClaro = PdfColor.fromInt(0xFFEFF6FF);
    const corCinzaFundo = PdfColor.fromInt(0xFFF8FAFC);
    const corBorda = PdfColor.fromInt(0xFFE2E8F0);
    const corTextoEscuro = PdfColor.fromInt(0xFF1E293B);
    const corTextoSuave = PdfColor.fromInt(0xFF64748B);

    final primeiroLugar =
        itensOrdenados.isNotEmpty ? itensOrdenados.first : null;
    final infoPrimeiroLugar = primeiroLugar != null
        ? infoInteligencias[primeiroLugar.key]
        : null;

    pdf.addPage(
      pw.MultiPage(
        theme: tema,
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 26, vertical: 20),
        header: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Row(
                    children: [
                      if (logoImage != null) ...[
                        pw.Image(logoImage, width: 36, height: 36),
                        pw.SizedBox(width: 10),
                      ],
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            Strings.pdfTituloRelatorio,
                            style: pw.TextStyle(
                              fontSize: 13,
                              fontWeight: pw.FontWeight.bold,
                              color: corAzul,
                            ),
                          ),
                          pw.Text(
                            Strings.pdfSubtituloRelatorio,
                            style: const pw.TextStyle(
                              fontSize: 9,
                              color: corTextoSuave,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        '${Strings.pdfParticipante} $nomeFormatado',
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                          color: corTextoEscuro,
                        ),
                      ),
                      if (emailUsuario != null &&
                          emailUsuario.trim().isNotEmpty)
                        pw.Text(
                          emailUsuario.trim(),
                          style: const pw.TextStyle(
                            fontSize: 8,
                            color: corTextoSuave,
                          ),
                        ),
                      pw.Text(
                        '${Strings.pdfData} $dataFormatada',
                        style: const pw.TextStyle(
                          fontSize: 7.5,
                          color: corTextoSuave,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 6),
              pw.Container(
                height: 1.2,
                color: corAzul,
              ),
              pw.SizedBox(height: 6),
            ],
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            margin: const pw.EdgeInsets.only(top: 4),
            padding: const pw.EdgeInsets.only(top: 3),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                top: pw.BorderSide(color: corBorda, width: 0.6),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  Strings.pdfRodapeHowardGardner,
                  style: const pw.TextStyle(fontSize: 7, color: corTextoSuave),
                ),
                pw.Text(
                  'Página ${context.pageNumber} de ${context.pagesCount}',
                  style: const pw.TextStyle(fontSize: 7, color: corTextoSuave),
                ),
              ],
            ),
          );
        },
        build: (pw.Context context) {
          const larguraTotalBarra = 527.0;
          final totalMaximo =
              itensOrdenados.isNotEmpty ? itensOrdenados.length * 10 : 90;
          final totalEstrelas = itensOrdenados.length;

          return [
            if (primeiroLugar != null && infoPrimeiroLugar != null) ...[
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 9, vertical: 5),
                decoration: pw.BoxDecoration(
                  color: corAzulClaro,
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(6)),
                  border: pw.Border.all(color: corAzul, width: 1.0),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: const pw.BoxDecoration(
                            color: corAzul,
                            borderRadius:
                                pw.BorderRadius.all(pw.Radius.circular(3)),
                          ),
                          child: pw.Text(
                            Strings.pdfInteligenciaPredominante,
                            style: pw.TextStyle(
                              fontSize: 7.2,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white,
                            ),
                          ),
                        ),
                        pw.Text(
                          '${primeiroLugar.value} Pontos (${((primeiroLugar.value / totalMaximo) * 100).round()}%)',
                          style: pw.TextStyle(
                            fontSize: 10.0,
                            fontWeight: pw.FontWeight.bold,
                            color: corAzul,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 2.5),
                    pw.Text(
                      infoPrimeiroLugar['key'] ?? primeiroLugar.key,
                      style: pw.TextStyle(
                        fontSize: 12.0,
                        fontWeight: pw.FontWeight.bold,
                        color: corAzul,
                      ),
                    ),
                    pw.SizedBox(height: 1.5),
                    pw.Text(
                      infoPrimeiroLugar['descricao'] ?? '',
                      style: const pw.TextStyle(
                        fontSize: 7.5,
                        color: corTextoEscuro,
                        lineSpacing: 1.12,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 5),
            ],
            pw.Text(
              Strings.pdfClassificacaoGeral,
              style: pw.TextStyle(
                fontSize: 9.0,
                fontWeight: pw.FontWeight.bold,
                color: corTextoEscuro,
              ),
            ),
            pw.SizedBox(height: 3),
            ...List.generate(itensOrdenados.length, (index) {
              final item = itensOrdenados[index];
              final info = infoInteligencias[item.key];
              final nome = info?['key'] ?? item.key;
              final descricao = info?['descricao'] ?? '';
              final pontos = item.value;
              final porcentagem = (pontos / totalMaximo * 100).clamp(0, 100);
              final posicao = '${index + 1}º';

              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 2.8),
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 7, vertical: 2.8),
                decoration: pw.BoxDecoration(
                  color: index == 0 ? corAzulClaro : corCinzaFundo,
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(5)),
                  border: pw.Border.all(
                    color: index == 0 ? corAzul : corBorda,
                    width: index == 0 ? 0.9 : 0.5,
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Row(
                          children: [
                            pw.Container(
                              width: 15,
                              height: 15,
                              alignment: pw.Alignment.center,
                              decoration: pw.BoxDecoration(
                                color:
                                    index == 0 ? corAzul : PdfColors.grey300,
                                shape: pw.BoxShape.circle,
                              ),
                              child: pw.Text(
                                posicao,
                                style: pw.TextStyle(
                                  fontSize: 7.0,
                                  fontWeight: pw.FontWeight.bold,
                                  color: index == 0
                                      ? PdfColors.white
                                      : corTextoEscuro,
                                ),
                              ),
                            ),
                            pw.SizedBox(width: 5),
                            pw.Text(
                              nome,
                              style: pw.TextStyle(
                                fontSize: 9.0,
                                fontWeight: pw.FontWeight.bold,
                                color: index == 0 ? corAzul : corTextoEscuro,
                              ),
                            ),
                          ],
                        ),
                        pw.Text(
                          '$pontos pts (${porcentagem.round()}%)',
                          style: pw.TextStyle(
                            fontSize: 8.0,
                            fontWeight: pw.FontWeight.bold,
                            color: index == 0 ? corAzul : corTextoSuave,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 2.5),
                    pw.Stack(
                      children: [
                        pw.Container(
                          height: 3.0,
                          width: double.infinity,
                          decoration: const pw.BoxDecoration(
                            color: PdfColors.grey200,
                            borderRadius:
                                pw.BorderRadius.all(pw.Radius.circular(2)),
                          ),
                        ),
                        pw.Container(
                          height: 3.0,
                          width: larguraTotalBarra *
                              (porcentagem / 100).clamp(0.01, 1.0),
                          decoration: pw.BoxDecoration(
                            color: index == 0 ? corAzul : corTextoSuave,
                            borderRadius: const pw.BorderRadius.all(
                                pw.Radius.circular(2)),
                          ),
                        ),
                      ],
                    ),
                    if (descricao.isNotEmpty) ...[
                      pw.SizedBox(height: 2.0),
                      pw.Text(
                        descricao,
                        style: const pw.TextStyle(
                          fontSize: 6.8,
                          color: corTextoSuave,
                          lineSpacing: 1.12,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
            pw.SizedBox(height: 3),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                  horizontal: 7, vertical: 3.5),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius:
                    const pw.BorderRadius.all(pw.Radius.circular(5)),
                border: pw.Border.all(color: corBorda, width: 0.6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    Strings.pdfSobreTeoria,
                    style: pw.TextStyle(
                      fontSize: 7.8,
                      fontWeight: pw.FontWeight.bold,
                      color: corTextoEscuro,
                    ),
                  ),
                  pw.SizedBox(height: 1.5),
                  pw.Text(
                    Strings.pdfSobreTeoriaDescricao,
                    style: const pw.TextStyle(
                      fontSize: 6.8,
                      color: corTextoSuave,
                      lineSpacing: 1.12,
                    ),
                  ),
                ],
              ),
            ),
            if (respostas != null && respostas.isNotEmpty) ...[
              pw.NewPage(),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 9, vertical: 4.5),
                decoration: pw.BoxDecoration(
                  color: corAzulClaro,
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(6)),
                  border: pw.Border.all(color: corAzul, width: 1.0),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          Strings.pdfDetalhamentoQuestionario,
                          style: pw.TextStyle(
                            fontSize: 9.5,
                            fontWeight: pw.FontWeight.bold,
                            color: corAzul,
                          ),
                        ),
                        pw.SizedBox(height: 1.0),
                        pw.Text(
                          Strings.pdfDetalhamentoSubtitulo,
                          style: const pw.TextStyle(
                              fontSize: 7.0, color: corTextoSuave),
                        ),
                      ],
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 5.5, vertical: 2.0),
                      decoration: const pw.BoxDecoration(
                        color: corAzul,
                        borderRadius:
                            pw.BorderRadius.all(pw.Radius.circular(4)),
                      ),
                      child: pw.Text(
                        Strings.pdfTotalQuestoesBadge,
                        style: pw.TextStyle(
                          fontSize: 7.0,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        ...List.generate(
                          (itensOrdenados.length / 2).ceil(),
                          (idx) {
                            final item = itensOrdenados[idx];
                            final info = infoInteligencias[item.key];
                            final nome = info?['key'] ?? item.key;
                            final colIndex =
                                _indiceInteligencias[item.key] ?? idx;
                            final totalPontos = item.value;
                            final porcentagem =
                                ((totalPontos / totalMaximo) * 100).round();

                            final perguntasTextos =
                                List.generate(10, (etapaIndex) {
                              if (etapaIndex == 3 &&
                                  Strings.pdfPerguntasChaveEtapa4
                                      .containsKey(item.key)) {
                                return Strings
                                    .pdfPerguntasChaveEtapa4[item.key]!;
                              }
                              if (etapaIndex < perguntas.length &&
                                  colIndex <
                                      (perguntas[etapaIndex] as List).length) {
                                var raw = perguntas[etapaIndex][colIndex]
                                    .toString()
                                    .trim();
                                if (raw.endsWith(':')) {
                                  raw = raw.substring(0, raw.length - 1);
                                }
                                if (raw.endsWith('?')) {
                                  raw = raw.substring(0, raw.length - 1);
                                }
                                return raw;
                              }
                              return 'Afirmação ${etapaIndex + 1}';
                            });

                            final notas = List.generate(10, (etapaIndex) {
                              if (etapaIndex < respostas.length &&
                                  colIndex < respostas[etapaIndex].length) {
                                return respostas[etapaIndex][colIndex];
                              }
                              return 0;
                            });

                            return _buildCardInteligenciaAgrupada(
                              posicao: idx + 1,
                              nome: nome,
                              totalPontos: totalPontos,
                              porcentagem: porcentagem,
                              perguntasTextos: perguntasTextos,
                              notas: notas,
                              corAzul: corAzul,
                              corAzulClaro: corAzulClaro,
                              corCinzaFundo: corCinzaFundo,
                              corBorda: corBorda,
                              corTextoEscuro: corTextoEscuro,
                              corTextoSuave: corTextoSuave,
                              totalEstrelas: totalEstrelas,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 5),
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        ...List.generate(
                          itensOrdenados.length -
                              (itensOrdenados.length / 2).ceil(),
                          (i) {
                            final splitCount =
                                (itensOrdenados.length / 2).ceil();
                            final idx = i + splitCount;
                            final item = itensOrdenados[idx];
                            final info = infoInteligencias[item.key];
                            final nome = info?['key'] ?? item.key;
                            final colIndex =
                                _indiceInteligencias[item.key] ?? idx;
                            final totalPontos = item.value;
                            final porcentagem =
                                ((totalPontos / totalMaximo) * 100).round();

                            final perguntasTextos =
                                List.generate(10, (etapaIndex) {
                              if (etapaIndex == 3 &&
                                  Strings.pdfPerguntasChaveEtapa4
                                      .containsKey(item.key)) {
                                return Strings
                                    .pdfPerguntasChaveEtapa4[item.key]!;
                              }
                              if (etapaIndex < perguntas.length &&
                                  colIndex <
                                      (perguntas[etapaIndex] as List).length) {
                                var raw = perguntas[etapaIndex][colIndex]
                                    .toString()
                                    .trim();
                                if (raw.endsWith(':')) {
                                  raw = raw.substring(0, raw.length - 1);
                                }
                                if (raw.endsWith('?')) {
                                  raw = raw.substring(0, raw.length - 1);
                                }
                                return raw;
                              }
                              return 'Afirmação ${etapaIndex + 1}';
                            });

                            final notas = List.generate(10, (etapaIndex) {
                              if (etapaIndex < respostas.length &&
                                  colIndex < respostas[etapaIndex].length) {
                                return respostas[etapaIndex][colIndex];
                              }
                              return 0;
                            });

                            return _buildCardInteligenciaAgrupada(
                              posicao: idx + 1,
                              nome: nome,
                              totalPontos: totalPontos,
                              porcentagem: porcentagem,
                              perguntasTextos: perguntasTextos,
                              notas: notas,
                              corAzul: corAzul,
                              corAzulClaro: corAzulClaro,
                              corCinzaFundo: corCinzaFundo,
                              corBorda: corBorda,
                              corTextoEscuro: corTextoEscuro,
                              corTextoSuave: corTextoSuave,
                              totalEstrelas: totalEstrelas,
                            );
                          },
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(5.0),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.white,
                            borderRadius: const pw.BorderRadius.all(
                                pw.Radius.circular(4)),
                            border:
                                pw.Border.all(color: corBorda, width: 0.6),
                          ),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                Strings.pdfComoInterpretarNotas,
                                style: pw.TextStyle(
                                  fontSize: 7.5,
                                  fontWeight: pw.FontWeight.bold,
                                  color: corTextoEscuro,
                                ),
                              ),
                              pw.SizedBox(height: 2.5),
                              pw.Text(
                                Strings.pdfGuiaNotaAlta,
                                style: const pw.TextStyle(
                                    fontSize: 6.2, color: corTextoSuave),
                              ),
                              pw.SizedBox(height: 1.5),
                              pw.Text(
                                Strings.pdfGuiaNotaMedia,
                                style: const pw.TextStyle(
                                    fontSize: 6.2, color: corTextoSuave),
                              ),
                              pw.SizedBox(height: 1.5),
                              pw.Text(
                                Strings.pdfGuiaNotaBaixa,
                                style: const pw.TextStyle(
                                    fontSize: 6.2, color: corTextoSuave),
                              ),
                              pw.SizedBox(height: 2.5),
                              pw.Container(height: 0.5, color: corBorda),
                              pw.SizedBox(height: 2.5),
                              pw.Text(
                                Strings.pdfMetodologiaIpsativa,
                                style: pw.TextStyle(
                                  fontSize: 7.0,
                                  fontWeight: pw.FontWeight.bold,
                                  color: corTextoEscuro,
                                ),
                              ),
                              pw.SizedBox(height: 1.2),
                              pw.Text(
                                Strings.pdfMetodologiaIpsativaDescricao,
                                style: const pw.TextStyle(
                                    fontSize: 6.2,
                                    color: corTextoSuave,
                                    lineSpacing: 1.12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ];
        },
      ),
    );

    return pdf.save();
  }

  Future<void> compartilharResultadoPdf({
    required BuildContext context,
    required List<MapEntry<String, int>> itensOrdenados,
    required Map<String, Map<String, String>> infoInteligencias,
    List<List<int>>? respostas,
    String? nomeUsuario,
    String? emailUsuario,
    DateTime? dataRealizacao,
    SharePlus? sharePlus,
  }) async {
    Rect? origin;
    try {
      final box = context.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) {
        origin = box.localToGlobal(Offset.zero) & box.size;
      }
    } catch (_) {
      origin = null;
    }

    final pdfBytes = await gerarRelatorioPdf(
      itensOrdenados: itensOrdenados,
      infoInteligencias: infoInteligencias,
      respostas: respostas,
      nomeUsuario: nomeUsuario,
      emailUsuario: emailUsuario,
      dataRealizacao: dataRealizacao,
    );

    const fileName = 'resultado_inteligencias_multiplas.pdf';
    final share = sharePlus ?? SharePlus.instance;
    await share.share(
      ShareParams(
        files: [
          XFile.fromData(
            pdfBytes,
            mimeType: 'application/pdf',
            name: fileName,
          ),
        ],
        fileNameOverrides: const [fileName],
        subject: Strings.pdfShareSubject,
        text: Strings.pdfShareText,
        sharePositionOrigin: origin,
      ),
    );
  }

  Future<void> baixarResultadoPdf({
    required List<MapEntry<String, int>> itensOrdenados,
    required Map<String, Map<String, String>> infoInteligencias,
    List<List<int>>? respostas,
    String? nomeUsuario,
    String? emailUsuario,
    DateTime? dataRealizacao,
    Future<void> Function(XFile file)? onSaveFile,
  }) async {
    final pdfBytes = await gerarRelatorioPdf(
      itensOrdenados: itensOrdenados,
      infoInteligencias: infoInteligencias,
      respostas: respostas,
      nomeUsuario: nomeUsuario,
      emailUsuario: emailUsuario,
      dataRealizacao: dataRealizacao,
    );

    const fileName = 'resultado_inteligencias_multiplas.pdf';
    final xFile = XFile.fromData(
      pdfBytes,
      mimeType: 'application/pdf',
      name: fileName,
      path: fileName,
    );

    if (onSaveFile != null) {
      await onSaveFile(xFile);
    } else {
      await xFile.saveTo(fileName);
    }
  }
}
