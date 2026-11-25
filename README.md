# plataforma-artefatos

Catálogo dos artefatos higienizados que os projetos Claude da BU de Digital Analytics compartilham com outras áreas da Leega.

- **Repositório:** privado, na organização `Leega-Digital-Analytics`. Nunca tornar público.
- **Hospedagem:** Cloudflare Pages (site estático, sem etapa de build, diretório de saída na raiz), protegido pelo Cloudflare Access com login Google só para convidados. Passo a passo no guia de configuração do Cloudflare da BU.
- **Estado:** esqueleto v0.1.0. Ainda sem deploy no Cloudflare e sem artefatos publicados.

## Estrutura

```
index.html            catálogo (lê manifest.json, com busca)
manifest.json         lista de artefatos publicados (JSON, array)
artefatos/<slug>/     um artefato por pasta: index.html, assets/, metadata.json
assets/               tokens do design system Leega e logos oficiais
```

Cada entrada do `manifest.json` e cada `artefatos/<slug>/metadata.json` têm: `slug`, `titulo`, `descricao`, `dono`, `versao`, `repositorio_origem`, `commit_origem`, `publicado_em` (AAAA-MM-DD) e `higienizado: true`.

## Como publicar

Somente pela skill `/padroes-bu:publicar-artefato` do plugin `padroes-bu`, que roda o checklist de higienização, grava os metadados, atualiza o `manifest.json` e abre um **pull request**. Nada de push direto na `main`: a tech lead revisa e faz o merge, e o deploy ocorre depois do merge.

## Regras

- Só artefato higienizado: sem nome de cliente, setor identificável, números reais, dado pessoal ou credencial.
- Nunca publicar `origem/` nem `dados-cliente/`.
- A decisão de publicar é de quem publica, ciente dos riscos de contrato, NDA e LGPD. Na dúvida, não publique.
- A lista de convidados vive só na política do Cloudflare Access, não neste repositório.
