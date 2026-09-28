vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/rafamadriz/friendly-snippets",
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-flutter/flutter-tools.nvim",
})

-- Builtin LSP keymaps: K hover, grn rename, gra code action, grr references,
-- gri implementation, grt type definition, gO document symbols,
-- [d ]d next/prev diagnostic, <C-w>d diagnostic float, <C-s> signature help.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = { buffer = event.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format() end, opts)
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
  end,
})

-- completion: <CR> accept, <C-Space> open/docs, <C-n>/<C-p> select,
-- <C-b>/<C-f> scroll docs, <Tab>/<S-Tab> jump in snippets
require("blink.cmp").setup({
  keymap = { preset = "enter" },
  completion = { documentation = { auto_show = true } },
  sources = { default = { "lsp", "path", "snippets", "buffer" } },
})

-- Copilot via builtin inline completion. To use it:
-- :MasonInstall copilot-language-server, restart, then :LspCopilotSignIn
vim.lsp.inline_completion.enable()
vim.keymap.set("i", "<C-J>", function()
  if not vim.lsp.inline_completion.get() then
    return "<C-J>"
  end
end, { expr = true, desc = "Accept inline completion" })

-- mason-lspconfig enables every server installed through :Mason
require("mason").setup()

-- installed automatically on first start (Mason package names)
local ensure_installed = {
  "bash-language-server", "clangd", "css-lsp", "dockerfile-language-server",
  "eslint-lsp", "harper-ls", "html-lsp", "json-lsp", "kotlin-language-server",
  "lua-language-server", "markdown-oxide", "omnisharp", "pyright",
  "quick-lint-js", "rust-analyzer", "typescript-language-server", "zls",
  -- linters/formatters
  "alex", "clang-format", "cpplint",
}

local registry = require("mason-registry")
registry.refresh(vim.schedule_wrap(function()
  for _, name in ipairs(ensure_installed) do
    local pkg = registry.get_package(name)
    if not pkg:is_installed() and not pkg:is_installing() then
      pkg:install()
    end
  end
end))
require("mason-lspconfig").setup({
  automatic_enable = { exclude = { "pylsp" } }, -- pyright covers python
})

local kotlin_ls = vim.fn.stdpath("data") .. "/mason/packages/kotlin-language-server/server"

vim.lsp.config("kotlin_language_server", {
  cmd = {
    "/usr/lib/jvm/java-21-openjdk/bin/java",
    "-classpath",
    kotlin_ls .. "/lib/*",
    "org.javacs.kt.MainKt",
  },
  -- Force Java version
  cmd_env = {
    JAVA_HOME = "/usr/lib/jvm/java-21-openjdk",
    PATH = "/usr/lib/jvm/java-21-openjdk/bin:" .. vim.env.PATH,
  },
})

vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})

-- dart/flutter LSP is started by flutter-tools
require("flutter-tools").setup({})
