# GitFlow E Aprovação De PR

Este projeto segue um fluxo inspirado em GitFlow, simplificado para um time
pequeno e com qualidade protegida por CI no GitHub Actions.

## Objetivo

- Permitir evolução contínua sem quebrar instalação/uso diário.
- Garantir rastreabilidade de mudanças.
- Exigir aprovação explícita do mantenedor antes de merge.

## Modelo De Branches Ativo

- `main`: produção estável, sempre pronta para uso.
- `develop`: integração contínua de features antes de release.
- `feature/<nome-curto>`: novas funcionalidades.
- `fix/<nome-curto>`: correções não críticas.
- `bugfix/<nome-curto>`: alias aceito para correções não críticas.
- `hotfix/<nome-curto>`: correções urgentes para produção.
- `release/<versao>`: preparação de release (changelog, docs, ajustes finais).
- `chore/<nome-curto>`: manutenção sem mudança funcional.
- `docs/<nome-curto>`: documentação.

Fluxo padrão:

```text
feature/* -> PR -> develop -> release/* -> PR -> main
fix/*     -> PR -> develop
hotfix/*  -> PR -> main -> backport/merge para develop
```

`main` representa o que uma pessoa pode instalar com confiança. `develop`
representa a próxima versão em integração.

## Comandos Práticos

Criar uma feature:

```powershell
git switch develop
git pull origin develop
git switch -c feature/nome-curto
```

Criar uma correção comum:

```powershell
git switch develop
git pull origin develop
git switch -c fix/nome-curto
```

Criar um hotfix de produção:

```powershell
git switch main
git pull origin main
git switch -c hotfix/nome-curto
```

Preparar release:

```powershell
git switch develop
git pull origin develop
git switch -c release/vX.Y.Z
```

## Regras De Pull Request

- Nunca fazer push direto em `main`.
- Evitar push direto em `develop`; use PR sempre que possível.
- Todo merge deve acontecer por PR.
- PR deve ser pequeno e focado (um objetivo claro).
- PR deve descrever risco, impacto e validação local.
- PR só pode ser mergeado com CI verde.
- Features e fixes entram primeiro em `develop`.
- Releases e hotfixes entram em `main` com aprovação do mantenedor.

## Aprovação Obrigatória Do Mantenedor

Este repositório usa `CODEOWNERS` apontando o mantenedor principal. Para tornar
a aprovação realmente obrigatória, configure no GitHub:

1. `Settings > Branches > Add rule` para `main`
2. Habilitar `Require a pull request before merging`
3. Habilitar `Require approvals` (mínimo 1)
4. Habilitar `Require review from Code Owners`
5. Habilitar `Require status checks to pass before merging`
6. Selecionar o check `validate` (workflow CI)
7. Opcional e recomendado: `Require branches to be up to date before merging`
8. Opcional e recomendado: `Do not allow bypassing the above settings`

Repita uma regra equivalente para `develop`, também exigindo PR e CI verde.
Com isso, o merge para `main` e `develop` depende do processo de revisão.

## Aplicar Proteção Por Script

Se preferir aplicar via API em vez da interface do GitHub, use:

```powershell
$env:GITHUB_TOKEN = '<token-com-administration-write>'
pwsh -NoLogo -NoProfile -File .\scripts\configure-branch-protection.ps1
```

O token precisa ter permissão de administração do repositório. Em fine-grained
tokens, habilite `Administration: Read and write` para este repositório.

O script aplica em `main` e `develop`:

- PR obrigatório antes de merge.
- 1 aprovação obrigatória.
- aprovação de CODEOWNERS obrigatória.
- status check obrigatório: `validate`.
- reviews antigas descartadas após novos pushes.
- admins também seguem a proteção (`enforce_admins`).
- force push e deleção de branch bloqueados.
- resolução de conversas obrigatória.

## Política De Merge

- Preferir `Squash and merge` para histórico limpo.
- Título do commit de merge deve ser descritivo.
- Referenciar issue relacionada quando existir.

## Checklist Mínimo Antes De Abrir PR

```powershell
pwsh -NoLogo -NoProfile -File .\scripts\check.ps1
pwsh -NoLogo -NoProfile -File .\scripts\test-profile.ps1
pwsh -NoLogo -NoProfile -File .\scripts\test-unit.ps1
pwsh -NoLogo -NoProfile -File .\scripts\test-e2e-reinstall.ps1
pwsh -NoLogo -NoProfile -File .\scripts\legal-check.ps1
```

## CI/CD Atual (Diagnóstico)

Hoje o pipeline está em `.github/workflows/ci.yml` com job `validate` em
`windows-latest` e os passos:

- diagnóstico (`scripts/check.ps1`)
- smoke test (`scripts/test-profile.ps1`)
- unitários (`scripts/test-unit.ps1`)
- E2E de reinstalação (`scripts/test-e2e-reinstall.ps1`)
- checagem legal (`scripts/legal-check.ps1`)

O workflow roda em push para:

- `main`
- `develop`
- `feature/**`
- `fix/**`
- `bugfix/**`
- `hotfix/**`
- `release/**`
- `chore/**`
- `docs/**`

O workflow também roda em PRs direcionados para `main` e `develop`, além de
permitir execução manual via `workflow_dispatch`.

Status: **CI está consistente com o processo de qualidade**.

Observação: **CD de release/publicação automática não está configurado**. Se
quiser CD, o próximo passo é criar workflow de release com tag/versionamento.
