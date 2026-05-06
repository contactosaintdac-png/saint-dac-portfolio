$baseDir = 'c:\Users\leshx\Downloads'

# 1. Crear las carpetas si no existen
$folders = @(
    '01 - APRENDIZAJE & ESTRATEGIA',
    '02 - PROYECTO PAME (ADMIN)',
    '03 - GENERACIONES IA',
    '04 - MEDIA ASSETS',
    '05 - LEGAL & ADMIN',
    '06 - SOFTWARE & GAMES',
    'DESARROLLO'
)

foreach ($f in $folders) {
    $path = Join-Path $baseDir $f
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
    }
}

# 2. Eliminar el archivo .rar
$rarPath = Join-Path $baseDir 'fl 2024.rar'
if (Test-Path $rarPath) {
    Remove-Item $rarPath -Force
}

# 3. Mover Recursos a DESARROLLO
$recursosPath = Join-Path $baseDir 'Recursos'
$desarrolloPath = Join-Path $baseDir 'DESARROLLO'
if (Test-Path $recursosPath) {
    $targetPath = Join-Path $desarrolloPath 'Recursos'
    if (-not (Test-Path $targetPath)) {
        Move-Item $recursosPath $desarrolloPath -Force
    }
}

# 4. Clasificar archivos
# --- Aprendizaje & Estrategia ---
Get-ChildItem $baseDir -File | Where-Object { 
    ($_.Name -match 'HOOKS|SANGRAR|SECUESTRAR|DOGMA|FECHAMENTO|ESTILO|Ganchos|FÁBRICA|MÁQUINA|Perfil|VIRAL|🎁|GUIA') -and ($_.Extension -eq '.pdf')
} | Move-Item -Destination (Join-Path $baseDir '01 - APRENDIZAJE & ESTRATEGIA') -ErrorAction SilentlyContinue

# --- Proyecto Pame ---
Get-ChildItem $baseDir -File | Where-Object { 
    $_.Name -match 'Manutenção|Deep Clean|Limpeza|Airbnb|Mudança|Adicionais|PAMELA|Candidatas|Preços|Precos|Responsabilidade|CHECKLIST'
} | Move-Item -Destination (Join-Path $baseDir '02 - PROYECTO PAME (ADMIN)') -ErrorAction SilentlyContinue

# --- Generaciones IA ---
Get-ChildItem $baseDir -File | Where-Object { 
    $_.Name -match 'Gemini|ChatGPT|Firefly|Casual_smartphone|Earth_planet|Header__context|Man_scrolling|The_character|ahora_mira|cambia_el_fondo|cambiar_fondo|esta_exactamente|hace_esta|hacelo_con|quiero_que_cambie|quiero_que_mejores|{__'
} | Move-Item -Destination (Join-Path $baseDir '03 - GENERACIONES IA') -ErrorAction SilentlyContinue

# --- Media Assets ---
Get-ChildItem $baseDir -File | Where-Object { 
    ($_.Extension -match 'mp3|mp4|ogg|png|jpg|jpeg') -and ($_.Name -notmatch '^0[1-6] -|^DESARROLLO')
} | Move-Item -Destination (Join-Path $baseDir '04 - MEDIA ASSETS') -ErrorAction SilentlyContinue

# --- Legal & Admin ---
Get-ChildItem $baseDir -File | Where-Object { 
    ($_.Name -match 'Acta|CARTA|Compromiso|Cartao|Certificado|DFE') -and ($_.Extension -eq '.pdf')
} | Move-Item -Destination (Join-Path $baseDir '05 - LEGAL & ADMIN') -ErrorAction SilentlyContinue

# --- Software & Games ---
Get-ChildItem $baseDir -Directory | Where-Object { 
    $_.Name -match 'Enshrouded' -and $_.Name -notmatch '^0[1-6] -|^DESARROLLO'
} | Move-Item -Destination (Join-Path $baseDir '06 - SOFTWARE & GAMES') -ErrorAction SilentlyContinue
