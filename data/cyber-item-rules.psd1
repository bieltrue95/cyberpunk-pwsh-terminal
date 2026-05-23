@{
    # Cyber item rules are intentionally data-only.
    # Add or edit patterns here instead of changing the renderer logic.
    # Keep this file as UTF-8 because Nerd Font glyphs are stored directly.

    Defaults = @{
        LinkIcon = ''
        DirectoryIcon = ''
        FileIcon = ''
        DirectoryColor = '#00E5FF'
        FileColor = '#E6ECFF'
    }

    DirectoryIconRules = @(
        @{ Pattern = '^\.git$'; Icon = '' }
        @{ Pattern = '^\.github$'; Icon = '' }
        @{ Pattern = '^\.gitlab$'; Icon = '' }
        @{ Pattern = '^\.vscode'; Icon = '󰨞' }
        @{ Pattern = '^\.idea$'; Icon = '' }
        @{ Pattern = '^\.cache$|^cache$|^caches$|^tmp$|^temp$'; Icon = '󰃨' }
        @{ Pattern = '^\.config$|^config$|^configs$|^settings$|^preferences$'; Icon = '' }
        @{ Pattern = '^\.ssh$|^ssh$|^keys$|^secrets?$'; Icon = '' }
        @{ Pattern = '^certs?$|^certificates$|^ssl$|^tls$'; Icon = '󰄤' }
        @{ Pattern = '^\.aws$|^aws$'; Icon = '' }
        @{ Pattern = '^\.azure$|^azure$'; Icon = '󰠅' }
        @{ Pattern = '^\.docker$|^docker$'; Icon = '' }
        @{ Pattern = '^\.kube$|^kubernetes$|^k8s$'; Icon = '󱃾' }
        @{ Pattern = '^\.terraform$|^terraform$'; Icon = '󱁢' }
        @{ Pattern = '^node_modules$'; Icon = '' }
        @{ Pattern = '^\.npm$|^npm$'; Icon = '' }
        @{ Pattern = '^\.pnpm-store$|^pnpm$'; Icon = '' }
        @{ Pattern = '^\.yarn$|^yarn$'; Icon = '' }
        @{ Pattern = '^\.nuget$|^nuget$|^packages$'; Icon = '󰏖' }
        @{ Pattern = '^\.venv$|^venv$|^env$|^virtualenv$'; Icon = '' }
        @{ Pattern = '^bin$|^obj$|^dist$|^build$|^out$|^target$|^release$|^debug$'; Icon = '' }
        @{ Pattern = '^src$|^source$|^lib$|^libs$|^components$|^pages$|^app$'; Icon = '' }
        @{ Pattern = '^public$|^static$|^assets$|^wwwroot$|^web$'; Icon = '󱉊' }
        @{ Pattern = '^tests?$|^specs?$|^__tests__$|^coverage$'; Icon = '󰙨' }
        @{ Pattern = '^logs?$'; Icon = '󰌱' }
        @{ Pattern = '^data$|^database$|^db$|^migrations$'; Icon = '' }
        @{ Pattern = '^docs?$|^wiki$|^manuals?$'; Icon = '' }
        @{ Pattern = '^\$Recycle\.Bin$'; Icon = '' }
        @{ Pattern = '^Windows$'; Icon = '󰖳' }
        @{ Pattern = '^System32$|^SysWOW64$|^WinSxS$'; Icon = '' }
        @{ Pattern = '^Program Files( \(x86\))?$'; Icon = '󰏖' }
        @{ Pattern = '^ProgramData$'; Icon = '' }
        @{ Pattern = '^PerfLogs$'; Icon = '󰌱' }
        @{ Pattern = '^inetpub$'; Icon = '󱉊' }
        @{ Pattern = '^Recovery$'; Icon = '' }
        @{ Pattern = '^Users$'; Icon = '' }
        @{ Pattern = '^Default$|^Public$|^All Users$'; Icon = '󰀄' }
        @{ Pattern = '^AppData$|^Local$|^LocalLow$|^Roaming$'; Icon = '' }
        @{ Pattern = '^3D Objects$'; Icon = '' }
        @{ Pattern = '^Desktop$'; Icon = '󰟀' }
        @{ Pattern = '^Documents$'; Icon = '' }
        @{ Pattern = '^Downloads$'; Icon = '󰉍' }
        @{ Pattern = '^Pictures$'; Icon = '󰉏' }
        @{ Pattern = '^Music$'; Icon = '󰌳' }
        @{ Pattern = '^Videos$'; Icon = '󰎁' }
        @{ Pattern = '^OneDrive$'; Icon = '󰏊' }
        @{ Pattern = '^Contacts$'; Icon = '󰛋' }
        @{ Pattern = '^Favorites$'; Icon = '󰚝' }
        @{ Pattern = '^Links$'; Icon = '' }
        @{ Pattern = '^Saved Games$'; Icon = '󰊴' }
        @{ Pattern = '^Searches$'; Icon = '' }
    )

    FileIconRules = @(
        @{ Pattern = '^README'; Icon = '󰂺' }
        @{ Pattern = '^CHANGELOG|^HISTORY|^RELEASES'; Icon = '󰦖' }
        @{ Pattern = '^TODO|^NOTES'; Icon = '󰎞' }
        @{ Pattern = '^LICENSE|^COPYING'; Icon = '' }
        @{ Pattern = '^\.env'; Icon = '' }
        @{ Pattern = '^\.git'; Icon = '' }
        @{ Pattern = '^\.gitattributes$'; Icon = '' }
        @{ Pattern = '^\.gitignore$'; Icon = '' }
        @{ Pattern = '^\.editorconfig$'; Icon = '' }
        @{ Pattern = '^\.npmrc$|^\.yarnrc'; Icon = '' }
        @{ Pattern = '^\.dockerignore$'; Icon = '' }
        @{ Pattern = '^docker-compose.*\.ya?ml$'; Icon = '' }
        @{ Pattern = '^Dockerfile$|^Containerfile$'; Icon = '' }
        @{ Pattern = '^\.github.*\.ya?ml$'; Icon = '' }
        @{ Pattern = '^\.gitlab-ci\.yml$'; Icon = '' }
        @{ Pattern = '^azure-pipelines\.ya?ml$'; Icon = '󰿕' }
        @{ Pattern = '^bitbucket-pipelines\.ya?ml$'; Icon = '' }
        @{ Pattern = '^Jenkinsfile$'; Icon = '' }
        @{ Pattern = '^terraform\.'; Icon = '󱁢' }
        @{ Pattern = '^\.babelrc$|^babel\.config\.'; Icon = '' }
        @{ Pattern = '^\.eslintrc'; Icon = '󰱺' }
        @{ Pattern = '^\.prettierrc'; Icon = '' }
        @{ Pattern = '^angular\.json$'; Icon = '' }
        @{ Pattern = '^eslint\.config\.'; Icon = '󰱺' }
        @{ Pattern = '^firebase\.json$'; Icon = '' }
        @{ Pattern = '^gruntfile\.(js|coffee|ts)$'; Icon = '' }
        @{ Pattern = '^gulpfile\.(js|coffee|ts)$'; Icon = '' }
        @{ Pattern = '^jquery.*\.js$'; Icon = '' }
        @{ Pattern = '^next\.config\.'; Icon = '' }
        @{ Pattern = '^nuxt\.config\.'; Icon = '󰡄' }
        @{ Pattern = '^package(-lock)?\.json$'; Icon = '' }
        @{ Pattern = '^pnpm-(lock|workspace)\.ya?ml$'; Icon = '' }
        @{ Pattern = '^postcss\.config\.'; Icon = '󱏿' }
        @{ Pattern = '^svelte\.config\.'; Icon = '' }
        @{ Pattern = '^tailwind\.config\.'; Icon = '󱏿' }
        @{ Pattern = '^tsconfig\.json$'; Icon = '' }
        @{ Pattern = '^vite\.config\.'; Icon = '' }
        @{ Pattern = '^vue\.config\.(js|ts)$'; Icon = '󰡄' }
        @{ Pattern = '^webpack\.config\.'; Icon = '󰜫' }
        @{ Pattern = '^yarn\.lock$'; Icon = '' }
        @{ Pattern = '^composer\.(json|lock)$'; Icon = '' }
        @{ Pattern = '^requirements.*\.txt$|^pyproject\.toml$|^poetry\.lock$|^Pipfile$'; Icon = '' }
        @{ Pattern = '^Gemfile$|^Gemfile\.lock$'; Icon = '' }
        @{ Pattern = '^go\.mod$|^go\.sum$'; Icon = '' }
        @{ Pattern = '^Cargo\.toml$|^Cargo\.lock$'; Icon = '' }
        @{ Pattern = '^pom\.xml$|^build\.gradle'; Icon = '' }
        @{ Pattern = '^CMakeLists\.txt$|^Makefile$'; Icon = '' }
        @{ Pattern = '^appsettings.*\.json$|^global\.json$'; Icon = '' }
    )

    ExtensionIcons = @{
        '.ps1' = '󰨊'
        '.psm1' = '󰨊'
        '.psd1' = '󰨊'
        '.ps1xml' = '󰨊'
        '.sh' = ''
        '.bash' = ''
        '.zsh' = ''
        '.fish' = ''
        '.bat' = ''
        '.cmd' = ''
        '.json' = ''
        '.jsonc' = ''
        '.yml' = ''
        '.yaml' = ''
        '.toml' = ''
        '.ini' = ''
        '.conf' = ''
        '.config' = ''
        '.properties' = ''
        '.props' = ''
        '.xml' = '󰗀'
        '.csv' = '󱎏'
        '.tsv' = '󱎏'
        '.db' = ''
        '.sqlite' = ''
        '.sqlite3' = ''
        '.mdb' = ''
        '.accdb' = '󱎏'
        '.bak' = '󰁯'
        '.md' = ''
        '.mdx' = ''
        '.markdown' = ''
        '.txt' = ''
        '.log' = '󰌱'
        '.pdf' = ''
        '.doc' = '󱎒'
        '.docx' = '󱎒'
        '.dot' = '󱎒'
        '.dotx' = '󱎒'
        '.xls' = '󱎏'
        '.xlsx' = '󱎏'
        '.xlsm' = '󱎏'
        '.xltx' = '󱎏'
        '.ppt' = '󱎐'
        '.pptx' = '󱎐'
        '.ppsx' = '󱎐'
        '.one' = '󰝇'
        '.vsdx' = '󰘐'
        '.js' = ''
        '.mjs' = ''
        '.cjs' = ''
        '.ts' = ''
        '.tsx' = ''
        '.jsx' = ''
        '.vue' = '󰡄'
        '.svelte' = ''
        '.astro' = ''
        '.html' = ''
        '.htm' = ''
        '.css' = ''
        '.scss' = ''
        '.sass' = ''
        '.py' = ''
        '.ipynb' = ''
        '.php' = ''
        '.go' = ''
        '.rs' = ''
        '.rb' = ''
        '.java' = ''
        '.cs' = '󰌛'
        '.csproj' = ''
        '.fs' = ''
        '.fsx' = ''
        '.fsproj' = ''
        '.vb' = ''
        '.vbproj' = ''
        '.xaml' = '󰙳'
        '.razor' = ''
        '.cshtml' = ''
        '.sln' = ''
        '.slnx' = ''
        '.c' = ''
        '.h' = ''
        '.cpp' = ''
        '.cc' = ''
        '.cxx' = ''
        '.hpp' = ''
        '.hxx' = ''
        '.lua' = ''
        '.dart' = ''
        '.swift' = ''
        '.kt' = ''
        '.kts' = ''
        '.scala' = ''
        '.ex' = ''
        '.exs' = ''
        '.erl' = ''
        '.hrl' = ''
        '.hs' = ''
        '.r' = '󰟔'
        '.pl' = ''
        '.pm' = ''
        '.sql' = ''
        '.tf' = '󱁢'
        '.tfvars' = '󱁢'
        '.hcl' = '󱁢'
        '.bicep' = '󰠅'
        '.pem' = '󰄤'
        '.crt' = '󰄤'
        '.cer' = '󰄤'
        '.key' = ''
        '.pfx' = '󰄤'
        '.p12' = '󰄤'
        '.pub' = ''
        '.lock' = ''
        '.zip' = ''
        '.7z' = ''
        '.rar' = ''
        '.tar' = ''
        '.gz' = ''
        '.tgz' = ''
        '.bz2' = ''
        '.xz' = ''
        '.cab' = ''
        '.iso' = '󰋊'
        '.msi' = '󰏖'
        '.msix' = '󰏖'
        '.appx' = '󰏖'
        '.exe' = ''
        '.dll' = ''
        '.sys' = ''
        '.drv' = ''
        '.reg' = ''
        '.lnk' = ''
        '.url' = ''
        '.png' = '󰋩'
        '.jpg' = '󰋩'
        '.jpeg' = '󰋩'
        '.gif' = '󰋩'
        '.webp' = '󰋩'
        '.bmp' = '󰋩'
        '.ico' = '󰋩'
        '.tif' = '󰋩'
        '.tiff' = '󰋩'
        '.svg' = '󰜡'
        '.mp3' = ''
        '.wav' = ''
        '.flac' = ''
        '.ogg' = ''
        '.m4a' = ''
        '.wma' = ''
        '.mp4' = '󰕧'
        '.mkv' = '󰕧'
        '.mov' = '󰕧'
        '.avi' = '󰕧'
        '.webm' = '󰕧'
        '.wmv' = '󰕧'
        '.ttf' = ''
        '.otf' = ''
        '.woff' = ''
        '.woff2' = ''
        '.eot' = ''
    }

    DirectoryColorRules = @(
        @{ Pattern = '^\.git$'; Color = '#FF3F66' }
        @{ Pattern = '^\.github$'; Color = '#F2F6FF' }
        @{ Pattern = '^\.gitlab$'; Color = '#FF4D6D' }
        @{ Pattern = '^\.vscode'; Color = '#55A8FF' }
        @{ Pattern = '^\.idea$'; Color = '#FF4DFF' }
        @{ Pattern = '^\.cache$|^cache$|^caches$|^tmp$|^temp$'; Color = '#63F3FF' }
        @{ Pattern = '^\.config$|^config$|^configs$|^settings$|^preferences$'; Color = '#D600FF' }
        @{ Pattern = '^\.claude$'; Color = '#D600FF' }
        @{ Pattern = '^\.codex$'; Color = '#67FF9A' }
        @{ Pattern = '^\.copilot$'; Color = '#55A8FF' }
        @{ Pattern = '^\.crossnote$'; Color = '#FF4DFF' }
        @{ Pattern = '^\.ssh$|^ssh$|^keys$|^secrets?$|^certs?$|^certificates$|^ssl$|^tls$'; Color = '#FF4D6D' }
        @{ Pattern = '^\.aws$|^aws$'; Color = '#FFD166' }
        @{ Pattern = '^\.azure$|^azure$|^OneDrive$'; Color = '#55A8FF' }
        @{ Pattern = '^\.docker$|^docker$|^kubernetes$|^k8s$|^\.kube$'; Color = '#00E5FF' }
        @{ Pattern = '^\.terraform$|^terraform$'; Color = '#D600FF' }
        @{ Pattern = '^node_modules$|^\.npm$|^npm$|^\.pnpm-store$|^pnpm$|^\.yarn$|^yarn$|^\.nuget$|^nuget$|^packages$'; Color = '#FFD166' }
        @{ Pattern = '^\.venv$|^venv$|^env$|^virtualenv$'; Color = '#67FF9A' }
        @{ Pattern = '^bin$|^obj$|^dist$|^build$|^out$|^target$|^release$|^debug$'; Color = '#FF4DFF' }
        @{ Pattern = '^src$|^source$|^lib$|^libs$|^components$|^pages$|^app$'; Color = '#67FF9A' }
        @{ Pattern = '^public$|^static$|^assets$|^wwwroot$|^web$'; Color = '#63F3FF' }
        @{ Pattern = '^tests?$|^specs?$|^__tests__$|^coverage$'; Color = '#FF4DFF' }
        @{ Pattern = '^logs?$'; Color = '#FF4D6D' }
        @{ Pattern = '^data$|^database$|^db$|^migrations$|^ProgramData$'; Color = '#FFD166' }
        @{ Pattern = '^docs?$|^wiki$|^manuals?$|Desktop|Documents|Contacts'; Color = '#63F3FF' }
        @{ Pattern = 'Downloads|Favorites'; Color = '#FFD166' }
        @{ Pattern = 'Pictures'; Color = '#67FF9A' }
        @{ Pattern = 'Music|Links'; Color = '#D600FF' }
        @{ Pattern = 'Videos|Saved Games'; Color = '#FF4D6D' }
        @{ Pattern = 'Windows|System32|SysWOW64|WinSxS|Searches|Program Files|PerfLogs|inetpub|Recovery'; Color = '#55A8FF' }
        @{ Pattern = '3D Objects|Users|Public|Default|AppData|Local|LocalLow|Roaming'; Color = '#00E5FF' }
    )

    FileColorRules = @(
        @{ Pattern = '^README'; Color = '#63F3FF' }
        @{ Pattern = '^CHANGELOG|^HISTORY|^RELEASES'; Color = '#FFD166' }
        @{ Pattern = '^TODO|^NOTES'; Color = '#FF4DFF' }
        @{ Pattern = '^LICENSE'; Color = '#FFD166' }
        @{ Pattern = '^\.env'; Color = '#FF4D6D' }
        @{ Pattern = '^\.git'; Color = '#FF3F66' }
        @{ Pattern = '^\.editorconfig$'; Color = '#D600FF' }
        @{ Pattern = '^\.npmrc$|^\.yarnrc'; Color = '#FF3F66' }
        @{ Pattern = '^\.dockerignore$'; Color = '#00E5FF' }
        @{ Pattern = '^\.eslintrc'; Color = '#D600FF' }
        @{ Pattern = '^\.gitlab-ci\.yml$'; Color = '#FF4D6D' }
        @{ Pattern = '^\.github.*\.ya?ml$'; Color = '#F2F6FF' }
        @{ Pattern = '^azure-pipelines\.ya?ml$'; Color = '#55A8FF' }
        @{ Pattern = '^bitbucket-pipelines\.ya?ml$'; Color = '#55A8FF' }
        @{ Pattern = '^Jenkinsfile$'; Color = '#FF4D6D' }
        @{ Pattern = '^terraform\.'; Color = '#D600FF' }
        @{ Pattern = '^\.babelrc$|^babel\.config\.'; Color = '#FFD166' }
        @{ Pattern = '^angular\.json$'; Color = '#FF3F66' }
        @{ Pattern = '^composer\.(json|lock)$'; Color = '#D600FF' }
        @{ Pattern = '^docker-compose.*\.ya?ml$'; Color = '#00E5FF' }
        @{ Pattern = '^Dockerfile$|^Containerfile$'; Color = '#00E5FF' }
        @{ Pattern = '^eslint\.config\.'; Color = '#D600FF' }
        @{ Pattern = '^firebase\.json$'; Color = '#FFD166' }
        @{ Pattern = '^gruntfile\.(js|coffee|ts)$'; Color = '#FF4D6D' }
        @{ Pattern = '^gulpfile\.(js|coffee|ts)$'; Color = '#67FF9A' }
        @{ Pattern = '^jquery.*\.js$'; Color = '#55A8FF' }
        @{ Pattern = '^next\.config\.'; Color = '#55A8FF' }
        @{ Pattern = '^nuxt\.config\.'; Color = '#67FF9A' }
        @{ Pattern = '^package(-lock)?\.json$'; Color = '#67FF9A' }
        @{ Pattern = '^pnpm-(lock|workspace)\.ya?ml$'; Color = '#FF4DFF' }
        @{ Pattern = '^postcss\.config\.'; Color = '#63F3FF' }
        @{ Pattern = '^svelte\.config\.'; Color = '#FF4D6D' }
        @{ Pattern = '^tailwind\.config\.'; Color = '#63F3FF' }
        @{ Pattern = '^tsconfig\.json$'; Color = '#55A8FF' }
        @{ Pattern = '^vite\.config\.'; Color = '#FFD166' }
        @{ Pattern = '^vue\.config\.(js|ts)$'; Color = '#67FF9A' }
        @{ Pattern = '^webpack\.config\.'; Color = '#55A8FF' }
        @{ Pattern = '^yarn\.lock$'; Color = '#55A8FF' }
        @{ Pattern = '^requirements.*\.txt$|^pyproject\.toml$|^poetry\.lock$|^Pipfile$'; Color = '#67FF9A' }
        @{ Pattern = '^Gemfile$|^Gemfile\.lock$'; Color = '#FF4D6D' }
        @{ Pattern = '^go\.mod$|^go\.sum$'; Color = '#67FF9A' }
        @{ Pattern = '^Cargo\.toml$|^Cargo\.lock$'; Color = '#FF4D6D' }
        @{ Pattern = '^pom\.xml$|^build\.gradle'; Color = '#FF4D6D' }
        @{ Pattern = '^CMakeLists\.txt$|^Makefile$'; Color = '#FFD166' }
        @{ Pattern = '^appsettings.*\.json$|^global\.json$'; Color = '#D600FF' }
    )

    ExtensionColors = @{
        '.ps1' = '#63F3FF'
        '.psm1' = '#63F3FF'
        '.psd1' = '#63F3FF'
        '.ps1xml' = '#63F3FF'
        '.sh' = '#67FF9A'
        '.bash' = '#67FF9A'
        '.zsh' = '#67FF9A'
        '.fish' = '#67FF9A'
        '.bat' = '#55A8FF'
        '.cmd' = '#55A8FF'
        '.json' = '#FFD166'
        '.jsonc' = '#FFD166'
        '.yml' = '#FF4DFF'
        '.yaml' = '#FF4DFF'
        '.toml' = '#55A8FF'
        '.ini' = '#55A8FF'
        '.conf' = '#55A8FF'
        '.config' = '#55A8FF'
        '.properties' = '#55A8FF'
        '.props' = '#55A8FF'
        '.xml' = '#55A8FF'
        '.csv' = '#FFD166'
        '.tsv' = '#FFD166'
        '.db' = '#FFD166'
        '.sqlite' = '#FFD166'
        '.sqlite3' = '#FFD166'
        '.mdb' = '#FFD166'
        '.accdb' = '#FFD166'
        '.bak' = '#FF4DFF'
        '.md' = '#63F3FF'
        '.mdx' = '#63F3FF'
        '.markdown' = '#63F3FF'
        '.txt' = '#E6ECFF'
        '.log' = '#FF4D6D'
        '.pdf' = '#FF4D6D'
        '.doc' = '#55A8FF'
        '.docx' = '#55A8FF'
        '.dot' = '#55A8FF'
        '.dotx' = '#55A8FF'
        '.xls' = '#67FF9A'
        '.xlsx' = '#67FF9A'
        '.xlsm' = '#67FF9A'
        '.xltx' = '#67FF9A'
        '.ppt' = '#FF4D6D'
        '.pptx' = '#FF4D6D'
        '.ppsx' = '#FF4D6D'
        '.one' = '#D600FF'
        '.vsdx' = '#55A8FF'
        '.js' = '#FFD166'
        '.mjs' = '#FFD166'
        '.cjs' = '#FFD166'
        '.ts' = '#55A8FF'
        '.tsx' = '#55A8FF'
        '.jsx' = '#FFD166'
        '.vue' = '#67FF9A'
        '.svelte' = '#FF4D6D'
        '.astro' = '#FF4DFF'
        '.html' = '#FF4D6D'
        '.htm' = '#FF4D6D'
        '.css' = '#63F3FF'
        '.scss' = '#D600FF'
        '.sass' = '#D600FF'
        '.py' = '#67FF9A'
        '.ipynb' = '#FFD166'
        '.php' = '#D600FF'
        '.go' = '#67FF9A'
        '.rs' = '#FF4D6D'
        '.rb' = '#FF4D6D'
        '.java' = '#FF4D6D'
        '.cs' = '#55A8FF'
        '.csproj' = '#D600FF'
        '.fs' = '#55A8FF'
        '.fsx' = '#55A8FF'
        '.fsproj' = '#D600FF'
        '.vb' = '#55A8FF'
        '.vbproj' = '#D600FF'
        '.xaml' = '#55A8FF'
        '.razor' = '#D600FF'
        '.cshtml' = '#D600FF'
        '.sln' = '#D600FF'
        '.slnx' = '#D600FF'
        '.c' = '#55A8FF'
        '.h' = '#55A8FF'
        '.cpp' = '#55A8FF'
        '.cc' = '#55A8FF'
        '.cxx' = '#55A8FF'
        '.hpp' = '#55A8FF'
        '.hxx' = '#55A8FF'
        '.lua' = '#55A8FF'
        '.dart' = '#63F3FF'
        '.swift' = '#FF4D6D'
        '.kt' = '#FF4DFF'
        '.kts' = '#FF4DFF'
        '.scala' = '#FF3F66'
        '.ex' = '#D600FF'
        '.exs' = '#D600FF'
        '.erl' = '#FF4D6D'
        '.hrl' = '#FF4D6D'
        '.hs' = '#D600FF'
        '.r' = '#55A8FF'
        '.pl' = '#FF4DFF'
        '.pm' = '#FF4DFF'
        '.sql' = '#FFD166'
        '.tf' = '#D600FF'
        '.tfvars' = '#D600FF'
        '.hcl' = '#D600FF'
        '.bicep' = '#55A8FF'
        '.pem' = '#FF4D6D'
        '.crt' = '#FF4D6D'
        '.cer' = '#FF4D6D'
        '.key' = '#FF4D6D'
        '.pfx' = '#FF4D6D'
        '.p12' = '#FF4D6D'
        '.pub' = '#FFD166'
        '.lock' = '#FF4DFF'
        '.zip' = '#FF4DFF'
        '.7z' = '#FF4DFF'
        '.rar' = '#FF4DFF'
        '.tar' = '#FF4DFF'
        '.gz' = '#FF4DFF'
        '.tgz' = '#FF4DFF'
        '.bz2' = '#FF4DFF'
        '.xz' = '#FF4DFF'
        '.cab' = '#FF4DFF'
        '.iso' = '#FFD166'
        '.msi' = '#FFD166'
        '.msix' = '#FFD166'
        '.appx' = '#FFD166'
        '.exe' = '#FF3F66'
        '.dll' = '#FF3F66'
        '.sys' = '#FF3F66'
        '.drv' = '#FF3F66'
        '.reg' = '#D600FF'
        '.lnk' = '#63F3FF'
        '.url' = '#63F3FF'
        '.png' = '#67FF9A'
        '.jpg' = '#67FF9A'
        '.jpeg' = '#67FF9A'
        '.gif' = '#67FF9A'
        '.webp' = '#67FF9A'
        '.bmp' = '#67FF9A'
        '.ico' = '#67FF9A'
        '.tif' = '#67FF9A'
        '.tiff' = '#67FF9A'
        '.svg' = '#63F3FF'
        '.mp3' = '#D600FF'
        '.wav' = '#D600FF'
        '.flac' = '#D600FF'
        '.ogg' = '#D600FF'
        '.m4a' = '#D600FF'
        '.wma' = '#D600FF'
        '.mp4' = '#FF4D6D'
        '.mkv' = '#FF4D6D'
        '.mov' = '#FF4D6D'
        '.avi' = '#FF4D6D'
        '.webm' = '#FF4D6D'
        '.wmv' = '#FF4D6D'
        '.ttf' = '#FFD166'
        '.otf' = '#FFD166'
        '.woff' = '#FFD166'
        '.woff2' = '#FFD166'
        '.eot' = '#FFD166'
    }
}
