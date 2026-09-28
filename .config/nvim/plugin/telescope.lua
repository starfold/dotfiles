vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
})

require("telescope").setup()

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.live_grep)
vim.keymap.set("n", "<leader>fb", builtin.buffers)
vim.keymap.set("n", "<leader>fh", builtin.help_tags)
vim.keymap.set("n", "<leader>fd", builtin.diagnostics)
vim.keymap.set("n", "<leader>fe", function()
  builtin.diagnostics({ severity = "ERROR" })
end)

-- project picker
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function scan_projects(base_dirs)
  local results = {}
  for _, base in ipairs(base_dirs) do
    local handle = io.popen("find " .. base .. " -maxdepth 3 -type d \\( -name .git -o -name .code -o -name '*.code-workspace' \\)")
    if handle then
      for dir in handle:lines() do
        local project = dir:gsub("/%.git$", "") -- strip trailing /.git
        table.insert(results, project)
      end
      handle:close()
    end
  end
  return results
end

local function projects_picker()
  local projects = scan_projects({ "~/" }) -- add your roots
  pickers.new({}, {
    prompt_title = "Projects",
    finder = finders.new_table(projects),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd("cd " .. selection[1])
        require("telescope.builtin").find_files({ cwd = selection[1] })
      end)
      return true
    end,
  }):find()
end

vim.keymap.set("n", "<leader>fp", projects_picker, { desc = "Find Project" })
