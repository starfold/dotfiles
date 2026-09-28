vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "nvim-treesitter" and ev.data.kind == "update" then
      if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" } })

-- nvim-treesitter only installs parsers; highlighting is builtin.
-- Compiling parsers needs the tree-sitter CLI (pacman -S tree-sitter-cli).
if vim.fn.executable("tree-sitter") == 1 then
  require("nvim-treesitter").install({
    "bash", "c", "c_sharp", "cpp", "css", "dart", "dockerfile", "html",
    "javascript", "json", "kotlin", "lua", "markdown", "markdown_inline",
    "python", "query", "regex", "rust", "toml", "tsx", "typescript", "vim",
    "vimdoc", "yaml", "zig",
  })
end

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
