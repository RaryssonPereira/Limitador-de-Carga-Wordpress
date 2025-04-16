#!/bin/bash

echo "🛡️  WP Load Shield - Controle de carga para WordPress"
echo "-----------------------------------------------"

# 🧭 Etapa 1: Procurar sites válidos com WordPress dentro de /var/www/
# Apenas diretórios que contenham o arquivo wp-config.php serão considerados sites válidos
echo "🔍 Procurando sites WordPress em /var/www/"
sites=()

for dir in /var/www/*/; do
    if [ -f "$dir/wp-config.php" ]; then
        sites+=("$dir")
    fi
done

# Se nenhum site for encontrado, encerra o script
if [ ${#sites[@]} -eq 0 ]; then
  echo "❌ Nenhum site WordPress com wp-config.php foi encontrado em /var/www/"
  exit 1
fi

# 🧠 Etapa 2: Exibir os sites encontrados e permitir ao usuário escolher um
echo "🗂️  Sites WordPress detectados:"
select site in "${sites[@]}"; do
  if [[ -n "$site" ]]; then
    echo "📍 Selecionado: $site"
    break
  else
    echo "❌ Opção inválida, tente novamente."
  fi
done

# 🛠️ Etapa 3: Definir caminhos
INI_FILE="$site/load-limit.ini"       # Caminho do arquivo de configuração externo
WPCONFIG="$site/wp-config.php"        # Caminho do wp-config do WordPress

# 📄 Etapa 4: Criar o arquivo .ini com as variáveis de controle de carga, se ele ainda não existir
if [ ! -f "$INI_FILE" ]; then
  echo "✅ Criando $INI_FILE"
  cat <<EOF > "$INI_FILE"
; Arquivo de configuração de limite de carga
MAX_LOAD_LIMIT = 60
ENABLE_LOAD_LIMIT = true
EOF
else
  echo "⚠️  O arquivo $INI_FILE já existe. Não será sobrescrito."
fi

# 🔐 Etapa 5: Inserir a lógica PHP no wp-config.php se ainda não estiver presente
if grep -q "MAX_LOAD_LIMIT" "$WPCONFIG"; then
  echo "⚠️  A lógica de controle de carga já está presente no wp-config.php"
else
  echo "✅ Adicionando regra no wp-config.php"
  cat <<'PHP' >> "$WPCONFIG"

# === WP LOAD SHIELD ===
$ini_file = dirname(__FILE__) . '/load-limit.ini';
$max_load = 60;
$limite_ativo = true;

if (file_exists($ini_file)) {
    $config = parse_ini_file($ini_file);
    if (isset($config['MAX_LOAD_LIMIT'])) {
        $max_load = (float) $config['MAX_LOAD_LIMIT'];
    }
    if (isset($config['ENABLE_LOAD_LIMIT'])) {
        $limite_ativo = filter_var($config['ENABLE_LOAD_LIMIT'], FILTER_VALIDATE_BOOLEAN);
    }
}

if ($limite_ativo) {
    $load = sys_getloadavg();
    $request_uri = $_SERVER['REQUEST_URI'];
    $urls_excluidas = ['/robots.txt', '/sitemap.xml', '/favicon.ico'];
    $whitelisted_patterns = ['/wp-json/cache-status/', '/cdn-cgi/', '/wp-content/'];

    $is_excluded = false;
    foreach (array_merge($urls_excluidas, $whitelisted_patterns) as $item) {
        if (strpos($request_uri, $item) !== false) {
            $is_excluded = true;
            break;
        }
    }

    if ($load[0] > $max_load && !$is_excluded) {
        header($_SERVER['SERVER_PROTOCOL'] . ' 503 Service Unavailable', true, 503);
        header('Retry-After: 120');
        exit();
    }
}
# === FIM WP LOAD SHIELD ===

PHP
fi

# 🔒 Etapa 6: Mostrar instrução de segurança para proteger o .ini no Nginx
echo "🔐 Para segurança, adicione no bloco do Nginx:"
echo "
location ~* \.ini$ {
    deny all;
}
"

# ✅ Conclusão
echo "✅ Finalizado! WP Load Shield ativo em: $site"
