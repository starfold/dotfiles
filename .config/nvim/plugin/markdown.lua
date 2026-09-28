vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local kind = ev.data.kind
    if ev.data.spec.name == "markdown-preview.nvim" and (kind == "install" or kind == "update") then
      vim.system({ "npm", "install" }, { cwd = ev.data.path .. "/app" })
    end
  end,
})

vim.g.mkdp_filetypes = { "markdown" }

vim.pack.add({ "https://github.com/iamcco/markdown-preview.nvim" })
