# Menu de Temas - Hyprland

Este documento descreve como funciona o sistema de temas do projeto, incluindo a integração com o menu (rofi) e o uso de symlinks para aplicar estilos aos componentes.

---

## Conceito Geral

O sistema de temas é baseado em **substituição de arquivos via symlinks**, ao invés de variáveis globais.

Cada componente (Waybar, Rofi, Hyprland, etc.) possui seus próprios arquivos de estilo, e o tema ativo é definido apontando esses arquivos para versões específicas dentro da pasta de temas.

---

## Estrutura de Temas

Os temas são organizados em diretórios contendo variações de arquivos de estilo para cada componente.

Exemplo:

```bash
themes/
├── theme-1/
│   ├── waybar.css
│   ├── rofi.rasi
│   ├── hypr.conf
│
├── theme-2/
│   ├── waybar.css
│   ├── rofi.rasi
│   ├── hypr.conf
```

---

## Uso de Symlinks

Ao invés de editar arquivos diretamente, o sistema utiliza **links simbólicos** para apontar para os arquivos do tema ativo.

Exemplo:

```bash
~/.config/waybar/style.css → themes/theme-1/waybar.css
~/.config/rofi/config.rasi → themes/theme-1/rofi.rasi
```

Isso permite:

* Troca instantânea de tema
* Separação clara entre configuração e estilo
* Facilidade de manutenção

---

## Menu de Temas (Rofi)

O menu de temas funciona como interface para seleção do tema ativo.

Fluxo:

1. O usuário abre o menu de temas via rofi
2. Os temas disponíveis são listados dinamicamente
3. Ao selecionar um tema:

   * Um script é executado
   * Os symlinks são atualizados
   * O sistema recarrega os componentes

---

## Fluxo Completo

```bash
Usuário abre menu (rofi)
        ↓
Seleciona um tema
        ↓
Script é executado
        ↓
Atualização dos symlinks
        ↓
Recarregamento dos componentes (waybar, hyprland, etc.)
        ↓
Novo tema aplicado
```

---

## Scripts

Os scripts são responsáveis por:

* Listar temas disponíveis
* Atualizar symlinks
* Reiniciar/recarregar componentes

Exemplo de ações realizadas:

* `ln -sf` para redefinir links simbólicos
* `killall waybar && waybar &`
* reload do Hyprland (quando necessário)

---

## Vantagens da Abordagem

* Não depende de variáveis globais
* Cada componente mantém sua própria configuração
* Sistema modular e escalável
* Fácil de adicionar novos temas
* Troca de tema rápida e previsível

---

## Observação

Existe um arquivo `colors.env` no projeto, mas ele **não é utilizado no fluxo atual**.

Ele está presente apenas como base para uma possível evolução futura do sistema (ex: centralização de cores via variáveis).

---

## Conclusão

O sistema atual prioriza simplicidade e controle direto, utilizando symlinks como mecanismo principal de troca de temas.

Isso garante um fluxo claro, fácil de entender e eficiente para uso diário.
