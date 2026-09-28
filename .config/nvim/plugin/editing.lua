vim.pack.add({
  "https://codeberg.org/andyg/leap.nvim",
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/eandrju/cellular-automaton.nvim",
})

-- leap
vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
vim.keymap.set("n", "S", "<Plug>(leap-from-window)")

require("nvim-autopairs").setup()

--useless plugin--
vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>")
