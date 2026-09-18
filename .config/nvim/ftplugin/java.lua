local status, jdtls = pcall(require, 'jdtls')
if not status then
  vim.notify('nvim-jdtls is not installed', vim.log.levels.ERROR)
  return
end

local home = os.getenv 'HOME'
local workspace_dir = home .. '/.local/share/nvim/jdtls-workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local jdtls_path = vim.fn.stdpath 'data' .. '/mason/packages/jdtls'

if vim.fn.isdirectory(jdtls_path) == 0 then
  vim.notify('jdtls is not installed via Mason. Run :Mason and install jdtls', vim.log.levels.WARN)
  return
end

local launcher_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')

if launcher_jar == '' then
  vim.notify('Could not find jdtls launcher jar', vim.log.levels.ERROR)
  return
end

local system = 'linux'
if vim.fn.has 'mac' == 1 then
  system = 'mac'
elseif vim.fn.has 'win32' == 1 then
  system = 'win'
end

local config_dir = jdtls_path .. '/config_' .. system

if vim.fn.isdirectory(config_dir) == 0 then
  vim.notify('jdtls config directory not found: ' .. config_dir, vim.log.levels.ERROR)
  return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local blink_status, blink = pcall(require, 'blink.cmp')
if blink_status then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-javaagent:' .. jdtls_path .. '/lombok.jar',
    '-jar',
    launcher_jar,
    '-configuration',
    config_dir,
    '-data',
    workspace_dir,
  },

  root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew' } or require('jdtls.setup').find_root { 'pom.xml', 'build.gradle' },

  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
        runtimes = {
          -- Add your Java runtimes here if you have multiple versions
          -- {
          --   name = "JavaSE-11",
          --   path = "/usr/lib/jvm/java-11-openjdk/",
          -- },
          -- {
          --   name = "JavaSE-17",
          --   path = "/usr/lib/jvm/java-17-openjdk/",
          -- },
        },
      },
      maven = {
        downloadSources = true,
      },
      import = {
        maven = {
          enabled = true,
        },
        gradle = {
          enabled = true,
        },
      },
      project = {
        referencedLibraries = {},
        importOnFirstTimeStartup = 'automatic',
        importHint = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      format = {
        enabled = true,
        settings = {
          url = vim.fn.stdpath 'config' .. '/formatter/eclipse-java-google-style.xml',
          profile = 'GoogleStyle',
        },
      },
      signatureHelp = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          'org.hamcrest.MatcherAssert.assertThat',
          'org.hamcrest.Matchers.*',
          'org.hamcrest.CoreMatchers.*',
          'org.junit.jupiter.api.Assertions.*',
          'java.util.Objects.requireNonNull',
          'java.util.Objects.requireNonNullElse',
          'org.mockito.Mockito.*',
        },
        importOrder = {
          'java',
          'javax',
          'com',
          'org',
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
        },
        useBlocks = true,
      },
    },
  },

  flags = {
    allow_incremental_sync = true,
  },

  capabilities = capabilities,

  init_options = {
    bundles = {},
  },
}

jdtls.start_or_attach(config)

local opts = { noremap = true, silent = true, buffer = true }
vim.keymap.set('n', '<leader>co', jdtls.organize_imports, vim.tbl_extend('force', opts, { desc = 'Organize Imports' }))
vim.keymap.set('n', '<leader>cv', jdtls.extract_variable, vim.tbl_extend('force', opts, { desc = 'Extract Variable' }))
vim.keymap.set('v', '<leader>cv', [[<ESC><CMD>lua require('jdtls').extract_variable(true)<CR>]], vim.tbl_extend('force', opts, { desc = 'Extract Variable' }))
vim.keymap.set('n', '<leader>cc', jdtls.extract_constant, vim.tbl_extend('force', opts, { desc = 'Extract Constant' }))
vim.keymap.set('v', '<leader>cc', [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]], vim.tbl_extend('force', opts, { desc = 'Extract Constant' }))
vim.keymap.set('v', '<leader>cm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], vim.tbl_extend('force', opts, { desc = 'Extract Method' }))
vim.keymap.set('n', '<leader>cu', jdtls.update_project_config, vim.tbl_extend('force', opts, { desc = 'Update Project Config' }))
vim.keymap.set('n', '<leader>ct', jdtls.test_class, vim.tbl_extend('force', opts, { desc = 'Test Class' }))
vim.keymap.set('n', '<leader>cn', jdtls.test_nearest_method, vim.tbl_extend('force', opts, { desc = 'Test Nearest Method' }))
