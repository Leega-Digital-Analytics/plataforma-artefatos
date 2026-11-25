# plataforma-artefatos

Catálogo dos artefatos higienizados que os projetos Claude da BU de Digital Analytics compartilham com outras áreas da Leega.

## Fases

| Fase | Hospedagem | Visibilidade | Acesso |
|---|---|---|---|
| **1. Piloto (atual, desde 2026-11-25)** | GitHub Pages, branch `main`, raiz | Repositório e site **públicos** (o plano Free só publica Pages de repositório público) | Aberto a qualquer pessoa com o link, sem login, `noindex` |
| **2. Definitiva** | Cloudflare Pages, sem etapa de build, saída na raiz | Repositório privado | Cloudflare Access com login Google, só convidados |

- **URL do piloto:** https://leega-digital-analytics.github.io/plataforma-artefatos/
- **Critério para passar à fase 2:** pelo menos 2 artefatos publicados pela skill via pull request, catálogo funcionando e feedback de 2 ou mais pessoas do time.
- **Como migrar:** desligar o GitHub Pages, voltar o repositório a privado e seguir o guia de configuração do Cloudflare da BU. Voltar a privado **não apaga** cópias, forks ou caches do que ficou público.

## Estrutura

```
index.html            catálogo (lê manifest.json, com busca)
manifest.json         lista de artefatos publicados (JSON, array)
artefatos/<slug>/     um artefato por pasta: index.html, assets/, metadata.json
assets/               tokens do design system Leega e logos oficiais
.nojekyll             serve os arquivos como estão no GitHub Pages
```

Cada entrada do `manifest.json` e cada `artefatos/<slug>/metadata.json` têm: `slug`, `titulo`, `descricao`, `dono`, `versao`, `repositorio_origem`, `commit_origem`, `publicado_em` (AAAA-MM-DD) e `higienizado: true`.

## Como publicar

Somente pela skill `/padroes-bu:publicar-artefato` do plugin `padroes-bu`, que roda o checklist de higienização, grava os metadados, atualiza o `manifest.json` e abre um **pull request**. A `main` é protegida: sem push direto e sem force push. A tech lead revisa e faz o merge, e o deploy ocorre depois do merge.

## Regras

- Na fase 1, **tudo o que entra aqui fica público na internet**, inclusive o histórico do repositório. Só publique o que pode ficar público para sempre.
- Só artefato higienizado: sem nome de cliente, setor identificável, números reais, dado pessoal ou credencial.
- Nunca publicar `origem/` nem `dados-cliente/`.
- A decisão de publicar é de quem publica, ciente dos riscos de contrato, NDA e LGPD. Na dúvida, não publique.
- Na fase 2, a lista de convidados vive só na política do Cloudflare Access, não neste repositório.
