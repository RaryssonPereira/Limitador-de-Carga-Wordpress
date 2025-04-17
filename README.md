# 🛡️ WP Load Shield - Limitador de Carga para WordPress com Shell Script

Este projeto contém um script interativo escrito em **Shell Script (Bash)** para proteger sites WordPress contra sobrecarga de servidor. O script aplica uma regra de controle de carga diretamente no `wp-config.php`, usando um arquivo externo de configuração (`load-limit.ini`) que define limites e ativa ou desativa dinamicamente a proteção.

🎯 O objetivo principal é fornecer um recurso de proteção inteligente para momentos de pico de tráfego, garantindo estabilidade ao servidor sem comprometer a experiência do usuário ou o SEO do site.

---

## 📜 Sobre o script

**Arquivo**: `wp-load-shield.sh`  
**Criado por**: [Rarysson](https://github.com/RaryssonPereira)  
**Objetivo**: Automatizar a inserção de uma lógica de proteção contra carga excessiva em sites WordPress, baseada em `sys_getloadavg()` e com exclusões configuráveis, mantendo o sistema responsivo mesmo sob alta demanda.

---

## 📌 Funcionalidades

- Detecta automaticamente diretórios com instalação WordPress em `/var/www/`.
- Permite ao usuário escolher em qual site aplicar a proteção.
- Cria o arquivo `load-limit.ini` com valores de carga máxima e ativador da regra.
- Insere no `wp-config.php` a lógica PHP de controle de carga, com:
  - Detecção de `load average` atual.
  - Exclusão de URLs estáticas ou essenciais.
  - Resposta `503 Service Unavailable` com `Retry-After`.
- Gera recomendação para proteção do `.ini` via Nginx.

---

## ⚙️ Pré-requisitos

- ✅ Servidor Linux com Ubuntu 22.04 ou superior.
- ✅ Permissões de root (ou `sudo`).
- ✅ Instalação do WordPress no diretório `/var/www/`.
- ✅ Shell Bash funcional.

---

## 📝 Personalizações necessárias

- O limite de carga é definido via `load-limit.ini`, permitindo ajustes sem alterar o PHP.
- As URLs ou padrões ignorados (como `/robots.txt`, `/wp-content/`, etc.) podem ser modificados diretamente no trecho PHP inserido.

---

## 📂 Arquivos afetados pelo script

- `wp-config.php` do site WordPress
- `load-limit.ini` (criado no diretório raiz do site WordPress)

---

## ⚠️ Avisos importantes

- O script **não sobrescreve configurações existentes** se já houver a lógica no `wp-config.php`.
- A regra é inserida de forma **segura e comentada** no final do arquivo.
- O `.ini` é externo e deve ser protegido contra acesso público com regra no servidor web.

---

## 🧐 Exemplos de aprendizado

- Como automatizar tarefas de infraestrutura com Shell Script.
- Como aplicar proteção contra sobrecarga no PHP usando `sys_getloadavg()`.
- Como parametrizar lógicas com arquivos externos (`.ini`).
- Como bloquear URLs criticamente sem afetar o site inteiro.

---

## ▶️ Como usar

### 1. Torne o script executável

```bash
chmod +x wp-load-shield.sh
```

### 2. Execute com permissões de root

```bash
sudo ./wp-load-shield.sh
```

Siga as instruções interativas para selecionar o site desejado e aplicar a proteção.

---

## 🧪 Sugestão

> Adapte os valores do `.ini` para cada cliente conforme a capacidade do servidor (por exemplo, `MAX_LOAD_LIMIT = 100` para 8 vCPUs ou mais).

---

## ❤️ Contribuindo

Sinta-se à vontade para contribuir com este projeto:
- Relatando bugs
- Sugerindo melhorias
- Criando novas funcionalidades

Abra uma **Issue** ou envie um **Pull Request** ✨

---

## 📜 Licença

Distribuído sob a licença **MIT**.  
Você pode **usar, modificar e compartilhar** livremente!

---

## ✨ Créditos

Criado com dedicação por **Rarysson**,  
pensado para administradores de servidores, agências e entusiastas que desejam aplicar proteção inteligente contra sobrecarga em sites WordPress. 🚀
