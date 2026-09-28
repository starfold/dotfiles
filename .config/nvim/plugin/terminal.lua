local function open_terminal()
  local width = math.floor(vim.o.columns / 2)
  local height = math.floor(vim.o.lines / 2)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(buf, true, {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = math.floor(height / 2),
    col = math.floor(width / 2),
  })
  vim.fn.jobstart(vim.o.shell, { term = true })
  vim.cmd.startinsert()
end

vim.api.nvim_create_user_command("OpenTerminal", open_terminal, {})
